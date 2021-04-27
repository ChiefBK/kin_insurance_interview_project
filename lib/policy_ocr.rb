module PolicyOcr
  ZERO = [[' ', '_', ' '], ['|', ' ', '|'], ['|', '_', '|']]
  ONE = [[' ', ' ', ' '], [' ', ' ', '|'], [' ', ' ', '|']]
  TWO = [[' ', '_', ' '], [' ', '_', '|'], ['|', '_', ' ']]
  THREE = [[' ', '_', ' '], [' ', '_', '|'], [' ', '_', '|']]
  FOUR = [[' ', ' ', ' '], ['|', '_', '|'], [' ', ' ', '|']]
  FIVE = [[' ', '_', ' '], ['|', '_', ' '], [' ', '_', '|']]
  SIX = [[' ', '_', ' '], ['|', '_', ' '], ['|', '_', '|']]
  SEVEN = [[' ', '_', ' '], [' ', ' ', '|'], [' ', ' ', '|']]
  EIGHT = [[' ', '_', ' '], ['|', '_', '|'], ['|', '_', '|']]
  NINE = [[' ', '_', ' '], ['|', '_', '|'], [' ', '_', '|']]

  CHARACTERS = [ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE]
  CHARACTERS_WITH_ID = CHARACTERS.each_with_index.map { |raw, i| { char: i.to_s, raw: raw } }

  class Character
    attr_reader :parsed_char

    def initialize
      @raw_data = []
      @parsed_char = nil
    end

    # Adds single line of input to build
    # After all lines are added @raw_data should be a 3x3 2D array matrix
    def add_line(char_array)
      if @raw_data.length == 3
        return
      end

      @raw_data << char_array

      if @raw_data.length == 3
        parse_char
      end
    end

    private

    def parse_char
      CHARACTERS_WITH_ID.each do |hash|
        id = hash[:char]
        raw = hash[:raw]

        if matches_char(raw)
          @parsed_char = id
          break
        end
      end

      if @parsed_char.nil?
        puts "ERROR - could not parse char"
      end
    end

    def matches_char(compare_data)
      flattened_compare = compare_data.flatten
      flattened_raw_data = @raw_data.flatten

      flattened_compare.each_with_index do |val, i|
        if val != flattened_raw_data[i]
          return false
        end
      end

      true
    end
  end

  class PolicyNumber
    attr_reader :characters

    def initialize(lines)
      @raw_data = lines
      @num_of_chars = 9
      @characters = parse_lines
    end

    def to_string
      @characters.reduce('') { |pn, char| pn += char.parsed_char }
    end

    private

    def parse_lines
      partials = []

      @raw_data.each do |line|
        line_arr = line.split('')
        partials << partial_chars(line_arr)
      end

      generate_characters(partials)
    end

    def partial_chars(line_arr)
      [
        line_arr[0...3],
        line_arr[3...6],
        line_arr[6...9],
        line_arr[9...12],
        line_arr[12...15],
        line_arr[15...18],
        line_arr[18...21],
        line_arr[21...24],
        line_arr[24...27],
      ]
    end

    def generate_characters(partials)
      characters = []
      partials_first_line = partials[0]
      partials_second_line = partials[1]
      partials_third_line = partials[2]

      @num_of_chars.times do |i|
        char = Character.new
        char.add_line(partials_first_line[i])
        char.add_line(partials_second_line[i])
        char.add_line(partials_third_line[i])

        characters << char
      end

      characters
    end
  end

  def self.parse_file(file_path)
    line_number = 1
    policy_numbers = []
    next_policy_number_lines = []

    File.foreach(file_path) do |line|
      if line_number % 4 == 0
        policy_numbers << PolicyNumber.new(next_policy_number_lines)
        next_policy_number_lines = []
        line_number += 1
        next
      end

      next_policy_number_lines << line.gsub("\n",'') # remove newline char
      line_number += 1
    end

    policy_numbers
  end
end
