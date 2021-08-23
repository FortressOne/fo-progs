class supershotgun_c : weapon_c 
{
    vector spread;
    float shot_count;
    
    void () supershotgun_c =
    {
        SetDefaults();
    };

    nonvirtual void() SetDefaults =
    {
        classname = "player_supershotgun";
        netname = "Super Shotgun";
        shoot_sound = SOUNDS::SUPERSHOTGUN_SHOOT;
        spread = '0.14 0.08 0';
        shot_count = 14;
        weapon = IT_SUPER_SHOTGUN; // hud
        weapon_type = WEAPON::SUPERSHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = MODELS::VIEW_SUPERSHOTGUN;
        attack_finish_delay = 0.7;
        animation_func = player_shot1;
        ammo_per_shot = 2;
        clip_size = 16;
        reload_time = 3;
    };

    virtual float () Attack =
    {
        if (this.owner.currentammo == 1)
        {
            //shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
            shoot_sound = SOUNDS::SHOTGUN_SHOOT;
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