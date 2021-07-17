typedef struct
{
    float season;
    float old_hp_armor;
    float spawn_full;
} gamesettings_t;
gamesettings_t GameSettings;

class gamemanager_c : entity
{
    float intermission_running;
    float intermission_exittime;
    string nextmap;

    void () gamemanager_c =
    {
        this.nextthink = time + 0.01;
        this.think = this.PopulateSettings;
    };

    //if ent is world, return serverinfo, if ent is a player, return that client's setinfo key
    nonvirtual float (entity ent, string ps_short, string ps_setting, string ps_default) GetSetting = 
    {
        string st;

        st = infokey(ent, ps_short);
        if (st != "") {
            st = infokey(ent, ps_setting);
            if (st != "") {
                st = ps_default;
            }
        }

        switch (st)
        {
            case "on":
                return TRUE;
            case "off":
                return FALSE;
            default:
                return stof(st);
        }
    };

    nonvirtual void () PopulateSettings = 
    {
        GameSettings.season = this.GetSetting(world, "tfs", "tf_season", ftos(SEASON_ONE));
        GameSettings.old_hp_armor = this.GetSetting(world, "oh", "old_hp_armor", "on");
        GameSettings.spawn_full = this.GetSetting(world, "sf", "spawnfull", "on");
    };

    /*
    ============
    IntermissionThink

    When the player presses attack or jump, change to the next level
    ============
    */
    nonvirtual void (player_c player) IntermissionThink =
    {
        if (time < this.intermission_exittime)
            return;

        if (!player.button0 && !player.button1 && !player.button2)
            return;
        
        this.GotoNextMap();
    };

    nonvirtual void () GotoNextMap =
    {
    //ZOID: 12-13-96, samelevel is overloaded, only 1 works for same level

        if (cvar("samelevel") == 1)     // if samelevel is set, stay on same level
            changelevel(mapname);
        else 
        {
            // configurable map lists, see if the current map exists as a
            // serverinfo/localinfo var
            string newmap = infokey(world, mapname);
            if (newmap != "")
                changelevel(newmap);
            else
                changelevel(nextmap);
        }
    };


    /*
    ============
    execute_changelevel

    The global "nextmap" has been set previously.
    Take the players to the intermission spot
    ============
    */
    nonvirtual void () ExecuteChangeLevel =
    {
        this.intermission_running = 1;
        
        // enforce a wait time before allowing changelevel
        this.intermission_exittime = time + 5;

        entity pos = FindIntermission();

        // play intermission music
        WriteByte (MSG_ALL, SVC_CDTRACK);
        WriteByte (MSG_ALL, 3);

        WriteByte (MSG_ALL, SVC_INTERMISSION);
        WriteCoord (MSG_ALL, pos.origin_x);
        WriteCoord (MSG_ALL, pos.origin_y);
        WriteCoord (MSG_ALL, pos.origin_z);
        WriteAngle (MSG_ALL, pos.mangle_x);
        WriteAngle (MSG_ALL, pos.mangle_y);
        WriteAngle (MSG_ALL, pos.mangle_z);
        
        other = find(world, ::classname, "player");
        while (other)
        {
            other.takedamage = DAMAGE_NO;
            other.solid = SOLID_NOT;
            other.movetype = MOVETYPE_NONE;
            other.modelindex = 0;
            other = find (other, ::classname, "player");
        }
    };

    /*
    ============
    FindIntermission

    Returns the entity to view from
    ============
    */
    nonvirtual entity () FindIntermission =
    {
        // look for info_intermission first
        entity spot = find (world, ::classname, "info_intermission");
        if (spot)
        {       // pick a random one
            float cyc = random() * 4;
            while (cyc > 1)
            {
                spot = find (spot, ::classname, "info_intermission");
                if (!spot)
                    spot = find (spot, ::classname, "info_intermission");
                cyc = cyc - 1;
            }
            return spot;
        }

        // then look for the start position
        spot = find (world, ::classname, "info_player_start");
        if (spot)
            return spot;
        
        objerror ("FindIntermission: no spot");
        return world;
    };

    nonvirtual void () NextLevel = 
    {
        if (nextmap != "")
            return; // already done

        entity o;
        if (mapname == "start")
        {
            if (!cvar("registered"))
            {
                mapname = "e1m1";
            }
            else if (!(serverflags & 1))
            {
                mapname = "e1m1";
                serverflags = serverflags | 1;
            }
            else if (!(serverflags & 2))
            {
                mapname = "e2m1";
                serverflags = serverflags | 2;
            }
            else if (!(serverflags & 4))
            {
                mapname = "e3m1";
                serverflags = serverflags | 4;
            }
            else if (!(serverflags & 8))
            {
                mapname = "e4m1";
                serverflags = serverflags - 7;
            }
    
            o = spawn();
            o.map = mapname;
        }
        else
        {
            // find a trigger changelevel
            o = find(world, ::classname, "trigger_changelevel");
            if (!o || mapname == "start")
            {       // go back to same map if no trigger_changelevel
                o = spawn();
                o.map = mapname;
            }
        }

        nextmap = o.map;

        if (o.nextthink < time)
        {
            o.think = this.ExecuteChangeLevel;
            o.nextthink = time + 0.1;
        }
    };

    nonvirtual void() CheckRules =
    {       
        if (timelimit && time >= timelimit)
            NextLevel();
        
        if (fraglimit && self.frags >= fraglimit)
            NextLevel();
    };
};
