gridHoriz = GRIDWIDTH;
gridVert = GRIDHEIGHT;

battle_grid = ds_grid_create(gridHoriz, gridVert);

highlighted_move_array=[];
highlighted_attack_array=[];
highlighted_target_array=[];
highlighted_enemy_target_array=[];

_target_transparency=0.5;

_more_visible=true;


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

reset_highlights_move = function(){
	highlighted_move_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._move_highlight=false;
		}
	}
}

reset_highlights_attack = function(){
	highlighted_attack_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._attack_highlight=false;
		}
	}
}

reset_highlights_target = function(){
	highlighted_target_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._target_highlight=false;
		}
	}
}

reset_highlights_enemy = function(){
	highlighted_enemy_target_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._danger_highlight=false;
		}
	}
}

highlighted_move = function(_center_x,_center_y,_range){
	
	reset_highlights_move();
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_move_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._move_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_move_array;
}

highlighted_attack_circle = function(_center_x,_center_y,_range){
	
	reset_highlights_attack();
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_attack_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._attack_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_attack_array;
}

highlighted_attack_line_pierce = function(_center_x,_center_y){
	
	reset_highlights_attack();
	var j=-1;
		while(_center_x+j<GRIDWIDTH){
			j+=1;
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT){
				array_push(highlighted_attack_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._attack_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}
		}
	
	return highlighted_attack_array;
}

highlighted_attack_line = function(_center_x,_center_y){
	
	reset_highlights_attack();
	var j=-1;
		while(battle_grid[_center_x+j][_center_y]._is_empty){
			j+=1;
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT){
				array_push(highlighted_attack_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._attack_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}
		}
	
	return highlighted_attack_array;
}


highlighted_target_circle = function(_center_x,_center_y,_range){
	
	reset_highlights_target();
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._target_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_target_array;
}

highlighted_target_cross = function(_center_x,_center_y,_range){
	
	reset_highlights_target();
	for(var i = -_range; i <= _range; i++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH){
				array_push(highlighted_target_array,battle_grid[_center_x+i][_center_y]);
				battle_grid[_center_x+i][_center_y]._target_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	for(var i = -_range; i <= _range; i++){
			if(_center_y+i>=0 && _center_y+i<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x][_center_y+i]);
				battle_grid[_center_x][_center_y+i]._target_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	return highlighted_target_array;
}

highlighted_target_line_pierce = function(_center_x,_center_y){
	
	reset_highlights_target();
	var j=-1;
		while(_center_x+j<GRIDWIDTH){
			j+=1;
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._target_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}
		}
	
	return highlighted_attack_array;
}

highlighted_enemy_target_circle = function(_center_x,_center_y,_range){
	
	
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_enemy_target_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_enemy_target_array;
}

highlighted_enemy_target_cross = function(_center_x,_center_y,_range){
	
	
	for(var i = -_range; i <= _range; i++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH){
				array_push(highlighted_target_array,battle_grid[_center_x+i][_center_y]);
				battle_grid[_center_x+i][_center_y]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	for(var i = -_range; i <= _range; i++){
			if(_center_y+i>=0 && _center_y+i<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x][_center_y+i]);
				battle_grid[_center_x][_center_y+i]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	return highlighted_enemy_target_array;
}

highlighted_enemy_target_line_pierce = function(_center_x,_center_y){
	
	
	var j=-1;
		while(_center_x+j<GRIDWIDTH){
			j+=1;
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}
		}
	
	return highlighted_enemy_target_array;
}


for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		var coordinates = get_coordinates(i,j);
		var _tile = instance_create_layer(coordinates[0],coordinates[1],"Tiles",obj_tile_class);
		battle_grid[i][j]=_tile;
		battle_grid[i][j]._x_coord=i;
		battle_grid[i][j]._y_coord=j;
		battle_grid[i][j]._is_empty=true;
		battle_grid[i][j].set_coords(i,j);
		battle_grid[i][j]._move_highlight = false;
		battle_grid[i][j]._target_highlight = false;
		battle_grid[i][j]._attack_highlight = false;
		battle_grid[i][j]._danger_highlight = false;
		
	}
}