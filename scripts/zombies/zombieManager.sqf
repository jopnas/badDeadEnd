fnc_zombieBehaviour = compile preprocessFile "scripts\zombies\zombieBehaviour.sqf";
_zUnits =  ["C_man_polo_1_F_euro","C_man_polo_2_F_asia","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_p_fugitive_F","C_scientist_F","C_man_hunter_1_F","C_journalist_F"];
_zMax			= 80;
_zCount 		= 0;

while {true} do {
    {
        _thisPlayer       = _x;
        _thisPlayerPos    = position _thisPlayer;

        _buildings = nearestObjects [_thisPlayer,["Building"], zSpawnRange];
        _buildingsCount = count _buildings;

        _zCount = floor (_buildingsCount/2);

        if (_zCount > _zMax) then {
            _zCount = _zMax;
        };

        
        if (count (units groupZ) < _zCount) then {
            _rdmLocPos = getPos (_buildings call BIS_fnc_selectRandom);
            _pos = [((_rdmLocPos select 0) + floor (random 10)) - floor (random 10), ((_rdmLocPos select 1) + floor (random 10)) - floor (random 10), _rdmLocPos select 2];
            if([objNull, "VIEW"] checkVisibility [eyePos _thisPlayer, _pos] == 0 && _thisPlayer distance _pos > 30)then{
                _z = _zUnits call BIS_fnc_selectRandom;
                _z createUnit [_pos, groupZ,"[this] call fnc_zombieBehaviour", 0, "NONE"];
                sleep 0.2;
            };
        };
    } forEach allPlayers;
};
