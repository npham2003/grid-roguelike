sprite_index = sprites.idle;

show_debug_message("{0}: [{1},{2}]", name, grid_pos[0], grid_pos[1]);

// set entity on the grid
obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile = id;

action = pointer_null;
target = noone;
attack_ready = false;

is_moving = false;
sprite_moving_speed = 5;
transparency=1;
is_dead = false;
shield = 0;

began_push = false;

// this variable is compared to a unit's ally boolean to see if it get shit
hitting_who = false;

// used for freeze status
freeze_graphic=pointer_null;
stall_turns=0;

teleporting = 0;

//healthbar_y = y-40;

// finds a target. not super relevant for board obstacles.
function find_target() {
	var available_targets = obj_battleControl.player_units;
	target = available_targets[irandom(array_length(available_targets) - 1)];
	show_debug_message("{0}'s target: {1}", name, target.name);
}

//function aim() {
//	action = actions[0];
//	var target_pos = target.grid_pos;
//	attack_ready = false;
	
//	show_debug_message("{0}: {1}", name, action.name);
	
//	for (var i = 0; i < array_length(action.range); i++) {
//		var est_pos = [target_pos[0] - action.range[i][0], target_pos[1] - action.range[i][1]];
		
//		if (est_pos[0] < 0 || est_pos[0] >= GRIDWIDTH) {
//			continue;
//		}
//		if (est_pos[1] < 0 || est_pos[1] >= GRIDHEIGHT) {
//			continue;
//		}
		
//		if (est_pos[0] == grid_pos[0] && est_pos[1] == grid_pos[1]) {
//			// No need to move
//			set_danger_highlights();
//			attack_ready = true;
//			show_debug_message("{0} is ready to attack", name);
//			break;
//		}
		
//		// todo: check availability
//		if (est_pos[0] > 4 && est_pos[0] < 10 && est_pos[1] >= 0 && est_pos[1] < 5 && 
//		obj_gridCreator.battle_grid[est_pos[0]][est_pos[1]]._is_empty) {
			
//			move(est_pos[0], est_pos[1]);
//			break;
//		}
//	}
	
	
//}

// calculates util of all possible positions
function calculate_util(test_x, test_y) {
	util=0;
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = test_x+action.range[i][0];
		var attack_y = test_y+action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		
		if(!obj_gridCreator.battle_grid[attack_x][attack_y]._is_empty){
			//show_debug_message("something is on tile "+string(attack_x)+", "+string(attack_y));
			if(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile==target){
				util+=1;
			}
			if(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.ally){
				util+=2;
			}else{
				util-=3;
			}
		}
		
		if(attack_x<5){
			util+=1;	
		}
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
	}
	if(obj_gridCreator.battle_grid[test_x][test_y]._danger_number>0){
		util-=2;
	}
	return util;
	
}

function teleport(new_x, new_y, set_grid = true) {
	remove_danger_highlights();
	
	if (set_grid) {
		obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	}
	
	grid_pos[0] = new_x;
	grid_pos[1] = new_y;
	
	if (set_grid) {
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	}
	
	
	teleporting = 1;
	var coord = obj_gridCreator.get_coordinates(new_x, new_y);
	x=coord[0];
	y=coord[1];
	set_danger_highlights();
}


// aims attack. does not move and only sets up danger highlights
function aim(){
	
		action = actions[0];
		
		attack_ready = false;
		show_debug_message("{0}: {1}", name, action.name);
		
		//show_debug_message(string(potential_positions));
		
		
		set_danger_highlights();
		attack_ready = true;
		show_debug_message("{0} is ready to attack", name);
	
	
	
}

// moves obstacle. not really used.
function move(new_x, new_y) {
	// Move to est_pos
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	
	grid_pos[0] = new_x;
	grid_pos[1] = new_y;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
	obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=self;
	is_moving = true;
	obj_battleControl.in_animation = true;
	//var coord = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);
	//x = coord[0];
	//y = coord[1];
}

// marks targetted tiles with the danger highlight
function set_danger_highlights() {
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_highlight = true;
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number += 1;
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
	}
	
}

// prints out danger numbers for targetted tiles
function danger_debug() {
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		show_debug_message("Before: ({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
	
	}
}

// removes danger highlight from targetted tiles. used for when needing to re-aim or when despawning
function remove_danger_highlights() {
	danger_debug();
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number-=1;
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		if(obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number<=0){
			obj_gridCreator.battle_grid[attack_x][attack_y]._danger_highlight = false;
		}
	}
}

// begins the attack and changes who it hits. ally is true if hitting player units, false for enemy
function attack(ally) {
	show_debug_message("{0} is attacking", name);
	display_target_highlights();
	remove_danger_highlights()
	sprite_index = sprites.attack;
	image_index = 0;
	obj_battleControl.in_animation = true;
	audio_play_sound(sounds.attack, 0, false);
	hitting_who = ally;
}


// displays targetted tiles with target highlights. used when hovered over or when starting attack
function display_target_highlights(){
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_cursor = true;
		
	}
}

// removes target highlight from targetted tiles
function remove_target_highlights(){
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_cursor = false;
		
	}
}

// actually does damage. ignores other obstacles and units with a mismatched ally boolean
function do_damage(){
	
	obj_gridCreator.reset_highlights_target();
	
	if(action.damage_type=="push"){
		for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		
		
						if (!obj_gridCreator.battle_grid[attack_x][attack_y]._is_empty) {
							if(attack_y>0){
								if(obj_gridCreator.battle_grid[attack_x][attack_y]==obj_gridCreator.battle_grid9[attack_x][attack_y-1]&&!obj_gridCreator.battle_gridobj_gridCreator.battle_grid[attack_x][attack_y-1]._is_empty){
									obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.push_up(1);
								}
							}
							if(attack_y<4){
								if(obj_gridCreator.battle_grid[attack_x][attack_y]==obj_gridCreator.battle_grid[attack_x][attack_y+1]&&!obj_gridCreator.battle_grid[attack_x][attack_y+1]._is_empty){
									obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.push_down(1);
								}
							}
							if(attack_x>0){
								if(obj_gridCreator.battle_grid[attack_x][attack_y]==obj_gridCreator.battle_grid[attack_x-1][attack_y]&&!obj_gridCreator.battle_grid[attack_x-1][attack_y]._is_empty){
									obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.push_forward(1);
								}
							}
							if(attack_x<9){
								if(obj_gridCreator.battle_grid[attack_x][attack_y]==obj_gridCreator.battle_grid[attack_x+1][attack_y]&&!obj_gridCreator.battle_grid[attack_x+1][attack_y]._is_empty){
									obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.push_back(1);
								}
							}
						}
		}
		
	}else{
	
	
	for (var i = 0; i < array_length(action.range); i++) {
		var attack_x = grid_pos[0] + action.range[i][0];
		var attack_y = grid_pos[1] + action.range[i][1];
		
		if (attack_x < 0 || attack_x >= GRIDWIDTH) {
			continue;
		}
		if (attack_y < 0 || attack_y >= GRIDHEIGHT) {
			continue;
		}
		
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
		if(!obj_gridCreator.battle_grid[attack_x][attack_y]._is_empty){
			if(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.ally == hitting_who && !array_contains(obj_battleControl.board_obstacles,obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile)){
				show_debug_message("("+string(attack_x)+","+string(attack_y)+")")
				show_debug_message(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile==pointer_null);
				obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.damage(strength);
				if (action.damage_type=="cold") {
					// does damage to affected tiles
					obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.stall_turns+=1;
					obj_battleEffect.show_damage(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile, 1, c_blue);
					obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.freeze_graphic = obj_battleEffect.hit_animation(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile, 6);
				}
			}
			

		}
		
	}
	}
	
	show_debug_message("{0} has {1} turns left", name, turns_remaining);
	remove_target_highlights();
}

// empty but needed to not cause errors
function damage(damage_value){
	
	
}

// despawns the obstacle and removes it from the grid
function despawn(){
	is_dead=true;
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	remove_danger_highlights();
	freeze_graphic.sprite_index=spr_freeze_out;
	freeze_graphic.image_speed=1;
}

// pushes right
function push_back(squares){
	if(squares==0){
		began_push=false;
		return;
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,0);
	}
	if(grid_pos[0]==GRIDWIDTH-1){
		obj_battleEffect.show_damage(self,1, c_red);
		hp-=1;
		display_target_highlights();
		began_push=false;
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._is_empty){
		if(!began_push){
			remove_danger_highlights();
			began_push=true;
			
		}
		
		move(grid_pos[0]+1,grid_pos[1]);
		push_back(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]+1][grid_pos[1]]._entity_on_tile.hp-=1;
		
	}
}


// pushes left
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
		display_target_highlights();
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._is_empty){
		if(!began_push){
			remove_danger_highlights();
			began_push=true;
			obj_battleEffect.push_animation(self,2);
		}
		move(grid_pos[0]-1,grid_pos[1]);
		push_back(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]-1][grid_pos[1]]._entity_on_tile.hp-=1;
		
	}
}

// pushes up
function push_up(squares){
	if(squares==0){
		began_push=false;
		return;
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,1);
	}
	if(grid_pos[0]==0 || grid_pos[1]==0){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		display_target_highlights();
		began_push=false;
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._is_empty){
		if(!began_push){
			remove_danger_highlights();
			began_push=true;
			
			obj_battleEffect.push_animation(self,1);
		}
		move(grid_pos[0],grid_pos[1]-1);
		push_up(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]-1]._entity_on_tile.hp-=1;
		
	}
}

// pushes down
function push_down(squares){
	if(squares==0){
		began_push=false;
		return;
		
	}
	if(!began_push){
		obj_battleEffect.push_animation(self,3);
	}
	if(grid_pos[0]==0 || grid_pos[1]==GRIDHEIGHT-1){
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		display_target_highlights();
		return;
	}
	if(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._is_empty){
		if(!began_push){
			remove_danger_highlights();
			began_push=true;
			obj_battleEffect.push_animation(self,3);
		}
		move(grid_pos[0],grid_pos[1]+1);
		push_down(squares-1);
	}else{
		obj_battleEffect.show_damage(self,1,c_red);
		hp-=1;
		obj_battleEffect.show_damage(obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile,1,c_red);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]+1]._entity_on_tile.hp-=1;
		
	}
}