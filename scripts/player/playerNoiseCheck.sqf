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

    _speed	=  abs floor(speed (vehicle _playerUnit));

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

};/*else{
    _noiseLevel = 100; //vehicle _playerUnit getSoundController "thrust";
    systemChat str (getAllSoundControllers (vehicle _playerUnit));
};*/

// Limitations cause GUI-Values
if(_noiseLevel < 0)then{
    _noiseLevel = 0;
};

if(_noiseLevel > 100)then{
    _noiseLevel = 100;
};

playerNoise = _noiseLevel;

// TODO send noise to zombie server
{
    _zombie = _x;
    if(_playerUnit distance _zombie < _noiseLevel)then{
        _zombie setVariable["lastPlayerHeard",getPos _playerUnit,true];
    };
}forEach (units groupZ);

/*["adjust_stand_side",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side1",0.251189,1,20]],
    ["adjust_stand_side",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side2",0.251189,1,20]],
    ["adjust_stand_side",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side3",0.251189,1,20]],
    ["adjust_stand_to_kneel",["\A3\sounds_f\characters\stances\concrete_adjust_stand_to_kneel1",0.251189,1,20]],
    ["adjust_stand_to_kneel",["\A3\sounds_f\characters\stances\concrete_adjust_stand_to_kneel2",0.251189,1,20]],
    ["adjust_kneel_to_stand",["\A3\sounds_f\characters\stances\concrete_adjust_kneel_to_stand1",0.251189,1,20]],
    ["adjust_kneel_to_stand",["\A3\sounds_f\characters\stances\concrete_adjust_kneel_to_stand2",0.251189,1,20]],
    ["adjust_stand_to_prone",["\A3\sounds_f\characters\stances\concrete_adjust_stand_to_prone",0.251189,1,20]],
    ["adjust_prone_to_stand",["\A3\sounds_f\characters\stances\concrete_adjust_prone_to_stand",0.251189,1,20]],
    ["adjust_prone_up",["\A3\sounds_f\characters\stances\concrete_adjust_prone_up",0.251189,1,20]],
    ["adjust_prone_up_back",["\A3\sounds_f\characters\stances\concrete_adjust_prone_up_back",0.251189,1,20]],
    ["adjust_prone_down",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side1",0.251189,1,20]],
    ["adjust_prone_down",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side2",0.251189,1,20]],
    ["adjust_prone_down",["\A3\sounds_f\characters\stances\concrete_adjust_stand_side3",0.251189,1,20]],
    ["adjust_prone_left",["\A3\sounds_f\characters\stances\concrete_adjust_prone_left",0.251189,1,20]],
    ["adjust_prone_right",["\A3\sounds_f\characters\stances\concrete_adjust_prone_right",0.251189,1,20]],
    ["adjust_kneel_to_prone",["\A3\sounds_f\characters\stances\concrete_adjust_kneel_to_prone",0.251189,1,20]],
    ["adjust_prone_to_kneel",["\A3\sounds_f\characters\stances\concrete_adjust_prone_to_kneel",0.251189,1,20]],
    ["adjust_stand_to_left_prone",["\A3\sounds_f\characters\stances\concrete_adjust_stand_to_left_prone",0.251189,1,20]],
    ["adjust_stand_to_right_prone",["\A3\sounds_f\characters\stances\concrete_adjust_stand_to_right_prone",0.251189,1,20]],
    ["adjust_left_prone_to_stand",["\A3\sounds_f\characters\stances\concrete_adjust_left_prone_to_stand",0.251189,1,20]],
    ["adjust_right_prone_to_stand",["\A3\sounds_f\characters\stances\concrete_adjust_right_prone_to_stand",0.251189,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\dirt_roll_1",0.891251,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\dirt_roll_2",0.891251,1,20]],
    ["roll",["A3\Sounds_F\characters\movements\roll\dirt_roll_3",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_dirt_roll_1",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_dirt_roll_1",0.891251,1,20]],
    ["roll_unarmed",["A3\Sounds_F\characters\movements\roll\unarmed_dirt_roll_1",0.891251,1,20]],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_1",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_2",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_3",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_4",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_5",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_6",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_7",0.501187,1,20],
    ["\A3\sounds_f\characters\footsteps\dirt_walk_new_8",0.501187,1,20],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_1",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_2",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_3",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_4",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_5",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_6",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_7",0.501187,1,45]],
    ["run",["\A3\sounds_f\characters\footsteps\dirt_run_new_8",0.501187,1,45]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_1",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_2",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_3",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_4",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_5",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_6",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_7",0.501187,1,20]],
    ["walk",["\A3\sounds_f\characters\footsteps\dirt_walk_new_8",0.501187,1,20]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_1",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_2",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_3",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_4",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_5",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_6",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_7",0.501187,1,55]],
    ["sprint",["\A3\sounds_f\characters\footsteps\dirt_sprint_new_8",0.501187,1,55]],
    ["crawl",["\A3\sounds_f\characters\crawl\dirt_crawl_1",0.223872,1,20]],
    ["crawl",["\A3\sounds_f\characters\crawl\dirt_crawl_2",0.223872,1,20]],
    ["crawl",["\A3\sounds_f\characters\crawl\dirt_crawl_3",0.223872,1,20]],
    ["crawl",["\A3\sounds_f\characters\crawl\dirt_crawl_4",0.223872,1,20]],
    ["crawl",["\A3\sounds_f\characters\crawl\dirt_crawl_5",0.223872,1,20]],
    ["laydown",["\A3\Sounds_F\characters\movements\laydown\dirt_laydown_1",0.501187,1,20]],
    ["laydown",["\A3\Sounds_F\characters\movements\laydown\dirt_laydown_2",0.501187,1,20]],
    ["bodyfall",["A3\sounds_F\dummysound",0.501187,1,20]],
    ["bodyfall",["A3\sounds_F\dummysound",0.501187,1,20]],
    ["bodyfall",["A3\sounds_F\dummysound",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_1",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_2",0.501187,1,20]],
    ["swim",["A3\Sounds_F\characters\movements\swim_3",0.501187,1,20]],
    ["Acts_carFixingWheel",["A3\Sounds_F\characters\cutscenes\dirt_Acts_carFixingWheel",0.562341,1,20]],
    ["Acts_PercMwlkSlowWrflDf",["A3\Sounds_F\characters\cutscenes\dirt_Acts_PercMwlkSlowWrflDf",0.562341,1,20]],
    ["Acts_PercMwlkSlowWrflDf2",["A3\Sounds_F\characters\cutscenes\dirt_Acts_PercMwlkSlowWrflDf2",0.562341,1,20]],
    ["Acts_SittingJumpingSaluting_out",["A3\Sounds_F\characters\cutscenes\dirt_Acts_SittingJumpingSaluting_out",0.562341,1,20]],
    ["Acts_WalkingChecking",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WalkingChecking",0.562341,1,20]],
    ["Acts_CrouchingFiringLeftRifle02",["A3\Sounds_F\characters\cutscenes\dirt_Acts_CrouchingFiringLeftRifle02",0.562341,1,20]],
    ["Acts_CrouchingFiringLeftRifle03",["A3\Sounds_F\characters\cutscenes\dirt_Acts_CrouchingFiringLeftRifle03",0.562341,1,20]],
    ["Acts_CrouchingFiringLeftRifle04",["A3\Sounds_F\characters\cutscenes\dirt_Acts_CrouchingFiringLeftRifle04",0.562341,1,20]],
    ["Acts_HUBABriefing",["A3\Sounds_F\characters\cutscenes\dirt_Acts_HUBABriefing",0.562341,1,20]],
    ["Acts_PointingLeftUnarmed",["A3\Sounds_F\characters\cutscenes\dirt_Acts_PointingLeftUnarmed",0.562341,1,20]],
    ["Acts_SittingJumpingSaluting_in",["A3\Sounds_F\characters\cutscenes\dirt_Acts_SittingJumpingSaluting_in",0.562341,1,20]],
    ["Acts_StandingSpeakingUnarmed",["A3\Sounds_F\characters\cutscenes\dirt_Acts_StandingSpeakingUnarmed",0.562341,1,20]],
    ["Acts_TreatingWounded_in",["A3\Sounds_F\characters\cutscenes\dirt_Acts_TreatingWounded_in",0.562341,1,20]],
    ["Acts_TreatingWounded_out",["A3\Sounds_F\characters\cutscenes\dirt_Acts_TreatingWounded_out",0.562341,1,20]],
    ["Acts_UnconsciousStandUp_part1",["A3\Sounds_F\characters\cutscenes\dirt_Acts_UnconsciousStandUp_part1",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_1",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_1",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_1b",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_1b",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_2",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_2",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_3",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_3",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_4",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_4",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_5",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_5",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_AIWalk_6",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_AIWalk_6",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_1",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_1",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_2",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_2",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_3",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_3",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_4",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_4",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_5",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_5",0.562341,1,20]],
    ["Acts_WelcomeOnHUB01_PlayerWalk_6",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB01_PlayerWalk_6",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk_2",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk_2",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk_3",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk_3",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk_4",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk_4",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk_5",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk_5",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_AIWalk_6",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_AIWalk_6",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_PlayerWalk_1",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_PlayerWalk_1",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_PlayerWalk_2",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_PlayerWalk_2",0.562341,1,20]],
    ["Acts_WelcomeOnHUB02_PlayerWalk_3",["A3\Sounds_F\characters\cutscenes\dirt_Acts_WelcomeOnHUB02_PlayerWalk_3",0.562341,1,20]],
    ["AmovPercMstpSnonWnonDnon_exercisePushup",["\A3\Sounds_F\characters\cutscenes\dirt_AmovPercMstpSnonWnonDnon_exercisePushup",0.562341,1,20]]
*/
