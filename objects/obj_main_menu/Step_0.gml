/// @description Insert description here
// You can write your code in this editor
layer_background_blend(background, current_background_color);
current_background_color = merge_color(current_background_color, next_background_color, 0.1);


if(funny_opacity>0){
	funny_opacity-=0.05;
}

#region turn opacity

	if(turn_opacity_increase){
		turn_opacity+=0.05;
	}else{
		turn_opacity-=0.05;
	}
	if(turn_opacity>=0.8){
		turn_opacity_increase=false;
	}
	if(turn_opacity<=0.5){
		turn_opacity_increase=true;
	}


turn_text_anim = lerp(turn_text_anim, 2, 0.2)
#endregion

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
		layer_hspeed(background_layer, lerp(layer_get_hspeed(background_layer),initial_bg_hspeed*-5,0.2));
		layer_vspeed(background_layer, lerp(layer_get_vspeed(background_layer),initial_bg_vspeed*5,0.2));
	}
	else if(sub_menu==3){
		actual_tips=lerp(actual_tips,tips_x,0.1);
		actual_description_x=lerp(actual_description_x,description_x_start,0.1);
	}
	else if(sub_menu==4){
		actual_tips=lerp(actual_tips,tips_x,0.1);
		actual_description_x=lerp(actual_description_x,description_x_start,0.1);
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
				css_sound_id=audio_play_sound(bgm_gather_under_night,0,true,0.6);
				turn_life=100;
				turn_banner_animation_started=true;
				turn_opacity=100;
			
				turn_text_anim = 0;
				turn_life = 100;
				portrait_flash=[false,false,false,false,false,false];
				portrait_flash_opacity=[0,0,0,0,0,0];
				portrait_final_flash=false;
				transition_in=true;
				beat_increment=0;
				
				
			}
			if(selector_pos==1){
				room_goto(1);
				
				audio_stop_sound(bgm_xenoblade_x_title);
				
				audio_stop_sound(bgm_xenoblade_x_title);
			}
			if(selector_pos==2){
				sub_menu=3;
				transition_in=true;
				selector_pos=0;
				
			}
			if(selector_pos==3){
				sub_menu=1;
				transition_in=true;
				selector_pos=0;
			}
			if(selector_pos==4){
				sub_menu=4;
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
			selector_pos=3;
		}
		
		
	}
	else if(sub_menu==2){
		actual_character_select=lerp(actual_character_select,initial_character_select,0.1);
		actual_skill_x=lerp(actual_skill_x,initial_skill_x,0.1);
		
		if(actual_character_select<-1950){
			audio_stop_sound(bgm_gather_under_night);
			if(curr>=2){
				audio_stop_sound(bgm_xenoblade_x_title);
				room_goto(3);
			}else{
				sub_menu=0;
				transition_in=true;
				audio_resume_sound(bgm_xenoblade_x_title);
				
				
			}
		}
	}
	else if(sub_menu==3){
		actual_tips=lerp(actual_tips,initial_tips,0.1);
		actual_description_x=lerp(actual_description_x,initial_description_x,0.1);
		if(actual_tips<-1900){
			transition_in=true;
			sub_menu=0;
			current_tip=array_length(tips)-1;
			option_cur=0;
		}
	}
	else if(sub_menu==4){
		actual_tips=lerp(actual_tips,initial_tips,0.1);
		actual_description_x=lerp(actual_description_x,initial_description_x,0.1);
		if(actual_tips<-1900){
			transition_in=true;
			sub_menu=0;
			current_tip=array_length(tips)-1;
			option_cur=0;
		}
	}
}

switch(sub_menu){
	case 0:
			if(transition_in){
				if (input_check_pressed("down")) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(menu_options[0]);
				
				}
				if (input_check_pressed("up")) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(menu_options[0])-1;
					}
				}
				if(input_check_pressed("confirm")){
					
					if(selector_pos==0){
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						
						
						next_background_color=menu_colors[2];
						
						curr=0;
						
					}
					if(selector_pos==1){
						audio_play_sound(sfx_game_start, 0, false, 0.7, 0);
					}
					if(selector_pos==2){
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						next_background_color=menu_colors[3];
					}
					if(selector_pos==3){
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						next_background_color=menu_colors[1];
					}
					if(selector_pos==4){
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						next_background_color=menu_colors[1];
					}
					if(selector_pos==5){
						funny_opacity=1;
						audio_play_sound(sfx_vine_boom, 0, false, 0.7, 0);
					}else{
						transition_in=false;
					}
					
				}
			}
			break;
	case 1:
			if(transition_in){
				if (input_check_pressed("down")) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(menu_options[1]);
				
				}
				if (input_check_pressed("up")) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(menu_options[1])-1;
					}
				}
				if(input_check_pressed("confirm")){
					if(selector_pos==array_length(menu_options[1])-1){
						transition_in=false;
						selector_pos=0;
						next_background_color=menu_colors[0];
						audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					}else{
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						url_open_ext(website_urls[selector_pos],"_blank");
					}
				}
				if(input_check_pressed("back")){
					transition_in=false;
					selector_pos=3;
					next_background_color=menu_colors[0];
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
				}
			}
			break;
	case 2:
			if(transition_in){
				if (input_check_pressed("down")) {
					selector_pos+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					selector_pos=selector_pos%array_length(global.players);
				
				}
				if (input_check_pressed("up")) {
					selector_pos-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(selector_pos<0){
						selector_pos=array_length(global.players)-1;
					}
				}
				if(input_check_pressed("confirm")){
					if(!selected[selector_pos]){
						while(party[curr]!=-1){
							curr++;
						}
						party[curr]=selector_pos;
						selected[selector_pos]=true;
						
						if(curr!=2){
							audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						}
					}else{
						audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
						selected[selector_pos]=false;
						var iter = 0;
						while(iter<array_length(party)){
							if(party[iter]==selector_pos){
								break;	
							}
							iter+=1;
						}
						curr=iter;
						party[curr]=-1;
						for(i=curr;i<array_length(party)-1;i++){
							party[i]=party[i+1];
						}
						party[2]=-1;
						
						
					}
					if(curr==2){
						for(var i = 0; i < array_length(global.party); i++){
							global.party[i].info=global.players[party[i]];
							global.party[i].grid=[i, 2];
						}
						transition_in=false;
						audio_play_sound(sfx_game_start, 0, false, 1, 0);
					}
						
					show_debug_message(selected);
						show_debug_message(party);
						show_debug_message(curr);
				}
				if(input_check_pressed("back")){
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					
					var iter = 2;
						while(iter>-1){
							if(party[iter]!=-1){
								break;	
							}
							iter-=1;
						}
					curr=iter;
					
					
					if(curr>=0){
						
						
						selected[party[curr]] = false;
						party[curr] = -1;
						
					
					}else{
						transition_in=false;
						selector_pos=0;
						next_background_color=menu_colors[0];
						
					}
				}
			}
			for(i=0;i<array_length(portrait_flash);i++){
				if(portrait_flash_times[i]<audio_sound_get_track_position(css_sound_id) && !portrait_flash[i]){
					portrait_flash[i]=true;
					portrait_flash_opacity[i]=1;
				}
				
				if(portrait_flash_opacity[i]>0){
					portrait_flash_opacity[i]-=0.02;
				}
			}
			if(portrait_flash_times[6]<audio_sound_get_track_position(css_sound_id)&&portrait_flash_opacity[5]==0&&!portrait_final_flash){
				for(i=0;i<array_length(portrait_flash_opacity);i++){
				
				
				
					portrait_flash_opacity[i]=1;
				
				}
				portrait_final_flash=true;
			}
			if(portrait_final_flash){
				if(floor(audio_sound_get_track_position(css_sound_id)/beat_length)==0){
					beat_increment=0;
				}
				if(floor(audio_sound_get_track_position(css_sound_id)/beat_length)>beat_increment){
					beat_increment=floor(audio_sound_get_track_position(css_sound_id)/beat_length);
					portrait_fill_flash=0.9;
				}
				
			}
			if(portrait_fill_flash>0){
				portrait_fill_flash-=0.05;
			}
			
			break;
	case 3:
		
			if(transition_in){
				if (input_check_pressed("down")) {
					option_cur+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					option_cur=option_cur%total_options;
				
				}
				if (input_check_pressed("up")) {
					option_cur-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(option_cur<0){
						option_cur=total_options-1;
					}
				}
				if (input_check_pressed("right")) {
					option_cur+=5;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					option_cur=option_cur%total_options;
				
				}
				if (input_check_pressed("left")) {
					option_cur-=5;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(option_cur<0){
						option_cur=total_options+option_cur;
					}
				}
				if(input_check_pressed("back")){
					transition_in=false;
					selector_pos=2;
					next_background_color=menu_colors[0];
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					
					
				}
				if(input_check_pressed("confirm")){
					
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						current_tip=option_cur;
				}
			//Determine the current y position we are drawing at
			if y_draw_cur!=y_draw_begin{//If the y position to draw is not yet at the begin y position we want, in/de crease the value to get it there
			    y_draw_cur+=(y_draw_begin-y_draw_cur)*transition_speed;}//This will "smoothing" transition the y position to the begin position

			//Determine the begin y position to draw
			y_draw_begin=(y_draw_offset*-1)*option_cur; //we do -1 because the menu will be drawn downward, doing -1 will then make the images begin to draw up higher

			//Determine the Current option we are selecting/hovering
			//option_cur=clamp(option_cur+(input_check_pressed("down")-input_check_pressed("up")),0,total_options-1);

			//Scale the options
			for(i=0;i<total_options;i++){
			    var scale_end=scale+(scale_add*(option_cur==i)); //add additional scale size if this option is the currently selected option
			    //if option[i,_scale]!=scale_end{
			    //    option[i,_scale]+=(scale_end-option[i,_scale])*scale_speed;}}
				option[i, _scale]=1;
			}
      
			//Fade the options
			for(i=0;i<total_options;i++){
			    var fade_end=1-(abs(i-option_cur)*fade); //find the "distance" this option is from current option, use that to determine strength of fade
			    if option[i,_fade]!=fade_end{
			        option[i,_fade]+=(fade_end-option[i,_fade])*fade_speed;}}
			}
			break;

case 4:
	
			if(transition_in){
				if (input_check_pressed("down")) {
					controls_cur+=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					controls_cur=controls_cur%total_controls;
				
				}
				if (input_check_pressed("up")) {
					controls_cur-=1;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(controls_cur<0){
						controls_cur=total_controls-1;
					}
				}
				if (input_check_pressed("right")) {
					controls_cur+=5;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					controls_cur=controls_cur%total_controls;
				
				}
				if (input_check_pressed("left")) {
					controls_cur-=5;
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					if(controls_cur<0){
						controls_cur=total_controls+controls_cur;
					}
				}
				if(input_check_pressed("back")){
					transition_in=false;
					selector_pos=2;
					next_background_color=menu_colors[0];
					audio_play_sound(sfx_menu_back, 0, false, 0.7, 0);
					
					
				}
				if(input_check_pressed("confirm")){
					
						audio_play_sound(sfx_menu_next, 0, false, 0.7, 0);
						current_tip=controls_cur;
				}
			//Determine the current y position we are drawing at
			if (y_draw_cur!=y_draw_begin) {//If the y position to draw is not yet at the begin y position we want, in/de crease the value to get it there
			    y_draw_cur+=(y_draw_begin-y_draw_cur)*transition_speed;}//This will "smoothing" transition the y position to the begin position

			//Determine the begin y position to draw
			y_draw_begin=(y_draw_offset*-1)*controls_cur; //we do -1 because the menu will be drawn downward, doing -1 will then make the images begin to draw up higher

			//Determine the Current option we are selecting/hovering
			//controls_cur=clamp(controls_cur+(input_check_pressed("down")-input_check_pressed("up")),0,total_controls-1);

			//Scale the options
			for(i=0;i<total_controls;i++){
			    var scale_end=scale+(scale_add*(controls_cur==i)); //add additional scale size if this option is the currently selected option
			    //if controls_draws[i,_scale]!=scale_end{
			    //    controls_draws[i,_scale]+=(scale_end-controls_draws[i,_scale])*scale_speed;}}
				controls_draws[i, _scale]=1;
			}
      
			//Fade the options
			for(i=0;i<total_controls;i++){
			    var fade_end=1-(abs(i-controls_cur)*fade); //find the "distance" this option is from current option, use that to determine strength of fade
			    if (controls_draws[i,_fade]!=fade_end){
			        controls_draws[i,_fade]+=(fade_end-controls_draws[i,_fade])*fade_speed;}}
			}
			break;
		
}