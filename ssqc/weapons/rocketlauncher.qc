class rocketlauncher_c : weapon_c
{
    void () rocketlauncher_c = 
    {
        shoot_sound = "weapons/sgun1.wav";
        weapon = IT_ROCKET_LAUNCHER; // hud
        weapon_type = WEAPON::ROCKETLAUNCHER;
        ammo_type = IT_ROCKETS;
        weaponmodel = "progs/v_rock2.mdl";
        attack_finish_delay = .8;
        animation_func = player_rocket1;
        ammo_per_shot = 1;
        clip_size = 4;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};