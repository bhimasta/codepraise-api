# frozen_string_literal: true

module CodePraise
  module Blame
    # Parses git blame porcelain: https://git-scm.com/docs/git-blame/1.6.0
    module Porcelain
      CODE_LINE_REGEX = /(\n\t[^\n]*\n)/
      NEWLINE = "\n"

      def self.parse_file_blame(output)
        Porcelain.split_porcelain_by_line(output)
                 .map { |line| Porcelain.parse_porcelain_line(line) }
      end

      def self.split_porcelain_by_line(output)
        header_code = output.split(CODE_LINE_REGEX)
        header_code.each_slice(2).map(&:join)
      rescue StandardError
        raise 'blame line parsing failed'
      end

      def self.parse_porcelain_line(porcelain)
        line_block = porcelain.split(NEWLINE)
        line_report = {
          'line_num' => parse_first_porcelain_line(line_block[0]),
          'code' => line_block[-1]
        }

        line_block[1..-2].each do |line|
          parsed = parse_key_value_porcelain_line(line)
          line_report[parsed[:key]] = parsed[:value] if parsed
        end

        line_report
      end

      def self.parse_first_porcelain_line(first_line)
        elements = first_line.split(/\s/)
        element_names = %w[sha linenum_original linenum_final group_count]
        [element_names].zip(elements).to_h
      end

      def self.parse_key_value_porcelain_line(line)
        line.match(/^(?<key>\S*) (?<value>.*)/)
      end
    end
  end
end
