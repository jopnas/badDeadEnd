// Animals Script
_animals = nearestObjects[player,["Rabbit_F","Goat_random_F","Sheep_random_F","Hen_random_F","Cock_random_F"],100];
{
	_animal = _x;
	_animalHasLoot = _animal getVariable["animalHasLoot",0];
	if(!(alive _animal) && _animalHasLoot == 0)then{
		if (_animalHasLoot < 1) then {
			_animal setVariable["animalHasLoot",1,true];
			_gwh = createVehicle ["groundWeaponHolder",position _animal,[],0,"can_collide"];
			_gwh modelToWorld [0,0.3,0];

			_animalType = typeOf _animal;
			if(_animalType in ["Sheep_random_F","Goat_random_F"])then{
				_gwh addMagazineCargoGlobal["bde_meat_big",2];
			};
			if(_animalType in ["Rabbit_F","Hen_random_F","Cock_random_F"])then{
				_gwh addMagazineCargoGlobal["bde_meat_small",2];
			};
		};
    };

	if(random 100 < 5)then{
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
