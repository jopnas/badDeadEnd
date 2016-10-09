_caller     = _this select 1;

_windowBarricades        = ["bde_barricade_win_one","bde_barricade_win_two","bde_barricade_win_three","bde_barricade_win_four","bde_barricade_win_five","bde_barricade_win_six"]; //barricadeWoodElements + barricadeSandElements + barricadeDefenceElements;

barricade = createVehicle ["bde_barricade_win_one", getPosATL _caller,[],0,"can_collide"];
barricade enableSimulation false;
barricade setDir (getDir _caller);

fncUpgradeBarricade = {
    _caller     = _this select 1;
    _barricadePos   = getPosATL barricade;
    _barricadeRot   = getDir barricade;

    [barricade] remoteExec ["fnc_deleteBarricade",2,false];
    deleteVehicle barricade;

    systemChat (typeOf barricade);
    switch(typeOf barricade)do{
        case "bde_barricade_win_one":{
            barricade = createVehicle ["bde_barricade_win_two", _barricadePos,[],0,"can_collide"];
        };
        case "bde_barricade_win_two":{
            barricade = createVehicle ["bde_barricade_win_three", _barricadePos,[],0,"can_collide"];
        };
        case "bde_barricade_win_three":{
            barricade = createVehicle ["bde_barricade_win_four", _barricadePos,[],0,"can_collide"];
        };
        case "bde_barricade_win_four":{
            barricade = createVehicle ["bde_barricade_win_five", _barricadePos,[],0,"can_collide"];
        };
        case "bde_barricade_win_five":{
            barricade = createVehicle ["bde_barricade_win_six", _barricadePos,[],0,"can_collide"];
        };
        default {
        };
    };

    barricade enableSimulation false;
    barricade setDir _barricadeRot;

    if(typeOf barricade != "bde_barricade_win_six")then{
        barricade addAction ["Upgrade Window Barricade", {
            _caller     = _this select 1;
            [_caller] call fncUpgradeBarricade;
        }, [], 6, false, false, "", "", 3, false];
    };

    barricade addAction ["Destroy Barricade", {
        sleep 0.5;
        [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
        deleteVehicle (_this select 0);
    },[],5,true,true,"","",3];
};

// Actions
barricade addAction ["Attach Window Barricade", {
    _barricadePos   = getPosATL barricade;
    _barricadeID    = format["%1%2",getPlayerUID player,floor(_barricadePos select 0),floor(_barricadePos select 1),floor(_barricadePos select 2)];
    barricade setVariable["barricadeID",_barricadeID,true];
    barricade setVariable["health",1000,true];
    [barricade] remoteExec ["fnc_saveBarricade",2,false];

    barricade addAction ["Destroy Barricade", {
        sleep 0.5;
        [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
        deleteVehicle (_this select 0);
    },[],0,true,true,"","",3];

    barricade             = objNull;

}, [], 6, false, false, "", "", 10, false];

barricade addAction ["Upgrade Window Barricade", {
    _caller     = _this select 1;
    [_caller] call fncUpgradeBarricade;
}, [], 5, false, false, "", "", 3, false];

barricade addAction ["Destroy Barricade", {
    sleep 0.5;
    [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
    deleteVehicle (_this select 0);
},[],4,true,true,"","",3];
