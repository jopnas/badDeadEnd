if(!isDedicated)then{
    cutText ["Welcome to BadDeadEnd ...", "BLACK FADED"];
};
if(isServer)then{
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
