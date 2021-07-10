#include "../share/defs.h"
#pragma target fte
#pragma autoproto


typedef void () void_f;

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

class player_c;
class gamemanager_c;
gamemanager_c GameManager;

// random globals from qw code
//entity stemp, otemp, s, old;



float   modelindex_eyes, modelindex_player;
.float hit_z; // FIXME - is this used by engine?
.float  dmgtime;
//entity  multi_ent;
//float   multi_damage;

//vector  blood_org;
//float   blood_count;

//vector  puff_org;
//float   puff_count;

float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
float PLAT_LOW_TRIGGER = 1;