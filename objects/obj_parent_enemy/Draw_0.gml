
draw_sprite_ext(self.sprite_index, self.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
var pc;
pc = (self.hp / self.hpMax) * 100;
//obj_battleEffect.health_bar(x,y,pc);
draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_red, c_red, 0, true, false)