_disconnectedPlayer = addMissionEventHandler["HandleDisconnect",{
    params["_unit","_id","_uid","_name"];
    if (isPlayer _unit) then {
        _unit setVariable["playerSetupReady",false,true];
        deleteVehicle _unit;
    };
}];
