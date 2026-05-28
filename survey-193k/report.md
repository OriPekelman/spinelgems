# Spinel gem-compatibility survey

- engine rev: `git:a03bb49+dirty/aarch64-linux-gnu`
- gems surveyed: **84324**
- compatible (clean+verified): **11520** (13.7%)  ·  risky: 7478  ·  rejected: 65326

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 13893 | `new` |
| 10044 | `[]` |
| 3576 | `expand_path` |
| 3309 | `parse` |
| 3146 | `include?` |
| 2920 | `unshift` |
| 2704 | `join` |
| 2676 | `empty?` |
| 2188 | `extend` |
| 2099 | `include` |
| 2052 | `first` |
| 1848 | `split` |
| 1835 | `call` |
| 1829 | `length` |
| 1773 | `delete` |
| 1640 | `load` |
| 1404 | `merge` |
| 1277 | `get` |
| 1273 | `gsub` |
| 1217 | `open` |
| 1155 | `keys` |
| 1142 | `glob` |
| 1095 | `exists?` |
| 1091 | `read` |
| 1057 | `body` |
| 1038 | `to_sym` |
| 1025 | `dup` |
| 944 | `name` |
| 928 | `find` |
| 912 | `sort` |
| 863 | `collect` |
| 857 | `close` |
| 853 | `each` |
| 841 | `size` |
| 838 | `match` |
| 830 | `info` |
| 829 | `merge!` |
| 801 | `start` |
| 800 | `config` |
| 800 | `to_a` |
| 797 | `any?` |
| 776 | `load_file` |
| 761 | `shift` |
| 747 | `strip` |
| 736 | `logger` |
| 734 | `puts` |
| 729 | `mkdir_p` |
| 720 | `register` |
| 717 | `respond_to?` |
| 713 | `const_get` |
| 707 | `debug` |
| 706 | `instance` |
| 698 | `to_json` |
| 677 | `last` |
| 666 | `write` |
| 661 | `path` |
| 649 | `code` |
| 646 | `downcase` |
| 645 | `post` |
| 623 | `setup` |
| 621 | `key?` |
| 603 | `fetch` |
| 595 | `run` |
| 585 | `has_key?` |
| 578 | `push` |
| 567 | `uniq` |
| 565 | `error` |
| 563 | `count` |
| 562 | `level=` |
| 559 | `instance_variable_set` |
| 553 | `hexdigest` |
| 531 | `root` |
| 519 | `Array` |
| 507 | `require_relative` |
| 503 | `to_s` |
| 497 | `index` |
| 488 | `warn` |
| 487 | `to_h` |
| 483 | `flatten` |
| 473 | `request` |
| 472 | `configure` |
| 468 | `reverse` |
| 463 | `gem` |
| 455 | `compact` |
| 453 | `synchronize` |
| 451 | `values` |
| 450 | `dump` |
| 450 | `exist?` |
| 449 | `add_identifier` |
| 448 | `fail` |
| 446 | `blank?` |
| 442 | `on_load` |
| 441 | `current` |
| 440 | `present?` |
| 440 | `update` |
| 437 | `scan` |
| 433 | `gsub!` |
| 432 | `use_ssl=` |
| 431 | `strftime` |
| 419 | `URI` |
| 417 | `options` |
| 401 | `text` |
| 399 | `message` |
| 399 | `sub` |
| 386 | `value` |
| 384 | `sort_by` |
| 380 | `env` |
| 378 | `add` |
| 378 | `pop` |
| 372 | `status` |
| 370 | `clear` |
| 367 | `map!` |
| 366 | `execute` |
| 363 | `clone` |
| 360 | `create` |
| 359 | `escape` |
| 359 | `with_index` |
| 358 | `mkdir` |
| 357 | `version` |
| 356 | `delete_if` |
| 353 | `chdir` |
| 352 | `gets` |
| 349 | `const_defined?` |
| 334 | `result` |
| 331 | `===` |
| 330 | `generate` |
| 329 | `start_with?` |
| 310 | `HTML` |
| 307 | `body=` |
| 306 | `css` |
| 302 | `[]=` |
| 302 | `upcase` |
| 298 | `all?` |
| 297 | `host` |
| 293 | `headers` |
| 292 | `instance_variable_get` |
| 292 | `xpath` |
| 288 | `success?` |
| 281 | `configuration` |
| 280 | `to_yaml` |
| 274 | `connect` |
| 272 | `id` |
| 270 | `constantize` |
| 269 | `encode` |
| 269 | `readlines` |
| 269 | `to_f` |
| 263 | `map` |
| 258 | `render` |
| 257 | `scheme` |
| 257 | `unpack` |
| 254 | `exit` |
| 253 | `parent` |
| 252 | `chomp` |
| 251 | `children` |
| 249 | `concat` |
| 248 | `detect` |
| 246 | `prepend` |
| 244 | `attributes` |
| 241 | `set` |
| 240 | `all` |
| 233 | `each_line` |
| 233 | `slice` |
| 232 | `verify_mode=` |
| 231 | `object_id` |
| 231 | `search` |
| 230 | `kill` |
| 229 | `timeout` |
| 226 | `encode64` |
| 219 | `max` |
| 217 | `for_gem` |
| 216 | `red` |
| 215 | `formatter=` |
| 215 | `min` |
| 214 | `each_key` |
| 211 | `application` |
| 210 | `to_hash` |
| 209 | `hash` |
| 209 | `print` |
| 209 | `type` |
| 207 | `save` |
| 205 | `XML` |
| 205 | `build` |
| 204 | `entries` |
| 203 | `query` |
| 202 | `connection` |
| 201 | `flush` |
| 199 | `pretty_generate` |
| 198 | `const_set` |
| 196 | `autoload` |
| 195 | `method` |
| 194 | `sync=` |
| 193 | `port` |
| 191 | `Pathname` |
| 191 | `cp` |
| 191 | `reject!` |
| 191 | `underscore` |
| 190 | `data` |
| 190 | `log` |
| 189 | `module_eval` |
| 189 | `response` |

Showing 200 of **36160** distinct candidate calls (250859 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 250859 | candidate core/stdlib calls (above) |
| 80333 | metaprogramming / reflection — out of scope |
| 370030 | no load path: `require` + `needs:` — probe limitation |
| 13779 | analyzer failed / timed out — compiler hardening |
| 1708 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 33121 | `unresolved:require` | loadpath |
| 21571 | `send` | metaprog |
| 13893 | `unresolved:new` | call |
| 13609 | `analyze-failed` | robustness |
| 11144 | `define_method` | metaprog |
| 10336 | `class_eval` | metaprog |
| 10044 | `unresolved:[]` | call |
| 10004 | `method_missing` | metaprog |
| 7853 | `instance_eval` | metaprog |
| 5056 | `needs:json` | loadpath |
| 4263 | `binding` | metaprog |
| 3585 | `eval` | metaprog |
| 3576 | `unresolved:expand_path` | call |
| 3309 | `unresolved:parse` | call |
| 3146 | `unresolved:include?` | call |
| 3086 | `public_send` | metaprog |
| 2920 | `unresolved:unshift` | call |
| 2880 | `needs:yaml` | loadpath |
| 2704 | `unresolved:join` | call |
| 2676 | `unresolved:empty?` | call |
| 2188 | `unresolved:extend` | call |
| 2099 | `unresolved:include` | call |
| 2096 | `needs:logger` | loadpath |
| 2052 | `unresolved:first` | call |
| 1995 | `needs:fileutils` | loadpath |
| 1951 | `needs:uri` | loadpath |
| 1848 | `unresolved:split` | call |
| 1835 | `unresolved:call` | call |
| 1831 | `respond_to_missing` | metaprog |
| 1829 | `unresolved:length` | call |
| 1773 | `unresolved:delete` | call |
| 1751 | `needs:net/http` | loadpath |
| 1730 | `unresolved:send` | metaprog |
| 1708 | `c-extension` | cext |
| 1698 | `needs:rubygems` | loadpath |
| 1640 | `unresolved:load` | call |
| 1421 | `needs:nokogiri` | loadpath |
| 1404 | `unresolved:merge` | call |
| 1292 | `needs:active_support` | loadpath |
| 1277 | `unresolved:get` | call |
| 1273 | `unresolved:gsub` | call |
| 1217 | `unresolved:open` | call |
| 1208 | `needs:pathname` | loadpath |
| 1155 | `unresolved:keys` | call |
| 1151 | `objectspace` | metaprog |
| 1142 | `unresolved:glob` | call |
| 1138 | `unresolved:class_eval` | metaprog |
| 1112 | `needs:time` | loadpath |
| 1095 | `unresolved:exists?` | call |
| 1091 | `unresolved:read` | call |
| 1078 | `needs:open-uri` | loadpath |
| 1066 | `needs:date` | loadpath |
| 1057 | `unresolved:body` | call |
| 1043 | `needs:cgi` | loadpath |
| 1038 | `unresolved:to_sym` | call |
| 1033 | `needs:base64` | loadpath |
| 1025 | `unresolved:dup` | call |
| 955 | `needs:active_record` | loadpath |
| 944 | `unresolved:name` | call |
| 928 | `unresolved:find` | call |
| 912 | `unresolved:sort` | call |
| 894 | `needs:ostruct` | loadpath |
| 865 | `needs:openssl` | loadpath |
| 863 | `unresolved:collect` | call |
| 859 | `needs:httparty` | loadpath |
| 857 | `unresolved:close` | call |
| 853 | `unresolved:each` | call |
| 841 | `unresolved:size` | call |
| 838 | `unresolved:match` | call |
| 830 | `unresolved:info` | call |
| 829 | `unresolved:merge!` | call |
| 817 | `needs:securerandom` | loadpath |
| 801 | `unresolved:instance_eval` | metaprog |
| 801 | `unresolved:start` | call |
| 800 | `unresolved:config` | call |
| 800 | `unresolved:to_a` | call |
| 797 | `unresolved:any?` | call |
| 784 | `const_missing` | metaprog |
| 776 | `unresolved:load_file` | call |
| 761 | `unresolved:shift` | call |
| 747 | `unresolved:strip` | call |
| 736 | `unresolved:logger` | call |
| 734 | `unresolved:puts` | call |
| 729 | `unresolved:mkdir_p` | call |
| 722 | `needs:faraday` | loadpath |
| 720 | `unresolved:register` | call |
| 717 | `unresolved:respond_to?` | call |
| 713 | `unresolved:const_get` | call |
| 707 | `unresolved:debug` | call |
| 706 | `unresolved:instance` | call |
| 698 | `unresolved:to_json` | call |
| 684 | `needs:socket` | loadpath |
| 677 | `unresolved:last` | call |
| 666 | `unresolved:write` | call |
| 661 | `unresolved:path` | call |
| 649 | `unresolved:code` | call |
| 646 | `unresolved:downcase` | call |
| 645 | `unresolved:post` | call |
| 623 | `unresolved:setup` | call |
| 621 | `unresolved:key?` | call |
