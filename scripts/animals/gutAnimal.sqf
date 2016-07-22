params["_animal"];
_smallAnimals = ["Rabbit_F","Hen_random_F","Cock_random_F"];
_bigAnimals = ["Goat_random_F","Sheep_random_F"];

if(_animal getVariable["animalHasLoot",0] == 0)then{
    _animal setVariable["animalHasLoot",1,true];
    _animalPos = getPosATL _animal;
    _newPos = [(_animalPos select 0)  + 0.5,(_animalPos select 1)  + 0.5,_animalPos select 2];

    player playActionNow "Medic";
    [player,"buildSound0","configVol","randomPitch",300] spawn bde_fnc_playSound3D;
    sleep 5;
    _gwh = createVehicle ["ContainerSupply",_newPos,[],0,"can_collide"];
    _gwhMark = createVehicle ["Sign_Arrow_Large_Cyan_F",_newPos,[],0,"can_collide"];

    _animalType = typeOf _animal;
    if(_animalType in _bigAnimals)then{
        _gwh addMagazineCargoGlobal["bde_meat_big",2];
        _gwh addMagazineCargoGlobal["bde_meat_small",3];
    };
    if(_animalType in _smallAnimals)then{
        _gwh addMagazineCargoGlobal["bde_meat_small",2];
    };
    _gwh setPosATL _newPos;
    _gwhMark setPosATL _newPos;
};
