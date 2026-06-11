export const meta = {
  name: 'spinelgems-harvest11-cb23cc6',
  description: 'Harvest #11: behaviour smokes for 200 top-ranked unsmoked loaded gems @ cb23cc6; verify --full or attribute the failure (bug vs known limit). NO upstream filing this round.',
  phases: [{ title: 'Smoke', detail: 'one agent per gem: read source, write smoke, verify, classify' }],
}

const GEMS =
[
  {
    "g": "rails-deprecated_sanitizer",
    "v": "1.0.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rails-deprecated_sanitizer-1.0.4"
  },
  {
    "g": "case_transform",
    "v": "0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/case_transform-0.2"
  },
  {
    "g": "after_commit_action",
    "v": "1.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/after_commit_action-1.1.0"
  },
  {
    "g": "utf8-cleaner",
    "v": "2.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/utf8-cleaner-2.0.1"
  },
  {
    "g": "fresh_connection",
    "v": "3.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/fresh_connection-3.1.3"
  },
  {
    "g": ".cat",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/.cat-0.0.1"
  },
  {
    "g": "zubi-test",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/zubi-test-0.0.1"
  },
  {
    "g": "ruby",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ruby-0.1.0"
  },
  {
    "g": "require_relative",
    "v": "1.0.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/require_relative-1.0.3"
  },
  {
    "g": "a",
    "v": "0.2.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/a-0.2.8"
  },
  {
    "g": "A-",
    "v": "0.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/A--0.0.0"
  },
  {
    "g": "a--",
    "v": "10.25.60",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/a---10.25.60"
  },
  {
    "g": "any",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/any-0.1.0"
  },
  {
    "g": "loc",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/loc-0.1.1"
  },
  {
    "g": "test_rubygem",
    "v": "0.0.22",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/test_rubygem-0.0.22"
  },
  {
    "g": "thincloud-test",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/thincloud-test-1.0.0"
  },
  {
    "g": "firstGem",
    "v": "0.0.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/firstGem-0.0.3"
  },
  {
    "g": "ped",
    "v": "0.2.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ped-0.2.1"
  },
  {
    "g": "git_log_generator",
    "v": "0.0.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/git_log_generator-0.0.5"
  },
  {
    "g": "borda",
    "v": "0.0.16",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/borda-0.0.16"
  },
  {
    "g": "acme",
    "v": "0.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/acme-0.3.0"
  },
  {
    "g": "full_lengther_next",
    "v": "1.0.6",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/full_lengther_next-1.0.6"
  },
  {
    "g": "caution",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/caution-1.0.0"
  },
  {
    "g": "rack-authenticate",
    "v": "0.6.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rack-authenticate-0.6.0"
  },
  {
    "g": "phenix",
    "v": "1.4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/phenix-1.4.0"
  },
  {
    "g": "mtncd",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mtncd-0.2.0"
  },
  {
    "g": "ibotta_geohash",
    "v": "0.2.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ibotta_geohash-0.2.1"
  },
  {
    "g": "puppetfile-updater",
    "v": "0.6.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/puppetfile-updater-0.6.0"
  },
  {
    "g": "hrk",
    "v": "1.0.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/hrk-1.0.8"
  },
  {
    "g": "allpay_client",
    "v": "2.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/allpay_client-2.0.2"
  },
  {
    "g": "rbrainz",
    "v": "0.5.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rbrainz-0.5.2"
  },
  {
    "g": "valigator-csv",
    "v": "4.2.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/valigator-csv-4.2.1"
  },
  {
    "g": "google-analytics-data-v1alpha",
    "v": "0.8.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/google-analytics-data-v1alpha-0.8.3"
  },
  {
    "g": "rubocop-github-annotations-formatter",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rubocop-github-annotations-formatter-0.1.0"
  },
  {
    "g": "jt-mobile-kit",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jt-mobile-kit-1.2.0"
  },
  {
    "g": "string-present-blank",
    "v": "0.0.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/string-present-blank-0.0.3"
  },
  {
    "g": "convore-simple",
    "v": "0.0.11",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/convore-simple-0.0.11"
  },
  {
    "g": "aslon_settings",
    "v": "0.1.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aslon_settings-0.1.8"
  },
  {
    "g": "dev_environment",
    "v": "0.0.15",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dev_environment-0.0.15"
  },
  {
    "g": "retry-this",
    "v": "1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/retry-this-1.1"
  },
  {
    "g": "gitlab_ci_meta",
    "v": "4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gitlab_ci_meta-4.0"
  },
  {
    "g": "ab",
    "v": "0.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ab-0.0.2"
  },
  {
    "g": "dagnabit",
    "v": "3.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dagnabit-3.1.1"
  },
  {
    "g": "bumpy",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/bumpy-1.0.0"
  },
  {
    "g": "appbombado_foundation",
    "v": "0.0.12",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/appbombado_foundation-0.0.12"
  },
  {
    "g": "klassnames",
    "v": "1.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/klassnames-1.0.2"
  },
  {
    "g": "clause_extractor",
    "v": "0.1.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/clause_extractor-0.1.4"
  },
  {
    "g": "inform",
    "v": "0.0.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/inform-0.0.9"
  },
  {
    "g": "crude-mutant",
    "v": "0.6.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/crude-mutant-0.6.2"
  },
  {
    "g": "blue-shell",
    "v": "0.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/blue-shell-0.3.0"
  },
  {
    "g": "singem",
    "v": "0.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/singem-0.3.1"
  },
  {
    "g": "ci_uy",
    "v": "1.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ci_uy-1.1.0"
  },
  {
    "g": "text-interpolator",
    "v": "1.1.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/text-interpolator-1.1.9"
  },
  {
    "g": "sequel-crushyform",
    "v": "0.1.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/sequel-crushyform-0.1.4"
  },
  {
    "g": "alinta-cucumber-rest-bdd",
    "v": "0.5.23",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/alinta-cucumber-rest-bdd-0.5.23"
  },
  {
    "g": "bs_form_builder",
    "v": "0.2.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/bs_form_builder-0.2.3"
  },
  {
    "g": "on",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/on-1.0.0"
  },
  {
    "g": "transdeps",
    "v": "2.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/transdeps-2.0.0"
  },
  {
    "g": "ruby-nessus",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ruby-nessus-1.2.0"
  },
  {
    "g": "contact",
    "v": "0.0.11",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/contact-0.0.11"
  },
  {
    "g": "passwordmasker",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/passwordmasker-1.2.0"
  },
  {
    "g": "otp",
    "v": "0.0.11",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/otp-0.0.11"
  },
  {
    "g": "wm_okta_helper",
    "v": "0.2.10",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/wm_okta_helper-0.2.10"
  },
  {
    "g": "wpcli",
    "v": "0.2.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/wpcli-0.2.9"
  },
  {
    "g": "brasilapi",
    "v": "0.7.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/brasilapi-0.7.0"
  },
  {
    "g": "business-period",
    "v": "0.1.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/business-period-0.1.5"
  },
  {
    "g": "groute",
    "v": "0.1.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/groute-0.1.9"
  },
  {
    "g": "git_manager",
    "v": "0.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/git_manager-0.1.2"
  },
  {
    "g": "check_slony",
    "v": "0.0.10",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/check_slony-0.0.10"
  },
  {
    "g": "arbiter",
    "v": "3.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/arbiter-3.0.0"
  },
  {
    "g": "funky-simplehttp",
    "v": "0.6.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/funky-simplehttp-0.6.0"
  },
  {
    "g": "cuke_mem",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/cuke_mem-0.1.1"
  },
  {
    "g": "pdns_api",
    "v": "0.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/pdns_api-0.1.3"
  },
  {
    "g": "tvd-ssh",
    "v": "0.0.14",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/tvd-ssh-0.0.14"
  },
  {
    "g": "right_hook",
    "v": "0.5.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/right_hook-0.5.2"
  },
  {
    "g": "radiant-site_templates-extension",
    "v": "1.0.6",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/radiant-site_templates-extension-1.0.6"
  },
  {
    "g": "circlemator",
    "v": "0.6.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/circlemator-0.6.0"
  },
  {
    "g": "human_size_to_number",
    "v": "1.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/human_size_to_number-1.0.1"
  },
  {
    "g": "process",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/process-0.0.1"
  },
  {
    "g": "ost-sdk-ruby",
    "v": "2.2.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ost-sdk-ruby-2.2.3"
  },
  {
    "g": "virtus-matchers",
    "v": "0.4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/virtus-matchers-0.4.0"
  },
  {
    "g": "ping",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ping-0.1.1"
  },
  {
    "g": "ymlex",
    "v": "1.1.9.10",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ymlex-1.1.9.10"
  },
  {
    "g": "Urbanesia",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/Urbanesia-0.0.1"
  },
  {
    "g": "spinto",
    "v": "0.2.15",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/spinto-0.2.15"
  },
  {
    "g": "postgres-fulltext-search-helper",
    "v": "0.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/postgres-fulltext-search-helper-0.1.2"
  },
  {
    "g": "cache_key_for",
    "v": "0.1.11",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/cache_key_for-0.1.11"
  },
  {
    "g": "cloudq_client",
    "v": "0.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/cloudq_client-0.1.2"
  },
  {
    "g": "lucabook",
    "v": "0.5.7",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/lucabook-0.5.7"
  },
  {
    "g": "rsmart_toolbox",
    "v": "0.17",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rsmart_toolbox-0.17"
  },
  {
    "g": "mtbuild",
    "v": "0.1.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mtbuild-0.1.8"
  },
  {
    "g": "trusty-snippets-extension",
    "v": "3.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/trusty-snippets-extension-3.1.1"
  },
  {
    "g": "financial_maths",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/financial_maths-0.1.0"
  },
  {
    "g": "derp",
    "v": "1.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/derp-1.1.1"
  },
  {
    "g": "object_comparator",
    "v": "0.1.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/object_comparator-0.1.4"
  },
  {
    "g": "semantic-crawler",
    "v": "0.7.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/semantic-crawler-0.7.1"
  },
  {
    "g": "cirun",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/cirun-0.2.0"
  },
  {
    "g": "helpful_configuration",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/helpful_configuration-0.1.0"
  },
  {
    "g": "rack-commonlogger",
    "v": "2.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rack-commonlogger-2.0.0"
  },
  {
    "g": "codependency",
    "v": "2.3.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/codependency-2.3.2"
  },
  {
    "g": "catptcha",
    "v": "0.1.6",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/catptcha-0.1.6"
  },
  {
    "g": "socky",
    "v": "0.4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/socky-0.4.0"
  },
  {
    "g": "envme",
    "v": "0.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/envme-0.3.0"
  },
  {
    "g": "bind",
    "v": "0.2.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/bind-0.2.8"
  },
  {
    "g": "libring",
    "v": "1.0.14",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/libring-1.0.14"
  },
  {
    "g": "zwr",
    "v": "0.1.7",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/zwr-0.1.7"
  },
  {
    "g": "link_url",
    "v": "0.0.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/link_url-0.0.9"
  },
  {
    "g": "pry-plus-byebug",
    "v": "1.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/pry-plus-byebug-1.0.2"
  },
  {
    "g": "base_action",
    "v": "3.1.6",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/base_action-3.1.6"
  },
  {
    "g": "splittable",
    "v": "0.0.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/splittable-0.0.9"
  },
  {
    "g": "sn-revisions",
    "v": "0.2.12",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/sn-revisions-0.2.12"
  },
  {
    "g": "rise-cli",
    "v": "0.3.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rise-cli-0.3.4"
  },
  {
    "g": "baht",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/baht-0.1.1"
  },
  {
    "g": "name-generator",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/name-generator-0.2.0"
  },
  {
    "g": "castanet",
    "v": "1.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/castanet-1.0.1"
  },
  {
    "g": "resident",
    "v": "0.0.16",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/resident-0.0.16"
  },
  {
    "g": "couch",
    "v": "0.2.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/couch-0.2.1"
  },
  {
    "g": "activerecord-odbc-adapter-openedge",
    "v": "2.3.7",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/activerecord-odbc-adapter-openedge-2.3.7"
  },
  {
    "g": "ilesspainfulclient-cucumber",
    "v": "0.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ilesspainfulclient-cucumber-0.1.3"
  },
  {
    "g": "logger_pipe",
    "v": "0.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/logger_pipe-0.3.1"
  },
  {
    "g": "fortytworb",
    "v": "2.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/fortytworb-2.0.0"
  },
  {
    "g": "json-sequence",
    "v": "0.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/json-sequence-0.1.2"
  },
  {
    "g": "ns1",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ns1-0.2.0"
  },
  {
    "g": "require_pattern",
    "v": "1.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/require_pattern-1.1.2"
  },
  {
    "g": "stf-client-neofreko",
    "v": "0.1.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/stf-client-neofreko-0.1.9"
  },
  {
    "g": "camel_snake_keys",
    "v": "1.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/camel_snake_keys-1.1.0"
  },
  {
    "g": "rviz",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rviz-0.1.0"
  },
  {
    "g": "g1nn13-image_science",
    "v": "1.2.10",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/g1nn13-image_science-1.2.10"
  },
  {
    "g": "slack-utils",
    "v": "0.7.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/slack-utils-0.7.5"
  },
  {
    "g": "dir",
    "v": "0.1.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dir-0.1.2"
  },
  {
    "g": "csv_country_selector",
    "v": "1.0.10",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/csv_country_selector-1.0.10"
  },
  {
    "g": "sinatra-cmd",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/sinatra-cmd-0.1.1"
  },
  {
    "g": "ni-logger",
    "v": "0.0.17",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ni-logger-0.0.17"
  },
  {
    "g": "satoshi-unit",
    "v": "0.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/satoshi-unit-0.2.2"
  },
  {
    "g": "glossgenius_style",
    "v": "0.1.17",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/glossgenius_style-0.1.17"
  },
  {
    "g": "abaco",
    "v": "1.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/abaco-1.0.1"
  },
  {
    "g": "bookie_accounting",
    "v": "2.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/bookie_accounting-2.0.1"
  },
  {
    "g": "tts",
    "v": "0.8.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/tts-0.8.2"
  },
  {
    "g": "mtracker",
    "v": "0.3.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mtracker-0.3.4"
  },
  {
    "g": "gemify",
    "v": "0.4.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gemify-0.4.1"
  },
  {
    "g": "ormdev",
    "v": "0.2.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ormdev-0.2.3"
  },
  {
    "g": "deno92",
    "v": "0.1.22",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/deno92-0.1.22"
  },
  {
    "g": "redshift-connector-data_file",
    "v": "7.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redshift-connector-data_file-7.3.1"
  },
  {
    "g": "mail-redirector",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mail-redirector-0.0.1"
  },
  {
    "g": "farsifu",
    "v": "0.5.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/farsifu-0.5.1"
  },
  {
    "g": "activerecord-import-oracle_enhanced",
    "v": "0.1.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/activerecord-import-oracle_enhanced-0.1.5"
  },
  {
    "g": "red-plasma",
    "v": "11.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/red-plasma-11.0.0"
  },
  {
    "g": "jt_tools",
    "v": "0.0.19",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jt_tools-0.0.19"
  },
  {
    "g": "nakor",
    "v": "0.0.12",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/nakor-0.0.12"
  },
  {
    "g": "active-record-without-callbacks",
    "v": "0.0.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/active-record-without-callbacks-0.0.4"
  },
  {
    "g": "timecapsule",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/timecapsule-1.2.0"
  },
  {
    "g": "flay-haml",
    "v": "0.0.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/flay-haml-0.0.5"
  },
  {
    "g": "a1447ll_mini_test",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/a1447ll_mini_test-0.1.0"
  },
  {
    "g": "oembed",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/oembed-0.2.0"
  },
  {
    "g": "template",
    "v": "2.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/template-2.0.0"
  },
  {
    "g": "redis-store-testing",
    "v": "0.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redis-store-testing-0.0.2"
  },
  {
    "g": "gitfinger",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gitfinger-0.1.0"
  },
  {
    "g": "speedflow-plugin-test",
    "v": "0.3.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/speedflow-plugin-test-0.3.3"
  },
  {
    "g": "itunes_ingestion",
    "v": "0.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/itunes_ingestion-0.3.0"
  },
  {
    "g": "color-rgb",
    "v": "0.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/color-rgb-0.0.2"
  },
  {
    "g": "high_water_mark",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/high_water_mark-0.1.0"
  },
  {
    "g": "selendroid",
    "v": "0.4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/selendroid-0.4.0"
  },
  {
    "g": "mingle-macro-development-toolkit",
    "v": "2.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mingle-macro-development-toolkit-2.0.2"
  },
  {
    "g": "frosty_meadow",
    "v": "2.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/frosty_meadow-2.3.1"
  },
  {
    "g": "doxie",
    "v": "4.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/doxie-4.0.0"
  },
  {
    "g": "yoshida",
    "v": "0.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/yoshida-0.1.1"
  },
  {
    "g": "gz_release",
    "v": "0.0.12",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gz_release-0.0.12"
  },
  {
    "g": "pool",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/pool-0.0.1"
  },
  {
    "g": "gioco",
    "v": "1.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gioco-1.1.1"
  },
  {
    "g": "fatalistic",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/fatalistic-0.0.1"
  },
  {
    "g": "mshard",
    "v": "0.8.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mshard-0.8.0"
  },
  {
    "g": "itax_code",
    "v": "2.0.7",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/itax_code-2.0.7"
  },
  {
    "g": "rot13",
    "v": "0.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rot13-0.1.3"
  },
  {
    "g": "humanize-bytes",
    "v": "2.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/humanize-bytes-2.2.0"
  },
  {
    "g": "rack-standards",
    "v": "0.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rack-standards-0.0.1"
  },
  {
    "g": "object_identifier",
    "v": "0.11.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/object_identifier-0.11.0"
  },
  {
    "g": "dragonfly-activerecord",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dragonfly-activerecord-1.0.0"
  },
  {
    "g": "chromium",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/chromium-0.1.0"
  },
  {
    "g": "synchronized_model",
    "v": "0.3.7",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/synchronized_model-0.3.7"
  },
  {
    "g": "cuesnap",
    "v": "1.2.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/cuesnap-1.2.5"
  },
  {
    "g": "a0",
    "v": "0.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/a0-0.1.0"
  },
  {
    "g": "berta",
    "v": "2.1.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/berta-2.1.1"
  },
  {
    "g": "xdite",
    "v": "1.5.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/xdite-1.5.1"
  },
  {
    "g": "rack-env-notifier",
    "v": "0.0.6",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rack-env-notifier-0.0.6"
  },
  {
    "g": "github_repo_statistics",
    "v": "2.3.26",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/github_repo_statistics-2.3.26"
  },
  {
    "g": "enhanced-logger",
    "v": "0.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/enhanced-logger-0.2.2"
  },
  {
    "g": "Impatient",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/Impatient-1.0.0"
  },
  {
    "g": "openweathermap",
    "v": "0.2.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/openweathermap-0.2.3"
  },
  {
    "g": "text_parser",
    "v": "0.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/text_parser-0.3.0"
  },
  {
    "g": "seapig-server",
    "v": "0.2.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/seapig-server-0.2.3"
  },
  {
    "g": "open_tree_struct",
    "v": "1.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/open_tree_struct-1.0.1"
  },
  {
    "g": "device",
    "v": "0.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/device-0.0.0"
  },
  {
    "g": "simple_queues",
    "v": "1.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/simple_queues-1.3.0"
  },
  {
    "g": "wurfl_cloud_client_light",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/wurfl_cloud_client_light-1.0.0"
  },
  {
    "g": "homesteading-tasks",
    "v": "0.0.12",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/homesteading-tasks-0.0.12"
  },
  {
    "g": "radiant-locked_page_parts-extension",
    "v": "0.1.11",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/radiant-locked_page_parts-extension-0.1.11"
  },
  {
    "g": "iglu-ruby-client",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/iglu-ruby-client-0.2.0"
  },
  {
    "g": "spbtv_code_style",
    "v": "1.7.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/spbtv_code_style-1.7.0"
  },
  {
    "g": "urbanopt-rnm-us",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/urbanopt-rnm-us-1.2.0"
  },
  {
    "g": "jn_services",
    "v": "1.0.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jn_services-1.0.8"
  }
]

const REPO = '/home/oripekelman/sites/spinelgems'
const ENGINE = '/srv/data/scratch/spinelgems-rp/spinel-frozen-cb23cc6'
const LEDGER = REPO + '/ledger/harvest11.jsonl'

const SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['gem', 'outcome'],
  properties: {
    gem: { type: 'string' },
    outcome: {
      type: 'string',
      enum: ['verified', 'miscompile-bug', 'codegen-bug', 'loadpath-limit', 'risky-smoke', 'skipped'],
      description: 'verified=cruby==spinel; miscompile-bug=both run but outputs differ; codegen-bug=spinel C-compile error on ordinary Ruby with NO ignored require; loadpath-limit=failure caused by an ignored require (no X.rb)/emitting-0 — known limit, not fileable; risky-smoke=could not make a valid deterministic CRuby smoke; skipped=no testable dep-free API',
    },
    verdict: { type: 'string', description: 'raw verdict word printed by spinel-compat verify' },
    smoke_kept: { type: 'boolean', description: 'true if a smoke file was left in harness/smoke/' },
    diff: { type: 'string', description: 'for miscompile-bug: the L# cruby=.. spinel=.. diff line' },
    error_excerpt: { type: 'string', description: 'for codegen-bug: the C compiler error line(s)' },
    api_tested: { type: 'string', description: 'one-line description of the gem API the smoke exercised' },
    bug_summary: { type: 'string', description: 'for *-bug outcomes: a one-sentence, file-ready description of the Spinel defect' },
  },
}

function prompt(gem, ver, dir) {
  return `You are vetting one RubyGem for the Spinel AOT compiler's behaviour-verification harness. Your job: write a deterministic behaviour smoke that drives this gem's real API, run the differential CRuby-vs-Spinel verifier, and classify the result.

GEM: ${gem}
VERSION: ${ver}
CACHED SOURCE DIR: ${dir}
REPO ROOT: ${REPO}
SMOKE FILE TO WRITE: ${REPO}/harness/smoke/${gem}.rb

## Background you must understand

The verifier compiles a tiny program twice — once under CRuby (reference, with \`-I <dir>/lib\`) and once Spinel-compiled — and diffs stdout. It prepends \`require_relative "lib/${gem}"\` (or the dashed->slashed path) then appends your smoke body. So your smoke must assume the gem's top-level constants are already loaded.

Spinel has NO load path. Two consequences you MUST account for:
- A plain \`require "other_gem"\` or \`require "some/stdlib"\` inside the gem is IGNORED by Spinel (it prints: \`require "X" could not be resolved (no X.rb ...); the call is ignored\`). If your chosen API depends on code behind such an ignored require, Spinel will fail with \`cannot resolve call ... (emitting 0)\` and a runtime \`undefined method\`. That is the KNOWN load-path limitation, NOT a fileable bug.
- Pick an API path that lives in the entrypoint file itself (or files reachable via \`require_relative\`, which Spinel DOES inline), and that needs no external gem and no Spinel-unsupported stdlib.

## Steps

1. Inspect the source: \`ls ${dir}/lib\`, read \`${dir}/lib/${gem}.rb\` (or the dashed->slashed entry), and any \`require_relative\` files. Identify the top-level module/class and a SIMPLE, DETERMINISTIC, dependency-free method or constant you can exercise. Constants and pure string/number/array transforms are ideal. Avoid: time/date/random/RUBY_VERSION/object-ids/hash-ordering-dependent output, network, filesystem, anything needing another gem.

2. Write a short smoke (3-10 \`puts\` lines of stable output) to ${REPO}/harness/smoke/${gem}.rb. Do NOT include the require — the harness adds it. Just drive the API and print.

3. Self-check under CRuby from the repo root:
   \`cd ${REPO} && printf 'require_relative "${dir}/lib/${gem}"\\n' > /tmp/sc_${gem}.rb && cat harness/smoke/${gem}.rb >> /tmp/sc_${gem}.rb && ruby -I ${dir}/lib /tmp/sc_${gem}.rb\`
   It MUST exit 0 with non-empty deterministic output. If it errors (e.g. needs a gem you can't load) or output is non-deterministic, revise the smoke to a different API, or if nothing dep-free is testable, delete the smoke file and return outcome \`skipped\` (or \`risky-smoke\` if the gem simply has no clean CRuby-runnable surface).

4. Run the verifier (this appends to the run ledger; safe in parallel):
   \`cd ${REPO} && SPINEL_DIR=${ENGINE} SPINEL_COMPAT_LEDGER=${LEDGER} ./exe/spinel-compat verify ${gem} ${ver} --dir ${dir} --smoke ${REPO}/harness/smoke/${gem}.rb\`
   Read the final verdict line.

5. Classify into \`outcome\`:
   - \`verified\`: verdict is "verified" (cruby==spinel). KEEP the smoke file. Big win.
   - \`rejected — miscompile\`: both compiled+ran but stdout differs. This is a \`miscompile-bug\`. KEEP the smoke. Capture the \`diff:L# cruby=.. spinel=..\` line into \`diff\`. Write a one-sentence \`bug_summary\`.
   - \`rejected — build-or-run-error\`: inspect WHY. Recompile manually to see warnings:
     \`cd ${dir} && printf 'require_relative "lib/${gem}"\\n' > __sp.rb && cat ${REPO}/harness/smoke/${gem}.rb >> __sp.rb && ${ENGINE}/spinel __sp.rb -o __sp.bin 2>&1 | head -20 ; rm -f __sp.rb __sp.bin\`
       * If you see \`could not be resolved (no X.rb)\` for an external gem/stdlib AND the failing call traces to that ignored require → \`loadpath-limit\`. DELETE the smoke file (low value). Not fileable.
       * If you see a real C compiler error (\`out.c:..: error: ...\`) on ordinary Ruby with NO relevant ignored require → \`codegen-bug\`. KEEP the smoke. Put the \`error:\` line in \`error_excerpt\` and a one-sentence \`bug_summary\`.
   - \`risky\` (smoke-error:cruby): your smoke is broken under CRuby. Try once more to fix it; if still broken, delete the smoke and return \`risky-smoke\`.

6. Set \`smoke_kept\` accurately. Return the structured result. Keep it tight — do not over-investigate; ~one verify + at most one manual recompile. Do NOT file any GitHub issues — bank bug evidence in the structured result only.`
}

phase('Smoke')
const results = await pipeline(
  GEMS,
  (item) => agent(prompt(item.g, item.v, item.d), {
    label: `smoke:${item.g}`,
    phase: 'Smoke',
    model: 'sonnet',
    schema: SCHEMA,
  }),
)

const ok = results.filter(Boolean)
const by = (o) => ok.filter((r) => r.outcome === o)
const summary = {
  total: GEMS.length,
  returned: ok.length,
  verified: by('verified').map((r) => r.gem),
  miscompile_bugs: by('miscompile-bug').map((r) => ({ gem: r.gem, diff: r.diff, bug: r.bug_summary })),
  codegen_bugs: by('codegen-bug').map((r) => ({ gem: r.gem, error: r.error_excerpt, bug: r.bug_summary })),
  loadpath_limit: by('loadpath-limit').length,
  risky_smoke: by('risky-smoke').length,
  skipped: by('skipped').length,
}
log(`verified=${summary.verified.length} miscompile=${summary.miscompile_bugs.length} codegen=${summary.codegen_bugs.length} loadpath=${summary.loadpath_limit} risky=${summary.risky_smoke} skipped=${summary.skipped}`)
return summary
