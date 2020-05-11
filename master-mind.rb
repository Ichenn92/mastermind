require 'pry'
require 'colorize'
require 'io/console'
require_relative './class/game'
require_relative './class/player'
require_relative './class/rules'

def clear_console 
  $stdout.write "#\e[2J" 
  puts "\n"
end

# print "•"


loop do
  continue = nil

  clear_console
  Game.new()
  loop do
    print "Do you want to play again? [Y/n] : "
    continue = gets.chomp.downcase
    break if "ny".include?(continue)
  end
  break if continue == "n"
  
end
