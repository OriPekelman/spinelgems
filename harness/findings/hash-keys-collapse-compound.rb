# FILED as matz/spinel#3322 (2026-07-24). Still failing at 76cfd099.
module YarnLockParser
  class Parser
    TOKEN_TYPES = {
      boolean: "BOOLEAN",
    }.freeze
    class << self
      def parse(file_path)
        until input.empty?
          if input[0] == "\n" || input[0] == "\r"
            while token.type == TOKEN_TYPES[:comma]
            end
            if valid_prop_value_token?(token)
              keys.each do |k|
              end
            end
          end
        end
        between_quotes = /\"(.*?)\"/
        lines.each do |line|
        end
      end
    end
  end
end
puts YarnLockParser::Parser::TOKEN_TYPES.keys.sort.map(&:to_s).inspect
