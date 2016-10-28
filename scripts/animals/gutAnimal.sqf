private["_newPos"];
_animal         = cursorObject;
if (!(_animal isKindOf "Animal")) exitWith {};

_smallAnimals   = ["Rabbit_F","Hen_random_F","Cock_random_F"];
_bigAnimals     = ["Goat_random_F","Sheep_random_F"];
_animalType     = typeOf _animal;

if(_animal getVariable["animalHasLoot",0] == 0)then{
    _animal setVariable["animalHasLoot",1,true];
    _animalPos = getPosATL _animal;

    player playActionNow "Medic";
    [player,"buildSound0","configVol","randomPitch",300] spawn bde_fnc_playSound3D;
    sleep 5;
    switch(_animalType)do{
        case "Rabbit_F": {
            _newPos = _animal modelToWorld [0.3,0.5,0];
        };
        case "Hen_random_F": {
            _newPos = _animal modelToWorld [0,0,0];
        };
        case "Cock_random_F": {
            _newPos = _animal modelToWorld [0,0,0];
        };
        case "Goat_random_F": {
            _newPos = _animal modelToWorld [-0.1,0.5,0];
        };
        case "Sheep_random_F": {
            _newPos = _animal modelToWorld [0.3,0.5,0];
        };
        default {
            _newPos = _animal modelToWorld [0,0,0];
        };
    };

    _gwh = createVehicle ["ContainerSupply",_newPos,[],0,"can_collide"];
    //_gwhMark = createVehicle ["Sign_Arrow_Large_Cyan_F",_newPos,[],0,"can_collide"];

    if(_animalType in _bigAnimals)then{
        _gwh addMagazineCargoGlobal["bde_meat_big",2];
        _gwh addMagazineCargoGlobal["bde_meat_small",3];
    };
    if(_animalType in _smallAnimals)then{
        _gwh addMagazineCargoGlobal["bde_meat_small",2];
    };
    _gwh setPosATL _newPos;
    //_gwhMark setPosATL _newPos;
};
