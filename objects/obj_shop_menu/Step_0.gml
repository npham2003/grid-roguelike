
if(delay>0){
	delay-=1;
	return;
}

if(obj_battleControl.state==BattleState.PlayerUpgrade && !transition_out){
	
	obj_gridCreator.x=5000;
	obj_battleControl.transition_count=120;
	alpha = lerp(alpha,1,0.05);
	actual_x=lerp(actual_x,room_width/2,0.05);
	switch(menu_level){
		case 0:
			if (input_check_pressed("left")) {
				selector_pos[0]-=1;
				fill_alpha = 0;
				if(selector_pos[0]<0){
					selector_pos[0]=2;
				}
			}
			if (input_check_pressed("right")) {
				selector_pos[0]+=1;
				fill_alpha = 0;
				selector_pos[0]=selector_pos[0]%3
				
			}
			if (input_check_pressed("down")) {
				selector_pos[1]+=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
				if(selector_pos[1]==1 && selector_pos[0]==3){
					selector_pos[0]=2;
				}
			}
			if (input_check_pressed("up")) {
				selector_pos[1]-=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
				if(selector_pos[1]<0){
					selector_pos[1]=1;
				}
			}
			if(input_check_pressed("confirm")){
				if(!selectable[selector_pos[0]+selector_pos[1]*3]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				if(selector_pos[0]==0&&selector_pos[1]==0){ // heal
					menu_level=1;
				}
				if(selector_pos[0]==1&&selector_pos[1]==0&&selectable[1]){ // gain 1 tp
					tp_bonus();
					audio_play_sound(sfx_buy, 0, false);
					
				}
				if(selector_pos[0]==2&&selector_pos[1]==0&&selectable[2]){ // 1 extra tp per turn
					attack_up();
					audio_play_sound(sfx_buy, 0, false);
					
				}
				if(selector_pos[0]==0&&selector_pos[1]==1&&selectable[3]){ // upgrade skill 1
					menu_level=2;
					character_select_pos=0;
				}
				if(selector_pos[0]==1&&selector_pos[1]==1&&selectable[4]){ // upgrade skill 2
					menu_level=2;
					character_select_pos=1;
				}
				if(selector_pos[0]==2&&selector_pos[1]==1&&selectable[5]){ // upgrade skill 3
					menu_level=2;
					character_select_pos=2;
				}
				//if(selector_pos[0]==3&&selector_pos[1]==1&&selectable[7]){ // new party member
				//	new_party_member();
				//	audio_play_sound(sfx_buy, 0, false);
				//}
				
			}
			if(input_check_pressed("back")){
				selector_pos=[0,0];
				transition_out=true;
			}
			break;
		case 1:
			if (input_check_pressed("left")) {
				character_select_pos-=1;
				
				if(character_select_pos<0){
					character_select_pos=array_length(obj_battleControl.player_units)-1;
				}
			}
			if (input_check_pressed("right")) {
				character_select_pos+=1;
				character_select_pos=character_select_pos%array_length(obj_battleControl.player_units);
				
			}
			if(input_check_pressed("back")){
				menu_level=0;
				character_select_pos=0;
			}
			if(input_check_pressed("confirm")){
				if(!selectable[character_select_pos]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				heal(obj_battleControl.player_units[character_select_pos]);
				audio_play_sound(sfx_buy, 0, false);
			}
			break;
		case 2:
			if (input_check_pressed("up")) {
				skill_select_pos-=1;
				
				if(skill_select_pos<0){
					skill_select_pos=2;
				}
			}
			if (input_check_pressed("down")) {
				skill_select_pos+=1;
				
				if(skill_select_pos>2){
					skill_select_pos=0;
				}
				
			}
			if(input_check_pressed("back")){
				menu_level=0;
				character_select_pos=0;
			}
			if(input_check_pressed("confirm")){
				menu_level=3;
				skill_select_pos+=1;
				new_skill_upgrade=obj_battleControl.player_units[character_select_pos].upgrades[skill_select_pos];
			}
			break;
		case 3:
			if(input_check_pressed("back")){
				menu_level=2;
				skill_select_pos-=1;
			}
			if (input_check_pressed("down")) {
				new_skill_upgrade+=1;
				if(new_skill_upgrade>2){
					new_skill_upgrade=0;
				}
			}
			if (input_check_pressed("up")) {
				new_skill_upgrade-=1;
				if(new_skill_upgrade<0){
					new_skill_upgrade=2;
				}
			}
			if(input_check_pressed("confirm")){
				if(!selectable[new_skill_upgrade]){
					audio_play_sound(sfx_no_tp, 0, false);
					return;
				}
				audio_play_sound(sfx_buy, 0, false);
				menu_level=0;
				upgrade(obj_battleControl.player_units[character_select_pos],skill_select_pos,new_skill_upgrade);
			}
		
	}
}else if(transition_out){
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,-2000,0.05);
	
	if(actual_x<-1500){
		transition_out=false;

		obj_battleControl.transition_count=80;

		obj_gridCreator.transition_in=true;
		obj_battleControl.change_state(BattleState.BattleStart);
	}
}else{
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,2500,0.05);
	delay=120;
}
