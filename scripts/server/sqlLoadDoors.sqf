_dbResult = call fnc_loadDoors;
_compiledDoorData = compile preprocessFile "scripts\barricade\fnc_getDoorLockPos.sqf"; // output [dir,pos]
waitUntil{count _dbResult > 0};
{
    _id         = _x select 0;
    _doorid     = _x select 1;
    _houseid    = _x select 2;
    _code       = _x select 3;
    _owner      = _x select 4;
    _locked     = _x select 5;
    //systemChat format["load door: %1, %2, %3, %4, %5, %6",_id,_doorid,_houseid,_code,_owner,_locked];

    _house = nearestBuilding _houseid;
    _house setVariable [format["bis_disabled_Door_%1",_doorid],_locked,true];
    _house setVariable [format["bde_door_%1_has_lock",_doorid],true,true];
    _house setVariable [format["bde_door_%1_code",_doorid],_code,true];

    _doorData = [_house,_doorid] call _compiledDoorData;
    //systemChat str (_doorData);

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

    sleep 0.1;
} forEach _dbResult;
