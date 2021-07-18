class weapon_c : entity
{
    float ammo_type;
    string shoot_sound;

    entity multi_ent;
    float multi_damage;
    vector blood_org;
    float blood_count;

    vector puff_org;
    float puff_count;

    float ammo_per_shot;
    float attack_finish_delay;
    float clip_size;
    float weapon_type;

    virtual void_f animation_func = __NULL__;

    get float ammo_count =
    {
        switch (this.ammo_type)
        {
            case IT_SHELLS:
                return this.owner.ammo_shells;
            case IT_NAILS:
                return this.owner.ammo_nails;
            case IT_ROCKETS:
                return this.owner.ammo_rockets;
            case IT_CELLS:
                return this.owner.ammo_cells;
        }
        return 0;
    };   

    nonvirtual float() HasAmmo =
    {
        if (this.ammo_count >= this.ammo_per_shot)
            return TRUE;
        
        return FALSE;
    };

    virtual float () Attack = 
    {
        player_c player = (player_c)this.owner;
        if (!this.HasAmmo())
        {
            player.current_weapon = player.GetBestWeapon();
            return FALSE;
        }
            
        makevectors(player.v_angle);                 // calculate forward angle for velocity
        player.show_hostile = time + 1;   // wake monsters up
        if (this.animation_func)
            this.animation_func();
            
        player.attack_finished = time + this.attack_finish_delay;
        sound(this.owner, CHAN_WEAPON, shoot_sound, 1, ATTN_NORM); 

        if (deathmatch != 4)
        {
            switch (this.ammo_type)
            {
                case IT_SHELLS:
                    this.owner.currentammo = this.owner.ammo_shells = this.owner.ammo_shells - this.ammo_per_shot;
                    break;
                case IT_NAILS:
                    this.owner.currentammo = this.owner.ammo_nails = this.owner.ammo_nails - this.ammo_per_shot;
                    break;
                case IT_ROCKETS:
                    this.owner.currentammo = this.owner.ammo_rockets = this.owner.ammo_rockets - this.ammo_per_shot;
                    break;
                case IT_CELLS:
                    this.owner.currentammo = this.owner.ammo_cells = this.owner.ammo_cells - this.ammo_per_shot;
                    break;
            }
        }

        return TRUE;
    };

    nonvirtual void(float damage, vector dir) TraceAttack =
    {       
        vector vel = normalize(dir + v_up*crandom() + v_right*crandom());
        vel = vel + 2*trace_plane_normal;
        vel = vel * 200;

        vector org = trace_endpos - dir*4;

        if (trace_ent.takedamage)
        {
            this.blood_count = this.blood_count + 1;
            this.blood_org = org;
            this.AddMultiDamage(trace_ent, damage);
        }
        else
        {
            this.puff_count = this.puff_count + 1;
        }
    };

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
    nonvirtual void(float shotcount, vector dir, vector spread) FireBullets =
    {
        player_c player = (player_c)this.owner;
        makevectors(player.v_angle);

        vector src = player.origin + v_forward*10;
        src_z = player.absmin_z + player.size_z * 0.7;

        this.ClearMultiDamage();

        traceline(src, src + dir*2048, FALSE, player);
        puff_org = trace_endpos - dir*4;

        while (shotcount > 0)
        {
            vector direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
            traceline(src, src + direction*2048, FALSE, player);
            if (trace_fraction != 1.0)
                this.TraceAttack(4, direction);

            shotcount = shotcount - 1;
        }
        this.ApplyMultiDamage();
        this.Multi_Finish();
    };

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

    nonvirtual void(entity hit, float damage) AddMultiDamage =
    {
        if (!hit)
            return;
        
        if (hit != this.multi_ent)
        {
            // apply damage to last multi ent
            this.ApplyMultiDamage();


            this.multi_damage = damage;
            this.multi_ent = hit;
        }
        else
            this.multi_damage = this.multi_damage + damage;
    };

    nonvirtual void() ApplyMultiDamage =
    {
        if (!this.multi_ent)
            return;

        T_Damage(this.multi_ent, this.owner, this.owner, this.multi_damage);
    };

    nonvirtual void() ClearMultiDamage =
    {
        this.multi_ent = world;
        this.multi_damage = 0;
        this.blood_count = 0;
        this.puff_count = 0;
    };

    nonvirtual void() Multi_Finish =
    {
        if (this.puff_count)
        {
            WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
            WriteByte (MSG_MULTICAST, TE_GUNSHOT);
            WriteByte (MSG_MULTICAST, this.puff_count);
            WriteCoord (MSG_MULTICAST, this.puff_org_x);
            WriteCoord (MSG_MULTICAST, this.puff_org_y);
            WriteCoord (MSG_MULTICAST, this.puff_org_z);
            multicast (this.puff_org, MULTICAST_PVS);
        }

        if (this.blood_count)
        {
            WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
            WriteByte (MSG_MULTICAST, TE_BLOOD);
            WriteByte (MSG_MULTICAST, this.blood_count);
            WriteCoord (MSG_MULTICAST, this.blood_org_x);
            WriteCoord (MSG_MULTICAST, this.blood_org_y);
            WriteCoord (MSG_MULTICAST, this.blood_org_z);
            multicast (this.puff_org, MULTICAST_PVS);
        }
    };
};