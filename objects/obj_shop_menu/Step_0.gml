
if(obj_battleControl.state==BattleState.PlayerUpgrade){
	alpha = lerp(alpha,1,0.05);
	actual_x=lerp(actual_x,x,0.05);
	switch(menu_level){
		case 0:
			if (keyboard_check_pressed(ord("A"))) {
				selector_pos[0]-=1;
				fill_alpha = 0;
				if(selector_pos[0]<0){
					selector_pos[0]=3;
				}
			}
			if (keyboard_check_pressed(ord("D"))) {
				selector_pos[0]+=1;
				fill_alpha = 0;
				selector_pos[0]=selector_pos[0]%4
			}
			if (keyboard_check_pressed(ord("S"))) {
				selector_pos[1]+=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
			}
			if (keyboard_check_pressed(ord("W"))) {
				selector_pos[1]-=1;
				fill_alpha = 0;
				selector_pos[1]=selector_pos[1]%2
				if(selector_pos[1]<0){
					selector_pos[1]=1;
				}
			}
			if(keyboard_check_pressed(vk_enter) && selectable[selector_pos[0]+selector_pos[1]*4]){
				if(selector_pos[0]==0&&selector_pos[1]==0){
					menu_level=1;
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
			if(keyboard_check_pressed(vk_enter) && selectable[character_select_pos]){
				heal(obj_battleControl.player_units[character_select_pos]);
			}
			break;
	}
}else{
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,2500,0.05);
}