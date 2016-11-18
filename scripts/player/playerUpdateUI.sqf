/*
Boolean
1200 = Infected
1201 = Sick
1202 = Wet
Float
1203 = Temperature
1204 = Temperature Value
1205 = Health
1206 = Health Value
1207 = Thirst
1208 = Thirst Value
1209 = Hunger
1210 = Hunger Value
1211 = Poisoning
1212 = Poisoning Value
1213 = Radiation
1214 = Radiation Value
*/

disableSerialization;

_playerUnit         = player;

// current values
_hungerVal       = _playerUnit getVariable ["playerHunger",100];
_thirstVal       = _playerUnit getVariable ["playerThirst",100];
_healthVal       = _playerUnit getVariable ["playerHealth",100];
_temperatureVal  = _playerUnit getVariable ["playerTemperature",100];
_wetVal          = _playerUnit getVariable ["playerWet",0];
_sickVal         = _playerUnit getVariable ["playerSick",0];
_infectedVal     = _playerUnit getVariable ["playerInfected",0];
_poisoningVal    = _playerUnit getVariable ["playerPoisoning",0];
_radiationVal    = _playerUnit getVariable ["playerRadiation",0];

// Max.-/Min. Values
if(_hungerVal>100)then{
	_hungerVal = 100;
};
if(_thirstVal>100)then{
	_thirstVal = 100;
};
if(_healthVal>100)then{
	_healthVal = 100;
};
if(_temperatureVal>100)then{
	_temperatureVal = 100;
};
if(_poisoningVal>100)then{
	_poisoningVal = 100;
};

if(_radiationVal>100)then{
	_radiationVal = 100;
};

if(_hungerVal<0)then{
	_hungerVal = 0;
};
if(_thirstVal<0)then{
	_thirstVal = 0;
};
if(_healthVal<0)then{
	_healthVal = 0;
};
if(_temperatureVal<0)then{
	_temperatureVal = 0;
};
if(_poisoningVal<0)then{
	_poisoningVal = 0;
};

if(_radiationVal<0)then{
	_radiationVal = 0;
};


_namespaceUI = uiNamespace getVariable "bde_gui_display";

// "infected"
_uiInfectedVal = (_infectedVal/100) / 2;
_ctrlInfected = _namespaceUI displayCtrl 1200;

// "sick"
_uiSickVal = (_sickVal/100) / 2;
_ctrlSick = _namespaceUI displayCtrl 1201;

// "wet"
_uiWetVal =  (_wetVal/100) / 2;
_ctrlWet = _namespaceUI displayCtrl 1202;

// "temperature"
_ctrlTemperatureIcon = _namespaceUI displayCtrl 1203;
_ctrlTemperature = _namespaceUI displayCtrl 1204;
_ctrlTemperature ctrlSetText "images\gui\val_" + str ( floor(_temperatureVal/10)*10 ) + ".paa";

// "health"
_ctrlHealthIcon = _namespaceUI displayCtrl 1205;
_ctrlHealth = _namespaceUI displayCtrl 1206;
_ctrlHealth ctrlSetText "images\gui\val_" + str ( floor(_healthVal/10)*10 ) + ".paa";

// "thirst"
_ctrlThirstIcon = _namespaceUI displayCtrl 1207;
_ctrlThirst = _namespaceUI displayCtrl 1208;
_ctrlThirst ctrlSetText "images\gui\val_" + str ( floor(_thirstVal/10)*10 ) + ".paa";

// "hunger"
_ctrlHungerIcon = _namespaceUI displayCtrl 1209;
_ctrlHunger = _namespaceUI displayCtrl 1210;
_ctrlHunger ctrlSetText "images\gui\val_" + str ( floor(_hungerVal/10)*10 ) + ".paa";

// "noise"
//systemChat str playerNoise;
//_ctrlNoise = _namespaceUI displayCtrl 1212;
//_ctrlNoise ctrlSetText "images\gui\val_" + str ( floor(playerNoise/10)*10 ) + ".paa";

_ctrlPoisoningIcon = _namespaceUI displayCtrl 1211;
_ctrlPoisoning = _namespaceUI displayCtrl 1212;
_ctrlPoisoning ctrlSetText "images\gui\val_" + str ( floor(_poisoningVal/10)*10 ) + ".paa";

if(guiBlink)then{
    guiBlink = false;
}else{
    guiBlink = true;
};
// Indicators
if(_infectedVal > 80)then{
    if(guiBlink)then{
        _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,0];
    }else{
        _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,1];
    };
}else{
    _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,1];
};

if(_sickVal > 80)then{
    if(guiBlink)then{
        _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,0];
    }else{
        _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,1];
    };
}else{
    _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,1];
};

if(_wetVal > 80)then{
    if(guiBlink)then{
        _ctrlWet ctrlSetTextColor [1 - _uiWetVal,1 - _uiWetVal,1,0];
    }else{
        _ctrlWet ctrlSetTextColor [1 - _uiWetVal,1 - _uiWetVal,1,1];
    };
}else{
    _ctrlWet ctrlSetTextColor [1 - _uiWetVal,1 - _uiWetVal,1,1];
};

// Values
if(_temperatureVal < 20)then{
    if(guiBlink)then{
        _ctrlTemperatureIcon ctrlSetTextColor [0.5,0.5,1,0.2];
    }else{
        _ctrlTemperatureIcon ctrlSetTextColor [0.5,0.5,1,1];
    };
}else{
    _ctrlTemperatureIcon ctrlSetTextColor [1,1,1,1];
};

if(_healthVal < 20)then{
    if(guiBlink)then{
        _ctrlHealthIcon ctrlSetTextColor [1,0.5,0.5,0.2];
    }else{
        _ctrlHealthIcon ctrlSetTextColor [1,0.5,0.5,1];
    };
}else{
    _ctrlHealthIcon ctrlSetTextColor [1,1,1,1];
};

if(_thirstVal < 20)then{
    if(guiBlink)then{
        _ctrlThirstIcon ctrlSetTextColor [1,1,1,0.2];
    }else{
        _ctrlThirstIcon ctrlSetTextColor [1,1,1,1];
    };
}else{
    _ctrlThirstIcon ctrlSetTextColor [1,1,1,1];
};

if(_hungerVal < 20)then{
    if(guiBlink)then{
        _ctrlHungerIcon ctrlSetTextColor [1,1,1,0.2];
    }else{
        _ctrlHungerIcon ctrlSetTextColor [1,1,1,1];
    };
}else{
    _ctrlHungerIcon ctrlSetTextColor [1,1,1,1];
};

if(_poisoningVal > 80)then{
    if(guiBlink)then{
        _ctrlPoisoningIcon ctrlSetTextColor [1,1,1,0.2];
    }else{
        _ctrlPoisoningIcon ctrlSetTextColor [1,1,1,1];
    };
}else{
    _ctrlPoisoningIcon ctrlSetTextColor [1,1,1,1];
};
