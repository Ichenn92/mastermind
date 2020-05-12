require_relative 'TextCheckModifier'
class Rules
  include TextCheckModifier

  def initialize
    if know_rules? == 'n'
      clear_console
      puts "The code is composed of \e[4m4 or 6 digits\e[0m:"
      print_color_exemple
      puts display
    end
    pause_execution
  end
  #------------------------------------------------------------------------------------
  def know_rules?
    text = "Do you already know the rules? [Y/n] : "
    check = Proc.new{|input| return input if input === 'n' || input === 'y'}
    check_error_input(text, check, "yes or no")
  end
  
  #------------------------------------------------------------------------------------
  def pause_execution                                                                                                               
    print "press any key"
    STDIN.getch
  end    

  #------------------------------------------------------------------------------------
  def display
    <<~HEREDOC
    \e[1;4mHow to play\e[0m:
    
    You play as the \e[4mcodebreaker\e[0m or the \e[4mcodemaker\e[0m.
        on Mode AI vs Human : You must guess the computer's randomly generated 
        on Mode Human vs AI : code or make a code for the computer to solve.
        on Mode Human vs Huamn : Play with a friend.

    After each guess, a maximum of \e[4mfour clues\e[0m will 
    be given.

    #{Game.hint[:correct_place_color]} means that you have one correct digit/color 
        in correct position.

    #{Game.hint[:correct_color]} means that you have one correct digit/color 
        out of position.

    HEREDOC
  end
end