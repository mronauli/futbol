class GameTeams
  attr_reader :hoa, :result, :game_id, :team_id, :goals, :head_coach, :shots, :tackles

  def initialize(game_teams_info)
    @team_id = game_teams_info[:team_id]
    @hoa = game_teams_info[:hoa]
    @result = game_teams_info[:result]
    @game_id = game_teams_info[:game_id]
    @team_id = game_teams_info[:team_id].to_i
    @goals = game_teams_info[:goals].to_i
    @head_coach = game_teams_info[:head_coach]
    @shots = game_teams_info[:shots].to_i
    @tackles = game_teams_info[:tackles].to_i
  end
end
