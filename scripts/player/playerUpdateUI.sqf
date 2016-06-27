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
1211 = Noise
1212 = Noise Value
*/

disableSerialization;

_playerUnit         = player;

// current values
_hungerVal          = playerHunger;
_thirstVal          = playerThirst;
_healthVal          = playerHealth;
_temperatureVal     = playerTemperature;
_wetVal             = playerWet;
_sickVal            = playerSick;
_infectedVal        = playerInfected;

// current blink status
_hungerBlink        = false;
_thirstBlink        = false;
_healthBlink        = false;
_temperatureBlink   = false;
_wetBlink           = false;
_sickBlink          = false;
_infectedBlink      = false;

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

_namespaceUI = uiNamespace getVariable "bde_gui_display";

// "infected"
_uiInfectedVal = _infectedVal/2;
_ctrlInfected = _namespaceUI displayCtrl 1200;

// "sick"
_uiSickVal = _sickVal/2;
_ctrlSick = _namespaceUI displayCtrl 1201;

// "wet"
_uiWetVal = _wetVal/2;
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
_ctrlNoise = _namespaceUI displayCtrl 1212;
_ctrlNoise ctrlSetText "images\gui\inner\gui_noise_inner_" + (str playerNoise) + ".paa";

if(lastUIBlinkCheck - time > 1)then{
    // Indicators
    if(_infectedVal > 0.8)then{
        if(_infectedBlink)then{
            _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,0.2];
            _infectedBlink = false;
        }else{
            _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,1];
            _infectedBlink = true;
        };
    }else{
        _ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,1];
    };

    if(_sickVal > 0.8)then{
        if(_sickBlink)then{
            _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,0.2];
            _sickBlink = false;
        }else{
            _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,1];
            _sickBlink = false;
        };
    }else{
        _ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,1];
    };

    if(_wetVal > 0.8)then{
        if(_wetBlink)then{
            _ctrlWet ctrlSetTextColor [1,1 - _uiWetVal,1 - _uiWetVal,0.2];
            _wetBlink = false;
        }else{
            _ctrlWet ctrlSetTextColor [1,1 - _uiWetVal,1 - _uiWetVal,1];
            _wetBlink = false;
        };
    }else{
        _ctrlWet ctrlSetTextColor [1,1 - _uiWetVal,1 - _uiWetVal,1];
    };

    // Values
    if(_temperatureVal < 20)then{
        if(_temperatureBlink)then{
            _ctrlTemperature ctrlSetTextColor [1,1,1,0.2];
            _temperatureBlink = false;
        }else{
            _ctrlTemperature ctrlSetTextColor [1,1,1,1];
            _temperatureBlink = false;
        };
    }else{
        _ctrlTemperature ctrlSetTextColor [1,1,1,1];
    };

    if(_healthVal < 20)then{
        if(_healthBlink)then{
            _ctrlHealth ctrlSetTextColor [1,1,1,0.2];
            _healthBlink = false;
        }else{
            _ctrlHealth ctrlSetTextColor [1,1,1,1];
            _healthBlink = false;
        };
    }else{
        _ctrlHealth ctrlSetTextColor [1,1,1,1];
    };

    if(_hungerVal < 20)then{
        if(_hungerBlink)then{
            _ctrlHunger ctrlSetTextColor [1,1,1,0.2];
            _hungerBlink = false;
        }else{
            _ctrlHunger ctrlSetTextColor [1,1,1,1];
            _hungerBlink = false;
        };
    }else{
        _ctrlHunger ctrlSetTextColor [1,1,1,1];
    };

    if(_thirstVal < 20)then{
        if(_thirstBlink)then{
            _ctrlThirst ctrlSetTextColor [1,1,1,0.2];
            _thirstBlink = false;
        }else{
            _ctrlThirst ctrlSetTextColor [1,1,1,1];
            _thirstBlink = false;
        };
    }else{
        _ctrlThirst ctrlSetTextColor [1,1,1,1];
    };

    if(_hungerVal < 20)then{
        if(_hungerBlink)then{
            _ctrlHunger ctrlSetTextColor [1,1,1,0.2];
            _hungerBlink = false;
        }else{
            _ctrlHunger ctrlSetTextColor [1,1,1,1];
            _hungerBlink = false;
        };
    }else{
        _ctrlHunger ctrlSetTextColor [1,1,1,1];
    };
    lastUIBlinkCheck = time;
};
