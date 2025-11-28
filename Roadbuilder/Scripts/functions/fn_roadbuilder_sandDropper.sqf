params ["_vehicle","_loop","_player"];


if (_loop == false) then {
	
	/*
	Checks if there are any nearby Dirt Humps (The object it will create shortly)
	Will only place one, if there is not one Dirt Hump too close.
	*/
	
	_nearbyObjects = _vehicle nearObjects ["HumpsDirt",8];

	if (count _nearbyObjects == 0) then {
		
		//Get the relative position behind the truck.
		
		_posBehindVehicle = _vehicle getRelPos [-5,0];
		
		//Creates the Dirt Hump behind the truck.
		
		_droppedSand = createVehicle ["HumpsDirt", _posBehindVehicle, [], 0 , "CAN_COLLIDE"];
		
		/*
		Will get Terrain Hight.
		So object will be placed as close as possible at the ground.
		*/
		
		_groundZ = getTerrainHeightASL [_posBehindVehicle select 0, _posBehindVehicle select 1];
		
		//Now sets the position of the Dirt Hump directly on the Terrain Ground.
		
		_droppedSand setPosASL [(getPosASL _droppedSand) select 0,(getPosASL _droppedSand) select 1,_groundZ];
		
		//Rotate it facing the same way of the truck.
		
		_droppedSand setDir ((getDir _vehicle) - 90);
		
		//And Vertical Rotation so it sits flush on the ground.
		
		_droppedSand setVectorUp (surfaceNormal getPosASL _droppedSand);
		
		//Changes the object scale, because normally this object is huge. 
		
		//_droppedSand setObjectScale 0.25;
		[_droppedSand,0.25] remoteExec ["setObjectScale",0];
		
		//Gets, removes and saves sand amount.
		
		_sandAmount = _vehicle getVariable ["ER32_roadbuilder_sandFilled",0];
		_sandAmount = _sandAmount - 25;
		_vehicle setVariable ["ER32_roadbuilder_sandFilled",_sandAmount,true];
		_height = 0.0003333 * _sandAmount - 0.5;
		_vehicle setVariable ["ER32_roadbuilder_sandHeight",_height,true];
	}else{
		hint "To close!"
	};
}else{
	[_vehicle] remoteExecCall ["ER32_fnc_roadbuilder_addAndRemoveSandDropperActions",-2];
	
	_sandDropperActive = true;
	_vehicle setVariable ["ER32_roadbuilder_sandDropper_loopActive",_sandDropperActive,true];
	_sandAmount = _vehicle getVariable ["ER32_roadbuilder_sandFilled",0];
	
	_sands = _vehicle nearObjects ["EFM_ground_surface_2x2m_soil",5];
	while {_sandDropperActive == true and _sandAmount > 0} do {
		_canSpawn = true;
		{
			if (((_x select 1) distance2D _vehicle) < 10) exitWith {
				_canSpawn = false;
			};
		}forEach ER32_roadbuilder_placedSands;
		_height = _vehicle getVariable ["ER32_roadbuilder_sandHeight", 0];
		
		if (_canSpawn == true) then {

			_posBehindVehicle = _vehicle getRelPos [-5,0];
			
			_droppedSand = createSimpleObject ["HumpsDirt", _posBehindVehicle, false];
			ER32_roadbuilder_placedSands pushBack [_droppedSand,_posBehindVehicle];
			publicVariable "ER32_roadbuilder_placedSands";
			_droppedSand hideObjectGlobal true;
			
			_groundZ = getTerrainHeightASL [_posBehindVehicle select 0, _posBehindVehicle select 1];
			
			_droppedSand setPosASL [(getPosASL _droppedSand) select 0,(getPosASL _droppedSand) select 1,_groundZ];
			_droppedSand setDir ((getDir _vehicle) - 90);
			_droppedSand setVectorUp (surfaceNormal getPosASL _droppedSand);
			
			[_droppedSand] remoteExec ["ER32_fnc_roadbuilder_mpScale",0];
			
			_sandAmount = _vehicle getVariable ["ER32_roadbuilder_sandFilled",0];
		
			format ["Sand: %1/1500",_sandAmount] remoteExec ["hintSilent",-2]  ;
			_sandAmount = _sandAmount - 30;
			
			_vehicle setVariable ["ER32_roadbuilder_sandFilled",_sandAmount,true];
			
			
			_height = 0.0003333 * _sandAmount - 0.5;
			_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];
			{
				[_x,[_vehicle, _sandPositions select _forEachIndex]] remoteExec ["attachTo",0];
			}forEach _sands;
			
			if (_sandAmount < 1) then {
				{
					deleteVehicle _x;
				}forEach _sands;
			};
		};
		_vehicle setVariable ["ER32_roadbuilder_sandHeight",_height,true];
		_sandDropperActive = _vehicle getVariable ["ER32_roadbuilder_sandDropper_loopActive",true];
		
		sleep 0.1;
	};
};