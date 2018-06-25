require_relative 'Players.rb'
require "byebug"
require 'Set'

class Game
  attr_accessor :players, :fragment, :dictionary

  def initialize(*players)
    @players = players
    @fragment = ""
    @dictionary = Set.new(File.readlines("dictionary.txt").map(&:chomp))
    @current_player = @players.first
    @previous_player = @players.last
    set_up_losses_hash
  end

  def next_player!
    @players << @players.shift
  end

  def take_turn(player)
    player.guess
  end

  def valid_play?(string)
    alphabet = ("a".."z").to_a
    return false unless alphabet.include?(string)

    current = @fragment + string
    @dictionary.each do |word|
      if word.include?(current)
        return true
      end
    end

    false
  end

  def over?
    @dictionary.include?(@fragment)
  end

  def play_round
    until over?
      guess = take_turn(@current_player)
      until valid_play?(guess)
        @current_player.alert_invalid_guess
        guess = take_turn(@current_player)
      end
      @fragment << guess
      puts "The fragment is now '#{@fragment}'. It is the next player's turn"
      # sleep(2)
      next_player!
    end

    conclude_round

    end

  def conclude_round
    puts "#{@previous_player.name} loses!"
    @losses[@previous_player] += 1
    puts "#{@previous_player.name} now has #{@losses[@previous_player]} losses"
    show_standings
    @fragment = ""
  end

  def show_standings
    @players.each do |player|
      puts "#{player.name}: #{record(player)}"
    end
  end

  def play
    until game_over?
      play_round
    end
    puts "Game over! #{@previous_player.name} loses!"
  end

  def set_up_losses_hash
    @losses = Hash.new(0)
    @players.each { |player| @losses[player] = 0 }
  end

  def record(player)
    ghost = "GHOST"
    player_losses = @losses[player]
    ghost[0...player_losses]
  end

  def game_over?
    @losses.any? { |_, v| v == 5}
  end

end

if __FILE__ == $PROGRAM_NAME
  # debugger
  game= Game.new(Players.new("Ronil"), Players.new("John"))
  game.play
end
