/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
    trigger_changelevel_c trig = (trigger_changelevel_c)self;
    trig.ParseSpawn();
};

class trigger_changelevel_c : entity
{
    nonvirtual void () ParseSpawn = 
    {
        if (!this.map)
		    objerror ("chagnelevel trigger doesn't have map");
	
        InitTrigger();
    };

    virtual void () touch =
    {
        if (other.classname != "player")
		return;

        // if "noexit" is set, blow up the player trying to leave
        //ZOID, 12-13-96, noexit isn't supported in QW.  Overload samelevel
        //      if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
        if ((cvar("samelevel") == 2) || ((cvar("samelevel") == 3) && (mapname != "start")))
        {
            T_Damage(other, this, this, 50000);
            return;
        }

        bprint(PRINT_HIGH, other.netname, " exited the level\n");
        GameManager.nextmap = this.map;

        SUB_UseTargets ();

        this.touch = SUB_Null;

    // we can't move people right now, because touch functions are called
    // in the middle of C movement code, so set a think time to do it
        this.think = GameManager.ExecuteChangeLevel;
        this.nextthink = time + 0.1;
    };
};