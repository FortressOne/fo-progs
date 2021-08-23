#define SHOTGUN_SPREAD '0.04 0.04 0'
#define SHOTGUN_SHOT_COUNT 6

class shotgun_c : weapon_c
{
    vector spread;
    float shot_count;
    //const string SHOOT_SOUND = "weapons/guncock.wav";
    //static vector SPREAD_STATIC = '0.04 0.04 0';
    //static float SHOT_COUNT_STATIC = 6;
    
    void () shotgun_c = 
    {
        classname = "player_shotgun";
        netname = "Shotgun";
        //shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
        shoot_sound = SOUNDS::SHOTGUN_SHOOT;
        //spread = shotgun_c::SPREAD_STATIC;
        spread = SHOTGUN_SPREAD;
        shot_count = SHOTGUN_SHOT_COUNT;
        weapon = IT_SHOTGUN; // hud
        weapon_type = WEAPON::SHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = MODELS::VIEW_SHOTGUN;
        attack_finish_delay = 0.5;
        animation_func = player_shot1;
        ammo_per_shot = 1;
        clip_size = 8;
        reload_time = 2;
    };

    virtual float () Attack =
    {
        if (!super::Attack())
            return FALSE;
        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_SMALLKICK);

        vector dir = aim(this.owner, 100000);
        this.FireBullets(shot_count, dir, spread);

        return TRUE;
    };
};