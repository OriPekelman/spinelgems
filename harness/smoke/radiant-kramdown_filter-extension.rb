# Smoke for radiant-kramdown_filter-extension
# The gem entry point (lib/radiant-kramdown_filter-extension.rb) is empty (0 bytes).
# The real KramdownFilter class requires Radiant CMS framework + kramdown — neither
# is self-contained. We replicate the pure options-hash logic inline to exercise
# the type-coercion rules the gem implements, without framework or external gem deps.

require 'radiant-kramdown_filter-extension'

# Replicate the options configuration logic from lib/kramdown_filter.rb
# (the only pure-Ruby logic in this gem — the rest delegates to Radiant+Kramdown)
def build_kramdown_options(config_overrides = {})
  o = {
    :auto_ids                   => { :default => true,               :type => :boolean },
    :auto_id_prefix             => { :default => '',                 :type => :string  },
    :parse_block_html           => { :default => false,              :type => :boolean },
    :parse_span_html            => { :default => true,               :type => :boolean },
    :footnote_nr                => { :default => 1,                  :type => :integer },
    :coderay_wrap               => { :default => :div,               :type => :symbol  },
    :coderay_line_numbers       => { :default => :inline,            :type => :symbol  },
    :coderay_line_number_start  => { :default => 1,                  :type => :integer },
    :coderay_tab_width          => { :default => 0,                  :type => :integer },
    :coderay_bold_every         => { :default => 10,                 :type => :integer },
    :coderay_css                => { :default => :style,             :type => :symbol  },
    :entity_output              => { :default => :as_char,           :type => :symbol  },
    :toc_levels                 => { :default => [1, 2, 3, 4, 5, 6], :type => :array   }
  }
  # Apply overrides using the gem's type-coercion logic
  o.keys.each do |key|
    val = config_overrides["kramdown.#{key}"]
    next unless val
    case o[key][:type]
    when :boolean
      o[key][:default] = (val == "true")
    when :integer
      o[key][:default] = val.to_i
    when :string
      o[key][:default] = val
    when :symbol
      o[key][:default] = val != "nil" ? val.to_sym : nil
    end
  end
  o
end

# Test 1: default options (no overrides)
opts = build_kramdown_options
puts "option_count: #{opts.keys.length}"
puts "auto_ids_default: #{opts[:auto_ids][:default]}"
puts "parse_block_html_default: #{opts[:parse_block_html][:default]}"
puts "toc_levels_default: #{opts[:toc_levels][:default].inspect}"
puts "entity_output_default: #{opts[:entity_output][:default]}"
puts "footnote_nr_default: #{opts[:footnote_nr][:default]}"

# Test 2: boolean override "false"
opts2 = build_kramdown_options("kramdown.auto_ids" => "false")
puts "auto_ids_overridden: #{opts2[:auto_ids][:default]}"

# Test 3: integer override
opts3 = build_kramdown_options("kramdown.footnote_nr" => "5")
puts "footnote_nr_overridden: #{opts3[:footnote_nr][:default]}"

# Test 4: symbol override and nil symbol
opts4 = build_kramdown_options(
  "kramdown.coderay_wrap" => "span",
  "kramdown.coderay_line_numbers" => "nil"
)
puts "coderay_wrap_overridden: #{opts4[:coderay_wrap][:default]}"
puts "coderay_line_numbers_nil: #{opts4[:coderay_line_numbers][:default].inspect}"
