disableSerialization;
private["_idcData","_cargoType","_clickPos","_idc","_selectedIndex","_classname","_description","_index","_pic","_buildFireplace","_needCountOfWood","_needCountOfStone","_actionTexts"];

_idc            = _this select 0;
_selectedIndex  = _this select 1;
_cargoData      = _this select 2;
_cargoType      = _cargoData select 0;
_cargoCtrl      = _cargoData select 1;
_clickPos   	= _this select 3;
_idcData        = _this select 4;

_classname 	    = lbData [_idc, _selectedIndex];
_description    = lbText [_idc, _selectedIndex];
_index          = lbValue [_idc, _selectedIndex];
_pic 	        = lbPicture [_idc, _selectedIndex];

// Functions
inventoryActions = compile preprocessFile "scripts\inventory\inventoryActions.sqf";
_showInventoryActions = {
    params["_classname","_cargoType","_actionNames","_cargoCtrl"];

    if(_actionNames isEqualType [])then{
        //_invActionCtrl = findDisplay 602 ctrlCreate ["RscListbox", 2500, findDisplay 602 displayCtrl _cargoCtrl];
        _invActionCtrl = findDisplay 602 ctrlCreate ["RscListbox", 2500];

        {
            lbAdd[1500,_x];
        } forEach _actionNames;

        _invActionPos       = ctrlPosition _invActionCtrl;
        _invActionNewHeight = (lbSize _invActionCtrl) * (0.027 + 0.01);

        _invActionCtrl ctrlSetPosition [(_clickPos select 0) - 0.1, (_clickPos select 1) - 0.01, _invActionPos select 2, _invActionNewHeight];
        _invActionCtrl ctrlCommit 0;
        ctrlSetFocus _invActionCtrl;

        _invActionCtrl ctrlSetEventHandler ["LBSelChanged", format["['%1','%2',_this select 1] spawn inventoryActions;",_classname,_cargoType]];
    };
};

switch(_classname) do {
    // Bottles
	case "bde_bottleuseless": {
        _actionTexts = ["fix"];
	};
	case "bde_bottleempty": {
        _actionTexts = ["refill"];
	};
	case "bde_bottlefilled": {
        _actionTexts = ["purify","empty"];
	};
	case "bde_bottleclean": {
        _actionTexts = ["drink","empty"];
	};

    // Canteens
	case "bde_canteenempty":  {
        _actionTexts = ["refill"];
	};
	case "bde_canteenfilled": {
        _actionTexts = ["drink","empty"];
	};

    // Canned Drinks
	case "bde_sodacan_01": {
        _actionTexts = ["drink"];
	};
	case "bde_sodacan_02": {
        _actionTexts = ["drink"];
	};

    // Canned Food
	case "bde_canunknown": {
        _actionTexts = ["eat"];
	};
	case "bde_canpasta": {
        _actionTexts = ["eat"];
	};
	case "bde_bakedbeans": {
        _actionTexts = ["eat"];
	};
	case "bde_tacticalbacon": {
        _actionTexts = ["eat"];
	};

    // Meat
	case "bde_meat_big": {
        _actionTexts = ["eat"];
	};
	case "bde_meat_big_cooked": {
        _actionTexts = ["eat"];
	};

	case "bde_meat_small": {
        _actionTexts = ["eat"];
	};
	case "bde_meat_small_cooked": {
        _actionTexts = ["eat"];
	};

    // Fruits
	case "bde_apple": {
        _actionTexts = ["eat"];
	};

	// Medicals
	case "bde_vitamines": {
        _actionTexts = ["take"];
	};
	case "bde_antibiotics": {
        _actionTexts = ["take"];
	};

    // Camonets
    case "bde_camonetSmallPacked": {
        _actionTexts = ["build camonet"];
	};
    case "bde_camonetBigPacked": {
        _actionTexts = ["build camonet"];
	};
    case "bde_camonetVehiclesPacked": {
        _actionTexts = ["build camonet"];
	};

    // Tents
    case "bde_tentDomePacked": {
        _actionTexts = ["build tent"];
	};
    case "bde_tentCamoPacked": {
        _actionTexts = ["build tent"];
	};

    // Crafting Elements
    case "bde_stone": {
        _actionTexts = ["build fireplace"];
    };
    case "bde_wood": {
        _actionTexts = ["build fireplace"];
    };

    // Default :-P
    default {
        _actionTexts = "none";
    };
};

[_classname,_cargoType,_actionTexts,_cargoCtrl] call _showInventoryActions;
