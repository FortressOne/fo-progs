/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor1 =
{
	item_armor_c item = (item_armor_c)self;
	item.Process();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor2 =
{
	item_armor_c item = (item_armor_c)self;
	item.Process();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorInv =
{
	item_armor_c item = (item_armor_c)self;
	item.Process();
};

class item_armor_c : item_c
{
    float value;
    float bit;
    float type;

    virtual void () Process =
    {
        precache_model ("progs/armor.mdl");
        setmodel(this, "progs/armor.mdl");
        setsize(this, '-16 -16 0', '16 16 56');

        switch (this.classname)
        {
            case "item_armor1":
                this.skin = 0;
                type = 0.3;
                value = 100;
                bit = IT_ARMOR1;
                break;
            case "item_armor2":
                this.skin = 1;
                type = 0.6;
                value = 150;
                bit = IT_ARMOR2;
                break;
            case "item_armorInv":
                this.skin = 2;
                type = 0.8;
                value = 200;
                bit = IT_ARMOR3;
                break;
        }
    };

    virtual void () touch =
    {	
        if (other.health <= 0)
            return;
        if (other.classname != "player")
            return;

        if (deathmatch == 4)
            if (other.invincible_time > 0)
                return;

        if (other.armortype*other.armorvalue >= this.type*this.value)
            return;
            
        other.armortype = this.type;
        other.armorvalue = this.value;
        other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + this.bit;

        this.solid = SOLID_NOT;
        this.model = "";
        if (deathmatch != 2)
            this.nextthink = time + 20;
        this.think = this.Regen;

        sprint(other, PRINT_LOW, "You got armor\n");
        // armor touch sound
        sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        
        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};