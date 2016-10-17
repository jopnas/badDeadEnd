_compiledDoorData   = compile preprocessFile "scripts\barricade\fnc_getDoorLockPos.sqf"; // output [dir,pos]
_doorNr             = ([nearestBuilding player] call canLock) select 3;
_house              = nearestBuilding player;

_codeblockIDD       = 666667;

_codeSet            = false;
_lockcode           = [];
_doorData           = [_house,_doorNr] call _compiledDoorData;
_doorDataDir        = _doorData select 0;
_doorDataPos        = _doorData select 1;

_codelock1 = createVehicle["bde_codelock", _doorDataPos, [], 0, "CAN_COLLIDE"];
_codelock2 = createVehicle["bde_codelock", _doorDataPos, [], 0, "CAN_COLLIDE"];

if(_doorDataDir == "x")then{
    _codelock1 setDir (getDir _house);
    _codelock2 setDir ((getDir _house) + 180);
}else{
    _codelock1 setDir ((getDir _house) + 90);
    _codelock2 setDir ((getDir _house) + 90 + 180);
};

_wallCheck1 = lineIntersectsSurfaces [AGLToASL (_codelock1 modelToWorld [-0.8,0.5,0]), AGLToASL (_codelock1 modelToWorld [-0.8,-0.5,0]), player, objNull, true, 1, "GEOM", "NONE"];
_wallCheck2 = lineIntersectsSurfaces [AGLToASL (_codelock2 modelToWorld [-0.8,-0.5,0]), AGLToASL (_codelock2 modelToWorld [-0.8,0.5,0]), player, objNull, true, 1, "GEOM", "NONE"];

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

//_codelock1 setPos (_doorDataPos);
//_codelock1 setPos (_codelock1 modelToWorld [-0.8,0,0]);
_codelock1 attachTo [_house,[0,0,0]];

//_codelock2 setPos (_doorDataPos);
//_codelock2 setPos (_codelock2 modelToWorld [-0.8,0,0]);
_codelock2 attachTo [_house,[0,0,0]];
_house setVariable [format["bde_door_%1_has_lock",_doorNr],true,true];

createDialog "codelockGUI";
waitUntil{!isNull (findDisplay _codeblockIDD)};
    ((findDisplay _codeblockIDD) displayCtrl 1214) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 1';if(count _lockcode < 4)then{_lockcode pushBack 1};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1215) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 2';if(count _lockcode < 4)then{_lockcode pushBack 2};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1216) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 3';if(count _lockcode < 4)then{_lockcode pushBack 3};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1217) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 4';if(count _lockcode < 4)then{_lockcode pushBack 4};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1218) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 5';if(count _lockcode < 4)then{_lockcode pushBack 5};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1219) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 6';if(count _lockcode < 4)then{_lockcode pushBack 6};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1220) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 7';if(count _lockcode < 4)then{_lockcode pushBack 7};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1221) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 8';if(count _lockcode < 4)then{_lockcode pushBack 8};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1222) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 9';if(count _lockcode < 4)then{_lockcode pushBack 9};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1223) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock 0';if(count _lockcode < 4)then{_lockcode pushBack 0};systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1224) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock C';_lockcode = [];"];
    ((findDisplay _codeblockIDD) displayCtrl 1225) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock #';systemChat _lockcode;"];
    ((findDisplay _codeblockIDD) displayCtrl 1226) ctrlSetEventHandler ["MouseButtonDown", "systemChat 'codelock OK';if(count _lockcode == 4)then{_codeSet = true;};systemChat _lockcode;"];
waitUntil{_codeSet};
    closeDialog _codeblockIDD;
    [format["%1:%2",parseNumber ((str(_house) splitString " ") select 1),_doorNr],_doorNr,getPos _house,12345,getPlayerUID player,0] remoteExec ["bde_fnc_saveDoor",2,false];

    