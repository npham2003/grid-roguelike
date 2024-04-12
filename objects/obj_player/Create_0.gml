moveable_grids = [];
move_range = 2; // temp val, change during initialization
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
upgrades =[0,2,1,1];
shield = 0;
attack_bonus = 0;
skill_progress = 0;
skill_option = 0;
began_push=false;
teleporting = 0;

var return_coords;

show_debug_message("{0}: [{1}, {2}]", name, grid_pos[0], grid_pos[1]);

// todo: set entity on the grid

has_moved = false;
has_attacked = false;

function show_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	prev_grid = [grid_pos[0], grid_pos[1]];
	show_debug_message(grid_pos[0]);
	show_debug_message(grid_pos[1]);
	moveable_grids = obj_gridCreator.highlighted_move(grid_pos[0], grid_pos[1], move_range);
	obj_cursor.movable_tiles=moveable_grids;
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function preview_moveable_grids() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	obj_gridCreator.highlighted_move_cursor(grid_pos[0], grid_pos[1], move_range);	
	//moveable_grids = obj_gridCreator.highlighted_attack_line(0, grid_pos[1]);

}

function show_moveable_grids_prev() {
	//moveable_grids = obj_gridCreator.get_moveable_grids(grid_pos, move_range);
	
	moveable_grids = obj_gridCreator.highlighted_move(prev_grid[0], prev_grid[1], move_range);
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
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
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
		obj_battleEffect.shield_damage(self, 1);
	}else{
		hp-=damage_value;
		obj_battleEffect.show_damage(self, damage_value);
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
		obj_battleEffect.show_damage(self,1);
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
		obj_battleEffect.show_damage(self,1);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile,1);
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
		obj_battleEffect.show_damage(self,1);
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
		obj_battleEffect.show_damage(self,1);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile,1);
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
		obj_battleEffect.show_damage(self,1);
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
		obj_battleEffect.show_damage(self,1);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile,1);
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
		obj_battleEffect.show_damage(self,1);
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
		obj_battleEffect.show_damage(self,1);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile,1);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile.hp-=1;
		
	}
}