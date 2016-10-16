_actionID           = _this select 2;
_player             = _this select 1;
_nearestBuilding    = nearestBuilding _player;
_canLockData        = [_nearestBuilding] call canLock;
_doorName           = _canLockData select 0;
_doorNo             = (_doorName splitString "_") select 1;
_isDoorOpen         = _nearestBuilding animationPhase format["Door_%1_rot",_doorNo];
_isDoorLocked       = 0;

if(!(_nearestBuilding getVariable[format["door%1Debug",_doorNo],false]))then{
    [_nearestBuilding,_doorNo] execVM "scripts\barricade\fnc_getDoorLockPos.sqf";
    _nearestBuilding setVariable[format["door%1Debug",_doorNo],true,true];
};

if(_isDoorOpen == 0)then{
    if(_nearestBuilding getVariable [format["bis_disabled_Door_%1",_doorNo],0] != 1)then{
        _nearestBuilding setVariable [format["bis_disabled_Door_%1",_doorNo],1,true];
        _isDoorLocked = 1;
    }else{
        _nearestBuilding setVariable [format["bis_disabled_Door_%1",_doorNo],0,true];
        _isDoorLocked = 0;
    };
    [format["%1:%2",parseNumber ((str(_nearestBuilding) splitString " ") select 1),_doorNo],_doorNo,getPos _nearestBuilding,12345,getPlayerUID player,_isDoorLocked] remoteExec ["bde_fnc_saveDoor",2,false];
}else{
    cutText ["door must be closed", "PLAIN DOWN"];
};
