_fnc_zombieBehaviour = compile preprocessFile "scripts\zombies\zombieBehaviour.sqf";
waitUntil {buildingsListReady};
sideZ 			= createCenter Resistance;
groupZ 			= createGroup Resistance;

publicVariable "sideZ";
publicVariable "groupZ";

groupZ allowFleeing 0;

zSpawnRange         = 700;
zMinSpawnRangeDef   = 20;
zMinSpawnRange 	    = zMinSpawnRangeDef;
agroRange 		    = 40;
attackRangeDef 		= 1.5;
zombiedamage        = 0.1;

bde_fnc_receivePlayersNoise = {
    params["_player","_noisePos","_noiseVol"];
    {
        if(_player distance _x < _noiseVol)then{
            _x setVariable["lastPlayerHeard",_noisePos,true];
        };
    }forEach (units groupZ);
};

//[] execVM "scripts\zombies\zombieManager.sqf";
