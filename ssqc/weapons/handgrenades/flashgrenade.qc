class flashgrenade_c : handgrenade_c
{
    void () flashgrenade_c =
    {
        classname = "flashgrenade";
        netname = "Flash grenade";
        model = MODELS::FLASH;
    };

    static void (player_c player) Prime =
    {
        flashgrenade_c gren = spawn(flashgrenade_c, owner: player);
        gren.damage = 10;
        gren.explode_radius = 300;
        player.primed_grenade = gren;
    };

    virtual void () ApplyEffect =
    {
        entity ent = findradius(this.origin, this.explode_radius);
        while (ent)
        {
            if (ent.classname != "player")
            {
                ent = ent.chain;
                continue;
            }

            traceline(this.origin, ent.origin, 1, this);
            if (trace_fraction != 1)
            {
                ent = ent.chain;
                continue;
            }

            player_c player = (player_c)ent;
            sprint(player, PRINT_HIGH, "You have been flashed!\n");
            sound(player, CHAN_AUTO, SOUNDS::FLASH, 1, ATTN_NONE, SOUNDFLAG_UNICAST, 0);
            
            if (player.health > 0) {
                entity ft = find(world, ::classname, "flashtimer");
                while (ft)
                {
                    if (ft.owner == player)
                    {
                        ft.nextthink = time + .1;
                        break;
                    }
                    ft = find(ft, ::classname, "flashtimer");
                }

                if (!ft)
                {
                    newmis = spawn();
                    newmis.classname = "flashtimer";
                    newmis.owner = player;
                    newmis.think = flashgrenade_c::FlashTimer;
                    newmis.nextthink = time + .1;
                }
                vector org = player.origin + (player.mins + player.maxs) * 0.5;
                float frac = (this.explode_radius - vlen(this.origin - org)) / this.explode_radius;
                float ftime = GameSettings.flash_time * (frac + frac * 0.5); // fall off is awful, let's half it
                player.flash_time = ftime;

                flashgrenade_c::StuffFlash(player);
                player.is_flashed = TRUE;
            }

            ent = ent.chain;
        }
    };

    static void () FlashTimer =
    {
        player_c player = (player_c)self.owner;
        player.flash_time = player.flash_time - 0.1;
        if (player.flash_time <= 0) 
        {
            sprint(player, PRINT_HIGH, "Flash has worn off\n");
            stuffcmd(player, "v_cshift; wait; bf\n");
            player.is_flashed = FALSE;
            remove(self);
            return;
        }

        flashgrenade_c::StuffFlash(player);
        self.nextthink = time + 0.1;
    };

    static float (player_c player) CalcFlash =
    {
        float timeleft = player.flash_time;
        float flashAmtMax = 240;
        float flashAmtMin = 100;
        float flashAmtMaxMult = stof(infokey(player, "maxflash"));
        float flashAmtMinMult = stof(infokey(player, "minflash"));
        
        float flashAmt = (flashAmtMaxMult > 0) ? flashAmtMax * flashAmtMaxMult : flashAmtMax;
        flashAmtMin = (flashAmtMinMult > 0) ? flashAmtMin * flashAmtMinMult : flashAmtMin;
        
        float perc = timeleft / GameSettings.flash_time;

        flashAmt = flashAmt * perc;
        flashAmt = flashAmt < flashAmtMin ? flashAmtMin : flashAmt;
        return flashAmt;
    };

    static void (player_c player) StuffFlash =
    {
        float amt = flashgrenade_c::CalcFlash(player);
        string st = ftos(amt);
        string cmd = strcat("v_cshift ", st, " ", st);
        cmd = strcat(cmd, " ", st, " ", st, "\n");
        stuffcmd(player, cmd);
    };

    virtual void () ParticleEffect =
    {
        this.effects = this.effects | EF_BRIGHTLIGHT;
        te_tarexplosion(this.origin);
    };
};