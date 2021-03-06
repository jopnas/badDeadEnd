worldHalfSize   = (getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize") / 2);
worldCenter     = [worldHalfSize,worldHalfSize,0];

[] execVM "scripts\tools\globalFuncs.sqf";
[] execVM "scripts\tools\burnObject.sqf";

if(isServer)then{
    /*_lastClientState = "";
    while{true}do{
        _curClientState = getClientState;
        if(_curClientState != _lastClientState)then{
            systemChat format["_curClientState: %1",_curClientState];
            _lastClientState = _curClientState;
        };
    };*/

    setTimeMultiplier 5; // 0.1 - 120

    [] execVM "scripts\server\MySQLdata.sqf";

    [] execVM "scripts\server\worldObjectsOptions.sqf";

    [] execVM "scripts\lists\buildingTypes.sqf";
    [] execVM "scripts\lists\buildingTypes2.sqf";
    [] execVM "scripts\lists\weaponTypes.sqf";
    [] execVM "scripts\lists\backpackTypes.sqf";
    [] execVM "scripts\lists\throwableTypes.sqf";
    [] execVM "scripts\lists\clothTypes.sqf";

    [] execVM "scripts\weather\initWeather.sqf";
    [] execVM "scripts\anomaly\initAnomaly.sqf";
    [] execVM "scripts\camps\initCamps.sqf";
    [] execVM "scripts\loot\initLoot.sqf";
    [] execVM "scripts\animals\spawnAnimals.sqf";
    [] execVM "scripts\server\whilePlayerOnline.sqf";
    [] execVM "scripts\server\sqlLoadVehicles.sqf";
    [] execVM "scripts\server\sqlLoadTents.sqf";
    [] execVM "scripts\server\sqlLoadDogs.sqf";
    [] execVM "scripts\server\sqlLoadBarricades.sqf";
    [] execVM "scripts\server\sqlLoadDoors.sqf";
};

if(!isDedicated)then{
    [] execVM "LLW_Climate\loadFunctions.sqf";
    [] execVM "scripts\player\playerGlobalFuncs.sqf";
    [] execVM "scripts\player\playerGlobalVars.sqf";
    [] execVM "scripts\player\playerSpawn.sqf";
};

