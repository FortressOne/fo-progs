class team_c : entity {
    string name;
    string scoreboard_name;
    float illegal_classes;
    float max_lives;
    float max_players;
    float civilian_team;
    float _score;
    
    inline set float score =
    {
        _score = value;
    };
    get float score =
    {
        if (GameSettings.team_frags || GameSettings.full_team_score)
        {
            return _score;
        }
        else
        {
            return frags;
        }
    };

    get float player_count =
    {
        float count = 0;
        player_c p = (player_c)find(world, ::classname, "player");
        while (p)
        {
            if (p.tfteam.team_no == this.team_no)
            {
                count++;
            }
        }

        return count;
    };

    static void (entity player, float all) ShowScores = 
    {
        if (all)
        {
            for (float i = 0; i < GameSettings.number_of_teams; i++)
            {
                string msg = strcat(Teams[i].name, ": ", ftos(Teams[i].score), "\n");
                bprint(PRINT_HIGH, msg);
            }
            return;
        }
        
        for (float i = 0; i < GameSettings.number_of_teams; i++)
        {
            string msg = strcat(Teams[i].name, ": ", ftos(Teams[i].score), "\n");
            sprint(player, PRINT_HIGH, msg);
        }
    };

    static void () UpdateAllClientsTeamScores = 
    {
        entity e = find(world, ::classname, "player");
        while (e) 
        {
            CSQCManager.UpdateClientTeamScores(e);
            e = find(e, ::classname, "player");
        }

        e = find(world, ::classname, "observer");
        while (e) 
        {
            CSQCManager.UpdateClientTeamScores(e);
            e = find(e, ::classname, "observer");
        }
    };

    nonvirtual float (float points) IncreaseScore = 
    {
        if (points == 0)
            return FALSE;

        this.score = this.score + points;

        this.UpdateAllClientsTeamScores();

        if (GameSettings.team_frags || GameSettings.full_team_score) 
        {
            player_c e = (player_c)find(world, ::classname, "player");
            while (e) 
            {
                if (e.tfteam.team_no == this.team_no)
                    e.frags = this.score;

                e = (player_c)find(e, ::classname, "player");
            }
        }
        return TRUE;
    };

    nonvirtual void (float all, float teamBit) ProcessIllegalClasses = 
    {
        if (teamBit == -1)
        {
            this.civilian_team = TRUE;
        }
        else
        {
            this.illegal_classes = all | teamBit;
        }
    };

    void () team_c = {
        switch ((TEAM)this.team_no)
        {
            case TEAM::BLUE:
                this.name = "Blue";
                this.scoreboard_name = "blue";
                break;
            case TEAM::RED:
                this.name = "Red";
                this.scoreboard_name = "red";
                break;
            case TEAM::YELLOW:
                this.name = "Yellow";
                this.scoreboard_name = "yell";
                break;
            case TEAM::GREEN:
                this.name = "Green";
                this.scoreboard_name = "gren";
                break;
            default:
                this.name = "Error";
                error("CreateTeam, number not in switch\n");
                break;
        }
    };
};
team_c *Teams;