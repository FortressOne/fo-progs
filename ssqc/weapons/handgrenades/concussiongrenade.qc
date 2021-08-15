class concussiongrenade_c : handgrenade_c
{
    void () concussiongrenade_c =
    {
        //damage = 10;
        explode_radius = 240;
        classname = "concussiongrenade";
        model = MODELS::HANDGRENADE;
        skin = 1;
    };

    static void (player_c player) Prime =
    {
        concussiongrenade_c gren = spawn(concussiongrenade_c, owner: player);
        gren.damage = 0;
        player.primed_grenade = gren;
    };

    virtual void () ApplyEffect =
    {
        entity ent = findradius(this.origin, this.explode_radius + 40); // magic number
        while (ent) 
        {
            if (ent.classname != "player")
            {
                ent = ent.chain;
                continue;
            }
            player_c player = (player_c)ent;

            if (player.takedamage) 
            {
                vector org = player.origin + (player.mins + player.maxs) * 0.5;
                float dist = 0.5 * vlen(org - this.origin); // kinda dist...
                if (dist < 0)
                    dist = 0;
                dist = this.explode_radius - dist;

                if (dist > 0)
                {
                    player.velocity = org - this.origin;
                    player.velocity = player.velocity * (dist / 20);

                    if (player.class.class == CLASS::MEDIC)
                    {
                        if (GameSettings.medic_no_cuss)
                        {
                            concussionspeedbump_c speedbump = spawn(concussionspeedbump_c, owner: player);
                            ent = player.chain;
                            continue;
                        }
                    }

                    concussiontimer_c timer = (concussiontimer_c)find(world, ::classname, "concussiontimer");
                    while (timer)
                    {
                        if (timer.owner == player)
                            break;
                        
                        timer = (concussiontimer_c)find(timer, ::classname, "concussiontimer");
                    }
                        
                    if (timer) 
                        timer.RestartTimer();
                    else 
                        concussiontimer_c newtimer = spawn(concussiontimer_c, owner: player);
                    
                }
            }
            ent = ent.chain;
        }
    };
};

class concussiontimer_c : entity
{
    float ticks_left;

    void () concussiontimer_c =
    {
        classname = "concussiontimer";
        player_c player = (player_c)owner;
        player.is_concussed = TRUE;
        RestartTimer();
    };

    nonvirtual void () RestartTimer =
    {
        ticks_left = GameSettings.concussion_length * 40; // magic number
        this.SetNextThink();
    };

    nonvirtual void () SetNextThink =
    {
        nextthink = time + 0.25;
    };

    virtual void () think =
    {
        this.SetNextThink();
        player_c player = (player_c)owner;
        if (player.is_invincible || this.ticks_left <= 0)
        {
            player.is_concussed = FALSE;
            remove(this);
            return;
        }

        if (this.ticks_left % 200 == 0)
        {
            bubble_c bubble = spawn(bubble_c, origin: player.origin);
        }
        float val = player.class.class == CLASS::MEDIC ? 20 : 10;
        this.ticks_left = this.ticks_left - val;

        vector org = player.origin;
        org_x = org_x + player.maxs_x + 2;
        org_y = org_y + player.maxs_y + 2;
        float pos = pointcontents(org);

        if (player.flags & FL_ONGROUND || player.flags & FL_INWATER)
        {
            if (player.is_feigning)
                return;

            makevectors(player.v_angle);
            float stumble = crandom() * this.ticks_left;
            if (!(pos == CONTENT_SOLID && player.velocity == '0 0 0')) 
            {
                if (crandom() < 0) 
                {
                    player.velocity_x = player.velocity_y + stumble;
                    player.velocity_y = player.velocity_x + stumble;
                } 
                else 
                {
                    player.velocity_x = player.velocity_y * -1 + stumble;
                    player.velocity_y = player.velocity_x * -1 + stumble;
                }
            }
        }
    };
};

class concussionspeedbump_c : entity 
{
    float near_ground;

    void () concussionspeedbump_c =
    {
        this.nextthink = time + 1;
    };

    virtual void () think =
    {
        player_c player = (player_c)this.owner;
        this.nextthink = time + .3;

        if (!this.near_ground)
        {
            makevectors(player.v_angle);

            // if player within x units of ground, slow
            traceline(player.origin, (v_up * -1000), MOVE_NOMONSTERS, player);

            if (vlen(player.origin - trace_endpos) <= 100)
            {
                // near ground
                this.near_ground = TRUE;
            }
        }

        if (this.near_ground)
        {
            this.cnt = this.cnt + 1;

            if (vlen(player.velocity) > 1000)
            {
                if (this.cnt < 10)
                {
                    player.velocity = player.velocity *.9;
                }        
            }
        }

        if (this.cnt >= 10)
        {
            remove(this);
        }
    };
};