#define SHOTGUN_SHOOT_SOUND "weapons/guncock.wav"
#define SHOTGUN_SPREAD '0.04 0.04 0'
#define SHOTGUN_SHOT_COUNT 6

class shotgun_c : weapon_c
{
    vector spread;
    float shot_count;
    //static string SHOOT_SOUND_STATIC = "weapons/guncock.wav";
    //static vector SPREAD_STATIC = '0.04 0.04 0';
    //static float SHOT_COUNT_STATIC = 6;
    
    void () shotgun_c = 
    {
        classname = "player_shotgun";
        //shoot_sound = shotgun_c::SHOOT_SOUND_STATIC; // or something
        shoot_sound = SHOTGUN_SHOOT_SOUND;
        //spread = shotgun_c::SPREAD_STATIC;
        spread = SHOTGUN_SPREAD;
        //shot_count = shotgun_c::SHOT_COUNT_STATIC;
        shot_count = SHOTGUN_SHOT_COUNT;
        weapon = IT_SHOTGUN; // hud
        weapon_type = WEAPON::SHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_shot.mdl";
        attack_finish_delay = 0.5;
        animation_func = player_shot1;
        ammo_per_shot = 1;
        clip_size = 8;
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