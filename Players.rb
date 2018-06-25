class Players

  attr_accessor :name, :guess

  def initialize(name)
    @name = name
    @losses = 0
  end

  def guess
    puts "Please guess a letter"
    @guess = gets.chomp.to_s
  end

  def alert_invalid_guess
    puts "Invalid Guess, please try again" unless @guess.class == String && @guess.length == 1
  end
end
