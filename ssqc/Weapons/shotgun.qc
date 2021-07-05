class shotgun_c : weapon_c
{
    vector spread;
    float shot_count;
    
    void () shotgun_c = 
    {
        shoot_sound = "weapons/guncock.wav";
        spread = '0.04 0.04 0';
        shot_count = 6;
    };

    virtual void () Attack =
    {
        //super::Attack();
        sound(this.owner, CHAN_WEAPON, shoot_sound, 1, ATTN_NORM); 

        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_SMALLKICK);
        
        if (deathmatch != 4)
            this.owner.currentammo = this.owner.ammo_shells = this.owner.ammo_shells - 1;

        vector dir = aim(this.owner, 100000);
        this.FireBullets(shot_count, dir, spread);
    };
};