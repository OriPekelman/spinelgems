# Spinel gem-compatibility survey

- engine rev: `git:a03bb49+dirty/aarch64-linux-gnu`
- gems surveyed: **149078**
- compatible (clean+verified): **24587** (16.5%)  ·  risky: 10884  ·  rejected: 113607

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 22035 | `new` |
| 16079 | `[]` |
| 10308 | `no-entrypoint` |
| 5594 | `parse` |
| 5349 | `expand_path` |
| 4957 | `include?` |
| 4915 | `unshift` |
| 4080 | `join` |
| 3988 | `empty?` |
| 3656 | `extend` |
| 3507 | `include` |
| 3184 | `first` |
| 2979 | `length` |
| 2908 | `split` |
| 2796 | `call` |
| 2604 | `delete` |
| 2585 | `load` |
| 2284 | `get` |
| 2091 | `merge` |
| 2030 | `open` |
| 1888 | `gsub` |
| 1775 | `glob` |
| 1760 | `body` |
| 1749 | `exists?` |
| 1730 | `keys` |
| 1723 | `read` |
| 1663 | `hard:Thread.new` |
| 1526 | `dup` |
| 1510 | `to_sym` |
| 1434 | `collect` |
| 1426 | `name` |
| 1416 | `sort` |
| 1403 | `each` |
| 1386 | `find` |
| 1312 | `size` |
| 1301 | `start` |
| 1267 | `close` |
| 1251 | `match` |
| 1237 | `load_file` |
| 1224 | `info` |
| 1224 | `merge!` |
| 1219 | `strip` |
| 1186 | `config` |
| 1183 | `shift` |
| 1160 | `to_a` |
| 1144 | `register` |
| 1137 | `puts` |
| 1120 | `post` |
| 1116 | `mkdir_p` |
| 1110 | `to_json` |
| 1085 | `any?` |
| 1042 | `const_get` |
| 1041 | `code` |
| 1037 | `last` |
| 1030 | `write` |
| 1026 | `logger` |
| 1025 | `instance` |
| 1023 | `respond_to?` |
| 989 | `path` |
| 988 | `debug` |
| 986 | `setup` |
| 967 | `downcase` |
| 925 | `push` |
| 923 | `fetch` |
| 920 | `hexdigest` |
| 894 | `count` |
| 880 | `run` |
| 865 | `has_key?` |
| 857 | `instance_variable_set` |
| 849 | `gem` |
| 847 | `uniq` |
| 836 | `key?` |
| 823 | `root` |
| 811 | `request` |
| 790 | `error` |
| 787 | `text` |
| 753 | `level=` |
| 746 | `reverse` |
| 744 | `to_s` |
| 742 | `HTML` |
| 738 | `index` |
| 732 | `use_ssl=` |
| 729 | `blank?` |
| 729 | `to_h` |
| 720 | `URI` |
| 719 | `Array` |
| 715 | `flatten` |
| 694 | `update` |
| 688 | `values` |
| 678 | `fail` |
| 677 | `dump` |
| 674 | `css` |
| 674 | `with_index` |
| 672 | `compact` |
| 667 | `warn` |
| 665 | `configure` |
| 665 | `gsub!` |
| 662 | `scan` |
| 659 | `strftime` |
| 657 | `exist?` |
| 656 | `require_relative` |
| 654 | `options` |
| 639 | `present?` |
| 606 | `escape` |
| 606 | `message` |
| 598 | `on_load` |
| 595 | `hard:Mutex.new` |
| 585 | `value` |
| 580 | `map!` |
| 575 | `status` |
| 572 | `gets` |
| 571 | `execute` |
| 565 | `current` |
| 561 | `mkdir` |
| 557 | `create` |
| 551 | `clone` |
| 551 | `sort_by` |
| 549 | `env` |
| 543 | `clear` |
| 543 | `sub` |
| 537 | `add` |
| 535 | `pop` |
| 520 | `chdir` |
| 517 | `result` |
| 510 | `body=` |
| 508 | `delete_if` |
| 502 | `const_defined?` |
| 495 | `===` |
| 486 | `generate` |
| 473 | `synchronize` |
| 472 | `xpath` |
| 471 | `version` |
| 463 | `upcase` |
| 462 | `[]=` |
| 455 | `all?` |
| 450 | `add_identifier` |
| 449 | `id` |
| 449 | `start_with?` |
| 448 | `configuration` |
| 446 | `readlines` |
| 445 | `search` |
| 444 | `encode` |
| 443 | `host` |
| 442 | `headers` |
| 439 | `success?` |
| 423 | `instance_variable_get` |
| 417 | `all` |
| 415 | `constantize` |
| 412 | `to_yaml` |
| 407 | `map` |
| 406 | `unpack` |
| 405 | `children` |
| 402 | `connect` |
| 397 | `chomp` |
| 397 | `detect` |
| 392 | `render` |
| 390 | `exit` |
| 388 | `scheme` |
| 388 | `slice` |
| 388 | `to_f` |
| 384 | `verify_mode=` |
| 373 | `attributes` |
| 372 | `encode64` |
| 363 | `concat` |
| 362 | `parent` |
| 360 | `set` |
| 356 | `XML` |
| 353 | `each_line` |
| 350 | `red` |
| 335 | `prepend` |
| 330 | `type` |
| 326 | `max` |
| 325 | `save` |
| 323 | `for_gem` |
| 321 | `build` |
| 319 | `min` |
| 318 | `object_id` |
| 317 | `load_locales` |
| 313 | `print` |
| 310 | `entries` |
| 310 | `query` |
| 307 | `green` |
| 306 | `timeout` |
| 303 | `connection` |
| 301 | `module_eval` |
| 300 | `hash` |
| 299 | `foreach` |
| 297 | `data` |
| 296 | `to_hash` |
| 295 | `application` |
| 293 | `pretty_generate` |
| 292 | `underscore` |
| 291 | `get_response` |
| 289 | `Pathname` |
| 289 | `const_set` |
| 289 | `formatter=` |
| 287 | `cp` |
| 286 | `each_key` |
| 285 | `each_with_index` |
| 284 | `kill` |

Showing 200 of **46229** distinct candidate calls (393326 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 393326 | candidate core/stdlib calls (above) |
| 113836 | metaprogramming / reflection — out of scope |
| 541257 | no load path: `require` + `needs:` — probe limitation |
| 14452 | analyzer failed / timed out — compiler hardening |
| 2502 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 54623 | `unresolved:require` | loadpath |
| 30946 | `send` | metaprog |
| 22035 | `unresolved:new` | call |
| 16079 | `unresolved:[]` | call |
| 15668 | `define_method` | metaprog |
| 14887 | `class_eval` | metaprog |
| 14262 | `method_missing` | metaprog |
| 14218 | `analyze-failed` | robustness |
| 10985 | `instance_eval` | metaprog |
| 10308 | `no-entrypoint` | call |
| 7945 | `needs:json` | loadpath |
| 5788 | `binding` | metaprog |
| 5594 | `unresolved:parse` | call |
| 5349 | `unresolved:expand_path` | call |
| 5015 | `eval` | metaprog |
| 4957 | `unresolved:include?` | call |
| 4915 | `unresolved:unshift` | call |
| 4316 | `needs:yaml` | loadpath |
| 4080 | `unresolved:join` | call |
| 3988 | `unresolved:empty?` | call |
| 3934 | `public_send` | metaprog |
| 3656 | `unresolved:extend` | call |
| 3507 | `unresolved:include` | call |
| 3184 | `unresolved:first` | call |
| 3144 | `needs:uri` | loadpath |
| 3011 | `needs:fileutils` | loadpath |
| 2979 | `unresolved:length` | call |
| 2963 | `needs:net/http` | loadpath |
| 2908 | `needs:logger` | loadpath |
| 2908 | `unresolved:split` | call |
| 2879 | `needs:rubygems` | loadpath |
| 2805 | `unresolved:send` | metaprog |
| 2796 | `unresolved:call` | call |
| 2604 | `unresolved:delete` | call |
| 2585 | `unresolved:load` | call |
| 2502 | `c-extension` | cext |
| 2480 | `needs:nokogiri` | loadpath |
| 2331 | `respond_to_missing` | metaprog |
| 2284 | `unresolved:get` | call |
| 2091 | `unresolved:merge` | call |
| 2063 | `needs:open-uri` | loadpath |
| 2030 | `unresolved:open` | call |
| 1940 | `unresolved:class_eval` | metaprog |
| 1915 | `needs:active_support` | loadpath |
| 1888 | `unresolved:gsub` | call |
| 1775 | `unresolved:glob` | call |
| 1760 | `unresolved:body` | call |
| 1749 | `unresolved:exists?` | call |
| 1730 | `unresolved:keys` | call |
| 1723 | `unresolved:read` | call |
| 1713 | `needs:date` | loadpath |
| 1672 | `needs:pathname` | loadpath |
| 1663 | `hard:Thread.new` | call |
| 1643 | `needs:time` | loadpath |
| 1634 | `needs:cgi` | loadpath |
| 1617 | `needs:httparty` | loadpath |
| 1612 | `needs:base64` | loadpath |
| 1526 | `unresolved:dup` | call |
| 1510 | `unresolved:to_sym` | call |
| 1458 | `needs:active_record` | loadpath |
| 1456 | `objectspace` | metaprog |
| 1434 | `unresolved:collect` | call |
| 1426 | `unresolved:name` | call |
| 1416 | `unresolved:sort` | call |
| 1403 | `unresolved:each` | call |
| 1386 | `unresolved:find` | call |
| 1378 | `needs:ostruct` | loadpath |
| 1335 | `needs:openssl` | loadpath |
| 1312 | `unresolved:size` | call |
| 1301 | `unresolved:start` | call |
| 1267 | `unresolved:close` | call |
| 1256 | `unresolved:instance_eval` | metaprog |
| 1251 | `unresolved:match` | call |
| 1237 | `unresolved:load_file` | call |
| 1224 | `unresolved:info` | call |
| 1224 | `unresolved:merge!` | call |
| 1219 | `unresolved:strip` | call |
| 1197 | `needs:faraday` | loadpath |
| 1186 | `unresolved:config` | call |
| 1183 | `unresolved:shift` | call |
| 1160 | `unresolved:to_a` | call |
| 1144 | `unresolved:register` | call |
| 1137 | `unresolved:puts` | call |
| 1122 | `needs:securerandom` | loadpath |
| 1120 | `unresolved:post` | call |
| 1116 | `unresolved:mkdir_p` | call |
| 1110 | `unresolved:to_json` | call |
| 1085 | `unresolved:any?` | call |
| 1042 | `unresolved:const_get` | call |
| 1041 | `unresolved:code` | call |
| 1040 | `const_missing` | metaprog |
| 1037 | `unresolved:last` | call |
| 1030 | `unresolved:write` | call |
| 1026 | `unresolved:logger` | call |
| 1025 | `unresolved:instance` | call |
| 1023 | `unresolved:respond_to?` | call |
| 989 | `unresolved:path` | call |
| 988 | `unresolved:debug` | call |
| 986 | `unresolved:setup` | call |
| 975 | `needs:net/https` | loadpath |
