gridHoriz = GRIDWIDTH;
gridVert = GRIDHEIGHT;

battle_grid = ds_grid_create(gridHoriz, gridVert);


// get co-ordinates for the middle of the tile at (x,y)
// (0,0) is top left
// arr[0] is the x and arr[1] is the y
// make sure your sprites are aligned at the middle of their feet
get_coordinates = function(_x_value, _y_value){
	
	coordinates = [x+CELLWIDTH/2+(_x_value*CELLWIDTH), y+CELLHEIGHT/2+(_y_value*CELLHEIGHT) ];
	return coordinates;
}

move_entity = function(_prev_x,_prev_y,_new_x,_new_y){
	var _entity_pointer = battle_grid[_prev_x][_prev_y]._entity_on_tile;
	if(!battle_grid[_prev_x][_prev_y]._is_empty){
		battle_grid[_new_x][_new_y]._entity_on_tile = _entity_pointer;
		battle_grid[_prev_x][_prev_y]._entity_on_tile = pointer_null;
		battle_grid[_prev_x][_prev_y]._is_empty = true;
		battle_grid[_new_x][_new_y]._is_empty = false;
	}
}

for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		var coordinates = get_coordinates(i,j);
		var _tile = instance_create_layer(coordinates[0],coordinates[1],"Tiles",obj_tile_class);
		battle_grid[i][j]=_tile;
		
		battle_grid[i][j].set_coords(i,j);
	}
}