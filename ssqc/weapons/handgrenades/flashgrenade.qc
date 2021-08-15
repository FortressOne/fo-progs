class flashgrenade_c : handgrenade_c
{
    void () flashgrenade_c =
    {
        //damage = 10;
        explode_radius = 300;
        classname = "flashgrenade";
        model = MODELS::FLASH;
    };

    static void (player_c player) Prime =
    {
        flashgrenade_c gren = spawn(flashgrenade_c, owner: player);
        gren.damage = 10;
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
                float found = FALSE;
                
                while (ft)
                {
                    if (ft.owner == ent)
                    {
                        found = TRUE;
                        ft.nextthink = time + .1;
                        break;
                    }
                    ft = find(ft, ::classname, "flashtimer");
                }

                if (!found)
                {
                    newmis = spawn();
                    newmis.classname = "flashtimer";
                    newmis.owner = ent;
                    newmis.think = flashgrenade_c::FlashTimer;
                    newmis.nextthink = time + .1;
                }
                vector org = player.origin + (player.mins + player.maxs) * 0.5;
                float frac = (this.explode_radius - vlen(self.origin - org)) / this.explode_radius;
                float ftime = GameSettings.flash_time;
                ftime = ftime * (frac + frac * 0.5); // fall off is awful, let's half it
                player.flash_time = ftime;

                float flashamount = flashgrenade_c::CalcFlash(player);
                flashgrenade_c::StuffFlash(player, flashamount);

                player.is_flashed = TRUE;
            }

            ent = ent.chain;
        }
    };

    static void () FlashTimer =
    {
        player_c player = (player_c)self.owner;
        player.flash_time = player.flash_time - 0.6;
        if (player.flash_time < 5) {
            player.flash_time = 1;
            stuffcmd(player, "v_cshift; wait; bf\n");
            player.is_flashed = FALSE;
            remove(self);
            return;
        }

        flashgrenade_c::StuffFlash(player, (player.flash_time*10));
        self.nextthink = time + 0.6;
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

    static void (entity ent, float amt) StuffFlash =
    {
        string st = ftos(amt);
        string cmd = strcat("v_cshift ", st, " ", st);
        cmd = strcat(cmd, " ", st, " ", st, "\n");
        stuffcmd(ent, cmd);
    };

    virtual void () ParticleEffect =
    {
        this.effects = this.effects | EF_BRIGHTLIGHT;
        te_tarexplosion(this.origin);
    };
};