moveable_grids = [];
move_range = 2;

prev_grid = [];

show_debug_message("{0}: [{1}, {2}]", name, grid_pos[0], grid_pos[1]);

// todo: set entity on the grid

function show_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	prev_grid = [grid_pos[0], grid_pos[1]];
	moveable_grids = obj_gridCreator.highlighted_move(grid_pos[0], grid_pos[1], move_range);	
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
	obj_gridCreator.reset_highlights();
}