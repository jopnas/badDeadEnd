private["_rdmLocPos","_thisPlayer","_thisPlayersZs","_zPerPlayer","_zPerPlayerDef"];
_fnc_zombieBehaviour = compile preprocessFile "scripts\zombies\zombieBehaviour.sqf";

_zUnitsCivStd1  = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_polo_1_F","C_man_polo_1_F_afro","C_man_polo_1_F_euro","C_man_polo_1_F_asia","C_man_polo_2_F","C_man_polo_2_F_afro","C_man_polo_2_F_euro","C_man_polo_2_F_asia","C_man_polo_3_F","C_man_polo_3_F_afro","C_man_polo_3_F_euro","C_man_polo_3_F_asia","C_man_polo_4_F","C_man_polo_4_F_afro","C_man_polo_4_F_euro","C_man_polo_4_F_asia","C_man_polo_5_F","C_man_polo_5_F_afro","C_man_polo_5_F_euro","C_man_polo_5_F_asia"];
_zUnitsCivStd2  = ["C_man_polo_6_F","C_man_polo_6_F_afro","C_man_polo_6_F_euro","C_man_polo_6_F_asia","C_man_p_fugitive_F","C_man_p_fugitive_F_afro","C_man_p_fugitive_F_euro","C_man_p_fugitive_F_asia","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_beggar_F_euro","C_man_p_beggar_F_asia","C_man_p_shorts_1_F","C_man_p_shorts_1_F_afro","C_man_p_shorts_1_F_euro","C_man_p_shorts_1_F_asia","C_man_shorts_1_F","C_man_shorts_1_F_afro"];
_zUnitsCivStd3  = ["C_man_shorts_1_F_euro","C_man_shorts_1_F_asia","C_man_shorts_2_F","C_man_shorts_2_F_afro","C_man_shorts_2_F_asia","C_man_shorts_3_F","C_man_shorts_3_F_afro","C_man_shorts_3_F_euro","C_man_shorts_3_F_asia","C_man_shorts_4_F","C_man_shorts_4_F_afro","C_man_shorts_4_F_euro","C_man_shorts_4_F_asia","C_Orestes","C_Nikos","C_Nikos_aged","C_Driver_1_random_base_F","C_Driver_1_black_F","C_Driver_1_green_F","C_Driver_1_orange_F"];
_zUnitsCivSci   = ["C_scientist_F"];
_zUnitsCivSer   = ["C_man_pilot_F","C_journalist_F","C_Marshal_F","C_man_w_worker_F","C_man_hunter_1_F"];
_zUnitsCiv      = _zUnitsCivStd1 + _zUnitsCivStd2 + _zUnitsCivStd3 + _zUnitsCivSci + _zUnitsCivSer;

_zUnitsMilInf   = ["I_G_Soldier_F","I_G_Soldier_lite_F","I_G_Soldier_A_F","I_Soldier_02_F","I_Soldier_M_F","I_medic_F","I_Soldier_repair_F","I_engineer_F","i_soldier_unarmed_f","I_Spotter_F","I_Sniper_F","I_support_AMort_F"];
_zUnitsMilPil   = ["I_Soldier_04_F","I_helipilot_F","I_pilot_F","I_helicrew_F"];
_zPerPlayerDef  = 30;
_zPerPlayer	    = _zPerPlayerDef;

while {true} do {
    {
        _thisPlayer     = _x;
        _buildings      = nearestObjects [_thisPlayer,["Building"], zSpawnRange];
        _countBuildings = count _buildings;
        _useZlist       = _zUnitsCiv;

        // count zombies spawned by this player
        _thisPlayersZs  = [];
        {
            _zombie  = _x;
            if(_zombie getVariable "creatorPlayer" == _thisPlayer && _zombie distance _thisPlayer < zSpawnRange)then{
                _thisPlayersZs pushBackUnique _zombie;
            };
        }forEach (units groupZ);

        if(_countBuildings == 0)then{
            _zPerPlayer = 5;
        }else{
            _zPerPlayer = _zPerPlayerDef;
        };

        if (count _thisPlayersZs < _zPerPlayer && _thisPlayer distance getMarkerPos "respawn_civilian" > 200) then {
            if(_countBuildings > 0)then{
                // choose type of zombie by bulding type
                _randomBuilding = selectRandom _buildings;

                if(typeOf _randomBuilding in militaryBuildings)then{
                    _useZlist = _zUnitsMilInf;
                };

                if(typeOf _randomBuilding in airportBuildings)then{
                    _useZlist = _zUnitsMilPil;
                };

                if(typeOf _randomBuilding in researchBuildings)then{
                    _useZlist = _zUnitsCivSci + _zUnitsCivSer;
                };

                // random position arround random building
                _rdmLocPos = getPos _randomBuilding;
            }else{
                _useZlist       = selectRandom [_zUnitsCiv,_zUnitsMilInf,_zUnitsMilPil];
                _thisPlayerPos  = getPos _thisPlayer;
                _rdmLocPos      = [(_thisPlayerPos select 0) + 200 - floor (random 400), (_thisPlayerPos select 1) + 200 - floor (random 400), _thisPlayerPos select 2];
            };

            _pos = [(_rdmLocPos select 0) + 10 - floor (random 20), (_rdmLocPos select 1) + 10 - floor (random 20), _rdmLocPos select 2];
            if([objNull, "VIEW"] checkVisibility [eyePos _thisPlayer, [_pos select 0,_pos select 1,(_pos select 2) + 1]] == 0 && _thisPlayer distance _pos > zMinSpawnRange)then{
                _z = selectRandom _useZlist;
                _z createUnit [_pos, groupZ,"[this] call _fnc_zombieBehaviour", 0, "NONE"];
                _z setVariable ["creatorPlayer", _thisPlayer, false];
            };
        };
    } forEach allPlayers;
    sleep 0.2;
};
