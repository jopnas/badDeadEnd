private["_doorcode"];
_player             = _this select 1;
_actionID           = _this select 2;
_nearestBuilding    = nearestBuilding _player;
_canLockData        = [_nearestBuilding] call canLock;
_doorName           = _canLockData select 0;
_doorNo             = (_doorName splitString "_") select 1;
_isDoorOpen         = _nearestBuilding animationPhase format["Door_%1_rot",_doorNo];
_isDoorLocked       = 0;
_doorcode           = _nearestBuilding getVariable format["bde_door_%1_code",_doorNo];
lockcode            = "";

_codelockGuiOK = createDialog "codelockGui";

waitUntil {
    _return = false;
    if(count lockcode == 4)then{
        if(_doorcode isEqualTo lockcode)then{
            _return = true;
        }else{
            lockcode = "";
            _return = false;
        };
    };
    _return
};

closeDialog 6906;

if(_isDoorOpen == 0)then{
    if(_nearestBuilding getVariable [format["bis_disabled_Door_%1",_doorNo],0] != 1)then{
        _nearestBuilding setVariable [format["bis_disabled_Door_%1",_doorNo],1,true];
        _isDoorLocked = 1;
    }else{
        _nearestBuilding setVariable [format["bis_disabled_Door_%1",_doorNo],0,true];
        _isDoorLocked = 0;
    };
    [format["%1:%2",parseNumber ((str(_nearestBuilding) splitString " ") select 1),_doorNo],_doorNo,getPos _nearestBuilding,_doorcode,getPlayerUID player,_isDoorLocked] remoteExec ["bde_fnc_saveDoor",2,false];
}else{
    cutText ["door must be closed", "PLAIN DOWN"];
};
