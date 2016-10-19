params["_classname","_cargoType","_actionNo","_actionName"];
ctrlDelete ((findDisplay 602) displayCtrl 2501);

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
    _pPos       = getPosATL player;
    _trashPos   = [(_pPos select 0) - 1 + random 2,(_pPos select 1) - 1 + random 2,(_pPos select 2) + 0.5];

    _trashWph   = createVehicle ["groundWeaponHolder", _trashPos, [], 1, "CAN_COLLIDE"];
    _trashWph setVehiclePosition [_trashPos, [], 0, "CAN_COLLIDE"];

    _trashWph setDir round(random 360);
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
            ["bde_wood",_cargoType] call _removeItemCargo;
        };
        for "_s" from 0 to _minStone step 1 do {
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
            [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_bottleclean",_cargoType] call _addItemCargo;
            cutText ["filled bottle with clean water", "PLAIN DOWN"];
        }else{
            if(nearOpenWater)then{
                player playActionNow "PutDown";
                [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
                sleep 1;
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
                [_classname,_cargoType] call _removeItemCargo;
                ["bde_waterpurificationtablets",_cargoType] call _removeItemCargo;
                ["bde_bottleclean",_cargoType] call _addItemCargo;
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
    case "bde_bottleclean": {
        if(_actionNo == 0)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            playerThirst = playerThirst + 50;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_bottleempty",_cargoType] call _addItemCargo;
            cutText ["drank clean water", "PLAIN DOWN"];
        };
        if(_actionNo == 1)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_bottleempty",_cargoType] call _addItemCargo;
            cutText ["emptied bottle", "PLAIN DOWN"];
        };
    };
    case "bde_canteenempty":  {
        if(_actionNo == 0)then{
    		if(drinkActionAvailable)then{
                [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
        	    sleep 1;
                [_classname,_cargoType] call _removeItemCargo;
                ["bde_canteenfilled",_cargoType] call _addItemCargo;
    			cutText ["filled canteen with clean water", "PLAIN DOWN"];
    		}else{
    	        cutText ["not close to clean water source", "PLAIN DOWN"];
    		};
		};
    };
    case "bde_canteenfilled": {
        if(_actionNo == 0)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            playerThirst = playerThirst + 30;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_canteenempty",_cargoType] call _addItemCargo;
            cutText ["drank clean water", "PLAIN DOWN"];
        };
        if(_actionNo == 1)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_canteenempty",_cargoType] call _addItemCargo;
            cutText ["emptied canteen", "PLAIN DOWN"];
        };
    };
    case "bde_sodacan_01": {
        if(_actionNo == 0)then{
            [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            playerThirst = playerThirst + 10;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_sodacan_01_trash"] call _addItemFloor;
            cutText ["drank can of Pepsi", "PLAIN DOWN"];
        };
    };
    case "bde_canunknown": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + (random(20)+20);
            [_classname,_cargoType] call _removeItemCargo;
    		["bde_emptycanunknown"] call _addItemFloor;
    		_tastes =  ["salty","sweet","bitter","sour","flavorless"];
    		cutText [format["ate somthing %1",selectRandom _tastes], "PLAIN DOWN"];
	    };
	};
    case "bde_canunknown": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + (random(20)+20);
            [_classname,_cargoType] call _removeItemCargo;
    		["bde_emptycanunknown"] call _addItemFloor;
    		_tastes =  ["salty","sweet","bitter","sour","flavorless"];
    		cutText [format["ate somthing %1",selectRandom _tastes], "PLAIN DOWN"];
        };
	};

    case "bde_canpasta": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 20;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_emptycanpasta"] call _addItemFloor;
    		cutText ["ate pasta", "PLAIN DOWN"];
	       };
	};
	case "bde_bakedbeans": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 25;
            [_classname,_cargoType] call _removeItemCargo;
    		["bde_emptycanunknown"] call _addItemFloor;
    		cutText ["ate baked beans", "PLAIN DOWN"];
    	};
	};
	case "bde_tacticalbacon": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 15;
            [_classname,_cargoType] call _removeItemCargo;
    		["bde_emptycanunknown"] call _addItemFloor;
    		cutText ["ate tactical bacon", "PLAIN DOWN"];
    	};
   };

	case "bde_meat_big": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 30;
    		playerHealth = playerHealth - 10;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["ate big peace of raw meat", "PLAIN DOWN"];
    	};
	};
	case "bde_meat_big_cooked": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 40;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["ate big peace of cooked meat", "PLAIN DOWN"];
        };
	};
	case "bde_meat_small": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 15;
    		playerHealth = playerHealth - 10;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["ate small peace of raw meat", "PLAIN DOWN"];
    	};
	};
	case "bde_meat_small_cooked": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 30;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["ate small peace of cooked meat", "PLAIN DOWN"];
        };
	};

	case "bde_apple": {
        if(_actionNo == 0)then{
            [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
    		playerHunger = playerHunger + 10;
    		playerHealth = playerHealth + 10;
    		playerThirst = playerThirst + 5;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["ate apple", "PLAIN DOWN"];
        };
	};

	// Medical
	case "bde_vitamines": {
        if(_actionNo == 0)then{
            [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    		sleep 1;
    		playerHealth = playerHealth + 10;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["took vitamines", "PLAIN DOWN"];
            _actionTexts = ["take"];
    	};
	};

	case "bde_antibiotics": {
        if(_actionNo == 0)then{
            [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    		sleep 1;
    		playerInfected = 0;
    		playerSick = 0;
    		playerHealth = playerHealth + 20;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["took antibiotics", "PLAIN DOWN"];
    	};
	};

	case "bde_antiradiationtablets": {
        if(_actionNo == 0)then{
            [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
    		sleep 1;
    		playerPoisoning = 0;
            [_classname,_cargoType] call _removeItemCargo;
    		cutText ["took antiradiation tablets", "PLAIN DOWN"];
    	};
	};

	case "bde_gasmask_filter": {
        if(_actionNo == 0)then{
            //[player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_gasmask_wasted",_cargoType] call _removeItemCargo;
            ["bde_gasmask",_cargoType] call _addItemCargo;
    		cutText ["changed filter off wasted gasmask", "PLAIN DOWN"];
    	};
	};

    // Camonets
    case "bde_camonetSmallPacked": {
        if(_actionNo == 0)then{
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

                _object addAction ["pack camonet", {
                    _targetObject   = _this select 0;
                    _caller         = _this select 1;
                    _classname      = _this select 3;

                    [_targetObject,_caller,_classname] call bde_fnc_packTent;
                }, _classname,0,true,true,"","",5,false];

            }, [_pitchedCamoNet,_classname]];
    	};
	};

    case "bde_camonetBigPacked": {
        if(_actionNo == 0)then{
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

                _object addAction ["pack camonet", {
                    _targetObject   = _this select 0;
                    _caller         = _this select 1;
                    _classname      = _this select 3;

                    [_targetObject,_caller,_classname] call bde_fnc_packTent;
                }, _classname,0,true,true,"","",5,false];
            }, [_pitchedCamoNet,_classname]];
    	};
	};

    case "bde_camonetVehiclesPacked": {
        if(_actionNo == 0)then{
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

                _object addAction ["pack camonet", {
                    _targetObject   = _this select 0;
                    _caller         = _this select 1;
                    _classname      = _this select 3;

                    [_targetObject,_caller,_classname] call bde_fnc_packTent;
                }, _classname,0,true,true,"","",8,false];
            }, [_pitchedCamoNet,_classname]];
        };
    };

    // Tents
    case "bde_tentDomePacked": {
        if(_actionNo == 0)then{
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

                _object addAction ["pack tent", {
                    _targetObject   = _this select 0;
                    _caller         = _this select 1;
                    _classname      = _this select 3;
                    if(count (magazines _targetObject) == 0 && count (weapons _targetObject) == 0 && count (items _targetObject) == 0 )then{
                        [_targetObject,_caller,_classname] call bde_fnc_packTent;
                    }else{
                        cutText ["not empty", "PLAIN DOWN"];
                    };
                }, _classname,0,true,true,"","",3,false];

                _object addEventHandler ["ContainerClosed", {
                    params["_container","_player"];
                    [_container] remoteExec ["fnc_saveTent",2,false];
                }];
            }, [_pitchedTent,_classname]];
    	};
	};

    case "bde_tentCamoPacked": {
        if(_actionNo == 0)then{
            [player,"toolSound1",0,0] remoteExec ["bde_fnc_say3d",0,false];
    		sleep 5;
            [_classname,_cargoType] call _removeItemCargo;

            _pitchedTent = createVehicle ["bde_tentCamo",getPosATL player,[],0,"can_collide"];

            _pitchedTent setDir (getDir player);
            _pitchedTent attachTo [player, [0,4,1.2]];

            releasepitchedTent = player addAction ["release tent", {
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

                _object addAction ["pack tent", {
                    _targetObject   = _this select 0;
                    _caller         = _this select 1;
                    _classname      = _this select 3;
                    if(count (magazines _targetObject) == 0 && count (weapons _targetObject) == 0 && count (items _targetObject) == 0 )then{
                        [_targetObject,_caller,_classname] call bde_fnc_packTent;
                    }else{
                        cutText ["not empty", "PLAIN DOWN"];
                    };
                }, _classname,0,true,true,"","",3,false];

                _object addEventHandler ["ContainerClosed", {
                        params["_container","_player"];
                        [_container] remoteExec ["fnc_saveTent",2,false];
                }];
            }, [_pitchedTent,_classname]];
    	};
	};

    // Tools
    case "bde_stone": {
        if(_actionNo == 0)then{
            [] call _buildFireplace;
        };
    };

    case "bde_wood": {
        if(_actionNo == 0)then{
            [] call _buildFireplace;
        };
    };

    // Clothes
    case "bde_scarf": {
        if(_actionNo == 0)then{
            //[player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["H_Bandanna_gry",_cargoType] call _addItemCargo;
            cutText ["made bandanna", "PLAIN DOWN"];
        };
        if(_actionNo == 1)then{
            //[player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["G_Bandanna_blk",_cargoType] call _addItemCargo;
            cutText ["made bandanna mask", "PLAIN DOWN"];
        };
    };
    case "H_Bandanna_gry": {
        if(_actionNo == 0)then{
            //[player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_scarf",_cargoType] call _addItemCargo;
            cutText ["made scarf", "PLAIN DOWN"];
        };
    };
    case "G_Bandanna_blk": {
        if(_actionNo == 0)then{
            //[player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
            sleep 1;
            [_classname,_cargoType] call _removeItemCargo;
            ["bde_scarf",_cargoType] call _addItemCargo;
            cutText ["made scarf", "PLAIN DOWN"];
        };
    };

    default {};
};

if(_actionName == "eat") then {
    nextHungerDecr = t + hungerWaitTime;
};

if(_actionName == "drink") then {
    nextThirstDecr = t + thirstWaitTime;
};

if(_classname == "bde_vitamines" || _classname == "bde_antibiotics") then {
    nextHealthDecr = t + healthWaitTime;
};
