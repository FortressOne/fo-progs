class grenadelauncher_c : weapon_c
{
    void () grenadelauncher_c = 
    {
        shoot_sound = "weapons/grenade.wav";
        weapon = IT_GRENADE_LAUNCHER; // hud
        weapon_type = WEAPON::GRENADELAUNCHER;
        ammo_type = IT_ROCKETS;
        weaponmodel = "progs/v_rock.mdl";
        attack_finish_delay = .6;
        animation_func = player_rocket1;
        ammo_per_shot = 1;
        clip_size = 6;
    };

    virtual void () Attack =
    {           
        super::Attack();
    };
};