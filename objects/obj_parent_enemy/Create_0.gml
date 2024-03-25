sprite_index = sprites.idle;

show_debug_message("{0}: [{1},{2}]", name, grid_pos[0], grid_pos[1]);

// set entity on the grid
obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile = id;

target = noone;
attack_ready = false;

function find_target() {
	var available_targets = obj_battleControl.player_units;
	target = available_targets[irandom(array_length(available_targets) - 1)];
	show_debug_message("{0}'s target: {1}", name, target.name);
}

function aim() {
	var action = actions[0];
	var target_pos = target.grid_pos;
	attack_ready = false;
	
	show_debug_message("{0}: {1}", name, action.name);
	
	for (var i = 0; i < array_length(action.range); i++) {
		var est_pos = [target_pos[0] - action.range[i][0], target_pos[1] - action.range[i][1]];
		
		if (est_pos[0] == grid_pos[0] && est_pos[1] == grid_pos[1]) {
			// No need to move
			attack_ready = true;
			break;
		}
		
		// todo: check availability
		if (est_pos[0] > 4 && est_pos[0] < 10 && est_pos[1] > 0 && est_pos[1] < 5 && 
		obj_gridCreator.battle_grid[est_pos[0]][est_pos[1]]._is_empty) {
			// Move to est_pos
			obj_gridCreator.move_entity(grid_pos[0], grid_pos[1], est_pos[0], est_pos[1]);
			grid_pos[0] = est_pos[0];
			grid_pos[1] = est_pos[1];
			attack_ready = true;
			var coord = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);
			x = coord[0];
			y = coord[1];
			show_debug_message("{0} move to {1}", name, est_pos);
			break;
		}
	}
	
	if (attack_ready) {
		show_debug_message("{0} is ready to attack", name);
	}
}

function attack() {
	show_debug_message("{0} is attacking", name);
}