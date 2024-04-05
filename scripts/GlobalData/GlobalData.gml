//Action Library
global.actionLibrary = {
	baseAttack: {
		name: ["Base Attack"], //probably redundant to have a name but keep it
		description: ["Does 1 damage to the first target in a row"],
		cost: [1],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 1, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
	
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_base_laser, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.hp -= _damage; // temp var until we get shit moving
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, _damage);
							show_debug_message(skill_range[i]._entity_on_tile.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
		
				}
			}
		}
	},
	beam: {
		name: ["Beam", "Big Beam", "Repel Beam"], 
		description: ["Does 2 damage to all targets in a row", "Does 2 damage to all targets in surrounding rows. Double damage if target is in the same row", "Does 2 damage to all targets in a row and pushes them back 1 tile."],
		cost: [3, 6, 4],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 2, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				
				if (!unit.play_sound) {
					audio_play_sound(sfx_beam_windup, 0, false);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					audio_play_sound(sfx_blast, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.hp -= _damage;
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, _damage);
							show_debug_message(skill_range[i]._entity_on_tile.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.play_sound = false;
				}
			},
			upgrade1: function(unit){
				
				if (!unit.play_sound) {
					audio_play_sound(sfx_beam_windup, 0, false);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = array_concat(obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]-1));

				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					audio_play_sound(sfx_blast, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						
						if(skill_range[i]._y_coord==unit.grid_pos[1]){
							_damage = unit.action.damage*2;
						}else{
							_damage = unit.action.damage;
						}
						if (!skill_range[i]._is_empty) {
							show_debug_message(string(skill_range[i]._y_coord)+" and "+string(unit.grid_pos[1]));
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.hp -= _damage;
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, _damage);
							show_debug_message(skill_range[i]._entity_on_tile.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.play_sound = false;
				}
			},
			upgrade2: function(unit){
				
				if (!unit.play_sound) {
					audio_play_sound(sfx_beam_windup, 0, false);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				
				skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					audio_play_sound(sfx_blast, 0, false);
					for (var i = array_length(skill_range)-1; i >= 0; i--) {
						
						
						if (!skill_range[i]._is_empty) {
							_target = skill_range[i]._entity_on_tile;
							show_debug_message(string(skill_range[i]._y_coord)+" and "+string(unit.grid_pos[1]));
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.hp -= _damage;
							
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, _damage);
							skill_range[i]._entity_on_tile.push_back(1);
							show_debug_message(_target.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.play_sound = false;
				}
			}
			
		}
			
	},
	mortar: {
		name: ["Mortar", "Airstrike", "Force Grenade"], //probably redundant to have a name but keep it
		description: ["Hits a nearby target and damages all adjacent units", "Hits any target and damages all adjacent units", "Hits a nearby target and damages and pushes all adjacent units. Center target takes double damage."],
		cost: [4, 6, 5],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 4, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				obj_gridCreator.reset_highlights_target();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0] + unit.range;
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
	
					audio_play_sound(sfx_mortar_windup, 0, false);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] += 1;
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_coords[1] > 0) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] -= 1;
					}
				}
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(186)) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.hp -= _damage;
							obj_battleEffect.show_damage(skill_range_aux[i]._entity_on_tile, _damage);
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
						}
					}
		
					unit.is_attacking = false;
					skill_range = obj_gridCreator.reset_highlights_attack();
					skill_range_aux = obj_gridCreator.reset_highlights_target();
					unit.skill_complete = true;
					unit.skill_init = false;
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
			upgrade1: function(unit){
				obj_gridCreator.reset_highlights_target();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0] + unit.range;
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
	
					audio_play_sound(sfx_mortar_windup, 0, false);
				}
				skill_range = obj_gridCreator.highlighted_attack_all();
				skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
				show_debug_message(string(skill_range));
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] += 1;
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_coords[1] > 0) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] -= 1;
					}
				}
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(186)) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.hp -= _damage;
							obj_battleEffect.show_damage(skill_range_aux[i]._entity_on_tile, _damage);
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
						}
					}
		
					unit.is_attacking = false;
					skill_range = obj_gridCreator.reset_highlights_attack();
					skill_range_aux = obj_gridCreator.reset_highlights_target();
					unit.skill_complete = true;
					unit.skill_init = false;
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
			upgrade2: function(unit){
				obj_gridCreator.reset_highlights_target();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0] + unit.range;
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
	
					audio_play_sound(sfx_mortar_windup, 0, false);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] += 1;
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_coords[1] > 0) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[1] -= 1;
					}
				}
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(186)) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]){
								_damage = unit.action.damage*2;
							}else{
								_damage = unit.action.damage
							}
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.hp -= _damage;
							obj_battleEffect.show_damage(skill_range_aux[i]._entity_on_tile, _damage);
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]&&!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]._is_empty){
								skill_range_aux[i]._entity_on_tile.push_up(1);
							}else if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]&&!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]._is_empty){
								skill_range_aux[i]._entity_on_tile.push_down(1);
							}else if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]&&!obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]._is_empty){
								skill_range_aux[i]._entity_on_tile.push_forward(1);
							}else if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]&&!obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]._is_empty){
								skill_range_aux[i]._entity_on_tile.push_back(1);
							}
						}
					}
		
					unit.is_attacking = false;
					skill_range = obj_gridCreator.reset_highlights_attack();
					skill_range_aux = obj_gridCreator.reset_highlights_target();
					unit.skill_complete = true;
					unit.skill_init = false;
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
		}
	},
	charge: {
		name: ["Charge"], //probably redundant to have a name but keep it
		description: ["Gain 1 TP"],
		cost: [0],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				unit.action = unit.actions[2];
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
	
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					obj_battleControl.tp_current+=1;
					if(obj_battleControl.tp_current>obj_battleControl.tp_max){
						obj_battleControl.tp_current=obj_battleControl.tp_max;
					}
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
		
				}
				
			}
		}
	}
	
}

global.enemyActions = {
	melee: {
		name: "melee",
		range: [
			[-1, 0], [-1, -1], [-1, 1],
			[-2, 0], [-2, -1], [-2, 1],
			[-3, 0]
		]
	},
	ranged_attack: {
		name: "ranged attack",
		range: [
			[-5, 0], [-6, 0], [-7, 0], [-8, 0], [-9, 0],
			[-4, 0], [-3, 0], [-2, 0], [-1, 0]
		]
	}
}

//Player(s) Data
global.players = [
	{ //l'cifure
		name: "L'Cifure",
		hp: 5,
		hpMax: 5,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead, gun: spr_player_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar],
		ally: true,
		tpGain: 1
		
	},
	{ //l'cifure
		name: "L'Cifure",
		hp: 5,
		hpMax: 5,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar],
		ally: true,
		tpGain: 1
	}
	//{ //new member
	//	name: "put new party member here", //refer to example above
	//}
]



//Enemy Data
global.enemies = [
	{
		name: "Slime",
		hp: 2,
		hpMax: 2,
		healthbar_offset: -30,
		sprites: { idle: spr_slime_idle, attack: spr_slime_attack },
		actions: [global.enemyActions.melee],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		gold: 50
	},
	{
		name: "Bat",
		hp: 1,
		hpMax: 1,
		healthbar_offset: -40,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.ranged_attack],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 100
	}
]

//Encounters
global.encounters = [
	[
		{
			info: global.enemies[1],
			grid: [8, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		}
		
	],
	[
		{
			info: global.enemies[0],
			grid: [8, 1]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		},
		{
			info: global.enemies[0],
			grid: [8, 3]
		}
	],
	[
		{
			info: global.enemies[1],
			grid: [8, 1]
		},
		{
			info: global.enemies[1],
			grid: [8, 3]
		}
	],
	[
		{
			info: global.enemies[1],
			grid: [6, 2]
		},
		{
			info: global.enemies[1],
			grid: [7, 1]
		},
		{
			info: global.enemies[1],
			grid: [7, 3]
		},
		{
			info: global.enemies[1],
			grid: [7, 2]
		},
		{
			info: global.enemies[1],
			grid: [8, 2]
		}
	],

]