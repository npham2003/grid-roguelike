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
	}
	else if(sub_menu==1){
		actual_credits_x=lerp(actual_credits_x,credits_x,0.2);
	}
}else{
	if(sub_menu==0){
		actual_logo_x=lerp(actual_logo_x,initial_logo_x,0.2);
		actual_options_x=lerp(actual_options_x,initial_options_x,0.2);
		if(actual_logo_x<=-290){
			if(selector_pos==0){
				room_goto(2);
			}
			if(selector_pos==1){
				room_goto(1);
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
					
					
					
					if(selector_pos==2){
						
						next_background_color=menu_colors[1];
					}
					if(selector_pos==3){
						funny_opacity=1;
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
					}else{
						url_open_ext(website_urls[selector_pos],"_blank");
					}
				}
				if(keyboard_check_pressed(vk_tab)){
					transition_in=false;
					selector_pos=0;
					next_background_color=menu_colors[0];
				}
			}
			break;
}