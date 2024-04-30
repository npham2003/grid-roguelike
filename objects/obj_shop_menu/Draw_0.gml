if (obj_battleControl.state == BattleState.PlayerUpgrade) {
	show_debug_message(selectable);
	// background and border
	if(menu_level<=1){ //if this is not the skill select screen
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(0, 0, room_width, room_height, false);
		draw_sprite_ext(spr_shop_menu_border, image_index, actual_x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);
		for (i = 0; i<3; i++){
			for (j=0; j<2; j++){
				
				var text_box_offset=250*j;
				//if the option is selected
				if(i==3&&j==1){ //this is so we dont draw the 8th option
					break;
				}
				draw_set_alpha(1);
				
				draw_set_color(c_black);
				if (selector_pos[0] == i && selector_pos[1] == j){ //if this option is highlighted
				
					//draw option and fill with primary
					fill_alpha = lerp(fill_alpha, 1, 0.2);
					draw_set_alpha(fill_alpha);
					draw_rectangle_colour(actual_x+(200*i)+225, y+(175*j)+37.5, actual_x+(200*i)+375, y+(175*j)+187.5, global._primary, global._primary, global._primary, global._primary, false);
				
					//draw text box and text
					draw_set_alpha(1);
					draw_rectangle_colour(actual_x+(200*i)+200, y+(175*j)-42+text_box_offset, actual_x+(200*i)+400, y+(175*j)+22+text_box_offset, c_black, c_black, c_black, c_black, false);
					draw_set_color(global._primary);
					draw_text_ext_transformed(actual_x+(200*i)+215, y+(175*j)-50+text_box_offset, descriptor_text[i+j*3], 40, 360, 0.5, 0.5, image_angle);
					draw_sprite_ext(spr_shop_menu_border, image_index, actual_x+(200*i)+200, y+(175*j)-50+text_box_offset, 0.2, 0.2, image_angle, global._primary, alpha);
				}
		
				
				if(j==1){
					#region draw character
					gpu_set_blendenable(false);
					gpu_set_colorwriteenable(false, false, false, true);
					draw_set_alpha(0);
					draw_rectangle(actual_x+(190*i)+200, y+(175*j)+20, actual_x+(200*i)+400, y+(175*j)+240, false); //invisible rectangle

					//mask
					draw_set_alpha(1);
					//draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, portraitScale, portraitScale, 0, c_white, 1);
					draw_set_color(c_white);
					draw_primitive_begin(pr_trianglestrip);
					draw_rectangle(actual_x+(200*i)+225, y+(175*j)+37.5, actual_x+(200*i)+375, y+(175*j)+187.5, false);
					draw_primitive_end();

					gpu_set_blendenable(true);
					gpu_set_colorwriteenable(true, true, true, true);

					//draw over mask
					gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
					gpu_set_alphatestenable(true);
					draw_sprite_ext(obj_battleControl.player_units[i].portrait, 0, actual_x+(200*i)+300, y+(175*j)+113, -0.4, 0.4, 0, c_white, 1);
					gpu_set_alphatestenable(false);
					draw_set_alpha(1);
					gpu_set_blendmode(bm_normal);
					#endregion
				}
				
				//draw cost of option in top left corner
				draw_set_alpha(1);
				draw_set_color(c_white);
				draw_text_ext_transformed(actual_x+(200*i)+250, y+(175*j)+37.5, cost[i+j*3], 40, 360, 0.5, 0.5, image_angle);
				draw_set_color(c_black);
				
				if(obj_battleControl.gold<cost[i+j*3]){
					selectable[i+j*3]=false;
				}else{
					selectable[i+j*3]=true;
				}
				
				
				draw_set_color(c_white);
				draw_rectangle(actual_x+(200*i)+225, y+(175*j)+37.5, actual_x+(200*i)+375, y+(175*j)+187.5, true);
			}
		}
	}
	if(menu_level==1){
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
						
						if(character_select_pos==i){
							draw_set_color(c_white)	
							draw_primitive_begin(pr_trianglestrip);
							draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim+15));
							draw_primitive_end();
						}
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
						if(selectable[i]){
							draw_set_color(c_white);
						}
						else{
							draw_set_color(c_gray);	
						}
						draw_primitive_begin(pr_trianglestrip);
						draw_vertices(make_diamond(actual_x+(character_spacing*i)+200, y+500,playerDim));
						draw_primitive_end();
						#endregion
						
						//draw_rectangle(actual_x+(character_spacing*i)+50, y+350, actual_x+(character_spacing*i)+350, y+650, true);

						#region draw character
						gpu_set_blendenable(false);
						gpu_set_colorwriteenable(false, false, false, true);
						draw_set_alpha(0);
						draw_rectangle(actual_x+(character_spacing*i)+50, y+350, actual_x+(character_spacing*i)+350, y+650, false); //invisible rectangle

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
					
				}
			}
		}
	}
	if(menu_level == 2){ //select skill to upgrade
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(0, 0, room_width, room_height, false);
		
		
		draw_set_color(c_white);
		var action = obj_battleControl.player_units[character_select_pos].actions[skill_select_pos];
		var prev_skill = obj_battleControl.player_units[character_select_pos].upgrades[skill_select_pos];

		
		for(i=0;i<3;i++){
			var action = obj_battleControl.player_units[character_select_pos].actions[i+1];
			var prev_skill = obj_battleControl.player_units[character_select_pos].upgrades[i+1];
			
			
			selectable[i]=true;	
			
			if(i==skill_select_pos){
				show_debug_message("draw arrow");
				if(selectable[i]){
					draw_sprite_ext(spr_right_arrow, image_index, skill_x_start-75, skill_y_start+(i)*250+75, 1, 1, image_angle, image_blend, 1);
				}else{
					draw_sprite_ext(spr_right_arrow_transparent, image_index, skill_x_start-75, skill_y_start+(i)*250+75, 1, 1, image_angle, image_blend, 0.5);
				}
			}
			
			
			draw_set_color(c_white);
			
			
			draw_sprite_ext(spr_shop_menu_border, image_index, skill_x_start, skill_y_start+(i)*250, 0.5, 0.5, image_angle, image_blend, alpha);
			draw_text_ext_transformed(skill_x_start+15, skill_y_start+((i)*250)+40, action.description[prev_skill], 40, 600, 0.8, 0.8, image_angle);
			draw_text_ext_transformed(skill_x_start+15, skill_y_start+((i)*250)+5, action.name[prev_skill], 40, 600, 0.8, 0.8, image_angle);
			
			//tp costs
			var _pips = make_tp(skill_x_start+415, skill_y_start+((i)*250)+30, 7*obj_menu.expandAnim, action.cost[prev_skill], true);

			draw_set_color(global._tpBar);
			for (var j = 0; j < array_length(_pips); j++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*obj_menu.expandAnim));
				draw_primitive_end();
			}
			draw_set_color(c_white)
		}
		
		
		
	}
	if(menu_level == 3){ //upgrade your skill
			#region setup
			var _border = border;
				var _outline1 = [
				[skill_x_start+upgrade_offset, skill_y_start+90-(optionRadius+_border)],
				[skill_x_start+upgrade_offset-(optionRadius+_border), skill_y_start+90],
				[skill_x_start+upgrade_offset, skill_y_start+90+(optionRadius+_border)],
				[skill_x_start+upgrade_offset+500, skill_y_start+90+(optionRadius+_border)],
				[skill_x_start+upgrade_offset+500+(optionRadius+_border), skill_y_start+90],
				[skill_x_start+upgrade_offset+500, skill_y_start+90-(optionRadius+_border)],
			]
			var _outline2 = [
				
				[skill_x_start+upgrade_offset, skill_y_start+90-(optionRadius+_border*2)],
				[skill_x_start+upgrade_offset-(optionRadius+_border*2), skill_y_start+90],
				[skill_x_start+upgrade_offset, skill_y_start+90+(optionRadius+_border*2)],
				[skill_x_start+upgrade_offset+500, skill_y_start+90+(optionRadius+_border*2)],
				[skill_x_start+upgrade_offset+500+(optionRadius+_border*2), skill_y_start+90],
				[skill_x_start+upgrade_offset+500, skill_y_start+90-(optionRadius+_border*2)],
			]
			_border = 0;
			var _button = [
				[skill_x_start+upgrade_offset+upgrade_offset-(optionRadius+_border), skill_y_start+90],
				[skill_x_start+upgrade_offset+upgrade_offset, skill_y_start+90-(optionRadius+_border)],
				
				[skill_x_start+upgrade_offset+upgrade_offset, skill_y_start+90+(optionRadius+_border)],
				[skill_x_start+upgrade_offset+upgrade_offset+500, skill_y_start+90-(optionRadius+_border)],
				[skill_x_start+upgrade_offset+upgrade_offset+500, skill_y_start+90+(optionRadius+_border)],
				
				[skill_x_start+upgrade_offset+upgrade_offset+500+(optionRadius+_border), skill_y_start+90]
			]
			#endregion
			
		
		//draw_set_color(c_black);
		//draw_set_alpha(1);
		//draw_rectangle(0, 0, room_width, room_height, false);
		
		
		//draw_set_color(c_white);
		var action = obj_battleControl.player_units[character_select_pos].actions[skill_select_pos];
		var prev_skill = obj_battleControl.player_units[character_select_pos].upgrades[skill_select_pos];
		
		//LEFT BOX
		//draw_sprite_ext(spr_shop_menu_border, image_index, skill_x_start, skill_y_start+(1)*250, 0.5, 0.5, image_angle, image_blend, alpha);
		
		draw_set_color(c_black);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(_outline2);
		draw_primitive_end();
	
		draw_set_color(global._characterPrimary);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(_outline1);
		draw_primitive_end();
	
		draw_set_color(global._primary);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(_button);
		draw_primitive_end();
		
		draw_set_alpha(1);
		draw_text_ext_transformed(skill_x_start+15, skill_y_start+((1)*250)+5, action.name[prev_skill], 40, 600, 0.8, 0.8, image_angle);
		draw_text_ext_transformed(skill_x_start+15, skill_y_start+((1)*250)+40, action.description[prev_skill], 40, 600, 0.8, 0.8, image_angle);
		var _pips = make_tp(skill_x_start+400, skill_y_start+((1)*250)+30, 7*obj_menu.expandAnim, action.cost[prev_skill], true);
	
		draw_set_color(global._tpBar);
		for (var j = 0; j < array_length(_pips); j++){
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*obj_menu.expandAnim));
			draw_primitive_end();
		}
		
		for(i=0;i<3;i++){
			
			// cant select skill you already have
			if(prev_skill==i){
				selectable[i]=false;	
			}else{
				selectable[i]=true;	
			}
			

			if(i==new_skill_upgrade){
				show_debug_message("draw arrow");
				if(selectable[i]){
					draw_sprite_ext(spr_right_arrow, image_index, skill_x_start+525, skill_y_start+(i)*250+75, 1, 1, image_angle, image_blend, 1);
				}else{
					draw_sprite_ext(spr_right_arrow_transparent, image_index, skill_x_start+525, skill_y_start+(i)*250+75, 1, 1, image_angle, image_blend, 0.5);
				}
			}
			
			if(selectable[i]){
				draw_set_color(c_white);
			}else{
				draw_set_color(c_gray);
			}
			
			
			//RIGHT BOXES
			//draw_sprite_ext(spr_shop_menu_border, image_index, skill_x_start+600, skill_y_start+(i)*250, 0.5, 0.5, image_angle, image_blend, alpha);
			draw_text_ext_transformed(skill_x_start+615, skill_y_start+((i)*250)+50, action.description[i], 40, 600, 0.8, 0.8, image_angle);
			draw_text_ext_transformed(skill_x_start+615, skill_y_start+((i)*250)+10, action.name[i], 40, 600, 0.8, 0.8, image_angle);
			
			var _pips = make_tp(skill_x_start+1015, skill_y_start+((i)*250)+30, 7*obj_menu.expandAnim, action.cost[i], true);

			draw_set_color(global._tpBar);
			for (var j = 0; j < array_length(_pips); j++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*obj_menu.expandAnim));
				draw_primitive_end();
			}
			draw_set_color(c_white)
		}
		
	}
	
	#region gold
	if(menu_level==2&&skill_select_pos==0){
		// translucent if selecting top left skill
		draw_set_alpha(0.5);
	}else{
		draw_set_alpha(1);
	}	
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(global._primary);
	draw_vertices(make_diamond(87, 53, 30));
	draw_primitive_end();
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(global._aspect_bars);
	draw_vertices(make_diamond(87, 53, 25));
	draw_primitive_end();

	draw_set_color(global._primary);
	draw_text_transformed(75, 20, "G    "+ string(obj_battleControl.gold), 0.8, 0.8, 0);
	#endregion
	//reset draw
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	
}