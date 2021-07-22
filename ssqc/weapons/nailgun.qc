class nailgun_c : weapon_c
{
    void () nailgun_c = 
    {
        classname = "player_nailgun";
        shoot_sound = "weapons/rocket1i.wav";
        weapon = IT_NAILGUN; // hud
        weapon_type = WEAPON::NAILGUN;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_nail.mdl";
        attack_finish_delay = .2;
        animation_func = player_nail1;
        ammo_per_shot = 1;
    };

    virtual float () Attack =
    {           
        if (!this.owner.button0 || GameManager.intermission_running)
        {
            player_run();
            return FALSE;
        }
        float offset = 4;
        if (this.weaponframe % 2 == 0)
        {
            this.animation_func = player_nail1;
            offset = 4;
        }
        else
        {
            this.animation_func = player_nail2;
            offset = -4;
        }

        if (!super::Attack())
            return FALSE;

        muzzleflash();

        this.weaponframe++;
        if (this.weaponframe == 9)
            this.weaponframe = 1;

        this.owner.weaponframe++;
        if (this.owner.weaponframe == 9)
            this.owner.weaponframe = 1;
        
        
        item_artifact_super_damage::ShootSound((player_c)this.owner);
        this.FireSpikes(offset);
        
        return TRUE;
    };

    nonvirtual void (float offset) FireSpikes =
    {
        makevectors(this.owner.v_angle);
        
        if (this.HasAmmo() && this.weapon == IT_SUPER_NAILGUN)
        {
            W_FireSuperSpikes();
            return;
        }
        player_c player = (player_c)this.owner;

        if (player.ammunition_nails < 1)
        {
            player.current_weapon = player.GetBestWeapon();
            return;
        }

        sound(player, CHAN_WEAPON, this.shoot_sound, 1, ATTN_NORM);
        player.attack_finished = time + this.attack_finish_delay;

        vector dir = aim (player, 1000);
        vector org = player.origin + '0 0 16' + v_right*offset;
        proj_spike_c ent = ::spawn(proj_spike_c, origin: org, direction: dir, owner: this.owner);
        
        msg_entity = player;
        WriteByte (MSG_ONE, SVC_SMALLKICK);
    };
};