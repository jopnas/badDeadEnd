private["_dontDoAction"];
_eventParam = _this select 0;
_dontDoAction = false;

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
    _actionMenuVis  = _eventParam select 9; // Boolean - action menu visibility
    _actionEH       = _eventParam select 10; // String - EH event name

    switch (_actionName) do {
        case "FireInFlame": {

            _hasLighter  = "bde_zippo" in magazines _actionCaller;
            _hasMatches  = "bde_matches" in magazines _actionCaller;
            if(_hasLighter || _hasMatches)then{
                if(rain < 0.3 || _hasLighter)then{
                    if(rain > 0.8)then{ // if _hasLighter
                        cutText ["it is raining too heavy", "PLAIN DOWN"];
                        _dontDoAction = true;
                    }else{
                        _dontDoAction = false;
                    };
                }else{
                    cutText ["it is raining", "PLAIN DOWN"];
                    _dontDoAction = true;
                };
            }else{
                cutText ["You need a lighter or matches", "PLAIN DOWN"];
                _dontDoAction = true;
            };

        };

        case "TakeWeapon": {
            systemChat format["TAKEWEAPON-> target: %1 ||| caller: %2 >-DO TAKEMAGAZINE-<",_actionTarget,_actionCaller];
        };

        default {
            _dontDoAction = false;
        };
    };
};

_dontDoAction
