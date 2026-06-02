# Harvest #4 @ 95557f5 — reproducers

## Codegen (17)

### nanaimo
```
/tmp/spinel_out.1SqP2O/out.c:58:5: error: unknown type name 'sp_Nanaimo_String'; did you mean 'sp_Nanaimo_Error'?
```
Spinel emits C type variable declarations (sp_Nanaimo_String, sp_Nanaimo_QuotedString, sp_Nanaimo_Array, sp_Nanaimo_Dictionary) for classes loaded via require_relative but never generates their struct/type definitions, likely due to a name-resolution conflict with Ruby built-in names (String, Array) inside a user module scope, causing C compilation failure.

### rotp
```
/tmp/spinel_out.dv72Gc/out.c:73:33: error: 'ROTP_Base32_SHIFT' undeclared (first use in this function)
/tmp/spinel_out.dv72Gc/out.c:74:33: error: 'ROTP_Base32_MASK' undeclared (first use in this function)
```
Spinel emits C symbol references for integer constants defined in ignored-require files (ROTP_Base32_SHIFT, ROTP_Base32_MASK) without declaring them, causing C compilation to fail with 'undeclared identifier' errors.

### polyglot
```
/tmp/spinel_out.TdAgFT/out.c:191:18: warning: passing argument 1 of 'sp_raise' from incompatible pointer type; sp_raise(self->iv_le) passes sp_Exception* where const char* expected; spinel: C compilation failed
```
Spinel codegen for NestedLoadError#reraise emits `sp_raise(self->iv_le)` passing an `sp_Exception*` (the stored exception object) as a `const char*` message string, causing a C compilation error instead of re-raising the exception.

### cocoapods-search
```
/tmp/spinel_out.yhzaZr/out.c:21:33: error: 'CocoapodsSearch_VERSION' undeclared (first use in this function)
```
Spinel ignores `require 'cocoapods-search/gem_version'` (non-relative path) so the constant is never defined, but then emits C code referencing `CocoapodsSearch_VERSION` without a declaration, causing a C compiler error.

### simple_po_parser
```
/tmp/spinel_out.8GrotY/out.c:30:33: error: 'SimplePoParser_VERSION' undeclared (first use in this function)
```
Spinel ignores all require_relative sub-files within a gem's lib (simple_po_parser/{error,parser,tokenizer,version}.rb), causing the entire SimplePoParser module to be undefined in the generated C code and failing compilation with 'SimplePoParser_VERSION' undeclared.

### metaclass
```
/tmp/spinel_out.h4Ssw4/out.c:28:33: error: 'Metaclass_VERSION' undeclared (first use in this function)
```
When `require "metaclass/version"` is ignored due to Spinel's load-path limit, Spinel still emits `Metaclass_VERSION` as a bare C identifier in the generated out.c, producing an "undeclared identifier" C compiler error instead of a graceful runtime constant-missing error.

### fastlane-sirp
```
/tmp/spinel_out.1izYfS/out.c:23:33: error: 'SIRP_VERSION' undeclared (first use in this function)
```
When a require for a file defining a module constant is ignored (no X.rb), Spinel emits the constant as a bare C identifier (SIRP_VERSION) without declaring it, causing a C compilation error instead of gracefully emitting 0 or raising.

### pdfkit
```
/tmp/spinel_out.NWWJKp/out.c:17:33: error: 'PDFKit_VERSION' undeclared (first use in this function)
```
When `require 'pdfkit/version'` is ignored (loadpath limit), Spinel emits a C reference to the undeclared variable `PDFKit_VERSION` for the constant `PDFKit::VERSION` instead of handling the undefined constant gracefully, causing a C compilation failure.

### erb_lint
```
/tmp/spinel_out.5Ze8su/out.c:17:5: error: unknown type name 'sp_ERBLint_Stats', /tmp/spinel_out.5Ze8su/out.c:19:5: error: unknown type name 'sp_ERBLint_Stats'
```
Spinel generates an invalid C type name `sp_ERBLint_Stats` for the `ERBLint::Stats` class defined inside a module namespace, causing a C compile error when instantiating it.

### pagerduty
```
/tmp/spinel_out.dpb3OA/out.c:150:33: error: 'Pagerduty_VERSION' undeclared (first use in this function)
/tmp/spinel_out.dpb3OA/out.c:153:47: error: incompatible type for argument 1 of 'sp_box_int'
```
Spinel emits a C reference to `Pagerduty_VERSION` even after warning that `require "pagerduty/version"` is ignored, causing an `undeclared` C compiler error when accessing the `Pagerduty::VERSION` constant.

### puppet-syntax
```
out.c:78:20: error: invalid initializer (sp_RbVal _t5 = cst_PuppetSyntax_exclude_paths)
out.c:82:56: error: incompatible type for argument 1 of 'sp_poly_inspect' — sp_StrArray * passed where sp_RbVal expected
```
Spinel generates invalid C when compiling a module that sets array-typed module instance variables (@ivar = [...]) and exposes them via attr_accessor — the emitted code assigns sp_StrArray* to sp_RbVal variables and passes mrb_int/sp_StrArray* to sp_poly_inspect which expects sp_RbVal.

### java-properties
```
/tmp/spinel_out.EQ01sl/out.c:229:33: error: 'JavaProperties_VERSION' undeclared (first use in this function)
```
When a constant is defined in a file loaded via a non-relative `require` that Spinel ignores, Spinel emits the constant name as an undeclared C identifier (e.g. `JavaProperties_VERSION`) instead of applying the same "emitting 0" safe-fallback it applies to unresolved method calls, causing a C compilation failure.

### cloud_events
```
/tmp/spinel_out.DfQm1Y/out.c:30:5: error: unknown type name 'sp_CloudEvents_ContentType'
```
Spinel ignores the bare `require "cloud_events/content_type"` in the gem's entrypoint but still emits a C local-variable declaration using the type `sp_CloudEvents_ContentType`, which is never defined, causing a C compilation failure.

### repost
```
/tmp/spinel_out.oz0SHL/out.c:95:33: error: 'Repost_VERSION' undeclared (first use in this function)
```
Spinel emits a C reference to `Repost_VERSION` in `main()` even though the `require "repost/version"` that defines it was ignored (printed as a warning), causing a C compilation failure with "undeclared identifier" on ordinary Ruby code that accesses the constant.

### angularjs-rails
```
/tmp/spinel_out.VUWtsr/out.c:21:33: error: 'AngularJS_Rails_VERSION' undeclared (first use in this function), /tmp/spinel_out.VUWtsr/out.c:22:33: error: 'AngularJS_Rails_UNSTABLE_VERSION' undeclared (first use in this function)
```
Spinel fails to emit C declarations for string constants defined inside nested modules (AngularJS::Rails::VERSION and UNSTABLE_VERSION), leaving them undeclared in the generated C output.

### quantile
```
/tmp/spinel_out.NCS98s/out.c:486:20: error: incompatible types when assigning to type 'mrb_int' {aka 'long int'} from type 'sp_RbVal' | /tmp/spinel_out.NCS98s/out.c:631:38: error: incompatible type for argument 1 of 'sp_Quantile_Estimator_new'
```
Spinel incorrectly infers an integer-array type for the splat argument to Estimator.new(*invariants) and mis-types a Float delta result as mrb_int in the generated C for Estimator#invariant, producing two C compiler errors that prevent compilation.

### url_safe_base64
```
/tmp/spinel_out.CSemkQ/out.c:37:33: error: 'UrlSafeBase64_VERSION' undeclared (first use in this function)
```
When `require "url_safe_base64/version"` is silently ignored, Spinel still emits a C reference to `UrlSafeBase64_VERSION` without a declaration, causing the C compiler to fail with "undeclared identifier".

## Miscompile (3)

### shellany
```
L3 cruby="true\n" spinel="false\n"
```
Spinel returns false for `Shellany.respond_to?(:module_eval)` where CRuby correctly returns true, indicating Spinel does not expose Module-level methods (like module_eval) through respond_to? for user-defined modules.

### terminal-notifier
```
L2 cruby=":test\n" spinel="\"Test\"\n"
```
Spinel emits 0 for unresolved `length` and `downcase` calls on a polymorphic receiver, causing `notify_result` to skip the symbol-conversion branch and return the original string instead of the expected symbol (e.g. `"Test"` instead of `:test`).

### minitest-ci
```
L1 cruby="test/reports\n" spinel="0\n"
```
Spinel miscompiles `attr_accessor`-backed class-level attribute `Minitest::Ci.report_dir` (set to `'test/reports'` at class body evaluation time), emitting `0` instead of the string value.

