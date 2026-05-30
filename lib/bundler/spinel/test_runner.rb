require "ripper"
require "tmpdir"

module Bundler
  module Spinel
    # Turn a gem's own minitest/test-unit suite into a Spinel-compilable smoke
    # (the `exercised-by-own-tests` signal, spinelgems#6). Two Spinel realities
    # force a build-time *translation* rather than running the framework as-is:
    #
    #   1. No reflection. Frameworks discover tests via `Module#instance_methods`,
    #      which Spinel returns 0 for. So we parse the test file with Ripper (in
    #      CRuby, at build) and emit an *explicit* runner — `T.new.test_a; ...`.
    #   2. No polymorphic methods. A shared `assert_equal(exp, act)` is called with
    #      heterogeneous types across tests; Spinel monomorphizes one C function and
    #      fails to type it. So each assertion is rewritten to `__t(<bool>)` — the
    #      comparison happens at the call site (locally typed), and `__t` only ever
    #      takes a bool.
    #
    # The result is run by the normal differential Verifier (CRuby vs Spinel, diff
    # the `TESTS pass=N fail=M` line) — a divergence is a caught miscompile.
    module TestRunner
      module_function

      # Locate a gem's test files (unit suites only — skip spec/ which is ~always
      # RSpec, out of reach). Returns [] if none.
      def test_files(dir)
        Dir[File.join(dir, "test", "**", "*.rb")].select do |f|
          b = File.basename(f)
          b.start_with?("test_") || b.end_with?("_test.rb")
        end.sort
      end

      # Generate one combined runner smoke from all of a gem's test files, or nil
      # if none parse into a recognizable test class.
      def generate_suite(dir)
        files = test_files(dir)
        return nil if files.empty?
        chunks = files.map { |f| chunk(File.read(f)) }.compact
        return nil if chunks.empty?

        out = +"$P = 0; $F = 0\n"
        out << "class Test; class Unit; class TestCase; end; end; end\n" # tolerate `< Test::Unit::TestCase`
        out << "module Minitest; class Test; end; end\n"
        chunks.each do |(body, klass, methods)|
          out << body << "\n"
          methods.each { |m| out << "begin; #{klass}.new.#{m}; rescue => e; $F += 1; end\n" }
        end
        out << %{puts("TESTS pass=" + $P.to_s + " fail=" + $F.to_s)\n}
        out
      end

      # one test file -> [rewritten_body, klass, methods] or nil
      def chunk(src)
        klass = test_class(src) or return nil
        methods = test_methods(src)
        return nil if methods.empty?
        [rewrite_assertions(strip_requires(src)), klass, methods]
      end

      def generate(test_file) # single-file convenience (kept for tests)
        c = chunk(File.read(test_file)) or return nil
        body, klass, methods = c
        out = +"$P = 0; $F = 0\nclass Test; class Unit; class TestCase; end; end; end\nmodule Minitest; class Test; end; end\n"
        out << body << "\n"
        methods.each { |m| out << "begin; #{klass}.new.#{m}; rescue => e; $F += 1; end\n" }
        out << %{puts("TESTS pass=" + $P.to_s + " fail=" + $F.to_s)\n}
        out
      end

      # --- Ripper-driven extraction ---------------------------------------

      def test_class(src)
        sexp = Ripper.sexp(src) or return nil
        found = nil
        walk = lambda do |n|
          return unless n.is_a?(Array)
          if n[0] == :class && (cp = const_name(n[1]))
            sup = const_name(n[2])
            found ||= cp if sup && (sup =~ /TestCase\z/ || sup =~ /Minitest::Test\z/ || sup == "Test")
          end
          n.each { |c| walk.call(c) if c.is_a?(Array) }
        end
        walk.call(sexp)
        found
      end

      def test_methods(src)
        sexp = Ripper.sexp(src) or return []
        names = []
        walk = lambda do |n|
          return unless n.is_a?(Array)
          if n[0] == :def && n[1].is_a?(Array) && n[1][0] == :@ident
            nm = n[1][1]
            names << nm if nm.start_with?("test_")
          end
          n.each { |c| walk.call(c) if c.is_a?(Array) }
        end
        walk.call(sexp)
        names.uniq
      end

      # const_ref / const_path_ref / var_ref -> "A::B" string
      def const_name(node)
        return nil unless node.is_a?(Array)
        case node[0]
        when :const_ref, :var_ref, :var_field then const_name(node[1])
        when :@const then node[1]
        when :const_path_ref, :const_path_field
          [const_name(node[1]), const_name(node[2])].compact.join("::")
        when :top_const_ref then const_name(node[1])
        end
      end

      # --- textual rewriting ----------------------------------------------

      def strip_requires(src)
        src.lines.reject { |l| l =~ /^\s*require(_relative)?\s/ }.join
      end

      # Rewrite single-line assertions to a monomorphic `__t(<bool>)`. Unhandled
      # forms are left as-is (they'll resolve to nothing or surface honestly).
      def rewrite_assertions(body)
        body.lines.map { |line| rewrite_line(line) }.join
      end

      def rewrite_line(line)
        m = line.match(/^(\s*)(assert_equal|assert_nil|assert|refute|refute_equal)\b[ (](.*)$/)
        return line unless m
        indent, kind, rest = m[1], m[2], m[3].rstrip
        rest = rest[0...-1] if rest.end_with?(")") && balanced?(rest[0...-1]) # drop a wrapping paren
        args = split_top(rest)
        expr =
          case kind
          when "assert_equal"  then args.size >= 2 ? "(#{args[0]}) == (#{args[1]})" : nil
          when "refute_equal"  then args.size >= 2 ? "(#{args[0]}) != (#{args[1]})" : nil
          when "assert_nil"    then args[0] ? "(#{args[0]}).nil?" : nil
          when "assert"        then args[0] ? "(#{args[0]})" : nil
          when "refute"        then args[0] ? "!(#{args[0]})" : nil
          end
        return line unless expr
        "#{indent}if #{expr} then $P += 1 else $F += 1 end\n"
      end

      # Split a top-level comma list, respecting (), [], {}, strings.
      def split_top(s)
        parts = []
        depth = 0
        buf = +""
        q = nil
        s.each_char do |c|
          if q
            buf << c
            q = nil if c == q
            next
          end
          case c
          when '"', "'" then q = c; buf << c
          when "(", "[", "{" then depth += 1; buf << c
          when ")", "]", "}" then depth -= 1; buf << c
          when ","
            if depth <= 0 then parts << buf.strip; buf = +""
            else buf << c end
          else buf << c
          end
        end
        parts << buf.strip unless buf.strip.empty?
        parts
      end

      def balanced?(s)
        depth = 0
        s.each_char { |c| depth += 1 if "([{".include?(c); depth -= 1 if ")]}".include?(c); return false if depth < 0 }
        depth == 0
      end
    end
  end
end
