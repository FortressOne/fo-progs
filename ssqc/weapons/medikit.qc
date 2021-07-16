class medikit_c : weapon_c
{
    void () medikit_c = 
    {
        shoot_sound = "weapons/ax1.wav";
        weapon = 0; // hud
        weapon_type = WEAPON::MEDIKIT;
        ammo_type = IT_CELLS;
        weaponmodel = "progs/v_medi.mdl";
        attack_finish_delay = 0.5;
        animation_func = player_axe1;
        ammo_per_shot = 0;
    };

    virtual void () Attack =
    {           
        float r = random();
        if (r < 0.25)
            this.animation_func = player_axe1;
        else if (r < 0.5)
            this.animation_func = player_axeb1;
        else if (r < 0.75)
            this.animation_func = player_axec1;
        else
            this.animation_func = player_axed1;
        super::Attack();
    };
};