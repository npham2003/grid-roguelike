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

function find_target() {
	var available_targets = obj_battleControl.player_units;
	target = available_targets[irandom(array_length(available_targets) - 1)];
	show_debug_message("{0}'s target: {1}", name, target.name);
}

function aim() {
	action = actions[0];
	var target_pos = target.grid_pos;
	attack_ready = false;
	
	show_debug_message("{0}: {1}", name, action.name);
	
	for (var i = 0; i < array_length(action.range); i++) {
		var est_pos = [target_pos[0] - action.range[i][0], target_pos[1] - action.range[i][1]];
		
		if (est_pos[0] < 0 || est_pos[0] >= GRIDWIDTH) {
			continue;
		}
		if (est_pos[1] < 0 || est_pos[1] >= GRIDHEIGHT) {
			continue;
		}
		
		if (est_pos[0] == grid_pos[0] && est_pos[1] == grid_pos[1]) {
			// No need to move
			set_danger_highlights();
			attack_ready = true;
			break;
		}
		
		// todo: check availability
		if (est_pos[0] > 4 && est_pos[0] < 10 && est_pos[1] >= 0 && est_pos[1] < 5 && 
		obj_gridCreator.battle_grid[est_pos[0]][est_pos[1]]._is_empty) {
			
			move(est_pos[0], est_pos[1]);
			attack_ready = true;
			break;
		}
	}
	
	if (attack_ready) {
		show_debug_message("{0} is ready to attack", name);
	}
}

function move(new_x, new_y) {
	// Move to est_pos
	obj_gridCreator.move_entity(grid_pos[0], grid_pos[1], new_x, new_y);
	grid_pos[0] = new_x;
	grid_pos[1] = new_y;
	
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
	
	}
}

function remove_danger_highlights() {
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
		
		if(obj_gridCreator.battle_grid[attack_x][attack_y]._danger_number==0){
			obj_gridCreator.battle_grid[attack_x][attack_y]._danger_highlight = false;
		}
	}
}

function attack() {
	show_debug_message("{0} is attacking", name);
}

function despawn(){
	is_dead=true;
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	remove_danger_highlights();
}