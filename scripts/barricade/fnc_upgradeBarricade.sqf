_barricade  = _this select 0;

// fetch barricade infos & remove object
_barricadeID        = _barricade getVariable "barricadeID";
_barricadeHealth    = _barricade getVariable "health";
_barricadeLevel     = _barricade getVariable "barricadeLevel";

_barricadePos       = getPosATL _barricade;
_barricadeRot       = getDir _barricade;

[_barricade] remoteExec ["fnc_deleteBarricade",2,false];
deleteVehicle _barricade;

// create next level
switch(_barricadeLevel)do{
    case 1:{
        _barricade = createVehicle ["bde_barricade_win_two", _barricadePos,[],0,"can_collide"];
    };
    case 2:{
        _barricade = createVehicle ["bde_barricade_win_three", _barricadePos,[],0,"can_collide"];
    };
    case 3:{
        _barricade = createVehicle ["bde_barricade_win_four", _barricadePos,[],0,"can_collide"];
    };
    case 4:{
        _barricade = createVehicle ["bde_barricade_win_five", _barricadePos,[],0,"can_collide"];
    };
    case 5:{
        _barricade = createVehicle ["bde_barricade_win_six", _barricadePos,[],0,"can_collide"];
    };
    default {
    };
};

_barricadeLevel = _barricadeLevel + 1;
if(_barricadeLevel >= 6)then{
    _barricadeLevel = 6;
};

_barricade setVariable["barricadeID",_barricadeID,true];
_barricade setVariable["health",_barricadeHealth,true];
_barricade setVariable["barricadeLevel",_barricadeLevel,true];

_barricade setPosATL _barricadePos;
_barricade enableSimulation false;
_barricade setDir _barricadeRot;

player removeItem "bde_plank";
player removeItem "bde_nails";
player removeItem "bde_nails";

if(typeOf _barricade != "bde_barricade_win_six")then{
    _barricade addAction ["Upgrade Window Barricade","scripts\barricade\fnc_upgradeBarricade.sqf", [], 6, false, false, "", "({_x == 'bde_nails'} count magazines player) >= 2  && ('bde_hammer' in (magazines player)) && ('bde_plank' in (magazines player))", 3, false];
};

_barricade addAction ["Destroy Barricade", {
    sleep 0.5;
    [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
    deleteVehicle (_this select 0);
},[],5,true,true,"","",3];

[_barricade] remoteExec ["fnc_saveBarricade",2,false];