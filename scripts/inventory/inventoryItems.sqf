disableSerialization;
private["_idcData","_cargoType","_clickPos","_idc","_selectedIndex","_classname","_description","_index","_pic","_buildFireplace","_needCountOfWood","_needCountOfStone","_magazinesDetail","_magazinesAmmoCargo"];

_idc            = _this select 0;
_selectedIndex  = _this select 1;
_cargoType      = _this select 2;
_clickPos   	= _this select 3;
_idcData        = _this select 4;

_classname 	    = lbData [_idc, _selectedIndex];
_description    = lbText [_idc, _selectedIndex];
_index          = lbValue [_idc, _selectedIndex];
_pic 	        = lbPicture [_idc, _selectedIndex];

// Functions
inventoryActions = compile preprocessFile "scripts\inventory\inventoryActions.sqf";
_showInventoryActions = {
    params["_classname","_cargoType","_actionNames"];

    _invActionList = createDialog "invActionsGUI";
    {
        lbAdd[1500,_x];
    } forEach _actionNames;

    _invActionCtrl      = (findDisplay 6901) displayCtrl 1500;
    _invActionPos       = ctrlPosition _invActionCtrl;
    _invActionNewHeight = (lbSize _invActionCtrl) * (0.027 + 0.01);

    _invActionCtrl ctrlSetPosition [(_clickPos select 0) - 0.1, (_clickPos select 1) - 0.01, _invActionPos select 2, _invActionNewHeight];
    _invActionCtrl ctrlCommit 0;

    _invActionCtrl ctrlSetEventHandler ["LBSelChanged", format["['%1','%2',_this select 1] spawn inventoryActions;closeDialog 6901;",_classname,_cargoType]];
};

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

_buildFireplace = {
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
            //player removeMagazine "bde_wood";
            ["bde_wood",_cargoType] call _removeItemCargo;
      };
      for "_s" from 0 to _minStone step 1 do {
            //player removeMagazine "bde_stone";
            ["bde_stone",_cargoType] call _removeItemCargo;
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

switch(_classname) do {
    // Food
	case "bde_bottleuseless": {
        [_classname,_cargoType,["fix damaged bottle"]] call _showInventoryActions;
	};
	case "bde_bottleempty": {
        [_classname,_cargoType,["refill bottle"]] call _showInventoryActions;
	};
	case "bde_bottlefilled": {
        [_classname,_cargoType,["use water purification tablets","empty bottle"]] call _showInventoryActions;
	};
	case "bde_bottleclean": {
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 50;
        [_classname,_cargoType] call _removeItemCargo;
        ["bde_bottleempty",_cargoType] call _addItemCargo;
		cutText ["drank clean water", "PLAIN DOWN"];
	};
	case "bde_canteenempty":  {
		if(drinkActionAvailable)then{
    	    //player say3D "fillSound0";
            [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
			//player removeMagazine _classname;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_canteenfilled",_cargoType] call _addItemCargo;
            //player addMagazine ["bde_canteenfilled",1];
			cutText ["filled canteen with clean water", "PLAIN DOWN"];
		}else{
	        cutText ["not close to clean water source", "PLAIN DOWN"];
		};
	};
	case "bde_canteenfilled": {
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 30;
        [_classname,_cargoType] call _removeItemCargo;
        ["bde_canteenempty",_cargoType] call _addItemCargo;
		cutText ["drank clean water", "PLAIN DOWN"];
	};
	case "bde_sodacan_01": {
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 10;
        [_classname,_cargoType] call _removeItemCargo;
		["bde_canempty"] call _addItemFloor;
		cutText ["drank can of Magic Cola", "PLAIN DOWN"];
	};

	case "bde_sodacan_02": {
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 10;
        [_classname,_cargoType] call _removeItemCargo;
		["bde_canempty"] call _addItemFloor;
		cutText ["drank can of Spirit", "PLAIN DOWN"];
	};

	case "bde_canunknown": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + (random(20)+20);
        [_classname,_cargoType] call _removeItemCargo;
		["bde_emptycanunknown"] call _addItemFloor;
		_tastes =  ["salty","sweet","bitter","sour","flavorless"];
		cutText [format["ate somthing %1",selectRandom _tastes], "PLAIN DOWN"];
	};
	case "bde_canpasta": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 20;
        [_classname,_cargoType] call _removeItemCargo;
        ["bde_emptycanpasta"] call _addItemFloor;
		cutText ["ate pasta", "PLAIN DOWN"];
	};
	case "bde_bakedbeans": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 25;
        [_classname,_cargoType] call _removeItemCargo;
		["bde_emptycanunknown"] call _addItemFloor;
		cutText ["ate baked beans", "PLAIN DOWN"];
	};
	case "bde_tacticalbacon": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 15;
        [_classname,_cargoType] call _removeItemCargo;
		["bde_emptycanunknown"] call _addItemFloor;
		cutText ["ate tactical bacon", "PLAIN DOWN"];
	};

	case "bde_meat_big": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 30;
		playerHealth = playerHealth - 10;
        [_classname,_cargoType] call _removeItemCargo;
		cutText ["ate big peace of raw meat", "PLAIN DOWN"];
	};
	case "bde_meat_big_cooked": {
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 40;
        [_classname,_cargoType] call _removeItemCargo;
		cutText ["ate big peace of cooked meat", "PLAIN DOWN"];
	};
	case "bde_meat_small": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 15;
		playerHealth = playerHealth - 10;
        [_classname,_cargoType] call _removeItemCargo;
		//player removeMagazine _classname;
		cutText ["ate small peace of raw meat", "PLAIN DOWN"];
	};
	case "bde_meat_small_cooked": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 30;
        [_classname,_cargoType] call _removeItemCargo;
		//player removeMagazine _classname;
		cutText ["ate small peace of cooked meat", "PLAIN DOWN"];
	};

	case "bde_apple": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 10;
		playerHealth = playerHealth + 10;
		playerThirst = playerThirst + 5;
        [_classname,_cargoType] call _removeItemCargo;
		cutText ["ate apple", "PLAIN DOWN"];
	};

	// Medical
	case "bde_vitamines": {
        [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 1;
		playerHealth = playerHealth + 10;
        [_classname,_cargoType] call _removeItemCargo;
		//player removeMagazine _classname;
		cutText ["took vitamines", "PLAIN DOWN"];
	};

	case "bde_antibiotics": {
        [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 1;
		playerInfected = 0;
		playerSick = 0;
		playerHealth = playerHealth + 20;
        [_classname,_cargoType] call _removeItemCargo;
		//player removeMagazine _classname;
		cutText ["took antibiotics", "PLAIN DOWN"];
	};

    // Camonets
    case "bde_camonetSmallPacked": {
        [player,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 5;
        [_classname,_cargoType] call _removeItemCargo;

        _pitchedCamoNet = createVehicle ["CamoNet_INDP_open_F",getPosATL player,[],0,"can_collide"];
        _pitchedCamoNet setDir (getDir player);
        _pitchedCamoNet attachTo [player, [0,5,1.2]];

        releasepitchedCamoNet = player addAction ["Release pitched Camonet", {
            _param      = _this select 3;
            _object     = _param select 0;
            _classname  = _param select 1;

            detach _object;
            _pos = getPosATL _object;
            _object setVehiclePosition [[_pos select 0,_pos select 1,(_pos select 2)+1], [],0,"can_collide"];
            player removeAction releasepitchedCamoNet;

            _tentPos        = getPosAtL _object;
            _tentID         = format["%1%2",getPlayerUID player,floor(_tentPos select 0),floor(_tentPos select 1),floor(_tentPos select 2)];

            _object setVariable["tentID",_tentID,true];
            [_object] remoteExec ["fnc_saveTent",2,false];

            _object addAction ["Pack Camonet", {
                _targetObject   = _this select 0;
                _caller         = _this select 1;
                _classname      = _this select 3;

                [_targetObject,_caller,_classname] call bde_fnc_packTent;
            }, _classname,0,true,true,"","",5,false];

        }, [_pitchedCamoNet,_classname]];
	};

    case "bde_camonetBigPacked": {
        [player,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 5;
        [_classname,_cargoType] call _removeItemCargo;

        _pitchedCamoNet = createVehicle ["CamoNet_INDP_F",getPosATL player,[],0,"can_collide"];
        _pitchedCamoNet setDir (getDir player);
        _pitchedCamoNet attachTo [player, [0,5,1.2]];

        releasepitchedCamoNet = player addAction ["Release pitched Camonet", {
            _param      = _this select 3;
            _object     = _param select 0;
            _classname  = _param select 1;

            detach _object;
            _pos = getPosATL _object;
            _object setVehiclePosition [[_pos select 0,_pos select 1,(_pos select 2)+1], [],0,"can_collide"];
            player removeAction releasepitchedCamoNet;

            _tentPos        = getPosAtL _object;
            _tentID         = format["%1%2",getPlayerUID player,floor(_tentPos select 0),floor(_tentPos select 1),floor(_tentPos select 2)];
            _tentOwner      = getPlayerUID player;

            _object setVariable["tentID",_tentID,true];
            [_object] remoteExec ["fnc_saveTent",2,false];

            _object addAction ["Pack Camonet", {
                _targetObject   = _this select 0;
                _caller         = _this select 1;
                _classname      = _this select 3;

                [_targetObject,_caller,_classname] call bde_fnc_packTent;
            }, _classname,0,true,true,"","",5,false];
        }, [_pitchedCamoNet,_classname]];
	};

    case "bde_camonetVehiclesPacked": {
        [player,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 5;
        [_classname,_cargoType] call _removeItemCargo;

        _pitchedCamoNet = createVehicle ["CamoNet_INDP_big_F",getPosATL player,[],0,"can_collide"];
        _pitchedCamoNet setDir (getDir player);
        _pitchedCamoNet attachTo [player, [0,8,1.5]];

        releasepitchedCamoNet = player addAction ["Release pitched Camonet", {
            _param      = _this select 3;
            _object     = _param select 0;
            _classname  = _param select 1;

            detach _object;
            _pos = getPosATL _object;
            _object setVehiclePosition [[_pos select 0,_pos select 1,(_pos select 2)+1], [],0,"can_collide"];
            player removeAction releasepitchedCamoNet;

            _tentPos        = getPosAtL _object;
            _tentID         = format["%1%2",getPlayerUID player,floor(_tentPos select 0),floor(_tentPos select 1),floor(_tentPos select 2)];
            _tentOwner      = getPlayerUID player;

            _object setVariable["tentID",_tentID,true];
            [_object] remoteExec ["fnc_saveTent",2,false];

            _object addAction ["Pack Camonet", {
                _targetObject   = _this select 0;
                _caller         = _this select 1;
                _classname      = _this select 3;

                [_targetObject,_caller,_classname] call bde_fnc_packTent;
            }, _classname,0,true,true,"","",8,false];
        }, [_pitchedCamoNet,_classname]];
	};

    // Tents
    case "bde_tentDomePacked": {
        [player,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 5;
        [_classname,_cargoType] call _removeItemCargo;

        _pitchedTent = createVehicle ["bde_tentDome",getPosATL player,[],0,"can_collide"];
        _pitchedTent setDir (getDir player);
        _pitchedTent attachTo [player, [0,4,1.2]];

        releasepitchedTent = player addAction ["Release pitched Tent", {
            _param      = _this select 3;
            _object     = _param select 0;
            _classname  = _param select 1;

            detach _object;
            _pos = getPosATL _object;
            _object setVehiclePosition [[_pos select 0,_pos select 1,(_pos select 2)+1], [],0,"can_collide"];
            player removeAction releasepitchedTent;

            _tentPos        = getPosAtL _object;
            _tentID         = format["%1%2",getPlayerUID player,floor(_tentPos select 0),floor(_tentPos select 1),floor(_tentPos select 2)];
            _tentOwner      = getPlayerUID player;

            _object setVariable["tentID",_tentID,true];
            [_object] remoteExec ["fnc_saveTent",2,false];

            _object addAction ["Pack Tent", {
                _targetObject   = _this select 0;
                _caller         = _this select 1;
                _classname      = _this select 3;

                [_targetObject,_caller,_classname] call bde_fnc_packTent;
            }, _classname,0,true,true,"","",3,false];

            _object addEventHandler ["ContainerClosed", {
                params["_container","_player"];
                [_container] remoteExec ["fnc_saveTent",2,false];
            }];
        }, [_pitchedTent,_classname]];
	};

    case "bde_tentCamoPacked": {
        [player,"toolSound1",0,0] remoteExec ["bde_fnc_say3d",0,false];
		sleep 5;
        [_classname,_cargoType] call _removeItemCargo;

        _pitchedTent = createVehicle ["bde_tentCamo",getPosATL player,[],0,"can_collide"];

        _pitchedTent setDir (getDir player);
        _pitchedTent attachTo [player, [0,4,1.2]];

        releasepitchedTent = player addAction ["Release pitched Tent", {
            _param      = _this select 3;
            _object     = _param select 0;
            _classname  = _param select 1;

            detach _object;
            _pos = getPosATL _object;
            _object setVehiclePosition [[_pos select 0,_pos select 1,(_pos select 2)+1], [],0,"can_collide"];
            player removeAction releasepitchedTent;

            _tentPos        = getPosAtL _object;
            _tentID         = format["%1%2",getPlayerUID player,floor(_tentPos select 0),floor(_tentPos select 1),floor(_tentPos select 2)];
            _tentOwner      = getPlayerUID player;

            _object setVariable["tentID",_tentID,true];
            [_object] remoteExec ["fnc_saveTent",2,false];

            _object addAction ["Pack Tent", {
                _targetObject   = _this select 0;
                _caller         = _this select 1;
                _classname      = _this select 3;

                [_targetObject,_caller,_classname] call bde_fnc_packTent;
            }, _classname,0,true,true,"","",3,false];

            _object addEventHandler ["ContainerClosed", {
                    params["_container","_player"];
                    [_container] remoteExec ["fnc_saveTent",2,false];
            }];
        }, [_pitchedTent,_classname]];
	};

    // Tools
    case "bde_stone": {
        [] call _buildFireplace;
    };

    case "bde_wood": {
        [] call _buildFireplace;
    };

    default {};
};
