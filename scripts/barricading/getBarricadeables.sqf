// https://forums.bistudio.com/topic/159352-set-a-unit-to-look-out-of-window-function/?p=2499831
_isInside = _this select 0;
_building = _this select 1;

_canBarricade = false;

if(_isInside)then{
    _claimedTo = _building getVariable["claimedTo",""];

    _closestPointDist = 10000;
    if(_claimedTo == getPlayerUID player)then{

        {
            if((position player) distance _x < _closestPointDist)then{
                _closestPointDist = (position player) distance _x;
                systemChat format["closest barricading point: %1",_closestPointDist];
            };

            if((position player) distance _x < 0.7)then{
                _buildingDir    = getDir _building;
                _playerDir      = getDir player;
                _realRelDir     = floor abs(_buildingDir - _playerDir);

                if(_realRelDir < 4)then{
                    _canBarricade = true;
                };

                if(_realRelDir < 94 && _realRelDir > 86)then{
                    _canBarricade = true;
                };

                if(_realRelDir < 184 && _realRelDir > 16)then{
                    _canBarricade = true;
                };

                if(_realRelDir < 274 && _realRelDir > 266)then{
                    _canBarricade = true;
                };

                if(_canBarricade)then{
                    if(barricadeAction < 0)then{
                        barricadeAction = player addAction["Start barricading",{
                            _vars = _this select 3;
                            [_vars select 0,_vars select 1,_vars select 2] call buildBarricade;
                        },["the type",_realRelDir,_x]];
                    };
                }else{
                    if(barricadeAction >= 0)then{
                        player removeAction barricadeAction;
                        barricadeAction = -1;
                    };
                };
            };

        }forEach (_building buildingPos -1);

        if(declaimAction < 0)then{
            declaimAction = player addAction["Declaime building",{
                _vars = _this select 3;
                (_vars select 0) setVariable["claimedTo","",true];
            },[_building,getPlayerUID player]];
        };

        if(claimAction >= 0)then{
            player removeAction claimAction;
            claimAction = -1;
        };

    }else{
        if(claimAction < 0)then{
            claimAction = player addAction["Claime building",{
                _vars = _this select 3;
                (_vars select 0) setVariable["claimedTo",_vars select 1,true];
            },[_building,getPlayerUID player]];
        };

        if(declaimAction >= 0)then{
            player removeAction declaimAction;
            declaimAction = -1;
        };
    };

}else{

    if(claimAction >= 0)then{
        player removeAction claimAction;
        claimAction = -1;
    };

    if(declaimAction >= 0)then{
        player removeAction declaimAction;
        declaimAction = -1;
    };

    if(barricadeAction >= 0)then{
        player removeAction barricadeAction;
        barricadeAction = -1;
    };

};