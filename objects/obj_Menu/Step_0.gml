#region options
for (var i = 0; i < skills; ++i) {
	
	if(obj_battleControl.state==BattleState.PlayerAiming){
		if(i==player_unit.skill_used){
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200 - select_shift, 0.2);
			
		}else if(i==player_unit.skill_used+1){
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200 + select_shift, 0.2);
		}else{
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200, 0.2);
		}
	}else{
		menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200, 0.2);
	}
	optionAlpha = lerp(optionAlpha, state, 0.1);
	if(skills==6){
		waitAlpha = lerp(waitAlpha, state, 0.1);
	}
}

expandAnim = lerp(expandAnim, state, 0.2);
tpCost=[0,player_unit.actions[0].cost[player_unit.upgrades[0]],player_unit.actions[1].cost[player_unit.upgrades[1]],player_unit.actions[2].cost[player_unit.upgrades[2]],player_unit.actions[3].cost[player_unit.upgrades[3]],0,0];
skill_names=["",player_unit.actions[0].name[player_unit.upgrades[0]],player_unit.actions[1].name[player_unit.upgrades[1]],player_unit.actions[2].name[player_unit.upgrades[2]],player_unit.actions[3].name[player_unit.upgrades[3]],player_unit.actions[4].name[player_unit.upgrades[4]],""];

if(obj_battleControl.state==BattleState.PlayerWaitingAction||obj_battleControl.state==BattleState.EnemyTakingAction||obj_battleControl.state==BattleState.PlayerUpgrade||obj_battleControl.state==BattleState.BattleEnd){
	menuX[5] = lerp(menuX[5], rootX + 5 * spacing * 0 + 0 * 200, 0.05);
	waitAlpha = lerp(waitAlpha, 0, 0.05);
}
#endregion

player_marker=lerp(player_marker,room_width/2-progress_length/2+(progress_length/(battles_in_room-1)*(obj_battleControl.battle_progress%5)),0.1);
if(obj_battleControl.battle_progress%5==0){
	player_marker=room_width/2-progress_length/2;
}

#region portrait opacity
if(open){
	state = 1;
	if(portraitAlpha<1){
		portraitAlpha+=0.1;
	}
}else{
	state = 0;
	if(portraitAlpha>0){
		portraitAlpha-=0.1;
	}
}
#endregion

#region tp opacity
if(tp_opacity_increase){
	tp_opacity+=0.01;
}else{
	tp_opacity-=0.01;
}
if(tp_opacity>=1){
	tp_opacity_increase=false;
}
if(tp_opacity<=0.5){
	tp_opacity_increase=true;
}
#endregion

#region hp opacity
if(hp_opacity_increase){
	hp_opacity+=0.01;
}else{
	hp_opacity-=0.01;
}
if(hp_opacity>=1){
	hp_opacity_increase=false;
}
if(hp_opacity<=0.5){
	hp_opacity_increase=true;
}
#endregion

#region turn opacity
if (turn_count <= turn_max) {
	if(turn_opacity_increase){
		turn_opacity+=0.05;
	}else{
		turn_opacity-=0.05;
	}
	if(turn_opacity>=0.8){
		turn_opacity_increase=false;
		turn_count++;
	}
	if(turn_opacity<=0.5){
		turn_opacity_increase=true;
	}
}

turn_text_anim = lerp(turn_text_anim, 2, 0.2)
#endregion

#region confirm location
if(confirm){
	confirmShiftX[0] = 920;
	confirmShiftX[1] = 1170;
	confirmShiftY = 660;
	

}else{
	confirmShiftX[0] = 870;
	confirmShiftX[1] = 1020;
	confirmShiftY = 660;
}

confirmY = lerp(confirmY, confirmShiftY, 0.2);
confirmX[0] = lerp(confirmX[0], confirmShiftX[0], 0.2);
confirmX[1] = lerp(confirmX[1], confirmShiftX[1], 0.2);

#endregion

#region back
if(back){
	backShift = 820;
	

}else{
	backShift=700;
}

backX = lerp(backX, backShift, 0.2);

#endregion

#region win lose anim
if (win > 0) {
	//show_debug_message("win: " + string(win));
	if (win == 2) grayscaleAlpha = 1;
	
	lineXShift = 0;
	//show_debug_message("lineX: " + string(lineX));
	
	if (lineX == 0) {
		lineYLShift = 0;
		lineYRShift = room_height;
		//show_debug_message("lineY: " + string(lineYL) + ", " + string(lineYR));
	}
	
	if (lineYR == room_height) winlose_anim_complete = true;
	else winlose_anim_complete = false;
	//show_debug_message(string(winlose_anim_complete));
}
else grayscaleAlpha = 0;

grayscale_params.g_Intensity = lerp(grayscale_params.g_Intensity, grayscaleAlpha, 0.5);
lineX = lerp(lineX, lineXShift, 0.2);
lineYL = lerp(lineYL, lineYLShift, 0.2);
lineYR = lerp(lineYR, lineYRShift, 0.2);

//show_debug_message(grayscale_params.g_Intensity);
#endregion