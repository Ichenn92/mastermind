require 'bundler/inline'

gemfile true do
 source 'http://rubygems.org'
 gem 'colorize'
end

require 'colorize' # for repl.it add the gem
require 'io/console'
require_relative './class/game'
require_relative './class/player'
require_relative './class/rules'
require_relative './class/TextCheckModifier'

def clear_console 
  print `clear`
end

# --------------
Rules.new()
# --------------

loop do
  continue = nil

  clear_console
  games = Game.new()
  loop do
    print "Do you want to play again? [Y/n] : "
    continue = gets.chomp.downcase
    break if "ny".include?(continue)
  end
  break if continue == "n"
  
end
