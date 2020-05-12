require_relative 'TextCheckModifier'

class HumanPlayer
  include TextCheckModifier

  def define_length
    text = "Code_maker ! what's the size of your code ? [4 or 6] : "
    check = Proc.new{|input| return input.to_i if [4,6].any? { |number| number == input.to_i }}
    check_error_input(text, check, "integer")
  end
  
  def define_secret_code
    puts "\nGood ! now tell me what's your secret code (No worry, I won't print it out)"
    print_color_exemple
    
    text = "your secret code : "
    check = Proc.new{|input| return input if check_code(input)}
    check_error_input(text, check, "password")
  end
  
  def try_decode(round)
    text = "#{round}     | Enter your code : "
    check = Proc.new{|input| return input if check_code(input)}
    check_error_input(text, check, "code")
  end

  def win_text
    <<~HEREDOC
      
    
    *******************************************
    You are the MasterMind !
    You won the game by decoding like a hacker
    *******************************************
    HEREDOC
  end

  def loose_text
    <<~HEREDOC

    Sorry, you havent found the secret code, you LOST !
    HEREDOC
  end
end

#------------------------------------------------------------------------------------
def check_code(code)
  code.all? { |letter| Game.possible_letter.include?(letter)} && code.size == Game.code_length
end

class AIPlayer
  include TextCheckModifier
  attr_accessor :guess

  def initialize
    @guess = { confirmed: Array.new(4),
               not_sure: Array.new(4)}
  end

  def define_length
    [4,6].sample
  end
  
  def define_secret_code
    code_to_guess = []
    Game.code_length.times { code_to_guess << Game.ball.keys.sample[0] }
    code_to_guess
  end
  
  def try_decode(round)
    print_thinking(round)
    guess = []
    Game.code_length.times { guess << Game.ball.keys.sample[0] }
    return guess

  end

  def print_thinking(round)
    cursor_up = lambda do
      $stdout.write "\e[1A" 
      $stdout.write "\e[#{"#{round}     | ".length}C"
    end

    print "%-6s" % [round]; print "| "; print "Computer is guessing"
    sleep(0.5)
    print "."
    sleep(0.5)
    print "."
    sleep(0.5)
    print ".\n"
    sleep(1)
    cursor_up.call
    print " " * 60 + "\n"
  end

  def win_text
    <<~HEREDOC
      
    
    *******************************************
    AI is definitely better than YOU !
    AI won the game by decoding like a hacker
    *******************************************
    HEREDOC
  end

  def loose_text
    <<~HEREDOC
    
    You made that code impossible to crack for AI
    Human win !
    HEREDOC
  end
end