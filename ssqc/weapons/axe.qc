class axe_c : weapon_c
{
    void () axe_c = 
    {
        classname = "player_axe";
        shoot_sound = "weapons/ax1.wav";
        weapon = IT_AXE; // hud
        weapon_type = WEAPON::AXE;
        ammo_type = 0;
        weaponmodel = "progs/v_axe.mdl";
        attack_finish_delay = 0.5;
        animation_func = player_axe1;
        ammo_per_shot = 0;
    };

    virtual float () Attack =
    {
        float r = random();
        if (r < 0.25)
            this.animation_func = player_axe1;
        else if (r < 0.5)
            this.animation_func = player_axeb1;
        else if (r < 0.75)
            this.animation_func = player_axec1;
        else
            this.animation_func = player_axed1;
            
        return super::Attack();
    };

    nonvirtual void () Swing =
    {
        makevectors (self.owner.v_angle);
        vector source = self.owner.origin + '0 0 16';
        traceline (source, source + v_forward*64, FALSE, self.owner);
        if (trace_fraction == 1.0)
            return;
        
        vector org = trace_endpos - v_forward*4;

        if (trace_ent.takedamage)
        {
            trace_ent.axhitme = 1;
            SpawnBlood (org, 20);
            if (deathmatch > 3)
                T_Damage (trace_ent, self.owner, self.owner, 75);
            else
                T_Damage (trace_ent, self.owner, self.owner, 20);
        }
        else
        {       // hit wall
            sound (self.owner, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

            WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
            WriteByte (MSG_MULTICAST, TE_GUNSHOT);
            WriteByte (MSG_MULTICAST, 3);
            WriteCoord (MSG_MULTICAST, org_x);
            WriteCoord (MSG_MULTICAST, org_y);
            WriteCoord (MSG_MULTICAST, org_z);
            multicast (org, MULTICAST_PVS);
        }
    };
};