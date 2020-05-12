require_relative 'TextCheckModifier'
require_relative 'player'

class Game
  include TextCheckModifier
  attr_accessor :game, :ball, :hint, :total_round
  
  @@total_round = 12
  @@ball = { red: " R ".on_red.bold, 
            blue: " B ".on_blue.bold, 
            green: " G ".on_green.bold, 
            white: " W ".black.on_white.bold,
            pink: " P ".on_yellow.bold,
            cyan: " C ".black.on_cyan.bold,
            dark: " D ".bold,
            magenta: " M ".on_magenta.bold }
  @@hint = { correct_place_color: "•".red.bold,
            correct_color: "•".white.bold }
  @@possible_letter = @@ball.keys.map{|word| word = word[0] }
  @@last_hint = nil
  @@code_length = nil

  def initialize
    @human = HumanPlayer.new
    @computer = AIPlayer.new
    start_game
  end
  
  def self.ball
    @@ball
  end
  def self.hint
    @@hint
  end
  def self.possible_letter
    @@possible_letter
  end
  def self.code_to_guess
    @@code_to_guess
  end
  def self.code_length
    @@code_length
  end
  def self.last_hint
    @@last_hint
  end

  #------------------------------------------------------------------------------------
  def start_game
    clear_console
    puts define_mode_txt
    define_mode
    @@code_length = @coder.define_length
    clear_console
    @secret_code = @coder.define_secret_code

    clear_console
    @board_game = [Array.new(@@code_length)] * @@total_round
    @board_hint = [Array.new(@@code_length)] * @@total_round
    
    decode_text
    print_board_line
    print_separator

    (1..@@total_round).each do |round|
      code_guess = @breaker.try_decode(round)
      code_guess_obj = code_guess.map{|letter| letter_to_ball(letter) }.join(" ")
      @@last_hint = check_hint(code_guess).join

      $stdout.write "\e[1A" 
      print_board_line(round, code_guess_obj, @@last_hint)
      
      break if game_end?(round, code_guess)
    end
  end

  #------------------------------------------------------------------------------------
  def define_mode
    text = "What do you choose : "
    check = Proc.new do |input| 
      case input.to_i
      when 1
        return (@coder, @breaker = @computer, @human)
      when 2
        return (@coder, @breaker = @human, @computer)
      when 3
        return (@coder, @breaker = @human, @human)
      end
    end
    check_error_input(text, check, "integer")
  end

  #------------------------------------------------------------------------------------
  def decode_text
    puts "***************************"
    puts "TIME TO DECODE"
    puts "***************************"
    print_color_exemple
    puts "\nLet's BEGIN"
    puts "The length code is #{@@code_length}"
    puts "You have #{@@total_round} rounds\n\n"
  end

  #------------------------------------------------------------------------------------
  def print_board_line(round = "round", board = "board", hint = "hint")
    print "%-6s" % [round]; print "| "; print "%-#{@@code_length * 4 - 1}s" % [board]; print " | "; print "%-6s" % [hint]; print "\n"
  end
  
  #------------------------------------------------------------------------------------
  def print_separator
    print "-" * 6; print "+" + "-" * (@@code_length * 4 + 1); print "+" + "-" * 6; print "\n"
  end
  
  #------------------------------------------------------------------------------------
  def game_end?(round, code_guess)
    if @secret_code == code_guess
      puts @breaker.win_text
      return true
    elsif round == @@total_round
      puts @breaker.loose_text
      return true
    end
  end

  #------------------------------------------------------------------------------------
  def check_hint(code)
    code_guess = code.clone
    code_to_guess = @secret_code.clone
    red_hint = @@hint[:correct_place_color]
    white_hint = @@hint[:correct_color]
    hint = []

    (0...@secret_code.length).reverse_each do |i|
      if code_guess[i] === code_to_guess[i]
        hint << red_hint
        code_guess.delete_at(i)
        code_to_guess.delete_at(i)
      end
    end
    
    code_guess.each do |element|
      if code_to_guess.include?(element)
        hint << white_hint
        code_to_guess.delete_at(code_to_guess.index(element))
      end
    end

    hint
  end
end