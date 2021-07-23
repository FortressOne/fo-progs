enum WEAPON
{
    AXE,
    SPANNER,
    SNIPERRIFLE,
    TRANQUILISER,
    SUPERSHOTGUN,
    NAILGUN,
    SUPERNAILGUN,
    GRENADELAUNCHER,
    FLAMETHROWER,
    INCENDIARYCANNON,
    ASSAULTCANNON,
    ROCKETLAUNCHER,
    RAILGUN,
    KNIFE,
    SHOTGUN,
    MEDIKIT
};

enum GRENADE
{
    FLASH,
    CONCUSSION
};

// TODO: pre-initialised struct members are not implemented yet (FTE issue)
typedef struct
{
    string classname;
    CLASS class;
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
} class_t;
class_t *Classes;

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