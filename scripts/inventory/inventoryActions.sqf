params["_classname","_cargoType","_actionNo"];
systemChat format["_classname: %1, _cargoType: %2, _actionNo: %3",_classname,_cargoType,_actionNo];

_addItemCargo = { // [_item,_cargoType] call _addItemCargo;
    _itemClass = _this select 0;
    _cargoType = _this select 1;

    switch(_cargoType) do {
        case "Backpack": {
            player addItemToBackpack _itemClass;
        };
        case "Vest": {
            player addItemToVest _itemClass;
        };
        case "Uniform": {
            player addItemToUniform _itemClass;
        };
        default {
        };
    };
};

_removeItemCargo = { // [_item,_cargoType] call _removeItemCargo;
    _itemClass = _this select 0;
    _cargoType = _this select 1;

    switch(_cargoType) do {
        case "Backpack": {
            player removeItemFromBackpack _itemClass;
        };
        case "Vest": {
            player removeItemFromVest _itemClass;
        };
        case "Uniform": {
            player removeItemFromUniform _itemClass;
        };
        default {
        };
    };
};

_addItemFloor = { // [_item] call _addItemFloor;
    _itemClass  = _this select 0;
    _pPos       = getPos player;
    _trashPos   = [_pPos select 0,_pPos select 1,(_pPos select 2) + 1];
    _trashPos   = [(_trashPos select 0) - 1 + random 2,(_trashPos select 1) - 1 + random 2,_trashPos select 2];

    _trashWph   = createVehicle ["groundWeaponHolder", _trashPos, [], 1, ""];

    _trashWph setDir round(random 360);
    _trashWph setVehiclePosition [_trashPos, [], 0, "CAN_COLLIDE"];
    _trashWph addMagazineCargoGlobal [_itemClass, 1];
};

switch(_classname) do {
    // Food
	case "bde_bottleuseless": {
        if('bde_ducttape' in Magazines Player)then{
            player playActionNow 'Medic';
            [player,"toolSound0",0,0] remoteExec ["bde_fnc_say3d",0,false];
            sleep 5;
            [_classname,_cargoType] call _removeItemCargo;
            ['bde_bottleempty',_cargoType] call _addItemCargo;
            cutText ['fixed damaged bottle', 'PLAIN DOWN'];
        }else{
            cutText ['need Ducttape to fix it', 'PLAIN DOWN'];
        };
    };

    case "bde_bottleempty": {
        if(drinkActionAvailable)then{
            player playActionNow "PutDown";
            //player say3D "fillSound0";
            [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            //player removeMagazine _classname;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_bottleclean",_cargoType] call _addItemCargo;
            //player addMagazine ["bde_bottleclean",1];
            cutText ["filled bottle with clean water", "PLAIN DOWN"];
        }else{
            if(nearOpenWater)then{
                player playActionNow "PutDown";
                //player say3D "fillSound0";
                [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
                sleep 1;
                //player removeMagazine _classname;
                [_classname,_cargoType] call _removeItemCargo;
                ["bde_bottlefilled",_cargoType] call _addItemCargo;
                //player addMagazine ["bde_bottlefilled",1];
                cutText ["filled bottle with dirty water", "PLAIN DOWN"];
            }else{
                cutText ["not close to water source", "PLAIN DOWN"];
            };
        };
    };

    case "bde_bottlefilled": {
        if(_actionNo == 0)then{
            if("bde_waterpurificationtablets" in Magazines player)then{
                player playActionNow "Medic";
                sleep 1;
                //player removeMagazine _classname;
                [_classname,_cargoType] call _removeItemCargo;
                //player removeMagazine "bde_waterpurificationtablets";
                ["bde_waterpurificationtablets",_cargoType] call _removeItemCargo;
                ["bde_bottleclean",_cargoType] call _addItemCargo;
                //player addMagazine ["bde_bottleclean",1];
                cutText ["purified dirty water", "PLAIN DOWN"];
            }else{
                cutText ["need water purification tablets", "PLAIN DOWN"];
            };
        };
        if(_actionNo == 1)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_bottleempty",_cargoType] call _addItemCargo;
            cutText ["emptied bottle", "PLAIN DOWN"];
        };
    };

    default {};
};
