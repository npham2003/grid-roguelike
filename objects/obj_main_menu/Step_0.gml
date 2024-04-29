/// @description Insert description here
// You can write your code in this editor
layer_background_blend(background, current_background_color);
current_background_color = merge_color(current_background_color, next_background_color, 0.1);

if(funny_opacity>0){
	funny_opacity-=0.05;
}

if(transition_in){
	
	if(sub_menu==0){
		actual_logo_x=lerp(actual_logo_x,logo_x,0.2);
		actual_options_x=lerp(actual_options_x,options_x,0.2);
		layer_hspeed(background_layer, lerp(layer_get_hspeed(background_layer),initial_bg_hspeed,0.2));
		layer_vspeed(background_layer, lerp(layer_get_vspeed(background_layer),initial_bg_vspeed,0.2));
	}
	else if(sub_menu==1){
		actual_credits_x=lerp(actual_credits_x,credits_x,0.2);
	}
	else if(sub_menu==2){
		actual_character_select=lerp(actual_character_select,character_select,0.1);
		actual_skill_x=lerp(actual_skill_x,skill_x_start,0.1);
		layer_hspeed(background_layer, lerp(layer_get_hspeed(background_layer),initial_bg_hspeed*3,0.2));
		layer_vspeed(background_layer, lerp(layer_get_vspeed(background_layer),initial_bg_vspeed*3,0.2));
	}
}else{
	if(sub_menu==0){
		actual_logo_x=lerp(actual_logo_x,initial_logo_x,0.2);
		actual_options_x=lerp(actual_options_x,initial_options_x,0.2);
		if(actual_logo_x<=-290){
			
			
			if(selector_pos==0){
				//room_goto(2);
				sub_menu=2;
				transition_in=true;
				audio_pause_sound(bgm_xenoblade_x_title);
				audio_play_sound(bgm_gather_under_night,0,true,0.7);
				
				transition_in=true;
				audio_pause_sound(bgm_xenoblade_x_title);
				audio_play_sound(bgm_gather_under_night,0,true,0.7);
				
			}
			if(selector_pos==1){
				room_goto(1);
				
				audio_stop_sound(bgm_xenoblade_x_title);
				
				audio_stop_sound(bgm_xenoblade_x_title);
			}
			if(selector_pos==2){
				sub_menu=1;
				transition_in=true;
				selector_pos=0;
			}
		}
	}
	else if(sub_menu==1){
		actual_credits_x=lerp(actual_credits_x,initial_credits_x,0.1);
		if(actual_credits_x>1900){
			sub_menu=0;
			transition_in=true;
		}
		
	}
	else if(sub_menu==2){
		actual_character_select=lerp(actual_character_select,initial_character_select,0.1);
		actual_skill_x=lerp(actual_skill_x,initial_skill_x,0.1);
		
		if(actual_character_select<-1950){
			audio_stop_sound(bgm_gather_under_night);
			if(curr>=3){
				audio_stop_sound(bgm_xenoblade_x_title);
				room_goto(3);
			}else{
				sub_menu=0;
				transition_in=true;
				audio_resume_sound(bgm_xenoblade_x_title);
				
				
			}
		}
	}
}

switch(sub_menu){
	case 0:
			if(transition_in){
				if (keyboard_check_pressed(ord("S"))) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(menu_options[0]);
				
				}
				if (keyboard_check_pressed(ord("W"))) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(menu_options[0])-1;
					}
				}
				if(keyboard_check_pressed(vk_enter)){
					
					if(selector_pos==0){
						audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						
						audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						
						next_background_color=menu_colors[2];
						
						
						
					}
					if(selector_pos==1){
						audio_play_sound(sfx_game_start, 0, false, 1, 0);
					}
					
					if(selector_pos==2){
						audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						next_background_color=menu_colors[1];
					}
					if(selector_pos==3){
						funny_opacity=1;
						audio_play_sound(sfx_vine_boom, 0, false, 1, 0);
					}else{
						transition_in=false;
					}
					
				}
			}
			break;
	case 1:
			if(transition_in){
				if (keyboard_check_pressed(ord("S"))) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(menu_options[1]);
				
				}
				if (keyboard_check_pressed(ord("W"))) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(menu_options[1])-1;
					}
				}
				if(keyboard_check_pressed(vk_enter)){
					if(selector_pos==array_length(menu_options[1])-1){
						transition_in=false;
						selector_pos=0;
						next_background_color=menu_colors[0];
						audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					}else{
						audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						url_open_ext(website_urls[selector_pos],"_blank");
					}
				}
				if(keyboard_check_pressed(vk_tab)){
					transition_in=false;
					selector_pos=2;
					next_background_color=menu_colors[0];
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
				}
			}
			break;
	case 2:
			if(transition_in){
				if (keyboard_check_pressed(ord("S"))) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(global.players);
				
				}
				if (keyboard_check_pressed(ord("W"))) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(global.players)-1;
					}
				}
				if(keyboard_check_pressed(vk_enter)){
					if(!selected[selector_pos]){
						party[curr]=selector_pos;
						selected[selector_pos]=true;
						curr++;
						if(curr!=3){
							audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						}
					}
					if(curr==3){
						for(var i = 0; i < array_length(global.party); i++){
							global.party[i].info=global.players[party[i]];
							global.party[i].grid=[i, 2];
						}
						transition_in=false;
						audio_play_sound(sfx_game_start, 0, false, 1, 0);
					}
						
					
				}
				if(keyboard_check_pressed(vk_tab)){
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					if(curr>0){
						
						curr--;
						selected[party[curr]] = false;
						party[curr] = -1;
					
					}else{
						transition_in=false;
						selector_pos=0;
						next_background_color=menu_colors[0];
						
					}
				}
			}
			break;
	case 2:
			if(transition_in){
				if (keyboard_check_pressed(ord("S"))) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(global.players);
				
				}
				if (keyboard_check_pressed(ord("W"))) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(global.players)-1;
					}
				}
				if(keyboard_check_pressed(vk_enter)){
					if(!selected[selector_pos]){
						party[curr]=selector_pos;
						selected[selector_pos]=true;
						curr++;
						if(curr!=3){
							audio_play_sound(sfx_menu_next, 0, false, 1, 0);
						}
					}
					if(curr==3){
						for(var i = 0; i < array_length(global.party); i++){
							global.party[i].info=global.players[party[i]];
							global.party[i].grid=[i, 2];
						}
						transition_in=false;
						audio_play_sound(sfx_game_start, 0, false, 1, 0);
					}
						
					
				}
				if(keyboard_check_pressed(vk_tab)){
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					if(curr>0){
						
						curr--;
						selected[party[curr]] = false;
						party[curr] = -1;
					
					}else{
						transition_in=false;
						selector_pos=0;
						next_background_color=menu_colors[0];
						
					}
				}
			}
			break;
}