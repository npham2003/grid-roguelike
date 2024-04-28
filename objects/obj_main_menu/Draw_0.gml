/// @description Insert description here
// You can write your code in this editor

draw_set_font(fnt_archivo);


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

draw_set_font(fnt_chiaro);