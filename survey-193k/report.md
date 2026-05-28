# Spinel gem-compatibility survey

- engine rev: `git:397115c+dirty/aarch64-linux-gnu`
- gems surveyed: **111852**
- compatible (clean+verified): **16246** (14.5%)  ·  risky: 9248  ·  rejected: 86358

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 18130 | `new` |
| 13027 | `[]` |
| 4464 | `expand_path` |
| 4453 | `parse` |
| 4035 | `include?` |
| 3830 | `unshift` |
| 3448 | `join` |
| 3338 | `empty?` |
| 2857 | `extend` |
| 2700 | `include` |
| 2642 | `first` |
| 2445 | `length` |
| 2422 | `split` |
| 2337 | `call` |
| 2310 | `open` |
| 2198 | `delete` |
| 2132 | `load` |
| 1760 | `get` |
| 1750 | `merge` |
| 1621 | `gsub` |
| 1572 | `read` |
| 1437 | `glob` |
| 1430 | `keys` |
| 1421 | `exists?` |
| 1371 | `body` |
| 1272 | `close` |
| 1268 | `dup` |
| 1265 | `to_sym` |
| 1186 | `name` |
| 1162 | `find` |
| 1152 | `sort` |
| 1149 | `each` |
| 1134 | `collect` |
| 1090 | `size` |
| 1087 | `start` |
| 1073 | `info` |
| 1061 | `match` |
| 1008 | `merge!` |
| 1001 | `puts` |
| 1000 | `load_file` |
| 997 | `config` |
| 993 | `strip` |
| 983 | `to_a` |
| 975 | `shift` |
| 948 | `any?` |
| 933 | `write` |
| 918 | `mkdir_p` |
| 905 | `register` |
| 903 | `to_json` |
| 893 | `debug` |
| 888 | `logger` |
| 881 | `last` |
| 872 | `instance` |
| 872 | `respond_to?` |
| 870 | `const_get` |
| 866 | `post` |
| 842 | `downcase` |
| 842 | `path` |
| 818 | `setup` |
| 810 | `code` |
| 769 | `fetch` |
| 763 | `push` |
| 748 | `run` |
| 740 | `hexdigest` |
| 726 | `count` |
| 724 | `key?` |
| 723 | `uniq` |
| 716 | `has_key?` |
| 708 | `error` |
| 698 | `instance_variable_set` |
| 675 | `level=` |
| 657 | `root` |
| 632 | `request` |
| 627 | `to_s` |
| 622 | `to_h` |
| 619 | `Array` |
| 613 | `gem` |
| 610 | `index` |
| 593 | `flatten` |
| 589 | `warn` |
| 588 | `require_relative` |
| 587 | `dump` |
| 585 | `fail` |
| 584 | `URI` |
| 581 | `text` |
| 580 | `reverse` |
| 576 | `configure` |
| 574 | `compact` |
| 573 | `values` |
| 570 | `blank?` |
| 570 | `update` |
| 562 | `exist?` |
| 560 | `scan` |
| 558 | `use_ssl=` |
| 556 | `gsub!` |
| 548 | `strftime` |
| 547 | `present?` |
| 537 | `synchronize` |
| 536 | `current` |
| 524 | `HTML` |
| 524 | `options` |
| 520 | `on_load` |
| 518 | `with_index` |
| 502 | `message` |
| 502 | `value` |
| 495 | `css` |
| 483 | `sort_by` |
| 482 | `execute` |
| 480 | `pop` |
| 480 | `sub` |
| 479 | `env` |
| 478 | `gets` |
| 476 | `add` |
| 471 | `escape` |
| 471 | `status` |
| 468 | `clear` |
| 467 | `clone` |
| 467 | `map!` |
| 465 | `create` |
| 459 | `mkdir` |
| 449 | `add_identifier` |
| 438 | `chdir` |
| 431 | `delete_if` |
| 420 | `const_defined?` |
| 417 | `result` |
| 411 | `body=` |
| 409 | `===` |
| 408 | `version` |
| 403 | `start_with?` |
| 402 | `generate` |
| 395 | `upcase` |
| 394 | `[]=` |
| 390 | `all?` |
| 378 | `host` |
| 377 | `xpath` |
| 368 | `headers` |
| 365 | `success?` |
| 363 | `instance_variable_get` |
| 358 | `encode` |
| 355 | `configuration` |
| 355 | `connect` |
| 351 | `id` |
| 350 | `readlines` |
| 347 | `all` |
| 340 | `constantize` |
| 339 | `unpack` |
| 338 | `to_f` |
| 334 | `chomp` |
| 331 | `exit` |
| 329 | `children` |
| 329 | `to_yaml` |
| 327 | `scheme` |
| 326 | `map` |
| 325 | `detect` |
| 322 | `render` |
| 322 | `search` |
| 313 | `parent` |
| 311 | `slice` |
| 309 | `concat` |
| 307 | `each_line` |
| 305 | `attributes` |
| 300 | `verify_mode=` |
| 298 | `set` |
| 292 | `encode64` |
| 286 | `kill` |
| 283 | `prepend` |
| 280 | `for_gem` |
| 280 | `object_id` |
| 277 | `red` |
| 273 | `XML` |
| 272 | `print` |
| 269 | `entries` |
| 268 | `max` |
| 268 | `timeout` |
| 265 | `build` |
| 262 | `application` |
| 262 | `each_key` |
| 262 | `save` |
| 261 | `hash` |
| 260 | `query` |
| 259 | `to_hash` |
| 258 | `connection` |
| 258 | `min` |
| 257 | `type` |
| 254 | `flush` |
| 251 | `formatter=` |
| 247 | `cp` |
| 246 | `foreach` |
| 245 | `const_set` |
| 244 | `module_eval` |
| 244 | `pretty_generate` |
| 240 | `each_with_index` |
| 240 | `method` |
| 238 | `reject!` |
| 235 | `green` |
| 234 | `data` |
| 234 | `select` |
| 233 | `autoload` |
| 233 | `underscore` |
| 231 | `port` |

Showing 200 of **41798** distinct candidate calls (319102 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 319102 | candidate core/stdlib calls (above) |
| 98869 | metaprogramming / reflection — out of scope |
| 455574 | no load path: `require` + `needs:` — probe limitation |
| 18248 | analyzer failed / timed out — compiler hardening |
| 2145 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 43718 | `unresolved:require` | loadpath |
| 26609 | `send` | metaprog |
| 18130 | `unresolved:new` | call |
| 18093 | `analyze-failed` | robustness |
| 13672 | `define_method` | metaprog |
| 13027 | `unresolved:[]` | call |
| 12733 | `class_eval` | metaprog |
| 12313 | `method_missing` | metaprog |
| 9654 | `instance_eval` | metaprog |
| 6491 | `needs:json` | loadpath |
| 5215 | `binding` | metaprog |
| 4464 | `unresolved:expand_path` | call |
| 4453 | `unresolved:parse` | call |
| 4411 | `eval` | metaprog |
| 4035 | `unresolved:include?` | call |
| 3830 | `unresolved:unshift` | call |
| 3636 | `public_send` | metaprog |
| 3595 | `needs:yaml` | loadpath |
| 3448 | `unresolved:join` | call |
| 3338 | `unresolved:empty?` | call |
| 2857 | `unresolved:extend` | call |
| 2700 | `unresolved:include` | call |
| 2642 | `unresolved:first` | call |
| 2588 | `needs:logger` | loadpath |
| 2536 | `needs:uri` | loadpath |
| 2512 | `needs:fileutils` | loadpath |
| 2445 | `unresolved:length` | call |
| 2422 | `unresolved:split` | call |
| 2337 | `unresolved:call` | call |
| 2315 | `needs:net/http` | loadpath |
| 2310 | `unresolved:open` | call |
| 2259 | `unresolved:send` | metaprog |
| 2198 | `unresolved:delete` | call |
| 2196 | `needs:rubygems` | loadpath |
| 2150 | `respond_to_missing` | metaprog |
| 2145 | `c-extension` | cext |
| 2132 | `unresolved:load` | call |
| 1928 | `needs:nokogiri` | loadpath |
| 1760 | `unresolved:get` | call |
| 1750 | `unresolved:merge` | call |
| 1621 | `unresolved:gsub` | call |
| 1572 | `needs:active_support` | loadpath |
| 1572 | `unresolved:read` | call |
| 1518 | `needs:open-uri` | loadpath |
| 1512 | `unresolved:class_eval` | metaprog |
| 1465 | `needs:pathname` | loadpath |
| 1437 | `unresolved:glob` | call |
| 1430 | `unresolved:keys` | call |
| 1421 | `unresolved:exists?` | call |
| 1393 | `objectspace` | metaprog |
| 1386 | `needs:date` | loadpath |
| 1378 | `needs:time` | loadpath |
| 1371 | `unresolved:body` | call |
| 1307 | `needs:cgi` | loadpath |
| 1294 | `needs:base64` | loadpath |
| 1272 | `unresolved:close` | call |
| 1268 | `unresolved:dup` | call |
| 1265 | `unresolved:to_sym` | call |
| 1201 | `needs:httparty` | loadpath |
| 1186 | `unresolved:name` | call |
| 1174 | `needs:active_record` | loadpath |
| 1162 | `unresolved:find` | call |
| 1152 | `unresolved:sort` | call |
| 1149 | `unresolved:each` | call |
| 1139 | `needs:ostruct` | loadpath |
| 1134 | `unresolved:collect` | call |
| 1090 | `unresolved:size` | call |
| 1087 | `unresolved:start` | call |
| 1086 | `needs:openssl` | loadpath |
| 1073 | `unresolved:info` | call |
| 1061 | `unresolved:match` | call |
| 1037 | `unresolved:instance_eval` | metaprog |
| 1008 | `unresolved:merge!` | call |
| 1001 | `unresolved:puts` | call |
| 1000 | `unresolved:load_file` | call |
| 997 | `unresolved:config` | call |
| 993 | `unresolved:strip` | call |
| 983 | `unresolved:to_a` | call |
| 982 | `needs:securerandom` | loadpath |
| 975 | `unresolved:shift` | call |
| 960 | `needs:faraday` | loadpath |
| 948 | `unresolved:any?` | call |
| 933 | `unresolved:write` | call |
| 931 | `const_missing` | metaprog |
| 918 | `unresolved:mkdir_p` | call |
| 905 | `unresolved:register` | call |
| 903 | `unresolved:to_json` | call |
| 893 | `unresolved:debug` | call |
| 888 | `unresolved:logger` | call |
| 881 | `unresolved:last` | call |
| 872 | `unresolved:instance` | call |
| 872 | `unresolved:respond_to?` | call |
| 870 | `unresolved:const_get` | call |
| 866 | `unresolved:post` | call |
| 842 | `unresolved:downcase` | call |
| 842 | `unresolved:path` | call |
| 836 | `needs:socket` | loadpath |
| 818 | `unresolved:setup` | call |
| 810 | `unresolved:code` | call |
| 769 | `unresolved:fetch` | call |
