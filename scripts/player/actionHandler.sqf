_eventParam = _this select 0;
if(count _eventParam > 0) then {
    _actionTarget   = _eventParam select 0;
    _actionCaller   = _eventParam select 1;
    _actionName     = _eventParam select 3;
    _actionText     = _eventParam select 4;

    //Fireplace
    if(_actionName == "FireInFlame") then {
        _hasLighter  = "jii_zippo" in magazines _actionCaller;
        _hasMatches  = "jii_matches" in magazines _actionCaller;
        if(_hasLighter || _hasMatches)then{
            if(rain < 0.3 || _hasLighter)then{
                if(rain > 0.8)then{ // if _hasLighter
                    cutText ['its raining too heavy', 'PLAIN DOWN'];
                    true
                }else{
                    false
                };
            }else
                cutText ['its raining', 'PLAIN DOWN'];
                true
            };
        }else{
            cutText ['You need a lighter or matches', 'PLAIN DOWN'];
            true
        };
    }else{
        false
    };

}else{
    false
};
