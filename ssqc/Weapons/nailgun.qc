class nailgun_c : weapon_c
{
    void () nailgun_c = 
    {
        shoot_sound = "weapons/rocket1i.wav";
        weapon = IT_NAILGUN; // hud
        weapon_type = WEAPON::NAILGUN;
        ammo_type = IT_NAILS;
        weaponmodel = "progs/v_nail.mdl";
        attack_finish_delay = .2;
        animation_func = player_nail1;
        ammo_per_shot = 1;
    };

    virtual void () Attack =
    {           
        super::Attack();
    };
};