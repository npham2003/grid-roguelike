moveable_grids = [];
//playerSpeed = 2; // temp val, change during initialization
skill_used = 0; // just to determine whether we do j k l, maybe it's not optimized
skill_range = [];
skill_range_aux = [];
skill_coords = [];
skill_complete = false;
skill_init = false;
new_coords = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);
play_sound = false; // temp var, will change later
is_attacking = false;
prev_grid = [0,0];
skill_back = false;
upgrades =[0,0,0,0];
shield = 0;
attack_bonus = 0;
attack_bonus_temp = 0;
skill_progress = 0;
skill_option = 0;
began_push=false;
teleporting = 0;
stall_turns = 0;
freeze_graphic=pointer_null;
attack_buff_recent=false;
move_buff_recent=false;
move_bonus_temp=0;
bombs_placed=0;
thaw_damage=0;
thaw_checked = false;

hp_opacity=0;
hp_opacity_increase=true;

var return_coords;

show_debug_message("{0}: [{1}, {2}]", name, grid_pos[0], grid_pos[1]);

// todo: set entity on the grid

has_moved = false;
has_attacked = false;

function show_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, playerSpeed);
	prev_grid = [grid_pos[0], grid_pos[1]];
	//show_debug_message(grid_pos[0]);
	//show_debug_message(grid_pos[1]);
	moveable_grids = obj_gridCreator.highlighted_move(grid_pos[0], grid_pos[1], playerSpeed+move_bonus_temp);
	obj_cursor.movable_tiles=moveable_grids;
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function preview_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, playerSpeed);
	obj_gridCreator.highlighted_move_cursor(grid_pos[0], grid_pos[1], playerSpeed+move_bonus_temp);	
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function show_moveable_grids_prev() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, playerSpeed);
	
	moveable_grids = obj_gridCreator.highlighted_move(prev_grid[0], prev_grid[1], playerSpeed+move_bonus_temp);
	obj_cursor.movable_tiles=moveable_grids;
	obj_cursor.reset_cursor(grid_pos[0],grid_pos[1]);
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function move_up() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] - 1]) {
		grid_pos[1] -= 1;
		break;
		}
	}
}

function move_down() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[1] < GRIDHEIGHT - 1
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1] + 1]) {
			grid_pos[1] += 1;
			break;
		}
	}
}

function move_left() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] > 0 
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] - 1][grid_pos[1]]) {
			grid_pos[0] -= 1;
			break;
		}
	}
}

function move_right() {
	for (var i = 0; i < array_length(moveable_grids); i++) {
		if (grid_pos[0] < (GRIDWIDTH / 2 - 1)
			&& moveable_grids[i] == obj_gridCreator.battle_grid[grid_pos[0] + 1][grid_pos[1]]) {
			grid_pos[0] += 1;
			break;
		}
	}
}

function confirm_move() {
	obj_gridCreator.remove_entity(prev_grid[0],prev_grid[1]);
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
	obj_gridCreator.reset_highlights_move();
	
	
}

function back_move(){
	show_debug_message("Move from ({0},{1}) back to ({2},{3})", grid_pos[0], grid_pos[1], prev_grid[0], prev_grid[1]);
	//if(!obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty){
	//	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	//}
	//obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	grid_pos[0]=prev_grid[0];
	grid_pos[1]=prev_grid[1];
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
	return_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
	x=return_coords[0];
	y=return_coords[1];
	obj_gridCreator.reset_highlights_move();
}


function back_aim(){
	show_debug_message("Move from ({0},{1}) back to ({2},{3})", grid_pos[0], grid_pos[1], prev_grid[0], prev_grid[1]);
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	obj_gridCreator.battle_grid[prev_grid[0]][prev_grid[1]]._entity_on_tile=self;
	return_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
	x=return_coords[0];
	y=return_coords[1];
	show_moveable_grids_prev();
	
}

function damage(damage_value){
	if(shield>0){
		shield-=1;
		obj_battleEffect.show_damage(self, 1, c_yellow);
	}else{
		hp-=damage_value;
		obj_battleEffect.show_damage(self, damage_value,c_red);
	}
}

function push_back(squares){
	if(squares==0){
		began_push=false;
		return;
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,0);
	}
	if(grid_pos[0]==4){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		
		began_push=false;
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._is_empty){
		if(!began_push){
			
			began_push=true;
			
		}
		
		obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
		obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._is_empty = false;
		obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile = self;
		grid_pos[0]+=1;
		push_back(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile.hp-=1;
		
	}
}

function push_forward(squares){
	if(squares==0){
		began_push=false;
		return;
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,2);
	}
	if(grid_pos[0]==0){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		began_push=false;
		
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._is_empty){
		if(!began_push){
			
			began_push=true;
			obj_battleEffect.push_animation(self,2);
		}
		obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
		obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._is_empty = false;
		obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile = self;
		grid_pos[0]-=1;
		push_back(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile.hp-=1;
		
	}
}

function push_up(squares){
	if(squares==0){
		began_push=false;
		return;
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,1);
	}
	if( grid_pos[1]==0){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		
		began_push=false;
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._is_empty){
		if(!began_push){
			
			began_push=true;
			
			obj_battleEffect.push_animation(self,1);
		}
		obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._is_empty = false;
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile = self;
		grid_pos[1]-=1;
		push_up(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile.hp-=1;
		
	}
}

function push_down(squares){
	if(squares==0){
		began_push=false;
		return;
		
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,3);
	}
	if(grid_pos[1]==GRIDHEIGHT-1){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._is_empty){
		if(!began_push){
			
			began_push=true;
			obj_battleEffect.push_animation(self,3);
		}
		obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._is_empty = false;
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile = self;
		grid_pos[1]+=1;
		push_down(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile.hp-=1;
		
	}
}

make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}

//draw tp
make_tp = function(_x, _y, _spacing, _len, is_rows) {
	var _res = [];
	var _bars =  _len/5;
	var _rem =  _len%5;
	var _y_offset = 0;
	
	var _lines = _bars + _rem;
	
		for (var i = 0; i < _len; ++i) {
			if (_bars > 0 && is_rows) {
				if (i != 0 && i%5 == 0) {
					for(var j = 0; j<array_length(_res);j++){
						_res[j][1]-=_spacing/3;
						_y_offset+=_spacing*0.45;
					}
				}
			}
			if (is_rows) _res[i] = [_x + (i%5)*_spacing, _y - _spacing*((i%5)%2) + _y_offset];
			else _res[i] = [_x + (i)*_spacing, _y - _spacing*(i%2) + _y_offset];
		}

	return _res;
	
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}
