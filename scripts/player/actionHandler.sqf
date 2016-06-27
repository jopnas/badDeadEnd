_eventParam = _this select 0;
if(count _eventParam > 0) then {
    _actionTarget   = _eventParam select 0;
    _actionCaller   = _eventParam select 1;
    _actionName     = _eventParam select 3;
    _actionText     = _eventParam select 4;

    systemChat format["actionTarget: %1, actionName: %2, actionText: %3",_actionTarget,_actionName,_actionText];

    switch(_actionName)do{
        case "FireInFlame": {
            _hasLighter = "jii_zippo" in magazines player;
            _hasMatches = "jii_matches" in magazines player;
            if(_hasLighter || _hasMatches)then{
                if(rain < 0.5)then{
                    false;
                }else{
                    if(_hasLighter)then{
                        if(rain > 0.8)then{
                            cutText ["It rains too much, even for a lighter", "PLAIN DOWN"];
                            true;
                        };
                        false;
                    }else{
                        cutText ["It rains. you need a lighter", "PLAIN DOWN"];
                        true;
                    };
                };
            }else{
                cutText ["You need a lighter or matches", "PLAIN DOWN"];
                true;
            };
        };
        default {
            false;
        };
    };
}else{
    false;
};
