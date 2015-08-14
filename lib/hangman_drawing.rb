class Drawing
  ONE = ["    -----\n"]
  TWO = ["   |      \n", "   |    O \n"]
  THREE = ["   |       \n", "   |    |  \n", "   |    |- \n", "   |   -|- \n"]
  FOUR = ["   |        \n", "   |   /    \n", "   |   / \\ \n"]
  FIVE = ["_______ "]


  def draw_hangman(misses)
    case misses
    when 0
      drawing = ONE[0] + TWO[0] + THREE[0] + FOUR[0] + FIVE[0]
    when 1
      drawing = ONE[0] + TWO[1] + THREE[0] + FOUR[0] + FIVE[0]
    when 2
      drawing = ONE[0] + TWO[1] + THREE[1] + FOUR[0] + FIVE[0]
    when 3
      drawing = ONE[0] + TWO[1] + THREE[2] + FOUR[0] + FIVE[0]
    when 4
      drawing = ONE[0] + TWO[1] + THREE[3] + FOUR[0] + FIVE[0]
    when 5
      drawing = ONE[0] + TWO[1] + THREE[3] + FOUR[1] + FIVE[0]
    when 6
      drawing = ONE[0] + TWO[1] + THREE[3] + FOUR[2] + FIVE[0]
    end
    puts drawing
  end

  def draw_board(board)
    print "Secret word: "
    puts board.map { |letter| letter.nil? ? "_" : letter.to_s }.join("")
  end
end
