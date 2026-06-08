module Bundler
  module Spinel
    # 0.3.0: `spinel-compat vendor` grows build-units (cmake/make native deps
    # built inside the consumer's vendor tree — heavy-native gems like toy's
    # ggml vendor self-contained + relocatable, #14), and a new
    # `spinel-compat why <gem>` legible diagnostic (#12).
    VERSION = "0.3.0"
  end
end
