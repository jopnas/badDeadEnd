_barricade  = _this select 0;

_barricadeID = _barricade getVariable "barricadeID";
_barricadeHealth = _barricade getVariable "health";

_barricadePos   = getPosATL _barricade;
_barricadeRot   = getDir _barricade;

[_barricade] remoteExec ["fnc_deleteBarricade",2,false];
deleteVehicle _barricade;

switch(typeOf _barricade)do{
    case "bde_barricade_win_one":{
        _barricade = createVehicle ["bde_barricade_win_two", _barricadePos,[],0,"can_collide"];
    };
    case "bde_barricade_win_two":{
        _barricade = createVehicle ["bde_barricade_win_three", _barricadePos,[],0,"can_collide"];
    };
    case "bde_barricade_win_three":{
        _barricade = createVehicle ["bde_barricade_win_four", _barricadePos,[],0,"can_collide"];
    };
    case "bde_barricade_win_four":{
        _barricade = createVehicle ["bde_barricade_win_five", _barricadePos,[],0,"can_collide"];
    };
    case "bde_barricade_win_five":{
        _barricade = createVehicle ["bde_barricade_win_six", _barricadePos,[],0,"can_collide"];
    };
    default {
    };
};

_barricade setVariable["barricadeID",_barricadeID,true];
_barricade setVariable["health",_barricadeHealth,true];

_barricade setPosATL _barricadePos;
_barricade enableSimulation false;
_barricade setDir _barricadeRot;

[_barricade] remoteExec ["fnc_saveBarricade",2,false];

if(typeOf _barricade != "bde_barricade_win_six")then{
    _barricade addAction ["Upgrade Window Barricade","scripts\barricade\fnc_upgradeBarricade.sqf", [], 6, false, false, "", "", 3, false];
};

_barricade addAction ["Destroy Barricade", {
    sleep 0.5;
    [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
    deleteVehicle (_this select 0);
},[],5,true,true,"","",3];