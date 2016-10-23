private["_wallCheck1","_wallCheck2","_posWallCheck1","_posWallCheck2"];
_compiledDoorData           = compile preprocessFile "scripts\barricade\fnc_getDoorLockPos.sqf"; // output [dir,pos]
_doorNr                     = ([nearestBuilding player] call canLock) select 3;
_house                      = nearestBuilding player;

_codeblockIDD               = 666667;

_codeSet                    = false;
lockcode                   = [];
_doorData                   = [_house,_doorNr] call _compiledDoorData;
_doorDataDir                = _doorData select 0;
_doorDataPos                = _doorData select 1;
_doorDataTrigRotDistance    = _doorData select 2;

_codelock1 = createVehicle["bde_codelock", _doorDataPos, [], 0, "CAN_COLLIDE"];
_codelock2 = createVehicle["bde_codelock", _doorDataPos, [], 0, "CAN_COLLIDE"];

if(_doorDataDir == "x")then{
    _codelock1 setDir (getDir _house);
    _codelock2 setDir ((getDir _house) + 180);
}else{
    _codelock1 setDir ((getDir _house) + 90 + 180);
    _codelock2 setDir ((getDir _house) + 90);
};

_wallCheck1 = lineIntersectsSurfaces [AGLToASL (_codelock1 modelToWorld [_doorDataTrigRotDistance * 2,0.5,0]), AGLToASL (_codelock1 modelToWorld [-(_doorDataTrigRotDistance * 2),0.5,0]), player, objNull, true, 1, "GEOM", "NONE"];
_wallCheck2 = lineIntersectsSurfaces [AGLToASL (_codelock2 modelToWorld [-(_doorDataTrigRotDistance * 2),0.5,0]), AGLToASL (_codelock2 modelToWorld [_doorDataTrigRotDistance * 2,0.5,0]), player, objNull, true, 1, "GEOM", "NONE"];

/*_posWallCheck1 = _wallCheck1 select 0;
_posWallCheck2 = _wallCheck2 select 0;

//systemChat format["%1",_wallCheck1];

_codelock1 setPosATL _posWallCheck1;
_codelock2 setPosATL _posWallCheck2;*/

{
    if( _x select 2 == _house)exitWith{
        _infPos = ASLToATL (_x select 0);
        _codelock1 setPosATL _infPos;
        _codelock1 setVectorDir (_x select 1);
    };
}forEach _wallCheck1;

{
    if( _x select 2 == _house)exitWith{
        _infPos = ASLToATL (_x select 0);
        _codelock2 setPosATL _infPos;
        _codelock2 setVectorDir (_x select 1);
    };
}forEach _wallCheck2;

_codelock1 attachTo [_house,[0,0,0]];
_codelock2 attachTo [_house,[0,0,0]];

_house setVariable [format["bde_door_%1_has_lock",_doorNr],true,true];

_codelockGuiOK = createDialog "codelockGui";
waitUntil {_codelockGuiOK && count lockcode == 4};
closeDialog 6906;
systemChat format["Locked with code %1", lockcode];
_house setVariable [format["bde_door_%1_code",_doorNr],lockcode,true];
[format["%1:%2",parseNumber ((str(_house) splitString " ") select 1),_doorNr],_doorNr,getPos _house,lockcode,getPlayerUID player,0] remoteExec ["bde_fnc_saveDoor",2,false];

