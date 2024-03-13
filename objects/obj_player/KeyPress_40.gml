/// @description move down
// You can write your code in this editor
if (is_acting) {
	for (var i = 0; i < array_length(moveable_tiles); i++) {
		if (y_pos > 0 && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos][y_pos-1]) {
		//show_debug_message("it exists");
		//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
		y += CELLHEIGHT; // eventually make it so that we move to the tile coord, not manually move
		y_pos -= 1;
		break;
		}
	}
}