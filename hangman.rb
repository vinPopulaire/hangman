class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

end

class Board

  MAX_NUM_OF_GUESSES = 5

  attr_accessor :word

  def initialize(word)
    @word = word.split('')
    @state = Array.new(word.length, "_")
    @errors = []
    @wrong_chars = []
    @used_chars = []
  end

  def draw
    print @state.join(' ')
    print "     "
    puts "#{@errors.join(' ')}"
    puts
    puts "wrong characters: #{@wrong_chars.join(',')}"
  end

  def update(letter)
    if @used_chars.include? letter
      puts "You have already used that character"
    elsif @word.include? letter
      @word.each_with_index do |char, index|
        if char == letter
          @state[index] = char
        end
      end
      @used_chars << letter
    else
      @errors << "X"
      @used_chars << letter
      @wrong_chars << letter
    end
  end

  def end_game?
    player_found_word? or player_lost? ? true : false
  end

  def player_found_word?
    @word == @state ? true : false
  end

  def player_lost?
    @errors.length == MAX_NUM_OF_GUESSES ? true : false
  end

end

class Game

  def play
    dictionary = load_dictionary
    word = select_word(dictionary).downcase

    puts "Hello! What's your name?"
    # player = Player.new(gets.chomp)
    player = Player.new("Giorgos")

    puts "Hello #{player.name}! Try to guess the word"

    board = Board.new(word)
    board.draw

    loop do
      puts "Choose a letter"
      board.update(gets.chomp.downcase)
      board.draw
      break if board.end_game?
    end

    if board.player_found_word?
      puts "Congratulations you found the word!"
    elsif board.player_lost?
      puts "You Failed! The word was #{board.word.join('')}"
    end

    puts "THE END"

  end

  def load_dictionary
    words = File.readlines("5desk.txt")
    words.map! { |word| word.strip! }
  end

  def select_word(dictionary)
    loop do
      word = dictionary.sample
      if word.length >=5 and word.length <= 12
        return word
      end
    end
  end

end

game = Game.new
game.play
