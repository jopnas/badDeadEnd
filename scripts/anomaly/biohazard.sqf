
// https://forums.bistudio.com/topic/153589-secret-simulweather-commands/
// https://community.bistudio.com/wiki/supportInfo
params["_isUnderCover","_isInCar","_rainIsAcid"];

if(_rainIsAcid)then{
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
    };
};