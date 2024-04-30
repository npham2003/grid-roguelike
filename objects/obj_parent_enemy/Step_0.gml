var target_grid_pos = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);

if (is_moving) {
	
	if (x != target_grid_pos[0]) {
		if (x < target_grid_pos[0]) {
			x += min(sprite_moving_speed, target_grid_pos[0] - x);
		}
		else {
			x -= min(sprite_moving_speed, x - target_grid_pos[0]);
		}
	}
	else if (y != target_grid_pos[1]) {
		if (y < target_grid_pos[1]) {
			y += min(sprite_moving_speed, target_grid_pos[1] - y);
		}
		else {
			y -= min(sprite_moving_speed, y - target_grid_pos[1]);
		}
	}
	if(x==target_grid_pos[0] && y==target_grid_pos[1]) {
		if(delay==30){
			attack_ready = true;
			set_danger_highlights();
			display_target_highlights();
		}
		delay-=1;
		if(delay<=0){
			is_moving = false;
			remove_target_highlights();
			battlecontrol.in_animation = false;
		}
	}
	
}
 
if(is_dead){
	
	if(image_alpha==0){
		instance_destroy();
		
	}
	// fade out speed
	image_alpha-=0.01;
	show_debug_message(string(image_alpha));
	
}

// changes speed based on if the enemy is being pushed or not
if(began_push){
	sprite_moving_speed=25;
}else{
	sprite_moving_speed=5;
}

if (teleporting == 1) {
	
	
	image_alpha -= 0.2;
	image_yscale = lerp(image_yscale, 5, 0.2);
	
	image_xscale = lerp(image_xscale, 0, 0.2);
	
	if(image_alpha <= 0){
		x = target_grid_pos[0];
		y = target_grid_pos[1];
		teleporting=2;
	}
}
else if (teleporting == 2) {
	image_alpha += 0.2;
	image_xscale = lerp(image_xscale, 1, 0.2);
	image_yscale = lerp(image_yscale, 1, 0.2);
	
	if(image_alpha >= 1){
		image_yscale = 1;
		image_xscale = 1;
		teleporting = 0;
	}
}

if(hp_opacity_increase){
	hp_opacity+=0.01;	
}else{
	hp_opacity-=0.01;
}

if(hp_opacity>0.6){
	hp_opacity_increase=false;	
}
if(hp_opacity<0.1){
	hp_opacity_increase=true;	
}

depth=layer_get_depth("Units")-grid_pos[1];