while {true} do {
    _allHCs = entities "HeadlessClient_F";
    _allHPs = allPlayers - _allHCs;
    _allAliveHPs = [];

    {
        if(alive _x)then{
            _allAliveHPs = _allAliveHPs + [_x];
        };

    } forEach allPlayers;

    // save car data to mysql if player close
    if(!(isNil loadedCarsList))then{
        if(count loadedCarsList > 0 && count _allAliveHPs > 0)then{
            _nearestCars = nearestObjects[[16000,16000],loadedCarsList,16000];
            {
                [_x] call fnc_saveCar;
            } forEach _nearestCars;
        };
    };
    sleep 1;
};

onPlayerDisconnected {
    if (isPlayer _x) then {
        _x setVariable["playerSetupReady",false];
        deleteVehicle _x;
    };
};
