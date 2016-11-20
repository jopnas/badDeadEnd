params["_isInCar","_isInShadow","_sunRadiation"/**/,"_newValue","_radiationVal"];

_playerUniform		= uniform player;
_playerVest			= vest player;
_playerBackpack		= backpack player;
_headgear 		    = headgear player;
_radiationVal       = player getVariable ["playerRadiation",0];
_newValue           = _radiationVal - 0.0001;

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

player setVariable ["playerRadiation",_newValue,true];