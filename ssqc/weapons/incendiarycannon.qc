class incendiarycannon_c : weapon_c
{
    void () incendiarycannon_c = 
    {
        shoot_sound = "weapons/flmfire2.wav";
        weapon = IT_ROCKET_LAUNCHER; // hud
        weapon_type = WEAPON::INCENDIARYCANNON;
        ammo_type = IT_ROCKETS;
        weaponmodel = "progs/v_irock.mdl";
        attack_finish_delay = 1.2;
        animation_func = player_rocket1;
        ammo_per_shot = 3;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};