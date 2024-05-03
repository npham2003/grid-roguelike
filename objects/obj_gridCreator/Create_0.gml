gridHoriz = GRIDWIDTH;
gridVert = GRIDHEIGHT;

battle_grid = ds_grid_create(gridHoriz, gridVert);
battle_grid_flattened=[];

highlighted_move_array=[];
highlighted_attack_array=[];
highlighted_target_array=[];
highlighted_enemy_target_array=[];
highlighted_support_array=[];

_target_transparency=0.5;

_more_visible=true;
_moving = false;

transition_in = true;


// get co-ordinates for the middle of the tile at (x,y)
// (0,0) is top left
// arr[0] is the x and arr[1] is the y
// make sure your sprites are aligned at the middle of their feet
get_coordinates = function(_x_value, _y_value){
	
	coordinates = [x+CELLWIDTH/2+(_x_value*CELLWIDTH), y+CELLHEIGHT/2+(_y_value*CELLHEIGHT) ];
	return coordinates;
}

remove_entity = function(_x_value, _y_value){
	battle_grid[_x_value][_y_value]._is_empty=true;
	battle_grid[_x_value][_y_value]._entity_on_tile=pointer_null;
	
}

visualize = function(){
	show_debug_message("Grid Viewer");
	for(i=0;i<array_length(battle_grid[0]);i++){
		var row_string="";
		for(j=0; j<array_length(battle_grid);j++){
			if(battle_grid[j][i]._is_empty){
				row_string = string_concat(row_string,"[ ]");
			}else{
				row_string = string_concat(row_string,"[-]");
			}
			if(j==4){
				row_string = string_concat(row_string," | ");
			}
		}
		show_debug_message(row_string);
	}
}

visualize_danger = function(){
	show_debug_message("Grid Viewer");
	for(i=0;i<array_length(battle_grid[0]);i++){
		var row_string="";
		for(j=0; j<array_length(battle_grid);j++){
			
			row_string = string_concat(row_string,"[",string(battle_grid[j][i]._danger_number),"]");
			
			
			
			if(j==4){
				row_string = string_concat(row_string," | ");
			}
		}
		show_debug_message(row_string);
	}
}

visualize_danger_bool = function(){
	show_debug_message("Grid Viewer");
	for(i=0;i<array_length(battle_grid[0]);i++){
		var row_string="";
		for(j=0; j<array_length(battle_grid);j++){
			var highlight="T";
			if(!battle_grid[j][i]._danger_highlight){
				highlight="F";
			}
			row_string = string_concat(row_string,"[",string(highlight),"]");	
			if(j==4){
				row_string = string_concat(row_string," | ");
			}
		}
		show_debug_message(row_string);
	}
}

move_entity = function(_prev_x,_prev_y,_new_x,_new_y){
	var _entity_pointer = battle_grid[_prev_x][_prev_y]._entity_on_tile;
	if(!battle_grid[_prev_x][_prev_y]._is_empty ){
		battle_grid[_prev_x][_prev_y]._entity_on_tile = pointer_null;
		battle_grid[_new_x][_new_y]._entity_on_tile = _entity_pointer;
		
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

reset_highlights_support = function(){
	highlighted_target_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._support_highlight=false;
			
		}
	}
}

reset_highlights_enemy = function(){
	highlighted_enemy_target_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._danger_highlight=false;
			battle_grid[i][j]._danger_number=0;
		}
	}
}


reset_highlights_cursor = function(){
	highlighted_enemy_target_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			battle_grid[i][j]._danger_cursor=false;
			battle_grid[i][j]._move_cursor=false;
		}
	}
}

highlighted_move = function(_center_x,_center_y,_range){
	
	reset_highlights_move();
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT &&_center_x+i<5){
				array_push(highlighted_move_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._move_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_move_array;
}

find_empty_tile_ally = function(_center_x,_center_y,_range){
	
	if(_range<0){
		return pointer_null;
	}
	if(_range==0 && battle_grid[_center_x][_center_y]._is_empty){
		return battle_grid[_center_x][_center_y];
	}
	show_debug_message("Range: "+string(_range));
	_temp = find_empty_tile_ally(_center_x,_center_y,_range-1);
	if(_temp!=pointer_null){
		return _temp;
	}
	
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			//show_debug_message("Checking ("+string(_center_x+i)+", "+string(_center_y+j)+") which is ("+string(battle_grid[_center_x+i][_center_y+j]._x_coord)+", "+string(battle_grid[_center_x+i][_center_y+j]._y_coord)+")");
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT &&_center_x+i<5){
				if(battle_grid[_center_x+i][_center_y+j]._is_empty){
					return battle_grid[_center_x+i][_center_y+j];
				}
				
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return pointer_null;
	
}

find_empty_tile_enemy = function(_center_x,_center_y,_range){
	
	if(_range<0){
		return pointer_null;
	}
	if(_range==0 && battle_grid[_center_x][_center_y]._is_empty){
		return battle_grid[_center_x][_center_y];
	}
	show_debug_message("Range: "+string(_range));
	_temp = find_empty_tile_ally(_center_x,_center_y,_range-1);
	if(_temp!=pointer_null){
		return _temp;
	}
	
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT &&_center_x+i>4){
				if(battle_grid[_center_x+i][_center_y+j]._is_empty){
					return battle_grid[_center_x+i][_center_y+j];
				}
				
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return pointer_null;
	
}

highlighted_support_circle = function(_center_x,_center_y,_range){
	
	highlighted_support_array = [];
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_support_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._support_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_support_array;
}

highlighted_support_circle_player_side = function(_center_x,_center_y,_range){
	
	highlighted_support_array = [];
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<5 && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_support_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._support_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_support_array;
}

highlighted_support_player_side = function() {
	highlighted_support_array = [];
	
	for (var i = 0; i < GRIDWIDTH / 2; i++) {
		for(var j = 0; j < GRIDHEIGHT; j++) {
			battle_grid[i][j]._support_highlight=true;
			array_push(highlighted_support_array, battle_grid[i][j]);
		}
	}
	
	return highlighted_support_array;
}

highlighted_support_enemy_side = function() {
	highlighted_support_array = [];
	
	for (var i = GRIDWIDTH / 2; i < GRIDWIDTH; i++) {
		for(var j = 0; j < GRIDHEIGHT; j++) {
			battle_grid[i][j]._support_highlight=true;
			array_push(highlighted_support_array, battle_grid[i][j]);
		}
	}
	
	return highlighted_support_array;
}

highlighted_support_all = function() {
	highlighted_support_array = [];
	
	for (var i = 0; i < GRIDWIDTH; i++) {
		for(var j = 0; j < GRIDHEIGHT; j++) {
			battle_grid[i][j]._support_highlight=true;
			array_push(highlighted_support_array, battle_grid[i][j]);
		}
	}
	
	return highlighted_support_array;
}

highlighted_support_cross = function(_center_x, _center_y, _range) {
	
	highlighted_support_array = [];
	
	array_push(highlighted_support_array, battle_grid[_center_x][_center_y]);
	battle_grid[_center_x][_center_y]._support_highlight = true;
	
	for(var i = -_range; i <= _range; i++){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < GRIDWIDTH){
			array_push(highlighted_support_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._support_highlight = true;
		}
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_support_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._support_highlight = true;
		}
	}
	
	return highlighted_support_array;
	
}

highlighted_support_cross_player_side = function(_center_x, _center_y, _range) {
	
	highlighted_support_array = [];
	
	array_push(highlighted_support_array, battle_grid[_center_x][_center_y]);
	battle_grid[_center_x][_center_y]._support_highlight = true;
	
	for(var i = -_range; i <= _range; i++){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < 5){
			array_push(highlighted_support_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._support_highlight = true;
		}
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_support_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._support_highlight = true;
		}
	}
	
	return highlighted_support_array;
	
}

highlighted_move_cursor = function(_center_x,_center_y,_range){
	
	
	for(var i = -_range; i <= _range; i++){
		for(var j = -(_range-abs(i)); j <= _range - abs(i); j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_move_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._move_cursor=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_move_array;
}

highlighted_attack_circle = function(_center_x,_center_y,_range){
	
	highlighted_attack_array = [];
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
	
	highlighted_attack_array = [];
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
	
	highlighted_attack_array = [];
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
			if(!battle_grid[_center_x+j][_center_y]._is_empty){
				break;
			}
		}
	
	return highlighted_attack_array;
}

highlighted_attack_line_range = function(_center_x,_center_y,_range){ //editable range for skills
	
	highlighted_attack_array = [];
	var j=-1;
	var i=0;
		while(_center_x+j<GRIDWIDTH  && j<_range){
			j+=1;
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT && j<_range){
				array_push(highlighted_attack_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._attack_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}

		}
	
	return highlighted_attack_array;
}

highlighted_attack_all = function(){
	highlighted_attack_array = [];
	for (var i = 0; i< gridHoriz;i++){
		for (var j = 0; j < gridVert;j++){
			array_push(highlighted_attack_array,battle_grid[i][j]);
			battle_grid[i][j]._attack_highlight=true;
		}
	}
	return highlighted_attack_array;
}
highlighted_attack_cross = function(_center_x, _center_y, _range) {
	
	highlighted_attack_array = [];
	
	array_push(highlighted_attack_array, battle_grid[_center_x][_center_y]);
	battle_grid[_center_x][_center_y]._attack_highlight = true;
	

	
	for(var i = 0; i <= _range; i++){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < GRIDWIDTH){
			array_push(highlighted_attack_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._attack_highlight = true;
			if(!battle_grid[_center_x + i][_center_y]._is_empty){
				break;
			}
		}
		

	}
	
	for(var i = 0; i >=-_range; i--){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < GRIDWIDTH){
			array_push(highlighted_attack_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._attack_highlight = true;
			if(!battle_grid[_center_x + i][_center_y]._is_empty){
				break;
			}
		}
		
	}
	
	for(var i = 0; i <= _range; i++){
		if (i == 0) continue;
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_attack_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._attack_highlight = true;
			if(!battle_grid[_center_x][_center_y + i]._is_empty){
				break;
			}
		}
		
		
	}
	
	for(var i = 0; i >=-_range; i--){
		if (i == 0) continue;
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_attack_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._attack_highlight = true;
			if(!battle_grid[_center_x][_center_y + i]._is_empty){
				break;
			}
		}
		
	}
	return highlighted_attack_array;
	
}

highlighted_attack_cross_basic = function(_center_x, _center_y, _range) {
	
	highlighted_attack_array = [];
	
	array_push(highlighted_attack_array, battle_grid[_center_x][_center_y]);
	battle_grid[_center_x][_center_y]._attack_highlight = true;
	

	
	for(var i = 0; i <= _range; i++){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < GRIDWIDTH){
			array_push(highlighted_attack_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._attack_highlight = true;
			if(!battle_grid[_center_x + i][_center_y]._is_empty){
				if(battle_grid[_center_x+i][_center_y]._entity_on_tile.hp>0){
					break;
				}
			}
		}
		

	}
	
	for(var i = 0; i >=-_range; i--){
		if (i == 0) continue;
		if(_center_x + i >= 0 && _center_x + i < GRIDWIDTH){
			array_push(highlighted_attack_array,battle_grid[_center_x + i][_center_y]);
			battle_grid[_center_x + i][_center_y]._attack_highlight = true;
			if(!battle_grid[_center_x + i][_center_y]._is_empty){
				if(battle_grid[_center_x+i][_center_y]._entity_on_tile.hp>0){
					break;	
				}
			}
		}
		
	}
	
	for(var i = 0; i <= _range; i++){
		if (i == 0) continue;
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_attack_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._attack_highlight = true;
			if(!battle_grid[_center_x][_center_y + i]._is_empty){
				if(battle_grid[_center_x][_center_y+i]._entity_on_tile.hp>0){
					break;
				}
			}
		}
		
		
	}
	
	for(var i = 0; i >=-_range; i--){
		if (i == 0) continue;
		if(_center_y + i >= 0 && _center_y + i < GRIDHEIGHT){
			array_push(highlighted_attack_array,battle_grid[_center_x][_center_y + i]);
			battle_grid[_center_x][_center_y + i]._attack_highlight = true;
			if(!battle_grid[_center_x][_center_y + i]._is_empty){
				if(battle_grid[_center_x][_center_y+i]._entity_on_tile.hp>0){
					break;
				}
			}
		}
		
	}
	return highlighted_attack_array;
	
}

highlighted_target_straight = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_x+j<GRIDWIDTH){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			
			array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
			battle_grid[_center_x+j][_center_y]._target_highlight=true;
			break;
		}
		j+=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_basic = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_x+j<GRIDWIDTH){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			if(battle_grid[_center_x+j][_center_y]._entity_on_tile.hp>0){
				array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._target_highlight=true;
			break;
			}
		}
		j+=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_row = function(_center_y){
	
	highlighted_target_array=[];
	_center_x=0;
	var j=0;
	while(_center_x+j<GRIDWIDTH){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			
			array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
			battle_grid[_center_x+j][_center_y]._target_highlight=true;
		
		}
		j+=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_back = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_x+j>=0){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			
			array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
			battle_grid[_center_x+j][_center_y]._target_highlight=true;
			break;
		}
		j-=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_up = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_y+j>=0){
		
		if(!battle_grid[_center_x][_center_y+j]._is_empty){
			
			array_push(highlighted_target_array,battle_grid[_center_x][_center_y+j]);
			battle_grid[_center_x][_center_y+j]._target_highlight=true;
			break;
		}
		j-=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_down = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_y+j<GRIDHEIGHT){
		
		if(!battle_grid[_center_x][_center_y+j]._is_empty){
			
			array_push(highlighted_target_array,battle_grid[_center_x][_center_y+j]);
			battle_grid[_center_x][_center_y+j]._target_highlight=true;
			break;
		}
		j+=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_back_basic = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_x+j>=0){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			if(battle_grid[_center_x+j][_center_y]._entity_on_tile.hp>0){
				array_push(highlighted_target_array,battle_grid[_center_x+j][_center_y]);
				battle_grid[_center_x+j][_center_y]._target_highlight=true;
			break;
			}
		}
		j-=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_up_basic = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_y+j>=0){
		
		if(!battle_grid[_center_x][_center_y+j]._is_empty){
			if(battle_grid[_center_x][_center_y+j]._entity_on_tile.hp>0){
				array_push(highlighted_target_array,battle_grid[_center_x][_center_y+j]);
				battle_grid[_center_x][_center_y+j]._target_highlight=true;
				break;
			}
		}
		j-=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_straight_down_basic = function(_center_x,_center_y){
	
	highlighted_target_array=[];
	var j=0;
	while(_center_y+j<GRIDHEIGHT){
		
		if(!battle_grid[_center_x][_center_y+j]._is_empty){
			if(battle_grid[_center_x][_center_y+j]._entity_on_tile.hp>0){
				array_push(highlhted_target_array,battle_grid[_center_x][_center_y+j]);
				battle_grid[_center_x][_center_y+j]._target_highlight=true;
				break;
			}
		}
		j+=1;
	}
	
	
	return highlighted_target_array;
}

highlighted_target_circle = function(_center_x,_center_y,_range){
	
	highlighted_target_array=[];
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

highlighted_target_square = function(_center_x,_center_y,_range){
	
	highlighted_target_array=[];
	for(var i = -_range; i <= _range; i++){
		for(var j = -_range; j <= _range; j++){
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
	
	highlighted_target_array=[];
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
	
	highlighted_target_array=[];
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
	
	return highlighted_target_array;
}

highlighted_target_cone = function(_center_x,_center_y,_range){
	
	highlighted_target_array=[];
	for(var i = 1; i <= _range; i++){
		for(var j = -i; j <= i; j++){
			if(_center_x+i>=0 && _center_x+i<GRIDWIDTH && _center_y+j>=0 && _center_y+j<GRIDHEIGHT){
				array_push(highlighted_target_array,battle_grid[_center_x+i][_center_y+j]);
				battle_grid[_center_x+i][_center_y+j]._target_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
		}
	}
	return highlighted_target_array;
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
				array_push(highlighted_enemy_target_array,battle_grid[_center_x+i][_center_y]);
				battle_grid[_center_x+i][_center_y]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	for(var i = -_range; i <= _range; i++){
			if(_center_y+i>=0 && _center_y+i<GRIDHEIGHT){
				array_push(highlighted_enemy_target_array,battle_grid[_center_x][_center_y+i]);
				battle_grid[_center_x][_center_y+i]._danger_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}
	}
	return highlighted_enemy_target_array;
}

highlighted_enemy_target_line_pierce = function(_center_x,_center_y){
	
	
	var j=-1;
		while(_center_x+j<GRIDWIDTH){
			
			if(_center_x+j>=0 && _center_x+j<GRIDWIDTH && _center_y>=0 && _center_y<GRIDHEIGHT){
				array_push(highlighted_attack_array,battle_grid[_center_x-j][_center_y]);
				battle_grid[_center_x-j][_center_y]._attack_highlight=true;
				//show_debug_message(string(_center_x+i)+", "+string(_center_y+j));
			}else{
				break;	
			}
			j+=1;
			if( _center_x+j>=0){
				break;
			}
		}
	
	return highlighted_enemy_target_array;
}


highlighted_enemy_target_straight_back = function(_center_x,_center_y){
	
	highlighted_enemy_target_array=[];
	var j=0;
	while(_center_x+j>0){
		
		if(!battle_grid[_center_x+j][_center_y]._is_empty){
			
			array_push(highlighted_enemy_target_array,battle_grid[_center_x+j][_center_y]);
			break;
		}
		j-=1;
	}
	
	
	return highlighted_enemy_target_array;
}

for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		var coordinates = get_coordinates(i,j);
		var _tile = instance_create_layer(coordinates[0],coordinates[1],"Tiles",obj_tile_class);
		battle_grid[i][j]=_tile;
		_tile.set_coords(i,j);
		array_push(battle_grid_flattened,_tile);
	}
}