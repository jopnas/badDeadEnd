_fnc_dogBehaviour = compile preprocessFile "scripts\animals\dogBehaviour.sqf";
_dbResult = call fnc_loadDogs;

sideD 			= createCenter Civilian;
groupD 			= createGroup Civilian;

waitUntil{count _dbResult > 0};

{
    _id         = _x select 0;
    _type       = _x select 1;
    _pos        = _x select 2;
    _bestFriend = _x select 3;

    if(str _pos == "[]")then{
        _forests = selectBestPlaces [worldCenter, worldHalfSize, "(1 + forest + trees) * (1 - sea) * (1 + houses) * (1 + meadow) * (1 + deadBody)", 30, 20];
        _forestPlaces = _forests apply {_x select 0};
        _rdmSpawnPos = (_forestPlaces select 0) findEmptyPosition [0, 50, _type];
        _pos = _rdmSpawnPos;
    };

    _type createUnit [_pos, groupD,"[this,_x] call _fnc_dogBehaviour", 0, "NONE"];
    /*_dog = createAgent [_type, _pos, [], 1, "NONE"];
    [_dog,_x] call _fnc_dogBehaviour;*/
    sleep 0.5;
} forEach _dbResult;
