WINNING_LINES =
  [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15],
   [16, 17, 18, 19, 20], [21, 22, 23, 24, 25]] + # rows
  [[1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23],
   [4, 9, 14, 19, 24], [5, 10, 15, 20, 25]] + # columns
  [[1, 7, 13, 19, 25], [5, 9, 13, 17, 21]] # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
wins_needed = 1
first_to_act = 'player'

def prompt(msg)
  puts "=> #{msg}"
end

scores = { player: 0, computer: 0 }

def scoreboard(scores)
  puts "+-------------------+"
  puts "| Player | Computer |"
  puts "+-------------------+"
  puts "|        |          |"
  puts "|   #{scores[:player]}    |     #{scores[:computer]}    |"
  puts "|        |          |"
  puts "+-------------------+"
end

def validate_wins_needed(wins_needed)
  if [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].include?(wins_needed)
    true
  else
    false
  end
end

def welcome
  system 'clear' || system(cls)
  prompt("Welcome to Tic Tac Toe!")
  sleep 1.5
  prompt("The Player and Computer will alternate who goes first.Good luck!")
  sleep 2
end

# rubocop:disable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize
def display_board(brd)
  system 'clear' || system(cls)
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  |  #{brd[4]}  |  #{brd[5]}"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "  #{brd[6]}  |  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  |  #{brd[10]}"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "  #{brd[11]}  |  #{brd[12]}  |  #{brd[13]}  |  #{brd[14]}  |  #{brd[15]}"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "  #{brd[16]}  |  #{brd[17]}  |  #{brd[18]}  |  #{brd[19]}  |  #{brd[20]}"
  puts "     |     |     |     |"
  puts "-----+-----+-----+-----+-----"
  puts "     |     |     |     |"
  puts "  #{brd[21]}  |  #{brd[22]}  |  #{brd[23]}  |  #{brd[24]}  |  #{brd[25]}"
  puts "     |     |     |     |"
  puts ""
  puts ""
end
# rubocop:enable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..25).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square #{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_f
    break if empty_squares(brd).include?(square) && square % 1 == 0
    prompt "Sorry, that's not a valid choice."
  end

  brd[square.to_i] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 4
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

# rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
def computer_places_piece!(brd)
  square = nil

  # offense first
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end

  # defense second
  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  # pick the middle square
  if !square && brd.values_at(13)[0] == ' '
    square = 13
    brd[square] = COMPUTER_MARKER
  end

  # just pick a square
  if !square
    square = empty_squares(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end
# rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 5
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 5
      return 'Computer'
    end
  end
  nil
end
#-----------------------WELCOME AND SETUP---------------------------------
welcome

loop do
  prompt "How many WINS do you want to play to during this tournament? (max 10)"
  wins_needed = gets.chomp.to_f
  if wins_needed % 1 == 0 && validate_wins_needed(wins_needed.to_i) == true
    puts "you got it! It will take #{wins_needed.to_i} to win the tournament!"
    sleep 2
    break
  else
    puts "That wasn't a valid choice, please enter a number from 1 to 10."
    system 'clear' || system(cls)
  end
end
puts " "
puts " "
puts "The board is setup as follows: When prompted;"
puts "please pick a square by its number."
puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
puts ""
puts "     |     |     |     |"
puts "  1  |  2  |  3  |  4  |  5"
puts "     |     |     |     |"
puts "-----+-----+-----+-----+-----"
puts "     |     |     |     |"
puts "  6  |  7  |  8  |  9  |  10"
puts "     |     |     |     |"
puts "-----+-----+-----+-----+-----"
puts "     |     |     |     |"
puts "  11 |  12 | 13  | 14  |  15"
puts "     |     |     |     |"
puts "-----+-----+-----+-----+-----"
puts "     |     |     |     |"
puts "  16 |  17 | 18  | 19  |  20"
puts "     |     |     |     |"
puts "-----+-----+-----+-----+-----"
puts "     |     |     |     |"
puts "  21 |  22 | 23  | 24  |  25"
puts "     |     |     |     |"
puts ""
puts ""

puts "hit return when ready to play"
gets.chomp

#------------------- MAIN GAME PLAY LOOP -------------------------------

loop do
  board = initialize_board

  if first_to_act == 'player'
    loop do
      display_board(board)
      scoreboard(scores)

      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      display_board(board)
      scoreboard(scores)
      sleep 0.5

      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      display_board(board)
      scoreboard(scores)
      sleep 0.25
    end
  else
    loop do
      display_board(board)
      scoreboard(scores)

      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      display_board(board)
      scoreboard(scores)
      sleep 0.25

      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      display_board(board)
      scoreboard(scores)
      sleep 0.5
    end
  end

  first_to_act = 'computer' if first_to_act == 'player'
  first_to_act = 'player' if first_to_act == 'computer'

  display_board(board)
  scoreboard(scores)
  sleep 1

  if someone_won?(board)
    prompt "#{detect_winner(board)} won that game!"
    case detect_winner(board)
    when 'Player' then scores[:player] += 1
    when 'Computer' then scores[:computer] += 1
    end
  else
    prompt "It's a tie!"
  end

  sleep 1.5
  display_board(board)
  scoreboard(scores)

  break if scores[:player] == wins_needed || scores[:computer] == wins_needed
  puts " "
  prompt("Hit return (or any key and return) to continue the tournament")
  puts " "
  prompt("or type 'x' to exit early")
  answer = gets.chomp
  break if answer == ('x')
end

grand_champion = 'Player' if scores[:player] == wins_needed
grand_champion = 'Computer' if scores[:computer] == wins_needed
grand_champion = 'Nobody' if grand_champion != ('Player' || 'Computer')

prompt("And the Grand Champion of the tournament is: #{grand_champion} ")
prompt("Thanks for playing Tic Tac Toe! Good bye!")
