_isInside = _this select 0;
_building = _this select 1;

_canBarricade = false;

if(_isInside)then{
    _claimedTo = _building getVariable["claimedTo",""];
    
    
    if(_claimedTo == getPlayerUID player)then{
        {
            if((position player) distance _x < 0.7)then{
                _buildingDir    = getDir _building;
                _playerDir      = getDir player;
                _realRelDir     = floor abs(_buildingDir - _playerDir);        
                if(
                    (_realRelDir < 2) ||
                    (_realRelDir < 92 && _realRelDir > 88) ||
                    (_realRelDir < 182 && _realRelDir > 178) ||
                    (_realRelDir < 272 && _realRelDir > 268)
                )then{
                    _canBarricade = true;
                }else{
                    _canBarricade = false;
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
                (_vars select 0) setVariable["claimedTo",""];  
            },[_building,getPlayerUID player]];
        };
        
    }else{
        if(claimAction < 0)then{
            claimAction = player addAction["Claime building",{ 
                _vars = _this select 3;
                (_vars select 0) setVariable["claimedTo",_vars select 1];  
            },[_building,getPlayerUID player]];
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