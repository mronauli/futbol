require_relative "game"
require "csv"

class GameCollection
  attr_reader :games

  def initialize(file_path)
    @games = create_games(file_path)
  end

  def create_games(file_path)
    csv = CSV.read(file_path, headers: true, header_converters: :symbol)

    csv.map { |row| Game.new(row) }
  end

  def games_by_season
    season_games = @games.reduce({}) do |hash,game|
      if hash[game.season]
        hash[game.season] << game
      else
        hash[game.season] = [game]
      end
      hash
    end
    season_games.each do |key, value|
      season_games[key] = value.length
    end
    season_games
  end
end
