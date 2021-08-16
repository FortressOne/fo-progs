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
        animation_func = __NULL__;
        ammo_per_shot = 1;
    };

    virtual float () Attack =
    {
        player_c player = (player_c)this.owner;
        this.animation_func = player.Anim_Nail1;

        if (!super::Attack())
            return FALSE;

        return TRUE;
    };

    
	static float (entity weap) NailLogic =
	{
		if (!weap.owner.button0 || GameManager.intermission_running)
        {
			weap.owner.weaponframe = 0;
            player_run();
            return FALSE;
        }

		muzzleflash();

		weap.owner.weaponframe++;
		if (weap.owner.weaponframe == 9)
			weap.owner.weaponframe = 1;

		float offset = 4;
		if (weap.owner.weaponframe % 2 == 1)
		{
			offset = -4;
		}

        item_artifact_super_damage::ShootSound((player_c)weap.owner);
		nailgun_c::FireSpikes(self, (player_c)weap.owner, offset);

		return TRUE;
	};

    nonvirtual void (entity weap, player_c player, float offset) FireSpikes =
    {
        nailgun_c ng = (nailgun_c)weap;
        makevectors(player.v_angle);
        
        if (ng.HasAmmo() && ng.weapon == IT_SUPER_NAILGUN)
        {
            W_FireSuperSpikes();
            return;
        }

        if (player.ammunition_nails < 1)
        {
            player.current_weapon = player.GetBestWeapon();
            return;
        }

        weapon_c::AdjustAmmo(player, ng);
        sound(player, CHAN_WEAPON, ng.shoot_sound, 1, ATTN_NORM);
        player.attack_finished = time + ng.attack_finish_delay;

        // FIXME - regression recently, broke nailgun nails, even particles on shotgun/axe etc
        // assume related to bad origin from player...
        vector dir = aim (player, 1000);
        vector org = player.origin + '0 0 16' + v_right*offset;
        proj_spike_c ent = ::spawn(proj_spike_c, origin: org, direction: dir, owner: player);
        
        msg_entity = player;
        WriteByte (MSG_ONE, SVC_SMALLKICK);
    };
};