unitSpeed = 1;
x_pos = 3 // temp x spawn coords that will update as we move
y_pos = 2; // temp y spawn coords that will update as we move
is_acting = false;
moveable_tiles = [];

CheckTiles = function() {
	moveable_tiles = obj_gridCreator.highlighted_move(x_pos,y_pos,playerSpeed);
}