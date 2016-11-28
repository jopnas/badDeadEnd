disableSerialization;
params["_classname","_cargoType","_clickPos"];

//systemChat format["_itemActions: %1",_itemActions];

bde_fnc_addItemCargo = { // [item,cargoType] call bde_fnc_addItemCargo;
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

bde_fnc_addItemGround = { // [item] spawn bde_fnc_addItemGround;
    _itemClass  = _this select 0;
    _pPos       = getPosATL player;
    _trashPos   = [(_pPos select 0) - 1 + random 2,(_pPos select 1) - 1 + random 2,(_pPos select 2) + 0.5];

    _trashWph   = createVehicle ["groundWeaponHolder", _trashPos, [], 1, "CAN_COLLIDE"];
    _trashWph setVehiclePosition [_trashPos, [], 0, "CAN_COLLIDE"];

    _trashWph setDir round(random 360);
    _trashWph addMagazineCargoGlobal [_itemClass, 1];
};

bde_fnc_removeItemCargo = { // [item,cargo] spawn bde_fnc_removeItemCargo;
    _itemClass = _this select 0;
    _cargoType = _this select 1;

    if(_cargoType == "")then{
        if(_itemClass in uniformItems player) exitWith {
            player removeItemFromUniform _itemClass;
        };
        if (_itemClass in vestItems player) exitWith {
            player removeItemFromVest _itemClass;
        };
        if (_itemClass in backpackItems player) exitWith {
            player removeItemFromBackpack _itemClass;
        };
    }else{
        if(_cargoType == "Uniform") then {
            player removeItemFromUniform _itemClass;
        };
        if(_cargoType == "Vest") then {
            player removeItemFromVest _itemClass;
        };
        if(_cargoType == "Backpack") then {
            player removeItemFromBackpack _itemClass;
        };
    }
};

useItem = {
    params["_usedItem","_cargoType","_clickedIndex"/**/,"_itemActions","_outputItem","_requiredItems","_consumesItems","_putOutputItem","_dontStop"];
    //ctrlDelete ((findDisplay 602) displayCtrl 2501);

    /*class action1 {
        actionText = "Collapse";
        outputItem = "bde_multitool";
        requiredItems[] = {};
        consumesItems[] = {};
        putOutputItem = "cargo/ground";
        actionTime = 10;
        customFunction = "buildCampfire";
    };*/

    _itemActions    = (configFile >> "CfgMagazines" >> _usedItem >> "itemActions") call BIS_fnc_getCfgSubClasses;
    _selectedAction = _itemActions select _clickedIndex;
    _outputItem     = getText (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "outputItem");
    _requiredItems  = getArray (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "requiredItems");
    _consumesItems  = getArray (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "consumesItems");
    _putOutputItem  = getText (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "putOutputItem");
    _actionTime     = getNumber (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "actionTime");
    _actionSound    = getText (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "actionSound");
    _customFunction = getText (configFile >> "CfgMagazines" >> _usedItem >> "itemActions" >> _selectedAction >> "customFunction");

    _allItems = (uniformitems player) + (vestitems player) + (backpackitems player);

    if(_customFunction != "")then{
        [] call compile _customFunction;
    };

    _dontStop = true;
    {
        if(!(_x in _allItems))then{
            _dontStop = false;
        };
    } forEach _requiredItems;

    if(!_dontStop) exitWith {
        cutText ["missing item", "PLAIN DOWN"];
    };

    systemChat format["_consumesItems: %1, dontStop: %2",_consumesItems,_dontStop];

    if(!(_consumesItems isEqualTo [])) then {
        {
            [_x,""] call bde_fnc_removeItemCargo;
        } forEach _consumesItems;
    };

    sleep _actionTime;

    if(_putOutputItem == "ground")then{
        [_outputItem] call bde_fnc_addItemGround;
    };
    if(_putOutputItem == "cargo")then{
        [_outputItem,_cargoType] call bde_fnc_addItemCargo;
    };
    if(_putOutputItem == "")then{
        [_x,_cargoType] spawn bde_fnc_removeItemCargo;
    };
};

// Stone + Wood Action
bde_fnc_buildFireplace = {
    private["_minWood","_minStone","_needCountOfWood","_needCountOfStone","_woodCount","_stoneCount"];
    _minWood = 2;
    _minStone = 4;
    _woodCount  = {_x == "bde_wood"} count magazines player;
    _stoneCount = {_x == "bde_stone"} count magazines player;
    if(_woodCount >= _minWood && _stoneCount >= _minStone)then{
        player playActionNow "Medic";
        [player,"buildSound0","configVol","randomPitch",300] spawn bde_fnc_playSound3D;
        sleep 5;
        for "_w" from 0 to _minWood step 1 do {
            ["bde_wood",_cargoType] spawn _removeItemCargo;
        };
        for "_s" from 0 to _minStone step 1 do {
            ["bde_stone",_cargoType] spawn _removeItemCargo;
        };
    	cutText ["build fireplace", "PLAIN DOWN"];

        fireplace = createVehicle ["Land_FirePlace_F",position player,[],0,"can_collide"];

    	fireplace setDir (getDir player);
        fireplace attachTo [player, [0,2,0]];
    	releaseFireplace = player addAction ["Release Fireplace", { detach fireplace; player removeAction releaseFireplace;}, name player];
    }else{
    	if(_woodCount >= _minWood)then{
            _needCountOfWood = 0;
        }else{
            _needCountOfWood = _minWood - _woodCount;
        };
    	if(_stoneCount >= _minStone)then{
            _needCountOfStone = 0;
        }else{
    		_needCountOfStone = _minStone - _stoneCount;
        };
        cutText [ format["need %1 more wood and %2 more stone to build fireplace",_needCountOfWood,_needCountOfStone], "PLAIN DOWN"];
    };
};

_showInventoryActions = {
    params["_classname","_cargoType","_clickPos"/**/,"_itemActions"];

    _itemActions = (configFile >> "CfgMagazines" >> _classname >> "itemActions") call BIS_fnc_getCfgSubClasses;

    if(_itemActions isEqualType [] && count _itemActions > 0)then{
        _invActionLB = findDisplay 602 ctrlCreate ["InventoryActionMenu", 2501];
        {
            _actionText = getText (configFile >> "CfgMagazines" >> _classname >> "itemActions" >> _x >> "actionText");
            lbAdd[2501,_actionText];
        } forEach _itemActions;

        _rowHeight          = 0.05;
        _invActionPos       = ctrlPosition _invActionLB;
        _invActionNewHeight = (count _itemActions) * _rowHeight;

        _invActionLB ctrlSetPosition [(_clickPos select 0) - 0.1, (_clickPos select 1) - 0.01, _invActionPos select 2, _invActionNewHeight];
        _invActionLB ctrlCommit 0;
        ctrlSetFocus _invActionLB;

        _invActionLB ctrlSetEventHandler ["LBSelChanged",format["['%1','%2',_this select 1] spawn useItem;",_classname,_cargoType]];
    };
};

[_classname,_cargoType,_clickPos] call _showInventoryActions;