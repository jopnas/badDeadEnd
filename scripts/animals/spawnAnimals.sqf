civGroup = createGroup CIVILIAN;
fnc_spawnAnimals = {
  _type   = _this select 0;
  _number = _this select 1;
  _radius = _this select 2;
  _pos    = _this select 3;
  for "_i" from 1 to _number do {
    _spawnPos = [((_pos select 0)-_radius) + random (_radius*2),((_pos select 1)-_radius) + random (_radius*2),0];
    _animal = civGroup createUnit [_type,_spawnPos, [], 5, "CAN_COLLIDE"];
  };
};


// "Rabbit_F","Goat_random_F","Sheep_random_F","Hen_random_F","Cock_random_F","Fin_random_F","Alsatian_Random_F"
//["Sheep_random_F",5,10,getPos _playerUnit] spawn fnc_spawnAnimals; // classname,count,spawn radius, position
