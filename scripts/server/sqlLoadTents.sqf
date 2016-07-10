_dbResult = call fnc_loadTents;
{
    //systemChat str _x;
    _id         = _x select 0;
    _tentid     = _x select 1;
    _owner      = _x select 2;
    _pos        = _x select 3;
    _rot        = _x select 4;
    _type       = _x select 5;
    _items      = _x select 6;
    _weapons    = _x select 7;
    _magazines  = _x select 8;
    _backpacks  = _x select 9;

    _tent       = _type createVehicle _pos;
    _tent setDir _rot;

    {
        _count_items = (_items select 1) select _foreachindex;
        _tent addItemCargoGlobal[_x,_count_items];
    } forEach (_items select 0);

    {
        _count_weapons = (_weapons select 1) select _foreachindex;
        _tent addWeaponCargoGlobal [_x,_count_weapons];
    } forEach (_weapons select 0);

    {
        _count_magazines = (_magazines select 1) select _foreachindex;
        _tent addMagazineCargoGlobal [_x,_count_magazines];
    } forEach (_magazines select 0);

    {
        _count_backpacks = (_backpacks select 1) select _foreachindex;
        _tent addBackpackCargoGlobal [_x, _count_backpacks];
    } forEach (_backpacks select 0);

    _tent setPosAtL _pos;
    _tent setDir _rot;

    systemChat str _tentid;

    _tent setVariable["tentID", _tentid,true];
    _tent setVariable["tentOwner", _owner,true];

    _tent addAction ["Pack Tent", {
        _targetObject   = _this select 0;
        _caller         = _this select 1;

        [_targetObject,_caller] call packTent;
    }, [],0,true,true,"","_target distance _this < 3"];

} forEach _dbResult;
