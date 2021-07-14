/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	item_artifact_invulnerability_c ent = (item_artifact_invulnerability_c)self;
    ent.Process();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	item_artifact_envirosuit_c ent = (item_artifact_envirosuit_c)self;
    ent.Process();
};

/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
    item_artifact_invisibility_c ent = (item_artifact_invisibility_c)self;
    ent.Process();
};

/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	item_artifact_super_damage_c ent = (item_artifact_super_damage_c)self;
    ent.Process();
};


class item_powerup_c : item_c
{
    virtual void () Process =
    {
        precache_model(this.model);
        setmodel(this, this.model);
        setsize (self, '-16 -16 -24', '16 16 32');
        item_c::Process();
    };

    virtual void () touch =
    {
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;

        sprint (other, PRINT_LOW, "You got the ", self.netname, "\n");

        self.mdl = self.model;
        
        if ((self.classname == "item_artifact_invulnerability") ||
            (self.classname == "item_artifact_invisibility"))
            self.nextthink = time + 60*5;
        else
            self.nextthink = time + 60;
        
        self.think = this.Regen;

        sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        self.solid = SOLID_NOT;
        other.items = other.items | self.items;
        self.model = "";

    // do the apropriate action
        if (self.classname == "item_artifact_envirosuit")
        {
            other.rad_time = 1;
            other.radsuit_finished = time + 30;
        }
        
        if (self.classname == "item_artifact_invulnerability")
        {
            other.invincible_time = 1;
            other.invincible_finished = time + 30;
        }
        
        if (self.classname == "item_artifact_invisibility")
        {
            other.invisible_time = 1;
            other.invisible_finished = time + 30;
        }

        if (self.classname == "item_artifact_super_damage")
        {
            if (deathmatch == 4)
            {
                other.armortype = 0;
                other.armorvalue = 0 * 0.01;
                other.ammo_cells = 0;
            }
            other.super_time = 1;
            other.super_damage_finished = time + 30;
        }       

        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};

class item_artifact_invulnerability_c : item_powerup_c
{
    virtual void () Process =
    {
        precache_sound ("items/protect.wav");
        precache_sound ("items/protect2.wav");
        precache_sound ("items/protect3.wav");
        model = "progs/invulner.mdl";
        items = IT_INVULNERABILITY;
        noise = "items/protect.wav";
        netname = "Pentagram of Protection";
        effects = self.effects | EF_RED;
        item_powerup_c::Process();
    };
};

class item_artifact_envirosuit_c : item_powerup_c
{
    virtual void () Process =
    {
        precache_sound ("items/suit.wav");
	    precache_sound ("items/suit2.wav");
        model = "progs/suit.mdl";
        items = IT_SUIT;
        noise = "items/suit.wav";
        netname = "Biosuit";

        item_powerup_c::Process();
    };
};

class item_artifact_invisibility_c : item_powerup_c
{
    virtual void () Process =
    {
        precache_sound ("items/inv1.wav");
	    precache_sound ("items/inv2.wav");
	    precache_sound ("items/inv3.wav");
        model = "progs/invisibl.mdl";
        items = IT_INVISIBILITY;
        noise = "items/inv1.wav";
        netname = "Ring of Shadows";

        item_powerup_c::Process();
    };

    nonvirtual void (float timeleft) Drop =
    {
        entity item = spawn();
        item.origin = self.origin;
        
        item.velocity_z = 300;
        item.velocity_x = -100 + (random() * 200);
        item.velocity_y = -100 + (random() * 200);
        
        item.flags = FL_ITEM;
        item.solid = SOLID_TRIGGER;
        item.movetype = MOVETYPE_TOSS;
        item.noise = "items/inv1.wav";
        item.model = "progs/invisibl.mdl";
        setmodel (item, item.model);
        setsize (item, '-16 -16 -24', '16 16 32');
        item.cnt = time + timeleft;
        item.touch = this.DropTouch;
        item.nextthink = time + timeleft;    // remove after 30 seconds
        item.think = SUB_Remove;
    };

    nonvirtual void () DropTouch =
    {
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;

        self.mdl = self.model;

        sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        self.solid = SOLID_NOT;
        other.items = other.items | IT_INVISIBILITY;
        self.model = "";

    // do the apropriate action
        other.invisible_time = 1;
        other.invisible_finished = self.cnt;
        string s=ftos(rint(other.invisible_finished - time));
        bprint (PRINT_LOW, other.netname);
        bprint (PRINT_LOW, " recovered a Ring with ");
        bprint (PRINT_LOW, s);
        bprint (PRINT_LOW, " seconds remaining!\n");
        
        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
    
};

class item_artifact_super_damage_c : item_powerup_c
{
    virtual void () Process =
    {
        precache_sound ("items/damage.wav");
	    precache_sound ("items/damage2.wav");
	    precache_sound ("items/damage3.wav");
        model = "progs/quaddama.mdl";
        items = IT_QUAD;
        noise = "items/damage.wav";
        if (deathmatch == 4)
            self.netname = "OctaPower";	
        else
            self.netname = "Quad Damage";
        self.effects = self.effects | EF_BLUE;

        item_powerup_c::Process();
    };

    nonvirtual void (float timeleft) Drop =
    {
        // essentially a static call to spawn
        entity item = spawn();
        item.origin = self.origin;
        
        item.velocity_z = 300;
        item.velocity_x = -100 + (random() * 200);
        item.velocity_y = -100 + (random() * 200);
        
        item.flags = FL_ITEM;
        item.solid = SOLID_TRIGGER;
        item.movetype = MOVETYPE_TOSS;
        item.noise = "items/damage.wav";
        item.model = "progs/quaddama.mdl";
        setmodel (item, item.model);
        setsize (item, '-16 -16 -24', '16 16 32');
        item.cnt = time + timeleft;
        item.touch = this.DropTouch;
        item.nextthink = time + timeleft;    // remove it with the time left on it
        item.think = SUB_Remove;
    };

    nonvirtual void () DropTouch =
    {
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;

        self.mdl = self.model;

        sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        self.solid = SOLID_NOT;
        other.items = other.items | IT_QUAD;
        self.model = "";
            if (deathmatch == 4)
            {
                other.armortype = 0;
                other.armorvalue = 0 * 0.01;
                other.ammo_cells = 0;
            }

    // do the apropriate action
        other.super_time = 1;
        other.super_damage_finished = self.cnt;

        string s=ftos(rint(other.super_damage_finished - time));

        bprint (PRINT_LOW, other.netname);
        if (deathmatch == 4)
            bprint (PRINT_LOW, " recovered an OctaPower with ");
        else 
            bprint (PRINT_LOW, " recovered a Quad with ");
        bprint (PRINT_LOW, s);
        bprint (PRINT_LOW, " seconds remaining!\n");

        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};