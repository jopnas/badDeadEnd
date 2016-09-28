params["_isUnderCover","_isInCar","_isInShadow","_sunRadiation"/**/,"_newValue"];

_playerUniform		= uniform player;
_playerVest			= vest player;
_playerBackpack		= backpack player;
_headgear 		    = headgear player;

_newValue           = playerPoisoning - 0.001;

// Acid Rain
if(rain > 0 && acidRain)then{
    if(!(_isUnderCover) && !(_isInCar))then{
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

// Toxic Oxygen from Trees
_trees = [];
{
    if (str _x find ": t_" > -1) then {
        _trees pushBack _x;
    };
} forEach nearestObjects [player, [], 10];
_countedTrees = count _trees;
if(_countedTrees > 0 && goggles player != "bde_gasmask") then{
    _newValue = _newValue + (0.01 * _countedTrees);
};
systemChat str (0.02 * _countedTrees);

// Direct Sunshine
if(!(_isInShadow) && _sunRadiation > 0)then{
    _newValue = _newValue + (_sunRadiation/1000);

    if(_playerUniform != "U_BasicBody")then{
        _newValue = _newValue - ((_sunRadiation/1000) / 4);
    };

    if(_playerVest != "")then{
        _newValue = _newValue - ((_sunRadiation/1000) / 4);
    };
    if(_playerBackpack != "")then{
        _newValue = _newValue - ((_sunRadiation/1000) / 4);
    };
    if(_headgear != "")then{
        _newValue = _newValue - ((_sunRadiation/1000) / 4);
    };
};

if(_newValue < 0)then{
    _newValue = 0;
};

if(_newValue > 100)then{
    _newValue = 100;
};

// acid rain effect
/*["ColorInversion", 2500, [0,1,0],_isUnderCover,_isInCar] spawn {
    params ["_name", "_priority", "_effect", "_handle","_isUnderCover","_isInCar"];
    _handle = ppEffectCreate [_name, _priority];
    _handle ppEffectAdjust _effect;
    if(rain > 0 && acidRain && !(_isUnderCover) && !(_isInCar))then{
        _handle ppEffectEnable true;
    }else{
        _handle ppEffectEnable true;
    };
    _handle ppEffectCommit 3;
};

// poisoned effect
["DynamicBlur", 400, [_newValue]] spawn {
	params ["_name", "_priority", "_poisoningVal", "_handle","_effect"];
    _handle = ppEffectCreate [_name, _priority];
    if(_poisoningVal select 0 > 0)then{
        _effect = (_poisoningVal select 0)/10;
        _handle ppEffectEnable true;
    }else{
        _effect = 0;
        _handle ppEffectEnable false;
    };
    _handle ppEffectAdjust _effect;
	_handle ppEffectCommit 2;
};*/

playerPoisoning = _newValue;