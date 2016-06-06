barricadeAction = -1;
claimAction = -1;
declaimAction = -1;

buildBarricade = {
    _type   = _this select 0;
    _dir    = _this select 1;
    _pos    = _this select 2;
    systemChat format["%1, %2, %3",_type,_dir,_pos]; 
};


// Barricadable Positions Arrays


