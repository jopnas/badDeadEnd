_z = _this select 0;
_z setHit ["head", 0.7 + random(0.2)];
_z setHit ["hands", 0.7 + random(0.2)];
_z setHit ["legs", 0.4];

removeAllWeapons _z;
removeAllAssignedItems _z;

_z disableAI "FSM";
_z disableAI "TARGET";
_z disableAI "AUTOTARGET";
_z disableAI "SUPPRESSION";
_z disableAI "AIMINGERROR";
_z setBehaviour "CARELESS";
_z enableFatigue false;
_z addRating -10000;

_z disableConversation true;
enableSentences false;

_z setVariable["speechPitch",random(2), false];

_z setVariable["hasTarget",false, false];
_z setVariable["lastPlayerSeen",[false,[]], false];
_z setVariable["lastPlayerHeard",[], false];
doStop _z;

_z addEventHandler ["FiredNear", {
    _unit = _this select 0; //Object - Object the event handler is assigned to
    _firer = _this select 1; //Object - Object which fires a weapon near the unit
    _distance = _this select 2; //Number - Distance in meters between the unit and firer (max. distance ~69m)
    _weapon = _this select 3; //String - Fired weapon
    //_muzzle = _this select 4; //String - Muzzle that was used
    //_mode = _this select 5; //String - Current mode of the fired weapon
    //_ammo = _this select 6; //String - Ammo used

    _silenced = 0;
    if(_weapon == primaryWeapon _firer)then{
        if(str(primaryWeaponItems _firer) find "muzzle" > -1)then{
            _silenced = 3;
        };
    };
    if(_weapon == secondaryWeapon _firer)then{
        if(str(secondaryWeaponItems _firer) find "muzzle" > -1)then{
            _silenced = 2;
        };
    };
    if(_weapon == handgunWeapon _firer)then{
        if(str(handgunItems _firer) find "muzzle" > -1)then{
            _silenced = 4;

        };
    };

    if(_silenced > 0)then{
        _distance = _distance / _silenced;
    };

    //_lastPlayerHeard     = _unit getVariable "lastPlayerHeard";

    //if(_distance < _lastPlayerHeard distance _unit)then{
        _unit setVariable["lastPlayerHeard",position _firer, false];
    //};
    //systemChat str (_distance);
}];

_z addeventhandler ["HandleDamage",{
    _unit = _this select 0;
    _selectionName = _this select 1;
    _amountOfDamage = _this select 2;
    _sourceOfDamage = _this select 3;
    _typeOfProjectile = _this select 4;
    _hitPartIndex = _this select 5;

	if (local _unit) then {
		//hint str(_hitPartIndex);
        if (_amountOfDamage > 1 and _typeOfProjectile != "") then {
            for "_i" from 0 to (floor _amountOfDamage) do {
                _Eff = "#particlesource" createVehicleLocal eyePos _unit;
                _Eff setParticleCircle [0, [0, 0, 0]];
                _Eff setParticleRandom [0.05, [0.25, 0.25, 0], [0.175, 0.175, 0.175], 0, 0.25, [0, 0, 0, 0], 0, 0];
                _Eff setParticleParams [["\A3\data_f\ParticleEffects\Universal\smoke.p3d", 1, 0, 1], "", "Billboard", 1, 0.15, eyePos _unit, [0, 10, -0.25], 0, 10, 7.9, 0.075, [0.25, 0.5, 0.7], [[0.7, 0, 0, 1], [0.7, 0, 0, 0.8], [0.7, 0, 0, 0.5], [0.7, 0, 0, 0]], [0.08], 1, 0, "", "", Eff];
                _Eff setDropInterval 60;//delete particle source to stop, otherwise it will keep spawning it once every 60 seconds
            };
            switch(_selectionName) do {
                case "head": {
                    _amountOfDamage = _amountOfDamage*100000;
                    _headshotSound = createSoundSource ["headshot0", position _unit, [], 0];
                	sleep 2;
                	deleteVehicle _headshotSound;
                };
                default {
                    _amountOfDamage = 0.05;
                    [_unit,format["zhurt%1",floor random 3],50,_speechPitch] remoteExec ["bde_fnc_say3d",0,false];
				};
	        };
        }else{
            //_amountOfDamage = 0;
        };
    };
    _amountOfDamage
}];

_z addMPEventHandler ["MPKilled",{
    _deadZ = _this select 0;
    [_deadZ] call bde_fnc_addBurnAction;
}];

canSeePlayer = {
    _z      = _this select 0;
    _p      = _this select 1;
    _canSee = false;

    _relDir         = _z getRelDir (position _p);
    _inViewAngle    = abs(_relDir - 180);
    if([objNull, "VIEW"] checkVisibility [eyePos _z, eyePos _p] > 0.9 && _inViewAngle > 100) then{
         _canSee = true;
    };

    _canSee
};

nextGrowl = 0;

_zBehaviour = [_z] spawn {
    private["_closestPlayerAlive"];
    _z = _this select 0;

    while{alive _z}do{
        t=time;
        // Do Zombie Behaviour here

        _speechPitch        = _z getVariable "speechPitch";
        _hasTarget          = _z getVariable "hasTarget";
        _lastPlayerHeard    = _z getVariable "lastPlayerHeard";

        _lastPlayerSeen     = _z getVariable "lastPlayerSeen";
        _lastPlayerSeenSet  = _lastPlayerSeen select 0;
        _lastPlayerSeenPos  = _lastPlayerSeen select 1;


        // Check Players in spawn range and seperate in alive/dead lists
        _alivePlayers   = [];
        _deadPlayers    = [];
        _closestPlayerAliveDistance = zMinSpawnRange;
        {
            _player = _x;
            if(_player distance _z < zMinSpawnRange)then{
                if(alive _player)then{
                    _alivePlayers = _alivePlayers + [_player];
                    if(_player distance _z < _closestPlayerAliveDistance)then{
                        _closestPlayerAliveDistance = _player distance _z;
                        _closestPlayerAlive         = _player;
                    };
                }else{
                    _deadPlayers = _deadPlayers + [_player];
                };
            };
        } forEach (allPlayers - entities "HeadlessClient_F");

        if(count _alivePlayers > 0)then{
            if(_closestPlayerAliveDistance > agroRange)then{
                _z forceWalk true;
                _z forceSpeed 0.3;
                _z setVariable["lastPlayerSeen",[false,[]], false];
                _z setVariable["hasTarget",false, false];
                if(count(_lastPlayerHeard) > 0)then{
                    _z doMove (_lastPlayerHeard);
                };
                if(t > nextGrowl)then{
                    [_z,format["zidle%1",floor random 8],50,_speechPitch] remoteExec ["bde_fnc_say3d",0,false];
                    nextGrowl = time + 30 + random 30;
                };
            }else{
                if([_z,_closestPlayerAlive] call canSeePlayer)then{
                    _z forceWalk false;
                    _z forceSpeed 10;

                    if(!_hasTarget)then{
                        [_z,format["zpunch%1",floor random 4],50,_speechPitch] remoteExec ["bde_fnc_say3d",0,false];
                        _z setVariable["hasTarget",true, false];
                    };

                   if(_closestPlayerAliveDistance > attackRangeDef)then{
                        _z doMove (position _closestPlayerAlive);
                    };

                   // if player in attack range
                    if(_closestPlayerAliveDistance < attackRangeDef)then{
                        doStop _z;
                        _z playMove "AwopPercMstpSgthWnonDnon_end";
                        sleep 1;
                        [_z,format["zpunch%1",floor random 4],50,_speechPitch] remoteExec ["bde_fnc_say3d",0,false];
                        if(_closestPlayerAliveDistance < attackRangeDef && [_z,_closestPlayerAlive] call canSeePlayer)then{
                            _closestPlayerAlive setDamage (damage _closestPlayerAlive + zombiedamage);
                        };
                    };

                }else{
                    if(_lastPlayerSeenSet)then{
                        _z doMove (_lastPlayerSeenPos);
                        _z setVariable["hasTarget",false, false];
                        if(
                            (position _z) distance _lastPlayerSeenPos < 2 &&
                            (!(terrainIntersectASL [_lastPlayerSeenPos, eyePos _z]) && !(lineIntersects [ _lastPlayerSeenPos, eyePos _z])) &&
                            !([_z,_closestPlayerAlive] call canSeePlayer)
                        )then{
                            _z setVariable["lastPlayerSeen",[false,[]], false];
                        };
                    }else{
                        if(count(_lastPlayerHeard) > 0)then{
                            _z doMove (_lastPlayerHeard);
                        };
                    };
                };
            };
        }else{
            _z forceWalk true;
            _z forceSpeed 0.3;
            _z setVariable["hasTarget",false, false];
        };

        if(_closestPlayerAliveDistance > zMinSpawnRange)then{
            deleteVehicle _z;            
        };


        sleep 0.5;
    };

};
