/*
worldCenter     = getArray(configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
worldHalfSize   = getNumber (configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");

safePositionAnchor[] = {15667,15791.3};
safePositionRadius = 7000;
*/

//worldHalfSize   = worldSize/2;
//worldCenter     = [worldHalfSize/2, worldHalfSize/2, 0];

worldCenter     = getArray(configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
worldHalfSize   = getNumber (configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");

if(isServer)then{
    loadedCarsList = [];
    [] execVM "scripts\server\registerDBdata.sqf";
    [] execVM "scripts\server\MySQLPlayerData.sqf";

    [] execVM "scripts\lists\buildingTypes.sqf";
    [] execVM "scripts\lists\weaponTypes.sqf";
	[] execVM "scripts\weather\initWeather.sqf";
	[] execVM "scripts\anomaly\initAnomaly.sqf";
	[] execVM "scripts\camps\initCamps.sqf";
	[] execVM "scripts\loot\initLoot.sqf";
	[] execVM "scripts\vehicles\initCars.sqf";
	[] execVM "scripts\animals\spawnAnimals.sqf";
	[] execVM "scripts\server\whilePlayerOnline.sqf";
    [] execVM "scripts\zombies\initZombies.sqf";
};

[] execVM "scripts\tools\burnObject.sqf";
[] execVM "scripts\tools\globalFuncs.sqf";

// REMOVE BEFORE RELEASE !!!!!!!!!!!
[] execVM "scripts\tools\dev_helper.sqf";
