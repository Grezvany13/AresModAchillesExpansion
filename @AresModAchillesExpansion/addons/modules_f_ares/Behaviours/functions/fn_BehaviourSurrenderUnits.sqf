#include "\achilles\modules_f_ares\module_header.hpp"

//Broadcast surrender function
if (isNil "Achilles_var_surrender_init_done") then
{
	publicVariable "Ares_fnc_surrenderUnit";
	Achilles_var_surrender_init_done = true;
};
//Broadcast animation function
if (isNil "Achilles_var_animation_init_done") then
{
	publicVariable "Achilles_fnc_ambientAnimGetParams";
	publicVariable "Achilles_fnc_ambientAnim";
	Achilles_var_animation_init_done = true;
};

_unitsToSurrender = [[_logic] call Ares_fnc_GetUnitUnderCursor];

// selection option
if (isNull (_unitsToSurrender select 0)) then
{
	_unitsToSurrender = [localize "STR_UNITS"] call Achilles_fnc_SelectUnits;
};
if (isNil "_unitsToSurrender") exitWith {};
if (count _unitsToSurrender == 0) exitWith {};

private _nextCaptureStateDialogResult = nil;
{
	_unitToSurrender = _x;
	// Determine if we've already captured the unit in the past
	if (alive _unitToSurrender) then
	{
		_surrenderState = _unitToSurrender getVariable ["AresCaptureState", -1];
		if (_surrenderState == -1) then
		{
			//Not yet surrendered

			// open dialog only once
			if (isNil "_nextCaptureStateDialogResult") then
			{
				_nextCaptureStateDialogResult =
				[
					localize "STR_SURRENDER_UNIT",
					[
						[localize "STR_AMBIENT_ANIMATION", [localize "STR_SURRENDER_UNIT", localize "STR_TIE_UNIT"]],
						[localize "STR_INTERACTION", [localize "STR_RELEASE_N_LEAD_UNIT", localize "STR_RELEASE_UNIT", localize "STR_TIE_UNIT"]]
					]
				] call Ares_fnc_ShowChooseDialog;
				// terminate script
				if (count _nextCaptureStateDialogResult == 0) exitWith {deleteVehicle _logic};
			};
			[_unitToSurrender,objNull,_nextCaptureStateDialogResult] remoteExec ["Ares_fnc_surrenderUnit",_unitToSurrender];
		} else
		{
			[_unitToSurrender,objNull,[-1,-1]] remoteExec ["Ares_fnc_surrenderUnit",_unitToSurrender];
		};
	};
} forEach _unitsToSurrender;

#include "\achilles\modules_f_ares\module_footer.hpp"
