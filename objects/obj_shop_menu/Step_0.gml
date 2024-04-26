
if(obj_battleControl.state==BattleState.PlayerUpgrade){
	alpha = lerp(alpha,1,0.05);
	actual_x=lerp(actual_x,x,0.05);
	switch(menu_level){
		case 0:
			if (keyboard_check_pressed(ord("A"))) {
				selector_pos[0]-=1;
				fill_alpha = 0;
				if(selector_pos[0]<0){
					selector_pos[0]=3-selector_pos[1];
				}
			}
			if (keyboard_check_pressed(ord("D"))) {
				selector_pos[0]+=1;
				fill_alpha = 0;
				if(selector_pos[1]==0){
					selector_pos[0]=selector_pos[0]%4
				}else{
					selector_pos[0]=selector_pos[0]%3
				}
			}
			if (keyboard_check_pressed(ord("S"))) {
				selector_pos[1]+=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
				if(selector_pos[1]==1 && selector_pos[0]==3){
					selector_pos[0]=2;
				}
			}
			if (keyboard_check_pressed(ord("W"))) {
				selector_pos[1]-=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
				if(selector_pos[1]<0){
					selector_pos[1]=1;
				}
			}
			if(keyboard_check_pressed(vk_enter)){
				if(!selectable[selector_pos[0]+selector_pos[1]*4]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				if(selector_pos[0]==0&&selector_pos[1]==0){ // heal
					menu_level=1;
				}
				if(selector_pos[0]==1&&selector_pos[1]==0&&selectable[1]){ // gain 1 tp
					obj_battleControl.tp_current+=1;
					obj_battleControl.gold-=cost[1];
					audio_play_sound(sfx_buy, 0, false);
					
				}
				if(selector_pos[0]==2&&selector_pos[1]==0&&selectable[2]){ // 1 extra tp per turn
					tp_bonus();
					audio_play_sound(sfx_buy, 0, false);
					
				}
				if(selector_pos[0]==3&&selector_pos[1]==0&&selectable[3]){ // 1 extra dmg on attacks
					attack_up();
					audio_play_sound(sfx_buy, 0, false);
				}
				if(selector_pos[0]==0&&selector_pos[1]==1&&selectable[4]){ // upgrade skill 1
					menu_level=2;
					skill_select_pos=1;
				}
				if(selector_pos[0]==1&&selector_pos[1]==1&&selectable[5]){ // upgrade skill 2
					menu_level=2;
					skill_select_pos=2;
				}
				if(selector_pos[0]==2&&selector_pos[1]==1&&selectable[6]){ // upgrade skill 3
					menu_level=2;
					skill_select_pos=3;
				}
				if(selector_pos[0]==3&&selector_pos[1]==1&&selectable[7]){ // new party member
					new_party_member();
					audio_play_sound(sfx_buy, 0, false);
				}
				
			}
			if(keyboard_check_pressed(vk_tab)){
				selector_pos=[0,0];
				obj_battleControl.change_state(BattleState.BattleStart);
			}
			break;
		case 1:
			if (keyboard_check_pressed(ord("A"))) {
				character_select_pos-=1;
				
				if(character_select_pos<0){
					character_select_pos=array_length(obj_battleControl.player_units)-1;
				}
			}
			if (keyboard_check_pressed(ord("D"))) {
				character_select_pos+=1;
				character_select_pos=character_select_pos%array_length(obj_battleControl.player_units);
				
			}
			if(keyboard_check_pressed(vk_tab)){
				menu_level=0;
				character_select_pos=0;
			}
			if(keyboard_check_pressed(vk_enter)){
				if(!selectable[character_select_pos]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				heal(obj_battleControl.player_units[character_select_pos]);
				audio_play_sound(sfx_buy, 0, false);
			}
			break;
		case 2:
			if (keyboard_check_pressed(ord("A"))) {
				character_select_pos-=1;
				
				if(character_select_pos<0){
					character_select_pos=array_length(obj_battleControl.player_units)-1;
				}
			}
			if (keyboard_check_pressed(ord("D"))) {
				character_select_pos+=1;
				character_select_pos=character_select_pos%array_length(obj_battleControl.player_units);
				
			}
			if(keyboard_check_pressed(vk_tab)){
				menu_level=0;
				character_select_pos=0;
			}
			if(keyboard_check_pressed(vk_enter)){
				menu_level=3;
			}
			break;
		case 3:
			if(keyboard_check_pressed(vk_tab)){
				menu_level=2;
			}
			if (keyboard_check_pressed(ord("S"))) {
				new_skill_upgrade+=1;
				if(new_skill_upgrade>2){
					new_skill_upgrade=0;
				}
			}
			if (keyboard_check_pressed(ord("W"))) {
				new_skill_upgrade-=1;
				if(new_skill_upgrade<0){
					new_skill_upgrade=2;
				}
			}
			if(keyboard_check_pressed(vk_enter)){
				if(!selectable[new_skill_upgrade]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				audio_play_sound(sfx_buy, 0, false);
				menu_level=0;
				upgrade(obj_battleControl.player_units[character_select_pos],skill_select_pos,new_skill_upgrade);
			}
		
	}
}else{
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,2500,0.05);
}
