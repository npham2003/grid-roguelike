if (obj_battleControl.state == BattleState.PlayerUpgrade) {
	
	// background and border
	draw_set_color(c_black);
	draw_set_alpha(alpha*0.7);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_sprite_ext(spr_shop_menu_border, image_index, actual_x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);
	
	for (i = 0; i<4; i++){
		for (j=0; j<2; j++){
			
			//if the option is selected
			if (selector_pos[0] == i && selector_pos[1] == j){
				
				//draw option, fill with white
				fill_alpha = lerp(fill_alpha, 1, 0.2);
				draw_set_alpha(fill_alpha);
				draw_rectangle_colour(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, global._primary, global._primary, global._primary, global._primary, false);
				
				//draw text box and text
				draw_set_alpha(1);
				draw_rectangle_colour(actual_x+(200*i)+100, y+(175*j)-42, actual_x+(200*i)+300, y+(175*j)+22, c_black, c_black, c_black, c_black, false);
				draw_set_color(global._primary);
				draw_text_ext_transformed(actual_x+(200*i)+115, y+(175*j)-50, descriptor_text[i+j*4], 40, 360, 0.5, 0.5, image_angle);
				draw_sprite_ext(spr_shop_menu_border, image_index, actual_x+(200*i)+100, y+(175*j)-50, 0.2, 0.2, image_angle, global._primary, alpha);
			}
		
			//draw empty rectangle
			draw_set_color(c_white);
			draw_rectangle(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, true);
			draw_set_color(c_black);
			
			if(obj_battleControl.gold<cost[i+j*4]){
				selectable[i+j*4]=false;
				
			}else{
				selectable[i+j*4]=true;
			}
			if(array_length(obj_battleControl.player_units)==4){
				selectable[7]=false;	
			}
		
		}
	}
		
	for (i = 0; i<4; i++){
	// if option is selected that requires you to select a character
		if ( menu_level == 1 && i < array_length(obj_battleControl.player_units)){
			//draw_sprite_ext(spr_diamond_base, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._primary, 1);
			//draw_sprite_ext(spr_diamond_outline, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._characterPrimary, 1);
			
			var pc;
			pc = (obj_battleControl.player_units[i].hp / obj_battleControl.player_units[i].hpMax) * 100;
			if(pc!=100 && obj_battleControl.gold>=cost[0]){
				selectable[i]=true;
			}else{
				selectable[i]=false;
			}
			
			#region draw diamond
			draw_set_color(c_black);
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim+10));
			draw_primitive_end();
			
			//if(character_select_pos!=i){
				draw_set_color(global._characterPrimary);
			//}else{
			//	draw_set_color(c_white);
			//}
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim+5));
			draw_primitive_end();
			if(character_select_pos==i){
				draw_set_color(global._primary);
				
			}else if(selectable[i]){
				draw_set_color(c_white);
			}
			else{
				draw_set_color(c_gray);	
			}
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim));
			draw_primitive_end();
			#endregion

			#region draw character
			gpu_set_blendenable(false);
			gpu_set_colorwriteenable(false, false, false, true);
			draw_set_alpha(0);
			//draw_rectangle(imgX-150, imgY-150, imgX+160, imgY+100, false); //invisible rectangle

			//mask
			draw_set_alpha(1);
			//draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, portraitScale, portraitScale, 0, c_white, 1);
			draw_set_color(c_white);
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim));
			draw_primitive_end();

			gpu_set_blendenable(true);
			gpu_set_colorwriteenable(true, true, true, true);

			//draw over mask
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
			//gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_src_alpha, portraitAlpha, bm_inv_src_alpha);

			//gpu_set_blendmode_ext_sepalpha(portraitAlpha, portraitAlpha, portraitAlpha, portraitAlpha);
			gpu_set_alphatestenable(true);
			//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
			if(!selectable[i]){
				draw_sprite_ext(obj_battleControl.player_units[i].portrait, 0, actual_x+(character_spacing*i)+200, y+500, -0.55, 0.55, 0, c_gray, 1);
			}else{
				draw_sprite_ext(obj_battleControl.player_units[i].portrait, 0, actual_x+(character_spacing*i)+200, y+500, -0.55, 0.55, 0, c_white, 1);
			}
			gpu_set_alphatestenable(false);
			draw_set_alpha(1);
			gpu_set_blendmode(bm_normal);
			
			
			pc = (obj_battleControl.player_units[i].hp / obj_battleControl.player_units[i].hpMax) * 100;
			draw_healthbar(actual_x+(character_spacing*i)+150, y+400, actual_x+(character_spacing*i)+250, y+410, pc, global._primary, global._characterSecondary, global._characterSecondary, 0, true, true)


		}
	}
	//reset draw
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	
}