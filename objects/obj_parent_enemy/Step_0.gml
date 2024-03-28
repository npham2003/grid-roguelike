
if (is_moving) {
	
	var target_pos = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);
	
	if (x != target_pos[0]) {
		if (x < target_pos[0]) {
			x += min(sprite_moving_speed, target_pos[0] - x);
		}
		else {
			x -= min(sprite_moving_speed, x - target_pos[0]);
		}
	}
	else if (y != target_pos[1]) {
		if (y < target_pos[1]) {
			y += min(sprite_moving_speed, target_pos[1] - y);
		}
		else {
			y -= min(sprite_moving_speed, y - target_pos[1]);
		}
	}
	else {
		set_danger_highlights();
		is_moving = false;
		obj_battleControl.in_animation = false;
	}
	
}
if(is_dead){
	image_alpha-=0.05;
}