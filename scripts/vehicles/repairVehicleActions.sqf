params["_thisVehicle",/**/"_repairActionIDs","_repairableParts"];
_repairActionIDs = _thisVehicle getVariable ["repairActionIDs", []];

_vehicleDamages = getAllHitPointsDamage _thisVehicle;
_vehicleDamageNames2 = _vehicleDamages select 0;
_vehicleDamageNames  = _vehicleDamages select 1;
_vehicleDamageValues = _vehicleDamages select 2;

if(count _repairActionIDs == 0)then{
    _addActionsReady = false;
    {
        _vehicleDamageName  = _vehicleDamageNames select _forEachIndex;
        _vehicleDamageValue = _vehicleDamageValues select _forEachIndex;
        _vehicleDamageName2 = _vehicleDamageNames2 select _forEachIndex;

        _damagePercent  = 100 - floor(_vehicleDamageValue*100);
        _actionText = "";
        if(_damagePercent >= 66)then{
            _actionText = format["<t color='#00FF00'>Repair %1: %2%3</t>",_vehicleDamageName2,_damagePercent,"%"];
        };
        if(_damagePercent >= 33 && _damagePercent < 66 )then{
            _actionText = format["<t color='#FFFF00'>Repair %1: %2%3</t>",_vehicleDamageName2,_damagePercent,"%"];
        };
        if(_damagePercent < 33 )then{
            _actionText = format["<t color='#FF0000'>Repair %1: %2%3</t>",_vehicleDamageName2,_damagePercent,"%"];
        };

        if(_vehicleDamageName != "" && _vehicleDamageValue > 0)then{
            private["_repairAction"];
            _repairAction = _thisVehicle addAction[_actionText,{
                _target = _this select 0;
                _caller = _this select 1;
                _params = _this select 3;
                [_params select 0,_params select 1,_target,_params select 2,_this select 2,_caller] call bde_fnc_vehicleRepair;
            },[_vehicleDamageName2,_vehicleDamageValue,_vehicleDamageName],0,false,false,"","vehicle _this == _this",3,false];
            _repairActionIDs = _repairActionIDs + [_repairAction];
        };
        if(count _vehicleDamageNames2 == (_forEachIndex + 1))then{
            _addActionsReady = true;
        };
    }forEach _vehicleDamageNames2;
    waitUntil {_addActionsReady};
    _thisVehicle setVariable ["repairActionIDs", _repairActionIDs,false];
};