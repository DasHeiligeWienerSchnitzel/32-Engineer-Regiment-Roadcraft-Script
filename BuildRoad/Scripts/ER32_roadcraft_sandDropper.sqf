params ["_vehicle","_loop"];
if (_loop == false) then {
	_nearbyObjects = _vehicle nearObjects ["HumpsDirt",8];

	if (count _nearbyObjects == 0) then {

		_posBehindVehicle = _vehicle getRelPos [-5,0];
		
		_droppedSand = createVehicle ["HumpsDirt", _posBehindVehicle, [], 0 , "CAN_COLLIDE"];
		
		_groundZ = getTerrainHeightASL [_posBehindVehicle select 0, _posBehindVehicle select 1];
		
		_droppedSand setPosASL [(getPosASL _droppedSand) select 0,(getPosASL _droppedSand) select 1,_groundZ];
		_droppedSand setDir ((getDir _vehicle) - 90);
		_droppedSand setVectorUp (surfaceNormal getPosASL _droppedSand);
		
		
		_droppedSand setObjectScale 0.25;
		
		_sandAmount = _vehicle getVariable ["ER32_roadcraft_sandFilled",0];
		_sandAmount = _sandAmount - 25;
		_vehicle setVariable ["ER32_roadcraft_sandFilled",_sandAmount,true];
		
	}else{
		hint "To close!"
	};
}else{
	[_vehicle, 1, ["ACE_SelfActions","ER32_roadcraft_sandDropper_loopActive"]] call ace_interact_menu_fnc_removeActionFromObject;
	
	_ER32_roadcraft_sandDropper_loopDeactive = [
		"ER32_roadcraft_sandDropper_loopDeactive",
		"Drop Sand (Deactivate Loop)",
		"",
		{
			params ["_target","_player","_params"];
			[_target, 1, ["ACE_SelfActions","ER32_roadcraft_sandDropper_loopDeactive"]] call ace_interact_menu_fnc_removeActionFromObject;
			_target setVariable ["ER32_roadcraft_sandDropper_loopActive",false,true];
			
			_ER32_roadcraft_sandDropper_loopActive = [
				"ER32_roadcraft_sandDropper_loopActive",
				"Drop Sand (Activate Loop)",
				"",
				{
					params ["_target","_player","_params"];
					[_target,true] execVM "ER32_roadcraft_sandDropper.sqf";
				},
				{
					params ["_target","_player","_params"];
					(_target getVariable ["ER32_roadcraft_sandFilled",1]) > 0;
				}
			] call ace_interact_menu_fnc_createAction;
			[_target, 1, ["ACE_SelfActions"], _ER32_roadcraft_sandDropper_loopActive] call ace_interact_menu_fnc_addActionToObject;
		},
		{true}
	] call ace_interact_menu_fnc_createAction;
	[_vehicle, 1, ["ACE_SelfActions"], _ER32_roadcraft_sandDropper_loopDeactive] call ace_interact_menu_fnc_addActionToObject;
	
	_sandDropperActive = true;
	_vehicle setVariable ["ER32_roadcraft_sandDropper_loopActive",_sandDropperActive,true];
	_sandAmount = _vehicle getVariable ["ER32_roadcraft_sandFilled",0];
	
	_sands = _vehicle nearObjects ["EFM_ground_surface_2x2m_soil",5];
	while {_sandDropperActive == true and _sandAmount > 0} do {
		_nearbyObjects = _vehicle nearObjects ["HumpsDirt",10];
		
		if (count _nearbyObjects == 0) then {

			_posBehindVehicle = _vehicle getRelPos [-5,0];
			
			_droppedSand = createVehicle ["HumpsDirt", _posBehindVehicle, [], 0 , "CAN_COLLIDE"];
			
			_groundZ = getTerrainHeightASL [_posBehindVehicle select 0, _posBehindVehicle select 1];
			
			_droppedSand setPosASL [(getPosASL _droppedSand) select 0,(getPosASL _droppedSand) select 1,_groundZ];
			_droppedSand setDir ((getDir _vehicle) - 90);
			_droppedSand setVectorUp (surfaceNormal getPosASL _droppedSand);
			
			_droppedSand setObjectScale 0.25;
			
			_sandAmount = _vehicle getVariable ["ER32_roadcraft_sandFilled",0];
		
			hint format ["%1",_sandAmount];
			_sandAmount = _sandAmount - 30;
			
			_vehicle setVariable ["ER32_roadcraft_sandFilled",_sandAmount,true];
			
			
			_height = 0.0003333 * _sandAmount - 0.5;
			_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];
			{
				_x attachTo [_vehicle, _sandPositions select _forEachIndex];
			}forEach _sands;
			
			if (_sandAmount < 1) then {
				{
					deleteVehicle _x;
				}forEach _sands;
			};
		};
		
		_sandDropperActive = _vehicle getVariable ["ER32_roadcraft_sandDropper_loopActive",true];
		
		sleep 0.1;
	};
};
