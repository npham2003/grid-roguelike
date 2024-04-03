draw_sprite(self.sprite_index, self.image_index, x, y);

var pc;
pc = (self.hp / self.hpMax) * 100;
draw_healthbar(x-10, y-10, x+10, y-10, pc, c_white, c_red, c_red, 0, true, true)