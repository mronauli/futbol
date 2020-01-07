class Team

attr_reader :team_name, :team_id, :franchise_id, :team_name, :abbreviation, :link

  def initialize(team)
    @team_name = team[:teamname]
    @team_id = team[:team_id]
    @franchise_id = team[:franchiseid]
    @abbreviation = team[:abbreviation]
    @stadium = team[:stadium]
    @link = team[:link]
    # @team_info = {team_id: team[:team_id], franchise_id: team[:franchise_id], team_name: team[:team_name], abbreviation: team[:abbreviation], link: team[:link]}
  end

end
