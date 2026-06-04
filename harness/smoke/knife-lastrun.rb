# Smoke test for knife-lastrun 0.0.8
# Stubs the Chef + HighLine deps so the gem's own logic can run standalone.

# Minimal HighLine stub
module HighLine
  STYLES = { bold: "\e[1m", reset: "\e[0m" }

  class << self
    def new
      Instance.new
    end
  end

  class Instance
    def color(text, *styles)
      "[#{styles.join(',')}:#{text}]"
    end

    def list(items, _layout = :rows, _cols = nil)
      items.join(" | ")
    end
  end
end

# Minimal Chef stub
module Chef
  class Handler; end
  module Log
    def self.debug(msg); end
    def self.warn(msg); end
  end
  class Knife
    def self.banner(b); end
    def self.deps(&block); end
    def ui
      @ui ||= UI.new
    end
    def name_args; []; end
  end
  class UI
    def msg(text); puts text; end
    def error(text); $stderr.puts text; end
  end
end

require 'knife-lastrun/version'
require 'chef/knife/lastrun'

# --- 1. VERSION ---
puts Knife::NodeLastrun::VERSION

# --- 2. header method produces color-tagged headers ---
plugin = GoulahPlugins::NodeLastrun.new
result = plugin.header('Status', 'Elapsed Time', 'Start Time', 'End Time')
puts result.length
puts result.first
puts result.last

# --- 3. Exercise the HighLine list formatting that header feeds into ---
h = HighLine.new
entries = plugin.header('Recipe', 'Action', 'Resource Type', 'Resource')
entries << "myapp::default"
entries << "run"
entries << "bash"
entries << "check-env"
formatted = h.list(entries, :uneven_columns_across, 4)
puts formatted
