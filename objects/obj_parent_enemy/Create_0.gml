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

//healthbar_y = y-40;

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
			show_debug_message("something is on tile "+string(attack_x)+", "+string(attack_y));
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

function aim(){
	
		action = actions[0];
		var target_pos = target.grid_pos;
		attack_ready = false;
		show_debug_message("{0}: {1}", name, action.name);
		max_util=-999;
		potential_positions = [];
		for(i=5;i<10;i++){
			for(j=0;j<5;j++){
				if(obj_gridCreator.battle_grid[i][j]._is_empty){
					util=calculate_util(i,j);
					if(util>=max_util){
						if(util>max_util){
							potential_positions=[];
						}
						max_util=util;
				
						array_push(potential_positions,[i,j]);
					}
				}else if(obj_gridCreator.battle_grid[i][j]._entity_on_tile==self){
					util=calculate_util(i,j);
					if(util>=max_util){
						if(util>max_util){
							potential_positions=[];
						}
						max_util=util;
				
						array_push(potential_positions,[i,j]);
					}
				}
			}
		}
		show_debug_message(string(potential_positions));
		show_debug_message("{0} has max util {1}", name, max_util);
		position = irandom(array_length(potential_positions)-1);
		move(potential_positions[position][0],potential_positions[position][1]);
		
		
		show_debug_message("{0} is ready to attack", name);
	
	
	
}

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
		obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number+=1;
		//show_debug_message("({0}, {1}): {2}", attack_x,attack_y,obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number);
		
	}
	
}

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

function attack() {
	show_debug_message("{0} is attacking", name);
	display_target_highlights();
	sprite_index = sprites.attack;
	image_index = 0;
	obj_battleControl.in_animation = true;
	audio_play_sound(sounds.attack, 0, false);
}

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

function do_damage(){
	obj_gridCreator.reset_highlights_target();
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
			show_debug_message("("+string(attack_x)+","+string(attack_y)+")")
			show_debug_message(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile==pointer_null);
			obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile.hp-=1;
			obj_battleEffect.show_damage(obj_gridCreator.battle_grid[attack_x][attack_y]._entity_on_tile, 1);

		}
		
	}
	remove_target_highlights();
	
}

function despawn(){
	is_dead=true;
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	remove_danger_highlights();
}