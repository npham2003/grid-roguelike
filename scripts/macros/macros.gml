#macro CELLSIZE 48
#macro CELLWIDTH 100
#macro CELLHEIGHT 50

#macro GRIDWIDTH 10
#macro GRIDHEIGHT 5

#region colors
global._primary = #d1a578;
global._secondary = #1cc6e0;
global._aspect_bars = #1a1a1a;

global._menu_primary = #0cac87;
global._menu_secondary = #386467;

global._playerTurnTop = #194DD0;
global._playerTurnMiddle = #194DD0;
global._playerTurnBottom = #148d95;

global._enemyTurnTop = #da7066;
global._enemyTurnMiddle = #cd5075;
global._enemyTurnBottom = #665d6c;

global._tpBar = #a4cda4;
global._tpBorder = #6ccf48;

global._characterPrimary = #0cac87; //change per party member later
global._characterSecondary = #386467;
#endregion


global.other_controls = [input_binding_get("up"), input_binding_get("left"), input_binding_get("down"), input_binding_get("right"), input_binding_get("confirm"), input_binding_get("back"), input_binding_get("end_turn")];
global.skill_controls = [input_binding_get("first"), input_binding_get("second"), input_binding_get("third"), input_binding_get("fourth"), input_binding_get("wait")];


global.floor_music=[
	[
		bgm_battleOfRuins, 
		bgm_keves_battle,
		bgm_clock_tower
	],
	[
		bgm_night_walker,
		bgm_rhythmical_bustle
	],
	[
		bgm_unfinished_battle,
		bgm_the_people_and_their_world
	]


]