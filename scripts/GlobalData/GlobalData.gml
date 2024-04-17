global.controls = ["H", "J", "K", "L"];

//Action Library
// _damage+unit.attack_bonus+unit.attack_bonus_temp
// THIS IS THE DAMAGE FORMULA
global.actionLibrary = {
	baseAttack: {
		name: ["Base Attack"], //probably redundant to have a name but keep it
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
					// setup initial target
					skill_range = obj_gridCreator.highlighted_target_straight(unit.grid_pos[0]+1, unit.grid_pos[1]);
					unit.skill_init=true;
					show_debug_message("basic init");
				}
				
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("H"))) { // use the skill
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
	beam: {
		name: ["Beam", "Big Beam", "Repel Beam"], 
		description: ["Does 1 damage to all targets in a row", "Does 1 damage to all targets in surrounding rows. Double damage if target is in the same row", "Does 1 damage to all targets in a row and pushes them back 1 tile."],
		cost: [3, 6, 4],
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
				
				if (!unit.play_sound) { //play beam sound once
					audio_play_sound(sfx_beam_windup, 0, false);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]);
				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) { // use the skill
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
					audio_play_sound(sfx_beam_windup, 0, false);
					unit.play_sound = true;
				}
				unit.is_attacking = true;
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				skill_range = array_concat(obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]+1),obj_gridCreator.highlighted_target_line_pierce(unit.grid_pos[0]+1, unit.grid_pos[1]-1));

				obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
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
					audio_play_sound(sfx_beam_windup, 0, false);
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) { // use skill
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
		description: ["Hits a nearby target and damages all adjacent units", "Hits any target and damages all adjacent units", "Hits a nearby target and damages and pushes all adjacent units. Center target takes double damage."],
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
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
					audio_play_sound(sfx_mortar_windup, 0, false);
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							
							if(skill_coords[1]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]){
									obj_battleEffect.push_preview(skill_range_aux[i],3);
								}
							}
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]){
								obj_battleEffect.push_preview(skill_range_aux[i],2);
							}
							if(skill_coords[0]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],1);
								}
							}
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]){
								obj_battleEffect.push_preview(skill_range_aux[i],0);
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
				skill_range = obj_gridCreator.highlighted_attack_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
				if(keyboard_check_pressed(vk_anykey)){
					obj_battleEffect.remove_push_preview();
					for (var i = 0; i < array_length(skill_range_aux); i++) {
						if (!skill_range_aux[i]._is_empty) {
							
							if(skill_coords[1]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1]){
									obj_battleEffect.push_preview(skill_range_aux[i],3);
								}
							}
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1]){
								obj_battleEffect.push_preview(skill_range_aux[i],2);
							}
							if(skill_coords[0]-1>=0){
								if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]]){
									obj_battleEffect.push_preview(skill_range_aux[i],1);
								}
							}
							if(skill_range_aux[i]==obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]]){
								obj_battleEffect.push_preview(skill_range_aux[i],0);
							}
							
						}
					}
				}
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
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
		
				}
			},
		}
	},
	charge: {
		name: ["Charge", "Long Charge", "Parry"], //probably redundant to have a name but keep it
		description: ["Gain 1 TP", "Gain 3 TP but move back to your original position", "Protect yourself from the next attack that hits you"],
		cost: [0, 0, 2],
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(unit){
				unit.action = unit.actions[unit.skill_used];
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
	
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,3);
					audio_play_sound(sfx_charge, 0, false,0.3);
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
				
			},
			upgrade1: function(unit){
				unit.action = unit.actions[unit.skill_used];
				
				if (!unit.skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.back_move();
					unit.skill_init = true;
					
				}
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
				obj_cursor.reset_cursor(unit.grid_pos[0],unit.grid_pos[1]);
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,3);
					audio_play_sound(sfx_charge, 0, false,0.3);
					obj_battleControl.tp_current+=3;
					if(obj_battleControl.tp_current>obj_battleControl.tp_max){
						obj_battleControl.tp_current=obj_battleControl.tp_max;
					}
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
					
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
					unit.skill_init = false;
		
				}
				
			},
			upgrade2: function(unit){
				unit.action = unit.actions[unit.skill_used];
				skill_range = [obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]];
				obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._target_highlight=true;
				obj_cursor.movable_tiles=skill_range;
	
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					obj_battleEffect.hit_animation(unit,4);
					audio_play_sound(sfx_shield, 0, false,0.3);
					unit.shield+=1;
					unit.skill_complete = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
		
				}else if(keyboard_check_pressed(vk_tab)){
					unit.skill_back = true;
					unit.skill_range = obj_gridCreator.reset_highlights_target();
		
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
	
					audio_play_sound(sfx_mortar_windup, 0, false);
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
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
	
					audio_play_sound(sfx_mortar_windup, 0, false);
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
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
	
					audio_play_sound(sfx_mortar_windup, 0, false);
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
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
	swap: {
		name: ["Warp", "Swap", "Rescue"], //probably redundant to have a name but keep it
		description: [ "Move an adjacent ally to an empty nearby space. Can include yourself", "Swap the positions of 2 allies. Can include yourself", "Moves a nearby ally to an adjacent empty tile"],
		cost: [5, 5, 7],
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
				}
				if(unit.skill_progress==2){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				}
				
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								unit.skill_progress=2;
								array_push(skill_range_aux,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]);
								audio_play_sound(sfx_teleport_select, 0, false, 1);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					else if(unit.skill_progress==2){
						if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(skill_coords[0]<5){
								audio_play_sound(sfx_teleport, 0, false, 1);
								skill_range_aux[0]._entity_on_tile.grid_pos = [skill_range_aux[1]._x_coord,skill_range_aux[1]._y_coord];
								
								skill_range_aux[1]._entity_on_tile = skill_range_aux[0]._entity_on_tile;
								skill_range_aux[0]._entity_on_tile = pointer_null;
								skill_range_aux[0]._is_empty = true;
								skill_range_aux[1]._is_empty = false;
								skill_range_aux[1]._entity_on_tile.teleporting = 1;

								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					if(unit.skill_progress==2){
						unit.skill_progress=1;
						skill_range_aux[1]._target_highlight=false;
						array_delete(skill_range_aux,1,1);
						obj_cursor.reset_cursor(skill_range_aux[0]._x_coord,skill_range_aux[0]._y_coord);
						skill_coords[0]=skill_range_aux[0]._x_coord;
						skill_coords[1]=skill_range_aux[0]._y_coord;
					}else{
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					}
		
				}
			},
			upgrade1: function(unit){
				if(unit.skill_complete){
					return;
				}
				obj_gridCreator.reset_highlights_target();
				unit.action = unit.actions[unit.skill_used];
				var _damage = unit.action.damage;
				if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
					unit.range = 3;
					skill_coords[0] = unit.grid_pos[0];
					skill_coords[1] = unit.grid_pos[1];
					unit.skill_progress = 1;
					unit.is_attacking = true;
					skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
				}
				skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								audio_play_sound(sfx_teleport_select, 0, false, 1);
								unit.skill_progress=2;
								array_push(skill_range_aux,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					else if(unit.skill_progress==2){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								audio_play_sound(sfx_teleport, 0, false, 1);
								temp = skill_range_aux[0]._entity_on_tile;
								skill_range_aux[0]._entity_on_tile = skill_range_aux[1]._entity_on_tile;
								skill_range_aux[1]._entity_on_tile = temp;
								
								skill_range_aux[1]._entity_on_tile.teleporting = 1;
								skill_range_aux[0]._entity_on_tile.teleporting = 1;
								
								
								temp = skill_range_aux[0]._entity_on_tile.grid_pos;
								skill_range_aux[0]._entity_on_tile.grid_pos = skill_range_aux[1]._entity_on_tile.grid_pos;
								skill_range_aux[1]._entity_on_tile.grid_pos= temp;
								
								
								
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					if(unit.skill_progress==2){
						unit.skill_progress=1;
						skill_range_aux[1]._target_highlight=false;
						array_delete(skill_range_aux,1,1);
						obj_cursor.reset_cursor(skill_range_aux[0]._x_coord,skill_range_aux[0]._y_coord);
						skill_coords[0]=skill_range_aux[0]._x_coord;
						skill_coords[1]=skill_range_aux[0]._y_coord;
					}else{
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					}
		
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
				}
				if(unit.skill_progress==2){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
				}
				if(unit.skill_progress==1){
					skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
				}
				
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
								audio_play_sound(sfx_teleport_selec, 0, false, 1);
								unit.skill_progress=2;
								array_push(skill_range_aux,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]);
								skill_coords[0]=unit.grid_pos[0];
								skill_coords[1]=unit.grid_pos[1];
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					else if(unit.skill_progress==2){
						if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
							if(skill_coords[0]<5){
								audio_play_sound(sfx_teleport, 0, false, 1);
								skill_range_aux[0]._entity_on_tile.grid_pos = [skill_range_aux[1]._x_coord,skill_range_aux[1]._y_coord];
								
								skill_range_aux[1]._entity_on_tile = skill_range_aux[0]._entity_on_tile;
								skill_range_aux[0]._entity_on_tile = pointer_null;
								skill_range_aux[0]._is_empty = true;
								skill_range_aux[1]._is_empty = false;
								skill_range_aux[1]._entity_on_tile.teleporting = 1;
								unit.is_attacking = false;
								skill_range = obj_gridCreator.reset_highlights_support();
								skill_range_aux = obj_gridCreator.reset_highlights_target();
								unit.skill_complete = true;
								unit.skill_init = false;
								unit.skill_progress=0;
								show_debug_message(unit.action.name);
							}else{
								audio_play_sound(sfx_no_tp, 0, false);
							}
						}else{
							audio_play_sound(sfx_no_tp, 0, false);
						}
					}
					
					
					
				}else if(keyboard_check_pressed(vk_tab)){
					if(unit.skill_progress==2){
						unit.skill_progress=1;
						skill_range_aux[1]._target_highlight=false;
						array_delete(skill_range_aux,1,1);
						obj_cursor.reset_cursor(skill_range_aux[0]._x_coord,skill_range_aux[0]._y_coord);
						skill_coords[0]=skill_range_aux[0]._x_coord;
						skill_coords[1]=skill_range_aux[0]._y_coord;
					}else{
						unit.is_attacking = false;
						unit.skill_back = true;
						unit.skill_range = obj_gridCreator.reset_highlights_target();
						unit.skill_range = obj_gridCreator.reset_highlights_support();
						unit.skill_progress=0;
					}
		
				}
			}
		}
	},
	stall: {
		name: ["Freeze", "Deep Freeze", "Piercing Freeze"], //probably redundant to have a name but keep it
		description: ["Prevents the first target in a row from moving for 1 turn", "Prevents the first target in a row from moving for 2 turns", "Prevents all targets in a row from moving for 1 turn"],
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
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							skill_range[i]._entity_on_tile.stall_turns+=1;
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 1, c_blue);
							skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
							
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
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							skill_range[i]._entity_on_tile.stall_turns+=2;
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 2, c_blue);
							skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
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
				}
				if(array_length(skill_range)>0 && !unit.skill_complete){
					obj_cursor.reset_cursor(skill_range[0]._x_coord,skill_range[0]._y_coord);
				}
				
				var _damage = unit.action.damage;
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_freeze, 0, false, 0.5);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							skill_range[i]._entity_on_tile.stall_turns+=1;
							if(skill_range[i]._entity_on_tile.ally){
								skill_range[i]._entity_on_tile.has_attacked=true;
								skill_range[i]._entity_on_tile.has_moved=true;
							}else{
								skill_range[i]._entity_on_tile.remove_danger_highlights();
							}
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, 1, c_blue);
							skill_range[i]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(skill_range[i]._entity_on_tile, 6);
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
		description: [ "Make an adjacent ally do 1 extra damage for 2 turns. Can include yourself", "Make a nearby ally do 1 extra damage for 2 turns. Can include yourself", "Make an adjacent ally do 2 extra damage for 2 turns. Can include yourself"],
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
		description: [ "Allow an adjacent ally to move an extra tile for 2 turns. Can include yourself", "Allow an adjacent ally to move 2 extra tiles for 2 turns. Can include yourself", "Allow an adjacent ally to act again"],
		cost: [5, 6, 8],
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
					audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
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
				skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
				for (var i = 0; i < array_length(skill_range_aux); i++) {
					skill_range_aux[i]._target_highlight=true;
				}
				//show_debug_message(string(unit.skill_progress));
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
					if(unit.skill_progress==1){
						if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
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
		tpGain: 1,
		portrait: spr_temp_Akeha,
		primary: #0cac87,
		secondary: #386467
		
	},
	{ //oktavia
		name: "Oktavia",
		hp: 3,
		hpMax: 3,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead, gun: spr_player_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.minefield, global.actionLibrary.mover,  global.actionLibrary.swap],
		ally: true,
		tpGain: 2,
		portrait: spr_temp_Gayle,
		primary: #0cac87,
		secondary: #386467
	},
	{ //l'cifure
		name: "Angel",
		hp: 3,
		hpMax: 3,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead, gun: spr_player_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.stall, global.actionLibrary.buff,  global.actionLibrary.dance],
		ally: true,
		tpGain: 3,
		portrait: spr_temp_Zero,
		primary: #0cac87,
		secondary: #386467
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
	},
	{
		name: "Shooter",
		hp: 3,
		hpMax: 3,
		healthbar_offset: -40,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.homing_aoe],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 100
	},
	{
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
	{
		name: "Summoner",
		hp: 3,
		hpMax: 3,
		healthbar_offset: -40,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.summon],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 200
	}
]

//Obstacles
global.obstacles = [
	{
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
	{
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
	]
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
	[
		{
			info: global.enemies[2],
			grid: [8, 2]
		}
	],
	[
		{
			info: global.enemies[4],
			grid: [8, 2]
		}
	]

]