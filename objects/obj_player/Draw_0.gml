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


var _pips = make_tp(x-30, y-60, 7, hpMax+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_white);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
	draw_primitive_end();
}

var _pips = make_tp(x-30, y-60, 7, hp+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_red);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 4));
	draw_primitive_end();
}

for (var i = array_length(_pips)-1; i >= array_length(_pips)-obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._danger_number &&i>0; --i){
	draw_primitive_begin(pr_trianglestrip);
		
	draw_set_color(c_black);
	draw_set_alpha(hp_opacity);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 4));
	
	draw_primitive_end();
}

draw_set_alpha(1);
