_dbResult = call fnc_loadBarricades;
{
    //systemChat str _x;
    _id             = _x select 0;
    _barricadeid    = _x select 1;
    _pos            = _x select 2;
    _rot            = _x select 3;
    _type           = _x select 4;
    _health         = _x select 5;

    _barricade      = _type createVehicle _pos;
    _barricade enableSimulation false;
    _barricade setDir _rot;
    _barricade setPosAtL _pos;

    //systemChat format["create %1",_type];

    _barricade setVariable["barricadeID", _barricadeid,true];
    _barricade setVariable["health", _health,true];

    _barricade addAction ["Destroy Barricade", {
        sleep 0.5;
        [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
        deleteVehicle (_this select 0);
    },_barricade getVariable["barricadeID","0"],5,true,true,"","isNull(attachedTo _target)",3];

    _barricade addAction ["Upgrade Window Barricade","scripts\barricade\fnc_upgradeBarricade.sqf", [], 6, false, false, "", "", 3, false];

} forEach _dbResult;
