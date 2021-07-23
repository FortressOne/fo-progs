class item_c : entity
{
    void () item_c =
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

    virtual void () Regen =
    {
        self.model = self.mdl;          // restore original model
        self.solid = SOLID_TRIGGER;     // allow it to be touched again
        sound(self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);    // play respawn sound
        setorigin(self, self.origin);
    };
};