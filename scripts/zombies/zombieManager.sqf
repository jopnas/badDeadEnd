_fnc_zombieBehaviour = compile preprocessFile "scripts\zombies\zombieBehaviour.sqf";

_zUnitsCivStd1  = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_polo_1_F","C_man_polo_1_F_afro","C_man_polo_1_F_euro","C_man_polo_1_F_asia","C_man_polo_2_F","C_man_polo_2_F_afro","C_man_polo_2_F_euro","C_man_polo_2_F_asia","C_man_polo_3_F","C_man_polo_3_F_afro","C_man_polo_3_F_euro","C_man_polo_3_F_asia","C_man_polo_4_F","C_man_polo_4_F_afro","C_man_polo_4_F_euro","C_man_polo_4_F_asia","C_man_polo_5_F","C_man_polo_5_F_afro","C_man_polo_5_F_euro","C_man_polo_5_F_asia"];
_zUnitsCivStd2  = ["C_man_polo_6_F","C_man_polo_6_F_afro","C_man_polo_6_F_euro","C_man_polo_6_F_asia","C_man_p_fugitive_F","C_man_p_fugitive_F_afro","C_man_p_fugitive_F_euro","C_man_p_fugitive_F_asia","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_beggar_F_euro","C_man_p_beggar_F_asia","C_man_p_shorts_1_F","C_man_p_shorts_1_F_afro","C_man_p_shorts_1_F_euro","C_man_p_shorts_1_F_asia","C_man_shorts_1_F","C_man_shorts_1_F_afro"];
_zUnitsCivStd3  = ["C_man_shorts_1_F_euro","C_man_shorts_1_F_asia","C_man_shorts_2_F","C_man_shorts_2_F_afro","C_man_shorts_2_F_asia","C_man_shorts_3_F","C_man_shorts_3_F_afro","C_man_shorts_3_F_euro","C_man_shorts_3_F_asia","C_man_shorts_4_F","C_man_shorts_4_F_afro","C_man_shorts_4_F_euro","C_man_shorts_4_F_asia","C_Orestes","C_Nikos","C_Nikos_aged","C_Driver_1_random_base_F","C_Driver_1_black_F","C_Driver_1_green_F","C_Driver_1_orange_F"];
_zUnitsCivSci   = ["C_scientist_F"];
_zUnitsCivSer   = ["C_man_pilot_F","C_journalist_F","C_Marshal_F","C_man_w_worker_F","C_man_hunter_1_F"];
_zUnitsCiv      = _zUnitsCivStd1 + _zUnitsCivStd2 + _zUnitsCivStd3 + _zUnitsCivSci + _zUnitsCivSer;

_zUnitsMilInf   = ["I_G_Soldier_F","I_G_Soldier_lite_F","I_G_Soldier_A_F","I_Soldier_02_F","I_Soldier_M_F","I_medic_F","I_Soldier_repair_F","I_engineer_F","i_soldier_unarmed_f","I_Spotter_F","I_Sniper_F","I_support_AMort_F"];
_zUnitsMilPil   = ["I_Soldier_04_F","I_helipilot_F","I_pilot_F","I_helicrew_F"];
_zPerPlayer	    = 30;
_zMax           = _zPerPlayer; // initial
_zCount         = 0;

_createdZno     = 0;
while {true} do {
    {
        _thisPlayer       = _x;
        _thisPlayerPos    = position _thisPlayer;

        _buildings = nearestObjects [_thisPlayer,["Building"], zSpawnRange];
        //_buildings = _thisPlayer nearObjects ["Building", zSpawnRange];
        _buildingsCount = count _buildings;

        _useZlist = _zUnitsCiv;

        _zCount = floor (_buildingsCount/2);

        _zMax = (count allPlayers) * _zPerPlayer;
        if (_zCount > _zMax) then {
            _zCount = _zMax;
        };

        /*
            BIS_fnc_findSafePos
            https://community.bistudio.com/wiki/BIS_fnc_findSafePos

            _safeSpawnPoint = [_thisPlayer, zMinSpawnRange, zSpawnRange, 1, 0, 20, 0] call BIS_fnc_findSafePos;
        */

        if ({alive _x} count (units groupZ) < _zCount) then {
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

            _rdmLocPos = getPos _randomBuilding;
            _pos = [((_rdmLocPos select 0) + floor (random 10)) - floor (random 10), ((_rdmLocPos select 1) + floor (random 10)) - floor (random 10), _rdmLocPos select 2];

            _relDir         = _thisPlayer getRelDir _pos;
            _inViewAngle    = abs(_relDir - 180);

            if([objNull, "VIEW"] checkVisibility [eyePos _thisPlayer, [_pos select 0,_pos select 1,(_pos select 2) + 1]] == 0 && _thisPlayer distance _pos > zMinSpawnRange && _inViewAngle < 100)then{
                _z = selectRandom _useZlist;
                _newZ = _z createUnit [_pos, groupZ,"[this] call _fnc_zombieBehaviour", 0, "NONE"];
                _newZ setVariable ["zID",_createdZno,true];

                _createdZno = _createdZno + 1;
                _markerstr = createMarker [format["zombie%1",_createdZno] , _pos];
            	_markerstr setMarkerShape "ICON";
            	_markerstr setMarkerType "mil_dot";
            	_markerstr setMarkerColor "ColorRed";

                sleep 0.5;
            };
        };
    } forEach allPlayers;
};
