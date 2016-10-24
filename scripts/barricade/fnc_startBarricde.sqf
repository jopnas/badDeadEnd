_caller     = _this select 1;

barricade = createVehicle ["bde_barricade_win_one", getPosATL _caller,[],0,"can_collide"];
barricade enableSimulation false;
barricade setDir (getDir _caller);
barricade setVariable["barricadeLevel",1,true];