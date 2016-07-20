// Animals Script
_animals = nearestObjects[player,["Rabbit_F","Goat_random_F","Sheep_random_F","Hen_random_F","Cock_random_F"],100];
{
	_animal = _x;

	if(!(alive _animal) && _animal getVariable["animalHasLoot",0] == 0)then{
        _animal addEventHandler ["AnimDone",{
            params["_unit","_anim"];
            if(_unit getVariable["animalHasLoot",0] == 0)then{
                _unit setVariable["animalHasLoot",1,true];
                if(_anim == "rabbit_die")then{
                    sleep 1;
                    _gwh = createVehicle ["ContainerSupply",position _unit,[],0,"can_collide"];

                    _animalType = typeOf _unit;
                    if(_animalType in ["Sheep_random_F","Goat_random_F"])then{
                        _gwh addMagazineCargoGlobal["bde_meat_big",2];
                    };
                    if(_animalType in ["Rabbit_F","Hen_random_F","Cock_random_F"])then{
                        _gwh addMagazineCargoGlobal["bde_meat_small",2];
                    };
                    _gwh setPosATL (getPosATL _unit);
                    _gwh attachTo [_unit, [0,0,0]];
                };
            };
        }];
    };

	if(random 100 < 2)then{
		switch (typeOf _animal) do {
			case "Sheep_random_F":{
				_rdmSheep = floor(random 2);
				_animal say3D format["sheep%1",_rdmSheep];
			};
			case "Goat_random_F":{
				_rdmGoat = floor(random 2);
				_animal say3D format["goat%1",_rdmGoat];
			};
			case "hen_random_f":{
				_rdmHen = floor(random 2);
				_animal say3D format["hen%1",_rdmHen];
			};
			case "Cock_random_F":{
				_rdmHen = floor(random 2);
				_animal say3D format["hen%1",_rdmHen];
			};
		};
	};

}forEach _animals;
