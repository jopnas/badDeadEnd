_action = _this select 0;
_meatCount = _this select 1;

_fnc_boilWater = {
    player setUnitPos "MIDDLE";
    player say3D "boilSound0";
    sleep 3;
    player removeMagazine "jii_bottlefilled";
    player addMagazine ["jii_bottleclean",1];
    cutText ["boiled some water", "PLAIN DOWN"];
};

_fnc_cookCannedFood = {
    player setUnitPos "MIDDLE";
    player say3D "frySound0";
    sleep 3;
    cutText ["Cooked baked beans. Eat while it's hot", "PLAIN DOWN"];

    if(cookCannedFoodAvailable && !eatCookedFoodAvailable) then {
        cookCannedFoodAvailable = false;
        player removeAction cookCannedFoodAction;

        cannedFoodCooldownCountdown = time + cannedFoodCooldownTime;

        eatCookedFoodAction = player addAction["Eat cooked baked beans",{
            player playActionNow "PutDown";
            player  say3D "eatSound0";
            sleep 1;
            player removeMagazine "jii_bakedbeans";
            player addMagazine ["jii_emptycanunknown",1];
            cutText ["ate cooked baked beans", "PLAIN DOWN"];

            [30] spawn fnc_increaseHunger;
            [10] spawn fnc_increaseTemperature;
            eatCookedFoodAvailable = false;
            cannedFoodCooldownCountdown = 0;
            player removeAction eatCookedFoodAction;
        }];
        eatCookedFoodAvailable = true;
    };
};

_fnc_cookMeat = {
    player setUnitPos "MIDDLE";

	_meatSmallCount  		= {_x == "jii_meat_small"} count magazines player;
	_meatBigCount  			= {_x == "jii_meat_big"} count magazines player;

	for "_a" from 0 to _meatSmallCount step 1 do {
		player say3D "frySound0";
		sleep 3;
		player removeMagazine "jii_meat_big";
		player addMagazine ["jii_meat_big_cooked",1];
		cutText ["Cooked big peace of meat", "PLAIN DOWN"];
	};

	for "_b" from 0 to _meatBigCount step 1 do {
		player say3D "frySound0";
		sleep 3;
		player removeMagazine "jii_meat_small";
		player addMagazine ["jii_meat_small_cooked",1];
		cutText ["Cooked small peace of meat", "PLAIN DOWN"];
	};

};

switch(_action) do {
	case "boilWater":{
		[] spawn _fnc_boilWater;
	};
	case "cookCannedFood":{
		[] spawn _fnc_cookCannedFood;
	};
	case "cookMeat":{
		[] spawn _fnc_cookMeat;
	};
	default{};
};
