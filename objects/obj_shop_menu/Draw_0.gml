if (obj_battleControl.state == BattleState.PlayerUpgrade) {
	
	// background and border
	draw_set_color(c_black);
	draw_set_alpha(alpha*0.7);
	draw_rectangle(0, 0, room_width, room_height, false);
	
	if(menu_level!=3){
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
				draw_set_alpha(1);
				draw_set_color(c_white);
				draw_rectangle(actual_x+(200*i)+125, y+(175*j)+37.5, actual_x+(200*i)+275, y+(175*j)+187.5, true);
				draw_text_ext_transformed(actual_x+(200*i)+150, y+(175*j)+37.5, cost[i+j*4], 40, 360, 0.5, 0.5, image_angle);
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
	}
	if(menu_level==1 || menu_level==2){
		for (i = 0; i<4; i++){
		// if option is selected that requires you to select a character
			if (i < array_length(obj_battleControl.player_units)){
				switch(menu_level){
					#region healing
					case 1: 
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
						#endregion
						gpu_set_alphatestenable(false);
						draw_set_alpha(1);
						gpu_set_blendmode(bm_normal);
			
			
						pc = (obj_battleControl.player_units[i].hp / obj_battleControl.player_units[i].hpMax) * 100;
						draw_healthbar(actual_x+(character_spacing*i)+150, y+400, actual_x+(character_spacing*i)+250, y+410, pc, global._primary, global._characterSecondary, global._characterSecondary, 0, true, true)
						break;
						
					#endregion
					#region skill change
					case 2:
					
						//draw_sprite_ext(spr_diamond_base, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._primary, 1);
						//draw_sprite_ext(spr_diamond_outline, 0, actual_x+(200*i)+200, y+500, _sb,_sb, 0, global._characterPrimary, 1);
			
						if(selector_pos[0]==2){ // checks to see if we are resetting a skill
							selectable[i]=false;
							for(j=0;j<array_length(obj_battleControl.player_units[i].upgrades);j++){ // checks to see if there are any skills to reset
								if(obj_battleControl.player_units[i].upgrades[j]!=0){
								
									selectable[i]=true;
									break;
								}
							}
						}
						else if(array_contains(obj_battleControl.player_units[i].upgrades, 0)){  //checks if there are any skills to upgrade
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
						#endregion
						gpu_set_alphatestenable(false);
						draw_set_alpha(1);
						gpu_set_blendmode(bm_normal);
			
			
					
						break;
					#endregion
				}
			}
		}
	}
	
	if(menu_level == 3){
		for(i=1;i<array_length(obj_battleControl.player_units[character_select_pos].actions);i++){
			var action = obj_battleControl.player_units[character_select_pos].actions[i];
			var prev_skill = obj_battleControl.player_units[character_select_pos].upgrades[i];
			draw_sprite_ext(spr_shop_menu_border, image_index, skill_x_start, skill_y_start+(i-1)*250, 0.5, 0.5, image_angle, image_blend, alpha);
			draw_set_color(c_white);
			draw_set_alpha(1);
			draw_text_ext_transformed(skill_x_start+15, skill_y_start+((i-1)*250)+5, action.name[prev_skill], 40, 600, 0.8, 0.8, image_angle);
			draw_text_ext_transformed(skill_x_start+15, skill_y_start+((i-1)*250)+40, action.description[prev_skill], 40, 600, 0.8, 0.8, image_angle);
			var _pips = make_tp(skill_x_start+400, skill_y_start+((i-1)*250)+30, 7*obj_menu.expandAnim, action.cost[prev_skill], true);

			draw_set_color(global._characterSecondary);
			for (var j = 0; j < array_length(_pips); j++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*obj_menu.expandAnim));
				draw_primitive_end();
			}
			draw_set_color(c_white)
			
			draw_sprite_ext(spr_shop_menu_border, image_index, skill_x_start+600, skill_y_start+(i-1)*250, 0.5, 0.5, image_angle, image_blend, alpha);
			draw_text_ext_transformed(skill_x_start+615, skill_y_start+((i-1)*250)+50, action.description[new_skill_upgrade], 40, 600, 0.8, 0.8, image_angle);
			draw_text_ext_transformed(skill_x_start+615, skill_y_start+((i-1)*250)+10, action.name[new_skill_upgrade], 40, 600, 0.8, 0.8, image_angle);
			
			var _pips = make_tp(skill_x_start+1015, skill_y_start+((i-1)*250)+30, 7*obj_menu.expandAnim, action.cost[new_skill_upgrade], true);

			draw_set_color(global._characterSecondary);
			for (var j = 0; j < array_length(_pips); j++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*obj_menu.expandAnim));
				draw_primitive_end();
			}
			draw_set_color(c_white)
		}
		
	}
	//reset draw
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	
}