if(!isDedicated)then{
    cutText ["Welcome to BadDeadEnd ...", "BLACK FADED"];
};

worldHalfSize   = (getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize") / 2);
worldCenter     = [worldHalfSize,worldHalfSize,0];

if(isServer)then{
    setTimeMultiplier 2; // 0.1 - 120

    [] execVM "scripts\server\registerDBdata.sqf";
    [] execVM "scripts\server\MySQLPlayerData.sqf";

    [] execVM "scripts\server\worldObjectsOptions.sqf";

    [] execVM "scripts\lists\buildingTypes.sqf";
    [] execVM "scripts\lists\weaponTypes.sqf";
	[] execVM "scripts\weather\initWeather.sqf";
	[] execVM "scripts\anomaly\initAnomaly.sqf";
	[] execVM "scripts\camps\initCamps.sqf";
	[] execVM "scripts\loot\initLoot.sqf";
	[] execVM "scripts\animals\spawnAnimals.sqf";
	[] execVM "scripts\server\whilePlayerOnline.sqf";
    //[] execVM "scripts\zombies\initZombies.sqf";
    [] execVM "scripts\server\sqlLoadVehicles.sqf";
    [] execVM "scripts\server\sqlLoadTents.sqf";
    [] execVM "scripts\server\sqlLoadDogs.sqf";
    [] execVM "scripts\server\sqlLoadBarricades.sqf";

};

[] execVM "scripts\tools\burnObject.sqf";
[] execVM "scripts\tools\globalFuncs.sqf";
[] execVM "LLW_Climate\loadFunctions.sqf";
