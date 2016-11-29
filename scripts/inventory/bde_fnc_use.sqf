params["_usedItem","_cargoType","_clickedIndex"/**/,"_itemActions","_outputItem","_requiredItems","_consumesItems","_putOutputItem","_valid"];

// Hide Actions Menu
ctrlDelete ((findDisplay 602) displayCtrl 2501);

// Set Variables & get data of item in cfgMagazines
_missingItem = "";

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

// Validate Requirements
{
    _xOfRequired    = _x;
    _countItemReq   = {_x == _xOfRequired} count _requiredItems;
    _countItemInv   = {_x == _xOfRequired} count _allItems;
    if(_countItemReq > _countItemInv) exitWith {
        _missingItem = _xOfRequired;
    };
} forEach _requiredItems;

if(_missingItem != "") exitWith {
    cutText [format["missing '%1'",_missingItem], "PLAIN DOWN"];
};

// Remove consuming items
if(!(_consumesItems isEqualTo [])) then {
    {
        _skip = false;
        if(_x in uniformItems player && !_skip) then {
            player removeItemFromUniform _x;
            _skip = true;
        };
        if(_x in uniformItems player && !_skip) then {
            player removeItemFromUniform _x;
            _skip = true;
        };
        if(_x in uniformItems player && !_skip) then {
            player removeItemFromUniform _x;
            _skip = true;
        };
    } forEach _consumesItems;
};

// Wait until action is done
sleep _actionTime;

// Remove used item
[_usedItem,_cargoType] call bde_fnc_removeItemCargo;

// Put new item to ground or player inventory
if(_putOutputItem == "ground")then{
    [_outputItem] call bde_fnc_addItemGround;
};
if(_putOutputItem == "cargo")then{
    [_outputItem,_cargoType] call bde_fnc_addItemCargo;
};

// Execute special function (must be global for player)
if(_customFunction != "")then{
    [] call compile _customFunction;
};