
if(stall_turns>0){
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, c_blue, image_alpha);
	image_speed=0;
}else{
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_speed=1;
}
var pc;
pc = (self.hp / self.hpMax) * 100;
//obj_battleEffect.health_bar(x,y,pc);
draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_red, c_red, 0, true, false);
if(freeze_graphic!=pointer_null){
	freeze_graphic.x=x;
	freeze_graphic.y=y;
}