params["_thisVehicle"];
_vehicleDamages = getAllHitPointsDamage _thisVehicle;
{
    _i = _forEachIndex;
    _vehicleDamageName  = (_vehicleDamages select 1) select _i;
    _vehicleDamageValue = (_vehicleDamages select 2) select _i;
    _vehicleDamageName2 = (_vehicleDamages select 0) select _i;

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

    if(_vehicleDamageName != "" && _vehicleDamageValue > 0 && repairableParts find _vehicleDamageName < 0)then{
        private["_repairAction"];
        repairableParts = repairableParts + [_vehicleDamageName];
        _repairAction = player addAction[_actionText,{
            _params = _this select 3;
            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] call vehicleRepair;
        },[_vehicleDamageName2,_vehicleDamageValue,_thisVehicle,_vehicleDamageName]];
        repairActionIDs = repairActionIDs + [_repairAction];
    };
}forEach(_vehicleDamages select 0);

while{alive player && count repairActionIDs > 0}do{
    if(count repairableParts > 0 && _thisVehicle distance player > 2 || !(alive player) || count repairActionIDs == 0)exitWith{
        repairableParts = [];
        {
            player removeAction _x;
            repairActionIDs = repairActionIDs - [_x];
        }forEach repairActionIDs;
    };
};