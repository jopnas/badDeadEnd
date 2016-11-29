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