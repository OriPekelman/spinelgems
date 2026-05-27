# Spinel gem-compatibility survey

- engine rev: `git:2183a92+dirty/aarch64-linux-gnu`
- gems surveyed: **6244**
- compatible (clean+verified): **1203** (19.3%)  ·  risky: 424  ·  rejected: 4617

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 945 | `new` |
| 680 | `[]` |
| 264 | `parse` |
| 224 | `include?` |
| 207 | `empty?` |
| 205 | `unshift` |
| 202 | `expand_path` |
| 183 | `join` |
| 151 | `first` |
| 148 | `dirname` |
| 143 | `extend` |
| 142 | `length` |
| 130 | `include` |
| 125 | `split` |
| 123 | `open` |
| 117 | `call` |
| 114 | `delete` |
| 107 | `match` |
| 106 | `body` |
| 100 | `get` |
| 91 | `load` |
| 88 | `glob` |
| 88 | `read` |
| 82 | `gsub` |
| 79 | `to_sym` |
| 76 | `exists?` |
| 71 | `close` |
| 71 | `merge` |
| 70 | `strip` |
| 68 | `each` |
| 65 | `sort` |
| 63 | `mkdir_p` |
| 61 | `keys` |
| 59 | `config` |
| 58 | `gsub!` |
| 58 | `name` |
| 57 | `any?` |
| 57 | `code` |
| 57 | `merge!` |
| 57 | `register` |
| 57 | `to_a` |
| 56 | `find` |
| 56 | `to_json` |
| 55 | `size` |
| 54 | `post` |
| 53 | `collect` |
| 53 | `path` |
| 53 | `puts` |
| 52 | `dup` |
| 52 | `logger` |
| 52 | `request` |
| 51 | `load_file` |
| 51 | `start` |
| 49 | `shift` |
| 48 | `downcase` |
| 48 | `info` |
| 48 | `write` |
| 47 | `setup` |
| 46 | `Array` |
| 45 | `URI` |
| 45 | `key?` |
| 44 | `dump` |
| 43 | `const_get` |
| 43 | `instance` |
| 43 | `push` |
| 42 | `last` |
| 42 | `respond_to?` |
| 42 | `reverse` |
| 42 | `use_ssl=` |
| 41 | `fetch` |
| 40 | `pwd` |
| 39 | `compact` |
| 39 | `exist?` |
| 39 | `scan` |
| 39 | `synchronize` |
| 39 | `uniq` |
| 38 | `HTML` |
| 38 | `body=` |
| 37 | `instance_variable_set` |
| 37 | `to_h` |
| 36 | `gem` |
| 36 | `hexdigest` |
| 36 | `message` |
| 36 | `root` |
| 36 | `with_index` |
| 35 | `blank?` |
| 35 | `count` |
| 35 | `text` |
| 34 | `class` |
| 34 | `flatten` |
| 34 | `index` |
| 34 | `lambda` |
| 33 | `require_relative` |
| 33 | `run` |
| 32 | `css` |
| 32 | `debug` |
| 32 | `search` |
| 32 | `sort_by` |
| 31 | `clear` |
| 31 | `const_defined?` |
| 31 | `error` |
| 31 | `extname` |
| 31 | `to_s` |
| 30 | `success?` |
| 29 | `level=` |
| 28 | `has_key?` |
| 28 | `options` |
| 28 | `strftime` |
| 28 | `warn` |
| 27 | `add` |
| 27 | `configuration` |
| 27 | `mkdir` |
| 27 | `pack` |
| 27 | `sub` |
| 26 | `configure` |
| 26 | `generate` |
| 26 | `on_load` |
| 26 | `pop` |
| 26 | `status` |
| 25 | `all?` |
| 25 | `children` |
| 25 | `for_gem` |
| 25 | `gets` |
| 25 | `present?` |
| 25 | `start_with?` |
| 25 | `unpack` |
| 24 | `clone` |
| 24 | `create` |
| 24 | `map!` |
| 24 | `max` |
| 24 | `update` |
| 23 | `all` |
| 23 | `each_line` |
| 23 | `fail` |
| 23 | `result` |
| 22 | `execute` |
| 22 | `host` |
| 22 | `value` |
| 22 | `values` |
| 21 | `constantize` |
| 21 | `delete_if` |
| 21 | `flush` |
| 21 | `instance_variable_get` |
| 21 | `query=` |
| 21 | `type` |
| 21 | `xpath` |
| 20 | `===` |
| 20 | `connect` |
| 20 | `connection` |
| 20 | `data` |
| 20 | `each_with_index` |
| 20 | `encode` |
| 20 | `headers` |
| 20 | `pretty_generate` |
| 20 | `print` |
| 20 | `red` |
| 20 | `to_yaml` |
| 19 | `method` |
| 19 | `render` |
| 19 | `strict_encode64` |
| 18 | `chdir` |
| 18 | `define_singleton_method` |
| 18 | `escape` |
| 18 | `object_id` |
| 18 | `upcase` |
| 17 | `application` |
| 17 | `current` |
| 17 | `green` |
| 17 | `hash` |
| 17 | `readlines` |
| 17 | `round` |
| 17 | `scheme` |
| 17 | `set` |
| 17 | `verify_mode=` |
| 16 | `XML` |
| 16 | `[]=` |
| 16 | `add_identifier` |
| 16 | `exit` |
| 16 | `id` |
| 16 | `instance_variables` |
| 16 | `kill` |
| 16 | `map` |
| 16 | `min` |
| 16 | `rewind` |
| 16 | `sub!` |
| 16 | `to_f` |
| 15 | `attributes` |
| 15 | `build` |
| 15 | `foreach` |
| 15 | `get_response` |
| 15 | `query` |
| 15 | `read_timeout=` |
| 15 | `response` |
| 15 | `url` |
| 15 | `where` |
| 14 | `backtrace` |
| 14 | `chomp` |
| 14 | `detect` |
| 14 | `end_with?` |
| 14 | `env` |

Showing 200 of **4461** distinct candidate calls (17558 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 17558 | candidate core/stdlib calls (above) |
| 4650 | metaprogramming / reflection — out of scope |
| 21780 | no load path: `require` + `needs:` — probe limitation |
| 1102 | analyzer failed / timed out — compiler hardening |
| 106 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 2147 | `unresolved:require` | loadpath |
| 1190 | `send` | metaprog |
| 1094 | `analyze-failed` | robustness |
| 945 | `unresolved:new` | call |
| 680 | `unresolved:[]` | call |
| 638 | `define_method` | metaprog |
| 569 | `method_missing` | metaprog |
| 559 | `class_eval` | metaprog |
| 453 | `instance_eval` | metaprog |
| 368 | `needs:json` | loadpath |
| 324 | `binding` | metaprog |
| 264 | `unresolved:parse` | call |
| 237 | `eval` | metaprog |
| 224 | `unresolved:include?` | call |
| 207 | `unresolved:empty?` | call |
| 205 | `unresolved:unshift` | call |
| 202 | `unresolved:expand_path` | call |
| 187 | `needs:yaml` | loadpath |
| 183 | `unresolved:join` | call |
| 176 | `public_send` | metaprog |
| 151 | `unresolved:first` | call |
| 148 | `unresolved:dirname` | call |
| 143 | `needs:net/http` | loadpath |
| 143 | `unresolved:extend` | call |
| 142 | `unresolved:length` | call |
| 137 | `needs:uri` | loadpath |
| 130 | `unresolved:include` | call |
| 125 | `unresolved:split` | call |
| 123 | `unresolved:open` | call |
| 121 | `needs:fileutils` | loadpath |
| 118 | `needs:logger` | loadpath |
| 117 | `unresolved:call` | call |
| 115 | `needs:nokogiri` | loadpath |
| 114 | `unresolved:delete` | call |
| 110 | `unresolved:send` | metaprog |
| 107 | `unresolved:match` | call |
| 106 | `c-extension` | cext |
| 106 | `unresolved:body` | call |
| 105 | `needs:open-uri` | loadpath |
| 103 | `needs:rubygems` | loadpath |
| 102 | `respond_to_missing` | metaprog |
| 100 | `unresolved:get` | call |
| 91 | `unresolved:load` | call |
| 88 | `unresolved:glob` | call |
| 88 | `unresolved:read` | call |
| 82 | `unresolved:gsub` | call |
| 79 | `needs:time` | loadpath |
| 79 | `unresolved:to_sym` | call |
| 76 | `needs:httparty` | loadpath |
| 76 | `unresolved:exists?` | call |
| 73 | `needs:active_support` | loadpath |
| 71 | `unresolved:close` | call |
| 71 | `unresolved:merge` | call |
| 70 | `unresolved:strip` | call |
| 68 | `needs:base64` | loadpath |
| 68 | `unresolved:each` | call |
| 67 | `objectspace` | metaprog |
| 65 | `unresolved:sort` | call |
| 64 | `needs:date` | loadpath |
| 64 | `needs:pathname` | loadpath |
| 64 | `unresolved:class_eval` | metaprog |
| 63 | `needs:faraday` | loadpath |
| 63 | `unresolved:mkdir_p` | call |
| 62 | `needs:cgi` | loadpath |
| 61 | `unresolved:keys` | call |
| 59 | `unresolved:config` | call |
| 58 | `unresolved:gsub!` | call |
| 58 | `unresolved:name` | call |
| 57 | `unresolved:any?` | call |
| 57 | `unresolved:code` | call |
| 57 | `unresolved:merge!` | call |
| 57 | `unresolved:register` | call |
| 57 | `unresolved:to_a` | call |
| 56 | `unresolved:find` | call |
| 56 | `unresolved:to_json` | call |
| 55 | `unresolved:size` | call |
| 54 | `needs:openssl` | loadpath |
| 54 | `unresolved:post` | call |
| 53 | `unresolved:collect` | call |
| 53 | `unresolved:path` | call |
| 53 | `unresolved:puts` | call |
| 52 | `unresolved:dup` | call |
| 52 | `unresolved:logger` | call |
| 52 | `unresolved:request` | call |
| 51 | `needs:active_record` | loadpath |
| 51 | `needs:ostruct` | loadpath |
| 51 | `unresolved:load_file` | call |
| 51 | `unresolved:start` | call |
| 49 | `unresolved:shift` | call |
| 48 | `needs:csv` | loadpath |
| 48 | `needs:securerandom` | loadpath |
| 48 | `unresolved:downcase` | call |
| 48 | `unresolved:info` | call |
| 48 | `unresolved:instance_eval` | metaprog |
| 48 | `unresolved:write` | call |
| 47 | `unresolved:setup` | call |
| 46 | `unresolved:Array` | call |
| 45 | `unresolved:URI` | call |
| 45 | `unresolved:key?` | call |
| 44 | `unresolved:dump` | call |
