class bubble_c : entity 
{
    float nextthink_time;

    void () bubble_c =
    {
        nextthink_time = .5;
        setmodel(this, MODELS::BUBBLE);
        setorigin(this, this.origin);
        movetype = MOVETYPE_NOCLIP;
        solid = SOLID_NOT;
        if (velocity == '0 0 0')
            velocity = '0 0 15';
        nextthink = time + nextthink_time;
        classname = "bubble";
        setsize(this,'-8 -8 -8', '8 8 8');
    };

    virtual void () touch =
    {
        if (other.classname == this.classname)
            return;

        remove(this);
    };

    nonvirtual void () Split =
    {
        this.frame = 1;
        this.cnt = 10;
        bubble_c new = spawn(bubble_c, velocity: this.velocity, frame: this.frame, cnt: this.cnt);

        if (this.waterlevel != 3)
            remove(this);
    };

    virtual void () think =
    {
        this.cnt = this.cnt + 1;
        if (this.cnt == 4)
            this.Split();

        if (this.cnt == 20)
        {
            remove(this);
            return;
        }

        float rnd1 = this.velocity_x + (-10 + random() * 20);
        float rnd2 = this.velocity_y + (-10 + random() * 20);
        float rnd3 = this.velocity_z + 10 + random() * 10;

        if (rnd1 > 10)
            rnd1 = 5;
        else if (rnd1 < -10)
            rnd1 = -5;

        if (rnd2 > 10)
            rnd2 = 5;
        else if (rnd2 < -10)
            rnd2 = -5;

        if (rnd3 < 10)
            rnd3 = 15;
        else if (rnd3 > 30)
            rnd3 = 25;

        this.velocity_x = rnd1;
        this.velocity_y = rnd2;
        this.velocity_z = rnd3;

        this.nextthink = time + nextthink_time;
    };
};

class bubble_spawner_c : entity
{
    float spawn_count;
    float spawned;

    void () bubble_spawner_c =
    {
        if (this.owner.waterlevel != 3)
        {
            remove(this);
            return;
        }
        vector org = this.owner.origin + '0 0 24';
        setorigin(this, org);
        movetype = MOVETYPE_NONE;
        solid = SOLID_NOT;
        this.RestartTimer();
    };

    nonvirtual void () RestartTimer =
    {
        nextthink = time + 0.1;
    };

    static void (float num, entity owning_ent) Spawn =
    {
        bubble_spawner_c ent = spawn(bubble_spawner_c, spawn_count: num, owner: owning_ent);
    };

    virtual void () think =
    {
        this.RestartTimer();
        bubble_c bubble = spawn(bubble_c, origin: this.origin);
        this.spawned = this.spawned + 1;

        if (this.spawned >= this.spawn_count)
            remove(this);
    };
};