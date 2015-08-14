require_relative 'hangman_drawing.rb'

class Hangman < Drawing
  attr_reader :guesser, :referee, :board, :misses

  def initialize(players)
    @guesser = players[:guesser]
    @referee = players[:referee]
    @misses = 0
  end

  def setup
    length = @referee.pick_secret_word
    @guesser.register_secret_length(length)
    @board = Array.new(length)
    draw_hangman(@misses)
    draw_board(@board)
  end

  def take_turn
    guess = @guesser.guess(@board)
    matches = @referee.check_guess(guess)
    @misses += 1 if matches.empty?
    update_board(matches, guess)
    draw_hangman(@misses)
    draw_board(@board)
    @guesser.handle_response(guess, matches)
  end

  def update_board(matches, letter)
    matches.each { |i| @board[i] = letter }
  end

  def play
    setup
    while @board.include?(nil) && @misses < 6
      take_turn
    end
    puts @misses == 6 ? "Game over." : "Guesser wins."
  end
end

class HumanPlayer

  def pick_secret_word
    print "Length of secret word: "
    @length = gets.chomp.to_i
  end

  def check_guess(letter)
    puts "Guessed letter: #{letter}"
    gets.scan(/\d/).map { |num| num.to_i - 1 }
  end

  def register_secret_length(length)
    @secret_length = length
    puts "Secret word: " + "_" * length
  end

  def guess(board)
    gets.chomp.downcase
  end

  def handle_response(guess, matches)

  end

end

class ComputerPlayer
  attr_reader :candidate_words

  def initialize(dictionary)
    @dictionary = dictionary
    @candidate_words = dictionary
    @letters = ('a'..'z').to_a
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    @length = @secret_word.length
  end

  def check_guess(letter)
    (0...@length).select { |idx| @secret_word[idx] == letter }
  end

  def register_secret_length(length)
    @secret_length = length
    @candidate_words.delete_if { |word| word.length != length }
  end

  def guess(board)
    most_common_letter
  end

  def handle_response(guess, matches)
    @letters.delete(guess)
    update_candidates(guess, matches)
  end

  def update_candidates(guess, matches)
    matches.each do |idx|
      @candidate_words.delete_if { |word|
        word[idx] != guess }
    end

    @candidate_words.delete_if { |word|
      word.count(guess) != matches.length }
  end

  def most_common_letter
    words = @candidate_words.join("")
    most_common = ""
    count = 0
    @letters.each do |letter|
      if words.count(letter) > count
        count = words.count(letter)
        most_common = letter
      end
    end
    most_common
  end

end

if __FILE__ == $PROGRAM_NAME

  dictionary = []

  File.open("lib/dictionary.txt").each_line do |line|
    dictionary << line.chomp
  end

  p1 = HumanPlayer.new
  p2 = ComputerPlayer.new(dictionary)

  game = Hangman.new({ :guesser => p1, :referee => p2 })
  game.play

end
