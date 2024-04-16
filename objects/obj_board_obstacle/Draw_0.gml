

if(stall_turns>0){
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, c_blue, image_alpha);
	image_speed=0;
}else{
	draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_speed=1;
}
var pc;
pc = (self.turns_remaining / self.turns_max) * 100;
//obj_battleEffect.health_bar(x,y,pc);
draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_yellow, c_yellow, 0, true, false)