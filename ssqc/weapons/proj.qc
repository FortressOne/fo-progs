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

    virtual void (vector org, vector dir, entity own) Setup =
    {
        this.think = this.FieldCheck; // accessors don't work
        this.nextthink = time + .02;
        this.movetype = MOVETYPE_FLYMISSILE;
        this.solid = SOLID_BBOX;
        this.owner = own;
        this.origin = org;
        this.direction = dir;
        newmis.angles = vectoangles(this.direction);
        newmis.velocity = this.direction * 1000;
        setmodel (newmis, this.model);
        setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
        setorigin (newmis, origin);
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