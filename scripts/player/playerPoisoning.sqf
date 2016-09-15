params["_isUnderCover","_isInCar","_isInShadow","_sunRadiation"/**/,"_newValue"];

_playerUniform		= uniform player;
_playerVest			= vest player;
_playerBackpack		= backpack player;
_headgear 		    = headgear player;

_newValue       = playerPoisoning - 0.01;

// Acid Rain
if(acidRainPossible)then{
    ["ColorInversion", 2500, [random 1,random 1,random 1]] spawn {
    	params ["_name", "_priority", "_effect",/**/"_handle"];
    	while {
    		_handle = ppEffectCreate [_name, _priority];
    		_handle < 0
    	} do {
    		_priority = _priority + 1;
    	};
    	_handle ppEffectEnable true;
    	_handle ppEffectAdjust _effect;
    	_handle ppEffectCommit 5;
    	waitUntil {ppEffectCommitted _handle};
    	uiSleep 3;
    	comment "admire effect for a sec";
    	_handle ppEffectEnable false;
    	ppEffectDestroy _handle;
    };

    // Acid Rain
    if(rain > 0 && !(_isUnderCover) && !(_isInCar))then{
        systemChat format["ouch, acid rain: %1",rain];
        _curDamage = damage player;
        player setDamage (_curDamage - (rain/100));

        ["DynamicBlur", 400, [rain*10]] spawn {
        	params ["_name", "_priority", "_effect",/**/"_handle"];
        	while {
        		_handle = ppEffectCreate [_name, _priority];
        		_handle < 0
        	} do {
        		_priority = _priority + 1;
        	};
        	_handle ppEffectEnable true;
        	_handle ppEffectAdjust _effect;
        	_handle ppEffectCommit 5;
        	waitUntil {ppEffectCommitted _handle};
        	uiSleep 3;
        	comment "admire effect for a sec";
        	_handle ppEffectEnable false;
        	ppEffectDestroy _handle;
        };

        _newValue = _newValue + rain;

        if(_playerUniform != "U_BasicBody")then{
            _newValue = _newValue - (rain / 5);
        };
        if(_playerVest != "")then{
            _newValue = _newValue - (rain / 5);
        };
        if(_playerBackpack != "")then{
            _newValue = _newValue - (rain / 5);
        };
        if(_headgear != "")then{
            _newValue = _newValue - (rain / 5);
        };
    };
};

_trees = [];
{
    if (str _x find ": t_" > -1) then {
        _trees pushBack _x;
    };
} forEach nearestObjects [player, [], 5];
_countedTrees = count _trees;
if(_countedTrees > 0)then{
    _newValue = _newValue + (0.02 * _countedTrees);
};

// Direct Sunrays
if(!(_isInShadow) && _sunRadiation > 0)then{
    _newValue = _newValue + (_sunRadiation/100);

    if(_playerUniform != "U_BasicBody")then{
        _newValue = _newValue - (_sunRadiation/22);
    };
    if(_playerVest != "")then{
        _newValue = _newValue - (_sunRadiation/22);
    };
    if(_playerBackpack != "")then{
        _newValue = _newValue - (_sunRadiation/22);
    };
    if(_headgear != "")then{
        _newValue = _newValue - (_sunRadiation/22);
    };

};

if(_newValue < 0)then{
    _newValue = 0;
};

if(_newValue > 100)then{
    _newValue = 100;
};

playerPoisoning = _newValue;