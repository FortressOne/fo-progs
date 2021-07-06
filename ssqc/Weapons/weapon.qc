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

    set float ammo_count = { return; };

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

    nonvirtual weapon_c() GetBestWeapon =
    {
        float it = this.owner.items;

        if (this.owner.waterlevel <= 1 && this.owner.ammo_cells >= 1 && (it & IT_LIGHTNING))
            return IT_LIGHTNING;
        else if(this.owner.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
            return IT_SUPER_NAILGUN;
        else if(this.owner.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
            return IT_SUPER_SHOTGUN;
        else if(this.owner.ammo_nails >= 1 && (it & IT_NAILGUN) )
            return IT_NAILGUN;
        else if(this.owner.ammo_shells >= 1 && (it & IT_SHOTGUN)  )
            return IT_SHOTGUN;
            
    /*
        if(self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) )
            return IT_ROCKET_LAUNCHER;
        else if(self.ammo_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) )
            return IT_GRENADE_LAUNCHER;

    */

        return IT_AXE;
    };

    nonvirtual float() HasAmmo =
    {
        if (this.weapon == IT_AXE)
            return TRUE;

        if (this.amount_count >= this.ammo_per_shot)
            return TRUE;
        
        this.owner.current_weapon = this.GetBestWeapon();
        
    // drop the weapon down
        return FALSE;
    };

    virtual void () Attack = 
    {
        if (!this.HasAmmo())
            return;

        makevectors(this.owner.v_angle);                 // calculate forward angle for velocity
        this.owner.show_hostile = time + 1;   // wake monsters up

        if (self.weapon == IT_AXE)
        {
            self.attack_finished = time + 0.5;
            sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
            float r = random();
            if (r < 0.25)
                player_axe1 ();
            else if (r<0.5)
                player_axeb1 ();
            else if (r<0.75)
                player_axec1 ();
            else
                player_axed1 ();
        }
        else if (self.weapon == IT_SHOTGUN)
        {
            player_shot1 ();
            self.attack_finished = time + 0.5;
            W_FireShotgun ();
        }
        else if (self.weapon == IT_SUPER_SHOTGUN)
        {
            player_shot1 ();
            self.attack_finished = time + 0.7;
            W_FireSuperShotgun ();
        }
        else if (self.weapon == IT_NAILGUN)
        {
            player_nail1 ();
        }
        else if (self.weapon == IT_SUPER_NAILGUN)
        {
            player_nail1 ();
        }
        else if (self.weapon == IT_GRENADE_LAUNCHER)
        {
            player_rocket1();
            self.attack_finished = time + 0.6;
            W_FireGrenade();
        }
        else if (self.weapon == IT_ROCKET_LAUNCHER)
        {
            player_rocket1();
            self.attack_finished = time + 0.8;
            W_FireRocket();
        }
        else if (self.weapon == IT_LIGHTNING)
        {
            self.attack_finished = time + 0.1;
            sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
            player_light1();
        }
    };

    nonvirtual void () Frame =
    {
        if (time < self.attack_finished)
            return;

        ImpulseCommands();
        
        // check for attack
        if (self.button0)
        {
            SuperDamageSound();
            this.Attack();
        }
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