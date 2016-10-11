params["_building","_doorNo"/**/,"_dir","_pos"];

_doorRotPos = _building selectionPosition format["Door_%1_rot",_doorNo];
_doorTriPos = _building selectionPosition format["Door_%1_trigger",_doorNo];

_doorRotX   = _doorRotPos select 0;
_doorTriX   = _doorTriPos select 0;

_doorRotY   = _doorRotPos select 1;
_doorTriY   = _doorTriPos select 1;

if(abs(_doorRotX - _doorTriX) > abs(_doorRotY - _doorTriY))then{
    _dir = "x";
}else{
    _dir = "y";
};

if(_dir == "x")then{

}else{

};

[_dir,_pos]