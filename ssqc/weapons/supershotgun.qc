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
        weapon = IT_SUPER_SHOTGUN; // hud
        weapon_type = WEAPON::SUPERSHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_shot2.mdl";
        attack_finish_delay = 0.7;
        animation_func = player_shot1;
        ammo_per_shot = 2;
        clip_size = 16;
    };

    virtual float () Attack =
    {
        if (this.owner.currentammo == 1)
        {
            //shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
            shoot_sound = SHOTGUN_SHOOT_SOUND;
            //spread = shotgun_c::SPREAD_STATIC;
            spread = SHOTGUN_SPREAD;
            //shot_count = shotgun_c::SHOT_COUNT_STATIC;
            shot_count = SHOTGUN_SHOT_COUNT;
            ammo_per_shot = 1;
            shotgun_c::Attack();
            SetDefaults();
            return TRUE;
        }

        if(!super::Attack())
            return FALSE;

        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_BIGKICK);
        
        vector dir = aim(this.owner, 100000);
        FireBullets(shot_count, dir, spread);

        return TRUE;
    };
};