params["_building","_doorNo"/**/,"_dir","_pos"];

_doorRotPos = _building selectionPosition format["Door_%1_axis",_doorNo];
_doorTriPos = _building selectionPosition format["Door_%1_trigger",_doorNo];

_RotTriDis  = _doorRotPos distance2D _doorTriPos;

_doorRotX   = _doorRotPos select 0;
_doorTriX   = _doorTriPos select 0;

_doorRotY   = _doorRotPos select 1;
_doorTriY   = _doorTriPos select 1;

_posX       = _doorRotPos select 0;
_posY       = _doorRotPos select 1;
_posZ       = _doorTriPos select 2;

if(abs(_doorRotX - _doorTriX) > abs(_doorRotY - _doorTriY))then{
    _dir = "x";
}else{
    _dir = "y";
};

if(_dir == "x")then{
    if(_doorRotX > _doorTriX)then{
        _pos = [_posX,_posY,_posZ];
    }else{
        _pos = [_posX,_posY,_posZ];
    };
}else{
    if(_doorRotY > _doorTriY)then{
        _pos = [_posX,_posY,_posZ];
    }else{
        _pos = [_posX,_posY,_posZ];
    };
};

[_dir,_building modelToWorld [_doorTriPos select 0,_doorTriPos select 1,_posZ]]