class railgun_c : weapon_c
{
    void () railgun_c = 
    {
        shoot_sound = "weapons/railgun.wav";
        weapon = IT_SHOTGUN; // hud
        weapon_type = WEAPON::RAILGUN;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_rail.mdl";
        attack_finish_delay = .4;
        animation_func = player_shot1;
        ammo_per_shot = 1;
    };

    virtual void () Attack =
    {           
        super::Attack();
    };
};