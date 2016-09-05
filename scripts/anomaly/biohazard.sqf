
// https://forums.bistudio.com/topic/153589-secret-simulweather-commands/
// https://community.bistudio.com/wiki/supportInfo

// Acid Rain
if(rain > 0)then{
    ["RadialBlur", 100, [100, 0.5, 0.1, 0.5]] spawn {
    	params ["_name", "_priority", "_effect", "_handle"];
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