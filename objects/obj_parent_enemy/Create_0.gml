unitSpeed = 1;
x_pos = 8 // temp x spawn coords that will update as we move
y_pos = 2; // temp y spawn coords that will update as we move
is_acting = false;
is_moving = false;
moveable_tiles = [];
moveSpeed = 1;

CheckTiles = function() {
	if (!is_moving) {
	moveable_tiles = obj_gridCreator.highlighted_move(x_pos,y_pos,moveSpeed);
	}
}