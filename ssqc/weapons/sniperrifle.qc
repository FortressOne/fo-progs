class sniperrifle_c : weapon_c
{
    void () sniperrifle_c = 
    {
        shoot_sound = "weapons/sniper.wav";
        weapon = IT_SHOTGUN; // hud
        weapon_type = WEAPON::SNIPERRIFLE;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_srifle.mdl";
        attack_finish_delay = 1.5;
        animation_func = player_shot1;
        ammo_per_shot = 1;

        // TODO - setting for 2.8 sniper rifle no clip vs fo sniper rifle
        clip_size = 1;
    };

    virtual float () Attack =
    {           
        return super::Attack();
    };
};