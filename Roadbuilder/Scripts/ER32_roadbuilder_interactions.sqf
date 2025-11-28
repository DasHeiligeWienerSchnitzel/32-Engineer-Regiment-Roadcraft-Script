//Will remove the "Stop Demolishment" Action and re-adds the "Start Demolishment" Action back.

ER32_roadbuilder_bulldozer_demolition_deactive = [
	"ER32_roadbuilder_bulldozer_demolition_deactive",
	"Stop Demolishment",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_demolition_deactive"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		_target setVariable ["ER32_roadbuilder_demolishmentState", false, true];
	},
	{true}
] call ace_interact_menu_fnc_createAction;

//Will remove the "Start Demolishment" Action and adds the "Stop Demolishment" Action, aswell as restarting the "ER32_buildRoad_bulldozer_demolishment.sqf" script.

ER32_roadbuilder_bulldozer_demolition_active = [
	"ER32_roadbuilder_bulldozer_demolition_active",
	"Start Demolishment",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_demolition_active"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_flatten_active"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_deactive] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		[_target] remoteExec ["ER32_fnc_roadbuilder_activateDemolishment",2];
	},
	{true}
] call ace_interact_menu_fnc_createAction;



//Will start the Flattening process.

ER32_roadbuilder_bulldozer_flatten_active = [
	"ER32_roadbuilder_bulldozer_flatten_active",
	"Start Flattening",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_flatten_active"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_deactive] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_demolition_active"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target] spawn ER32_fnc_roadbuilder_flatten;
	},
	{true}
] call ace_interact_menu_fnc_createAction;

//Will end the Flattening process.

ER32_roadbuilder_bulldozer_flatten_deactive = [
	"ER32_roadbuilder_bulldozer_flatten_deactive",
	"Stop Flattening",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_bulldozer_flatten_deactive"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
		_target setVariable ["ER32_roadbuilder_bulldozer_flatten", false, true];
	},
	{true}
] call ace_interact_menu_fnc_createAction;

ER32_roadbuilder_sandDropper_loopActive = [
	"ER32_roadbuilder_sandDropper_loopActive",
	"Drop Sand (Activate Loop)",
	"",
	{
		params ["_target","_player","_params"];
		[_target,true,_player] remoteExec ["ER32_fnc_roadbuilder_sandDropper",2];
	},
	{
		params ["_target","_player","_params"];
		(_target getVariable ["ER32_roadbuilder_sandFilled",1]) > 0;
	}
] call ace_interact_menu_fnc_createAction;


ER32_roadbuilder_sandDropper_loopDeactive = [
	"ER32_roadbuilder_sandDropper_loopDeactive",
	"Drop Sand (Deactivate Loop)",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_roadbuilder_sandDropper_loopDeactive"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",-2];
		_target setVariable ["ER32_roadbuilder_sandDropper_loopActive",false,true];
		
		[_target, 1, ["ACE_SelfActions"], ER32_roadbuilder_sandDropper_loopActive] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
	},
	{true}
] call ace_interact_menu_fnc_createAction;


//----------------------------------------------------------------------------------------------------------------------------

if (hasInterface) then {

	params ["_fillTruckZones","_fillTruckSwitches","_bulldozer_spawners","_bulldozer_spawnpoints"];

	//Adds interaction to fill trucks on deticated zones.

	for "_i" from 0 to (count _fillTruckSwitches - 1) do {
		(_fillTruckSwitches select _i) setObjectTextureGlobal [0,""];
		_zone = _fillTruckZones select _i;
		_ER32_roadbuilder_sandFiller = [
			"ER32_roadbuilder_sandFiller",
			"Start Filling Truck with Sand",
			"",
			{
				params ["_target","_player","_params"];
				_zone = _params select 0;
				[_zone,_player] remoteExec ["ER32_fnc_roadbuilder_fillTruck",2];
			},
			{true},
			{},
			[_zone]
		] call ace_interact_menu_fnc_createAction;
		
		[_fillTruckSwitches select _i, 0, ["ACE_MainActions"], _ER32_roadbuilder_sandFiller] call ace_interact_menu_fnc_addActionToObject;
	};

	//Adds interaction to create bulldozers.


	for "_i" from 0 to (count _bulldozer_spawners - 1) do {
		
		//Removes texture from spawner. As a helper sphere is used and only the interaction is needed.
		(_bulldozer_spawners select _i) setObjectTextureGlobal [0,""];
		
		_ER32_roadbuilder_bulldozer_spawner = [
			"ER32_roadbuilder_bulldozer_spawner",
			"Spawn Bulldozer",
			"",
			{
				params ["_target","_player","_params"];
				_spawnpoint = _params select 0;
				
				//Creates the tractor, disables it simulation and removes its texture.
				
				_tractor = createVehicle ["C_Tractor_01_F", position _spawnpoint, [], 0, "CAN_COLLIDE"];
				_tractor enableSimulationGlobal false;
				_tractor setObjectTextureGlobal [0,""];
				_tractor setDir ((getDir _spawnpoint) - 180);
				
				//Now spawns the static object bulldozer and also disables its simulation.
				
				_bulldozer = createVehicle ["Land_Bulldozer_01_wreck_F", position _spawnpoint, [], 0, "CAN_COLLIDE"];
				_bulldozer enableSimulationGlobal false;
				
				//Attaches the bulldozer to the now invisible tractor.
				
				_bulldozer attachTo [_tractor, [0, 0.7, -0.5]];
				_bulldozer setVectorDirAndUp [[0,-1,0],[0,0,1]];
				
				//Re-enables the simulation of the tractor, making the bulldozer drivable. 
				
				_tractor enableSimulationGlobal true;
				
				//Adds interaction points to the bulldozer, allowing it to run the demolish and flatten script.
				
				[_tractor, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
				[_tractor, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_active] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",-2];
				
				//Appends it to the global bulldozer list.
				ER32_roadbuilder_spawnedBulldozers pushBack _tractor;
				publicVariable "ER32_roadbuilder_spawnedBulldozers";
				
			},
			{true},
			{},
			[_bulldozer_spawnpoints select _i]
		] call ace_interact_menu_fnc_createAction;
		[_bulldozer_spawners select _i, 0, ["ACE_MainActions"], _ER32_roadbuilder_bulldozer_spawner] call ace_interact_menu_fnc_addActionToObject;
	};

	//-----------------------------------------------------------------------------------------------

	if (count ER32_roadbuilder_spawnedBulldozers > 0) then {
		{
			
			if (_x getVariable ["ER32_roadbuilder_demolishmentState",false] == false) then {
				[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_active] call ace_interact_menu_fnc_addActionToObject;
				if (_x getVariable ["ER32_roadbuilder_bulldozer_flatten",false] == false) then {
					[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_active] call ace_interact_menu_fnc_addActionToObject;
				}else{
					[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_flatten_deactive] call ace_interact_menu_fnc_addActionToObject;
				};
			}else{
				[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_bulldozer_demolition_deactive] call ace_interact_menu_fnc_addActionToObject;
			};
			
		}forEach spawnedBulldozers;
	};

	if (count ER32_roadbuilder_sandTrucks > 0) then {
		{
			[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_sandDropper] call ace_interact_menu_fnc_addActionToObject;
			if (_x getVariable ["ER32_roadbuilder_sandDropper_loopActive",false] == false) then {
				[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_sandDropper_loopActive] call ace_interact_menu_fnc_addActionToObject;
			}else{
				[_x, 1, ["ACE_SelfActions"], ER32_roadbuilder_sandDropper_loopDeactive] call ace_interact_menu_fnc_addActionToObject;
			};
		}forEach ER32_roadbuilder_sandTrucks;
	};
};