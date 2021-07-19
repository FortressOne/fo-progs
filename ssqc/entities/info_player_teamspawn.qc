void () info_player_teamspawn = 
{
    GameSettings.number_of_teams = (GameSettings.number_of_teams < self.team_no) ? self.team_no : GameSettings.number_of_teams;
};