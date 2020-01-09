require './test/test_helper'
require './lib/game_collection'
require './lib/game_teams_collection'
require './lib/season_stats'

class SeasonStatsTest < Minitest::Test
  def setup
    @game_collection = GameCollection.new("./test/fixtures/games_truncated.csv")
    @game_teams_collection = GameTeamsCollection.new("./test/fixtures/game_teams_truncated.csv")
    @season_stats = SeasonStats.new(@game_collection, @game_teams_collection)
  end

  def test_it_exists
    assert_instance_of SeasonStats, @season_stats
  end

  def test_it_can_find_results_by_opponent
    expected = {
      14=>["WIN", "WIN", "LOSS", "WIN", "WIN", "WIN"],
      19=>["WIN", "WIN", "WIN", "LOSS", "WIN", "WIN"]
    }
    assert_equal expected, @season_stats.results_by_opponents(16)
  end

  def test_it_can_report_head_to_head_results
    expected = {14=>0.83, 19=>0.83}
    assert_equal expected, @season_stats.head_to_head_ids(16)
  end

  def test_it_can_make_season_game_teams_array
    assert_equal 12, @season_stats.make_season_game_array("20132014").length
    # require "pry"; binding.pry
  end

  def test_it_can_find_win_percentage_by_coach_for_a_season
    assert_equal 0.83, @season_stats.coach_win_percent("20132014", "Joel Quenneville")
  end

  def test_it_can_make_array_of_coaches
    assert_equal ["Joel Quenneville", "Ken Hitchcock"], @season_stats.make_array_of_coaches("20132014")
  end

  def test_it_can_make_hash_of_coaches_and_their_win_percentages
    answer = {"Joel Quenneville"=>0.83, "Ken Hitchcock"=>0.17}

    assert_equal answer, @season_stats.make_coach_win_percent_hash("20132014")
  end

  def test_it_can_find_winningest_coach
    assert_equal "Joel Quenneville", @season_stats.winningest("20132014")
  end

  def test_it_can_find_losingest_coach
    assert_equal "Ken Hitchcock", @season_stats.losingest("20132014")
  end

  def test_it_can_find_shot_percentage_for_a_team_and_season
    assert_equal 0.3636, @season_stats.team_shot_percentage("20132014", 16)
  end

  def test_it_can_make_array_of_teams
    assert_equal [16, 19], @season_stats.make_array_of_teams("20132014")
  end

  def test_it_can_make_hash_of_teams_and_their_shot_percentages
    answer = {16=>0.3636, 19=>0.1923}

    assert_equal answer, @season_stats.make_team_shot_percent_hash("20132014")
  end

  def test_it_can_find_most_accurate_team
    assert_equal 16, @season_stats.most_accurate("20132014")
  end

  def test_it_can_find_least_accurate_team
    assert_equal 19, @season_stats.least_accurate("20132014")
  end

  def test_it_can_make_hash_of_teams_and_their_tackles
    answer = {16=>143, 19=>248}

    assert_equal answer, @season_stats.make_team_tackles_hash("20132014")
  end

  def test_it_can_find_most_tackles
    assert_equal 19, @season_stats.most_tackles("20132014")
  end

  def test_it_can_find_most_least_tackles
    assert_equal 16, @season_stats.least_tackles("20132014")
  end

  def test_can_get_game_score_differentials
    assert_equal [1, 1, 1, 2], @season_stats.game_score_differentials(20, "LOSS")
  end

  def test_can_get_biggest_team_blowout
    assert_equal 2, @season_stats.biggest_team_blowout(24)
  end

  def test_can_get_worst_team_loss
    assert_equal 2, @season_stats.worst_loss(20)
  end

  # def test_it_can_make_season_game_teams_array
  #   assert_equal [], @game_collection.make_season_game_array("20132014")
  # end
end
