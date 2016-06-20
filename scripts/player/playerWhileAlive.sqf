// GUI
updateUI   			= compile preprocessFile "scripts\player\playerUpdateUI.sqf";
checkNoise 			= compile preprocessFile "scripts\player\playerNoiseCheck.sqf";
handleWet 			= compile preprocessFile "scripts\player\playerWetHandler.sqf";
handleTemperature 	= compile preprocessFile "scripts\player\playerTemperatureHandler.sqf";
checkBoundingBox    = compile preprocessFile "scripts\tools\checkBoundingBox.sqf";
checkAnimals		= compile preprocessFile "scripts\animals\checkAnimals.sqf";
footFuncs			= compile preprocessFile "scripts\foot\foot_funcs.sqf";
checkSick			= compile preprocessFile "scripts\player\checkSick.sqf";
//getBarricadeables	= compile preprocessFile "scripts\barricading\getBarricadeables.sqf";

hungerWaitTime = 10;
nextHungerDecr = hungerWaitTime;

thirstWaitTime = 20;
nextThirstDecr = thirstWaitTime;

healthWaitTime = 30;
nextHealthDecr = healthWaitTime;

// Cook & Boil
boilWaterAvailable      = false;
cookCannedFoodAvailable = false;
cookMeatAvailable  		= false;
eatCookedFoodAvailable  = false;

// Repair
repairableParts         = [];
repairActionIDs         = [];
carRepair = {
    _partName   = _this select 0;
    _damage     = _this select 1;
    _car        = _this select 2;
    _part       = _this select 3;
    _action     = _this select 4;

    _allineed = false;
    if(_partName find "Wheel" > -1 && "jii_tire" in Magazines Player)then{
        _allineed = true;
        player removeMagazine "jii_tire";
    };

    if(_partName find "Fuel" > -1 && "jii_ducttape" in Magazines Player)then{
        _allineed = true;
        player removeMagazine "jii_ducttape";
    };

    if(_allineed)then{
        player  say3D (selectRandom ["toolSound0","toolSound1"]);
        sleep 11;
        _car setHit [_part, 0];
        player removeAction _action;
        repairActionIDs = repairActionIDs - [_action];
    };
};
// Wood
nearestTree  			= [];

// Watersources
nearOpenWater           = false;
drinkActionAvailable    = false;
drinkWater = {
    player playActionNow "PutDown";
    player say3D "drinkSound0";
    sleep 2;
    playerThirst = playerThirst + 10;
};

cannedFoodCooldownTime      = 120;
cannedFoodCooldownCountdown = 0;

eatCookedFoodAction = {
    player say3D "eatSound0";
    sleep 1;
    playerHunger = playerHunger + (random(20)+30);
    playerTemperature = playerTemperature + 20;
    player removeMagazine "jii_canunknown";

    _pPos     = getPos player;
    _trashPos = [_pPos select 0,_pPos select 1,(_pPos select 2) + 1];
    _wph = "groundWeaponHolder" createVehicle _trashPos;
    _wph setDir round(random 360);
    _wph setVehiclePosition [_trashPos, [], 0, "CAN_COLLIDE"];
    _wph addMagazineCargoGlobal ["jii_emptycanunknown", 1];

    _tastes =  ["salty","sweet","bitter","sour","flavorless"];
    cutText [format["ate somthing cooked %1",selectRandom _tastes], "PLAIN DOWN"];
};

// broadcast shot to zombie
player addEventHandler ["Fired", {
    private["_unit","_audible","_caliber","_distance","_sil"];
    _unit       = _this select 0; // Object - Object the event handler is assigned to
    _weapon     = _this select 1; // String - Fired weapon
    _muzzle     = _this select 2; // String - Muzzle that was used
    _mode       = _this select 3; // String - Current mode of the fired weapon
    _ammo       = _this select 4; // String - Ammo used
    _magazine   = _this select 5; // String - magazine name which was used
    _projectile = _this select 6; // Object - Object of the projectile that was shot

    _sil        = 1;

    if(_weapon == primaryWeapon _unit && str(primaryWeaponItems _unit) find "_snds_" > -1)then{
        _sil    = 3;
    };
    if(_weapon == secondaryWeapon _unit && str(secondaryWeaponItems _unit) find "_snds_" > -1)then{
        _sil    = 2;
    };
    if(_weapon == handgunWeapon _unit && str(handgunItems _unit) find "_snds_" > -1)then{
        _sil    = 4;
    };

    _aud        = getNumber (configFile >> "CfgAmmo" >> _ammo >> "audibleFire");
    //_cal        = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");

    _dist       = round((_aud/_sil) * 100 );

    {
        _zombie = _x;
        if(_unit distance _zombie < _dist)then{
            _zombie setVariable["lastPlayerHeard",getPos _unit,true];
        };
    }forEach (units groupZ);
}];


while{alive player && player getVariable["playerSetupReady",false]}do{
	t=time;

	if(t > nextHungerDecr)then{
		// Hunger
		_hungerVal = playerHunger;
		if(_hungerVal > 0)then{
			playerHunger = _hungerVal - 1;
		}else{
			playerHunger = 0;
		};
		nextHungerDecr = time + hungerWaitTime;
	};

	if(t > nextThirstDecr)then{
		// Thirst
		_thirstVal = playerThirst;
		if(_thirstVal > 0)then{
			playerThirst = _thirstVal - 1;
		}else{
			playerThirst = 0;
		};
		nextThirstDecr = time + thirstWaitTime;
	};

	if(t > nextHealthDecr)then{
		// Health
		_healthVal = playerHealth;
		_sickVal = playerSick;

		if(_healthVal > 0)then{
			playerHealth = _healthVal - 1;
		}else{
			playerHealth = 0;
		};

		nextHealthDecr = time + healthWaitTime;
	};

	if(t > 0.1)then{
		// Save Spawn Stats
        [player,[playerHunger,playerThirst,playerHealth,playerTemperature,playerWet,playerSick,playerInfected]] remoteExec ["fnc_savePlayerStats",2,false];
	};

	if(t > 5)then{
		// Spawn Loot
		[getPos player] remoteExec ["fnc_spawnLoot",2,false];
        systemChat str weaponCaliber;
	};

	waitUntil {time - t > 0.1};

    _cursorObject       = cursorObject;
	_cursorObjectType   = typeOf _cursorObject;

	_closestBuilding    = nearestBuilding player;
	_isInside           = [_closestBuilding,player,false,false] call checkBoundingBox;
    _isInCar            = (vehicle player != player);
    _isUnderCover       = [player] call bde_fnc_underCover;

	_nearestFireplaces  = nearestObjects [player, ["Land_FirePlace_F","Land_Campfire_F"], 3];
    _inflamedFireplaces = [];
    {
        if(inflamed _x)then{
            _inflamedFireplaces pushBack _inflamedFireplaces;
        };
    } forEach _nearestFireplaces;

	[_isUnderCover,_isInside,_isInCar,_inflamedFireplaces] spawn handleWet;
	[_isUnderCover,_isInside,_isInCar,_inflamedFireplaces] spawn handleTemperature;

    //[_isInside,_closestBuilding] call getBarricadeables;

	[] spawn checkSick;
	[] spawn checkNoise;
	[] spawn updateUI;
	[] spawn checkAnimals;

	// Everything in 2 meters around player
	/*_things = nearestObjects [player,[],5];   //!DON'T NEED IT AT MOMENT!
	{
		_obj = _x;
		// Tree Check
		if (str _x find ": t_" > -1) then {
			nearestTree = [_obj];
		};
	} forEach _things;*/

    nearestTree = [];
    if(str (getModelInfo _cursorObject) find ": t_" > -1)then{
        nearestTree = [_cursorObjectType];
    }else{
        nearestTree = [];
    };

    if(str (getModelInfo _cursorObject) find "watertank" > -1 || str (getModelInfo _cursorObject) find "waterbarrel" > -1 || str (getModelInfo _cursorObject) find "barrelwater" > -1 || str (getModelInfo _cursorObject) find "stallwater" > -1 || str (getModelInfo _cursorObject) find "watersource" > -1)then{
        if(!drinkActionAvailable)then{
            drinkAction = player addAction["drink clean water",{
                [] call drinkWater;
            }];
            drinkActionAvailable = true;
        }
    }else{
        if(drinkActionAvailable)then{
            drinkActionAvailable = false;
            player removeAction drinkAction;
        };
    };

	// Fireplace Check
	if(inflamed _cursorObject) then {
		_emptyPastaCanCount     = {_x == "jii_emptycanpasta"} count magazines player;
		_emptyUnknownCanCount   = {_x == "jii_emptycanunknown"} count magazines player;
		_emptyCanCount 			= _emptyPastaCanCount + _emptyUnknownCanCount;

		_bottlefilledCount  	= {_x == "jii_bottlefilled"} count magazines player;

		_canBeansCount  		= {_x == "jii_bakedbeans"} count magazines player;
		_canUnknownCount  		= {_x == "jii_canunknown"} count magazines player;
		_canPastaCount  		= {_x == "jii_canpasta"} count magazines player;
		_canCount				= _canBeansCount + _canUnknownCount + _canPastaCount;

		_meatSmallCount  		= {_x == "jii_meat_small"} count magazines player;
		_meatBigCount  			= {_x == "jii_meat_big"} count magazines player;
		_meatCount				= _meatSmallCount + _meatBigCount;

		if(!boilWaterAvailable && _emptyCanCount > 0 && _bottlefilledCount > 0) then {
			boilWaterAction = player addAction["Boil water",{
				["boilWater"] spawn footFuncs;
			}];
			boilWaterAvailable = true;
		};
		if(!cookCannedFoodAvailable && cannedFoodCooldownCountdown == 0 && _canCount > 0) then {
			cookCannedFoodAction = player addAction["Cook baked beans",{
				["cookCannedFood"] spawn footFuncs;
			}];
			cookCannedFoodAvailable = true;
		};
		if(!cookMeatAvailable && _meatCount > 0) then {
			cookMeatAction = player addAction["Cook meat",{
				["cookMeat"] spawn footFuncs;
			}];
			cookMeatAvailable = true;
		};
	}else{
        if(boilWaterAvailable) then {
            boilWaterAvailable = false;
            player removeAction boilWaterAction;
        };
		if(cookCannedFoodAvailable) then {
            cookCannedFoodAvailable = false;
            player removeAction cookCannedFoodAction;
        };
		if(cookMeatAvailable) then {
            cookMeatAvailable = false;
            player removeAction cookMeatAction;
        };
    };

    if(time > cannedFoodCooldownCountdown && eatCookedFoodAvailable) then {
        eatCookedFoodAvailable = false;
        cannedFoodCooldownCountdown = 0;
        player removeAction eatCookedFoodAction;
    };

    if("ToolKit" in Items Player && vehicle player == player && _cursorObject isKindOf "Car" && cursorObject distance player < 5)then{
        _nearestCarObj = _cursorObject;
        _carDamages = getAllHitPointsDamage _nearestCarObj;
        {
            _i = _forEachIndex;
            _carDamageName  = (_carDamages select 1) select _i;
            _carDamageValue = (_carDamages select 2) select _i;
            _carDamageName2 = (_carDamages select 0) select _i;

            _damagePercent  = 100 - floor(_carDamageValue*100);
            _actionText = "";
            if(_damagePercent >= 66)then{
                _actionText = format["<t color='#00FF00'>Repair %1: %2%3</t>",_carDamageName2,_damagePercent,"%"];
            };
            if(_damagePercent >= 33 && _damagePercent < 66 )then{
                _actionText = format["<t color='#FFFF00'>Repair %1: %2%3</t>",_carDamageName2,_damagePercent,"%"];
            };
            if(_damagePercent < 33 )then{
                _actionText = format["<t color='#FF0000'>Repair %1: %2%3</t>",_carDamageName2,_damagePercent,"%"];
            };

            if(_carDamageName != "" && _carDamageValue > 0 && repairableParts find _carDamageName < 0)then{
                repairableParts = repairableParts + [_carDamageName];

                switch (_i) do {
                    default { // = 0
                        repair00 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair00];
                    };
                    case 1: {
                        repair01 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair01];
                    };
                    case 2: {
                        repair02 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair02];
                    };
                    case 3: {
                        repair03 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair03];
                    };
                    case 4: {
                        repair04 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair04];
                    };
                    case 5: {
                        repair05 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair05];
                    };
                    case 6: {
                        repair06 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair06];
                    };
                    case 7: {
                        repair07 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair07];
                    };
                    case 8: {
                        repair08 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair08];
                    };
                    case 9: {
                        repair09 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair09];
                    };
                    case 10: {
                        repair10 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair10];
                    };
                    case 11: {
                        repair11 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair11];
                    };
                    case 12: {
                        repair12 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair12];
                    };
                    case 13: {
                        repair13 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair13];
                    };
                    case 14: {
                        repair14 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair14];
                    };
                    case 15: {
                        repair15 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair15];
                    };
                    case 16: {
                        repair16 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair16];
                    };
                    case 17: {
                        repair17 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair17];
                    };
                    case 18: {
                        repair18 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair18];
                    };
                    case 19: {
                        repair19 = player addAction[_actionText,{
                            _params = _this select 3;
                            [_params select 0,_params select 1,_params select 2,_params select 3,_this select 2] spawn carRepair;
                        },[_carDamageName2,_carDamageValue,_nearestCarObj,_carDamageName]];
                        repairActionIDs = repairActionIDs + [repair19];
                    };
                };
            };
        }forEach(_carDamages select 0);
    }else{
        if(count repairableParts > 0)then{
            repairableParts = [];
            {
                player removeAction _x;
                repairActionIDs = repairActionIDs - [_x];
            }forEach repairActionIDs;
        };
    };

    hint format["cursorObject: %1\ncursorObjectType: %2\nisUnderCover: %3",_cursorObject,_cursorObjectType,_isUnderCover];
};
