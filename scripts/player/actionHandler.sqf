_eventParam = _this select 0;
if(count _eventParam > 0) then {

    //Fireplace
    if(_eventParam select 3 == 'FireInFlame') then {
        _lighterCount  = {_x == 'jii_zippo'} count magazines player;
        _matchesCount  = {_x == 'jii_matches'} count magazines player;
        if(_lighterCount > 0 || _matchesCount > 0)then{
            if(rain < 0.3 || _lighterCount > 0)then{
                false;
            }else{
                cutText ['its rainin', 'PLAIN DOWN'];
                true;
            };
        }else{
            cutText ['You need a lighter or matches', 'PLAIN DOWN'];
            true;
        };
    }else{
        false;
    };

}else{
    false;
};
