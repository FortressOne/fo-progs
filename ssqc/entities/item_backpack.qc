class item_backpack_c : entity 
{
    weapon_c held_weapon;
    float ammunition_shells;
    float ammunition_nails;
    float ammunition_rockets;
    float ammunition_cells;

    // owner needs to be set
    void () item_backpack_c =
    {
        if (!this.owner)
        {
            objerror("item_backpack_c does not have owner set");
            return;
        }
            
        player_c player = (player_c)this.owner;

        if (!(player.ammunition_shells + player.ammunition_nails + player.ammunition_rockets + player.ammunition_cells))
            return; // nothing in it
        
        this.origin = player.origin - '0 0 24';


        this.ammunition_shells = player.ammunition_shells;
        this.ammunition_nails = player.ammunition_nails;
        this.ammunition_rockets = player.ammunition_rockets;
        this.ammunition_cells = player.ammunition_cells;

        this.velocity_z = 300;
        this.velocity_x = -100 + (random() * 200);
        this.velocity_y = -100 + (random() * 200);
        
        this.flags = FL_ITEM;
        this.solid = SOLID_TRIGGER;
        this.movetype = MOVETYPE_TOSS;
        setmodel (this, "progs/backpack.mdl");
        setsize (this, '-16 -16 0', '16 16 56');
        
        this.nextthink = time + 120;    // remove after 2 minutes
        this.think = SUB_Remove;
    };

    virtual void () touch =
    {      
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;

        player_c player = (player_c)other;

        player.ammunition_shells = player.ammunition_shells + this.ammunition_shells;
        player.ammunition_nails = player.ammunition_nails + this.ammunition_nails;
        player.ammunition_rockets = player.ammunition_rockets + this.ammunition_rockets;
        player.ammunition_cells = player.ammunition_cells + this.ammunition_cells;

        sprint(other, PRINT_LOW, "You get ");

        float hasOther = FALSE;
        if (this.ammunition_shells)
        {
            sprint (other, PRINT_LOW, ftos(this.ammunition_shells), " shells");
            hasOther = TRUE;
        }
        if (this.ammunition_nails)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammunition_nails), " nails");
            hasOther = TRUE;
        }
        if (this.ammunition_rockets)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammunition_rockets), " rockets");
            hasOther = TRUE;
        }
        if (this.ammunition_cells)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammunition_cells), " cells");
        }

        sprint(other, PRINT_LOW, "\n");
    // backpack touch sound
        sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
        stuffcmd (other, "bf\n");

        remove(this);
    };
};