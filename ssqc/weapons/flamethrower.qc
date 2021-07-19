class flamethrower_c : weapon_c
{
    void () flamethrower_c = 
    {
        shoot_sound = "weapons/flmfire2.wav";
        weapon = IT_GRENADE_LAUNCHER; // hud
        weapon_type = WEAPON::FLAMETHROWER;
        ammo_type = IT_CELLS;
        weaponmodel = "progs/v_flame.mdl";
        attack_finish_delay = .15;
        animation_func = player_shot1;
        ammo_per_shot = 1;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};