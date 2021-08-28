// TODO: pre-initialised struct members are not implemented yet (FTE issue)
typedef struct
{
    string classname;
    CLASS class; // dumb
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
    float max_activegren2;
    float type_gren1;
    float type_gren2;
    int tf_attributes;
    float illegal_bit;
} class_t;
class_t *Classes;
