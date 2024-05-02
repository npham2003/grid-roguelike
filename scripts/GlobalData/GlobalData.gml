global.controls = ["H", "J", "K", "L", "Enter"];


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


//Action Library
// _damage+unit.attack_bonus+unit.attack_bonus_temp
// THIS IS THE DAMAGE FORMULA
global.actionLibrary = {
	baseAttack: {
		name: ["Attack"], //probably redundant to have a name but keep it
		description: ["Does 1 damage to the first target in any direction"],
		cost: [1],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 1, 
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				if(!unit.skill_init){
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					// setup initial target
					skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
					unit.skill_init=true;
					show_debug_message("basic init");
				}
				obj_gridCreator.highlighted_attack_cross(unit.grid_pos[0], unit.grid_pos[1],15);
				obj_cursor.movable_tiles=skill_range;
				unit.is_attacking = true;
				if(array_length(skill_range)>0 && !unit.skill_complete){ // set cursor to target if it hits anything, if not its on the player unit
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}else{
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
				}
				
				if (keyboard_check_pressed(ord("A"))) { // aiming
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_straight_back(unit.grid_pos[0]-1, unit.grid_pos[1]);
					
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);

				}
				if (keyboard_check_pressed(ord("D")) ) { // a bunch of this is hardcoded atm
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);

				}
				if (keyboard_check_pressed(ord("S")) ) { // a bunch of this is hardcoded atm
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_straight_down(unit.grid_pos[0], unit.grid_pos[1]+1);
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);

				}
				if (keyboard_check_pressed(ord("W"))) { // a bunch of this is hardcoded atm
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_straight_up(unit.grid_pos[0], unit.grid_pos[1]-1);
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);

				}
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("H"))) { // use the skill
					audio_play_sound(sfx_base_laser, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) { // do damage
						if (!skill_range[i]._is_empty) {
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp); // temp var until we get shit moving
							obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile,0);
							show_debug_message(skill_range[i]._entity_on_tile.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init=false;
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_init=false;
					skill_range = obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.reset_highlights_attack();
		
				}
			}
		}
	},
	beam: {
		name: ["Beam", "Big Beam", "Repel Beam"], 
		description: ["Does 2 damage to all targets in a row", "Does 2 damage to all targets in current and adjacent rows.\nDouble damage if in the same row", "Does 2 damage to all targets in a row and pushes them back 1 tile."],
		cost: [3, 5, 4],
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
				 
				if (!unit.play_sound) { //play beam sound once
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				if (keyboard_check_pressed(ord("J"))) { // use the skill
					audio_play_sound(sfx_blast, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile,2);
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
				
				if (!unit.play_sound) { // play beam sound
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = array_concat(obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]-1));

				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_blast, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						
						if(skill_range[i]._y_coord==unit.grid_pos[1]){ // doubles damage if on the same row
							_damage = unit.action.damage*2;
						}else{
							_damage = unit.action.damage;
						}
						if (!skill_range[i]._is_empty) {
							show_debug_message(string(skill_range[i]._y_coord)+" and "+string(unit.grid_pos[1]));
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile,2);
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
				
				if (!unit.play_sound) { // play sound
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					for(i=0;i<array_length(skill_range);i++){ // set up push preview
					
						if(!skill_range[i]._is_empty){
							obj_battleEffect.push_preview(skill_range[i],0);
						}
					}
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				
				
				
				
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(ord("J"))) { // use skill
					audio_play_sound(sfx_blast, 0, false);
					for (var i = array_length(skill_range)-1; i >= 0; i--) {
						
						
						if (!skill_range[i]._is_empty) {
							_target = skill_range[i]._entity_on_tile;
							show_debug_message(string(skill_range[i]._y_coord)+" and "+string(unit.grid_pos[1]));
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile,2);
							skill_range[i]._entity_on_tile.push_back(1); // push right 
							show_debug_message(_target.hp);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					obj_battleEffect.remove_push_preview();
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_battleEffect.remove_push_preview();
					
					unit.play_sound = false;
				}
			}
			
		}
			
	},
	mortar: {
		name: ["Mortar", "Airstrike", "Force Grenade"], //probably redundant to have a name but keep it
		description: ["Hits a target up to 3 tiles away and damages all adjacent units", "Hits any target and damages all adjacent units", "Hits a target up to 3 tiles away and damages and pushes all adjacent units.\nCenter target takes double damage."],
		cost: [4, 6, 5],
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
				obj_gridCreator.reset_highlights_target();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0] + unit.range;
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
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
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					obj_battleEffect.hit_animation_coordinates(skill_coords[0],skill_coords[1],1);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
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
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz-1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					obj_battleEffect.hit_animation_coordinates(skill_coords[0],skill_coords[1],1);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
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
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
					skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
					skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							
							if(skill_coords[1]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]){
									obj_battleEffect.push_preview(skill_range_aux[i],3);
								}
							}
							if(skill_coords[1]+1<5){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]){
									obj_battleEffect.push_preview(skill_range_aux[i],2);
								}
							}
							if(skill_coords[0]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],1);
								}
							}
							if(skill_coords[0]+1<10){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],0);
								}
							}
							
						}
					}
				}
				
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz-1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert-1) { // a bunch of this is hardcoded atm
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
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if(keyboard_check_pressed(vk_anykey)){
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						show_debug_message(array_length(skill_range_aux));
						show_debug_message(i)
						if (!skill_range_aux[i]._is_empty) {
							
							if(skill_coords[1]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]){
									obj_battleEffect.push_preview(skill_range_aux[i],3);
								}
							}
							if(skill_coords[1]+1<5){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]){
									obj_battleEffect.push_preview(skill_range_aux[i],2);
								}
							}
							if(skill_coords[0]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],1);
								}
							}
							if(skill_coords[0]+1<10){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],0);
								}
							}
							
						}
					}
				}
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					obj_battleEffect.hit_animation_coordinates(skill_coords[0],skill_coords[1],1);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]){
								_damage = unit.action.damage*2;
							}else{
								_damage = unit.action.damage
							}
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
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
					obj_battleEffect.remove_push_preview();
		
				}
			},
		}
	},
	charge: {
		name: ["Charge", "Chargeback", "Parry"], //probably redundant to have a name but keep it
		description: ["Gain 1 TP", "Gain 3 TP but move back to your original position", "Protect yourself from all attacks that hit you this turn"],
		cost: [-1, -3, 3],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.skill_init = true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				unit.action = unit.actions[unit.skill_used];
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
	
				if (keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,3);
					audio_play_sound(sfx_charge, 0, false,0.3);
					
					
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
				}
				
			},
			upgrade1: function(unit){
				unit.action = unit.actions[unit.skill_used];
				
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.back_move();
					unit.skill_init = true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
				if (keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,3);
					audio_play_sound(sfx_charge, 0, false,0.3);
					
					
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
					obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._entity_on_tile=pointer_null;
		
				}
				
			},
			upgrade2: function(unit){
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.skill_init = true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				unit.action = unit.actions[unit.skill_used];
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
	
				if (keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,4);
					audio_play_sound(sfx_shield, 0, false,0.3);
					unit.shield+=9999;
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
		
				}
				
			},
		}
	},
	minefield: {
		name: ["Minefield", "Violent Field", "Quick Blast"], //probably redundant to have a name but keep it
		description: ["Places a trap in a 3x3 area. Any units in the area take 3 damage at the end of their turn.", "Places a trap in a 5x5 area. Any units in the area take 1 damage at the end of their turn.", "Hits all units in a 3x3 area for 4 damage."],
		cost: [3, 6, 6],
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
	
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[0],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}
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
	
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],2);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[1],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}
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
	
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
							skill_range_aux[i]._entity_on_tile.damage(_damage+unit.attack_bonus);
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
		}
	},
	mover: {
		name: ["Phase Shifter", "Long Phase", "Forceful Shift"], //probably redundant to have a name but keep it
		description: ["Moves the first target in a row 1 tile in a direction of your choosing", "Moves the first target in a row in a direction of your choosing until they hit a wall or another unit", "Moves the first target in a row 1 tile in a direction of your choosing and deals 1 damage"],
		cost: [2, 4, 3],
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
				if(!unit.skill_init){
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				if (keyboard_check_pressed(ord("A"))) {
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 1;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],1);
					}
				}
				else if (keyboard_check_pressed(ord("D"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 0;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
				}
				else if (keyboard_check_pressed(ord("S"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 2;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],2);
					}
				}
				else if (keyboard_check_pressed(ord("W"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 3;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],3);
					}
				}
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_push, 0, false, 0.3);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							
							if(unit.skill_option == 0){
								skill_range[i]._entity_on_tile.push_back(1);
							}
							if(unit.skill_option == 1){
								skill_range[i]._entity_on_tile.push_forward(1);
							}
							if(unit.skill_option == 2){
								skill_range[i]._entity_on_tile.push_down(1);
							}
							if(unit.skill_option == 3){
								skill_range[i]._entity_on_tile.push_up(1);
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade1: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				if (keyboard_check_pressed(ord("A"))) {
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 1;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],1);
					}
				}
				else if (keyboard_check_pressed(ord("D"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 0;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
				}
				else if (keyboard_check_pressed(ord("S"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 2;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],2);
					}
				}
				else if (keyboard_check_pressed(ord("W"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 3;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],3);
					}
				}
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_base_laser, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if(unit.skill_option == 0){
								skill_range[i]._entity_on_tile.push_back(7);
							}
							if(unit.skill_option == 1){
								skill_range[i]._entity_on_tile.push_forward(7);
							}
							if(unit.skill_option == 2){
								skill_range[i]._entity_on_tile.push_down(7);
							}
							if(unit.skill_option == 3){
								skill_range[i]._entity_on_tile.push_up(7);
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					obj_battleEffect.remove_push_preview();
					unit.skill_init=false;
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_battleEffect.remove_push_preview();
					unit.skill_init=false;
					
				}
			},
			upgrade2: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				
				var _damage = unit.action.damage;
				skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				if (keyboard_check_pressed(ord("A"))) {
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 1;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],1);
					}
				}
				else if (keyboard_check_pressed(ord("D"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 0;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],0);
					}
				}
				else if (keyboard_check_pressed(ord("S"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 2;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],2);
					}
				}
				else if (keyboard_check_pressed(ord("W"))) { // a bunch of this is hardcoded atm
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_option = 3;
					obj_battleEffect.remove_push_preview();
					if(array_length(skill_range)>0){
						obj_battleEffect.push_preview(skill_range[0],3);
					}
				}
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_push, 0, false, 0.3);
					for (var i = 0; i < array_length(skill_range); i++) {
						
						if (!skill_range[i]._is_empty) {
							obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile,0);
							
							skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							if(unit.skill_option == 0){
								skill_range[i]._entity_on_tile.push_back(1);
							}
							if(unit.skill_option == 1){
								skill_range[i]._entity_on_tile.push_forward(1);
							}
							if(unit.skill_option == 2){
								skill_range[i]._entity_on_tile.push_down(1);
							}
							if(unit.skill_option == 3){
								skill_range[i]._entity_on_tile.push_up(1);
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					obj_battleEffect.remove_push_preview();
					unit.skill_init=false;
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_battleEffect.remove_push_preview();
					unit.skill_init=false;
		
				}
			}
		}
	},
	teleport_self: {
		name: ["Misty Step", "Cartesian Shift", "Dimension Door"],
		description: [
			"Teleport yourself to an empty space within 2 tiles",
			"Teleport yourself to any space with same row or column as your current location",
			"Teleport yourself to any empty space"
		],
		cost: [0, 1, 2],
		subMenu: 0,
		userAnimation: "attack",
		damage: 0,
		func: function(_user, _targets) {
			var _damage = 0;
		},
		skillFunctions: {
			base: skill_teleport_self_1,
			upgrade1: skill_teleport_self_2,
			upgrade2: skill_teleport_self_3
		}
	},
	teleport_ally: {
		name: ["Warp", "Swap", "Rescue"], //probably redundant to have a name but keep it
		description: [ "Move an adjacent ally to an empty space up to 3 tiles away", "Swap the positions of 2 allies up to 3 tiles away", "Moves an ally up to 3 tiles away to an adjacent empty tile "],
		cost: [3, 4, 3],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		damage: 1,
		func: function(_user, _targets) {
			var _damage = 1;
		},
		skillFunctions: {
			base: skill_teleport_ally_1,
			upgrade1: skill_teleport_ally_2,
			upgrade2: skill_teleport_ally_3
		}
	},
	teleport_enemy: {
		name: ["Vortex Shift", "Vortex Swap", "Vortex Warp"],
		description: [
			"Teleport an enemy to an empty space up to 3 tiles away",
			"Swap the positions of any 2 enemies",
			"Teleport an enemy to any empty space"
		],
		cost: [3, 4, 4],
		subMenu: 0,
		userAnimation: "attack",
		damage: 0,
		func: function(_user, _targets) {
			var _damage = 0;
		},
		skillFunctions: {
			base: skill_teleport_enemy_1,
			upgrade1: skill_teleport_enemy_2,
			upgrade2: skill_teleport_enemy_3
		}
	},
	freeze: {
		name: ["Freeze", "Deep Freeze", "Piercing Freeze"], //probably redundant to have a name but keep it
		description: ["Prevents the first target in a row from acting for 1 turn", "Prevents the first target in a row from acting for 2 turns", "Prevents all targets in a row from acting for 1 turn"],
		cost: [2, 4, 4],
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
				if(!unit.skill_init){
					unit.skill_init=true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 1, c_blue);
							if(skill_range[i]._entity_on_tile.stall_turns<=0){
								skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
								skill_range[i]._entity_on_tile.stall_turns+=1;
							}
							
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade1: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					//audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 2, c_blue);
							if(skill_range[i]._entity_on_tile.stall_turns<=0){
								skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
							}
							skill_range[i]._entity_on_tile.stall_turns+=2;
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade2: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("J"))) {
					//audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 1, c_blue);
							if(skill_range[i]._entity_on_tile.stall_turns<=0){
								skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
							}
							skill_range[i]._entity_on_tile.stall_turns+=1;
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
		}
	},
	frostcone: {
		name: ["Frostbite", "Boreal Wind", "Sharp Winds"], //probably redundant to have a name but keep it
		description: ["Attacks in a cone in front of you.\nFrozen units take 1 more damage", "Attacks in a cone in front of you as well as everything in front of you in the row.\nFrozen units take 1 more damage", "Attacks in a cone in front of you.\nFrozen units take 2 more damage"],
		cost: [3, 4, 4],
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
				skill_range = obj_gridCreator.highlighted_target_cone(unit.grid_pos[0], unit.grid_pos[1], 3);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("K"))) {
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if (skill_range[i]._entity_on_tile.stall_turns>0) {
								skill_range[i]._entity_on_tile.freeze_graphic.sprite_index=spr_freeze_out;
								audio_play_sound(sfx_defreeze, 0, false, 0.5);
								skill_range[i]._entity_on_tile.freeze_graphic.image_speed=1;
								skill_range[i]._entity_on_tile.freeze_graphic=pointer_null;
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp+1);
								skill_range[i]._entity_on_tile.stall_turns = 0;
							}
							else {
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							}
							
							
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade1: function(unit){
				unit.action = unit.actions[unit.skill_used];
				skill_range = array_concat(obj_gridCreator.highlighted_target_cone(unit.grid_pos[0], unit.grid_pos[1], 3),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+3, unit.grid_pos[1]));
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("K"))) {
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if (skill_range[i]._entity_on_tile.stall_turns>0) {
								skill_range[i]._entity_on_tile.freeze_graphic.sprite_index=spr_freeze_out;
								audio_play_sound(sfx_defreeze, 0, false, 0.5);
								skill_range[i]._entity_on_tile.freeze_graphic.image_speed=1;
								skill_range[i]._entity_on_tile.freeze_graphic=pointer_null;
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp+1);
								//if (!skill_range[i]._is_empty) {											 I WAS TRYING TO GET REFREEZING TO WORK BUT I JUST COULD NOT 
								//	skill_range[i]._entity_on_tile.stall_turns+=1;
								//	if(skill_range[i]._entity_on_tile.ally){
								//		skill_range[i]._entity_on_tile.has_attacked=true;
								//		skill_range[i]._entity_on_tile.has_moved=true;
								//	}else{
								//		skill_range[i]._entity_on_tile.remove_danger_highlights();
								//	}
								//	obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 2, c_blue);
								//	skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
								//}
							}
							else {
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
								//if (!skill_range[i]._is_empty) {
								//skill_range[i]._entity_on_tile.stall_turns+=1;
								//	if(skill_range[i]._entity_on_tile.ally){
								//	skill_range[i]._entity_on_tile.has_attacked=true;
								//	skill_range[i]._entity_on_tile.has_moved=true;
								//}else{
								//	skill_range[i]._entity_on_tile.remove_danger_highlights();
								//}
								//obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 2, c_blue);
								//skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
								//}
							}
							
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade2: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_cone(unit.grid_pos[0], unit.grid_pos[1], 2);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("K"))) {
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if (skill_range[i]._entity_on_tile.stall_turns>0) {
								skill_range[i]._entity_on_tile.freeze_graphic.sprite_index=spr_freeze_out;
								audio_play_sound(sfx_defreeze, 0, false, 0.5);
								skill_range[i]._entity_on_tile.freeze_graphic.image_speed=1;
								skill_range[i]._entity_on_tile.freeze_graphic=pointer_null;
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp+2);
								skill_range[i]._entity_on_tile.stall_turns = 0;
							}
							else {
								skill_range[i]._entity_on_tile.damage(_damage+unit.attack_bonus+unit.attack_bonus_temp);
							}
							//if(skill_range[i]._entity_on_tile.ally){
							//	skill_range[i]._entity_on_tile.has_attacked=true;
							//	skill_range[i]._entity_on_tile.has_moved=true;
							//}else{
							//	skill_range[i]._entity_on_tile.remove_danger_highlights();
							//}
							
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
		}
	},
	thaw: {
		name: ["Icicle Crash", "Avalanche", "Absolute Zero"], //probably redundant to have a name but keep it
		description: ["Freezes a unit up to 3 tiles away and all adjacent units for 1 turn", "Freezes any unit and all adjacent units for 1 turn", "Freeze all enemy units for 1 turn"],
		cost: [4, 6, 8],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 0, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 0; //math function here
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
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					
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
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							if(skill_range_aux[i]._entity_on_tile.stall_turns<=0){
								skill_range_aux[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range_aux[i]._entity_on_tile, 6);
							}
							skill_range_aux[i]._entity_on_tile.stall_turns+=1;
							if(skill_range_aux[i]._entity_on_tile.ally){
								skill_range_aux[i]._entity_on_tile.has_attacked=true;
								skill_range_aux[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range_aux[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range_aux[i]._entity_on_tile, 1, c_blue);
							
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
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
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz-1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					obj_battleEffect.hit_animation_coordinates(skill_coords[0],skill_coords[1],1);
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							if(skill_range_aux[i]._entity_on_tile.stall_turns<=0){
								skill_range_aux[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range_aux[i]._entity_on_tile, 6);
							}
							skill_range_aux[i]._entity_on_tile.stall_turns+=1;
							if(skill_range_aux[i]._entity_on_tile.ally){
								skill_range_aux[i]._entity_on_tile.has_attacked=true;
								skill_range_aux[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range_aux[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range_aux[i]._entity_on_tile, 1, c_blue);
							
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
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_square(unit.grid_pos[0]+1, unit.grid_pos[1], 10);
				obj_cursor.movable_tiles=skill_range;
				if(!unit.skill_init){
					unit.skill_init=true;
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if(!skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.stall_turns+=1;
								if(skill_range[i]._entity_on_tile.ally){
									skill_range[i]._entity_on_tile.has_attacked=true;
									skill_range[i]._entity_on_tile.has_moved=true;
								}else{
									skill_range[i]._entity_on_tile.remove_danger_highlights();
								}
								obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 1, c_blue);
								if(skill_range[i]._entity_on_tile.stall_turns<=0){
									skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
								}
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
		}
	},
	buff: {
		name: ["Encourage", "Rallying Cry", "Invigorate"], //probably redundant to have a name but keep it
		description: [ "Make an adjacent ally do 1 extra damage for 2 turns.", "Make an ally up to 3 tiles away do 1 extra damage for 2 turns", "Make an adjacent ally do 2 extra damage for 2 turns"],
		cost: [3, 5, 5],
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
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_bonus_temp+=1;
								
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_buff_recent=true;
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,3);
								audio_play_sound(sfx_charge, 0, false,0.3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
			upgrade1: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 3);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_bonus_temp+=1;
								
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_buff_recent=true;
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								audio_play_sound(sfx_charge, 0, false,0.3);
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
			upgrade2: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_bonus_temp+=2;
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.attack_buff_recent=true;
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								audio_play_sound(sfx_charge, 0, false,0.3);
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
		}
	},
	dance: {
		name: ["Haste", "Superspeed", "Dance"], //probably redundant to have a name but keep it
		description: [ "Allow an adjacent ally to move an extra tile for 2 turns", "Allow an adjacent ally to move 2 extra tiles for 2 turns", "Allow an adjacent ally to act again"],
		cost: [4, 5, 3],
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
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.move_bonus_temp+=1;
								
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.move_buff_recent=true;
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,3);
								audio_play_sound(sfx_charge, 0, false,0.3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
			upgrade1: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.move_bonus_temp+=2;
								
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.move_buff_recent=true;
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								audio_play_sound(sfx_charge, 0, false,0.3);
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
			upgrade2: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally && obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile!=unit){
								if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.has_attacked||obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.has_moved){
									obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.has_attacked=false;
									obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.has_moved=false;
								
									unit.is_attacking = false;
									skill_range = obj_gridCreator.reset_highlights_support();
									skill_range_aux = obj_gridCreator.reset_highlights_target();
									unit.skill_complete = true;
									unit.skill_init = false;
									unit.skill_progress=0;
									audio_play_sound(sfx_dance, 0, false,0.3);
									obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,7);
									show_debug_message(unit.action.name);
								}else{
									audio_play_sound(sfx_no_tp, 0, false);
								}
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
		}
	},	
	shield: {
		name: ["Protect", "Shove", "Wide Guard"], //probably redundant to have a name but keep it
		description: [ "Make an adjacent ally immune to 1 attack this turn", "Push an adjacent ally away from you", "Makes the user and all adjacent allies immune to 1 attack this turn"],
		cost: [3, 2, 5],
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
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("J"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && skill_coords[0]!=unit.grid_pos[0] && skill_coords[1]!=unit.grid_pos[1]){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.shield+=1;
								
								
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								
								obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile,4);
								audio_play_sound(sfx_charge, 0, false,0.3);
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
			upgrade1: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty  && keyboard_check_pressed(vk_anykey)){
					obj_battleEffect.remove_push_preview();
					if(skill_coords[0]==unit.grid_pos[0]+1){
						unit.skill_option=0;
						obj_battleEffect.push_preview(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]],0);
					}
					if(skill_coords[0]==unit.grid_pos[0]-1){
						unit.skill_option=1;
						obj_battleEffect.push_preview(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]],1);
					}
					if(skill_coords[1]==unit.grid_pos[1]+1){
						unit.skill_option=2;
						obj_battleEffect.push_preview(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]],2);
					}
					if(skill_coords[1]==unit.grid_pos[1]-1){
						unit.skill_option=3;
						obj_battleEffect.push_preview(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]],3);
					}
				}
				
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("J"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								switch(unit.skill_option){
									case 0:
										obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.push_back(1);
										break;
									case 1:
										obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.push_forward(1);
										break;
									case 2:
										obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.push_down(1);
										break;
									case 3:
										obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.push_up(1);
										break;
								}
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								unit.skill_option=0;
								audio_play_sound(sfx_charge, 0, false,0.3);
								obj_battleEffect.remove_push_preview();
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
						obj_battleEffect.remove_push_preview();
					
		
				}
			},
			upgrade2: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				obj_gridCreator.reset_highlights_support();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 0);
					
				}
				
				
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(ord("J"))) {
					if(unit.skill_progress==1){
						for(i=0;i<array_length(skill_range_aux);i++){
							if(!skill_range_aux[i]._is_empty){
								if(skill_range_aux[i]._entity_on_tile.ally){
									skill_range_aux[i]._entity_on_tile.shield+=1;
									
									
									obj_battleEffect.hit_animation(skill_range_aux[i]._entity_on_tile,4);
									show_debug_message(unit.action.name);
								}
							}
						}
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_support();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						unit.skill_progress=0;
						audio_play_sound(sfx_charge, 0, false,0.3);
					}
					
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					
		
				}
			},
		}
	},
	placebomb: {
		name: ["Mine", "Bigger Mine", "More Mines"], //probably redundant to have a name but keep it
		description: ["Places a mine. Any adjacent units take damage at the end of their turn", "Places a mine. Any units in the 3x3 area take 3 damage at the end of their turn.", "Places 2 mines. Any adjacent units take damage at the end of their turn"],
		cost: [2, 3, 5],
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_cross(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[2],skill_coords);	//minibomb
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[3],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
					unit.range = 4;
					skill_coords[0] = unit.grid_pos[0] + unit.range;
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_init = true;
					unit.is_attacking = true;
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_cross(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("J"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[2],skill_coords);	//minibomb
						unit.bombs_placed += 1;
						if (unit.bombs_placed == 2) {
							unit.is_attacking = false;
							skill_range = obj_gridCreator.reset_highlights_attack();
							skill_range_aux = obj_gridCreator.reset_highlights_target();
							unit.skill_complete = true;
							unit.skill_init = false;
							show_debug_message(unit.action.name);
						}
						
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
				}else if(keyboard_check_pressed(vk_tab)){
					unit.bombs_placed = 0;
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
		}
	},
	placeicebomb: {
		name: ["Ice Mine", "Freezer", "Ice Age"], //probably redundant to have a name but keep it
		description: ["Places an ice mine that freezes units in a 3x3 area at the end of their turn", "Places an ice mine that continually freezes units in a 3x3 area for 3 turns", "Places a large ice mine that freezes units in a 5x5 area and does 1 damage"],
		cost: [3, 5, 5],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 0, // temp damage, until i figure out how to do this damage function thing
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("K"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[4],skill_coords);	//minibomb
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("K"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[5],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],2);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("K"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[6],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
				}else if(keyboard_check_pressed(vk_tab)){
					unit.bombs_placed = 0;
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
		}
	},
	placegravbomb: {
		name: ["Push Mine", "Gravity Mine", "Super Push Mine"], //probably redundant to have a name but keep it
		description: ["Places a mine. Any adjacent units get pushed 1 tile away at the end of their turn", "Places a mine. Any units in the surrounding area get pulled 1 tile in at the end of their turn", "Places a mine. Adjacent enemies get pushed away until they hit an obstacle at the end of their turn"],
		cost: [3, 4, 5],
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_cross(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[7],skill_coords);	//minibomb
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_cross(skill_coords[0], skill_coords[1],2);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[8],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
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
	
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				}
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_cross(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] -= 1;
					}
				}
				if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz - 1) { // a bunch of this is hardcoded atm
					if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
						audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
						skill_coords[0] += 1;
					}
				}
				if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
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
				if (keyboard_check_pressed(ord("L"))) {
					if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
						audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
						
						obj_battleControl.spawn_obstacle(global.obstacles[9],skill_coords);	
						unit.is_attacking = false;
						skill_range = obj_gridCreator.reset_highlights_attack();
						skill_range_aux = obj_gridCreator.reset_highlights_target();
						unit.skill_complete = true;
						unit.skill_init = false;
						show_debug_message(unit.action.name);
					}else{
						audio_play_sound(sfx_no_tp, 0, false);
					}
				}else if(keyboard_check_pressed(vk_tab)){
					unit.bombs_placed = 0;
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_range = obj_gridCreator.reset_highlights_attack();
					unit.skill_init = false;
		
				}
			},
		}
	},
	pushspread: {
		name: ["Repelling Blast", "Repelling Shockwave", "Compress"], 
		description: ["Pushes all units in front of you and in 1 adjacent row away from each other", 
			"Pushes all units in front of you and in an adjacent row away from each other until they hit a wall or another unit.", 
			"Slams all units in front of you and in adjacent rows into the row in front of you."],
		cost: [4, 6, 4],
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
				obj_gridCreator.reset_highlights_attack();
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1);
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]-1);
				if (!unit.play_sound) { //play beam sound once
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],2);
						}else{
							obj_battleEffect.push_preview(skill_range[i],3);
						}
					}
					
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(ord("S")) && skill_type==-1) {
					skill_type=1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],3);
						}else{
							obj_battleEffect.push_preview(skill_range[i],2);
						}
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_type==1) { // a bunch of this is hardcoded atm
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],2);
						}else{
							obj_battleEffect.push_preview(skill_range[i],3);
						}
					}
				}
				if (keyboard_check_pressed(ord("K"))) { // use the skill
					audio_play_sound(sfx_blast, 0, false);
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if(skill_type==1){
								if(unit.grid_pos[1]==skill_range[i]._y_coord){
									skill_range[i]._entity_on_tile.push_up(1);
								}else{
									skill_range[i]._entity_on_tile.push_down(1);
								}
							}else{
								if(unit.grid_pos[1]==skill_range[i]._y_coord){
									skill_range[i]._entity_on_tile.push_down(1);
								}else{
									skill_range[i]._entity_on_tile.push_up(1);
								}
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					obj_battleEffect.remove_push_preview();
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_gridCreator.reset_highlights_attack();
					unit.play_sound = false;
				}
			},
			upgrade1: function(unit){
				obj_gridCreator.reset_highlights_attack();
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1);
				obj_gridCreator.highlighted_attack_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]-1);
				if (!unit.play_sound) { //play beam sound once
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],2);
						}else{
							obj_battleEffect.push_preview(skill_range[i],3);
						}
					}
					
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(ord("S")) && skill_type==-1) {
					skill_type=1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],3);
						}else{
							obj_battleEffect.push_preview(skill_range[i],2);
						}
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_type==1) { // a bunch of this is hardcoded atm
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord){
							obj_battleEffect.push_preview(skill_range[i],2);
						}else{
							obj_battleEffect.push_preview(skill_range[i],3);
						}
					}
				}
				if (keyboard_check_pressed(ord("K"))) { // use the skill
					audio_play_sound(sfx_blast, 0, false);
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							if(skill_type==1){
								if(unit.grid_pos[1]==skill_range[i]._y_coord){
									skill_range[i]._entity_on_tile.push_up(5);
								}else{
									skill_range[i]._entity_on_tile.push_down(5);
								}
							}else{
								if(unit.grid_pos[1]==skill_range[i]._y_coord){
									skill_range[i]._entity_on_tile.push_down(5);
								}else{
									skill_range[i]._entity_on_tile.push_up(5);
								}
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					obj_battleEffect.remove_push_preview();
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.play_sound = false;
					obj_gridCreator.reset_highlights_attack();
				}
			},
			upgrade2: function(unit){
				
				if (!unit.play_sound) { //play beam sound once
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.play_sound = true;
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					obj_gridCreator.reset_highlights_target();
					skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1);
					if(unit.grid_pos[1]+skill_type>=0 && unit.grid_pos[1]+skill_type<GRIDHEIGHT){
						skill_range = array_concat(skill_range, obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+skill_type));
					}
					for(i=0;i<array_length(skill_range);i++){
						if(unit.grid_pos[1]==skill_range[i]._y_coord+1){
							obj_battleEffect.push_preview(skill_range[i],2);
						}else{
							obj_battleEffect.push_preview(skill_range[i],3);
						}
					}
					
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				if (keyboard_check_pressed(ord("K"))) { // use the skill
					audio_play_sound(sfx_blast, 0, false);
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							
							if(unit.grid_pos[1]==skill_range[i]._y_coord+1){
								skill_range[i]._entity_on_tile.push_down(1);
							}else{
								skill_range[i]._entity_on_tile.push_up(1);
							}
							
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					unit.play_sound = false;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					show_debug_message(unit.action.name);
				}else if(keyboard_check_pressed(vk_tab)){
					obj_battleEffect.remove_push_preview();
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.play_sound = false;
					obj_gridCreator.reset_highlights_attack();
				}
			},
			
		}
			
	},
	pushlos: {
		name: ["Force Push", "Row Shift", "Force Pull"], //probably redundant to have a name but keep it
		description: ["Moves the first target in front in each row 1 tile to the right", "Moves all units in the same row 1 tile up or down", "Moves the first target in front in each row 1 tile to the left"],
		cost: [3, 3, 3],
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
				skill_range = [];
				for(i=0;i<GRIDHEIGHT;i++){
					skill_range = array_concat(skill_range,  obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, i));
				}
				obj_cursor.movable_tiles=[];
				if(!unit.skill_init){
					for(i=0;i<array_length(skill_range);i++){
						obj_battleEffect.push_preview(skill_range[i],0);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_push, 0, false, 0.3);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							skill_range[i]._entity_on_tile.push_back(1);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade1: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = obj_gridCreator.highlighted_target_row(unit.grid_pos[1]);
				
				obj_cursor.movable_tiles=[];
				if(!unit.skill_init){
					for(i=0;i<array_length(skill_range);i++){
						obj_battleEffect.push_preview(skill_range[i],3);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					skill_type=-1;
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(ord("S")) && skill_type==-1) {
					skill_type=1;
					obj_battleEffect.remove_push_preview();
					
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					
					
					for(i=0;i<array_length(skill_range);i++){
						obj_battleEffect.push_preview(skill_range[i],2);
						
					}
				}
				if (keyboard_check_pressed(ord("W")) && skill_type==1) { // a bunch of this is hardcoded atm
					skill_type=-1;
					obj_battleEffect.remove_push_preview();
					
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
				
					for(i=0;i<array_length(skill_range);i++){
						obj_battleEffect.push_preview(skill_range[i],3);
					}
				}
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_push, 0, false, 0.3);
					for (var i = array_length(skill_range)-1; i >=0; i--) {
						if (!skill_range[i]._is_empty) {
							if(skill_type==-1){
								skill_range[i]._entity_on_tile.push_up(1);
							}else{
								skill_range[i]._entity_on_tile.push_down(1);
							}
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
			upgrade2: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				skill_range = [];
				for(i=0;i<GRIDHEIGHT;i++){
					skill_range = array_concat(skill_range,  obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, i));
				}
				obj_cursor.movable_tiles=[];
				if(!unit.skill_init){
					for(i=0;i<array_length(skill_range);i++){
						obj_battleEffect.push_preview(skill_range[i],1);
					}
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					unit.skill_init=true;
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(ord("L"))) {
					audio_play_sound(sfx_push, 0, false, 0.3);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							skill_range[i]._entity_on_tile.push_forward(1);
						}
					}
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
					
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init=false;
					obj_battleEffect.remove_push_preview();
				
		
				}
			},
		}
	},
	nothing: {
		name: ["Wait"], //probably redundant to have a name but keep it
		description: ["Move without using a skill"],
		cost: [0],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 1, 
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				
				unit.action = unit.actions[unit.skill_used];
				if(!unit.skill_init){
					//audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					// setup initial target
					
					unit.skill_init=true;
					show_debug_message("basic init");
				}
				
				obj_cursor.movable_tiles=[];
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(vk_enter)) { // use the skill
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					
					unit.is_attacking = false;
					unit.skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
					obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
					unit.skill_init=false;
				}else if(keyboard_check_pressed(vk_tab)){
					unit.is_attacking = false;
					unit.skill_back = true;
					unit.skill_init=false;
					skill_range = obj_gridCreator.reset_highlights_target();
		
				}
			}
		}
	},
}

global.enemyActions = {
	melee: {
		name: "melee",
		range: [
			[-1, 0], [-1, -1], [-1, 1],
			[-2, 0], [-2, -1], [-2, 1],
			[-3, 0]
		],
		type: "normal",
		damage_type: "normal"
	},
	ranged_attack: {
		name: "ranged attack",
		range: [
			[-5, 0], [-6, 0], [-7, 0], [-8, 0], [-9, 0],
			[-4, 0], [-3, 0], [-2, 0], [-1, 0]
		],
		type: "normal",
		damage_type: "normal"
	},
	center_square: {
		name: "square explosion",
		range: [
			[-1, -1], [-1, 0], [-1, 1],
			[0, -1], [0, 0], [0, 1], 
			[1, -1], [1, 0], [1, 1]
		],
		type: "normal",
		damage_type: "normal"
	},
	mini_cross: {
		name: "mini explosion",
		range: [
					[-1, 0],
			[0, -1], [0, 0], [0, 1], 
					 [1, 0],
		],
		type: "normal",
		damage_type: "normal"
	},
	center_big_square: {
		name: "big square explosion",
		range: [
			[-2, -2], [-2, -1], [-2, 0], [-2, 1], [-2, 2],
			[-1, -2], [-1, -1], [-1, 0], [-1, 1], [-1, 2],
			[0, -2], [0, -1], [0, 0], [0, 1], [0, 2],
			[1, -2], [1, -1], [1, 0], [1, 1], [1, 2],
			[2, -2], [2, -1], [2, 0], [2, 1], [2, 2]
		],
		type: "normal",
		damage_type: "normal"
	},
	center_square_c: {
		name: "square explosion",
		range: [
			[-1, -1], [-1, 0], [-1, 1],
			[0, -1], [0, 0], [0, 1], 
			[1, -1], [1, 0], [1, 1]
		],
		type: "normal",
		damage_type: "cold"
	},
	center_big_square_c: {
		name: "big square explosion",
		range: [
			[-2, -2], [-2, -1], [-2, 0], [-2, 1], [-2, 2],
			[-1, -2], [-1, -1], [-1, 0], [-1, 1], [-1, 2],
			[0, -2], [0, -1], [0, 0], [0, 1], [0, 2],
			[1, -2], [1, -1], [1, 0], [1, 1], [1, 2],
			[2, -2], [2, -1], [2, 0], [2, 1], [2, 2]
		],
		type: "normal",
		damage_type: "cold"
	},
	mini_cross_push: {
		name: "push explosion",
		range: [
					[-1, 0],
			[0, -1], [0, 0], [0, 1], 
					 [1, 0],
		],
		type: "normal",
		damage_type: "push"
	},
	center_square_pushpush: {
		name: "bigger push",
		range: [
					[-1, 0],
			[0, -1], [0, 0], [0, 1], 
					 [1, 0],
		],
		type: "normal",
		damage_type: "big push"
	},
	center_big_square_pull: {
		name: "big square explosion",
				range: [
					[-2, 0],
					[-1, 0],
	[0, -2], [0, -1], [0, 0], [0, 1], [0,2],
					 [1, 0],
					 [2, 0]
		],
		type: "normal",
		damage_type: "pull"
	},
	
	homing_aoe: {
		name: "homing aoe",
		range: [
			[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]
		],
		type: "turret",
		damage_type: "normal"
	},
	summon: {
		name: "summon",
		range: [
			[0, 0]
		],
		type: "random_turret",
		damage_type: "summon"
	},
	cross: {
		name: "cross",
		range: [
			[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0], [9, 0],
			[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0], [-8, 0], [-9, 0],
			[0, 1], [0, 2], [0, 3], [0, 4],
			[0, -1], [0, -2], [0, -3], [0, -4]
			
		],
		type: "turret_no_target",
		damage_type: "normal"
	},
	sight: {
		name: "los attack",
		range: [
			[0, 0]
		],
		type: "los",
		damage_type: "normal"
	},
}
	


//Player(s) Data
global.players = [
	{ //basic guy
		name: "L'Cifure",
		hp: 3,
		hpMax: 3,
		playerSpeed: 2,
		sprites : { idle: spr_player2, dead: spr_player2_dead, gun: spr_player2_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar, global.actionLibrary.nothing],
		ally: true,
		tpGain: 1,
		portrait: spr_temp_Taion,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Taion_full,
		guy: "Damage Guy"
		
	},
	{ // dancer guy
		name: "Angel",
		hp: 3,
		hpMax: 3,
		playerSpeed: 3,
		sprites : { idle: spr_player3, dead: spr_player3_dead, gun: spr_player3_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.shield, global.actionLibrary.buff,  global.actionLibrary.dance, global.actionLibrary.nothing],
		ally: true,
		tpGain: 3,
		portrait: spr_temp_Glimmer,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Glimmer_full,
		guy: "Dancer Guy"
	},
	{ // Teleport guy
		name: "Warpman",
		hp: 3,
		hpMax: 3,
		playerSpeed: 1,
		sprites : { idle: spr_player5, dead: spr_player5_dead, gun: spr_player5_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.teleport_self, global.actionLibrary.teleport_ally,  global.actionLibrary.teleport_enemy, global.actionLibrary.nothing],
		ally: true,
		tpGain: 3,
		portrait: spr_temp_Wulfric,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Wulfric_full,
		guy: "Warper Guy"
	},
	{ //Bomb guy
		name: "Bombastic",
		hp: 4,
		hpMax: 4,
		playerSpeed: 2,
		sprites : { idle: spr_player4, dead: spr_player4_dead, gun: spr_player4_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.placebomb, global.actionLibrary.placeicebomb,  global.actionLibrary.placegravbomb, global.actionLibrary.nothing],
		ally: true,
		tpGain: 1,
		portrait: spr_temp_Azami,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Azami_full,
		guy: "Bomb Guy"
	},
	{ //freeze guy
		name: "Frozone",
		hp: 5,
		hpMax: 5,
		playerSpeed: 2,
		sprites : { idle: spr_player6, dead: spr_player6_dead, gun: spr_player6_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.freeze, global.actionLibrary.frostcone,  global.actionLibrary.thaw, global.actionLibrary.nothing],
		ally: true,
		tpGain: 1,
		portrait: spr_temp_Perun,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Perun_full,
		guy: "Freeze Guy"
	},
	{ // push guy
		name: "Oktavia",
		hp: 4,
		hpMax: 4,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead, gun: spr_player_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.mover, global.actionLibrary.pushspread,  global.actionLibrary.pushlos, global.actionLibrary.nothing],
		ally: true,
		tpGain: 2,
		portrait: spr_temp_Pandoria,
		primary: #0cac87,
		secondary: #386467,
		portrait_full: spr_Pandoria_full,
		guy: "Push Guy"
	},
	//{ //new member
	//	name: "put new party member here", //refer to example above
	//}
]

global.party=
[
	{
		info: global.players[0],
		grid: [3, 2]		
	},
	{
		info: global.players[0],
		grid: [2, 2]		
	},
	{
		info: global.players[0],
		grid: [3, 3]		
	}
];

//Enemy Data
global.enemies = [
	{//slime
		name: "Slime",
		hp: 2,
		hpMax: 2,
		healthbar_offset: -30,
		sprites: { idle: spr_slime_idle, attack: spr_slime_attack },
		actions: [global.enemyActions.melee],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		gold: 2
	},
	{//bat
		name: "Bat",
		hp: 1,
		hpMax: 1,
		healthbar_offset: -40,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.ranged_attack],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 1
	},
	{//shooter
		name: "Shooter",
		hp: 5,
		hpMax: 5,
		healthbar_offset: -60,
		sprites: { idle: spr_cannon_idle, attack: spr_cannon_attack },
		actions: [global.enemyActions.homing_aoe],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 3
	},
	{//cross
		name: "Cross",
		hp: 1,
		hpMax: 1,
		healthbar_offset: -40,
		sprites: { idle: spr_turret_idle, attack: spr_turret_attack },
		actions: [global.enemyActions.cross],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 0
	},
	{//summoner
		name: "Summoner",
		hp: 5,
		hpMax: 5,
		healthbar_offset: -40,
		sprites: { idle: spr_summoner_idle, attack: spr_summoner_attack },
		actions: [global.enemyActions.summon],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 5
	},
	{//los
		name: "LOS Enemy",
		hp: 1,
		hpMax: 1,
		healthbar_offset: -40,
		sprites: { idle: spr_skeleton_idle, attack: spr_skeleton_attack },
		actions: [global.enemyActions.sight],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 1
	}
]

//Obstacles
global.obstacles = [
	{//bomb
		name: "Bomb",
		turns_remaining: 3,
		turns_max: 3,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_square],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 3
	},
	{//big bomb
		name: "Big Bomb",
		turns_remaining: 3,
		turns_max: 3,
		sprites: { idle: spr_big_bomb, attack: spr_big_explosion },
		actions: [global.enemyActions.center_big_square],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 1
	},
	{
		name: "Basic Bomb",
		turns_remaining: 2,
		turns_max: 2,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.mini_cross],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 1
	},
	{
		name: "Bigger Bomb",
		turns_remaining: 2,
		turns_max: 2,
		sprites: { idle: spr_big_bomb, attack: spr_big_explosion },
		actions: [global.enemyActions.center_square],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 3
	},
	{
		name: "Ice Bomb",
		turns_remaining: 1,
		turns_max: 1,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_square_c],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 0
	},
	{
		name: "Freezer",
		turns_remaining: 3,
		turns_max: 3,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_square_c],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 0
	},
	{
		name: "Ice Age",
		turns_remaining: 1,
		turns_max: 1,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_big_square_c],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 1
	},
	{
		name: "Push Bomb",
		turns_remaining: 1,
		turns_max: 1,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.mini_cross_push],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 0
	},
	{
		name: "Pull Bomb",
		turns_remaining: 3,
		turns_max: 3,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_big_square_pull],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 0
	},
	{
		name: "Double Push Bomb",
		turns_remaining: 1,
		turns_max: 1,
		sprites: { idle: spr_bomb, attack: spr_explosion },
		actions: [global.enemyActions.center_square_pushpush],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		hp: 999,
		healthbar_offset: -30,
		strength: 1
	}
]

// Encounters specifically for the tutorial
global.tutorialenc = [
	[
		{
			info: global.enemies[1],
			grid: [6, 3]
		},
		{
			info: global.enemies[1],
			grid: [7, 2]
		}
	],
	[
		{
			info: global.enemies[0],
			grid: [7, 1]
		},
		{
			info: global.enemies[0],
			grid: [8, 1]
		},
		{
			info: global.enemies[0],
			grid: [9, 1]
		},
		{
			info: global.enemies[0],
			grid: [7, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 3]
		},
		{
			info: global.enemies[0],
			grid: [9, 3]
		},
	],
	[
	{
			info: global.enemies[1],
			grid: [5, 2]
		},
		{
			info: global.enemies[1],
			grid: [6, 1]
		},
		{
			info: global.enemies[1],
			grid: [6, 2]
		},
		{
			info: global.enemies[1],
			grid: [6, 3]
		},
		{
			info: global.enemies[1],
			grid: [7, 2]
		}
	]
]

//Encounters
//global.encounters = [
//	[
//		{
//			info: global.enemies[1],
//			grid: [8, 3]
//		},
//		{
//			info: global.enemies[0],
//			grid: [8, 2]
//		}
		
//	],
//	[
//		{
//			info: global.enemies[0],
//			grid: [8, 1]
//		},
//		{
//			info: global.enemies[0],
//			grid: [8, 2]
//		},
//		{
//			info: global.enemies[0],
//			grid: [8, 3]
//		}
//	],
//	[
//		{
//			info: global.enemies[1],
//			grid: [8, 1]
//		},
//		{
//			info: global.enemies[1],
//			grid: [8, 3]
//		}
//	],
//	[
//		{
//			info: global.enemies[1],
//			grid: [6, 2]
//		},
//		{
//			info: global.enemies[1],
//			grid: [7, 1]
//		},
//		{
//			info: global.enemies[1],
//			grid: [7, 3]
//		},
//		{
//			info: global.enemies[1],
//			grid: [7, 2]
//		},
//		{
//			info: global.enemies[1],
//			grid: [8, 2]
//		}
//	],
//	[
//		{
//			info: global.enemies[2],
//			grid: [8, 2]
//		}
//	],
//	[
//		{
//			info: global.enemies[4],
//			grid: [8, 2]
//		}
//	]

//]

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
		
	], // 3 gold
	[
		{
			info: global.enemies[5],
			grid: [8, 1]
		},
		{
			info: global.enemies[5],
			grid: [8, 3]
		},
		{
			info: global.enemies[5],
			grid: [8, 2]
		},
		{
			info: global.enemies[5],
			grid: [8, 4]
		},
		{
			info: global.enemies[5],
			grid: [8, 0]
		}
	], // 5 gold
	[
		{
			info: global.enemies[1],
			grid: [8, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		},
		{
			info: global.enemies[0],
			grid: [7, 2]
		},
		{
			info: global.enemies[0],
			grid: [7, 3]
		}
		
	], // 7 gold
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
	], // 5 gold
	[
		{
			info: global.enemies[5],
			grid: [8, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		},
		{
			info: global.enemies[0],
			grid: [7, 3]
		},
		{
			info: global.enemies[1],
			grid: [6, 3]
		},
		{
			info: global.enemies[5],
			grid: [8, 1]
		},
		
	], // 7 gold, end of floor 1
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
		},
		{
			info: global.enemies[0],
			grid: [8, 4]
		},
		{
			info: global.enemies[0],
			grid: [8, 0]
		}
	], // 10 gold
	[
		{
			info: global.enemies[2],
			grid: [9, 2]
		},
		{
			info: global.enemies[1],
			grid: [8, 1]
		},
		{
			info: global.enemies[1],
			grid: [8, 3]
		}
	], // 5 gold
	
	[
		{
			info: global.enemies[2],
			grid: [9, 1]
		},
		{
			info: global.enemies[2],
			grid: [9, 3]
		},
		{
			info: global.enemies[1],
			grid: [8, 1]
		},
		{
			info: global.enemies[1],
			grid: [8, 3]
		}
		
	], // 8 gold
	[
		
		{
			info: global.enemies[2],
			grid: [8, 2]
		},
		{
			info: global.enemies[5],
			grid: [8, 0]
		},
		{
			info: global.enemies[2],
			grid: [8, 4]
		},
		{
			info: global.enemies[2],
			grid: [8, 3]
		},
		
	], // 10 gold
	[
		{
			info: global.enemies[2],
			grid: [9, 1]
		},
		{
			info: global.enemies[2],
			grid: [9, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 1]
		},
		{
			info: global.enemies[0],
			grid: [8, 3]
		},
	], // 10 gold, end of floor 2
	[
		{
			info: global.enemies[4],
			grid: [9, 2]
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
	], // 8 gold
	[
		{
			info: global.enemies[4],
			grid: [9, 1]
		},
		{
			info: global.enemies[4],
			grid: [9, 3]
		},
		{
			info: global.enemies[1],
			grid: [7, 2]
		},
		{
			info: global.enemies[1],
			grid: [8, 2]
		}
		
	], // 12 gold
	[
		{
			info: global.enemies[2],
			grid: [5, 0]
		},
		{
			info: global.enemies[2],
			grid: [5, 4]
		},
		{
			info: global.enemies[4],
			grid: [9, 1]
		},
		
		
	], // 11 gold
	[
		{
			info: global.enemies[4],
			grid: [9, 1]
		},
		{
			info: global.enemies[4],
			grid: [9, 3]
		},
		{
			info: global.enemies[0],
			grid: [7, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 3]
		},
		
	], // 14 gold
	[
		{
			info: global.enemies[4],
			grid: [9, 1]
		},
		{
			info: global.enemies[4],
			grid: [9, 3]
		},
		{
			info: global.enemies[2],
			grid: [8, 2]
		},
		{
			info: global.enemies[2],
			grid: [8, 4]
		},
		{
			info: global.enemies[2],
			grid: [8, 0]
		},
		{
			info: global.enemies[1],
			grid: [7, 2]
		},
		{
			info: global.enemies[1],
			grid: [7, 3]
		}
		
	], // 21 gold, end of floor 3
	
	//[
	//	{
	//		info: global.enemies[1],
	//		grid: [8, 3]
	//	},
	//	{
	//		info: global.enemies[0],
	//		grid: [8, 2]
	//	}
		
	//],
	
	
]