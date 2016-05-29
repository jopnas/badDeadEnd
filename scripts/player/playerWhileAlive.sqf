// GUI
updateUI   			= compile preprocessFile "scripts\player\playerUpdateUI.sqf";
checkNoise 			= compile preprocessFile "scripts\player\playerNoiseCheck.sqf";
handleWet 			= compile preprocessFile "scripts\player\playerWetHandler.sqf";
handleTemperature 	= compile preprocessFile "scripts\player\playerTemperatureHandler.sqf";
checkInside			= compile preprocessFile "scripts\tools\checkInside.sqf";
checkAnimals		= compile preprocessFile "scripts\animals\checkAnimals.sqf";
footFuncs			= compile preprocessFile "scripts\foot\foot_funcs.sqf";
checkSick			= compile preprocessFile "scripts\player\checkSick.sqf";

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
    _part   = _this select 0;
    _damage = _this select 1;
    _car    = _this select 2;
    _action = _this select 3;
    systemChat format["%1,%2,%3,%4",_part,_damage,_car,_action];
    
    _allineed = false;
    if(_part find "wheel" > -1 && "jii_tire" in Magazines Player)then{
        _allineed = true;
        player removeMagazine "jii_tire";
    };
    
    if(_part find "fuel" > -1 && "jii_ducttape" in Magazines Player)then{
        _allineed = true;
        player removeMagazine "jii_ducttape";
    };
    
    if(_allineed)then{
        player  say3D "toolSound0";
        sleep 3;
        _car setHit [_part, 0];
        player removeAction _action;
        repairActionIDs = repairActionIDs - [_action];
    };
};
//"HitEngine","HitFuel","HitLFWheel","HitLF2Wheel","HitRFWheel","HitRF2Wheel","HitRGlass","HitLGlass","HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitBody","HitLBWheel","HitLMWheel","HitRBWheel","HitRMWheel"
// Wood
nearestTree  			= [];

// Watersources
nearOpenWater           = false;
drinkActionAvailable    = false;

cannedFoodCooldownTime      = 120;
cannedFoodCooldownCountdown = 0;

eatCookedFoodAction = {
    player  say3D "eatSound0";
    sleep 1;
    playerHunger = playerHunger + (random(20)+30);
    playerTemperature = playerTemperature + 20;
    player removeMagazine "jii_canunknown";
    player addMagazine ["jii_emptycanunknown",1];
    _tastes =  ["salty","sweet","bitter","sour","flavorless"];
    cutText [format["ate somthing cooked %",_tastes call BIS_fnc_selectRandom], "PLAIN DOWN"];
};

_whileAliveFunc = [] spawn {
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

			if(_healthVal < 30)then{
				_sickSound = floor (round(random 1));
				[40] spawn checkNoise;
				player say3D format["sickSound%1",_sickSound];
				sleep random 5;
				_sickSound = floor (round(random 1));
				player say3D format["sickSound%1",_sickSound];
			};

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
            
            if((damage player) > 0)then{
                player setDamage ((damage player) - 0.001);
            };
		};

		waitUntil {time - t > 0.1};

		_cursorTarget = cursorTarget;
		_cursorTargetType = typeOf _cursorTarget;
		_closestBuilding = nearestBuilding player;
		_isInside = [_closestBuilding,player,false] call checkInside;
		_nearestFireplaces = nearestObjects [player, ["Land_FirePlace_F","Land_Campfire_F"], 3];

		[_isInside,_nearestFireplaces] spawn handleWet;
		[_isInside,_nearestFireplaces] spawn handleTemperature;

		[] spawn checkSick;
		[0] spawn checkNoise;
		[] spawn updateUI;
		[] spawn checkAnimals;

		nearestTree = [];
		// Everything in 2 meters around player
		_things = nearestObjects [player,[],5];
		{
			_obj = _x;
			// Tree Check
			if (str _x find ": t_" > -1) then {
				nearestTree = [_obj];
				//systemChat format ["%1 %2",str _obj,time];
			};

			//Debug
			//systemChat str nearTree;
		} forEach _things;

		// Fireplace Check
		if(_cursorTargetType == "Land_FirePlace_F" && inflamed _cursorTarget) then {
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
        
        _nearestCars    = player nearEntities [["Car"], 4];
        _nearestCarObj  = _nearestCars select 0;
        if("ToolKit" in Items Player && count (_nearestCars) > 0)then{
            _carDamages = getAllHitPointsDamage _nearestCarObj;
            {
                _i = _forEachIndex;
                _carDamageName  = (_carDamages select 1) select _i;
                _carDamageValue = (_carDamages select 2) select _i;
                _carDamageName2 = (_carDamages select 0) select _i;
               
                if(_carDamageName != "" && _carDamageValue > 0 && repairableParts find _carDamageName < 0)then{
                    repairableParts = repairableParts + [_carDamageName];
  
                    
                    switch (_i) do {
                        default { // = 0
                            repair00 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair00];
                        };                        
                        case 1: { 
                            repair01 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair01];
                        };
                        case 2: { 
                            repair02 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair02];
                        };
                        case 3: { 
                            repair03 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair03];
                        };
                        case 4: { 
                            repair04 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair04];
                        };
                        case 5: {
                            repair05 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair05];
                        };
                        case 6: { 
                            repair06 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair06];
                        };
                        case 7: {
                            repair07 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair07];
                        };
                        case 8: {
                            repair08 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair08];
                        };
                        case 9: {
                            repair09 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair09];
                        };
                        case 10: {
                            repair10 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair10];
                        };
                        case 11: {
                            repair11 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair11];
                        };
                        case 12: {
                            repair12 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair12];
                        };
                        case 13: {
                            repair13 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair13];
                        };
                        case 14: {
                            repair14 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair14];
                        };
                        case 15: {
                            repair15 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair15];
                        };
                        case 16: {
                            repair16 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair16];
                        };
                        case 17: {
                            repair17 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair17];
                        };
                        case 18: {
                            repair18 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
                            repairActionIDs = repairActionIDs + [repair18];
                        };
                        case 19: {
                            repair19 = player addAction[format["Repair %1",_carDamageName2],{
                                _params = _this select 3;
                                [_params select 0,_params select 1,_params select 2,_this select 2] spawn carRepair;
                            },[_carDamageName,_carDamageValue,_nearestCarObj]];
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
        systemChat str repairActionIDs;
        //systemChat str repairableParts;
        
        //systemChat format["playerHunger: %1, playerThirst: %2, playerHealth: %3, playerTemperature: %4, playerNoise: %5, playerWet: %6, playerSick: %7, playerInfected: %8",playerHunger,playerThirst,playerHealth,playerTemperature,playerNoise,playerWet,playerSick,playerInfected];
       
        /*_playerDamageVals = "";
        _allHitpoints   = getAllHitPointsDamage player;
        {
            _i = _forEachIndex;
            _hitpointname   = _allHitpoints select 0;
            _hitpointvalue  = _allHitpoints select 2;
            _playerDamageVals =  format["%1; %2: %3 ",_playerDamageVals,_hitpointname select _i,_hitpointvalue select _i];
        }forEach(_allHitpoints select 0);
        
        systemChat _playerDamageVals;*/
    };
};
