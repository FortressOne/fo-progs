class knife_c : weapon_c
{
    void () knife_c = 
    {
        shoot_sound = "weapons/ax1.wav";
        weapon = 0; // hud
        weapon_type = WEAPON::KNIFE;
        ammo_type = IT_CELLS;
        weaponmodel = "progs/v_knife.mdl";
        // bloody one is v_knife2
        attack_finish_delay = 0.5;
        animation_func = player_axe1;
        ammo_per_shot = 0;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};