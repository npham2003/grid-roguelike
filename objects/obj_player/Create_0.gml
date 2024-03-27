moveable_grids = [];
move_range = 2; // temp val, change during initialization
skill_used = 0; // just to determine whether we do j k l, maybe it's not optimized
skill_range = [];
skill_range_aux = [];
skill_coords = [];
skill_complete = false;
skill_init = false;
play_sound = false; // temp var, will change later
prev_grid = [];
skill_names = ["Base Attack", "Beam", "Mortar"];
skill_descriptions=["Hits the first target in a row", "Hits all targets in a row", "Hits a target in front and damages all adjacent units"];
skill_back = false;

var return_coords;

show_debug_message("{0}: [{1}, {2}]", name, grid_pos[0], grid_pos[1]);

// todo: set entity on the grid

has_moved = false;
has_attacked = false;

function show_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	prev_grid = [grid_pos[0], grid_pos[1]];
	moveable_grids = obj_gridCreator.highlighted_move(grid_pos[0], grid_pos[1], move_range);	
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function show_moveable_grids_prev() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	
	moveable_grids = obj_gridCreator.highlighted_move(prev_grid[0], prev_grid[1], move_range);	
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function move_up() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] - 1]) {
		y -= CELLHEIGHT; // eventually make it so that we move to the tile coord, not manually move
		grid_pos[1] -= 1;
		break;
		}
	}
}

function move_down() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] < GRIDHEIGHT - 1
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] + 1]) {
			y += CELLHEIGHT;
			grid_pos[1] += 1;
			break;
		}
	}
}

function move_left() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] - 1][grid_pos[1]]) {
			x -= CELLWIDTH;
			grid_pos[0] -= 1;
			break;
		}
	}
}

function move_right() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] < (GRIDWIDTH / 2 - 1)
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] + 1][grid_pos[1]]) {
			x += CELLWIDTH;
			grid_pos[0] += 1;
			break;
		}
	}
}

function confirm_move() {
	//obj_gridCreator.move_entity(prev_grid[0], prev_grid[1], grid_pos[0], grid_pos[1]);
	obj_gridCreator.reset_highlights_move();
}

function back_move(){
	
	grid_pos=prev_grid;
	return_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
	x=return_coords[0];
	y=return_coords[1];
	obj_gridCreator.reset_highlights_move();
}

function baseattack() {
	action = actions[0];
	obj_info_panel.set_text("Cost: "+string(actions[0].cost)+"\n"+skill_descriptions[0]+"\nWASD - Aim\nJ - Confirm\nKL - Back");
	skill_range = obj_gridCreator.highlighted_target_straight(grid_pos[0], grid_pos[1]);
	
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
		audio_play_sound(sfx_base_laser, 0, false);
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 5; // temp var until we get shit moving
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		skill_complete = true;
		skill_range = obj_gridCreator.reset_highlights_target();
	}else if(keyboard_check_pressed(ord("K")) || keyboard_check_pressed(ord("L"))){
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
	skill_range = obj_gridCreator.highlighted_target_line_pierce(grid_pos[0]+1, grid_pos[1]);
	obj_info_panel.set_text("Cost: "+string(actions[1].cost)+"\n"+skill_descriptions[1]+"\nWASD - Aim\nK - Confirm\nJL - Back");
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
		audio_play_sound(sfx_blast, 0, false);
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 5; // temp var until we get shit moving
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		skill_complete = true;
		play_sound = false;
		skill_range = obj_gridCreator.reset_highlights_target();
	show_debug_message(action.name);
	}else if(keyboard_check_pressed(ord("J")) || keyboard_check_pressed(ord("L"))){
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		play_sound = false;
	}
}

function skill2() {
	action = actions[2];
	if (!skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
	skill_coords[0] = grid_pos[0] + 4;
	skill_coords[1] = grid_pos[1];
	skill_init = true;
	audio_play_sound(sfx_mortar_windup, 0, false);
	}
	obj_info_panel.set_text("Cost: "+string(actions[2].cost)+"\n"+skill_descriptions[2]+"\nWASD - Aim\nL - Confirm\nJK - Back");
	skill_range = obj_gridCreator.highlighted_attack_line_range(grid_pos[0], grid_pos[1], 5);
	skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
	if (keyboard_check_pressed(ord("A")) && skill_coords[0] > grid_pos[0]) {
		audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
		skill_coords[0] -= 1;
	}
	else if (keyboard_check_pressed(ord("D")) && skill_coords[0] < grid_pos[0]+4) { // a bunch of this is hardcoded atm
		audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
		skill_coords[0] += 1;
	}
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("L"))) {
		audio_play_sound(sfx_blast, 0, false, 1, 0, 0.7);
		for (var i = 0; i < array_length(skill_range_aux); i++) {
			if (!skill_range_aux[i]._is_empty) {
				show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
				skill_range_aux[i]._entity_on_tile.hp -= 5; // temp var until we get shit moving
				show_debug_message(skill_range_aux[i]._entity_on_tile.hp);
			}
		}
		skill_range = obj_gridCreator.reset_highlights_attack();
		skill_range_aux = obj_gridCreator.reset_highlights_target();
		skill_complete = true;
		skill_init = false;
		show_debug_message(action.name);
		}else if(keyboard_check_pressed(ord("K")) || keyboard_check_pressed(ord("J"))){
		skill_back = true;
		skill_range = obj_gridCreator.reset_highlights_target();
		skill_range = obj_gridCreator.reset_highlights_attack();
		skill_init = false;
		
	}
}