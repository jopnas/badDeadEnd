// https://forums.bistudio.com/topic/159352-set-a-unit-to-look-out-of-window-function/?p=2499831
private["_canBarricade","_actionAdded"];
_isInside = _this select 0;
_building = _this select 1;

_canBarricade = false;
if(_isInside)then{
    _claimedTo = _building getVariable["claimedTo",""];

    if(_claimedTo == getPlayerUID player)then{

        {
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

            if(!_actionAdded)then{
                _actionAdded = true;
                barricadeAction = player addAction["Create Barricade Element",{
                    barricade = createVehicle ["Land_Pallet_vertical_F",position player,[],0,"can_collide"];
                    isBarricading = true;
                    barricade setDir (getDir player);
                    barricade attachTo [player, [0,2,2]];

                    raiseBarricade = player addAction ["Raise Barricade", {
                        _curPos = getPosATL barricade;
                        barricade setPosATL [_curPos select 0,_curPos select 1,(_curPos select 2) + 0.1];
                    },"",6,true,false,"",""];

                    lowerBarricade = player addAction ["Lower Barricade", {
                        _curPos = getPosATL barricade;
                        barricade setPosATL [_curPos select 0,_curPos select 1,(_curPos select 2) - 0.1];
                    },"",6,true,false,"",""];

                    cancleBarricading = player addAction ["Cancle Barricading", {
                        deleteVehicle barricade;
                        barricade = nil;
                    },"",6,true,false,"",""];

                    releaseBarricade = player addAction ["Release Barricade", {
                        detach barricade;
                        barricade = nil;
                    },"",6,true,false,"",""];

                },"",6,true,false,"",""];
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
