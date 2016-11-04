disableSerialization;
params["_itemActionNames","_itemActionOutputs","_classname","_cargoType","_clickPos"];
systemChat format["_itemActionNames: %1, _itemActionOutputs: %2",_itemActionNames,_itemActionOutputs];


bde_fnc_addItemCargo = { // [_item,_cargoType] call bde_fnc_addItemCargo;
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

bde_fnc_addItemFloor = { // [_item] call bde_fnc_addItemFloor;
    _itemClass  = _this select 0;
    _pPos       = getPosATL player;
    _trashPos   = [(_pPos select 0) - 1 + random 2,(_pPos select 1) - 1 + random 2,(_pPos select 2) + 0.5];

    _trashWph   = createVehicle ["groundWeaponHolder", _trashPos, [], 1, "CAN_COLLIDE"];
    _trashWph setVehiclePosition [_trashPos, [], 0, "CAN_COLLIDE"];

    _trashWph setDir round(random 360);
    _trashWph addMagazineCargoGlobal [_itemClass, 1];
};

bde_fnc_removeItemCargo = { // [_item,_cargoType] call bde_fnc_removeItemCargo;
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

useItem = {
    params["_usedItem","_cargoType","_itemActionOutputs","_clickedIndex"/**/,"_newItem"];
    _newItem = _itemActionOutputs select _clickedIndex;
    systemChat format["%1, %2, %3",_usedItem,_cargoType,_itemActionOutputs select _clickedIndex],

    ctrlDelete ((findDisplay 602) displayCtrl 2501);
    [_usedItem,_cargoType] call bde_fnc_removeItemCargo;
    sleep 5;
    [_newItem,_cargoType] call bde_fnc_addItemCargo;
};

_showInventoryActions = {
    params["_classname","_cargoType","_itemActionNames","_clickPos"];

    if(_itemActionNames isEqualType [])then{
        _invActionLB = findDisplay 602 ctrlCreate ["InventoryActionMenu", 2501];

        {
            lbAdd[2501,_x];
        } forEach _itemActionNames;

        _invActionPos       = ctrlPosition _invActionLB;
        _invActionNewHeight = (count _itemActionNames) * 0.03;

        _invActionLB ctrlSetPosition [(_clickPos select 0) - 0.1, (_clickPos select 1) - 0.01, _invActionPos select 2, _invActionNewHeight];
        _invActionLB ctrlCommit 0;
        ctrlSetFocus _invActionLB;

        _invActionLB ctrlSetEventHandler ["LBSelChanged",format["['%1','%2',%3,_this select 1] call useItem",_classname,_cargoType,_itemActionOutputs]];
    };
};
[_classname,_cargoType,_itemActionNames,_clickPos] call _showInventoryActions;