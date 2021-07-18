class nailgun_c : weapon_c
{
    void () nailgun_c = 
    {
        shoot_sound = "weapons/rocket1i.wav";
        weapon = IT_NAILGUN; // hud
        weapon_type = WEAPON::NAILGUN;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_nail.mdl";
        attack_finish_delay = .2;
        animation_func = __NULL__;
        ammo_per_shot = 1;
    };

    virtual float () Attack =
    {           
        if (!this.owner.button0 || GameManager.intermission_running)
        {
            player_run();
            return FALSE;
        }

        if (!super::Attack())
            return FALSE;

        muzzleflash();
        this.owner.weaponframe++;
        if (this.owner.weaponframe == 9)
            this.owner.weaponframe = 1;
        
        item_artifact_super_damage_c::ShootSound((player_c)this.owner);

        if (this.owner.weaponframe % 2 == 0)
        {
            this.FireSpikes(4);
            player_nail1();
        }
        else
        {
            this.FireSpikes(-4);
            player_nail2();
        }
        return this.Attack(); // this will always return false...
    };

    nonvirtual void (float offset) FireSpikes =
    {
        makevectors(this.owner.v_angle);
        
        if (this.HasAmmo() && this.weapon == IT_SUPER_NAILGUN)
        {
            W_FireSuperSpikes();
            return;
        }

        if (this.owner.ammo_nails < 1)
        {
            player_c player = (player_c)self.owner;
            player.current_weapon = player.GetBestWeapon();
            return;
        }

        sound(this.owner, CHAN_WEAPON, this.shoot_sound, 1, ATTN_NORM);
        this.owner.attack_finished = time + this.attack_finish_delay;
        if (deathmatch != 4)
            this.owner.currentammo = this.owner.ammo_nails = this.owner.ammo_nails - this.ammo_per_shot;

        vector dir = aim (this.owner, 1000);
        proj_spike_c ent = proj_spike_c::spawn(this.owner.origin + '0 0 16' + v_right*offset, dir, self);

        msg_entity = this.owner;
        WriteByte (MSG_ONE, SVC_SMALLKICK);
    };
};