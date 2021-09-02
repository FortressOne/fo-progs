class grenade_mirv_c : grenade_hand_c
{   
    void () grenade_mirv_c =
    {
        classname = "mirvgrenade";
        netname = "Mirv grenade";
        model = MODELS::GRENADE_MIRV;
        this.skin = 0;
        this.avelocity = '0 300 0';
    };

    static void (player_c player) Prime =
    {
        grenade_mirv_c gren = spawn(grenade_mirv_c, owner: player);
        gren.damage = 100;
        player.primed_grenade = gren;
    };

    virtual void () think =
    {
        this.CheckMaxActiveGrenLimit();

        for (float i = 0; i < 4; i++)
        {
            this.LaunchGrenade();
        }
        this.Explode();       
    };

    nonvirtual void () LaunchGrenade =
    {
        vector org = this.origin + '0 0 -1';
        float xdir = (150 * random() - 75) * 2;
        float ydir = (150 * random() - 75) * 2;
        float zdir = (40 * random()) * 15;

        proj_grenade_c ent = ::spawn(proj_grenade_c, origin: org, owner: this.owner);
        ent.nextthink = time + 2 + random();
        ent.velocity = [xdir, ydir, zdir];
        ent.avelocity = '250 300 400';
    };
};