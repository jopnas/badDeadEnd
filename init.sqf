if(!isDedicated)then{
    cutText ["Welcome to BadDeadEnd ...", "BLACK FADED"];
};

worldCenter     = getArray(configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
worldCenter pushBack 0;
worldHalfSize   = (getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize") / 2);

/*_centerMarker = createMarker ["centerMarker", [worldCenter select 0,worldCenter select 1]];
_centerMarker setMarkerColor "ColorYellow";
_centerMarker setMarkerBrush "FDiagonal";
_centerMarker setMarkerAlpha 0.5;
_centerMarker setMarkerShape "ELLIPSE";
_centerMarker setMarkerSize [worldHalfSize,worldHalfSize];*/

if(isServer)then{
    //loadedCarsList = [];
    [] execVM "scripts\server\registerDBdata.sqf";
    [] execVM "scripts\server\MySQLPlayerData.sqf";

    [] execVM "scripts\lists\buildingTypes.sqf";
    [] execVM "scripts\lists\weaponTypes.sqf";
	[] execVM "scripts\weather\initWeather.sqf";
	[] execVM "scripts\anomaly\initAnomaly.sqf";
	[] execVM "scripts\camps\initCamps.sqf";
	[] execVM "scripts\loot\initLoot.sqf";
	[] execVM "scripts\animals\spawnAnimals.sqf";
	[] execVM "scripts\server\whilePlayerOnline.sqf";
    [] execVM "scripts\zombies\initZombies.sqf";
    [] execVM "scripts\server\sqlLoadVehicles.sqf";
    [] execVM "scripts\server\sqlLoadTents.sqf";
    [] execVM "scripts\server\sqlLoadBarricades.sqf";
};

[] execVM "scripts\tools\burnObject.sqf";
[] execVM "scripts\tools\globalFuncs.sqf";
