/// @description Insert description here
// You can write your code in this editor

draw_set_font(fnt_archivo);

draw_sprite_ext(saul_goodman,image_number, room_width/2, room_height/2, funny_scale, funny_scale, image_angle, c_white, funny_opacity)
draw_sprite(spr_logo,image_number,actual_logo_x,room_height/2);


if(sub_menu==0){

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	#region party tp
	var _pips = make_menu(actual_options_x, room_height/2-((array_length(menu_options[0])-1)*(line_spacing+20)/2), line_spacing+20, array_length(menu_options[0]), false);
	for (var i = 0; i < array_length(_pips); ++i){
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing+20));
		}
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing+10));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
	
		draw_set_color(diamond_fill);
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing+5));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
		//draw_set_color(global._tpBar);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
		draw_primitive_end();
		draw_set_color(c_black);
	
		draw_text(_pips[i][0],_pips[i][1],menu_options[0][i]);
		
	}
	draw_set_alpha(1);
	#endregion
	draw_set_color(c_white);
	//draw_sprite_ext(spr_right_arrow, image_index, actual_options_x+arrow_spacing, room_height/2-((array_length(menu_options[0])-1)*line_spacing/2)+line_spacing*selector_pos-20, 1, 1, image_angle, image_blend, 1);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}
if(sub_menu==1){
	var _pips = make_menu_alternate(credits_x, room_height/2-((array_length(menu_options[1])-1)*(line_spacing)/2), line_spacing, array_length(menu_options[1]), false, actual_credits_x, credits_x);
	for (var i = 0; i < array_length(_pips); ++i){
		draw_primitive_begin(pr_trianglestrip);
		if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing));
		}
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-10));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
	
		draw_set_color(diamond_fill);
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-15));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
		//draw_set_color(global._tpBar);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
		draw_primitive_end();
		draw_set_color(c_white);
		
		draw_set_valign(fa_middle);
		if(i%2==0){
			draw_set_halign(fa_right);
		}else{
			draw_set_halign(fa_left);
		}
		//draw_text(_pips[i][0]+line_spacing*1.2*power(-1,i+1),_pips[i][1],menu_options[1][i]);
		draw_set_color(c_black);
		text_outline(_pips[i][0]+line_spacing*1.2*power(-1,i+1),_pips[i][1], menu_options[1][i], 2, c_white, 8, 100000, 1000000);
		
		#region draw character
		gpu_set_blendenable(false);

		gpu_set_colorwriteenable(false, false, false, true);
		draw_set_alpha(0);
		draw_rectangle(_pips[i][0]-150, _pips[i][1]-300, _pips[i][0]+160, _pips[i][1]+300, false); //invisible rectangle

		//mask
		draw_set_alpha(1);
		//draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, portraitScale, portraitScale, 0, c_white, 1);
		draw_set_color(c_white);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1],line_spacing-15));
		draw_primitive_end();

		gpu_set_blendenable(true);
		gpu_set_colorwriteenable(true, true, true, true);

		//draw over mask
		gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
		//gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_src_alpha, portraitAlpha, bm_inv_src_alpha);

		//gpu_set_blendmode_ext_sepalpha(portraitAlpha, portraitAlpha, portraitAlpha, portraitAlpha);
		gpu_set_alphatestenable(true);
		//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
		draw_sprite_ext(profile_pictures[i], 0, _pips[i][0], _pips[i][1]-20, 0.45, 0.45, 0, c_white, 1);
		gpu_set_alphatestenable(false);
		draw_set_alpha(1);
		gpu_set_blendmode(bm_normal);




		#endregion
		
	}
	
}

if(sub_menu==2){
	var _pips = make_menu_alternate(character_select, room_height/2-((array_length(global.players)-1)*(line_spacing-15)/2), line_spacing-15, array_length(global.players), false, character_select, actual_character_select);
	for (var i = 0; i < array_length(_pips); ++i){
		draw_primitive_begin(pr_trianglestrip);
		
		if(selector_pos==i && selected[i]){
			draw_set_color(c_aqua);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-15));
		}else if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-15));
		}
		else if(selected[i]){
			draw_set_color(c_blue);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-15));
		}
		draw_primitive_end();
		
		
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-25));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
	
		draw_set_color(diamond_fill);
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing-30));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
		//draw_set_color(global._tpBar);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
		draw_primitive_end();
		draw_set_color(c_white);
		
		draw_set_valign(fa_middle);
		if(i%2==0){
			draw_set_halign(fa_right);
		}else{
			draw_set_halign(fa_left);
		}
		//draw_text(_pips[i][0]+line_spacing*1.2*power(-1,i+1),_pips[i][1],menu_options[1][i]);
		draw_set_color(c_black);
		//text_outline(_pips[i][0]+line_spacing*1.2*power(-1,i+1),_pips[i][1], menu_options[1][i], 2, c_white, 8, 100000, 1000000);
		
		#region draw character
		gpu_set_blendenable(false);

		gpu_set_colorwriteenable(false, false, false, true);
		draw_set_alpha(0);
		draw_rectangle(_pips[i][0]-150, _pips[i][1]-300, _pips[i][0]+160, _pips[i][1]+300, false); //invisible rectangle

		//mask
		draw_set_alpha(1);
		//draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, portraitScale, portraitScale, 0, c_white, 1);
		draw_set_color(c_white);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1],line_spacing-30));
		draw_primitive_end();

		gpu_set_blendenable(true);
		gpu_set_colorwriteenable(true, true, true, true);

		//draw over mask
		gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
		//gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_src_alpha, portraitAlpha, bm_inv_src_alpha);

		//gpu_set_blendmode_ext_sepalpha(portraitAlpha, portraitAlpha, portraitAlpha, portraitAlpha);
		gpu_set_alphatestenable(true);
		//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
		draw_sprite_ext(global.players[i].portrait, 0, _pips[i][0], _pips[i][1]-20, 0.45, 0.45, 0, c_white, 1);
		gpu_set_alphatestenable(false);
		draw_set_alpha(1);
		gpu_set_blendmode(bm_normal);




		#endregion
		
		for(j=0;j<3;j++){
			
			var action = global.players[selector_pos].actions[j+1];
			draw_set_color(c_white);
			
			
			draw_sprite_ext(spr_shop_menu_border, image_index, actual_skill_x+00, skill_y_start+(j)*220, 0.5, 0.5, image_angle, image_blend, 1);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
			
			draw_set_color(c_black)
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 40, 600, 0.8, 0.8, image_angle);
			
			
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+10, action.name[0], 40, 600, 0.8, 0.8, image_angle);
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 40, 600, 0.8, 0.8, image_angle);
			draw_set_font(fnt_chiaro_small);
			text_outline(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 1, c_white, 4, 40, 450);
			draw_set_font(fnt_chiaro);
			text_outline(actual_skill_x+15, skill_y_start+((j)*220), action.name[0], 1, c_white, 4, 40, 600);
			
			
			
			
			var _tp_pips = make_tp(actual_skill_x+415, skill_y_start+((j)*220)+30, 7, action.cost[0], true);

			draw_set_color(global._tpBar);
			for (var k = 0; k < array_length(_tp_pips); k++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_tp_pips[k][0],_tp_pips[k][1], 5));
				draw_primitive_end();
			}
			draw_set_color(c_white)
		}
		
	}
	
}
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_set_font(fnt_chiaro);
draw_set_color(c_black);
text_outline(580,700, "WASD - Move Cursor    Enter - Select    Tab - Back", 1, c_white, 8, 100000, 1000000);
draw_set_color(c_white);