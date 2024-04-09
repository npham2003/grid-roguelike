
if(obj_battleControl.state==BattleState.PlayerUpgrade){
	alpha = lerp(alpha,1,0.05);
	actual_x=lerp(actual_x,x,0.05);
	if (keyboard_check_pressed(ord("A"))) {
		selector_pos[0]-=1;
		if(selector_pos[0]<0){
			selector_pos[0]=3;
		}
	}
	if (keyboard_check_pressed(ord("D"))) {
		selector_pos[0]+=1;
		selector_pos[0]=selector_pos[0]%4
	}
	if (keyboard_check_pressed(ord("S"))) {
		selector_pos[1]+=1;
		selector_pos[1]=selector_pos[1]%2
	}
	if (keyboard_check_pressed(ord("W"))) {
		selector_pos[1]-=1;
		selector_pos[1]=selector_pos[1]%2
		if(selector_pos[1]<0){
			selector_pos[1]=1;
		}
	}
	if(keyboard_check_pressed(vk_enter)){
		if(menu_level==0){
			if(selector_pos[0]==0&&selector_pos[0]){
				menu_level=1;
			}
		}
	}
}else{
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,2500,0.05);
}