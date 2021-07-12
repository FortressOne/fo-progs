class item_c : entity
{
    virtual void () Process =
    {
        this.nextthink = time + .2; // items start after other solids
    };
    
    virtual void () think =
    {
        this.mdl = this.model;          // so it can be restored on respawn
        this.flags = FL_ITEM;           // make extra wide
        this.solid = SOLID_TRIGGER;
        this.movetype = MOVETYPE_TOSS;  
        this.velocity = '0 0 0';
        this.origin_z = this.origin_z + 6;
        if (!droptofloor())
        {
            dprint ("Bonus item fell out of level at ");
            dprint (vtos(this.origin));
            dprint ("\n");
            remove(this);
            return;
        }
    };

    virtual void () touch = 
    {

    };
};