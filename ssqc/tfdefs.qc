#include "../share/defs.h"
#pragma target fte
#pragma autoproto

// random globals from qw code
//entity stemp, otemp, s, old;

float   modelindex_eyes, modelindex_player;
string nextmap;
.float hit_z; // FIXME - is this used by engine?

float   intermission_running;
float   intermission_exittime;
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