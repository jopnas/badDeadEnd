_dbResult = call fnc_loadDogs;
{
    //systemChat str _x;
    _id         = _x select 0;
    _type       = _x select 1;
    _items      = _x select 2;
    _pos        = _x select 3;

    _dog        = createAgent [_type, _pos, [], 5, ""]; //"[this] call _fnc_zombieBehaviour"

    {
    _tent setPosAtL _pos;

    systemChat format["create %1",_type];

    _tent setVariable["bestFriend", "76561197984281873",true];

} forEach _dbResult;
