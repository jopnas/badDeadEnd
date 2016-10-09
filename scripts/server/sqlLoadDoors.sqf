_dbResult = call fnc_loadDoors;
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

    _relPos = _house modelToWorld (_house selectionPosition format["door_%1_trigger",_doorid]);
    _codelock = createVehicle["bde_codelock", _relPos, [], 0, "CAN_COLLIDE"];

    _codelock enableSimulationGlobal false;
    _codelock setDir ((getDir _house) - 180);
    _codelock setPos (_codelock modelToWorld [1,0.3,0]);
    _codelock attachTo [_house,[0,0,0]];

    sleep 0.1;
} forEach _dbResult;
