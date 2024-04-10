draw_sprite(self.sprite_index, self.image_index, x, y);

var pc;
pc = (self.turns_remaining / self.turns_max) * 100;
//obj_battleEffect.health_bar(x,y,pc);
draw_healthbar(x-10, y+healthbar_offset-1, x+10, y+healthbar_offset+1, pc, c_white, c_yellow, c_yellow, 0, true, false)