class shotgun_c : weapon_c
{
    vector spread;
    float shot_count;
    static string SHOOT_SOUND_STATIC = "weapons/guncock.wav";
    static vector SPREAD_STATIC = '0.04 0.04 0';
    static float SHOT_COUNT_STATIC = 6;
    
    void () shotgun_c = 
    {
        shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
        spread = shotgun_c::SPREAD_STATIC;
        shot_count = shotgun_c::SHOT_COUNT_STATIC;
        weapon = IT_SHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_shot.mdl";
        attack_finish_delay = 0.5;
        animation_func = player_shot1;
    };

    virtual void () Attack =
    {
        super::Attack();

        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_SMALLKICK);
        
        if (deathmatch != 4)
            this.owner.currentammo = this.owner.ammo_shells = this.owner.ammo_shells - 1;

        vector dir = aim(this.owner, 100000);
        this.FireBullets(shot_count, dir, spread);
    };
};