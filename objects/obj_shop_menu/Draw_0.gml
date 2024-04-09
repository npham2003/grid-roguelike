
if(obj_battleControl.state==BattleState.PlayerUpgrade){
	draw_set_color(c_black);
	draw_set_alpha(alpha/2);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_sprite_ext(spr_shop_menu_border, image_index, actual_x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);
	for(i = 0;i<4;i++){
		for(j=0;j<2;j++){
			draw_rectangle_colour(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, c_white, c_white, c_white, c_white, true);
		}
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
}