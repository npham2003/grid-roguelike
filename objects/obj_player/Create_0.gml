moveable_grids = [];
move_range = 2; // temp val, change during initialization
skill_used = 0; // just to determine whether we do j k l, maybe it's not optimized
skill_range = [];
skill_range_aux = [];
skill_coords = [];
skill_complete = false;
skill_init = false;
prev_grid = [];

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

function baseattack() {
	action = actions[0];
	skill_range = obj_gridCreator.highlighted_attack_line(grid_pos[0], grid_pos[1]);
	if (keyboard_check_pressed(vk_enter)) {
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 5; // temp var until we get shit moving
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		skill_complete = true;
		skill_range = obj_gridCreator.reset_highlights_attack();
	}
}

function skill1() {
	action = actions[1];
	skill_range = obj_gridCreator.highlighted_attack_line_pierce(grid_pos[0], grid_pos[1]);
	if (keyboard_check_pressed(vk_enter)) {
		for (var i = 0; i < array_length(skill_range); i++) {
			if (!skill_range[i]._is_empty) {
				show_debug_message(skill_range[i]._entity_on_tile.hp);
				skill_range[i]._entity_on_tile.hp -= 5; // temp var until we get shit moving
				show_debug_message(skill_range[i]._entity_on_tile.hp);
			}
		}
		skill_complete = true;
		skill_range = obj_gridCreator.reset_highlights_attack();
	show_debug_message(action.name);
	}
}

function skill2() {
	action = actions[2];
	if (!skill_init) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
	skill_coords[0] = grid_pos[0] + 4;
	skill_coords[1] = grid_pos[1];
	skill_init = true;
	}
	skill_range = obj_gridCreator.highlighted_attack_line_range(grid_pos[0], grid_pos[1], 5);
	skill_range_aux = obj_gridCreator.highlighted_target_circle(skill_coords[0], skill_coords[1],1);
	if (keyboard_check_pressed(ord("A")) && skill_coords[0] > grid_pos[0]) {
		skill_coords[0] -= 1;
	}
	else if (keyboard_check_pressed(ord("D")) && skill_coords[0] < grid_pos[0]+4) { // a bunch of this is hardcoded atm
		skill_coords[0] += 1;
	}
	if (keyboard_check_pressed(vk_enter)) {
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
		}
}