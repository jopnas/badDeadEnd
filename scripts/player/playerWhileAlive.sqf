// nützlich für ghost objects? https://community.bistudio.com/wiki/createSimpleObject
// https://community.bistudio.com/wiki/createSimpleObject/objects

// GUI
updateUI   			= compile preprocessFile "scripts\player\playerUpdateUI.sqf";
checkNoise 			= compile preprocessFile "scripts\player\playerNoiseCheck.sqf";
handleWet 			= compile preprocessFile "scripts\player\playerWetHandler.sqf";
handleTemperature 	= compile preprocessFile "scripts\player\playerTemperatureHandler.sqf";
checkBoundingBox    = compile preprocessFile "scripts\tools\checkBoundingBox.sqf";
checkAnimals		= compile preprocessFile "scripts\animals\checkAnimals.sqf";
gutAnimal		    = compile preprocessFile "scripts\animals\gutAnimal.sqf";
foodFuncs			= compile preprocessFile "scripts\food\food_funcs.sqf";
checkSick			= compile preprocessFile "scripts\player\checkSick.sqf";

nextHazardCheck     = 0;
hazards			    = compile preprocessFile "scripts\anomaly\biohazard.sqf";

nextEverySecond     = 0;
nextEveryHalfSecond = 0;

barricadeWoodElements       = ["Land_Pallet_vertical_F","Land_Shoot_House_Wall_F","Land_Shoot_House_Wall_Stand_F","Land_Shoot_House_Wall_Crouch_F","Land_Shoot_House_Wall_Prone_F","Land_Shoot_House_Wall_Long_F","Land_Shoot_House_Wall_Long_Stand_F","Land_Shoot_House_Wall_Long_Crouch_F","Land_Shoot_House_Wall_Long_Prone_F"];
barricadeSandElements       = ["Land_BagFence_Corner_F","Land_BagFence_End_F","Land_BagFence_Long_F","Land_BagFence_Round_F","Land_BagFence_Short_Fm"];
barricadeDefenceElements    = ["Land_Razorwire_F"];
barricadeAllElements        = barricadeWoodElements + barricadeSandElements + barricadeDefenceElements;

changeBarricadeNext     = -1;
changeBarricadePrev     = -1;
raiseBarricade          = -1;
lowerBarricade          = -1;
releaseBarricade        = -1;
cancleBarricading       = -1;
resetHeightBarricade    = -1;
barricade               = player;
barricadeHeight         = 1;
barricadeElementIndex   = 0;
actionBarricadeActive   = false;

isInside                = false;

// current GUI blink status
guiBlink            = false;

hungerWaitTime      = 10;
nextHungerDecr      = hungerWaitTime;

thirstWaitTime      = 20;
nextThirstDecr      = thirstWaitTime;

healthWaitTime      = 30;
nextHealthDecr      = healthWaitTime;

// Gut Animal
gutAnimalActionAvailable = false;

// Cook & Boil
boilWaterAvailable      = false;
cookCannedFoodAvailable = false;
cookMeatAvailable  		= false;
eatCookedFoodAvailable  = false;

// Wood
chopWoodActionAvailable = false;
chopWood = {
    _theTree = _this select 0;
    _theTreePos = getPosATL _theTree;
    player playActionNow "Medic";
    [player,"buildSound0",500,1] remoteExec ["bde_fnc_say3d",0,false];
    sleep 5;
    _theTree setDamage 1;
    sleep 2;
    _woodHolder = createVehicle ["groundWeaponHolder",_theTreePos,[],0,"can_collide"];

    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addMagazineCargoGlobal ["bde_wood",1];

    cutText ["choped wood", "PLAIN DOWN"];
};

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
    player removeMagazine "bde_canunknown";

    _pPos     = getPos player;
    _trashPos = [_pPos select 0,_pPos select 1,(_pPos select 2) + 1];
    _wph = "groundWeaponHolder" createVehicle _trashPos;
    _wph setDir round(random 360);
    _wph setVehiclePosition [_trashPos, [], 0, ""];
    _wph addMagazineCargoGlobal ["bde_emptycanunknown", 1];

    _tastes =  ["salty","sweet","bitter","sour","flavorless"];
    cutText [format["ate somthing cooked %1",selectRandom _tastes], "PLAIN DOWN"];
};

/*player addEventHandler ["Take", {
    // _unit: Object - Unit to which the event handler is assigned
    // _container: Object - The container from which the item was taken (vehicle, box, etc.)
    // _item: String - The class name of the taken item
    params["_unit","_container","_item"];
    systemChat format["Take/_item: %1, _container: %2",_item,typeof _container];
}];*/

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

    _dist       = round((_aud/_sil) * 30 );

    [_unit,getPos _unit,_dist] remoteExec ["bde_fnc_receivePlayersNoise",2,false];
    systemChat format["shot noise range: %1",_dist];
}];

while{true}do{
	t=time;
    "dog 0" setMarkerPos getPos (player getVariable "playersDog");

    //_speed              = speed (vehicle player);

    //_carryingMass       = loadAbs player;
    //_calcFatigue        = _carryingMass / 500;
    //player setFatigue _calcFatigue;

    _rainIsAcid         = false;
    _cursorObject       = cursorObject;
    _cursorObjectType   = typeOf _cursorObject;

    _closestBuilding    = nearestBuilding player;
    isInside           = [_closestBuilding,player,false,false] call checkBoundingBox;
    _isInCar            = (vehicle player != player);
    _isUnderCover       = [player] call bde_fnc_underCover;

	if(t > nextHungerDecr)then{
		// Hunger
		_hungerVal = playerHunger;
		if(_hungerVal > 0)then{
			playerHunger = _hungerVal - 1;
		}else{
			playerHunger = 0;
		};
		nextHungerDecr = t + hungerWaitTime;
	};

	if(t > nextThirstDecr)then{
		// Thirst
		_thirstVal = playerThirst;
		if(_thirstVal > 0)then{
			playerThirst = _thirstVal - 1;
		}else{
			playerThirst = 0;
		};
		nextThirstDecr = t + thirstWaitTime;
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

		nextHealthDecr = t + healthWaitTime;
	};

    if(t > 2)then{
        [] spawn checkNoise;
        [] spawn checkAnimals;
    };
    if(t > 5)then{
        [] spawn checkSick;
        [getPos player] remoteExec ["fnc_spawnLoot",2,false];
    };

    if(t > nextEveryHalfSecond)then{
        [] spawn updateUI;
        nextEveryHalfSecond = t + 0.5;
    };

    if(t > nextEverySecond)then{
        [player,[playerHunger,playerThirst,playerHealth,playerTemperature,playerWet,playerSick,playerInfected]] remoteExec ["fnc_savePlayerStats",2,false];
        nextEverySecond = t + 1;
    };

    if(t > nextHazardCheck)then {
        _rainIsAcid = player getVariable ["rainIsAcid",false];
        [_isUnderCover,_isInCar,_rainIsAcid] call hazards;
        nextHazardCheck = t + 5;
    };

	_nearestFireplaces  = nearestObjects [player, ["Land_FirePlace_F","Land_Campfire_F"], 3];
    _inflamedFireplaces = [];
    {
        if(inflamed _x)then{
            _inflamedFireplaces pushBack _x;
        };
    } forEach _nearestFireplaces;

	[_isUnderCover,isInside,_isInCar,_inflamedFireplaces] spawn handleWet;
	[_isUnderCover,isInside,_isInCar,_inflamedFireplaces] spawn handleTemperature;

	// Everything in 2 meters around player
	/*_things = nearestObjects [player,[],5];   //!DON'T NEED IT AT MOMENT!
	{
		_obj = _x;
		// Tree Check
		if (str _x find ": t_" > -1) then {
			nearestTree = [_obj];
		};
	} forEach _things;*/

    // Gut Animals
    if( _cursorObject distance2D player < 3 &&
        _cursorObjectType in ["Rabbit_F","Goat_random_F","Sheep_random_F","Hen_random_F","Cock_random_F"] &&
        !(alive _cursorObject) &&
        _cursorObject getVariable["animalHasLoot",0] == 0)then{
        if(!gutAnimalActionAvailable)then{
            gutAnimalAction = player addAction["Gut Animal",{
                [_this select 3] call gutAnimal;
            },_cursorObject,6,true,true,"",""];
            gutAnimalActionAvailable = true;
        };
    }else{
        if(gutAnimalActionAvailable)then{
            gutAnimalActionAvailable = false;
            player removeAction gutAnimalAction;
        };
    };

    if(_cursorObject distance2D player < 3 && "bde_hatchet" in magazines player && str (_cursorObject) find ": t_" > -1)then{
        if(!chopWoodActionAvailable)then{
            chopWoodAction = player addAction["chop wood",{
                [_this select 3] call chopWood;
            },_cursorObject,6,true,true,"",""];
            chopWoodActionAvailable = true;
        };
    }else{
        if(chopWoodActionAvailable)then{
            chopWoodActionAvailable = false;
            player removeAction chopWoodAction;
        };
    };

    if(_cursorObject distance2D player < 3 && str (getModelInfo _cursorObject) find "watertank" > -1 || str (getModelInfo _cursorObject) find "waterbarrel" > -1 || str (getModelInfo _cursorObject) find "barrelwater" > -1 || str (getModelInfo _cursorObject) find "stallwater" > -1 || str (getModelInfo _cursorObject) find "watersource" > -1)then{
        if(!drinkActionAvailable)then{
            drinkAction = player addAction["drink clean water",{
                [] call drinkWater;
            },_cursorObject,6,true,true,"",""];
            drinkActionAvailable = true;
        };
    }else{
        if(drinkActionAvailable)then{
            drinkActionAvailable = false;
            player removeAction drinkAction;
        };
    };

	// Fireplace Check
	if(inflamed _cursorObject) then {
		_emptyPastaCanCount     = {_x == "bde_emptycanpasta"} count magazines player;
		_emptyUnknownCanCount   = {_x == "bde_emptycanunknown"} count magazines player;
		_emptyCanCount 			= _emptyPastaCanCount + _emptyUnknownCanCount;

		_bottlefilledCount  	= {_x == "bde_bottlefilled"} count magazines player;

		_canBeansCount  		= {_x == "bde_bakedbeans"} count magazines player;
		_canUnknownCount  		= {_x == "bde_canunknown"} count magazines player;
		_canPastaCount  		= {_x == "bde_canpasta"} count magazines player;
		_canCount				= _canBeansCount + _canUnknownCount + _canPastaCount;

		_meatSmallCount  		= {_x == "bde_meat_small"} count magazines player;
		_meatBigCount  			= {_x == "bde_meat_big"} count magazines player;
		_meatCount				= _meatSmallCount + _meatBigCount;

		if(!boilWaterAvailable && _emptyCanCount > 0 && _bottlefilledCount > 0) then {
			boilWaterAction = player addAction["Boil water",{
				["boilWater"] call foodFuncs;
			}];
			boilWaterAvailable = true;
		};
		if(!cookCannedFoodAvailable && cannedFoodCooldownCountdown == 0 && _canCount > 0) then {
			cookCannedFoodAction = player addAction["Cook baked beans",{
				["cookCannedFood"] call foodFuncs;
			}];
			cookCannedFoodAvailable = true;
		};
		if(!cookMeatAvailable && _meatCount > 0) then {
			cookMeatAction = player addAction["Cook meat",{
				["cookMeat"] call foodFuncs;
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

    if(isInside && !actionBarricadeActive)then{
        actionBarricadeActive = true;
        barricadeAction = player addAction["Create Barricade Element",{
            _caller     = _this select 1;

            player removeAction barricadeAction;

            barricade = createVehicle [barricadeAllElements select barricadeElementIndex,position player,[],0,"can_collide"];
            barricade enableSimulation false;
            barricade setDir (getDir player);
            barricade attachTo [player, [0,2,barricadeHeight]];

            changeBarricadeNext = player addAction ["Next Barricade Element", {
                deleteVehicle barricade;

                if(barricadeElementIndex + 1 == count barricadeAllElements)then{
                    barricadeElementIndex = 0;
                }else{
                    barricadeElementIndex = barricadeElementIndex + 1;
                };

                barricade = createVehicle [barricadeAllElements select barricadeElementIndex,position player,[],0,"can_collide"];
                barricade enableSimulation false;
                barricade setDir (getDir player);
                barricade attachTo [player, [0,2,barricadeHeight]];

            },"",1,true,false,"",""];

            changeBarricadePrev = player addAction ["Previous Barricade Element", {
                deleteVehicle barricade;

                if(barricadeElementIndex == 0)then{
                    barricadeElementIndex = count barricadeAllElements - 1;
                }else{
                    barricadeElementIndex = barricadeElementIndex - 1;
                };

                barricade = createVehicle [barricadeAllElements select barricadeElementIndex,position player,[],0,"can_collide"];
                barricade enableSimulation false;
                barricade setDir (getDir player);
                barricade attachTo [player, [0,2,barricadeHeight]];

            },"",1,true,false,"",""];

            raiseBarricade = player addAction ["Raise Barricade", {
                _curPos = getPosATL barricade;
                barricadeHeight = barricadeHeight + 0.1;
                barricade attachTo [player, [0,2,barricadeHeight]];
            },"",0,true,false,"",""];

            lowerBarricade = player addAction ["Lower Barricade", {
                _curPos = getPosATL barricade;
                barricadeHeight = barricadeHeight - 0.1;
                barricade attachTo [player, [0,2,barricadeHeight]];
            },"",0,true,false,"",""];

            resetHeightBarricade = player addAction ["Reset Barricade Height", {
                barricadeHeight = 0;
            },"",0,true,false,"",""];

            cancleBarricading = player addAction ["Cancle Barricading", {
                player removeAction changeBarricadePrev;
                player removeAction changeBarricadeNext;
                player removeAction raiseBarricade;
                player removeAction lowerBarricade;
                player removeAction resetHeightBarricade;
                player removeAction cancleBarricading;
                player removeAction releaseBarricade;
                deleteVehicle barricade;
                barricade             = player;
                actionBarricadeActive = false;
            },"",0,true,false,"",""];

            releaseBarricade = player addAction ["Release Barricade", {

                _barricadePos   = getPosATL barricade;
                _barricadeID    = format["%1%2",getPlayerUID player,floor(_barricadePos select 0),floor(_barricadePos select 1),floor(_barricadePos select 2)];
                barricade setVariable["barricadeID",_barricadeID,true];
                barricade setVariable["health",1000,true];
                [barricade] remoteExec ["fnc_saveBarricade",2,false];

                barricade addAction ["Destroy Barricade", {
                    sleep 0.5;
                    [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
                    deleteVehicle (_this select 0);
                },_barricadeID,0,true,true,"","",3];
                player removeAction changeBarricadePrev;
                player removeAction changeBarricadeNext;
                player removeAction raiseBarricade;
                player removeAction lowerBarricade;
                player removeAction resetHeightBarricade;
                player removeAction cancleBarricading;
                player removeAction releaseBarricade;
                detach barricade;
                barricade             = player;
                actionBarricadeActive = false;

            },"",0,true,false,"",""];

        },"",1,false,false,""];
    };

    if(!isInside && actionBarricadeActive)then{
        if((typeOf barricade) in barricadeAllElements)then{
            deleteVehicle barricade;
            barricade = player;
        };
        player removeAction changeBarricadePrev;
        player removeAction changeBarricadeNext;
        player removeAction barricadeAction;
        player removeAction raiseBarricade;
        player removeAction lowerBarricade;
        player removeAction resetHeightBarricade;
        player removeAction cancleBarricading;
        player removeAction releaseBarricade;
        actionBarricadeActive = false;
    };

    hint format["_cursorObjectType: %1\ngetModelInfo: %2\n_rainIsAcid: %3",_cursorObjectType,getModelInfo _cursorObject,_rainIsAcid];
};
