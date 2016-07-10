/*
worldCenter     = getArray(configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
worldHalfSize   = getNumber (configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");

safePositionAnchor[] = {15667,15791.3};
safePositionRadius = 7000;
*/

//worldHalfSize   = worldSize/2;
//worldCenter     = [worldHalfSize/2, worldHalfSize/2, 0];
cutText ["Welcome to BadDeadEnd ...", "BLACK FADED"];

worldCenter     = getArray(configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
worldCenter pushBack 0;
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
    [] execVM "scripts\server\sqlLoadTents.sqf";
};

if(!isDedicated)then{
    packTent = {
        _targetObject   = _this select 0;
        _caller         = _this select 1;
        _tentPos        = getPosATL _targetObject;
        _tentID         = _targetObject getVariable["tentID","0"];

        [_caller,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
        [_tentID] remoteExec ["fnc_deleteTent",2,false];

        sleep 5;
        deleteVehicle _targetObject;
        _tentWph = createVehicle ["groundWeaponHolder",_tentPos,[],0,"can_collide"];
        _tentWph setVehiclePosition [[_tentPos select 0,_tentPos select 1,(_tentPos select 2) + 0.5], [], 0, "can_collide"];
        _tentWph addMagazineCargoGlobal [ format["%1Packed",typeOf _targetObject],1];
    };
};

[] execVM "scripts\tools\burnObject.sqf";
[] execVM "scripts\tools\globalFuncs.sqf";
