private ['_code', '_function', '_file'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
	["JohnO_fnc_handlePlayerActions","Client_scriptsAndFunctions\Functions\JohnO_fnc_handlePlayerActions.sqf"]
];

true