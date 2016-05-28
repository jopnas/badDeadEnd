private["_calcNoiseLevel"];
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

_playerUnit     = player;

_hungerVal      = playerHunger;
_thirstVal      = playerThirst;
_healthVal      = playerHealth;
_temperatureVal = playerTemperature;
_wetVal         = playerWet;
_sickVal        = playerSick;
_infectedVal    = playerInfected;

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
	_ctrlInfected ctrlSetTextColor [1,1 - _uiInfectedVal,1 - _uiInfectedVal,1];
	
    // "sick"
    _uiSickVal = _sickVal/2;
	_ctrlSick = _namespaceUI displayCtrl 1201;
	_ctrlSick ctrlSetTextColor [1,1 - _uiSickVal,1 - _uiSickVal,1];

    // "wet"
    _uiWetVal = _wetVal/2;
	_ctrlWet = _namespaceUI displayCtrl 1202;
	_ctrlWet ctrlSetTextColor [1,1 - _uiWetVal,1 - _uiWetVal,1];

    // "temperature"
	_ctrlTemperatureIcon = _namespaceUI displayCtrl 1203;
	_ctrlTemperature = _namespaceUI displayCtrl 1204;
	_ctrlTemperature ctrlSetText "images\gui\val_" + str ( floor(_temperatureVal/10)*10 ) + ".paa";
    _tempVal = 1-((_temperatureVal/3) / 100);
    _ctrlTemperatureIcon ctrlSetTextColor [1-_tempVal,1-_tempVal,1,1];

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
	_ctrlNoise ctrlSetText "images\gui\inner\gui_noise_inner_" + str ( playerNoise ) + ".paa";
