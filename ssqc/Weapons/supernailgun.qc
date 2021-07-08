class supernailgun_c : weapon_c
{
    void () supernailgun_c = 
    {
        shoot_sound = "weapons/spike2.wav";
        weapon = IT_NAILGUN; // hud
        weapon_type = WEAPON::SUPERNAILGUN;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_nail2.mdl";
        attack_finish_delay = .2;
        animation_func = player_nail1;
        ammo_per_shot = 2;
    };

    virtual void () Attack =
    {           
        super::Attack();
    };
};