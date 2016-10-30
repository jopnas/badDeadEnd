fnc_spawnLoot = {
  private ["_buildingType"];

  _playerPosition 	    = _this select 0;

  _clothes              = headgears + vests + uniforms;

  _ducttapes            = ["bde_ducttape","bde_ducttape_6","bde_ducttape_5","bde_ducttape_4","bde_ducttape_3","bde_ducttape_2","bde_ducttape_1","bde_ducttape_empty"];
  _bottles              = ["bde_bottleclean","bde_bottleclean_3_4","bde_bottleclean_2_4","bde_bottleclean_1_4","bde_bottleempty","bde_bottlefilled","bde_bottleuseless"];
  _canteen              = ["bde_canteenfilled","bde_canteenfilled_3_4","bde_canteenfilled_2_4","bde_canteenfilled_1_4","bde_canteenempty"];

  // Military Lootlists
  _itemsMil             = ["bde_gasmask","bde_gasmask_wasted","bde_gasmask_filter","bde_gasmask_empty","ItemGPS","Rangefinder","NVGoggles","Laserdesignator","Laserdesignator_02","Laserdesignator_03"];
  // Civilian Lootlists
  _itemsCiv             = ["ItemWatch","ItemCompass","ItemMap","Binocular","FirstAidKit","Medikit"];
  // ConstructionBuilding Items
  _constructionItems    = ["bde_matches","bde_lock","bde_wood","bde_hammer","bde_nails","bde_plank","bde_cable","bde_stone","bde_codelock_panel"];

  // BDE Mod Items
  _foodItems            = ["bde_apple","bde_canunknown","bde_canpasta","bde_sodacan_01","bde_antibiotics","bde_vitamines"];
  _medicalItems	        = ["bde_gasmask_filter","bde_gasmask_empty","bde_antiradiationtablets","bde_waterpurificationtablets","bde_antibiotics","bde_vitamines"];
  _toolItems            = ["bde_scarf","bde_matches","bde_lock","bde_hatchet","bde_zippo","bde_codelock_panel","bde_codelock"];

  // Building Stuff
  _garageStuff          = ["bde_camonetSmallPacked","bde_camonetBigPacked","bde_camonetVehiclesPacked","bde_tentCamoPacked","bde_tentDomePacked","bde_wheel","bde_fuelCanisterEmpty","bde_fuelCanisterFilled","bde_wrench","bde_multitool"];
  _garagesNames         = ["Land_i_Garage_V1_F","Land_i_Garage_V1_dam_F","Land_i_Garage_V2_F","Land_i_Garage_V2_dam_F"];
  _pierNames         	= ["Land_Pier_F","Land_Pier_Box_F","Land_Pier_wall_F"];
  _bridgeNames         	= ["Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F"];
  _BuildingsExclude     = _pierNames + _bridgeNames;

  // Furniture
  _furnituresCivil      =["Land_ChairWood_F","Land_Metal_rack_F","Land_Rack_F","Land_Metal_wooden_rack_F","Land_ShelvesWooden_khaki_F","Land_ShelvesWooden_F","Land_WoodenTable_small_F","Land_WoodenTable_large_F","Land_ChairPlastic_F"];

  _constructionItems append [_bottles,_canteen];
  _foodItems append [_canteen,_bottles,_ducttapes];

  _buildings = nearestObjects [_playerPosition, ["Building"], 50];
  {
    _building       = _x;
    _buildingClass  = typeOf _x;
    _position       = getPos _building;
    _posBuilPos     = count(_building call BIS_fnc_buildingPositions);

    if ( buildingsListReady && _posBuilPos > 0 && !(_buildingClass in _BuildingsExclude) && (_building getVariable["hasLoot",0]) == 0) then {

	  _building setVariable["hasLoot",1,false];

      if(_buildingClass in militaryBuildings)then {
        _buildingType = "MilitaryBuilding";
      };

      if(_buildingClass in airportBuildings)then {
        _buildingType = "AirportBuilding";
      };

      if(_buildingClass in researchBuildings)then {
        _buildingType = "ResearchBuilding";
      };

      if(_buildingClass in constructBuildings)then {
        _buildingType = "ConstructionBuilding";
      };

      if( !(_buildingClass in (researchBuildings + constructBuildings + militaryBuildings + airportBuildings)) )then {
        _buildingType = "CivilianBuilding";
      };

      if(_posBuilPos > 0) then {
        for "_i" from 0 to _posBuilPos step 1 do {

            // Create Holder

    		_holderPos = _building buildingPos _i;
            _spawn = createVehicle ["groundWeaponHolder", [_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.15], [], 0, "CAN_COLLIDE"];

    		// Options
            _spawn setVehiclePosition [[_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.15], [], 0, "CAN_COLLIDE"];
            _spawn setDir round(random 360);

            if(_buildingClass in _garagesNames)then {
                _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _garageStuff, 1];
            };

            switch(_buildingType) do {
                case "MilitaryBuilding":{
                  // Attachments
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom attachments,1];
                  };

                  // Tools
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom _itemsMil,1];
                  };

                  // Ammo only
                  if(random 100 < 30) then {
                    _rdmWeaponAmmoMil  = selectRandom (heavyWeapons call BIS_fnc_arrayShuffle);
                    _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoMil >> "magazines");
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)+1];
                  };

                  // Backpacks
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addBackpackCargoGlobal*/ [selectRandom backpacks,1];
                  };

                  // Cloth
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom _clothes,1];
                  };

                  // Handgrenades
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom handgrenades, round(random 2)];
                  };

                  // Chemlights
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom chemlights, round(random 2)];
                  };

                  // Smokeshells
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom smokeshells, round(random 2)];
                  };

                  // Medicals & Chemicals
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _medicalItems, 1];
                  };


                  // Weapons
                  if(random 100 < 30) then {
                    _rdmWeaponWeapMil = selectRandom (heavyWeapons call BIS_fnc_arrayShuffle);
                    _spawn addItemCargoGlobal/*addWeaponCargoGlobal*/ [_rdmWeaponWeapMil,1];
                    _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapMil >> "magazines");
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)];
                  };
                };

                case "AirportBuilding":{
                    // Ammo only
                    if(random 100 < 30) then {
                      _rdmWeaponAmmoAir  = selectRandom mediumWeapons;
                      _rmags      = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoAir >> "magazines");
                      _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)+1];
                    };

                    // Weapons
                    if(random 100 < 30) then {
                      _rdmWeaponWeapAir = selectRandom mediumWeapons;
                      _spawn addItemCargoGlobal/*addWeaponCargoGlobal*/ [_rdmWeaponWeapAir,1];
                      _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapAir >> "magazines");
                      _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)];
                    };

                    // Medicals & Chemicals
                    if(random 100 < 30) then {
                      _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _medicalItems, 1];
                    };

                    // Tools
                    if(random 100 < 30) then {
                        _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _toolItems,1];
                    };

                    // Food
                    if(random 100 < 30) then {
                      _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _foodItems, 1];
                    };
                };

                case "ResearchBuilding":{
                  // Medicals & Chemicals
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _medicalItems, 1];
                  };
                };

                case "ConstructionBuilding":{
                    // Tools
                    if(random 100 < 30) then {
                        _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _toolItems,1];
                    };
                    // Xtra Construction Items
                    for "_i=1" from 1 to 5 do {
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _constructionItems,round(random 1)];
                        };
                    };
                };

                case "CivilianBuilding":{
                    // Furnitures
                    if(random 100 < 20 && !(_buildingClass in ["Land_Hangar_F","Land_TentHangar_V1_F"])) then {
                        if([_holderPos] call bde_fnc_underCover)then{
                            _furniture = createVehicle[selectRandom _furnituresCivil, _holderPos, [], 0, "CAN_COLLIDE"];
                            _furniture setDir round(random 360);
                            _furniture setVehiclePosition [[_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.1], [], 0, "CAN_COLLIDE"];
                        };
                    }else{
                        // Medicals & Chemicals
                        if(random 100 < 30) then {
                          _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _medicalItems, 1];
                        };

                        // Tools
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _toolItems,1];
                        };

                        // Food
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _foodItems, 1];
                        };

                        // Items
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal [selectRandom _itemsCiv,1];
                        };

                        // Ammo only
                        if(random 100 < 30) then {
                            _rdmWeaponAmmoCiv  = selectRandom lightWeapons;
                            _rmags      = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoCiv >> "magazines");
                            _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)+1];
                        };

                        // Backpacks
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal/*addBackpackCargoGlobal*/ [selectRandom backpacks,1];
                        };

                        // Clothes
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal [selectRandom _clothes,1];
                        };

                        // Weapons
                        if(random 100 < 30) then {
                            _rdmWeaponWeapCiv = selectRandom lightWeapons;
                            _spawn addItemCargoGlobal/*addWeaponCargoGlobal*/ [_rdmWeaponWeapCiv,1];
                            _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapCiv >> "magazines");
                            _spawn addItemCargoGlobal/*addMagazineCargoGlobal*/ [selectRandom _rmags, round(random 3)];
                        };
                    };
                };

                default {};
            };

        };
      };
    };
  }forEach(_buildings);
};
