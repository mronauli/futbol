require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    @game_path = './test/fixtures/games_truncated.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './test/fixtures/game_teams_truncated.csv'

    locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_can_get_the_sum_of_highest_winning_and_losing_team_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_can_get_the_sum_of_lowest_winning_and_losing_team_score
    assert_equal 2, @stat_tracker.lowest_total_score
  end

  def test_it_can_get_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_it_can_get_percent_home_wins
    assert_equal 0.38, @stat_tracker.percentage_home_wins

  end

  def test_it_can_get_percentage_visitor_wins
    assert_equal 0.58, @stat_tracker.percentage_visitor_wins

  end

  def test_it_can_get_percentage_ties
    assert_equal 0.04, @stat_tracker.percentage_ties
  end

  def test_it_can_count_games_by_season
    assert_equal ({"20162017"=>4, "20142015"=>6, "20152016"=>10, "20132014"=>6}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_get_average_goals_per_game
    assert_equal 4.31, @stat_tracker.average_goals_per_game
  end

  def test_it_can_get_average_goals_per_season
    assert_equal ({"20162017"=>4.75, "20142015"=>3.5, "20152016"=>4.6, "20132014"=>4.33}), @stat_tracker.average_goals_by_season
  end

  def test_it_can_count_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end
end
