class grenade_hand_c : entity
{
    float explode_radius;
    float _damage;
    get float damage =
    {
        return _damage;
    };
    set float damage =
    {
        explode_radius = value;
        _damage = value;
    };

    float is_thrown;

    void () grenade_hand_c =
    {
        nextthink = time + 3.8;
        
        if (owner)
            sprint(owner, PRINT_HIGH, strcat(netname, " primed, 3 seconds...\n"));
    };

    static void (player_c player) Prime =
    {
        grenade_hand_c gren = spawn(grenade_hand_c, model: MODELS::GRENADE_HAND, owner: player, classname: "handgrenade", netname: "Grenade");
        gren.damage = 180;
        player.primed_grenade = gren;
    };

    nonvirtual void () Throw =
    {
        makevectors(this.owner.v_angle);

        if (this.owner.v_angle_x) 
        {
            this.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 +
                crandom() * v_up * 10;
        } 
        else 
        {
            this.velocity = aim(this.owner, 10000);
            this.velocity = this.velocity * 600;
            this.velocity_z = 200;
        }
        this.angles = vectoangles(this.velocity);

        this.movetype = MOVETYPE_BOUNCE;
        solid = SOLID_BBOX;
        
        setmodel(this, model);
        setsize(this, VEC_ORIGIN, VEC_ORIGIN);
        setorigin(this, this.owner.origin);
        is_thrown = TRUE;
        player_c player = (player_c)this.owner;
        player.primed_grenade = __NULL__;

        sound(this.owner, CHAN_AUTO, SOUNDS::AXE_SHOOT, 1, ATTN_NORM);
    };

    virtual void () Explode =
    {
        if (!is_thrown)
            setorigin(this, this.owner.origin);

        if (this.damage)
            T_RadiusDamage(this, this.owner, this.damage, world);
        
        // FIXME - another findradius loop, not very efficient but much easier to code
        this.ApplyEffect();

        this.ParticleEffect();
        
        remove(this);
    };

    virtual void () ParticleEffect =
    {
        te_explosion(this.origin);
    };

    virtual void () ApplyEffect =
    {

    };

    virtual void () touch =
    {
        if (other == this.owner)
            return;

        sound(this, CHAN_WEAPON, SOUNDS::BOUNCE, 1, ATTN_NORM);
        if (this.velocity == '0 0 0')
            this.avelocity = '0 0 0';
    };

    virtual void () think =
    {
        this.Explode();
    };

    virtual void () CheckMaxActiveGrenLimit =
    {
        float count = 1;
        entity ent = find(world, ::classname, this.classname);

        while (ent)
        {
            if (ent.owner == this.owner && ent != this)
            {
                count++;
                player_c player = (player_c)this.owner;
                float limit = player.tf_class.max_activegren2;
                if (limit != 0)
                {
                    if (count >= limit)
                    {
                        remove(ent);
                        count--;
                    }
                }
            }

            ent = find(ent, ::classname, this.classname);
        }
    };
};