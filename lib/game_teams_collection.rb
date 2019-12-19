require_relative "game_teams"
require "csv"

class GameTeamsCollection
  attr_reader :game_teams_array

  def initialize(file_path)
    @game_teams_array = create_game_teams_array(file_path)
  end

  def create_game_teams_array(file_path)
    csv = CSV.read(file_path, headers: true, header_converters: :symbol)

    csv.map { |row| GameTeams.new(row) }
  end

  def game_teams_hash
    @game_teams_array.reduce({}) do |hash, game_teams|
      hash[game_teams.team_id] << game_teams if hash[game_teams.team_id]
      hash[game_teams.team_id] = [game_teams] if hash[game_teams.team_id].nil?
      hash
    end
  end

  def percentage(numerator, denominator) #to-do: make Calculatable module
    return ((numerator.to_f / denominator) * 100).round(2)
  end

  def team_win_percentage(games_hash, team, hoa = nil)
    team_games = Hash.new
    if hoa
      team_games[team] = games_hash[team].find_all { |game_team| game_team.hoa == hoa }
    else
      team_games[team] = games_hash[team]
    end
    wins = team_games[team].count { |game_team| game_team.result == "WIN" }
    percentage(wins, team_games[team].length)
  end

  def winningest_team_id
    hash = game_teams_hash
    win_percentages = Hash.new
    hash.each do |key, value|
      win_percentages[key] = team_win_percentage(hash, key)
    end
    win_percentages.max_by { |key, value| value }[0]
  end

  def hoa_differences(hash)
    diffs = Hash.new{}
    hash.each do |key, value|
      diffs[key] = team_win_percentage(hash, key, "home") - team_win_percentage(hash, key, "away")
    end
    diffs
  end

  def best_fans_id
    hoa_differences(game_teams_hash).max_by { |key, value| value }[0]
  end

  def worst_fans_ids
    hoa_diffs = hoa_differences(game_teams_hash)
    worst_fan_teams = hoa_diffs.find_all { |key, value| value < 0 }
    worst_fan_teams.map { |element| element[0] }
  end
end
