private["_playerUnit","_noise","_noiseLevel","_surfaceName","_surfaceLevel","_stanceLevel","_speed"];
_playerUnit  = player;
_noise	= _this select 0;
_noiseLevel = 1;

if(vehicle _playerUnit == _playerUnit)then{
    // Player Position
    switch(stance _playerUnit)do{
        case "PRONE": {
            _stanceLevel = 1;
        };
        case "CROUCH": {
            _stanceLevel = 2;
        };
        case "STAND": {
            _stanceLevel = 3;
        };
        default {
            _stanceLevel = 1;
        };
    };

    _speedY	=  velocityModelSpace _playerUnit select 0;
    _speedX	=  velocityModelSpace _playerUnit select 1;
    if(_speedY >= _speedX)then{
        _speed = _speedY;
    }else{
        _speed = _speedX;
    };
    _speed = abs floor(3.6 * _speed);

    // Surfaces
    _type = surfaceType (getPosATL _playerUnit);
    _typeA = toArray _type;
    _typeA set [0,"DEL"];
    _typeA = _typeA - ["DEL"];
    _type = toString _typeA;
    _soundType = getText (configFile >> "CfgSurfaces" >> _type >> "soundEnviron");
    _soundVal = getArray (configFile >> "CfgVehicles" >> "CAManBase" >> "SoundEnvironExt" >> _soundType);

    _surfaceLevelBySpeed = 0;
    if(_speed == 1)then{
        _surfaceLevelBySpeed = 60;
    };
    if(_speed >= 2 && _speed <= 3)then{
        _surfaceLevelBySpeed = 44;
    };
    if(_speed == 4)then{
        _surfaceLevelBySpeed = 36;
    };
    if(_speed == 5)then{
        _surfaceLevelBySpeed = 52;
    };
    if(_surfaceLevelBySpeed > 0)then{
        if(isOnRoad _playerUnit)then{
            _surfaceLevel = 6;
        }else{
            _surfaceLevel = ((_soundVal select _surfaceLevelBySpeed) select 1) select 3;
            _surfaceLevel = _surfaceLevel/10;
        };
    }else{
        _surfaceLevel = 1;
    };

    // Calculate Noise
    _noiseLevel = round(_surfaceLevel * _stanceLevel * _speed);
    _noiseLevel = (_noiseLevel/64)*10;
    _noiseLevel = floor(_noiseLevel) * 10;

}else{
    _speed	=  abs floor(speed (vehicle _playerUnit));
    _noiseLevel = floor(100 + (_speed / 2));
    systemChat str (getAllSoundControllers (vehicle _playerUnit));
};

// Limitations cause GUI-Values
if(_noiseLevel < 0)then{
    _noiseLevel = 0;
};

if(_noiseLevel > 100)then{
    _noiseLevel = 100;
};

playerNoise = _noiseLevel;

[_playerUnit,getPos _playerUnit,_noiseLevel] remoteExec ["bde_fnc_receivePlayersNoise",2,false];

/*CAManBase_SoundEnvironExt_generic[] = {
    ["healself",["\A3\Sounds_F\characters\ingame\AinvPknlMstpSlayWrflDnon_medic",0.891251,1,20]],
    ["healselfprone",["\A3\Sounds_F\characters\ingame\AinvPpneMstpSlayWrflDnon_medic",0.891251,1,20]],
    ["healselfpistolkneelin",["\A3\Sounds_F\characters\ingame\AinvPknlMstpSlayWpstDnon_medicIn",0.891251,1,20]],
    ["healselfpistolkneel",["\A3\Sounds_F\characters\ingame\AinvPknlMstpSlayWpstDnon_medic",0.891251,1,20]],
    ["healselfpistolkneelout",["\A3\Sounds_F\characters\ingame\AinvPknlMstpSlayWpstDnon_medicOut",0.891251,1,20]],
    ["healselfpistolpromein",["\A3\Sounds_F\characters\ingame\AinvPpneMstpSlayWpstDnon_medicin",0.891251,1,20]],
    ["healselfpistolprone",["\A3\Sounds_F\characters\ingame\AinvPpneMstpSlayWpstDnon_medic",0.891251,1,20]],
    ["healselfpistolpromeout",["\A3\Sounds_F\characters\ingame\AinvPpneMstpSlayWpstDnon_medicOut",0.891251,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\concrete_roll_1",0.891251,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\concrete_roll_2",0.891251,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\concrete_roll_3",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_concrete_roll_1",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_concrete_roll_2",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_concrete_roll_3",0.891251,1,20]],
    ["adjust_short",["\A3\sounds_f\characters\stances\adjust_short1",0.158489,1,20]],
    ["adjust_short",["\A3\sounds_f\characters\stances\adjust_short2",0.158489,1,20]],
    ["adjust_short",["\A3\sounds_f\characters\stances\adjust_short3",0.158489,1,20]],
    ["adjust_short",["\A3\sounds_f\characters\stances\adjust_short4",0.158489,1,20]],
    ["adjust_short",["\A3\sounds_f\characters\stances\adjust_short5",0.158489,1,20]],
    ["adjust_stand_to_left_prone",["\A3\sounds_f\characters\stances\adjust_short1",0.158489,1,20]],
    ["adjust_stand_to_right_prone",["\A3\sounds_f\characters\stances\adjust_short1",0.158489,1,20]],
    ["adjust_kneelhigh_to_standlow",["\A3\sounds_f\characters\stances\adjust_short3",0.158489,1,20]],
    ["adjust_standlow_to_kneelhigh",["\A3\sounds_f\characters\stances\adjust_short1",0.158489,1,20]],
    ["over_the_obstacle_slow",["\A3\sounds_f\characters\movements\over_the_obstacle_slow",0.316228,1,20]],
    ["over_the_obstacle_fast",["\A3\sounds_f\characters\movements\over_the_obstacle_fast",0.316228,1,20]],
    ["grenade_throw",["\A3\sounds_f\characters\stances\grenade_throw1",0.354813,1,20]],
    ["grenade_throw",["\A3\sounds_f\characters\stances\grenade_throw2",0.354813,1,20]],
    ["inventory_in",["\A3\sounds_f\characters\stances\adjust_short1",0.251189,1,20]],
    ["inventory_out",["\A3\sounds_f\characters\stances\adjust_short2",0.251189,1,20]],
    ["handgun_to_rifle",["\A3\Sounds_F\characters\stances\handgun_to_rifle",1,1,20]],
    ["handgun_to_launcher",["\A3\sounds_f\characters\stances\handgun_to_launcher",1,1,20]],
    ["launcher_to_rifle",["\A3\sounds_f\characters\stances\launcher_to_rifle",1,1,20]],
    ["launcher_to_handgun",["\A3\sounds_f\characters\stances\launcher_to_handgun",1,1,20]],
    ["rifle_to_handgun",["\A3\Sounds_F\characters\stances\rifle_to_handgun",1,1,20]],
    ["rifle_to_handgun_prn",["\A3\Sounds_F\characters\stances\rifle_to_handgun_prn",1,1,20]],
    ["rifle_to_launcher",["\A3\sounds_f\characters\stances\rifle_to_launcher",1,1,20]],
    ["rifle_to_binoc",["\A3\sounds_f\characters\stances\rifle_to_binoculars",1,1,20]],
    ["handgun_to_binoc",["\A3\sounds_f\characters\stances\handgun_to_binoculars",1,1,20]],
    ["launcher_to_binoc",["\A3\sounds_f\characters\stances\launcher_to_binoculars",1,1,20]],
    ["launcher_to_binoc_knl",["\A3\sounds_f\characters\stances\launcher_to_binoculars_knl",1,1,20]],
    ["unarmed_to_binoc",["\A3\sounds_f\characters\stances\unarmed_to_binoculars",1,1,20]],
    ["binoc_to_rifle",["\A3\sounds_f\characters\stances\binoculars_to_rifle",1,1,20]],
    ["binoc_to_rifle_2",["\A3\sounds_f\characters\stances\binoculars_to_rifle_2",1,1,20]],
    ["binoc_to_handgun",["\A3\sounds_f\characters\stances\binoculars_to_handgun",1,1,20]],
    ["binoc_to_launcher",["\A3\sounds_f\characters\stances\binoculars_to_launcher",1,1,20]],
    ["binoc_to_unarmed",["\A3\sounds_f\characters\stances\binoculars_to_unarmed",1,1,20]],
    ["low_rifle",["A3\sounds_f\characters\stances\low_rifle",0.501187,1,20]],
    ["lift_rifle",["A3\sounds_f\characters\stances\lift_rifle",0.501187,1,20]],
    ["low_handgun",["A3\sounds_f\characters\stances\low_handgun",0.501187,1,20]],
    ["lift_handgun",["A3\sounds_f\characters\stances\lift_handgun",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_01",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_02",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_03",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_04",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_05",0.501187,1,20]],
    ["ladder",["\A3\Sounds_F\characters\movements\ladder\ladder_06",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_1",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_2",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_3",0.501187,1,20]],
    ["Acts_CrouchGetLowGesture",["\A3\Sounds_F\characters\cutscenes\Acts_CrouchGetLowGesture",0.891251,1,20]],
    ["Acts_listeningToRadio_in",["A3\Sounds_F\characters\cutscenes\Acts_listeningToRadio_in",0.891251,1,20]],
    ["Acts_listeningToRadio_Loop",["\A3\Sounds_F\dummysound",0.891251,1,20]],
    ["Acts_listeningToRadio_Out",["\A3\Sounds_F\characters\cutscenes\Acts_listeningToRadio_Out",0.891251,1,20]],
    ["Acts_LyingWounded_loop1",["\A3\Sounds_F\characters\cutscenes\Acts_LyingWounded_loop1",0.891251,1,20]],
    ["Acts_LyingWounded_loop2",["\A3\Sounds_F\characters\cutscenes\Acts_LyingWounded_loop2",0.891251,1,20]],
    ["Acts_LyingWounded_loop3",["\A3\Sounds_F\characters\cutscenes\Acts_LyingWounded_loop3",0.891251,1,20]],
    ["Acts_NavigatingChopper_In",["\A3\Sounds_F\characters\cutscenes\Acts_NavigatingChopper_In",0.562341,1,20]],
    ["Acts_NavigatingChopper_Loop",["\A3\Sounds_F\characters\cutscenes\Acts_NavigatingChopper_Loop",0.562341,1,20]],
    ["Acts_NavigatingChopper_Out",["\A3\Sounds_F\characters\cutscenes\Acts_NavigatingChopper_Out",0.562341,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup1",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup1",0.562341,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup1b",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup1b",0.562341,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup1c",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup1c",0.562341,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup2",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup2",0.562341,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup2b",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup2b",0.891251,1,20]],
    ["Acts_PercMstpSlowWrflDnon_handup2c",["\A3\Sounds_F\characters\cutscenes\Acts_PercMstpSlowWrflDnon_handup2c",0.562341,1,20]],
    ["Acts_SignalToCheck",["\A3\Sounds_F\characters\cutscenes\Acts_SignalToCheck",0.562341,1,20]],
    ["Acts_ShowingTheRightWay_in",["\A3\Sounds_F\characters\cutscenes\Acts_ShowingTheRightWay_in",0.562341,1,20]],
    ["Acts_ShowingTheRightWay_loop",["\A3\Sounds_F\characters\cutscenes\Acts_ShowingTheRightWay_Loop",0.562341,1,20]],
    ["Acts_ShowingTheRightWay_out",["\A3\Sounds_F\characters\cutscenes\Acts_ShowingTheRightWay_Out",0.562341,1,20]],
    ["Acts_ShieldFromSun_loop",["\A3\Sounds_F\dummysound",0.562341,1,20]],
    ["Acts_ShieldFromSun_out",["\A3\Sounds_F\characters\cutscenes\Acts_ShieldFromSun_Out",0.562341,1,20]],
    ["Acts_TreatingWounded01",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded01",0.562341,1,20]],
    ["Acts_TreatingWounded02",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded02",0.562341,1,20]],
    ["Acts_TreatingWounded03",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded03",0.562341,1,20]],
    ["Acts_TreatingWounded04",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded04",0.562341,1,20]],
    ["Acts_TreatingWounded05",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded05",0.562341,1,20]],
    ["Acts_TreatingWounded06",["\A3\Sounds_F\characters\cutscenes\Acts_TreatingWounded06",0.562341,1,20]],
    ["Acts_AidlPercMstpSlowWrflDnon_pissing",["\A3\Sounds_F\characters\cutscenes\Acts_AidlPercMstpSlowWrflDnon_pissing",0.891251,1,20]],
    ["Acts_BoatAttacked01",["\A3\Sounds_F\characters\cutscenes\Acts_BoatAttacked01",0.891251,1,20]],
    ["Acts_BoatAttacked02",["\A3\Sounds_F\characters\cutscenes\Acts_BoatAttacked02",0.891251,1,20]],
    ["Acts_BoatAttacked03",["\A3\Sounds_F\characters\cutscenes\Acts_BoatAttacked03",0.891251,1,20]],
    ["Acts_BoatAttacked04",["\A3\Sounds_F\characters\cutscenes\Acts_BoatAttacked04",0.891251,1,20]],
    ["Acts_BoatAttacked05",["\A3\Sounds_F\characters\cutscenes\Acts_BoatAttacked05",0.891251,1,20]],
    ["acts_CrouchingCoveringRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_CrouchingCoveringRifle01",0.562341,1,20]],
    ["acts_CrouchingIdleRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_CrouchingIdleRifle01",0.562341,1,20]],
    ["acts_CrouchingReloadingRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_CrouchingReloadingRifle01",0.562341,1,20]],
    ["acts_CrouchingWatchingRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_CrouchingWatchingRifle01",0.562341,1,20]],
    ["acts_InjuredAngryRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredAngryRifle01",0.562341,1,20]],
    ["acts_InjuredCoughRifle02",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredCoughRifle02",0.562341,1,20]],
    ["acts_InjuredLookingRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLookingRifle01",0.562341,1,20]],
    ["acts_InjuredLookingRifle02",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLookingRifle02",0.562341,1,20]],
    ["acts_InjuredLookingRifle03",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLookingRifle03",0.562341,1,20]],
    ["acts_InjuredLookingRifle04",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLookingRifle04",0.562341,1,20]],
    ["acts_InjuredLookingRifle05",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLookingRifle05",0.562341,1,20]],
    ["acts_InjuredLyingRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredLyingRifle01",0.562341,1,20]],
    ["acts_InjuredSpeakingRifle01",["\A3\Sounds_F\characters\cutscenes\Acts_InjuredSpeakingRIfle01",0.562341,1,20]],
    ["Acts_PknlMstpSlowWrflDnon",["\A3\Sounds_F\characters\cutscenes\Acts_PknlMstpSlowWrflDnon",0.562341,1,20]],
    ["Acts_SittingJumpingSaluting_loop1",["\A3\Sounds_F\characters\cutscenes\Acts_SittingJumpingSaluting_loop1",0.562341,1,20]],
    ["Acts_SittingJumpingSaluting_loop2",["\A3\Sounds_F\characters\cutscenes\Acts_SittingJumpingSaluting_loop2",0.562341,1,20]],
    ["Acts_SittingJumpingSaluting_loop3",["\A3\Sounds_F\characters\cutscenes\Acts_SittingJumpingSaluting_loop3",0.562341,1,20]],
    ["AmovPercMstpSnonWnonDnon_exercisekneeBendA",["\A3\Sounds_F\characters\cutscenes\AmovPercMstpSnonWnonDnon_exercisekneeBendA",0.562341,1,20]]
};*/
