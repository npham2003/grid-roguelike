moveable_grids = [];
move_range = 2; // temp val, change during initialization
skill_used = 0; // just to determine whether we do j k l, maybe it's not optimized
skill_range = [];
skill_range_aux = [];
skill_coords = [];
skill_complete = false;
skill_init = false;
play_sound = false; // temp var, will change later
is_attacking = false; // for sprite
new_coords = [];
prev_grid = [];
skill_back = false;

var return_coords;

show_debug_message("{0}: [{1}, {2}]", name, grid_pos[0], grid_pos[1]);

// todo: set entity on the grid

has_moved = false;
has_attacked = false;

function show_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	prev_grid = [grid_pos[0], grid_pos[1]];
	show_debug_message(grid_pos[0]);
	show_debug_message(grid_pos[1]);
	moveable_grids = obj_gridCreator.highlighted_move(grid_pos[0], grid_pos[1], move_range);
	obj_cursor.movable_tiles=moveable_grids;
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function preview_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	obj_gridCreator.highlighted_move_cursor(grid_pos[0], grid_pos[1], move_range);	
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function show_moveable_grids_prev() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	
	moveable_grids = obj_gridCreator.highlighted_move(prev_grid[0], prev_grid[1], move_range);
	obj_cursor.movable_tiles=moveable_grids;
	obj_cursor.reset_cursor(grid_pos[0],grid_pos[1]);
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function move_up() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] - 1]) {
		grid_pos[1] -= 1;
		break;
		}
	}
}

function move_down() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] < GRIDHEIGHT - 1
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] + 1]) {
			grid_pos[1] += 1;
			break;
		}
	}
}

function move_left() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] - 1][grid_pos[1]]) {
			grid_pos[0] -= 1;
			break;
		}
	}
}

function move_right() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] < (GRIDWIDTH / 2 - 1)
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] + 1][grid_pos[1]]) {
			grid_pos[0] += 1;
			break;
		}
	}
}

function confirm_move() {
	obj_gridCreator.remove_entity(prev_grid[0],prev_grid[1]);
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
	obj_gridCreator.reset_highlights_move();
	
	
}

function back_move(){
	
	grid_pos=prev_grid;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	return_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
	x=return_coords[0];
	y=return_coords[1];
	obj_gridCreator.reset_highlights_move();
}

function baseattack() {
	action = actions[0];
	is_attacking = true;
	//obj_info_panel.set_text("Cost: "+string(actions[0].cost)+"\n"+actions[0].description+"\nWASD - Aim\nJ - Confirm\nTab - Back");
	obj_info_panel.set_text("Cost: "+string(actions[0].cost)+"\n"+skill_descriptions[0]+"\nWASD - Aim\nJ - Confirm\nTab - Back");
	skill_range = obj_gridCreator.highlighted_target_straight(grid_pos[0]+1, grid_pos[1]);
	obj_cursor.movable_tiles=skill_range;
	
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
		audio_play_sound(sfx_base_laser, 0, false);
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 1; // temp var until we get shit moving
				
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		is_attacking = false;
		skill_complete = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		
	}else if(keyboard_check_pressed(vk_tab)){
		is_attacking = false;
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		
	}
}

function skill1() {
	if (!play_sound) {
	audio_play_sound(sfx_beam_windup, 0, false);
	play_sound = true;
	}
	action = actions[1];
	is_attacking = true;
	skill_range = obj_gridCreator.highlighted_target_line_pierce(grid_pos[0]+1, grid_pos[1]);
	obj_cursor.movable_tiles=[obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]];
	obj_info_panel.set_text("Cost: "+string(actions[1].cost)+"\n"+actions[1].description+"\nWASD - Aim\nK - Confirm\nTab - Back");
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
		audio_play_sound(sfx_blast, 0, false);
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 1; // temp var until we get shit moving
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		is_attacking = false;
		skill_complete = true;
		play_sound = false;
		skill_range = obj_gridCreator.reset_highlights_target();
	show_debug_message(action.name);
	}else if(keyboard_check_pressed(vk_tab)){
		is_attacking = false;
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		play_sound = false;
	}
}

function skill3() {
	action = actions[2];
	is_attacking = true;
	if (!skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
	range = 3;
	skill_coords[0] = grid_pos[0] + range;
	skill_coords[1] = grid_pos[1];
	skill_init = true;
	
	audio_play_sound(sfx_mortar_windup, 0, false);
	}
	obj_info_panel.set_text("Cost: "+string(actions[3].cost)+"\n"+actions[3].description+"\nWASD - Aim\n; - Confirm\nTab - Back");
	skill_range = obj_gridCreator.highlighted_attack_circle(grid_pos[0], grid_pos[1], range);
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
				skill_range_aux[i]._entity_on_tile.hp -= 1; // temp var until we get shit moving
				show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
			}
		}
		
		skill_range = obj_gridCreator.reset_highlights_attack();
		skill_range_aux = obj_gridCreator.reset_highlights_target();
		is_attacking = false;
		skill_complete = true;
		skill_init = false;
		show_debug_message(action.name);
		}else if(keyboard_check_pressed(vk_tab)){
		is_attacking = false;
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		skill_range = obj_gridCreator.reset_highlights_attack();
		skill_init = false;
		
	}
}

function skill2() {
	action = actions[0];
	obj_info_panel.set_text("Cost: "+string(actions[2].cost)+"\n"+actions[2].description+"\nL - Confirm\nTab - Back");
	skill_range = [obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]];
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._target_highlight=true;
	obj_cursor.movable_tiles=skill_range;
	
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
		obj_battleControl.tp_current+=2;
		if(obj_battleControl.tp_current>obj_battleControl.tp_max){
			obj_battleControl.tp_current=obj_battleControl.tp_max;
		}
		skill_complete = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		
	}else if(keyboard_check_pressed(vk_tab)){
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		
	}
}