class proj_c : entity
{
    vector direction;
    float duration;

    void () proj_c =
    {
        if (!owner)
        {
            bprint(PRINT_HIGH, "owner on ", this.classname, " not set!\n");
            remove(this);
            return;
        }
        movetype = MOVETYPE_FLYMISSILE;
        solid = SOLID_BBOX;
        angles = vectoangles(direction);
        velocity = direction * 1000;
        setmodel (this, model);
        setsize (this, VEC_ORIGIN, VEC_ORIGIN);
        setorigin (this, origin);
        think = SUB_Remove;
        nextthink = time + duration;
    };
};