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


// Hangars
_allHangars = nearestObjects [worldCenter, ["Land_Hangar_F","Land_TentHangar_V1_F"], worldHalfSize];
{
    _markerstr = createMarker [format["hangar%1",_foreachindex],getPos _x];
    _markerstr setMarkerShape "ICON";
    _markerstr setMarkerType "mil_arrow";
    _dir = (getDir _x) - 180;
    /*if(_dir < 0)then{
        _dir = 360 - abs _dir;
    };*/

    _markerstr setMarkerDir _dir;
    _testplane = "C_Plane_Civil_01_F" createVehicle (getPosATL _x);
    _testplane setDir _dir;
} forEach _allHangars;

// Primary Airfield
_afMainPos  = getArray (configFile >> "CfgWorlds" >> worldName >> "ilsPosition");
_ilsDir     = getArray (configFile >> "CfgWorlds" >> worldName >> "ilsDirection");

_markerstr      = createMarker ["airfieldMain",_afMainPos];
_markerstr setMarkerShape "ICON";
_markerstr setMarkerType "mil_arrow";

_testplane = "C_Plane_Civil_01_F" createVehicle _afMainPos;
_testplane setVectorDir  [_ilsDir select 0,_ilsDir select 2,(_ilsDir select 1) * (-1)];
_testplane setDir ((getDir _testplane) - 180);

_markerstr setMarkerDir (getDir _testplane);


// Secondary Airfields
_airfields   = (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports") call BIS_fnc_getCfgSubClasses;
{
    private["_pos","_dir","_ilsDir"];
    _pos = getArray (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports" >> _x >> "ilsPosition");
    _ilsDir = getArray (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports" >> _x >> "ilsDirection");

    _markerstr = createMarker [format["airfieldNo%1",_foreachindex],_pos];
    _markerstr setMarkerShape "ICON";
    _markerstr setMarkerType "mil_arrow";

    _testplane = "C_Plane_Civil_01_F" createVehicle _pos;
    _testplane setVectorDir [_ilsDir select 0,_ilsDir select 2,(_ilsDir select 1) * (-1)];
    _testplane setDir ((getDir _testplane) - 180);

    _markerstr setMarkerDir (getDir _testplane);

} forEach _airfields;