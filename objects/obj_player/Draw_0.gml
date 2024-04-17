/// @description Insert description here
// You can write your code in this editor
if(stall_turns>0){
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_blue,image_alpha);
	image_speed=0;
}else if(has_attacked || has_moved){
	//var oldFog = gpu_get_fog();
	//gpu_set_fog(true, c_black, 0, 0);
	//gpu_set_blendmode(bm_add); 
	//draw_set_alpha(0.5);
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_dkgray,image_alpha);
	image_speed=1;
}else{
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
	image_speed=1;
}

if(has_attacked || has_moved){
	//gpu_set_fog(oldFog[0], oldFog[1], oldFog[2], oldFog[3]);
}