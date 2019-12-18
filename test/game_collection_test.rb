require './test/test_helper'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test
  def setup
    @game_collection = GameCollection.new("./data/games.csv")
    @game = @game_collection.games.first
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_it_has_attributes
    assert_instance_of Array, @game_collection.games
  end

  def test_it_can_create_games_from_csv
    assert_instance_of Game, @game
    assert_equal "20122013", @game.season
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
  end

  def test_it_can_calculate_average_goals_per_game
    expected = 4.22 #to-do: set up dummy test b/c idk if this is accurate
    assert_equal  expected, @game_collection.average_goals_per_game
  end

  def test_it_can_store_games_by_season
    #to-do: change to account for dummy test stats
    assert_equal 6, @game_collection.games_by_season.length
  end
end
