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

waitUntil {buildingsListReady};
[] execVM "scripts\zombies\zombieManager.sqf";
