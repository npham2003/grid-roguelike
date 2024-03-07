// draw the custom cursor, animated at 2fps
if alarm[0] >= 30 {
	var xx=global.grid_size*(window_mouse_get_x() div global.grid_size);
	var yy=global.grid_size*(window_mouse_get_y() div global.grid_size);
	draw_sprite(spr_cursor, 1, xx, yy);
}

else {
	var xx=global.grid_size*(window_mouse_get_x() div global.grid_size);
	var yy=global.grid_size*(window_mouse_get_y() div global.grid_size);
	draw_sprite(spr_cursor, 2, xx, yy);
}