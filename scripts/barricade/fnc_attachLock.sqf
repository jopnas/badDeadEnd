_compiledDoorData = compile preprocessFile "scripts\barricade\fnc_getDoorLockPos.sqf"; // output [dir,pos]
_doorNr = ([nearestBuilding player] call canLock) select 3;
_house = nearestBuilding player;

_doorData = [_house,_doorNr] call _compiledDoorData;

_codelock = createVehicle["bde_codelock", _doorData select 1, [], 0, "CAN_COLLIDE"];
_codelock enableSimulationGlobal false;

if(_doorData select 0 == "x")then{
    _codelock setDir (getDir _house);
}else{
    _codelock setDir ((getDir _house) + 90);
};

_codelock setPos (_doorData select 1); //(_codelock modelToWorld [1,0.3,0]);
_codelock setPos (_codelock modelToWorld [-0.8,0,0]);
_codelock attachTo [_house,[0,0,0]];

3 cutRsc ['codelockGUI', 'PLAIN',3];

_house setVariable [format["bde_door_%1_has_lock",_doorNr],true,true];
[format["%1:%2",parseNumber ((str(_house) splitString " ") select 1),_doorNr],_doorNr,getPos _house,12345,getPlayerUID player,0] remoteExec ["bde_fnc_saveDoor",2,false];