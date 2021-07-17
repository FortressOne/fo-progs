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
    float regen_time;

    virtual void () Process =
    {
        precache_model(this.model);
        setmodel(this, this.model);
        setsize (self, '-16 -16 -24', '16 16 32');
        this.cnt = 30;
        
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

        this.nextthink = time + this.regen_time;
        self.think = this.Regen;

        sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        self.solid = SOLID_NOT;
        other.items = other.items | self.items;
        self.model = "";

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
        this.regen_time = 60*5;
        item_powerup_c::Process();
    };

    virtual void () touch =
    {
        other.invincible_time = TRUE;
        other.invincible_finished = this.cnt;

        item_powerup_c::touch();
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
        this.regen_time = 60;

        item_powerup_c::Process();
    };

    virtual void () touch =
    {
        other.rad_time = TRUE;
        other.radsuit_finished = this.cnt;

        item_powerup_c::touch();
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
        this.regen_time = 60*5;

        item_powerup_c::Process();
    };

    nonvirtual void (player_c player) Drop =
    {
        float timeleft = self.invisible_finished - time;
        bprint (PRINT_LOW, self.netname, " lost a ring with ", ftos(rint(timeleft)), " seconds remaining\n");
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

        sound(other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        self.solid = SOLID_NOT;
        other.items = other.items | IT_INVISIBILITY;
        self.model = "";

    // do the apropriate action
        other.invisible_time = TRUE;
        other.invisible_finished = self.cnt;
        string s=ftos(rint(this.cnt - time));
        bprint(PRINT_LOW, other.netname, " recovered a Ring with ", s, " seconds remaining!\n");
        
        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };

    virtual void () touch =
    {
        other.invisible_time = TRUE;
        other.invisible_finished = this.cnt;

        item_powerup_c::touch();
    };
};

#define QUAD_SHOOT_SOUND "items/damage3.wav"

class item_artifact_super_damage_c : item_powerup_c
{
    virtual void () Process =
    {
        precache_sound ("items/damage.wav");
	    precache_sound ("items/damage2.wav");
	    precache_sound(QUAD_SHOOT_SOUND);
        model = "progs/quaddama.mdl";
        items = IT_QUAD;
        noise = "items/damage.wav";
        if (deathmatch == 4)
            this.netname = "OctaPower";	
        else
            this.netname = "Quad Damage";
        this.effects = this.effects | EF_BLUE;
        this.regen_time = 60;

        item_powerup_c::Process();
    };

    // this sucks but statics don't work on classes
    nonvirtual void (player_c player) ShootSound =
    {
        if (player.super_damage_finished > time)
        {
            if (player.super_sound < time)
            {
                player.super_sound = time + 1;
                sound(player, CHAN_BODY, QUAD_SHOOT_SOUND, 1, ATTN_NORM);
            }
        }
    };

    nonvirtual void (player_c player) Drop =
    {
        float timeleft = self.super_damage_finished - time;
        bprint(PRINT_LOW, player.netname);
        if (deathmatch == 4)
            bprint(PRINT_LOW, " lost an OctaPower with ");
        else
            bprint(PRINT_LOW, " lost a quad with ");
        bprint(PRINT_LOW, ftos(rint(timeleft)), " seconds remaining\n");
        
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

    virtual void () touch =
    {
        if (deathmatch == 4)
        {
            other.armortype = 0;
            other.armorvalue = 0 * 0.01;
            other.ammo_cells = 0;
        }
        other.super_time = TRUE;
        other.super_damage_finished = this.cnt;

        item_powerup_c::touch();
    };
};