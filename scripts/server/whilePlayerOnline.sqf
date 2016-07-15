while {count allPlayers > 0} do {
    _allHCs = entities "HeadlessClient_F";
    _allHPs = allPlayers - _allHCs;
    _allAliveHPs = [];

    {
        if(alive _x)then{
            _allAliveHPs = _allAliveHPs + [_x];
        };

    } forEach allPlayers;

    // save car data to mysql if player close
    if(count _allAliveHPs > 0 && count loadedCarsList > 0)then{
        _nearestCars = nearestObjects[[worldCenter select 0,worldCenter select 1],loadedCarsList,worldHalfSize];
        {
            [_x] call fnc_saveCar;
        } forEach _nearestCars;
    };
    sleep 1;
};


_disconnectedPlayer = addMissionEventHandler["HandleDisconnect",{
/*
unit: Object - unit formerly occupied by player
id: Number - same as _id in onPlayerDisconnected
uid: String - same as _uid in onPlayerDisconnected
name: String - same as _name in onPlayerDisconnected
*/
    params["_unit","_id","_uid","_name"];
    if (isPlayer _unit) then {
        _unit setVariable["playerSetupReady",false];
        deleteVehicle _unit;
    };
}];
