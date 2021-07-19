class csqcmanager_c : entity 
{
    nonvirtual void (entity e) UpdateClientTeamScores = 
    {
        if(!infokeyf(e, INFOKEY_P_CSQCACTIVE))
        return;

        msg_entity = e;
        WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
        WriteByte(MSG_MULTICAST, MSG_TEAM_SCORES);
        WriteFloat(MSG_MULTICAST, Teams[0].score);
        WriteFloat(MSG_MULTICAST, Teams[1].score);
        WriteFloat(MSG_MULTICAST, Teams[2].score);
        WriteFloat(MSG_MULTICAST, Teams[3].score);
        multicast('0 0 0', MULTICAST_ONE_R_NOSPECS);
    };
};
csqcmanager_c CSQCManager;