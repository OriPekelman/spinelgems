# Smoke for evt-transform 2.0.0.0
# The gem is a transformation-protocol framework (Write/Read/Copy) backed by a
# Reflect+Log runtime.  Both deps have deep native chains unavailable in the
# harness; we supply minimal stubs inline so the real Transform logic compiles
# under Spinel.  All Transform/* source is pulled via require_relative from the
# gem lib/ directory (relative paths work because the harness is placed in the
# gem root by the verify tool).

# ── Stub: Log ────────────────────────────────────────────────────────────────
# transform/log and write/read each call Log.get(self) → logger; we return a
# silent object that accepts any call with any args.
class Log
  def self.get(_subject)
    NullLogger.new
  end

  class NullLogger
    def trace(**_kw); end
    def debug(**_kw); end
    def info(**_kw);  end
    def warn(**_kw);  end
    def error(**_kw); end
  end
end

# ── Stub: Reflect ────────────────────────────────────────────────────────────
# The real evt-reflect is ~120 lines.  We re-implement only the surface that
# transform/*.rb actually calls (constant, constant?, call, get).
module Reflect
  Error = Class.new(RuntimeError)

  class Reflection
    attr_reader :subject, :target, :strict

    # Explicit def instead of alias so Spinel's alias resolver is not confused.
    def constant; target; end

    def initialize(subject, target, strict)
      @subject = subject
      @target  = target
      @strict  = strict
    end

    def subject_constant
      Reflect.constant(subject)
    end

    def self.build(subject, constant_name, strict: true, ancestors: nil)
      subject_constant = Reflect.constant(subject)
      target = Reflect.get_constant(subject_constant, constant_name, strict: strict)
      return nil if target.nil?
      new(subject, target, strict)
    end

    def call(method_name, arg = nil)
      unless target.respond_to?(method_name)
        raise Reflect::Error, "#{Reflect.constant(target).name} does not define method #{method_name}"
      end
      arg ||= subject
      target.send(method_name, arg)
    end

    def get(accessor_name, strict: nil, coerce_constant: nil)
      strict          = self.strict if strict.nil?
      coerce_constant = true        if coerce_constant.nil?
      unless target.respond_to?(accessor_name)
        raise Reflect::Error, "#{Reflect.constant(target).name} does not have accessor #{accessor_name}" if strict
        return nil
      end
      result = target.send(accessor_name)
      result = Reflect.constant(result) if coerce_constant
      self.class.new(subject, result, strict)
    end

    def target_accessor?(name, subj = nil)
      (subj || target).respond_to?(name)
    end
  end

  def self.call(subject, constant_name, strict: true, ancestors: nil)
    Reflection.build(subject, constant_name, strict: strict, ancestors: ancestors)
  end

  def self.constant(subject)
    [Module, Class].include?(subject.class) ? subject : subject.class
  end

  def self.constant?(subject_constant, constant_name, ancestors: nil)
    subject_constant.const_defined?(constant_name, false)
  end

  def self.get_constant(subject_constant, constant_name, strict: true, ancestors: nil)
    if constant?(subject_constant, constant_name)
      subject_constant.const_get(constant_name, false)
    elsif strict
      raise Reflect::Error, "Namespace #{constant_name} is not defined in #{subject_constant.name}"
    end
  end
end

# ── Load real Transform source via require_relative (gem root → lib/) ─────────
# The harness is placed at <gem-root>/__spinel_verify.rb so these paths resolve.
require_relative "lib/transform/transform"
require_relative "lib/transform/log"
require_relative "lib/transform/write"
require_relative "lib/transform/read"
require_relative "lib/transform/copy"

# ── Define a domain object with a Transformer sub-module ─────────────────────
# Mirrors Controls::Subject in the gem's own test controls.
module MyApp
  class Record
    attr_accessor :name, :score

    def initialize(name, score)
      @name  = name
      @score = score
    end

    def ==(other)
      other.is_a?(Record) && other.name == name && other.score == score
    end

    module Transformer
      def self.raw_data(instance)
        { name: instance.name, score: instance.score }
      end

      def self.instance(raw_data)
        MyApp::Record.new(raw_data[:name], raw_data[:score])
      end

      def self.csv
        CsvFormat
      end

      module CsvFormat
        def self.write(raw_data)
          "#{raw_data[:name]},#{raw_data[:score]}"
        end

        def self.read(text)
          parts = text.split(",", 2)
          { name: parts[0], score: Integer(parts[1]) }
        end
      end
    end
  end
end

module NoTransNS
  class Plain; end
end

rec = MyApp::Record.new("alice", 42)

# 1. Transform.transformer? — detects Transformer sub-module
puts Transform.transformer?(rec)                     # true
puts Transform.transformer?(NoTransNS::Plain.new)    # false

# 2. Transform.transformer_name — picks :Transformer over :Transform
puts Transform.transformer_name(MyApp::Record)       # Transformer

# 3. Transform::Write.raw_data — extracts plain data hash
raw = Transform::Write.raw_data(rec)
puts raw[:name]                                      # alice
puts raw[:score]                                     # 42

# 4. Transform::Write.call — serialise to :csv format
serialised = Transform::Write.call(rec, :csv)
puts serialised                                      # alice,42

# 5. Transform::Read.instance — reconstruct from raw data
rebuilt = Transform::Read.instance(raw, MyApp::Record)
puts rebuilt.name                                    # alice
puts rebuilt.score                                   # 42
puts rebuilt == rec                                  # true

# 6. Transform::Copy.call + Copy.copied?
copy = Transform::Copy.call(rec)
puts copy.equal?(rec)                                # false (different object)
puts Transform::Copy.copied?(rec, copy)              # true  (same raw_data)
puts Transform::Copy.copied?(rec, rec)               # false (same identity)
