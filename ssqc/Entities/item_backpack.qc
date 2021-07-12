class item_backpack_c : entity 
{
    weapon_c held_weapon;
    // owner needs to be set
    void () item_backpack_c =
    {
        if (!this.owner)
        {
            objerror("item_backpack_c does not have owner set");
            return;
        }
            
        player_c player = (player_c)this.owner;

        if (!(player.ammo_shells + player.ammo_nails + player.ammo_rockets + player.ammo_cells))
            return; // nothing in it
        
        this.origin = player.origin - '0 0 24';


        this.ammo_shells = player.ammo_shells;
        this.ammo_nails = player.ammo_nails;
        this.ammo_rockets = player.ammo_rockets;
        this.ammo_cells = player.ammo_cells;

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

        other.ammo_shells = other.ammo_shells + this.ammo_shells;
        other.ammo_nails = other.ammo_nails + this.ammo_nails;
        other.ammo_rockets = other.ammo_rockets + this.ammo_rockets;
        other.ammo_cells = other.ammo_cells + this.ammo_cells;
        
        bound_other_ammo ();

        sprint(other, PRINT_LOW, "You get ");

        float hasOther = FALSE;
        if (this.ammo_shells)
        {
            sprint (other, PRINT_LOW, ftos(this.ammo_shells), " shells");
            hasOther = TRUE;
        }

        if (this.ammo_nails)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammo_nails), " nails");
            hasOther = TRUE;
        }
        if (this.ammo_rockets)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammo_rockets), " rockets");
            hasOther = TRUE;
        }
        if (this.ammo_cells)
        {
            if (hasOther)
                sprint(other, PRINT_LOW, ", ");
            sprint (other, PRINT_LOW, ftos(this.ammo_cells), " cells");
            hasOther = TRUE;
        }

        sprint(other, PRINT_LOW, "\n");
    // backpack touch sound
        sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
        stuffcmd (other, "bf\n");

        remove(this);
    };
};