module TextCheckModifier
  def check_error_input(question, proc, type_of_input)
    try_again = "Wrong input!!! try again...".red.bold
    cursor_up = lambda do
      $stdout.write "\e[1A" 
      $stdout.write "\e[#{question.length}C"
    end

    $stdout.print question
    loop do
      case type_of_input
      when "password"
        input = STDIN.getpass.downcase.split("")
      when "integer"
        input = gets.chomp
      when "code"
        input = gets.chomp.downcase.split("")
      when "yes or no"
        input = gets.chomp.downcase
      else
        input = gets.chomp
      end

      cursor_up.call
      print " " * input.length + "\n"
      
      proc.call(input)
      
      cursor_up.call
      print try_again + "\n"
      sleep(0.8)
      cursor_up.call
      print "#{" " * try_again.length}" + "\n"
      cursor_up.call
    end
  end

  def letter_to_ball(letter)
    case letter
    when 'r'
      return Game.ball[:red]
    when 'b'
      return Game.ball[:blue]
    when 'g'
      return Game.ball[:green]
    when 'w'
      return Game.ball[:white]
    when 'y'
      return Game.ball[:yellow]
    when 'c'
      return Game.ball[:cyan]
    when 'd'
      return Game.ball[:dark]
    when 'm'
      return Game.ball[:magenta]
    end
  end

  #------------------------------------------------------------------------------------
  def print_color_exemple
    puts "EXEMPLE if you type rbgw -> #{[ Game.ball[:red], Game.ball[:blue], Game.ball[:green], Game.ball[:white] ].join(" ")}"
    puts "here are all the color you can use:"
    Game.ball.each {|key, value| puts "#{value} -> #{key}"}
    puts "\n\n"
  end
  
  #------------------------------------------------------------------------------------
  def define_mode_txt
    <<~HEREDOC
    \e[1;4mChoose your type of game\e[0m:
    [1] Coder AI vs Breaker Human
    [2] Coder Human vs Breaker AI
    [3] Coder Human vs Breaker Human
    HEREDOC
  end
end