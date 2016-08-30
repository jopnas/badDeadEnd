// Fuelpumps
_fuelPumps = nearestObjects [worldCenter, ["Land_FuelStation_01_pump_F","Land_FuelStation_02_pump_F","Land_FuelStation_Feed_F","Land_fs_feed_F"], worldHalfSize];
{
    _x setFuelCargo (1 - random 0.5);
    _x addAction["fill an empty fuel canister",{
        params["_target", "_caller", "_ID", "_arguments"];
        [_caller,"fillSound0",0,0] remoteExec ["bde_fnc_say3d",0,false];
        sleep 7;
        _caller removeMagazine "bde_fuelCanisterEmpty";
        _caller addMagazine "bde_fuelCanisterFilled";
        [] remoteExec ["cutText ['filled fuel canister', 'PLAIN DOWN']",_caller,false];
        _target setFuelCargo ((getFuelCargo _target) - 0.01);
        if(getFuelCargo _target <= 0)then{
            _target removeAction _ID;
        };
    },[],6,false,false,"","'bde_fuelCanisterEmpty' in Magazines _this",3,false];
} forEach _fuelPumps;