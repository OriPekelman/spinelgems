# Harvest @ f8040f3 — miscompile reproducers (43)

Authored by the 300-gem smoke workflow (wommytvw8), each verified via differential
smoke (CRuby vs Spinel-compiled). Smoke files: harness/smoke/<gem>.rb.

## tty-cursor

```
L2 cruby="\"\\e[3A\"\n" spinel="\"\\x1B[3A\"\n"
```

Spinel's String#inspect renders the escape character (0x1B) as `\x1B` instead of CRuby's `\e`, causing divergent output for any string containing ESC.

## atomos

```
L1 cruby="ArgumentError: must provide either contents or a block\n" spinel="Atomos module exists: true\n"
```

Spinel does not raise ArgumentError when Atomos.atomic_write is called with both contents and a block (or neither), meaning the `unless nil? ^ nil?` XOR guard condition is not correctly compiled and the rescue block is never executed.

## libdatadog

```
L2 cruby="33.0.0.1.0\n" spinel="194450183112009.194450183112017.194450183112025194450183112033\n"
```

Spinel miscompiles the string-interpolated constant VERSION = "#{LIB_VERSION}.#{GEM_MAJOR_VERSION}.#{GEM_MINOR_VERSION}#{GEM_PRERELEASE_VERSION}" — numeric garbage is emitted instead of the correct version string "33.0.0.1.0".

## sd_notify

```
L10 cruby="nil\n" spinel="0\n"
```

SdNotify.notify returns nil in CRuby when NOTIFY_SOCKET is not set, but Spinel compiles it to return 0 instead.

## abbrev

```
L1 cruby="ca=>car\n" spinel="car=>205693808042361\n"
```

Spinel miscompiles Hash#[] (or string interpolation of hash values) inside the abbrev method, producing a raw integer object ID instead of the string value, and also yields wrong key ordering relative to CRuby.

## mime

```
L3 cruby="[\"pdf\"]\n" spinel="0\n"
```

Spinel emits `0` instead of the correct Array value when calling `.inspect` on the result of a Hash literal lookup (e.g., `MIME::ContentTypes::CONTENT_TYPES['application/pdf'].inspect` returns `0` instead of `["pdf"]`).

## libddprof

```
L1 cruby="0.6.0.1.0\n" spinel="193272419917401.193272419917409.193272419917417193272419917425\n"
```

Spinel miscompiles the VERSION constant (built via string interpolation of sub-constants) producing a garbled numeric string instead of "0.6.0.1.0".

## omnicontacts

```
L3 cruby="hello world\n" spinel="0\n"
```

Spinel miscompiles `normalize_name` — a method chaining `chomp!`, `squeeze!`, and `strip!` on a local string — returning `0` instead of the mutated string, indicating a bug in codegen for in-place String bang-method return values or the method's implicit return.

## to_dots

```
L1 cruby="[\"a.b.1\", \"a.c.2\", \"d.3\"]\n" spinel="[]\n"
```

Spinel returns an empty array from ToDots.to_dots instead of the populated result, indicating the recursive accumulator pattern (passing a mutable default array argument through recursive calls) is miscompiled.

## magic_frozen_string_literal

```
L2 cruby="frozen_string_literal: true\n" spinel="210248295084609: true\n"
```

Spinel miscompiles string interpolation of a frozen-string-literal constant: `MAGIC_COMMENT = "#{MAGIC_COMMENT_PREFIX}: true"` produces a numeric value (`210248295084609`) in place of the string `frozen_string_literal`, suggesting the `# frozen_string_literal: true` magic comment in the gem's own source causes Spinel to corrupt the string constant's value during AOT compilation.

## nido

```
L1 cruby="app\n" spinel="195026819125968\n"
```

When `puts` is called on a `Nido` instance (a String subclass), Spinel emits a raw integer (the object address) instead of the String content, indicating String-subclass instances are not treated as strings during `puts`/`to_s` dispatch.

## cacert

```
L3 cruby="true\n" spinel="false\n"
```

Cacert.share_dir.end_with?("share") returns false under Spinel but true under CRuby, indicating that File.expand_path (used in Cacert.share_dir) or the subsequent String#end_with? call produces a wrong result in the Spinel-compiled binary.

## static_literal_parser

```
L1 cruby=42 spinel=unhandled exception: Unsupported constants type: 221156236649168
```

Spinel miscompiles `case x when Array / when Hash` dispatch: a Hash argument is stored into an `mrb_int` local (C warning: "initialization of 'mrb_int' from 'sp_StrIntHash *' makes integer from pointer without a cast"), causing the `when Hash` branch to never match and the fallthrough `raise ArgumentError` to fire with the raw pointer value as the "type".

## round_robin_tournament

```
diff:L2 cruby="1v2,3v4\n" spinel="\n"
```

Spinel fails to resolve Integer#times (emitting 0), causing RoundRobinTournament.schedule to return an empty/wrong games array instead of the correct round-robin pairings.

## ensure_valid_encoding

```
diff:L2 cruby="??\n" spinel="\xFF\xFE\n"
```

Spinel fails to replace invalid UTF-8 bytes when `ensure_valid_encoding` is called with `invalid: :replace, replace: "?"`, returning the raw invalid byte sequence unchanged instead of substituting the replacement character, because `String#chars`, `Array#collect`, and `Array#join` are emitted as 0 due to unresolved type inference cascading from an ignored `require`.

## json_web_token

```
L1 cruby="1\n" spinel="0\n"
```

Spinel returns 0 instead of 1 when accessing a symbol-keyed hash value after JsonWebToken::Util.symbolize_keys converts string keys to symbols via transform_keys.

## damm

```
L4 cruby="4\n" spinel="0\n"
```

Spinel miscompiles the iterative TASQ table lookup in Damm.generate, returning 0 instead of the correct check digit 4 for input "572", likely due to incorrect handling of the each_char block with accumulated integer indexing.

## a_vs_an

```
L1 cruby="an\n" spinel="0\n"
```

Spinel miscompiles AVsAn.query, returning 0 (integer) instead of the correct article string "an", likely due to incorrect handling of the hash trie lookup or the conditional assignment of the :article key.

## jaccard

```
L1 cruby=0.75 spinel=unhandled exception: [1, 2, 3, 4] does not implement #&
```

Spinel's `respond_to?` incorrectly returns false for the `#&` (intersection) operator method on Array, causing Jaccard.coefficient to raise ArgumentError at runtime even though CRuby correctly returns true and proceeds to compute the coefficient.

## has_images

```
L4 cruby="[:has_images]\n" spinel="0\n"
```

Spinel miscompiles `Module#instance_methods(false)` on a nested module (`HasImages::ClassMethods`), returning `0` instead of the array `[:has_images]`.

## random_user_agent

```
L2 cruby="52.9\n" spinel="52\n"
```

Spinel truncates Float hash values to Integer when accessed via Hash#[], causing `Browser.new.statistics["Chrome"]` to return `52` instead of `52.9`.

## combination-extractor

```
diff:L2 cruby="fruit=\"apple\", city=\"NewYork\"\n" spinel="\n"
```

Spinel miscompiles Hash#each destructuring in a block with two block parameters (|k, v|): `combination.map { |k, v| "#{k}=#{v.inspect}" }` returns empty strings instead of formatted key-value pairs.

## twitter_username_extractor

```
L1 cruby="johndoe\n" spinel="0\n"
```

Spinel miscompiles `Regexp.last_match(1)` called after a successful `String#match`, emitting 0 instead of the capture group string, causing `TwitterUsernameExtractor.extract` to return 0 on every code path.

## date_format

```
L6 cruby="NA\n" spinel="\n"
```

Spinel miscompiles the `unless element.nil? || element == ""` guard in `DateFormat.change_to`: when `element` is `nil`, CRuby correctly returns `"NA"` but Spinel emits an empty string instead.

## quadkey

```
L4 cruby="512\n" spinel="0\n"
```

Spinel miscompiles `256 << precision` in Quadkey.map_size: with precision=1 CRuby returns 512 but Spinel emits 0, corrupting all downstream tile/quadkey computations.

## bitly-client

```
diff:L2 cruby="[:access_token, :access_token=, :api_version, :api_version=, :configure]\n" spinel="0\n"
```

Spinel miscompiles Module#instance_methods(false) — returns 0 instead of the array of method symbols defined on Bitly::Config.

## justified

```
diff:L4 cruby="true\n" spinel="false\n"
```

Spinel incorrectly returns false for `Justified.const_defined?(:Error)` when the `Error` module is defined within the `Justified` module, while CRuby correctly returns true.

## redcar-svnkit

```
L1 cruby="true\n" spinel="false\n"
```

Spinel incorrectly evaluates `String#end_with?("vendor/svnkit-1.3.5.jar")` as false when the receiver is the result of `File.expand_path`, whereas CRuby returns true.

## soar_authentication_cas

```
diff:L5 cruby="nil\n" spinel="{}\n"
```

SoarAuthenticationCas.configure(nil) returns nil in CRuby (early return on nil? check) but Spinel returns {} — Spinel miscompiles the `return nil if environment.nil? or environment['RACK_ENV'].nil?` guard, failing to short-circuit and instead returning an empty hash.

## redcar-jruby

```
L1 cruby="true\n" spinel="false\n"
```

Spinel miscompiles `File.expand_path("../../vendor/jruby-complete-1.6.4.jar", __FILE__)`: the returned path does not end with the expected filename, indicating `__FILE__` or `expand_path`'s relative-traversal is resolved incorrectly at compile/runtime.

## git_modified_lines

```
L6 cruby="2\n" spinel="0\n"
```

String#scan with a multiline extended regex (DIFF_HUNK_REGEX uses /x and anchors) returns 0 matches in Spinel when scanning a newline-containing string that CRuby correctly matches twice.

## require-me

```
L4 cruby="true\n" spinel="false\n"
```

Spinel evaluates `tracing == :on` as false even after `Require.tracing = :on` is set, indicating a defect in symbol equality comparison through module-level attr_accessor in Spinel's AOT compilation.

## flashatron

```
L4 cruby="[:render_flashes]\n" spinel="0\n"
```

Spinel miscompiles `Module#instance_methods(false).sort.inspect` on a module with one instance method, returning `0` instead of `[:render_flashes]`.

## time_aware_polyline

```
L1 cruby="3850000\n" spinel="0\n"
```

Spinel emits 0 for `Float#round(0)` (cannot resolve call to 'round' on poly — no concrete user-class arm), so `_get_coordinate_for_polyline(38.5)` returns 0 instead of 3850000.

## a9s_swift

```
L5 cruby="true\n" spinel="false\n"
```

Spinel incorrectly returns false for `Module#singleton_class.method_defined?(:version)` when the method is defined via `def self.version` on a module, whereas CRuby returns true.

## mack-paths

```
L1 cruby="/myapp/public/\n" spinel="/myapp/public\n"
```

File.join with a trailing empty array argument (from an unpopulated splat *files) produces a trailing slash in CRuby but not in Spinel, causing Mack::Paths path helpers to return divergent strings.

## vindicator

```
L1 cruby="true\n" spinel="false\n"
```

Spinel miscompiles Vindicator.valid_vin? returning false for a known-valid VIN ('1GNEC233X9R191831') where CRuby returns true, indicating a bug in the check-digit arithmetic (likely in integer modulo, string/integer comparison, or hash-keyed alpha-value lookup).

## sms_sender_tester

```
L1 cruby="Hash\n" spinel="\n"
```

Spinel emits an empty string instead of the class name "Hash" when calling `.class` on a Hash literal returned from a method, indicating a miscompile in `puts result.class` where the class name resolution produces no output.

## color_contrast_calc

```
diff:L1 cruby="1.0\n" spinel="0\n"
```

Spinel miscompiles `ColorContrastCalc::Checker.relative_luminance([255, 255, 255])`, returning `0` instead of `1.0`, indicating a bug in AOT-compiled floating-point arithmetic for the WCAG luminance formula.

## bychar

```
diff:L3 cruby="a\n" spinel="0\n"
```

Spinel's String#[] (single-integer-index form) returns an Integer instead of a one-character String, causing ReaderStrbuf#read_one_char to emit byte values (e.g. 97) instead of characters (e.g. "a").

## pdftohtml

```
L3 cruby="1\n" spinel="0\n"
```

Spinel reports arity 0 for `Pdftohtml.method(:convert)` where CRuby correctly returns 1 for a singleton method defined with one required parameter.

## tasks

```
L5 cruby="1\n" spinel="0\n"
```

Spinel reports `Tasks.instance_method(:kill_children).arity` as 0 instead of the correct 1, indicating that `UnboundMethod#arity` mis-counts required parameters for methods defined with `module_function`.

## hache

```
L1 cruby="Hello &lt;World&gt; &amp; &#39;everyone&#39; &#34;quoted&#34;\n" spinel="\n"
```

Spinel fails to resolve `String#to_str` (emitting 0) and subsequently `gsub` on the resulting int, causing `Hache.h` to silently return 0 instead of the HTML-escaped string.

