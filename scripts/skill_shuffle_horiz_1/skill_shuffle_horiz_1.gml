function skill_shuffle_horiz_1(unit) {
	if (unit.skill_complete) {
		return;
	}
	obj_gridCreator.reset_highlights_target();
	obj_gridCreator.reset_highlights_support();
	unit.action = unit.actions[unit.skill_used];
	var _damage = unit.action.damage;
	
	unit.range = 1;
	skill_range = [];
	for (var i = 0; i < 5; ++i) {//remove hard coding later
		array_push(skill_range, obj_gridCreator.battle_grid[5][i]);
	}
	
	unit.is_attacking = false;
	audio_play_sound(sfx_teleport_windup, 0, false, 0.5);
	

	obj_cursor.movable_tile = skill_range;
	obj_cursor.reset_cursor(skill_coords[0]._x_coord, 3);
	
	if (keyboard_check_pressed(ord("A")) && skill_coords[0] > 0) {
		if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]-1][skill_coords[1]])){
			audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
			skill_coords[0] -= 1;
		}
	}
	if (keyboard_check_pressed(ord("D")) && skill_coords[0] < obj_gridCreator.gridHoriz -1) { // a bunch of this is hardcoded atm
		if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]+1][skill_coords[1]])){
			audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
			skill_coords[0] += 1;
		}
	}

	skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
	
	for (var i = 0; i < array_length(skill_range); i++) {
		skill_range[i]._target_highlight=true;
	}
	//show_debug_message(string(unit.skill_progress));
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {

	}
					
					
					
	else if(keyboard_check_pressed(vk_tab)){
		unit.is_attacking = false;
		unit.skill_back = true;
		unit.skill_range = obj_gridCreator.reset_highlights_target();
		unit.skill_range = obj_gridCreator.reset_highlights_support();

	}
}