# Spinel gem-compatibility survey

- engine rev: `git:8d88ebe+dirty/aarch64-linux-gnu`
- gems surveyed: **189750**
- compatible (clean+verified): **33636** (17.7%)  ·  risky: 11816  ·  rejected: 143580

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 30720 | `no-entrypoint` |
| 25234 | `new` |
| 19317 | `[]` |
| 7457 | `parse` |
| 5947 | `hard:Thread.new` |
| 5824 | `expand_path` |
| 5693 | `include?` |
| 5061 | `empty?` |
| 5049 | `unshift` |
| 4805 | `join` |
| 4136 | `extend` |
| 3898 | `include` |
| 3855 | `first` |
| 3681 | `length` |
| 3426 | `split` |
| 3255 | `call` |
| 2891 | `delete` |
| 2825 | `get` |
| 2804 | `hard:Mutex.new` |
| 2777 | `load` |
| 2577 | `body` |
| 2479 | `merge` |
| 2321 | `open` |
| 2261 | `gsub` |
| 2071 | `glob` |
| 2006 | `keys` |
| 1977 | `read` |
| 1868 | `dup` |
| 1820 | `to_sym` |
| 1755 | `exists?` |
| 1711 | `find` |
| 1662 | `name` |
| 1654 | `each` |
| 1642 | `sort` |
| 1625 | `strip` |
| 1586 | `code` |
| 1535 | `size` |
| 1526 | `collect` |
| 1501 | `post` |
| 1489 | `match` |
| 1469 | `to_json` |
| 1459 | `load_file` |
| 1454 | `any?` |
| 1448 | `mkdir_p` |
| 1388 | `start` |
| 1385 | `merge!` |
| 1378 | `to_a` |
| 1361 | `register` |
| 1358 | `config` |
| 1331 | `shift` |
| 1297 | `info` |
| 1281 | `setup` |
| 1237 | `close` |
| 1220 | `request` |
| 1214 | `downcase` |
| 1204 | `last` |
| 1198 | `puts` |
| 1190 | `respond_to?` |
| 1180 | `fetch` |
| 1171 | `URI` |
| 1150 | `const_get` |
| 1146 | `path` |
| 1136 | `write` |
| 1126 | `use_ssl=` |
| 1115 | `logger` |
| 1110 | `key?` |
| 1104 | `uniq` |
| 1095 | `count` |
| 1088 | `hexdigest` |
| 1052 | `instance` |
| 1047 | `reverse` |
| 1025 | `HTML` |
| 1009 | `text` |
| 997 | `push` |
| 996 | `debug` |
| 995 | `instance_variable_set` |
| 987 | `Array` |
| 984 | `[]=` |
| 977 | `to_h` |
| 973 | `with_index` |
| 941 | `compact` |
| 921 | `index` |
| 919 | `css` |
| 918 | `has_key?` |
| 918 | `root` |
| 883 | `scan` |
| 877 | `gem` |
| 870 | `run` |
| 856 | `blank?` |
| 851 | `error` |
| 845 | `body=` |
| 834 | `to_s` |
| 828 | `strftime` |
| 824 | `values` |
| 820 | `exist?` |
| 801 | `options` |
| 801 | `present?` |
| 795 | `status` |
| 786 | `message` |
| 782 | `flatten` |
| 765 | `dump` |
| 759 | `update` |
| 756 | `level=` |
| 752 | `gsub!` |
| 751 | `sort_by` |
| 744 | `require_relative` |
| 719 | `fail` |
| 718 | `configure` |
| 709 | `warn` |
| 698 | `escape` |
| 695 | `value` |
| 692 | `on_load` |
| 678 | `success?` |
| 673 | `generate` |
| 663 | `execute` |
| 659 | `map!` |
| 658 | `configuration` |
| 651 | `start_with?` |
| 640 | `sub` |
| 634 | `clone` |
| 626 | `create` |
| 622 | `gets` |
| 617 | `all?` |
| 608 | `env` |
| 607 | `headers` |
| 606 | `clear` |
| 602 | `add` |
| 602 | `mkdir` |
| 589 | `result` |
| 576 | `chdir` |
| 567 | `readlines` |
| 561 | `upcase` |
| 558 | `xpath` |
| 551 | `delete_if` |
| 544 | `map` |
| 542 | `const_defined?` |
| 542 | `id` |
| 540 | `current` |
| 535 | `for_gem` |
| 533 | `all` |
| 533 | `encode` |
| 529 | `===` |
| 525 | `children` |
| 515 | `host` |
| 512 | `search` |
| 511 | `pop` |
| 510 | `to_f` |
| 502 | `query=` |
| 497 | `slice` |
| 496 | `chomp` |
| 489 | `constantize` |
| 485 | `version` |
| 480 | `to_yaml` |
| 474 | `instance_variable_get` |
| 467 | `scheme` |
| 466 | `render` |
| 465 | `pretty_generate` |
| 463 | `type` |
| 458 | `exit` |
| 456 | `get_response` |
| 452 | `verify_mode=` |
| 449 | `add_identifier` |
| 448 | `detect` |
| 445 | `each_line` |
| 436 | `concat` |
| 432 | `XML` |
| 431 | `smoke-error:cruby` |
| 426 | `prepend` |
| 425 | `attributes` |
| 422 | `red` |
| 420 | `unpack` |
| 419 | `each_with_index` |
| 418 | `min` |
| 416 | `load_locales` |
| 412 | `parent` |
| 411 | `match?` |
| 408 | `max` |
| 399 | `connect` |
| 396 | `encode64` |
| 395 | `read_timeout=` |
| 382 | `set` |
| 372 | `green` |
| 369 | `build` |
| 368 | `connection` |
| 366 | `save` |
| 355 | `print` |
| 355 | `round` |
| 354 | `application` |
| 354 | `strict_encode64` |
| 353 | `instance_variables` |
| 352 | `each_key` |
| 349 | `entries` |
| 349 | `put` |
| 347 | `data` |
| 347 | `hash` |
| 346 | `end_with?` |
| 341 | `query` |
| 337 | `foreach` |
| 337 | `to_hash` |
| 335 | `transform_keys` |

Showing 200 of **47869** distinct candidate calls (481615 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 481615 | candidate core/stdlib calls (above) |
| 109871 | metaprogramming / reflection — out of scope |
| 592857 | no load path: `require` + `needs:` — probe limitation |
| 2339 | analyzer failed / timed out — compiler hardening |
| 2666 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 60728 | `unresolved:require` | loadpath |
| 30720 | `no-entrypoint` | call |
| 30403 | `send` | metaprog |
| 25234 | `unresolved:new` | call |
| 19317 | `unresolved:[]` | call |
| 15113 | `define_method` | metaprog |
| 14186 | `class_eval` | metaprog |
| 13583 | `method_missing` | metaprog |
| 10311 | `instance_eval` | metaprog |
| 10193 | `needs:json` | loadpath |
| 7457 | `unresolved:parse` | call |
| 5947 | `hard:Thread.new` | call |
| 5824 | `unresolved:expand_path` | call |
| 5693 | `unresolved:include?` | call |
| 5139 | `binding` | metaprog |
| 5061 | `unresolved:empty?` | call |
| 5049 | `unresolved:unshift` | call |
| 4805 | `unresolved:join` | call |
| 4720 | `needs:yaml` | loadpath |
| 4518 | `eval` | metaprog |
| 4136 | `unresolved:extend` | call |
| 4049 | `public_send` | metaprog |
| 4039 | `needs:uri` | loadpath |
| 3898 | `unresolved:include` | call |
| 3861 | `needs:net/http` | loadpath |
| 3855 | `unresolved:first` | call |
| 3681 | `unresolved:length` | call |
| 3426 | `unresolved:split` | call |
| 3410 | `needs:fileutils` | loadpath |
| 3255 | `unresolved:call` | call |
| 3237 | `unresolved:send` | metaprog |
| 3002 | `needs:nokogiri` | loadpath |
| 2929 | `needs:rubygems` | loadpath |
| 2891 | `unresolved:delete` | call |
| 2842 | `needs:logger` | loadpath |
| 2825 | `unresolved:get` | call |
| 2804 | `hard:Mutex.new` | call |
| 2777 | `unresolved:load` | call |
| 2666 | `c-extension` | cext |
| 2577 | `unresolved:body` | call |
| 2479 | `unresolved:merge` | call |
| 2452 | `needs:open-uri` | loadpath |
| 2322 | `respond_to_missing` | metaprog |
| 2321 | `unresolved:open` | call |
| 2261 | `unresolved:gsub` | call |
| 2146 | `needs:active_support` | loadpath |
| 2140 | `unresolved:class_eval` | metaprog |
| 2109 | `needs:date` | loadpath |
| 2071 | `unresolved:glob` | call |
| 2027 | `needs:httparty` | loadpath |
| 2006 | `unresolved:keys` | call |
| 1985 | `analyze-failed` | robustness |
| 1977 | `unresolved:read` | call |
| 1900 | `needs:base64` | loadpath |
| 1868 | `unresolved:dup` | call |
| 1820 | `unresolved:to_sym` | call |
| 1795 | `needs:time` | loadpath |
| 1764 | `needs:cgi` | loadpath |
| 1755 | `unresolved:exists?` | call |
| 1753 | `needs:faraday` | loadpath |
| 1711 | `unresolved:find` | call |
| 1692 | `needs:active_record` | loadpath |
| 1678 | `needs:pathname` | loadpath |
| 1662 | `unresolved:name` | call |
| 1654 | `unresolved:each` | call |
| 1642 | `unresolved:sort` | call |
| 1625 | `unresolved:strip` | call |
| 1603 | `needs:openssl` | loadpath |
| 1586 | `unresolved:code` | call |
| 1535 | `unresolved:size` | call |
| 1526 | `unresolved:collect` | call |
| 1501 | `unresolved:post` | call |
| 1489 | `unresolved:match` | call |
| 1469 | `unresolved:to_json` | call |
| 1459 | `unresolved:load_file` | call |
| 1454 | `unresolved:any?` | call |
| 1452 | `needs:ostruct` | loadpath |
| 1448 | `unresolved:mkdir_p` | call |
| 1395 | `unresolved:instance_eval` | metaprog |
| 1388 | `unresolved:start` | call |
| 1385 | `unresolved:merge!` | call |
| 1378 | `unresolved:to_a` | call |
| 1361 | `unresolved:register` | call |
| 1358 | `unresolved:config` | call |
| 1331 | `unresolved:shift` | call |
| 1297 | `unresolved:info` | call |
| 1281 | `unresolved:setup` | call |
| 1237 | `unresolved:close` | call |
| 1233 | `needs:securerandom` | loadpath |
| 1220 | `unresolved:request` | call |
| 1214 | `unresolved:downcase` | call |
| 1204 | `unresolved:last` | call |
| 1198 | `unresolved:puts` | call |
| 1190 | `unresolved:respond_to?` | call |
| 1180 | `unresolved:fetch` | call |
| 1171 | `unresolved:URI` | call |
| 1150 | `unresolved:const_get` | call |
| 1146 | `unresolved:path` | call |
| 1136 | `unresolved:write` | call |
| 1126 | `unresolved:use_ssl=` | call |
