class tranquiliser_c : weapon_c
{
    void () tranquiliser_c = 
    {
        shoot_sound = "weapons/dartgun.wav";
        weapon = IT_SHOTGUN; // hud
        weapon_type = WEAPON::TRANQUILISER;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_tranq.mdl";
        attack_finish_delay = 1.5;
        animation_func = player_shot1;
        ammo_per_shot = 1;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};