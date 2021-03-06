class Game
	include Mongoid::Document
	include Mongoid::Timestamps

  field :starter_matrix,    type: Array
  field :opponent_matrix,   type: Array
  field :level,             type: Integer, default: 5
  field :stop,              type: Time
  belongs_to :user
  belongs_to :ip
  
  def game_initialization(user, level = 5)
  	game = Game.new
  	game.starter_matrix = random_matrix(level)
  	game.opponent_matrix = random_matrix(level)
    game.level = level
  	game.ip = user
  	game.save
    return game
  end

  def random_matrix(number)
    d = (1..(number * number)).to_a.shuffle
    g =[]
    (1..number).each do |x|
      z = x-1
      g.push(d[number*z..number*x-1])
    end
    g
  end

  def update_matrix(number, user)
    game = user.game[-1]
    game_hash = {}
    game_hash[:user_matrix] = game.starter_matrix
    game_hash[:computer_matrix] = game.opponent_matrix
    game_hash[:number] = number
    game_hash[:level] = game.level
    user_matrix, computer_matrix, element = UpdateMatrix.update(game_hash)
    game.starter_matrix = user_matrix
    game.opponent_matrix = computer_matrix
    game.save
  end

  def level_winner_info
    games = Game.all
    # {level: game_played}
    game_win_hash = {}
    games.each do |game|
      if game_win_hash.has_key? game.level - 2
        game_win_hash[game.level - 2] += 1
      else
        game_win_hash[game.level - 2] = 1
      end
    end
    game_win_hash
  end
end