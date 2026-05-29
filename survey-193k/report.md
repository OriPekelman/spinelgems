# Spinel gem-compatibility survey

- engine rev: `git:a03bb49+dirty/aarch64-linux-gnu`
- gems surveyed: **189742**
- compatible (clean+verified): **35291** (18.6%)  ·  risky: 12511  ·  rejected: 141940

> Catalog `verified` count is **28**. The bar is **full-surface** verification
> (`verify --full`: every `lib/` file force-required, no `autoload` masking, no
> missing-dependency rescue, behaviour smoke matches CRuby). An earlier pass reported
> 57/77 on an entrypoint-only smoke, but the qdrant-ruby spike (spinelgems#4) showed a
> constant/VERSION-only smoke can pass while the gem's real code stays behind
> `autoload`/plain-`require` and never compiles; re-auditing all 237 smokes under
> `--full` cut it to 16 self-contained gems.
>
> Then five of our filed module/reflection bugs landed on `matz/spinel` (8ec9a3b,
> e47419b — `is_a?(Module)`, `.class`, `respond_to?` on singleton methods/accessors,
> nested `::` naming). Rebuilding at `git:8d88ebe` and re-auditing: **30** gems now
> pass full-surface (14 graduated). Two of those 30 (`pr_geohash`, `strings-ansi`)
> still show `rejected` in the catalog because they were rejected at the dominant
> survey rev `a03bb49` and sticky-rejected is rev-scoped — they'll flip on a full
> re-survey at the newer rev. The corpus aggregate above is the `a03bb49` static
> survey and is unchanged.

## Harness behaviour pass — `git:8adbd7b` (2026-05-29)

A targeted differential CRuby-vs-Spinel pass over the **546** most-popular
clean, dependency-light gems that load require-only. Each got a hand-driven
behaviour smoke (authored by a per-gem agent, see `harness/smoke/`). Outcomes
at engine rev `git:8adbd7b+dirty`:

| outcome | count |
|---|---|
| **verified** (smoke matches CRuby) | **57** |
| miscompile bug (runs, wrong output) | 77 |
| codegen bug (C-compile error, ordinary Ruby) | 85 |
| load-path limit (known no-load-path constraint, not a bug) | 283 |
| risky / no testable surface | 44 |

The 57 above is the **entrypoint-only** smoke pass. A follow-up full-surface audit
(`verify --full` over all 237 smokes) cut this to **16** genuinely-verified gems —
see the note at the top. Only `verify-full` verdicts now earn the catalog ★; the
others were demoted. The bug findings below are recorded in `compat.jsonl` at
`8adbd7b` and feed the matz/spinel issue queue; they do not flip the
(a03bb49-dominant) catalog, which is rev-scoped.

### Newly behaviour-verified (57)

`activerecord-import-sqlserver`, `amakanize`, `bigkeeper`, `bundler_install_stats`, `cloudapp`, `cloudwalk_handshake`, `cocoapods-dependencies`, `cocoapods-no-dev-schemes`, `cocoapods-prune-localizations`, `codemonitor`, `crunchbase-ruby-library`, `danger-SwiftInfo`, `danger-apple_swift_format`, `danger-duplicate_localizable_strings`, `danger-findbugs`, `danger-iblinter`, `danger-lgtm`, `danger-logging_lint`, `danger-pmd`, `danger-pronto`, `danger-reek`, `danger-shellcheck`, `danger-shroud`, `danger-slack`, `danger-slather`, `danger-the_coding_love`, `danger-undercover`, `danger-xcodebuild`, `danger-yamlint`, `flipper-activerecord3dot2`, `glicko2`, `grape-jsonapi`, `gtk2passwordapp`, `haddock`, `hello-world`, `href_protocol`, `innodb_ruby`, `knife-cleanup`, `knife-inspect`, `metric_fu-roodi`, `mime_builder`, `mime_type_list`, `mod11`, `qawolf-socket-rubygem`, `qdrant-ruby`, `remote_syslog-gitlab`, `rggen`, `ringcentral_sdk`, `ruby-recaptcha`, `ruby_version`, `salamtak`, `tagrity`, `test`, `testrbl`, `trusty-rad-social-extension`, `yarn_lock_parser`, `zerobounce-sdk`

### Bug findings (162) — candidate matz/spinel issues

Grouped by apparent root cause. Each gem has a minimal-ish reproducer smoke.

- **other** (96): `fustigit`, `rox-rollout`, `ftpfxp`, `whenever-elasticbeanstalk`, `sexpistol`, `validate-website`, `call_with_params`, `facebook_username_extractor`, `tradsim`, `minimal_pipeline`, `rubysl-expect`, `sauce_platforms`, …
- **Module#is_a?(Module) returns false** (21): `activerecord-mysql2-adapter`, `cocoapods-clean`, `slimcop`, `ar_mysql_flexmaster`, `error_page_assets`, `testflight`, `ember-data-factory-guy`, `marathon_deploy`, `rspec_chunked`, `hudson`, `ignore_this_gem`, `origin-selectable_ext`, …
- **nested class name uses _ not ::** (10): `prop`, `ae_network_connection_exception`, `webpurify`, `slackened`, `delayed_task`, `jakal`, `Dhalang`, `md2man`, `kiqstand`, `cohere-ruby`
- **respond_to? on self.-method / class<<self false** (10): `tinnef`, `clarity_tracking_number`, `redis_dedupe`, `samson_secret_puller`, `cleantalk`, `wrgem`, `strip_params`, `gitup`, `awes_cli`, `activerecord-fast-import`
- **frozen-string / frozen-array mishandling** (7): `pygmentize`, `schema_registry`, `gitlab-development-kit`, `cocoapods-try-release-fix`, `scalpel`, `cfn_manage`, `story_branch`
- **Module#constants wrong / empty** (6): `stigg-api-client`, `cocoapods-amicable`, `heroku_deploy`, `hashy_db`, `notifier`, `pg_hash_func`
- **string interpolation collapses to first arg** (5): `rfc-822`, `companies-house-rest`, `retry_block`, `recent_ruby`, `stemmify`
- **.class on a Module returns Integer** (2): `jar_wrapper`, `gem-helper`
- **String#[](offset,len) returns 0** (2): `picky-statistics`, `n_gram`
- **nil constant treated as integer 0** (1): `taglib-ruby`
- **Struct.members returns 0** (1): `danger-periphery`
- **Hash[:sym] from module method returns 0** (1): `youtube_addy`

Full per-gem diffs and one-line defect summaries: see the workflow result and the kept smokes.


## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 27085 | `new` |
| 20339 | `[]` |
| 18221 | `no-entrypoint` |
| 7766 | `parse` |
| 6262 | `expand_path` |
| 6147 | `include?` |
| 5491 | `empty?` |
| 5429 | `unshift` |
| 5320 | `join` |
| 4275 | `extend` |
| 4134 | `first` |
| 3977 | `include` |
| 3959 | `length` |
| 3694 | `split` |
| 3584 | `call` |
| 3171 | `delete` |
| 2991 | `load` |
| 2943 | `get` |
| 2688 | `merge` |
| 2678 | `body` |
| 2626 | `hard:Thread.new` |
| 2479 | `open` |
| 2410 | `gsub` |
| 2201 | `glob` |
| 2180 | `keys` |
| 2113 | `read` |
| 2032 | `dup` |
| 1981 | `to_sym` |
| 1904 | `exists?` |
| 1835 | `find` |
| 1810 | `name` |
| 1790 | `each` |
| 1768 | `sort` |
| 1738 | `strip` |
| 1693 | `size` |
| 1654 | `code` |
| 1631 | `collect` |
| 1614 | `start` |
| 1607 | `any?` |
| 1589 | `match` |
| 1577 | `to_json` |
| 1551 | `post` |
| 1547 | `mkdir_p` |
| 1527 | `load_file` |
| 1520 | `info` |
| 1520 | `to_a` |
| 1511 | `merge!` |
| 1491 | `close` |
| 1445 | `config` |
| 1440 | `shift` |
| 1404 | `register` |
| 1355 | `puts` |
| 1353 | `setup` |
| 1324 | `respond_to?` |
| 1310 | `downcase` |
| 1294 | `last` |
| 1282 | `fetch` |
| 1274 | `request` |
| 1269 | `write` |
| 1268 | `logger` |
| 1255 | `const_get` |
| 1255 | `path` |
| 1250 | `hard:Mutex.new` |
| 1240 | `key?` |
| 1232 | `URI` |
| 1194 | `debug` |
| 1180 | `uniq` |
| 1178 | `use_ssl=` |
| 1176 | `instance` |
| 1171 | `count` |
| 1167 | `hexdigest` |
| 1135 | `push` |
| 1107 | `reverse` |
| 1085 | `instance_variable_set` |
| 1077 | `to_h` |
| 1069 | `Array` |
| 1056 | `text` |
| 1043 | `HTML` |
| 1040 | `error` |
| 1028 | `compact` |
| 1022 | `with_index` |
| 1008 | `run` |
| 987 | `index` |
| 983 | `root` |
| 980 | `has_key?` |
| 946 | `css` |
| 943 | `gem` |
| 927 | `scan` |
| 914 | `to_s` |
| 899 | `exist?` |
| 889 | `body=` |
| 887 | `values` |
| 884 | `message` |
| 880 | `blank?` |
| 876 | `level=` |
| 874 | `strftime` |
| 870 | `require_relative` |
| 861 | `dump` |
| 861 | `options` |
| 861 | `status` |
| 856 | `flatten` |
| 856 | `warn` |
| 832 | `present?` |
| 822 | `update` |
| 806 | `sort_by` |
| 800 | `gsub!` |
| 787 | `configure` |
| 780 | `value` |
| 766 | `fail` |
| 739 | `generate` |
| 732 | `escape` |
| 719 | `start_with?` |
| 717 | `on_load` |
| 711 | `success?` |
| 709 | `map!` |
| 705 | `execute` |
| 704 | `sub` |
| 701 | `current` |
| 697 | `gets` |
| 691 | `clear` |
| 683 | `create` |
| 681 | `clone` |
| 680 | `configuration` |
| 675 | `add` |
| 669 | `all?` |
| 661 | `mkdir` |
| 648 | `env` |
| 633 | `headers` |
| 630 | `pop` |
| 629 | `result` |
| 622 | `chdir` |
| 608 | `upcase` |
| 598 | `const_defined?` |
| 597 | `readlines` |
| 595 | `delete_if` |
| 587 | `map` |
| 586 | `id` |
| 585 | `===` |
| 578 | `for_gem` |
| 573 | `xpath` |
| 572 | `encode` |
| 566 | `host` |
| 557 | `to_f` |
| 555 | `all` |
| 555 | `children` |
| 552 | `[]=` |
| 542 | `chomp` |
| 542 | `instance_variable_get` |
| 535 | `search` |
| 529 | `slice` |
| 523 | `query=` |
| 523 | `version` |
| 515 | `scheme` |
| 514 | `exit` |
| 513 | `constantize` |
| 513 | `to_yaml` |
| 509 | `pretty_generate` |
| 502 | `type` |
| 486 | `verify_mode=` |
| 485 | `synchronize` |
| 483 | `render` |
| 477 | `unpack` |
| 474 | `get_response` |
| 473 | `each_line` |
| 469 | `connect` |
| 468 | `concat` |
| 467 | `detect` |
| 466 | `min` |
| 456 | `max` |
| 453 | `red` |
| 451 | `attributes` |
| 450 | `add_identifier` |
| 450 | `each_with_index` |
| 449 | `prepend` |
| 448 | `parent` |
| 446 | `match?` |
| 443 | `XML` |
| 427 | `read_timeout=` |
| 426 | `set` |
| 423 | `load_locales` |
| 418 | `encode64` |
| 401 | `print` |
| 399 | `hash` |
| 396 | `build` |
| 394 | `green` |
| 392 | `each_key` |
| 390 | `save` |
| 388 | `connection` |
| 383 | `strict_encode64` |
| 377 | `application` |
| 376 | `data` |
| 376 | `end_with?` |
| 376 | `object_id` |
| 375 | `foreach` |
| 374 | `round` |
| 373 | `instance_variables` |
| 372 | `query` |
| 371 | `timeout` |
| 366 | `transform_keys` |
| 365 | `entries` |

Showing 200 of **54132** distinct candidate calls (505041 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 505041 | candidate core/stdlib calls (above) |
| 128306 | metaprogramming / reflection — out of scope |
| 642035 | no load path: `require` + `needs:` — probe limitation |
| 15040 | analyzer failed / timed out — compiler hardening |
| 3012 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 63802 | `unresolved:require` | loadpath |
| 34775 | `send` | metaprog |
| 27085 | `unresolved:new` | call |
| 20339 | `unresolved:[]` | call |
| 18221 | `no-entrypoint` | call |
| 17654 | `define_method` | metaprog |
| 16384 | `class_eval` | metaprog |
| 15725 | `method_missing` | metaprog |
| 14697 | `analyze-failed` | robustness |
| 12278 | `instance_eval` | metaprog |
| 10872 | `needs:json` | loadpath |
| 7766 | `unresolved:parse` | call |
| 6424 | `binding` | metaprog |
| 6262 | `unresolved:expand_path` | call |
| 6147 | `unresolved:include?` | call |
| 5574 | `eval` | metaprog |
| 5491 | `unresolved:empty?` | call |
| 5429 | `unresolved:unshift` | call |
| 5320 | `unresolved:join` | call |
| 5130 | `needs:yaml` | loadpath |
| 4885 | `public_send` | metaprog |
| 4297 | `needs:uri` | loadpath |
| 4275 | `unresolved:extend` | call |
| 4134 | `unresolved:first` | call |
| 4099 | `needs:net/http` | loadpath |
| 3977 | `unresolved:include` | call |
| 3959 | `unresolved:length` | call |
| 3755 | `needs:fileutils` | loadpath |
| 3694 | `unresolved:split` | call |
| 3584 | `unresolved:call` | call |
| 3472 | `unresolved:send` | metaprog |
| 3367 | `needs:logger` | loadpath |
| 3171 | `unresolved:delete` | call |
| 3154 | `needs:rubygems` | loadpath |
| 3068 | `needs:nokogiri` | loadpath |
| 3012 | `c-extension` | cext |
| 2991 | `unresolved:load` | call |
| 2943 | `unresolved:get` | call |
| 2834 | `respond_to_missing` | metaprog |
| 2688 | `unresolved:merge` | call |
| 2678 | `unresolved:body` | call |
| 2626 | `hard:Thread.new` | call |
| 2543 | `needs:open-uri` | loadpath |
| 2479 | `unresolved:open` | call |
| 2410 | `unresolved:gsub` | call |
| 2274 | `needs:active_support` | loadpath |
| 2252 | `needs:date` | loadpath |
| 2223 | `unresolved:class_eval` | metaprog |
| 2201 | `unresolved:glob` | call |
| 2180 | `unresolved:keys` | call |
| 2113 | `unresolved:read` | call |
| 2079 | `needs:base64` | loadpath |
| 2044 | `needs:httparty` | loadpath |
| 2032 | `unresolved:dup` | call |
| 2028 | `needs:time` | loadpath |
| 1981 | `unresolved:to_sym` | call |
| 1955 | `needs:pathname` | loadpath |
| 1904 | `unresolved:exists?` | call |
| 1873 | `needs:cgi` | loadpath |
| 1835 | `unresolved:find` | call |
| 1812 | `needs:faraday` | loadpath |
| 1810 | `unresolved:name` | call |
| 1790 | `unresolved:each` | call |
| 1768 | `unresolved:sort` | call |
| 1754 | `needs:active_record` | loadpath |
| 1750 | `needs:openssl` | loadpath |
| 1738 | `unresolved:strip` | call |
| 1693 | `unresolved:size` | call |
| 1654 | `unresolved:code` | call |
| 1631 | `unresolved:collect` | call |
| 1614 | `unresolved:start` | call |
| 1607 | `unresolved:any?` | call |
| 1589 | `unresolved:match` | call |
| 1585 | `objectspace` | metaprog |
| 1581 | `needs:ostruct` | loadpath |
| 1577 | `unresolved:to_json` | call |
| 1551 | `unresolved:post` | call |
| 1547 | `unresolved:mkdir_p` | call |
| 1527 | `unresolved:load_file` | call |
| 1520 | `unresolved:info` | call |
| 1520 | `unresolved:to_a` | call |
| 1511 | `unresolved:merge!` | call |
| 1491 | `unresolved:close` | call |
| 1488 | `unresolved:instance_eval` | metaprog |
| 1481 | `needs:securerandom` | loadpath |
| 1445 | `unresolved:config` | call |
| 1440 | `unresolved:shift` | call |
| 1404 | `unresolved:register` | call |
| 1355 | `unresolved:puts` | call |
| 1353 | `unresolved:setup` | call |
| 1324 | `unresolved:respond_to?` | call |
| 1310 | `unresolved:downcase` | call |
| 1294 | `unresolved:last` | call |
| 1282 | `unresolved:fetch` | call |
| 1274 | `unresolved:request` | call |
| 1269 | `unresolved:write` | call |
| 1268 | `unresolved:logger` | call |
| 1255 | `unresolved:const_get` | call |
| 1255 | `unresolved:path` | call |
| 1250 | `hard:Mutex.new` | call |
