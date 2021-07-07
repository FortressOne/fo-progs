class supershotgun_c : shotgun_c 
{
    void () supershotgun_c =
    {
        SetDefaults();
    };

    nonvirtual void() SetDefaults =
    {
        shoot_sound = "weapons/shotgn2.wav";
        spread = '0.14 0.08 0';
        shot_count = 14;
        weapon = IT_SUPER_SHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_shot2.mdl";
        attack_finish_delay = 0.7;
        animation_func = player_shot1;
    };

    virtual void () Attack =
    {
        if (this.owner.currentammo == 1)
        {
            this.shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
            this.spread = shotgun_c::SPREAD_STATIC;
            this.shot_count = shotgun_c::SHOT_COUNT_STATIC;
            shotgun_c::Attack();
            SetDefaults();
            return;
        }

        super::Attack();

        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_BIGKICK);
        
        if (deathmatch != 4)
            this.owner.currentammo = this.owner.ammo_shells = this.owner.ammo_shells - 2;
        vector dir = aim(this.owner, 100000);
        FireBullets(shot_count, dir, spread);
    };
};