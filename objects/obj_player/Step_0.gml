/// @description Insert description here
// You can write your code in this editor
if(hp<=0){
	sprite_index=sprites.dead;
}else if(is_attacking){
	sprite_index=sprites.gun;
}else{
	sprite_index=sprites.idle;
}
new_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
if(teleporting==0){
	
	x = lerp(x, new_coords[0], 0.4);
	y = lerp(y, new_coords[1], 0.4);
}else if (teleporting==1){
	//obj_battleEffect.hit_animation_coordinates(prev_grid[0], prev_grid[1], 6);
	teleporting=2;
}else if (teleporting==2){
	image_alpha-=0.2;
	image_yscale=lerp(image_yscale,5,0.2);
	
	image_xscale=lerp(image_xscale,0,0.2);
	
	if(image_alpha<=0){
		teleporting=3;
	}
	
}else if (teleporting==3){
	x = new_coords[0];
	y = new_coords[1];
	teleporting=4;
	//obj_battleEffect.hit_animation(self, 7);
}else if (teleporting==4){
	image_alpha+=0.2;
	image_yscale=lerp(image_yscale,1,0.2);
	
	image_xscale=lerp(image_xscale,1,0.2);
	if(image_alpha>=1){
		teleporting=0;
		image_yscale=1;
		image_xscale=1;
	}
	prev_grid[0]=grid_pos[0];
	prev_grid[1]=grid_pos[1];
}


depth=layer_get_depth("Units")-grid_pos[1];
//show_debug_message("Current: ({0},{1}) Prev: ({2},{3})", grid_pos[0], grid_pos[1], prev_grid[0], prev_grid[1]);