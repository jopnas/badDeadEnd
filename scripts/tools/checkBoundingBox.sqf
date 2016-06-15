private["_bboxObject","_notBuilding","_checkObj","_result","_canEnter","_debug"];
_bboxObject     = _this select 0;
_checkObj 	    = _this select 1;
_notBuilding    = _this select 2;
_debug          = _this select 3;

_result = false;

if(_notBuilding)then{
    _canEnter = true;
}else{
    _canEnter = [_bboxObject] call BIS_fnc_isBuildingEnterable;
};

_offset     = 1;
_pPos       = _bboxObject worldToModel (getPosATL _checkObj);
_BBox       = boundingBoxReal _bboxObject;

_BBoxMin    = _BBox select 0;
_BBoxMax    = _BBox select 1;
_BBoxHeight = _BBox select 2;

_pX     = _pPos select 0;
_pY     = _pPos select 1;
_pZ     = _pPos select 2;

if(_pX > (_BBoxMin select 0)+_offset && _pX < (_BBoxMax select 0)-_offset) then {
	if(_pY > (_BBoxMin select 1)+_offset && _pY < (_BBoxMax select 1)-_offset) then {
		if(_pZ > (_BBoxMin select 2) && _pZ < (_BBoxMax select 2)) then {
		    if(_canEnter)then{
	            _result = true;
	        };
		};
	};
};

if(_debug)then{
	_bboxObject call {
		private ["_obj","_bb","_bbx","_bby","_bbz","_arr","_y","_z"];
		_obj = _this;
		_bb = {
			_bbx = [_this select 0 select 0, _this select 1 select 0];
			_bby = [_this select 0 select 1, _this select 1 select 1];
			_bbz = [_this select 0 select 2, _this select 1 select 2];
			_arr = [];
			0 = {
				_y = _x;
				0 = {
					_z = _x;
					0 = {
						0 = _arr pushBack (_obj modelToWorld [_x,_y,_z]);
					} count _bbx;
				} count _bbz;
				reverse _bbz;
			} count _bby;
			_arr pushBack (_arr select 0);
			_arr pushBack (_arr select 1);
			_arr
		};
		bbox = boundingBox _obj call _bb;
		bboxr = boundingBoxReal _obj call _bb;
		addMissionEventHandler ["Draw3D", {
			for "_i" from 0 to 7 step 2 do {
				drawLine3D [
					bbox select _i,
					bbox select (_i + 2),
					[0,0,1,1]
				];
				drawLine3D [
					bboxr select _i,
					bboxr select (_i + 2),
					[0,1,0,1]
				];
				drawLine3D [
					bbox select (_i + 2),
					bbox select (_i + 3),
					[0,0,1,1]
				];
				drawLine3D [
					bboxr select (_i + 2),
					bboxr select (_i + 3),
					[0,1,0,1]
				];
				drawLine3D [
					bbox select (_i + 3),
					bbox select (_i + 1),
					[0,0,1,1]
				];
				drawLine3D [
					bboxr select (_i + 3),
					bboxr select (_i + 1),
					[0,1,0,1]
				];
			};
		}];
	};
};

_result
