bde_fnc_say3d = { // [_sayobject,_audioclip,_maxdistance,_audiopitch] remoteExec ["bde_fnc_say3d",0,false];
    if(!isDedicated)then{
        _sayobject      = _this select 0;
        _audioclip      = _this select 1;
        _maxdistance    = _this select 2;

        _sayobject say3D [_audioclip, _maxdistance, random(2)];
    };
};

// Burn Dead Z
bde_fnc_addBurnAction = {
    _targetObject = _this select 0;
    burnAction = _targetObject addAction [ "Burn dead body", {
        _targetObject = _this select 0;
        _caller = _this select 1;
        if(("jii_zippo" in Magazines _caller || (rain < 0.2 && "jii_matches" in Magazines _caller))/* && "jii_fuelcan" in Magazines _caller*/)then{
            [_targetObject] remoteExec ["bde_fnc_removeBurnAction",0,false];
            [_targetObject] remoteExec ["fnc_burnDeadZ",0,false];
        };
    },[],6,true,true,"","_target distance _this < 4"];
};

bde_fnc_removeBurnAction = {
    _targetObject = _this select 0;
    _targetObject removeAction burnAction;
};