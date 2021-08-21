enum {
    MENU_NONE,
    MENU_TEAM,
    MENU_CLASS,
};

class menumanager_c : entity {
    nonvirtual void (player_c player) CheckMenu = {
        if (player.classname == "observer")
        {
            return;
        }

        // if no team set
        if (!player.tf_team.team_no)
        { 
            this.TeamMenu(player);
            return;
        }
        if (!player.tf_class)
        {
            this.ClassMenu(player);
            return;
        }
    };

    nonvirtual void (player_c player, float menuType, string... count) SetMenu = {
        // no printing while menu open
        if (player.menu != MENU_NONE)
        {
            return;
        }
        float i, len, lineCount = 0;
        string s;
        s = "";

        for (i = 0; i < count; i++)
        {
            s = strcat(s, ...(i, string));
        }
        len = strlen(s);

        for (i = 0; i < len; i++)
        {
            if (substring(s, i, 1) == "\n")
            {
                lineCount++;
            }
        }
        if (len > 0 && lineCount == 0)
            lineCount = 1;

        player.status_string = s;
        player.status_string_lines = lineCount;
        player.status_string_time = time + 1.5;
        player.status_string_refresh_time = time;

        player.menu = menuType;
        player.impulse = 0;
    };

// TODO - force update of status bar
    nonvirtual void (player_c player) RefreshScreen = {
        if (player.status_string_refresh_time > time)
        {
            return;
        }

        if (player.status_string_lines > 0 && player.status_string_time <= time && player.menu == MENU_NONE)
        {
            this.ClearScreen(player);
            //return;
        }

        centerprint(player, player.status_string);
    };

    nonvirtual void (player_c player) ClearScreen = {
        player.status_string = "";
        player.status_string_lines = 0;
    };

    nonvirtual void (player_c player) FrameThink = {
        if (player.menu != MENU_NONE)
        {
            this.MenuInput(player);
        }

        // check menus
        this.CheckMenu(player);

        this.RefreshScreen(player);
    };

    nonvirtual void (player_c player, string... count) CenterPrint = {
        float i, len, lineCount = 0;
        string s;
        s = "";

        for (i = 0; i < count; i++)
        {
            s = strcat(s, ...(i, string));
        }
        len = strlen(s);

        for (i = 0; i < len; i++)
        {
            if (substring(s, i, 1) == "\n")
            {
                lineCount++;
            }
        }

        if (len > 0 && lineCount == 0)
            lineCount = 1;

        player.status_string = s;
        player.status_string_time = time + 1.5;
        player.status_string_refresh_time = time;
        player.status_string_lines = lineCount;
    };

    nonvirtual void (player_c player) MenuInput = {
        switch (player.menu)
        {
            case MENU_NONE:
                return;
            case MENU_TEAM:
                this.MenuTeamInput(player);
                break;
            case MENU_CLASS:
                this.MenuClassInput(player);
                break;
        }

        player.impulse = 0;
    };

    nonvirtual void (player_c player) TeamMenu = {
        string select = "Select team:\n\n";
        for (float i = 0; i < GameSettings.number_of_teams; i++)
        {
            string temp = strcat(Q"\s[\s", ftos(i+1), Q"\s]\s ", Teams[i].name,"\n");
            select = strcat(select, temp);
        }
        
        // don't show auto team if already assigned a team
        string autoteam = (player.tf_team.team_no) ? "" : Q"\s[\s5\s]\s Auto-assign team";

        this.SetMenu(player, MENU_TEAM, select, autoteam);
    };

    nonvirtual void (player_c player) MenuTeamInput = {
        if (player.classname == "observer")
        {
            return;
        }

        switch (player.impulse)
        {
            case 0:
                return;
            case 1:
            case 2:
            case 3:
            case 4:
                player.SetTeam(player.impulse);
                player.menu = MENU_NONE;
                break;
            case 5:
                float choose = 0;
                for (float i = 0; i < GameSettings.number_of_teams; i++)
                {
                    float new = Teams[i].player_count;
                    if (choose == 0)
                    {
                        choose = new;
                    }
                    else if (new < choose)
                    {
                        choose = new;
                    }
                }
                player.SetTeam(choose);
                player.menu = MENU_NONE;
                break;
        }
    };

    nonvirtual void (player_c player) ClassMenu = {
        string select = "Select class: \n\n";
        for (float i = 0; i < GameSettings.number_of_classes; i++)
        {
            string temp = strcat(Q"\s[\s", ftos(i+1), Q"\s]\s ", Classes[i].classname,"\n");
            select = strcat(select, temp);
        }

        string random = Q"\s[\s0\s]\s Random PC";

        this.SetMenu(player, MENU_CLASS, select, random);
    };

    nonvirtual void (player_c player) MenuClassInput = {
        if (player.classname == "observer")
        {
            return;
        }

        switch (player.impulse)
        {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                if (player.CanChooseClass(player.impulse))
                {
                    player.SetClass(player.impulse);
                    player.menu = MENU_NONE;
                }
                
                break;
        }
    };
};

menumanager_c MenuManager;