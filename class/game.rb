class Game
  attr_accessor

  def initialize ()
    @ball = { red: " R ".on_red.bold, 
              blue: " B ".on_blue.bold, 
              green: " G ".on_green.bold, 
              white: " W ".black.on_white.bold,
              pink: " P ".on_yellow.bold,
              cyan: " C ".black.on_cyan.bold,
              dark: " D ".bold,
              magenta: " M ".on_magenta.bold }
    @hint = { correct_place_color: "•".red.bold,
              correct_color: "•".white.bold }

    @possible_letter = @ball.keys.map{|word| word = word[0] }

    define_length
    clear_console
    define_secret_code
    clear_console
    @total_round = 12
    @board_game = [Array.new(@code_length)] * @total_round
    @board_hint = [Array.new(@code_length)] * @total_round
    
    decode_text
    print_board_line
    print_separator
    play
  end

  #------------------------------------------------------------------------------------
  def decode_text
    puts "***************************"
    puts "TIME TO DECODE"
    puts "***************************"
    print_color_exemple
    puts "\nLet's BEGIN"
    puts "You have #{@total_round} rounds\n\n"
  end

  #------------------------------------------------------------------------------------
  def play
    (1..@total_round).each do |round|
      code_guess = decode_play(round)
      code_guess_obj = code_guess.map{|letter| letter_to_ball(letter) }.join(" ")
      hint = check_hint(code_guess).join
      
      $stdout.write "\e[1A" 
      print_board_line(round, code_guess_obj, hint)

      break if game_end?(round, code_guess)
    end
  end
  
  #------------------------------------------------------------------------------------
  def check_hint(code)
    code_guess = code.clone
    code_to_guess = @code_to_guess.clone
    red_hint = @hint[:correct_place_color]
    white_hint = @hint[:correct_color]
    hint = []

    (0...@code_to_guess.length).reverse_each do |i|
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

  #------------------------------------------------------------------------------------
  def game_end?(round, code_guess)
    if @code_to_guess == code_guess
      puts "\n\n*******************************************"
      puts "You are the MasterMind !"
      puts "You won the game by decoding like a hacker"
      puts "*******************************************"
      return true
    elsif round == @total_round
      puts "Sorry, you havent found the secret code, you LOST !"
      return true
    end
  end

  #------------------------------------------------------------------------------------
  def decode_play(round)
    text = "#{round}     | Enter your code : "
    check = Proc.new{|input| return input if check_code(input)}
    check_error_input(text, check, "code")
  end
  
  #------------------------------------------------------------------------------------
  def print_board_line(round = "round", board = "board", hint = "hint")
    print "%-6s" % [round]; print "| "; print "%-#{@code_length * 4 - 1}s" % [board]; print " | "; print "%-6s" % [hint]; print "\n"
  end
  
  #------------------------------------------------------------------------------------
  def print_separator
    print "-" * 6; print "+" + "-" * (@code_length * 4 + 1); print "+" + "-" * 6; print "\n"
  end

  #------------------------------------------------------------------------------------
  def check_code(code)
    code.all? { |letter| @possible_letter.include?(letter)} && code.size == @code_length
  end

  #------------------------------------------------------------------------------------
  def define_length
    text = "Code_maker ! what's the size of your code ? [4 or 6] : "
    check = Proc.new{|input| return (@code_length = input.to_i) if [4,6].any? { |number| number == input.to_i }}
    check_error_input(text, check, "integer")
  end
  
  #------------------------------------------------------------------------------------
  def define_secret_code
    puts "\nGood ! now tell me what's your secret code (No worry, I won't print it out)"
    print_color_exemple

    text = "your secret code : "
    check = Proc.new{|input| return @code_to_guess = input if check_code(input)}
    check_error_input(text, check, "password")
  end

  #------------------------------------------------------------------------------------
  def print_color_exemple
    puts "EXEMPLE if you type rbgw -> #{[ @ball[:red], @ball[:blue], @ball[:green], @ball[:white] ].join(" ")}"
    puts "here are all the color you can use:"
    @ball.each {|key, value| puts "#{value} -> #{key}"}
    puts "\n\n"
  end

  #------------------------------------------------------------------------------------
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

  #------------------------------------------------------------------------------------
  def letter_to_ball(letter)
    case letter
    when 'r'
      return @ball[:red]
    when 'b'
      return @ball[:blue]
    when 'g'
      return @ball[:green]
    when 'w'
      return @ball[:white]
    when 'p'
      return @ball[:pink]
    when 'c'
      return @ball[:cyan]
    when 'd'
      return @ball[:dark]
    when 'm'
      return @ball[:magenta]
    end
  end
end