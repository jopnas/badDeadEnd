// Burn Effect
BIS_fn_createFireEffect = {
	private["_effect","_pos","_fire","_smoke","_eFire","_eSmoke"];
	private["_light","_brightness","_color","_ambient","_intensity","_attenuation"];

	_pos 	= _this select 0;
	_effect = _this select 1;
	_timer 	= _this select 2;

	_fire	= "";
	_smoke	= "";
	_light	= objNull;
	_color		= [1,0.85,0.6];
	_ambient	= [1,0.3,0];

	switch (_effect) do {
		case "FIRE_SMALL" : {
			_fire 	= "SmallDestructionFire";
			_smoke 	= "SmallDestructionSmoke";
		};
		case "FIRE_MEDIUM" : {
			_fire 	= "MediumDestructionFire";
			_smoke 	= "MediumDestructionSmoke";
			_brightness	= 0.5;
			_intensity	= 200;
			_attenuation	= [0,0,0,2];
		};
		case "FIRE_BIG" : {
			_fire 	= "BigDestructionFire";
			_smoke 	= "BigDestructionSmoke";
			_brightness	= 1.0;
			_intensity	= 1600;
			_attenuation	= [0,0,0,1.6];
		};
		case "SMOKE_SMALL" : {
			_smoke 	= "SmallDestructionSmoke";
		};
		case "SMOKE_MEDIUM" : {
			_smoke 	= "MediumSmoke";
		};
		case "SMOKE_BIG" : {
			_smoke 	= "BigDestructionSmoke";
		};
	};

	if (_fire != "") then {
		_eFire = "#particlesource" createVehicleLocal _pos;
		_eFire setParticleClass _fire;
		_eFire setPosATL _pos;
	};

	if (_smoke != "") then {
		_eSmoke = "#particlesource" createVehicleLocal _pos;
		_eSmoke setParticleClass _smoke;
		_eSmoke setPosATL _pos;
	};

	//create lightsource
	if (_effect in ["FIRE_BIG","FIRE_MEDIUM"]) then {
		_pos   = [_pos select 0,_pos select 1,(_pos select 2)+1];
		_light = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
		_light setPosATL _pos;

		_light setLightBrightness _brightness;
		_light setLightColor _color;
		_light setLightAmbient _ambient;
		_light setLightIntensity _intensity;
		_light setLightAttenuation _attenuation;
		_light setLightDayLight false;
	};

	sleep _timer;
	if (_fire != "") then {
		deleteVehicle _eFire;
	};
	if (_effect in ["FIRE_BIG","FIRE_MEDIUM"]) then {
		deleteVehicle _light;
	};

    sleep _timer;
	if (_smoke != "") then {
		deleteVehicle _eSmoke;
	};
};

// Burn Zombie
fnc_burnDeadZ = {
    if(!isDedicated)then{
        private["_deadZ","_skeletton"];
        _deadZ = _this select 0;

        [getPosATL _deadZ,"FIRE_MEDIUM",22] spawn BIS_fn_createFireEffect;
        _deadZ setVariable["burning",true,true];
        {
            if(_x distance _deadZ < 5 && group _x == groupZ && !(_x getVariable["burning",false]) )then{
                [_x] remoteExec ["fnc_burnDeadZ",0,false];
                [_x] remoteExec ["bde_fnc_removeBurnAction",0,false];
            };
        } forEach allDeadMen;

        sleep 20;
        _skeletton = createVehicle ["Land_HumanSkeleton_F", getPos _deadZ, [], 0, "CAN_COLLIDE"];
        _skeletton setDir (getDir _deadZ);
        hideBody _deadZ;
        sleep 2;
        deleteVehicle _deadZ;
    };
};
