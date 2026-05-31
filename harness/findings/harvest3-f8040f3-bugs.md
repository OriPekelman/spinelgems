# Harvest #3 @ f8040f3 — miscompile reproducers (29)

Authored by the 300-gem smoke workflow (wljatzxiu) over the highest-download
un-smoked loaded gems. Each verified via differential smoke. Smoke files:
harness/smoke/<gem>.rb.

## afm

```
diff:L6 cruby="BitstreamVeraSans-Roman\n" spinel="0\n"
```

AFM::Font#[] (the metadata hash accessor) returns 0 instead of the string value when compiled by Spinel, miscompiling hash lookup via @metadata[key].

## humanize

```
L1 cruby="zero\n" spinel="0\n"
```

Spinel emits `0` (the raw integer literal) instead of `"zero"` when humanizing the integer 0, indicating that the early-return branch `return locale_class::SUB_ONE_GROUPING[0] if number.zero?` in `Humanize.format` is miscompiled — either `number.zero?` or the constant array lookup returns incorrectly.

## google-adwords-api

```
L1 cruby="The AdWords API is no longer available.\n" spinel="AdwordsApi\n"
```

Spinel silently skips executing a `puts` statement inside a module body at module definition time, so the deprecation message printed by `module AdwordsApi; puts "..."; end` is emitted by CRuby but absent from the Spinel binary's output.

## ruby_dig

```
L1 cruby="42\n" spinel="\n"
```

Spinel miscompiles the RubyDig#dig method: a nested two-key dig call that should return 42 produces an empty string instead, indicating the recursive RubyDig-module dispatch through `value.dig(*rest)` is broken in the AOT output.

## fuzzy-string-match

```
L1 cruby="true\n" spinel="0\n"
```

Spinel miscompiles JaroWinklerPure#pure? so that the boolean `true` return value is emitted as integer 0 instead of `true`.

## i18n-country-translations

```
L1 cruby="I18nCountryTranslations\n" spinel="0\n"
```

Spinel miscompiles `Module#name` for a user-defined module, emitting `0` instead of the module's name string.

## url_regex

```
L1 cruby="Regexp\n" spinel="Integer\n"
```

Spinel infers the return type of UrlRegex.get as mrb_int instead of Regexp, so rx.class prints "Integer" instead of "Regexp" and the returned value is unusable as a regex.

## yoginth

```
L3 cruby="Yoginth\n" spinel="48\n"
```

Spinel returns an integer (48) instead of the module constant (Yoginth) for `Module#ancestors.first`, indicating that `ancestors` returns wrong values or `Array#first` misresolves the element when called on a module's ancestor list.

## n_plus_one_control

```
diff:L6 cruby="[2, 3]\n" spinel="nil\n"
```

Spinel returns nil for NPlusOneControl.default_scale_factors instead of [2, 3], because the module-level `self.default_scale_factors = [2, 3]` assignment (made in the top-level body of the entry file) is not preserved through AOT compilation.

## polylines

```
L1 cruby="_p~iF~ps|U_ulLnnqC_mqNvxq`@\n" spinel="0\n"
```

Polylines::Encoder.encode_points returns the correct encoded string under CRuby but Spinel emits `0` instead, indicating a miscompile in the multi-step bitwise encode pipeline (likely in the string join or chr/pack logic in Base).

## ey_config

```
L1 cruby="config/ey_services_config_local.yml\n" spinel="0\n"
```

Spinel emits 0 instead of the string return value of EY::Config::Local.config_path, indicating a miscompile of the class method defined on a nested class's singleton.

## to-bool

```
diff:L3 cruby="invalid value for `to_bool': 'maybe'\n" spinel="invalid value for `to_bool': '206338624477761'\n"
```

Spinel corrupts the interpolated string value inside an ArgumentError message constructed with string interpolation (#{self}), emitting a raw numeric pointer-like value instead of the actual string content.

## google-cloud-bigtable-admin-v2

```
L2 cruby="projects/my-project/instances/my-instance/appProfiles/my-profile\n" spinel="0\n"
```

After `include Google::Cloud::Bigtable::Admin::V2::BigtableInstanceAdmin::Paths` at top level, Spinel cannot resolve any of the included module's methods and emits 0 instead of the expected resource-path strings.

## google-cloud-bigtable-v2

```
L1 cruby="projects/my-project/instances/my-instance/tables/my-table\n" spinel="0\n"
```

Spinel emits 0 instead of the interpolated resource-path string returned by Paths#table_path (and likely all other path helpers), indicating a string-interpolation or method-return-value miscompile.

## stub_env

```
L2 cruby="true\n" spinel="false\n"
```

Spinel returns false for `StubEnv::Helpers.is_a?(Module)` where CRuby correctly returns true, indicating that nested module objects fail the `is_a?(Module)` type check in Spinel.

## php-serialize

```
L1 cruby="i:42;\n" spinel="0\n"
```

Spinel miscompiles PHP.serialize for Integer values, returning "0" instead of the correct PHP-format string "i:42;".

## pipetree

```
L5 cruby="true\n" spinel="false\n"
```

Spinel incorrectly returns false for `respond_to?(:class)` on an instance of a user-defined class (Pipetree), while CRuby correctly returns true.

## google-cloud-tasks-v2

```
L2 cruby="projects/my-project/locations/us-central1\n" spinel="0\n"
```

Spinel silently emits 0 instead of the interpolated string result from the `location_path` keyword-argument path-helper method defined in Google::Cloud::Tasks::V2::CloudTasks::Paths, indicating a miscompile in string-interpolation or keyword-argument method dispatch.

## package

```
L2 cruby="run\n" spinel="0\n"
```

Spinel miscompiles `UnboundMethod#name` (called via `Module#instance_method(:run).name`), returning `0` instead of the method name string `"run"`.

## i18n-timezones

```
L1 cruby="Module\n" spinel="Integer\n"
```

Spinel returns `Integer` instead of `Module` for `ActiveSupport.class` when the `ActiveSupport` constant is created as a module via class-reopen in the gem, indicating a miscompile in the `.class` method for module objects.

## google-cloud-ai_platform-v1

```
L1 cruby="projects/my-project/locations/us-central1/datasets/123\n" spinel="0\n"
```

Spinel miscompiles the keyword-argument path-builder methods in Google::Cloud::AIPlatform::V1::DatasetService::Paths, returning 0 instead of the expected interpolated resource-path string.

## random-word

```
L1 cruby="true\n" spinel="false\n"
```

Spinel incorrectly returns false for `RandomWord.is_a?(Module)` where CRuby returns true, indicating Spinel mishandles the Ruby object model rule that a Module is an instance of Module.

## google-cloud-recaptcha_enterprise-v1beta1

```
L2 cruby="projects/my-project/assessments/my-assessment\n" spinel="0\n"
```

Spinel miscompiles `assessment_path` (a keyword-args string-interpolation path helper) — it returns 0 instead of the expected resource string "projects/{project}/assessments/{assessment}".

## reretryable

```
L1 cruby="42\n" spinel="0\n"
```

Spinel miscompiles the `retryable` method so the block's return value is lost — a `retryable(tries:1) { 42 }` call returns 0 instead of 42.

## module_methods

```
L2 cruby="Hello from Person" spinel="unhandled exception: undefined method 'greeting' for class"
```

Spinel emits `0` for class-method calls added dynamically through a custom `included` hook (ModuleMethods::Extension pattern), causing the compiled binary to crash at runtime with `undefined method 'greeting' for class` instead of invoking the extended ClassMethods.

## google-cloud-security-private_ca-v1beta1

```
L2 cruby="projects/my-project/locations/us-east1/certificateAuthorities/my-ca/certificates/my-cert" spinel="unhandled exception: undefined method 'certificate_path' for class"
```

Spinel fails to handle `extend self` on a module (Paths): the path-helper methods (e.g. certificate_path, location_path) are compiled with `cannot resolve call … (emitting 0)` and throw `undefined method 'certificate_path' for class` at runtime, while CRuby executes them correctly and returns interpolated resource-path strings.

## rails-mermaid_erd

```
L2 cruby="6\n" spinel="0\n"
```

Spinel miscompiles a frozen Array constant (RailsMermaidErd::MermaidText::HEADER) and reports its length as 0 instead of 6, causing downstream MermaidText.build output to also diverge.

## deferrable

```
L3 cruby="deferred block 1\n" spinel="both\n"
```

Spinel misorders block execution when using `Deferrable#complete_deferred` after sequential `deferred` calls mixed with `now_and_later`, producing wrong output relative to CRuby.

## pid_cache

```
diff:L2 cruby="true\n" spinel="false\n"
```

Spinel fails to recognize singleton methods defined via `class << self` inside a runtime conditional block (`if Process.respond_to?(:_fork)`), causing `PIDCache.respond_to?(:pid)` and even `Process.respond_to?(:pid)` to incorrectly return `false` instead of `true`.

