class axe_c : weapon_c
{
    float damage;
    void () axe_c = 
    {
        classname = "player_axe";
        shoot_sound = SOUNDS::AXE_SHOOT;
        weapon = IT_AXE; // hud
        weapon_type = WEAPON::AXE;
        ammo_type = 0;
        weaponmodel = MODELS::VIEW_AXE;
        attack_finish_delay = 0.5;
        animation_func = player_axe1;
        ammo_per_shot = 0;
        damage = 20;
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
        makevectors (this.owner.v_angle);
        vector source = this.owner.origin + '0 0 16';
        traceline (source, source + v_forward*64, FALSE, this.owner);
        if (trace_fraction == 1.0)
            return;
        
        vector org = trace_endpos - v_forward*4;

        if (trace_ent.takedamage)
        {
            trace_ent.axhitme = 1;
            SpawnBlood (org, 20);
            T_Damage (trace_ent, this.owner, this.owner, this.damage, DAMAGE::NOTTEAM, DAMAGETYPE::OTHER);
        }
        else
        {       // hit wall
            sound(this.owner, CHAN_WEAPON, SOUNDS::AXE_HIT, 1, ATTN_NORM);

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