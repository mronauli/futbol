require_relative 'team'
require_relative 'csv_loadable'
require_relative 'helpers'



class TeamCollection
  include CsvLoadable
  include Helpers

  attr_reader :teams_array

  def initialize(file_path)
    @teams_array = create_teams_array(file_path)
  end

  def create_teams_array(file_path)
    load_from_csv(file_path, Team)
  end

  def number_of_teams
    @teams_array.length
  end

  def team_name_by_id(team_id)
    find_team(team_id).team_name
  end

  def team_info(team_id)
    team = find_team(team_id)
    {
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end
end
