class grenade_shock_c : grenade_hand_c
{
    float rotations;
    float shock_damage;
    player_c real_owner;

    float firstnextthink_interval;
    float lasthit_time;
    
    void () grenade_shock_c =
    {
        classname = "shockgrenade";
        netname = "Shock grenade";
        model = MODELS::GRENADE_SHOCK;
        firstnextthink_interval = 0.7;
        this.skin = 1;
        this.avelocity = '0 300 0';
        shock_damage = 20;
    };

    static void (player_c player) Prime =
    {
        grenade_shock_c gren = spawn(grenade_shock_c, owner: player);
        gren.damage = 120;
        player.primed_grenade = gren;
    };
    
    nonvirtual void () DoShock =
    {
        if (rotations == 0)
        {
            this.v_angle = '0 0 0';
            this.velocity = '0 0 0';
            this.real_owner = (player_c)this.owner;
            this.owner = world;
        }
        else
        {
            this.v_angle_y = anglemod(self.v_angle_y + GameSettings.lasergren_angleperthink);
        }

        this.angles = this.v_angle;
        makevectors(this.v_angle);
        
        traceline(this.origin, this.origin + v_forward * GameSettings.lasergren_range, 0, this);
        te_lightning2(this, this.origin, trace_endpos);

        if (trace_ent.takedamage)
        {
            te_lightningblood(trace_endpos);
            T_Damage(trace_ent, this, this.real_owner, this.shock_damage, DAMAGE::NOTTEAM, DAMAGETYPE::SHOCK);
        }

        if (this.lasthit_time < time)
        {
            sound(this, CHAN_AUTO, SOUNDS::SHOCK_HIT, 1, ATTN_NORM);
            this.lasthit_time = time + 0.8;
        }

        this.nextthink = time + GameSettings.lasergren_thinktime;
        this.rotations++;
        if (this.rotations > GameSettings.lasergren_reqthinks)
        {
            this.owner = this.real_owner;
            this.think = this.Explode;
        }
    };

    virtual void () think =
    {
        this.CheckMaxActiveGrenLimit();
        // do laser
        this.movetype = MOVETYPE_FLY;
        setorigin(this, this.origin + '0 0 32');
        this.avelocity = '0 500 0';
        this.think = this.DoShock;
        this.nextthink = time + this.firstnextthink_interval;
    };
};