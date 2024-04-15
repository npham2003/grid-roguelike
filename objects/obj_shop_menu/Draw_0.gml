
if (obj_battleControl.state == BattleState.PlayerUpgrade) {
	
	// background and border
	draw_set_color(c_black);
	draw_set_alpha(alpha/2);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_sprite_ext(spr_shop_menu_border, image_index, actual_x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);
	
	for (i = 0; i<4; i++){
		for (j=0; j<2; j++){
			
			//if the option is selected
			if (selector_pos[0] == i && selector_pos[1] == j){
				
				//draw option, fill with white
				draw_rectangle_colour(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, c_white, c_white, c_white, c_white, false);
				draw_sprite_ext(spr_shop_menu_border, image_index, actual_x+(200*i)-50, y+(175*j)-50, 0.2, 0.2, image_angle, image_blend, alpha);
				draw_set_alpha(1);
				
				//draw text box and text
				draw_rectangle_colour(actual_x+(200*i)-40, y+(175*j)-42, actual_x+(200*i)+140, y+(175*j)+22, c_black, c_black, c_black, c_black, false);
				draw_set_color(c_white);
				draw_text_ext_transformed(actual_x+(200*i)-40, y+(175*j)-50, descriptor_text[j][i], 40, 360, 0.5, 0.5, image_angle);
				draw_set_color(c_black);
				draw_set_alpha(alpha/2);
				
			}else{
				
				//draw empty rectangle
				draw_rectangle_colour(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, c_white, c_white, c_white, c_white, true);
			}
		}
		
		// if option is selected that requires you to select a character
		if ( menu_level == 1 && i < array_length(obj_battleControl.player_units)){
			var _sb = 10;
			draw_sprite_ext(spr_diamond_base, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._primary, 1);
			draw_sprite_ext(spr_diamond_outline, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._characterPrimary, 1);
			#region draw character

			gpu_set_blendenable(false);
			gpu_set_colorwriteenable(false, false, false, true);
			draw_set_alpha(0);
			//draw_rectangle(actual_x+(200*i)+50, y+350, imgX+160, imgY+100, false); //invisible rectangle

			//mask
			draw_set_alpha(1);
			draw_sprite_ext(spr_diamond_base, 0, actual_x+(200*i)+200, y+500, _sb, _sb, 0, c_white, 1);
			gpu_set_blendenable(true);
			gpu_set_colorwriteenable(true, true, true, true);

			//draw over mask
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
			gpu_set_alphatestenable(true);
			//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
			draw_sprite_ext(obj_battleControl.player_units[i].portrait, 0, actual_x+(200*i)+200, y+500, -0.25, 0.25, 0, c_white, 1);
			gpu_set_alphatestenable(false);
			gpu_set_blendmode(bm_normal);

			#endregion
			draw_set_alpha(alpha/2);
		}
	}
	
	//reset draw
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	
}