movable_tiles=[];
current_x=0;
current_y=0;

move_cursor = function(new_x, new_y){
	obj_gridCreator.reset_highlights_target();
	if(new_x>=0 && new_x<GRIDWIDTH && new_y >= 0 && new_y<GRIDHEIGHT){
		if(array_contains(movable_tiles,obj_gridCreator.battle_grid[new_x][new_y])){
			current_x=new_x;
			current_y=new_y;
		}
	}
	
}

reset_cursor = function(new_x, new_y){
	current_x=new_x;
	current_y=new_y;
}