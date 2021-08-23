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
    float clip_left;
    float reload_time;
    float weapon_type;

    virtual void_f animation_func = __NULL__;

    get float ammo_count =
    {
        player_c player = (player_c)owner;
        switch (this.ammo_type)
        {
            case IT_SHELLS:
                return player.ammunition_shells;
            case IT_NAILS:
                return player.ammunition_nails;
            case IT_ROCKETS:
                return player.ammunition_rockets;
            case IT_CELLS:
                return player.ammunition_cells;
        }
        return 0;
    };

    void () weapon_c =
    {
        clip_left = clip_size;
    };

    static weapon_c (WEAPON weap, entity player) spawn =
    {
        weapon_c ret = __NULL__;
        switch (weap)
        {
            case WEAPON::NAILGUN:
                ret = ::spawn(nailgun_c, owner: player);
                break;
            case WEAPON::SHOTGUN:
                ret = ::spawn(shotgun_c, owner: player);
                break;
            case WEAPON::AXE:
                ret = ::spawn(axe_c, owner: player);
                break;
        }
        return ret;
    };

    nonvirtual float () HasAmmo =
    {
        if (this.ammo_count >= this.ammo_per_shot)
            return TRUE;
        
        return FALSE;
    };

    nonvirtual float () IsReady =
    {
        player_c player = (player_c)this.owner;
        if (player.attack_finished > time)
            return FALSE;

        if (player.is_reloading)
            return FALSE;

        return TRUE;
    };

    nonvirtual void () Reload =
    {
        player_c player = (player_c)this.owner;
        if (player.is_reloading)
            return;

        if (this.clip_left == this.clip_size)
        {
            sprint(player, PRINT_HIGH, "Clip full\n");
            return;
        }

        string ammo_type_string = "";
        switch (this.ammo_type)
        {
            case IT_SHELLS:
                ammo_type_string = "shells";
                break;
            case IT_NAILS:
                ammo_type_string = "nails";
                break;
            case IT_ROCKETS:
                if (this.weapon_type == WEAPON::GRENADELAUNCHER)
                {
                    ammo_type_string = "grenades";
                }
                else
                {
                    ammo_type_string = "rockets";
                }
                break;
            case IT_CELLS:
                ammo_type_string = "cells";
                break;
        }

        float ammo_left = this.ammo_count;

        if (this.clip_left == ammo_left)
        {
            sprint(player, PRINT_HIGH, strcat("All ", ammo_type_string, " are in the clip\n"));
            return;
        }

        if (ammo_left <= 0)
        {
            sprint(player, PRINT_HIGH, "Out of ", ammo_type_string, "\n");
            return;
        }

        float amount = this.clip_size - this.clip_left;
        if (amount > ammo_left)
            amount = ammo_left;

        float time_to_reload = this.reload_time * (amount / this.clip_size));
        sprint(player, PRINT_HIGH, strcat("Reloading ", this.netname, "...\n"));
        entity timer = ::spawn();
        timer.owner = this;
        timer.nextthink = time + time_to_reload;
        timer.think = weapon_c::ReloadNow;
        player.is_reloading = TRUE;
    };

    static void () ReloadNow =
    {
        weapon_c weap = (weapon_c)self.owner;
        weap.clip_left = weap.clip_size;
        player_c player = (player_c)weap.owner;
        player.is_reloading = FALSE;
    };

    virtual float () Attack = 
    {
        player_c player = (player_c)this.owner;
        if (player.is_reloading)
            return FALSE;

        if (!this.HasAmmo())
        {
            player.current_weapon = player.GetBestWeapon();
            return FALSE;
        }
            
        makevectors(player.v_angle);                 // calculate forward angle for velocity
        player.show_hostile = time + 1;   // wake monsters up
        if (this.animation_func)
            this.animation_func();
        else
            bprint(PRINT_HIGH, "animation func not set\n");
            
        sound(player, CHAN_WEAPON, shoot_sound, 1, ATTN_NORM); 

        weapon_c::AdjustAmmo(player, this);
        player.attack_finished = time + this.attack_finish_delay;
        
        return TRUE;
    };

    nonvirtual void (entity p, entity w) AdjustAmmo =
    {
        player_c player = (player_c)p;
        weapon_c weapon = (weapon_c)w;

        switch (weapon.ammo_type)
        {
            case IT_SHELLS:
                player.currentammo = player.ammunition_shells = player.ammunition_shells - weapon.ammo_per_shot;
                break;
            case IT_NAILS:
                player.currentammo = player.ammunition_nails = player.ammunition_nails - weapon.ammo_per_shot;
                break;
            case IT_ROCKETS:
                player.currentammo = player.ammunition_rockets = player.ammunition_rockets - weapon.ammo_per_shot;
                break;
            case IT_CELLS:
                player.currentammo = player.ammunition_cells = player.ammunition_cells - weapon.ammo_per_shot;
                break;
        }

        weapon.clip_left = weapon.clip_left - weapon.ammo_per_shot;
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