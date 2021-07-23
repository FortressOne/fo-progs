class tf_entity : entity
{
    float is_processed;
    float ammunition_shells;
    float ammunition_nails;
    float ammunition_rockets;
    float ammunition_cells;
    
    nonvirtual void () ProcessFieldAbbreviations =
    {
        // because way back when we got real desperate to save some memory
        if (!is_processed)
        {
            this.goal_activation = (!this.goal_activation) ? this.g_a : this.goal_activation;
            this.goal_effects = (!this.goal_effects) ? this.g_e : this.goal_effects;
            this.has_item_from_group = (!this.has_item_from_group) ? this.h_i_g : this.has_item_from_group;
            this.hasnt_item_from_group = (!this.hasnt_item_from_group) ? this.hn_i_g : this.hasnt_item_from_group;
            this.remove_item_group = (!this.remove_item_group) ? this.r_i_g : this.remove_item_group;
            this.ammunition_shells = (!this.ammo_shells) ? this.a_s : this.ammo_shells;
            this.ammunition_nails = (!this.ammo_nails) ? this.a_n : this.ammo_nails;
            this.ammunition_rockets = (!this.ammo_rockets) ? this.a_r : this.ammo_rockets;
            this.ammunition_cells = (!this.ammo_cells) ? this.a_c : this.ammo_cells;
            this.remove_spawngroup = (!this.remove_spawngroup) ? this.rv_s_h : this.remove_spawngroup;
            this.restore_spawngroup = (!this.restore_spawngroup) ? this.rs_s_h : this.restore_spawngroup;
            this.remove_group_no = (!this.remove_group_no) ? this.rv_gr : this.remove_group_no;
            this.restore_group_no = (!this.restore_group_no) ? this.rs_gr : this.restore_group_no;
            this.remove_goal_no = (!this.remove_goal_no) ? this.rv_g : this.remove_goal_no;
            this.restore_goal_no = (!this.restore_goal_no) ? this.rs_g : this.restore_goal_no;
            this.team_str_home = (!this.team_str_home) ? this.t_s_h : this.team_str_home;
            this.team_str_moved = (!this.team_str_moved) ? this.t_s_m : this.team_str_moved;
            this.team_str_carried = (!this.team_str_carried) ? this.t_s_c : this.team_str_carried;
            this.non_team_str_home = (!this.non_team_str_home) ? this.n_s_h : this.non_team_str_home;
            this.non_team_str_moved = (!this.non_team_str_moved) ? this.n_s_m : this.non_team_str_moved;
            this.non_team_str_carried = (!this.non_team_str_carried) ? this.n_s_c : this.non_team_str_carried;
            this.broadcast = (!this.broadcast) ? this.b_b : this.broadcast;
            this.team_broadcast = (!this.team_broadcast) ? this.b_t : this.team_broadcast;
            this.non_team_broadcast = (!this.non_team_broadcast) ? this.b_n : this.non_team_broadcast;
            this.owners_team_broadcast = (!this.owners_team_broadcast) ? this.b_o : this.owners_team_broadcast;
            this.netname_broadcast = (!this.netname_broadcast) ? this.n_b : this.netname_broadcast;
            this.netname_team_broadcast = (!this.netname_team_broadcast) ? this.n_t : this.netname_team_broadcast;
            this.netname_non_team_broadcast = (!this.netname_non_team_broadcast) ? this.n_n : this.netname_non_team_broadcast;
            this.netname_owners_team_broadcast = (!this.netname_owners_team_broadcast) ? this.n_o : this.netname_owners_team_broadcast;
            this.team_drop = (!this.team_drop) ? this.d_t : this.team_drop;
            this.non_team_drop = (!this.non_team_drop) ? this.d_n : this.non_team_drop;
            this.netname_team_drop = (!this.netname_team_drop) ? this.d_n_t : this.netname_team_drop;
            this.netname_non_team_drop = (!this.netname_non_team_drop) ? this.d_n_n : this.netname_non_team_drop;

            if (!GameSettings.flag_emulation) {
                if (GameManager.GetSetting(world, "fe", "flag_emu", "off"))
                {
                    GameSettings.flag_emulation = FLAGEMU_NORM;
                }
                if (GameManager.GetSetting(world, "ws", "use_standard", "on"))
                {
                    GameSettings.flag_emulation = FLAGEMU_WARSTANDARD;
                }

                if (!GameSettings.flag_emulation)
                    GameSettings.flag_emulation = FLAGEMU_CHECKED;
            }
            if (GameSettings.flag_emulation) {
                switch (this.mdl)
                {
                    case "progs/b_s_key.mdl":
                    case "progs/m_s_key.mdl":
                    case "progs/w_s_key.mdl":
                        if (GameSettings.flag_emulation == FLAGEMU_NORM)
                        {
                            this.mdl = "progs/tf_flag.mdl";
                            this.origin_z = this.origin_z + 6;
                        }
                        else
                        {
                            this.mdl = "progs/tf_stan.mdl";
                        }
                        
                        this.skin = 1;
                        break;
                    case "progs/b_g_key.mdl":
                    case "progs/m_g_key.mdl":
                    case "progs/w_g_key.mdl":
                        if (GameSettings.flag_emulation == FLAGEMU_NORM)
                        {
                            this.mdl = "progs/tf_flag.mdl";
                            this.origin_z = this.origin_z + 6;
                        }
                        else
                        {
                            this.mdl = "progs/tf_stan.mdl";
                        }
                        this.skin = 2;
                        break;
                    case "progs/tf_flag.mdl":
                        if (GameSettings.flag_emulation == FLAGEMU_WARSTANDARD)
                            this.mdl = "progs/tf_stan.mdl";
                        break;
                }
            }
            
            this.is_processed = 1;
        }
    };
};