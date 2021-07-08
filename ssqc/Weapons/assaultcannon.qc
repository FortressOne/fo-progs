class assaultcannon_c : shotgun_c
{
    void () assaultcannon_c = 
    {
        shoot_sound = "weapons/asscan1.wav";
        weapon = IT_ROCKET_LAUNCHER; // hud
        weapon_type = WEAPON::ASSAULTCANNON;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_asscan.mdl";
        attack_finish_delay = .2;
        animation_func = player_rocket1;
        ammo_per_shot = 1;
        shot_count = 8;
    };

    virtual void () Attack =
    {           
        super::Attack();
    };
};