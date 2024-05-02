

if(stall_turns>0){
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, c_blue, image_alpha);
	image_speed=0;
}else{
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_speed=1;
}
//var pc;
//pc = (self.turns_remaining / self.turns_max) * 100;
////obj_battleEffect.health_bar(x,y,pc);
//draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_yellow, c_yellow, 0, true, false);

var _pips = make_tp(x-30, y+healthbar_offset, 7, turns_max+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_white);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
	draw_primitive_end();
}

var _pips = make_tp(x-30, y+healthbar_offset, 7, turns_remaining+1, false);
for (var i = 1; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_blue);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 4));
	draw_primitive_end();
}



draw_set_alpha(1);