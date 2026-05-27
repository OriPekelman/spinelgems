# Spinel gem-compatibility survey

- engine rev: `git:2183a92+dirty/aarch64-linux-gnu`
- gems surveyed: **9747**
- compatible (clean+verified): **1165** (12.0%)  ·  risky: 1060  ·  rejected: 7522

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 1588 | `new` |
| 1131 | `[]` |
| 539 | `expand_path` |
| 438 | `add_identifier` |
| 392 | `empty?` |
| 379 | `include?` |
| 366 | `join` |
| 334 | `parse` |
| 251 | `call` |
| 249 | `first` |
| 233 | `delete` |
| 229 | `split` |
| 214 | `dirname` |
| 214 | `unshift` |
| 205 | `extend` |
| 201 | `length` |
| 200 | `include` |
| 191 | `dup` |
| 179 | `merge` |
| 170 | `match` |
| 154 | `gsub` |
| 150 | `keys` |
| 146 | `any?` |
| 144 | `respond_to?` |
| 140 | `key?` |
| 134 | `to_a` |
| 133 | `load` |
| 132 | `on_load` |
| 132 | `sort` |
| 128 | `name` |
| 127 | `read` |
| 125 | `to_sym` |
| 123 | `size` |
| 120 | `open` |
| 115 | `logger` |
| 112 | `merge!` |
| 111 | `find` |
| 109 | `config` |
| 108 | `require_relative` |
| 107 | `last` |
| 103 | `close` |
| 103 | `warn` |
| 102 | `Array` |
| 102 | `glob` |
| 99 | `body` |
| 99 | `collect` |
| 97 | `each` |
| 97 | `fetch` |
| 96 | `synchronize` |
| 94 | `const_get` |
| 94 | `shift` |
| 92 | `lambda` |
| 92 | `path` |
| 92 | `strip` |
| 86 | `gsub!` |
| 86 | `register` |
| 85 | `puts` |
| 84 | `setup` |
| 83 | `prepend` |
| 82 | `current` |
| 82 | `debug` |
| 81 | `instance` |
| 80 | `to_s` |
| 79 | `to_h` |
| 79 | `version` |
| 78 | `pack` |
| 77 | `flatten` |
| 73 | `===` |
| 73 | `downcase` |
| 72 | `uniq` |
| 71 | `get` |
| 71 | `mkdir_p` |
| 70 | `class` |
| 70 | `count` |
| 68 | `const_defined?` |
| 68 | `pop` |
| 68 | `sort_by` |
| 68 | `start_with?` |
| 67 | `configure` |
| 67 | `start` |
| 67 | `values` |
| 66 | `unpack` |
| 65 | `code` |
| 65 | `hexdigest` |
| 65 | `info` |
| 64 | `error` |
| 63 | `instance_variable_set` |
| 63 | `write` |
| 62 | `compact` |
| 62 | `dump` |
| 62 | `reverse` |
| 61 | `index` |
| 60 | `map!` |
| 60 | `scan` |
| 59 | `has_key?` |
| 59 | `object_id` |
| 59 | `sub` |
| 58 | `all?` |
| 58 | `clear` |
| 58 | `push` |
| 58 | `to_json` |
| 57 | `present?` |
| 56 | `message` |
| 56 | `value` |
| 55 | `fail` |
| 55 | `with_index` |
| 54 | `level=` |
| 54 | `root` |
| 53 | `env` |
| 53 | `exist?` |
| 53 | `run` |
| 53 | `update` |
| 52 | `use_ssl=` |
| 51 | `for_gem` |
| 50 | `load_file` |
| 49 | `children` |
| 49 | `encode` |
| 48 | `instance_variable_get` |
| 48 | `pwd` |
| 47 | `+@` |
| 46 | `blank?` |
| 46 | `each_key` |
| 46 | `request` |
| 45 | `delete_if` |
| 45 | `inspect` |
| 45 | `options` |
| 43 | `parent` |
| 43 | `status` |
| 42 | `add` |
| 42 | `arity` |
| 42 | `gem` |
| 42 | `scheme` |
| 41 | `concat` |
| 41 | `headers` |
| 41 | `host` |
| 41 | `ignore` |
| 41 | `post` |
| 40 | `generate` |
| 40 | `map` |
| 40 | `sub!` |
| 39 | `execute` |
| 39 | `replace` |
| 39 | `to_f` |
| 38 | `application` |
| 38 | `configuration` |
| 38 | `end_with?` |
| 37 | `exists?` |
| 36 | `URI` |
| 36 | `__dir__` |
| 36 | `backtrace` |
| 36 | `slice` |
| 35 | `match?` |
| 35 | `type` |
| 34 | `autoload` |
| 34 | `body=` |
| 34 | `method` |
| 33 | `[]=` |
| 33 | `each_value` |
| 33 | `force_encoding` |
| 33 | `hash` |
| 33 | `strftime` |
| 33 | `success?` |
| 33 | `tty?` |
| 33 | `verify_mode=` |
| 32 | `attributes` |
| 32 | `build` |
| 32 | `detect` |
| 32 | `port` |
| 32 | `reject!` |
| 32 | `upcase` |
| 31 | `clone` |
| 31 | `digest` |
| 31 | `print` |
| 31 | `round` |
| 31 | `text` |
| 30 | `create` |
| 30 | `each_line` |
| 30 | `each_with_index` |
| 30 | `escape` |
| 30 | `formatter=` |
| 30 | `instance_methods` |
| 30 | `singleton_class` |
| 30 | `source` |
| 29 | `all` |
| 29 | `decode` |
| 29 | `loaded_specs` |
| 29 | `url` |
| 29 | `uuid` |
| 28 | `extname` |
| 28 | `flush` |
| 28 | `result` |
| 28 | `safe_load` |
| 28 | `to_hash` |
| 28 | `to_set` |
| 28 | `tr` |
| 27 | `caller` |
| 27 | `chdir` |
| 27 | `inflector` |
| 27 | `read_timeout=` |
| 27 | `select` |

Showing 200 of **8043** distinct candidate calls (33941 occurrences). Set `SPINEL_REPORT_CALLS=0` for the full list.

## Blockers by category

| occurrences | category |
|---|---|
| 33941 | candidate core/stdlib calls (above) |
| 11850 | metaprogramming / reflection — out of scope |
| 50291 | no load path: `require` + `needs:` — probe limitation |
| 2097 | analyzer failed / timed out — compiler hardening |
| 272 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 2882 | `send` | metaprog |
| 2801 | `unresolved:require` | loadpath |
| 2071 | `analyze-failed` | robustness |
| 1632 | `define_method` | metaprog |
| 1588 | `unresolved:new` | call |
| 1461 | `class_eval` | metaprog |
| 1313 | `method_missing` | metaprog |
| 1131 | `unresolved:[]` | call |
| 1091 | `instance_eval` | metaprog |
| 776 | `public_send` | metaprog |
| 767 | `binding` | metaprog |
| 671 | `needs:json` | loadpath |
| 539 | `unresolved:expand_path` | call |
| 493 | `eval` | metaprog |
| 486 | `respond_to_missing` | metaprog |
| 448 | `needs:aws-sdk-core` | loadpath |
| 442 | `needs:aws-sigv4` | loadpath |
| 438 | `unresolved:add_identifier` | call |
| 392 | `unresolved:empty?` | call |
| 379 | `unresolved:include?` | call |
| 366 | `unresolved:join` | call |
| 334 | `unresolved:parse` | call |
| 272 | `c-extension` | cext |
| 251 | `unresolved:call` | call |
| 249 | `objectspace` | metaprog |
| 249 | `unresolved:first` | call |
| 233 | `unresolved:delete` | call |
| 232 | `needs:logger` | loadpath |
| 229 | `unresolved:split` | call |
| 223 | `needs:yaml` | loadpath |
| 218 | `needs:tencentcloud-sdk-common` | loadpath |
| 214 | `unresolved:dirname` | call |
| 214 | `unresolved:unshift` | call |
| 205 | `unresolved:extend` | call |
| 202 | `needs:uri` | loadpath |
| 201 | `unresolved:length` | call |
| 200 | `unresolved:include` | call |
| 197 | `needs:time` | loadpath |
| 197 | `unresolved:send` | metaprog |
| 192 | `needs:active_support` | loadpath |
| 191 | `unresolved:dup` | call |
| 186 | `needs:pathname` | loadpath |
| 179 | `unresolved:merge` | call |
| 170 | `unresolved:match` | call |
| 169 | `needs:fileutils` | loadpath |
| 162 | `const_missing` | metaprog |
| 154 | `unresolved:gsub` | call |
| 150 | `needs:base64` | loadpath |
| 150 | `unresolved:keys` | call |
| 148 | `needs:openssl` | loadpath |
| 147 | `needs:net/http` | loadpath |
| 146 | `unresolved:any?` | call |
| 144 | `unresolved:respond_to?` | call |
| 140 | `unresolved:key?` | call |
| 139 | `needs:securerandom` | loadpath |
| 137 | `unresolved:class_eval` | metaprog |
| 134 | `unresolved:to_a` | call |
| 133 | `needs:date` | loadpath |
| 133 | `unresolved:load` | call |
| 132 | `unresolved:on_load` | call |
| 132 | `unresolved:sort` | call |
| 128 | `unresolved:name` | call |
| 127 | `unresolved:read` | call |
| 125 | `needs:cgi` | loadpath |
| 125 | `unresolved:to_sym` | call |
| 123 | `unresolved:size` | call |
| 120 | `unresolved:open` | call |
| 115 | `unresolved:logger` | call |
| 112 | `needs:active_record` | loadpath |
| 112 | `unresolved:merge!` | call |
| 111 | `unresolved:find` | call |
| 109 | `unresolved:config` | call |
| 108 | `unresolved:require_relative` | call |
| 107 | `unresolved:last` | call |
| 105 | `needs:socket` | loadpath |
| 103 | `unresolved:close` | call |
| 103 | `unresolved:warn` | call |
| 102 | `unresolved:Array` | call |
| 102 | `unresolved:glob` | call |
| 99 | `needs:nokogiri` | loadpath |
| 99 | `unresolved:body` | call |
| 99 | `unresolved:collect` | call |
| 97 | `unresolved:each` | call |
| 97 | `unresolved:fetch` | call |
| 96 | `unresolved:synchronize` | call |
| 94 | `unresolved:const_get` | call |
| 94 | `unresolved:shift` | call |
| 92 | `needs:rubygems` | loadpath |
| 92 | `unresolved:lambda` | call |
| 92 | `unresolved:path` | call |
| 92 | `unresolved:strip` | call |
| 86 | `needs:thread` | loadpath |
| 86 | `unresolved:gsub!` | call |
| 86 | `unresolved:register` | call |
| 85 | `unresolved:puts` | call |
| 84 | `unresolved:setup` | call |
| 83 | `unresolved:prepend` | call |
| 82 | `unresolved:current` | call |
| 82 | `unresolved:debug` | call |
| 81 | `unresolved:instance` | call |
