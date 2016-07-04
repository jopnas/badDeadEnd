_eventParam = _this select 0;
if(count _eventParam > 0) then {
    _actionTarget   = _eventParam select 0; // Object - target object to which action is attached
    _actionCaller   = _eventParam select 1; // Object - caller object, basically player
    _actionIndex    = _eventParam select 2; // Number - index of the action in action menu (0 - top most)
    _actionName     = _eventParam select 3; // String - engine based action name ("User" for user added actions)
    _actionText     = _eventParam select 4; // String - localized action plain text as seen by the caller
    _actionPrio     = _eventParam select 5; // Number - action priority value
    _actionWindow   = _eventParam select 6; // Boolean - action showWindow value
    _actionHide     = _eventParam select 7; // Boolean - action hideOnUse value
    _actionShortcut = _eventParam select 8; // String - action shortcut name or ""
    _actionMenuVis  = _eventParam select 9; // Boolean - action menu visibility (on first scroll or action press the menu is still invisible, so no action is performed, only menu is shown)
    _actionEH       = _eventParam select 10; // String - EH event name

    //Fireplace
    /*if(_actionName == "FireInFlame") then {
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
            }else{
                cutText ['its raining', 'PLAIN DOWN'];
                true
            };
        }else{
            cutText ['You need a lighter or matches', 'PLAIN DOWN'];
            true
        };
    }else{
        false
    };*/

    switch (_actionName) do {
        case "FireInFlame": {

            _hasLighter  = "jii_zippo" in magazines _actionCaller;
            _hasMatches  = "jii_matches" in magazines _actionCaller;
            if(_hasLighter || _hasMatches)then{
                if(rain < 0.3 || _hasLighter)then{
                    if(rain > 0.8)then{ // if _hasLighter
                        cutText ["it is raining too heavy", "PLAIN DOWN"];
                        true
                    }else{
                        false
                    };
                }else{
                    cutText ["it is raining", "PLAIN DOWN"];
                    true
                };
            }else{
                cutText ["You need a lighter or matches", "PLAIN DOWN"];
                true
            };

        };

        case "TakeWeapon": {
            //systemChat format["TAKEWEAPON-> target: 1% ||| caller: 2% >-DO TAKEMAGAZINE-<",_actionTarget,_actionCaller];
        };

        default {
            false
        };
    };


}else{
    false
};
