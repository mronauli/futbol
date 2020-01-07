module Helpers
  def find_team(team_id)
    team = @teams_array.find {|team| team.team_id.to_i == team_id}
  end
end
