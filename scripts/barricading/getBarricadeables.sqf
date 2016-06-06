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
                _closestPointDist = (position player) distance _x
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
            
        }forEach ([_building] call _findBarricadables);
        
        if(declaimAction < 0)then{
            declaimAction = player addAction["Declaime building",{ 
                _vars = _this select 3;
                (_vars select 0) setVariable["claimedTo",""];  
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
                (_vars select 0) setVariable["claimedTo",_vars select 1];  
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

_findBarricadables = {
    private ["_model_pos","_world_pos","_armor","_cfg_entry","_veh","_house","_window_pos_arr","_cfgHitPoints","_cfgDestEff","_brokenGlass","_selection_name"];

    _house = _this select 0;

    _window_pos_arr = [];
    _cfgHitPoints = (configFile >> "cfgVehicles" >> (typeOf _house) >> "HitPoints");
    for "_i" from 0 to count _cfgHitPoints - 1 do 
    {
        _cfg_entry = _cfgHitPoints select _i;

        if (isClass _cfg_entry) then
        {
            _armor = getNumber (_cfg_entry / "armor");

            if (_armor < 0.5) then
            {
                _cfgDestEff = (_cfg_entry / "DestructionEffects");
                _brokenGlass = _cfgDestEff select 0;
                _selection_name = getText (_brokenGlass / "position");
                _model_pos = _house selectionPosition _selection_name;
                _world_pos = _house modelToWorld _model_pos;
                _window_pos_arr set [count _window_pos_arr, _world_pos];
            };
        };
    }; 

    /*{ 
        veh = createVehicle ["Sign_Sphere100cm_F", _x, [], 0, "none"];
        _veh setObjectTexture [0,'#(argb,8,8,3)color(0.55,0,0.1,1)'];
        _veh setPosATL _x;     
    } foreach _window_pos_arr;*/
    
    _window_pos_arr
};
