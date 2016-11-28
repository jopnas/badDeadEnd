params["_playerUnit","_isRespawn"];

// nützlich für ghost objects? https://community.bistudio.com/wiki/createSimpleObject
// https://community.bistudio.com/wiki/createSimpleObject/objects

// Compiles
updateUI   			= compile preprocessFile "scripts\player\playerUpdateUI.sqf";
//checkNoise 		= compile preprocessFile "scripts\player\playerNoiseCheck.sqf";
handleWet 			= compile preprocessFile "scripts\player\playerWetHandler.sqf";
handlePoisoning	    = compile preprocessFile "scripts\player\playerPoisoning.sqf";
handleRadiation	    = compile preprocessFile "scripts\player\playerRadiation.sqf";
handleTemperature 	= compile preprocessFile "scripts\player\playerTemperatureHandler.sqf";
checkSick			= compile preprocessFile "scripts\player\checkSick.sqf";
checkBoundingBox    = compile preprocessFile "scripts\tools\checkBoundingBox.sqf";
checkAnimals		= compile preprocessFile "scripts\animals\checkAnimals.sqf";
canLock		        = compile preprocessFile "scripts\barricade\canLock.sqf";
foodFuncs			= compile preprocessFile "scripts\food\food_funcs.sqf";

// Player Variables
playerHunger           = player getVariable ["playerHunger",100];
playerThirst           = player getVariable ["playerThirst",100];
playerHealth           = player getVariable ["playerHealth",100];
playerTemperature      = player getVariable ["playerTemperature",100];
playerWet              = player getVariable ["playerWet",0];
playerSick             = player getVariable ["playerSick",0];
playerInfected         = player getVariable ["playerInfected",0];
playerPoisoning        = player getVariable ["playerPoisoning",0];
playerRadiation        = player getVariable ["playerRadiation",0];

closeToDoor = false;

acidRain            = false;

nextEverySecond     = 0;
//nextEveryHalfSecond = 0;

barricade = objNull;

//https://community.bistudio.com/wiki/BIS_fnc_isInsideArea
isInside                = false;

// current GUI blink status
guiBlink            = false;

hungerWaitTime      = 10;
nextHungerDecr      = hungerWaitTime;

thirstWaitTime      = 20;
nextThirstDecr      = thirstWaitTime;

healthWaitTime      = 30;
nextHealthDecr      = healthWaitTime;

// Cook & Boil
boilWaterAvailable      = false;
cookCannedFoodAvailable = false;
cookMeatAvailable  		= false;
eatCookedFoodAvailable  = false;

// Wood
chopWood = {
    _theTree = _this select 0;
    _theTreePos = getPosATL _theTree;
    player playActionNow "Medic";
    [player,"buildSound0",500,1] remoteExec ["bde_fnc_say3d",0,false];
    sleep 5;
    _theTree setDamage 1;
    sleep 2;
    _woodHolder = createVehicle ["groundWeaponHolder",_theTreePos,[],0,"can_collide"];

    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    sleep 2;
    _woodHolder addItemCargoGlobal ["bde_wood",1];
    hideObjectGlobal _theTree;

    cutText ["tree felled", "PLAIN DOWN"];
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
/*player addEventHandler ["Fired", {
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
    //systemChat format["shot noise range: %1",_dist];
}];*/

player addEventHandler ["Fired", {
    private["_unit","_audible","_caliber","_distance","_sil"];
    _unit       = _this select 0; // Object - Object the event handler is assigned to
    _weapon     = _this select 1; // String - Fired weapon
    _muzzle     = _this select 2; // String - Muzzle that was used
    _mode       = _this select 3; // String - Current mode of the fired weapon
    _ammo       = _this select 4; // String - Ammo used
    _magazine   = _this select 5; // String - magazine name which was used
    _projectile = _this select 6; // Object - Object of the projectile that was shot

    systemChat format["ammo: %1",_ammo];

    if (_ammo isKindOf "bde_melee_ammo") exitWith {
    	_unit playActionNow "GestureSwing";
    };
}];

// Hide Weapons
player addAction["Holster Weapon",{
    player action["SwitchWeapon",player,player,100];
    player switchCamera cameraView;
},[],0,false,false,"","currentWeapon player != ''"];

// Start Barricade
barricadeStartAction = player addAction["Create Barricade","scripts\barricade\fnc_startBarricde.sqf",[],0,false,false,"","isInside && (barricade isEqualTo objNull) && ({_x == 'bde_nails'} count magazines player) >= 2 && ('bde_hammer' in (magazines player)) && ('bde_plank' in (magazines player))"];

player addAction ["Attach Window Barricade", {
    _barricadePos   = getPosATL barricade;
    _barricadeID    = format["%1%2",getPlayerUID player,floor(_barricadePos select 0),floor(_barricadePos select 1),floor(_barricadePos select 2)];
    barricade setVariable["barricadeID",_barricadeID,true];
    barricade setVariable["health",1000,true];
    barricade setVariable["barricadePosition",_barricadePos,true];
    [barricade] remoteExec ["fnc_saveBarricade",2,false];

    player removeItem "bde_plank";
    player removeItem "bde_nails";
    player removeItem "bde_nails";

    barricade addAction ["Destroy Barricade", {
        sleep 0.5;
        [_this select 3] remoteExec ["fnc_deleteBarricade",2,false];
        deleteVehicle (_this select 0);
    },[],5,true,true,"","",3];

    barricade addAction ["Upgrade Window Barricade","scripts\barricade\fnc_upgradeBarricade.sqf", [], 6, false, false, "", "isInside && (barricade isEqualTo objNull) && ({_x == 'bde_nails'} count magazines player) >= 2 && ('bde_hammer' in (magazines player)) && ('bde_plank' in (magazines player))", 3, false];
    barricade             = objNull;

}, [], 6, false, false, "", "typeOf barricade == 'bde_barricade_win_one'", 10, false];

//Lock Door
player addAction["Attach Codelock","scripts\barricade\fnc_attachLock.sqf",[],0,false,false,"","closeToDoor && !(doorHasLock)"];
player addAction["Use Codelock","scripts\barricade\fnc_lockdoor.sqf",[],0,false,false,"","closeToDoor && doorHasLock"];

// Gut Animal
player addAction["Gut Animal","scripts\animals\gutAnimal.sqf",[],6,true,true,"","(cursorObject isKindOf 'Animal') && ('bde_multitool_knife' in magazines player) && (player distance cursorObject < 2) && !(alive cursorObject)"];

// Chop Wood
player addAction["chop wood",{
    [cursorObject] call chopWood;
},[],6,true,true,"","('bde_hatchet' in magazines player) && (str (cursorObject) find ': t_' > -1) && (player distance2d cursorObject < 3)"];

// Drink Water
player addAction["drink clean water",{
    [] call drinkWater;
},_cursorObject,6,true,true,"","(cursorObject distance player < 2) && (str (getModelInfo cursorObject) find 'watertank' > -1 || str (getModelInfo cursorObject) find 'waterbarrel' > -1 || str (getModelInfo cursorObject) find 'barrelwater' > -1 || str (getModelInfo cursorObject) find 'stallwater' > -1 || str (getModelInfo cursorObject) find 'water_source' > -1)"];

//endLoadingScreen;

// Player Init Situation
if(_isRespawn)then{
	playSound "feeepSound0";
    addCamShake [10, 10, 50];
};
5 fadeSound 3;
5 fadeMusic 3;
cutText ["Welcome to BadDeadEnd ...", "BLACK IN", 5];

while{true}do{
	t=time;
    //"dog 0" setMarkerPos getPos (player getVariable "playersDog");

    //_speed              = speed (vehicle player);

    //_carryingMass       = loadAbs player;
    //_calcFatigue        = _carryingMass / 500;
    //player setFatigue _calcFatigue;

    _cursorObject       = cursorObject;
    _cursorObjectType   = typeOf _cursorObject;

    _closestBuilding    = nearestBuilding player;
    isInside            = [_closestBuilding,player,false,false] call checkBoundingBox;
    _isInCar            = (vehicle player != player);
    _isUnderCover       = [player] call bde_fnc_underCover;
    _isInShadow         = [player] call llw_fnc_inShadow;
    _sunRadiation       = [player] call llw_fnc_getSunRadiation;

    // If Barricading
    _camBarricadeIntersect       = lineIntersectsSurfaces [AGLToASL positionCameraToWorld [0,0,0], AGLToASL positionCameraToWorld [0,0,20], player, barricade, true, 1, "GEOM", "NONE"];
    if( !(barricade isEqualTo objNull) )then{
        {
            if( _x select 2 == _closestBuilding && !(barricade isEqualTo objNull) )exitWith{
                _infPos = ASLToATL (_x select 0);
                barricade setPosATL _infPos;
                barricade setVectorDir (_x select 1);
            };
        }forEach _camBarricadeIntersect;
    };


    if(isInside)then{
        closeToDoor = ([_closestBuilding] call canLock) select 1;
        if(_closestBuilding getVariable[format["bde_%1_has_lock",([_closestBuilding] call canLock) select 0],false])then{
            doorHasLock = true;
        }else{
            doorHasLock = false;
        };
    }else{
        closeToDoor = false;
        doorHasLock = false;
    };

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
        //[] call checkNoise;
        [_isUnderCover,_isInCar] call handlePoisoning;
        [_isInCar,_isInShadow,_sunRadiation] call handleRadiation;
        [] call checkAnimals;
    };
    if(t > 5)then{
        [] call checkSick;
        [getPos player] remoteExec ["fnc_spawnLoot",2,false];
    };

    /*if(t > nextEveryHalfSecond)then{
        [] call updateUI;
        nextEveryHalfSecond = t + 0.5;
    };*/

    if(t > nextEverySecond)then{
        [player,[playerHunger,playerThirst,playerHealth,playerTemperature,playerWet,playerSick,playerInfected,playerPoisoning,playerRadiation]] remoteExec ["fnc_savePlayerStats",2,false];
        [] call updateUI;
        nextEverySecond = t + 1;
    };

	_nearestFireplaces  = nearestObjects [player, ["Land_FirePlace_F","Land_Campfire_F"], 3];
    _inflamedFireplaces = [];
    {
        if(inflamed _x)then{
            _inflamedFireplaces pushBack _x;
        };
    } forEach _nearestFireplaces;

	[_isUnderCover,isInside,_isInCar,_inflamedFireplaces,_isInShadow,_sunRadiation] spawn handleWet;
	[_isUnderCover,isInside,_isInCar,_inflamedFireplaces,_isInShadow,_sunRadiation] spawn handleTemperature;

	// Everything in 2 meters around player
	/*_things = nearestObjects [player,[],5];   //!DON'T NEED IT AT MOMENT!
	{
		_obj = _x;
		// Tree Check
		if (str _x find ": t_" > -1) then {
			nearestTree = [_obj];
		};
	} forEach _things;*/

    /*if(_cursorObject distance player < 2 && (str (getModelInfo _cursorObject) find "watertank" > -1 || str (getModelInfo _cursorObject) find "waterbarrel" > -1 || str (getModelInfo _cursorObject) find "barrelwater" > -1 || str (getModelInfo _cursorObject) find "stallwater" > -1 || str (getModelInfo _cursorObject) find "water_source" > -1) )then{
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
    };*/

	// Fireplace Check
	if(inflamed _cursorObject) then {
		_emptyPastaCanCount     = {_x == "bde_emptycanpasta"} count magazines player;
		_emptyUnknownCanCount   = {_x == "bde_emptycanunknown"} count magazines player;
		_emptyCanCount 			= _emptyPastaCanCount + _emptyUnknownCanCount;

		_bottlefilledCount  	= {_x == "bde_bottledirty"} count magazines player;

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

    //hint format["_cursorObjectType: %1\ngetModelInfo: %2",_cursorObjectType,getModelInfo _cursorObject];
    hintsilent (
            "playerPoisoning:" + (str playerPoisoning)
            + "\nacidRain:" + (str acidRain)
            + "\n\n" + ([] call llw_fnc_getDateTime)
            + "\nSolar radiation: " + str _sunRadiation + " W/m²"
            + "\nAir: " + str ([] call llw_fnc_getTemperature select 0) +"°C"
            + "\nSea: " + str ([] call llw_fnc_getTemperature select 1) +"°C"
            + "\nPlayer in shadow: " + str _isInShadow
            + "\ncursor object: " + str cursorobject
            + "\ncursor object class: " + typeOf cursorobject
            + "\n\nTry fiddling with time, date, overcast, and fog."
    );
};
