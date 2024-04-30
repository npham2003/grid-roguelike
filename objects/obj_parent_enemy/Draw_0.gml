
if(stall_turns>0){
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, c_blue, image_alpha);
	image_speed=0;
}else{
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_speed=1;
}
//var pc;
//pc = (self.hp / self.hpMax) * 100;
////obj_battleEffect.health_bar(x,y,pc);
//draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_red, c_red, 0, true, false);
draw_set_color(c_white);

draw_text_ext_transformed(x+30, y, string(enemy_turn_order), 100, 100, 0.5, 0.5, 0);

if(freeze_graphic!=pointer_null){
	freeze_graphic.x=x;
	freeze_graphic.y=y;
}

var _pips = make_tp(x-30, y+healthbar_offset, 7, hpMax+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_white);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
	draw_primitive_end();
}

var _pips = make_tp(x-30, y+healthbar_offset, 7, hp+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_red);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 4));
	draw_primitive_end();
}


for (var i = array_length(_pips)-1; i >= array_length(_pips)-obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._danger_number &&i>=0; --i){
	draw_primitive_begin(pr_trianglestrip);
		
	draw_set_color(c_black);
	draw_set_alpha(hp_opacity);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 4));
	
	draw_primitive_end();
}

draw_set_alpha(1);

draw_set_alpha(1);