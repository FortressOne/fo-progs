class class_c : entity 
{
    string class_name;
    float class_number;
    float max_health;
    float init_armor;
    float max_armor;
    float max_armor_type; // green, yellow, red
    float init_armor_type;
    float init_armor_classes;
    float max_speed;
    float max_strafe_speed; // is it ever different?
    float weapon1;
    float weapon2;
    float weapon3;
    float weapon4;
    float max_shells;
    float init_shells;
    float max_nails;
    float init_nails;
    float max_rockets;
    float init_rockets;
    float max_cells;
    float init_cells;
    float max_gren1;
    float init_gren1;
    float init_gren2;
    float max_gren2;
    float type_gren1;
    float type_gren2;
    int tf_attributes;
    float illegal_bit;
};

enum SCOUT
{
    CLASS = 1,
    MAXSPEED = 450,
    MAXSTRAFESPEED = 450,
    MAXARMORTYPE = .3,
    INITARMORTYPE = .3,
    INITARMORCLASS = 0,
    MAXAMMO_SHOT = 50,
    MAXAMMO_NAIL = 200,
    MAXAMMO_CELL = 100,
    MAXAMMO_ROCKET = 25,
    INITAMMO_SHOT = 25,
    INITAMMO_NAIL = 100,
    INITAMMO_CELL = 50,
    INITAMMO_ROCKET = 0,
    INITAMMO_GREN1 = 2,
    INITAMMO_GREN2 = 3,
    MAXAMMO_GREN1 = 3,
    MAXAMMO_GREN2 = 4,
    WEAPON1 = WEAPON::NAILGUN,
    WEAPON2 = WEAPON::SHOTGUN,
    WEAPON3 = WEAPON::AXE,
    TYPE_GREN1 = GRENADE::FLASH,
    TYPE_GREN2 = GRENADE::CONCUSSION,
    ILLEGALBIT = 1, // Legal Playerclass Handling
    MAXHEALTH = 75,
    MAXHEALTH_FO = 100,
    MAXARMOR_FO = 50,
    MAXARMOR = 25,
    MAX_GREN1 = 3,
    MAX_GREN2 = 4,
    INIT_GREN1 = 2,
    INIT_GREN2 = 3,
};

class scout_c : class_c
{
    void () scout_c =
    {
        class_name = PC_SCOUT_NAME;
        class_number = SCOUT::CLASS;
        max_speed = SCOUT::MAXSPEED;
        max_strafe_speed = SCOUT::MAXSTRAFESPEED;
        max_armor_type = SCOUT::MAXARMORTYPE;
        init_armor_type = SCOUT::INITARMORTYPE;
        init_armor_classes = SCOUT::INITARMORCLASS;
        illegal_bit = SCOUT::ILLEGALBIT;
        weapon1 = WEAPON::NAILGUN;
        weapon2 = WEAPON::SHOTGUN;
        weapon3 = WEAPON::AXE;
        tf_attributes = ATTRIBUTE::SCAN | ATTRIBUTE::DOUBLEJUMP | ATTRIBUTE::DISARM;
        max_shells = SCOUT::MAXAMMO_SHOT;
        init_shells = SCOUT::INITAMMO_SHOT;
        max_nails = SCOUT::MAXAMMO_NAIL;
        init_nails = SCOUT::INITAMMO_NAIL;
        max_rockets = SCOUT::MAXAMMO_ROCKET;
        init_rockets = SCOUT::INITAMMO_ROCKET;
        max_cells = SCOUT::MAXAMMO_CELL;
        init_cells = SCOUT::INITAMMO_CELL;
        type_gren1 = SCOUT::TYPE_GREN1;
        type_gren2 = SCOUT::TYPE_GREN2;
        
        switch (GameSettings.season)
        {
            case SEASON::ONE:
                max_health = SCOUT::MAXHEALTH_FO;
                max_armor = SCOUT::MAXARMOR_FO;
                init_armor = max_armor;
                max_gren1 = SCOUT::MAX_GREN1;
                max_gren2 = SCOUT::MAX_GREN2;
                init_gren1 = max_gren1;
                init_gren2 = max_gren2;
                break;
            case SEASON::FO:
            case SEASON::TF28:
                if (GameSettings.old_hp_armor)
                {
                    max_health = SCOUT::MAXHEALTH;
                    max_armor = SCOUT::MAXARMOR;
                }
                else
                {
                    max_health = SCOUT::MAXHEALTH_FO;
                    max_armor = SCOUT::MAXARMOR_FO;
                }
                max_gren1 = SCOUT::MAX_GREN1;
                max_gren2 = SCOUT::MAX_GREN2;
                max_shells = SCOUT::MAXAMMO_SHOT;
                max_nails = SCOUT::MAXAMMO_NAIL;
                max_rockets = SCOUT::MAXAMMO_ROCKET;
                max_cells = SCOUT::MAXAMMO_CELL;

                if (GameSettings.spawn_full)
                {
                    init_armor = max_armor;
                    init_shells = max_shells;
                    init_nails = max_nails;
                    init_rockets = max_rockets;
                    init_cells = max_cells;
                    init_gren1 = max_gren1;
                    init_gren2 = max_gren2;
                }
                else
                {
                    init_armor = max_armor / 2;
                    init_shells = SCOUT::INITAMMO_SHOT;
                    init_nails = SCOUT::INITAMMO_NAIL;
                    init_rockets = SCOUT::INITAMMO_ROCKET;
                    init_cells = SCOUT::INITAMMO_CELL;
                    init_gren1 = SCOUT::INIT_GREN1;
                    init_gren2 = SCOUT::INIT_GREN2;
                }
                break;
        }
    };
};