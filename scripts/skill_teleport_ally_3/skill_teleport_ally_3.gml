function skill_teleport_ally_3(unit){
	if(unit.skill_complete){
		return;
	}
	obj_gridCreator.reset_highlights_target();
	obj_gridCreator.reset_highlights_support();
	unit.action = unit.actions[unit.skill_used];
	var _damage = unit.action.damage;
	if (unit.skill_progress==0) { // i gotta find a better way to initialize the skill coord that doesn't use this stupid bool
		unit.range = 3;
		skill_coords[0] = unit.grid_pos[0];
		skill_coords[1] = unit.grid_pos[1];
		unit.skill_progress = 1;
		unit.is_attacking = true;
		skill_range_aux = obj_gridCreator.highlighted_target_square(skill_coords[0], skill_coords[1],0);
		audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
	}
	if(unit.skill_progress==2){
		skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], 1);
	}
	if(unit.skill_progress==1){
		skill_range = obj_gridCreator.highlighted_support_circle(unit.grid_pos[0], unit.grid_pos[1], unit.range);
	}
				
	obj_cursor.movable_tiles=skill_range;
	obj_cursor.reset_cursor(skill_coords[0],skill_coords[1]);
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
	if (keyboard_check_pressed(ord("S")) && skill_coords[1] < obj_gridCreator.gridVert -1) { // a bunch of this is hardcoded atm
		if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]+1])){
			audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
			skill_coords[1] += 1;
		}
	}
	if (keyboard_check_pressed(ord("W")) && skill_coords[1] > 0) { // a bunch of this is hardcoded atm
		if(array_contains(skill_range,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]-1])){
			audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
			skill_coords[1] -= 1;
		}
	}
	skill_range_aux[unit.skill_progress-1]=obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]];
	for (var i = 0; i < array_length(skill_range_aux); i++) {
		skill_range_aux[i]._target_highlight=true;
	}
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("K"))) {
		if(unit.skill_progress==1){
			if(!obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
				if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._entity_on_tile.ally){
					audio_play_sound(sfx_teleport_select, 0, false, 1);
					unit.skill_progress=2;
					array_push(skill_range_aux,obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]);
					skill_coords[0]=unit.grid_pos[0];
					skill_coords[1]=unit.grid_pos[1];
				}else{
					audio_play_sound(sfx_no_tp, 0, false);
				}
			}else{
				audio_play_sound(sfx_no_tp, 0, false);
			}
		}
		else if(unit.skill_progress==2){
			if(obj_gridCreator.battle_grid[skill_coords[0]][skill_coords[1]]._is_empty){
				if(skill_coords[0]<5){
					audio_play_sound(sfx_teleport, 0, false, 1);
					skill_range_aux[0]._entity_on_tile.grid_pos = [skill_range_aux[1]._x_coord,skill_range_aux[1]._y_coord];
								
					skill_range_aux[1]._entity_on_tile = skill_range_aux[0]._entity_on_tile;
					skill_range_aux[0]._entity_on_tile = pointer_null;
					skill_range_aux[0]._is_empty = true;
					skill_range_aux[1]._is_empty = false;
					skill_range_aux[1]._entity_on_tile.teleporting = 1;
					unit.is_attacking = false;
					skill_range = obj_gridCreator.reset_highlights_support();
					skill_range_aux = obj_gridCreator.reset_highlights_target();
					unit.skill_complete = true;
					unit.skill_init = false;
					unit.skill_progress=0;
					show_debug_message(unit.action.name);
				}else{
					audio_play_sound(sfx_no_tp, 0, false);
				}
			}else{
				audio_play_sound(sfx_no_tp, 0, false);
			}
		}
	}else if(keyboard_check_pressed(vk_tab)){
		if(unit.skill_progress==2){
			unit.skill_progress=1;
			skill_range_aux[1]._target_highlight=false;
			array_delete(skill_range_aux,1,1);
			obj_cursor.reset_cursor(skill_range_aux[0]._x_coord,skill_range_aux[0]._y_coord);
			skill_coords[0]=skill_range_aux[0]._x_coord;
			skill_coords[1]=skill_range_aux[0]._y_coord;
		}else{
			unit.is_attacking = false;
			unit.skill_back = true;
			unit.skill_range = obj_gridCreator.reset_highlights_target();
			unit.skill_range = obj_gridCreator.reset_highlights_support();
			unit.skill_progress=0;
		}
		
	}
}