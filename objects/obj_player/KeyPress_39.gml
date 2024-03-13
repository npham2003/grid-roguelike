/// @description move right
// You can write your code in this editor
if (is_moving) {
	for (var i = 0; i < array_length(moveable_tiles); i++) {
		if (x_pos < (GRIDWIDTH/2-1) && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos+1][y_pos]) {
		//show_debug_message("it exists");
		//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
		x += CELLWIDTH;
		x_pos += 1;
		break;
		}
	}
}

// note, to change if we want to go past the middle, change gridwidth/2-1