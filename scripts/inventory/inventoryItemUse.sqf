disableSerialization;
params["_classname","_cargoType","_clickPos"];

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

        _invActionLB ctrlSetEventHandler ["LBSelChanged",format["['%1','%2',_this select 1] execVM 'scripts\inventory\bde_fnc_use.sqf';",_classname,_cargoType]];
    };
};

[_classname,_cargoType,_clickPos] call _showInventoryActions;