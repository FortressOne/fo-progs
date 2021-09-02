class proj_pipebomb_c : proj_c
{

    void () proj_pipebomb_c =
    {
        classname = "pipebomb";
        model = MODELS::PIPEBOMB;
        movetype = MOVETYPE_BOUNCE;
        nextthink_interval = 120; // pipebomb lifetime
        speed = 600;
        speed_vertical = 200;
        damage = 120;
        skin = 2;
        player_c player = (player_c)this.owner;
        GameManager.pipebomb_count_world++;
        player.pipebomb_count++;
        player.tf_team.pipebomb_count++;
        player.det_cooldown = time + GameSettings.det_delay;

        if (GameSettings.pipebomb_limit_world > -1)  //unlimited
        {
            if (GameManager.pipebomb_count_world > GameSettings.pipebomb_limit_world)
            {
                Demoman::ExplodeOldestPipebomb(player);
            }
        }

        if (GameSettings.pipebomb_limit_team > -1)
        {
            if (player.tf_team.pipebomb_count > GameSettings.pipebomb_limit_team)
            {
                Demoman::ExplodeOldestPipebomb(player);
            }
        }

        if (GameSettings.pipebomb_limit_player > -1)
        {
            if (player.pipebomb_count > GameSettings.pipebomb_limit_player)
            {
                Demoman::ExplodeOldestPipebomb(player);
            }
        }
    };

    virtual void () think =
    {
        this.Explode();
    };

    virtual void () Explode =
    {
        other = world;
        GameManager.pipebomb_count_world--;
        player_c player = (player_c)this.owner;
        player.pipebomb_count--;
        player.tf_team.pipebomb_count--;
        super::Explode();
    };

    
};