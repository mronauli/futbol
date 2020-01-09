require_relative 'game_collection'
require_relative 'game_teams_collection'
require_relative 'createable'

class SeasonStats
  include Createable

  attr_reader :game_collection, :game_teams_collection, :season_game_teams_array
  def initialize(game_collection, game_teams_collection)
    @game_collection = game_collection
    @game_teams_collection = game_teams_collection
    @season_game_teams_array = nil
  end

  def results_by_opponents(team_id)
    @game_teams_collection.game_teams_by_id[team_id].reduce({}) do |acc, game_team|
      corresponding_game = @game_collection.games.find {|game| game.game_id == game_team.game_id }
      opponent = corresponding_game.opponent_id(team_id)
      acc[opponent] << game_team.result if acc[opponent]
      acc[opponent] = [game_team.result] if acc[opponent].nil?
      acc
    end
  end

  def head_to_head_ids(team_id)
    results_by_opponents_hash = results_by_opponents(team_id)
    results_by_opponents_hash.reduce({}) do |acc, results|
      win_count = results[1].count {|result| result == "WIN"}
      acc[results[0]] = (win_count.to_f / results_by_opponents_hash[results[0]].length).round(2)
      acc
    end
  end

  def make_season_game_array(season)
    season_game_array = @game_collection.game_hash_from_array_by_attribute(@game_collection.games, :season)[season]
    @season_game_teams_array = season_game_array.reduce([]) do |acc, game|
      @game_teams_collection.game_teams_array.each {|game_team| acc << game_team if game_team.game_id == game.game_id}
      acc
    end
  end

  def coach_win_percent(season, coach)
    make_season_game_array(season)
    wins = @season_game_teams_array.find_all do |game_team|
      game_team.head_coach == coach && game_team.result == "WIN"
    end.length

    games = @season_game_teams_array.find_all do |game_team|
      game_team.head_coach == coach
    end.length

    (wins.to_f / games).round(2)
  end

  def team_shot_percentage(season, team_id)
    make_season_game_array(season)
    shots = @season_game_teams_array.reduce(0) do |acc, game_team|
      if game_team.team_id == team_id
        acc += game_team.shots
      end
      acc
    end

    goals = @season_game_teams_array.reduce(0) do |acc, game_team|
      if game_team.team_id == team_id
        acc += game_team.goals
      end
      acc
    end
    (goals.to_f / shots).round(4)
  end

  def game_score_differentials(team_id, result)
    games = @game_teams_collection.game_ids_by_result(team_id, result)
    games.map do |game_id|
      @game_collection.games.find{|game| game.game_id == game_id}.difference_between_score

  def team_tackles(season, team_id)
    make_season_game_array(season)
    tackles = @season_game_teams_array.reduce(0) do |acc, game_team|
      if game_team.team_id == team_id
        acc += game_team.tackles
      end
      acc
    end
    tackles
  end

  def make_array_of_teams(season)
    make_season_game_array(season)
    @season_game_teams_array.reduce([]) do |array, game_team|
      array << game_team.team_id
      array
    end.uniq
  end

  def make_array_of_coaches(season)
    make_season_game_array(season)
    @season_game_teams_array.reduce([]) do |array, game_team|
      array << game_team.head_coach
      array
    end.uniq
  end

  def make_coach_win_percent_hash(season)
    make_array_of_coaches(season).reduce({}) do |hash, coach|
      hash[coach] = coach_win_percent(season, coach)
      hash
    end
  end

  def make_team_shot_percent_hash(season)
    make_array_of_teams(season).reduce({}) do |hash, team_id|
      hash[team_id] = team_shot_percentage(season, team_id)
      hash
    end
  end

  def make_team_tackles_hash(season)
    make_array_of_teams(season).reduce({}) do |hash, team_id|
      hash[team_id] = team_tackles(season, team_id)
      hash
    end
  end

  def winningest(season)
    make_coach_win_percent_hash(season).sort_by {|k, v| v}.last[0]
  end

  def losingest(season)
    make_coach_win_percent_hash(season).sort_by {|k, v| v}.first[0]
  end

  def most_accurate(season)
    make_team_shot_percent_hash(season).sort_by {|k, v| v}.last[0]
  end

  def least_accurate(season)
    make_team_shot_percent_hash(season).sort_by {|k, v| v}.first[0]
  end

  def most_tackles(season)
    make_team_tackles_hash(season).sort_by {|k, v| v}.last[0]
  end

  def least_tackles(season)
    make_team_tackles_hash(season).sort_by {|k, v| v}.first[0]
  end

  def biggest_team_blowout(team_id)
    game_score_differentials(team_id, "WIN").max
  end

  def worst_loss(team_id)
    game_score_differentials(team_id, "LOSS").max
  end

end
