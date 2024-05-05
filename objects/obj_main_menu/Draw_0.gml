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
	for (var i = 0; i < array_length(_pips)-1; ++i){
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing+15));
		}
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing+5));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
	
		draw_set_color(diamond_fill);
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], line_spacing));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
		//draw_set_color(global._tpBar);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
		draw_primitive_end();
		draw_set_color(c_black);
	
		draw_text_transformed(_pips[i][0],_pips[i][1],menu_options[0][i],0.7,0.7,0);
		
	}
	draw_set_alpha(1);
	#endregion

	
	if(selector_pos==array_length(_pips)-1){
		draw_set_color(c_white);
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(make_diamond(150, 700, line_spacing+5));
		draw_primitive_end();
	}
	
	draw_set_color(diamond_outline);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(make_diamond(150, 700, line_spacing));
	draw_primitive_end();
	
	draw_set_color(diamond_fill);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(make_diamond(150, 700, line_spacing-5));
	draw_primitive_end();
	
	draw_set_color(c_black);
	draw_text_transformed(150,700,menu_options[0][array_length(_pips)-1],0.7,0.7,0);
	
	draw_set_color(c_white);
	//draw_sprite_ext(spr_right_arrow, image_index, actual_options_x+arrow_spacing, room_height/2-((array_length(menu_options[0])-1)*line_spacing/2)+line_spacing*selector_pos-20, 1, 1, image_angle, image_blend, 1);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}
if(sub_menu==1){
	
	
	var _pips = make_menu_alternate(credits_x, room_height/2-((array_length(menu_options[1])-1)*(credits_spacing)/2), credits_spacing, array_length(menu_options[1]), false, actual_credits_x, credits_x);
	
	for (var i = 0; i < array_length(_pips); ++i){
		draw_primitive_begin(pr_trianglestrip);
		if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], credits_spacing));
		}
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], credits_spacing-10));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
	
		draw_set_color(diamond_fill);
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], credits_spacing-15));
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
		draw_set_alpha(1);
		//text_outline(_pips[i][0]+line_spacing*1.2*power(-1,i+1),_pips[i][1], menu_options[1][i], 2, c_white, 8, 100000, 1000000);
		for(var dto_i=45; dto_i<405; dto_i+=360/8)
		{
		  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
		  draw_text_ext(_pips[i][0]+credits_spacing*1.2*power(-1,i+1)+round(lengthdir_x(2,dto_i)),_pips[i][1]+round(lengthdir_y(2,dto_i)),menu_options[1][i],8,100000);
		}
		draw_set_color(c_white);
		draw_text_ext(_pips[i][0]+credits_spacing*1.2*power(-1,i+1),_pips[i][1], menu_options[1][i],8,10000);
		
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
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1],credits_spacing-15));
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
	
	if(selected[selector_pos]){
		draw_sprite_ext(global.players[selector_pos].portrait_full,0,actual_character_select+350, room_height/2,1,1,image_angle,c_white,0.8);
	}else{
		draw_sprite_ext(global.players[selector_pos].portrait_full,0,actual_character_select+350, room_height/2,1,1,image_angle,c_white,0.5);
	}
	draw_set_font(fnt_archivo);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	text_outline(actual_character_select+350, room_height/2, global.players[selector_pos].name, 1, c_black, 4, 8, 100000);
	draw_set_font(fnt_chiaro);
	
	text_outline(actual_character_select+350, room_height/2+40, global.players[selector_pos].guy, 1, c_black, 4, 8, 100000);
	var _pips = make_menu_alternate(character_select, room_height/2-((array_length(global.players)-1)*(character_select_spacing-15)/2), character_select_spacing-15, array_length(global.players), false, character_select, actual_character_select);
	for (var i = 0; i < array_length(_pips); ++i){
		draw_primitive_begin(pr_trianglestrip);
		
		if(selector_pos==i && selected[i]){
			draw_set_color(c_aqua);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-15));
		}else if(selector_pos==i){
			draw_set_color(c_white);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-15));
		}
		else if(selected[i]){
			draw_set_color(c_blue);
			draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-15));
		}
		draw_primitive_end();
		
		
		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		draw_set_color(diamond_outline);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-25));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		if(selected[i]){
			draw_set_color(diamond_fill);
		}else{
			draw_set_color(merge_color(diamond_fill,c_white,portrait_fill_flash));
		}
	
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-30));
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
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1],character_select_spacing-30));
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

		draw_primitive_begin(pr_trianglestrip);
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
		draw_set_color(c_white);
		draw_set_alpha(portrait_flash_opacity[i]);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], character_select_spacing-25));
		//draw_set_color(global._tpBorder);
		//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
		draw_primitive_end();
		draw_set_alpha(1);


		#endregion
		
		for(j=0;j<3;j++){
			
			var action = global.players[selector_pos].actions[j+1];
			draw_set_color(c_white);
			
			#region setup
			var _border = border;
			var _outline1 = [
				[actual_skill_x, skill_y_start+90+j*220-(optionRadius+_border)],
				[actual_skill_x-(optionRadius+_border), skill_y_start+90+j*220],
				[actual_skill_x, skill_y_start+90+j*220+(optionRadius+_border)],
				[actual_skill_x+500, skill_y_start+90+j*220+(optionRadius+_border)],
				[actual_skill_x+500+(optionRadius+_border), skill_y_start+90+j*220],
				[actual_skill_x+500, skill_y_start+90+j*220-(optionRadius+_border)],
			]
			var _outline2 = [
				
				[actual_skill_x, skill_y_start+90+j*220-(optionRadius+_border*2)],
				[actual_skill_x-(optionRadius+_border*2), skill_y_start+90+j*220],
				[actual_skill_x, skill_y_start+90+j*220+(optionRadius+_border*2)],
				[actual_skill_x+500, skill_y_start+90+j*220+(optionRadius+_border*2)],
				[actual_skill_x+500+(optionRadius+_border*2), skill_y_start+90+j*220],
				[actual_skill_x+500, skill_y_start+90+j*220-(optionRadius+_border*2)],
			]
			_border = 0;
			var _button = [
				[actual_skill_x-(optionRadius+_border), skill_y_start+90+j*220],
				[actual_skill_x, skill_y_start+90+j*220-(optionRadius+_border)],
				
				[actual_skill_x, skill_y_start+90+j*220+(optionRadius+_border)],
				[actual_skill_x+500, skill_y_start+90+j*220-(optionRadius+_border)],
				[actual_skill_x+500, skill_y_start+90+j*220+(optionRadius+_border)],
				
				[actual_skill_x+500+(optionRadius+_border), skill_y_start+90+j*220]
			]
			#endregion
	
			#region draw buttons
			draw_set_alpha(0.1);
			draw_set_color(c_black);
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(_button);
			draw_primitive_end();
			
			draw_set_alpha(1);
			draw_set_color(global._menu_primary);
			draw_primitive_begin(pr_trianglestrip);
			//draw_vertices(_outline1);
			draw_lines(_outline1,border*2,diamond_fill);
			draw_primitive_end();
			
			
			draw_set_color(c_black);
			draw_primitive_begin(pr_trianglestrip);
			//draw_vertices(_outline2);
			draw_lines(_outline2,border,diamond_outline);
			draw_primitive_end();
	
			
	
			
			#endregion
			
			//draw_sprite_ext(spr_shop_menu_border, image_index, actual_skill_x+00, skill_y_start+(j)*220, 0.5, 0.5, image_angle, image_blend, 1);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
			
			draw_set_color(c_white)
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 40, 600, 0.8, 0.8, image_angle);
			
			
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+10, action.name[0], 40, 600, 0.8, 0.8, image_angle);
			//draw_text_ext_transformed(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 40, 600, 0.8, 0.8, image_angle);
			draw_set_font(fnt_chiaro_small);
			text_outline(actual_skill_x+15, skill_y_start+((j)*220)+50, action.description[0], 1, c_black, 4, 30, 460);
			draw_set_color(c_white)
			draw_set_font(fnt_archivo);
			text_outline(actual_skill_x+15, skill_y_start+((j)*220)+15, action.name[0], 1, c_black, 4, 40, 600);
			
			
			var _cost = action.cost[0];
			if(_cost<0){
				_cost=_cost*-1;
				draw_set_font(fnt_archivo);
				draw_set_halign(fa_right);
				draw_set_color(global._tpBar);
				draw_text_transformed_colour(actual_skill_x+400, skill_y_start+((j)*220)+20, "+", 0.7, 0.7, 0, global._tpBar, global._tpBar, global._tpBar, global._tpBar, 1);
				
				draw_set_halign(fa_left);
			}
			
			var _tp_pips = make_tp(actual_skill_x+415, skill_y_start+((j)*220)+50, 7, _cost, true);

			draw_set_color(global._tpBar);
			for (var k = 0; k < array_length(_tp_pips); k++){
				draw_primitive_begin(pr_trianglestrip);
				draw_vertices(make_diamond(_tp_pips[k][0],_tp_pips[k][1], 5));
				draw_primitive_end();
			}
			draw_set_color(c_white)
		}
		
	}
	
	#region turn banner
	if (turn_banner_animation_started) {
		turn_life--;
		draw_set_color(global._primary);
	
		if (turn_life > 50) {
			draw_set_alpha(turn_opacity/100);
		}
		else {
			turn_life--;
			draw_set_alpha(turn_life/100);
		}
		if(turn_life<=0){
			turn_banner_animation_started=false;	
		}
		
		draw_rectangle_colour(0, 500, room_width, 250, global._aspect_bars, global._aspect_bars, global._aspect_bars, global._aspect_bars, false);
		draw_set_color(diamond_fill);
		draw_set_halign(fa_center);
		draw_set_font(fnt_archivo);
		draw_text_transformed(room_width/2, 320, "SELECT YOUR TEAM", turn_text_anim, 2, 0);
	
	}
	else {
		turn_life = 100;
	}
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	#endregion
	
}

if(sub_menu==3){
	for(i=0;i<total_options;i++){
		//draw_sprite_ext(option_s,i,x,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*i),option[i,_scale],option[i,_scale],0,c_white,option[i,_fade]);
			if(option_cur==i){
				draw_set_alpha(0.2);
				draw_set_color(c_white);
				draw_rectangle_color(actual_tips-3, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),actual_tips+tip_box_width+2,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,c_white,c_white,c_white,c_white,false);
			}
			draw_set_alpha(option[i,_fade]);
			
			
			draw_set_color(diamond_outline);
			draw_line_width(actual_tips-3, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),actual_tips+tip_box_width+2, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),5);
			draw_line_width(actual_tips+tip_box_width, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),actual_tips+tip_box_width, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height,5);
			draw_line_width(actual_tips-3, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height,actual_tips+tip_box_width+2, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height,5);
			draw_line_width(actual_tips, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),actual_tips, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height,5);
			
			draw_set_color(diamond_fill);
			draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,2);
			draw_line_width(actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
			draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
			draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
			
			draw_set_color(c_black);
			draw_set_halign(fa_center);
			draw_set_font(fnt_chiaro);
			for(var dto_i=45; dto_i<405; dto_i+=360/8)
			{
			  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
			  draw_text_ext_transformed(actual_tips+(tip_box_width/2)+round(lengthdir_x(1,dto_i)),y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+2+round(lengthdir_y(1,dto_i)),tips[i][0],8,10000000,1,1,0);
			}
			draw_set_color(c_white);
			draw_text_ext_transformed(actual_tips+(tip_box_width/2),y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+2,tips[i][0],8,10000000,1,1,0);
			
			//draw_primitive_begin(pr_trianglestrip);
			//draw_vertices(make_diamond(actual_tips,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),(skill_diamond_size)));
			//draw_primitive_end();
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
		
	}
	show_debug_message(option[0,_scale]);
	draw_set_alpha(0.1);
	draw_set_color(c_black);
	
	draw_rectangle(actual_description_x,description_y_start,actual_description_x+description_box_width,description_y_start+description_box_height,false);
	draw_set_alpha(1);
	draw_set_color(diamond_outline);
	draw_line_width(actual_description_x-3,description_y_start,actual_description_x+description_box_width+2, description_y_start,5);
	draw_line_width(actual_description_x+description_box_width, description_y_start,actual_description_x+description_box_width, description_y_start+description_box_height,5);
	draw_line_width(actual_description_x-3, description_y_start+description_box_height,actual_description_x+description_box_width+2, description_y_start+description_box_height,5);
	draw_line_width(actual_description_x, description_y_start,actual_description_x, description_y_start+description_box_height,5);
			
	draw_set_color(diamond_fill);
	draw_line_width(actual_description_x+1,description_y_start+1,actual_description_x+description_box_width-1, description_y_start+1,2);
	draw_line_width(actual_description_x+description_box_width-1, description_y_start+1,actual_description_x+description_box_width-1, description_y_start+description_box_height-1,2);
	draw_line_width(actual_description_x+1, description_y_start+description_box_height-1,actual_description_x+description_box_width-1, description_y_start+description_box_height-1,2);
	draw_line_width(actual_description_x+1, description_y_start+1,actual_description_x+1, description_y_start+description_box_height-1,2);
	//draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,2);
	//draw_line_width(actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
	//draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,actual_tips+tip_box_width-1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
	//draw_line_width(actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+1,actual_tips+1, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,2);
			
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_chiaro_small);
	text_outline(actual_description_x+20,description_y_start,tips[option_cur][1],1,c_black,8,30,description_box_width-40);
	//draw_set_color(c_black);
	//draw_rectangle(actual_description_x,description_y_start,actual_description_x+500,description_y_start+600,false);
	draw_set_alpha(1);
	
}

if(sub_menu==4){
	for(var i=0;i<total_controls;i++){
		//draw_sprite_ext(option_s,i,x,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*i),controls_draw[i,_scale],controls_draw[i,_scale],0,c_white,controls_draw[i,_fade]);
			if(controls_cur==i){
				draw_set_alpha(0.2);
				draw_set_color(c_white);
				draw_rectangle_color(actual_tips-3, y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),actual_tips+tip_box_width+2,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+tip_box_height-1,c_white,c_white,c_white,c_white,false);
			}
			draw_set_alpha(controls_draw[i,_fade]);
			
			
			draw_set_font(fnt_chiaro);
			for(var dto_i=45; dto_i<405; dto_i+=360/8){
			  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
			  draw_text_ext_transformed(actual_tips+(tip_box_width/2)+round(lengthdir_x(1,dto_i)),y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+2+round(lengthdir_y(1,dto_i)),controls_list[i][0],8,10000000,1,1,0);
			}
			draw_set_color(c_white);
			draw_text_ext_transformed(actual_tips+(tip_box_width/2),y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i))+2,controls_list[i][0],8,10000000,1,1,0);
			
			draw_primitive_begin(pr_trianglestrip);
			draw_vertices(make_diamond(actual_tips,y+((y_draw_cur)+(y_draw_offset+y_draw_spacing)*(i)),(skill_diamond_size)));
			draw_primitive_end();
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
		
	}
	//show_debug_message(options[0,_scale]);
	draw_set_alpha(0.1);
	draw_set_color(c_black);
	
	
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_chiaro_small);
	//text_outline(actual_description_x+20,description_y_start,tips[controls_cur][1],1,c_black,8,30,description_box_width-40);
	//draw_rectangle(actual_description_x,description_y_start,actual_description_x+500,description_y_start+600,false);
	draw_set_alpha(1);
}
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_set_font(fnt_chiaro);
draw_set_color(c_white);
text_outline(580,700, string_upper(global.other_controls[0])+string_upper(global.other_controls[1])+string_upper(global.other_controls[2])+string_upper(global.other_controls[3])+"- Move Cursor     "+string_upper(global.other_controls[4])+" - Select Unit     "+string_upper(global.other_controls[6])+" - End Turn", 1, c_black, 8, 100000, 1000000);
draw_set_color(c_white);