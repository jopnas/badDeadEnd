private["_idcData","_cargoType","_idc","_selectedIndex","_data","_text","_value","_pic","_buildFireplace","_needCountOfWood","_needCountOfStone","_magazinesDetail","_magazinesAmmoCargo"];
_idc            = _this select 0;
_selectedIndex  = _this select 1;

_data 	= lbData [_idc, _selectedIndex];
_text 	= lbText [_idc, _selectedIndex];
_value 	= lbValue [_idc, _selectedIndex];
_pic 	= lbPicture [_idc, _selectedIndex];

/*_magazinesDetail = magazinesDetail player;
{
    if(str _x find format["[id:%1]",_selectedIndex])then{
        systemChat format["ItemInfo: %1",_x];
    };
}forEach _magazinesDetail;*/
/* example result
[
	"6.5mm 30Rnd STANAG Mag(30/30)[id:3]",
	"6.5mm 30Rnd STANAG Mag(30/30)[id:9]",
	"9mm 16Rnd Mag(16/16)[id:12]",
	"Smoke Grenade (Green)(1/1)[id:14]",
	"Chemlight (Green)(1/1)[id:16]",
	"RGO Frag Grenade(1/1)[id:18]"
]*/

/*switch(_cargoType) do {
    case "Backpack": {
        _magazinesAmmoCargo = magazinesAmmoCargo backpackContainer player;
    };
    case "Vest": {
        _magazinesAmmoCargo = magazinesAmmoCargo vestContainer player;
    };
    case "Uniform": {
        _magazinesAmmoCargo = magazinesAmmoCargo uniformContainer player;
    };
    default {
    };
};*/
/* example result
[
    ["30Rnd_65x39_caseless_mag",30],
    ["30Rnd_65x39_caseless_mag",30],
    ["Chemlight_green",1]
]*/

// Functions
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

_buildFireplace = {
    private["_minWood","_minStone","_needCountOfWood","_needCountOfStone","_woodCount","_stoneCount"];
    _minWood = 2;
    _minStone = 4;
    _woodCount  = {_x == "jii_wood"} count magazines player;
    _stoneCount = {_x == "jii_stone"} count magazines player;
  if(_woodCount >= _minWood && _stoneCount >= _minStone)then{
    player playActionNow "Medic";
    //player say3D "buildSound0";
    [player,"buildSound0",300,1] remoteExec ["bde_fnc_say3d",0,false];
    sleep 5;
      for "_w" from 0 to _minWood step 1 do {
          player removeMagazine "jii_wood";
      };
      for "_s" from 0 to _minStone step 1 do {
          player removeMagazine "jii_stone";
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

_trashWph = "groundWeaponHolder" createVehicle getPos player;
_trashWph setDir round(random 360);
_trashWph setVehiclePosition [getPos _trashWph, [], 0, "CAN_COLLIDE"];

switch(_data) do {
    // Food
	case "jii_bottleuseless": {
        if("jii_ducttape" in Magazines Player)then{
        	player playActionNow "Medic";
			//player say3D "toolSound0";
            [player,"toolSound0",100,1] remoteExec ["bde_fnc_say3d",0,false];
	        sleep 1;
            player removeMagazine _data;
            ["jii_bottleempty",_cargoType] call _addItemCargo;
            //player addMagazine ["jii_bottleempty",1];
		    cutText ["fixed damaged bottle", "PLAIN DOWN"];
        }else{
            cutText ["need Ducttape to fix it", "PLAIN DOWN"];
        };
	};
	case "jii_bottleempty": {
		if(drinkActionAvailable)then{
        	player playActionNow "PutDown";
    	    //player say3D "fillSound0";
            [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
			player removeMagazine _data;
            ["jii_bottleclean",_cargoType] call _addItemCargo;
			//player addMagazine ["jii_bottleclean",1];
			cutText ["filled bottle with clean water", "PLAIN DOWN"];
		}else{
			if(nearOpenWater)then{
            	player playActionNow "PutDown";
        	    //player say3D "fillSound0";
                [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
        	    sleep 1;
			    player removeMagazine _data;
                ["jii_bottlefilled",_cargoType] call _addItemCargo;
                //player addMagazine ["jii_bottlefilled",1];
			    cutText ["filled bottle with dirty water", "PLAIN DOWN"];
			}else{
			    cutText ["not close to water source", "PLAIN DOWN"];
			};
		};
	};
	case "jii_bottlefilled": {
		if("jii_waterpurificationtablets" in Magazines player)then{
        	player playActionNow "Medic";
	        sleep 1;
			player removeMagazine _data;
			player removeMagazine "jii_waterpurificationtablets";
            ["jii_bottleclean",_cargoType] call _addItemCargo;
            //player addMagazine ["jii_bottleclean",1];
			cutText ["purified dirty water", "PLAIN DOWN"];
		}else{
			cutText ["need water purification tablets", "PLAIN DOWN"];
		};
	};
	case "jii_bottleclean": {
	    //player say3D "drinkSound0";
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 50;
		player removeMagazine _data;
        ["jii_bottleempty",_cargoType] call _addItemCargo;
        //player addMagazine ["jii_bottleempty",1];
		cutText ["drank clean water", "PLAIN DOWN"];
	};
	case "jii_canteenempty":  {
		if(drinkActionAvailable)then{
    	    //player say3D "fillSound0";
            [player,"fillSound0",20,1] remoteExec ["bde_fnc_say3d",0,false];
    	    sleep 1;
			player removeMagazine _data;
            ["jii_canteenfilled",_cargoType] call _addItemCargo;
            //player addMagazine ["jii_canteenfilled",1];
			cutText ["filled canteen with clean water", "PLAIN DOWN"];
		}else{
	        cutText ["not close to clean water source", "PLAIN DOWN"];
		};
	};
	case "jii_canteenfilled": {
	    //player say3D "drinkSound0";
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 30;
		player removeMagazine _data;
        ["jii_canteenempty",_cargoType] call _addItemCargo;
        //player addMagazine ["jii_canteenempty",1];
		cutText ["drank clean water", "PLAIN DOWN"];
	};
	case "jii_canrusty": {
	    //player say3D "drinkSound0";
        [player,"drinkSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerThirst = playerThirst + 10;
		player removeMagazine _data;
		_trashWph addMagazine ["jii_canempty",1];
		cutText ["drank can of Spirit", "PLAIN DOWN"];
	};

	case "jii_canunknown": {
	    //player  say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + (random(20)+20);
		player removeMagazine _data;
		_trashWph addMagazine ["jii_emptycanunknown",1];
		_tastes =  ["salty","sweet","bitter","sour","flavorless"];
		cutText [format["ate somthing %1",selectRandom _tastes], "PLAIN DOWN"];
	};
	case "jii_canpasta": {
	    //player  say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 20;
		player removeMagazine _data;
		_trashWph addMagazine ["jii_emptycanpasta",1];
		cutText ["ate pasta", "PLAIN DOWN"];
	};
	case "jii_bakedbeans": {
	    //player  say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 25;
		player removeMagazine _data;
		_trashWph addMagazine ["jii_emptycanunknown",1];
		cutText ["ate baked beans", "PLAIN DOWN"];
	};
	case "jii_tacticalbacon": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 15;
		player removeMagazine _data;
		_trashWph addMagazine ["jii_emptycanunknown",1];
		cutText ["ate tactical bacon", "PLAIN DOWN"];
	};

	case "jii_meat_big": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 30;
		playerHealth = playerHealth - 10;
		player removeMagazine _data;
		cutText ["ate big peace of raw meat", "PLAIN DOWN"];
	};
	case "jii_meat_big_cooked": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 40;
		player removeMagazine _data;
		cutText ["ate big peace of cooked meat", "PLAIN DOWN"];
	};
	case "jii_meat_small": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 15;
		playerHealth = playerHealth - 10;
		player removeMagazine _data;
		cutText ["ate small peace of raw meat", "PLAIN DOWN"];
	};
	case "jii_meat_small_cooked": {
	    //player say3D "eatSound0";
        [player,"eatSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
	    sleep 1;
		playerHunger = playerHunger + 30;
		player removeMagazine _data;
		cutText ["ate small peace of cooked meat", "PLAIN DOWN"];
	};

	// Medical
	case "jii_vitamines": {
		//player say3D "swallowSound0";
        [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 1;
		playerHealth = playerHealth + 10;
		player removeMagazine _data;
		cutText ["took vitamines", "PLAIN DOWN"];
	};

	case "jii_antibiotics": {
		//player say3D "swallowSound0";
        [player,"swallowSound0",10,1] remoteExec ["bde_fnc_say3d",0,false];
		sleep 1;
		playerInfected = 0;
		playerSick = 0;
		playerHealth = playerHealth + 20;
		player removeMagazine _data;
		cutText ["took antibiotics", "PLAIN DOWN"];
	};

    // Tools
    case "jii_hatchet": {
		if(count nearestTree > 0)then{
			_theTree = nearestTree select 0;
			_theTreePos = getPosATL _theTree;
			player playActionNow "Medic";
			//player say3D "buildSound0";
            [player,"buildSound0",500,1] remoteExec ["bde_fnc_say3d",0,false];
			sleep 10;
			_theTree setDamage 1;
			sleep 2;
			_woodHolder = createVehicle ["groundWeaponHolder",_theTreePos,[],0,"can_collide"];
			_woodHolder addMagazineCargoGlobal ["jii_wood",1];
			sleep 2;
			_woodHolder addMagazineCargoGlobal ["jii_wood",1];
			sleep 2;
			_woodHolder addMagazineCargoGlobal ["jii_wood",1];
			sleep 2;
			_woodHolder addMagazineCargoGlobal ["jii_wood",1];
			sleep 2;
			_woodHolder addMagazineCargoGlobal ["jii_wood",1];
			cutText ["choped wood", "PLAIN DOWN"];
		}else{
			cutText ["need tree", "PLAIN DOWN"];
		};
	};

    case "jii_stone": {
        [] call _buildFireplace;
    };

    case "jii_wood": {
        [] call _buildFireplace;
    };

    default {
        //cutText [format["what can i do with %1?",_text], "PLAIN DOWN"];
    };
};
