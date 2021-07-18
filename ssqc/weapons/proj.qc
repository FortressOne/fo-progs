class proj_c : entity
{
    float origin_set;
    vector _origin;
    get vector origin =
    {
        return _origin;
    };
    set vector origin = 
    {
        origin_set = TRUE;
        _origin = value;
    };

    float direction_set;
    vector _direction;
    set vector direction =
    {
        _direction = value;
        direction_set = TRUE;
    };
    get vector direction =
    {
        return _direction;
    };

    float duration;

    static proj_c (vector org, vector dir, entity own, string cname, string model, float durat) spawn =
    {
        proj_c ent = ::spawn(proj_c);
        ent.duration = durat;
        ent.classname = cname;
        ent.think = ent.FieldCheck; // accessors don't work
        ent.nextthink = time + .02;
        ent.movetype = MOVETYPE_FLYMISSILE;
        ent.solid = SOLID_BBOX;
        ent.owner = own;
        ent.origin = org;
        ent.direction = dir;
        ent.angles = vectoangles(ent.direction);
        ent.velocity = ent.direction * 1000;
        setmodel (ent, model);
        setsize (ent, VEC_ORIGIN, VEC_ORIGIN);
        setorigin (ent, origin);
        return ent;
    };

    nonvirtual void () FieldCheck =
    {
        if (!direction_set)
        {
            bprint(PRINT_HIGH, "direction on ", this.classname, " not set!\n");
            remove(this);
            return;
        }
        if (!origin_set)
        {
            bprint(PRINT_HIGH, "origin on ", this.classname, " not set!\n");
            remove(this);
            return;
        }
        if (!owner)
        {
            bprint(PRINT_HIGH, "owner on ", this.classname, " not set!\n");
            remove(this);
            return;
        }
        this.think = SUB_Remove;
        this.nextthink = time + duration;
    };
};