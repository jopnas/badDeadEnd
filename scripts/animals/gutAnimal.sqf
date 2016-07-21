params["_animal"];

if(_animal getVariable["animalHasLoot",0] == 0)then{
    _animal setVariable["animalHasLoot",1,true];
        sleep 1;
        _gwh = createVehicle ["ContainerSupply",position _animal,[],0,"can_collide"];

        _animalType = typeOf _animal;
        if(_animalType in ["Sheep_random_F","Goat_random_F"])then{
            _gwh addMagazineCargoGlobal["bde_meat_big",2];
        };
        if(_animalType in ["Rabbit_F","Hen_random_F","Cock_random_F"])then{
            _gwh addMagazineCargoGlobal["bde_meat_small",2];
        };
        _gwh setPosATL (getPosATL _animal);
        _gwh attachTo [_animal, [0,0,0]];
    };
};
