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

if(obj_battleControl.state==BattleState.PlayerWaitingAction){
	menuX[5] = lerp(menuX[5], rootX + 5 * spacing * 0 + 0 * 200, 0.05);
	waitAlpha = lerp(waitAlpha, 0, 0.05);
}
#endregion

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

#region back opacity
if(back){
	backShiftX[0] = 770;
	backShiftX[1] = 920;
	backShiftY = 660;
	

}else{
	backShiftX[0] = 720;
	backShiftX[1] = 870;
	backShiftY = 700;
}

backY = lerp(backY, backShiftY, 0.2);
backX[0] = lerp(backX[0], backShiftX[0], 0.2);
backX[1] = lerp(backX[1], backShiftX[1], 0.2);

#endregion

#region confirm opacity
if(confirm){
	confirmShiftX[0] = 920;
	confirmShiftX[1] = 1170;
	confirmShiftY = 660;
	

}else{
	confirmShiftX[0] = backShiftX[0];
	confirmShiftX[1] = backShiftX[1];
	confirmShiftY = backShiftY;
}

confirmY = lerp(confirmY, confirmShiftY, 0.2);
confirmX[0] = lerp(confirmX[0], confirmShiftX[0], 0.2);
confirmX[1] = lerp(confirmX[1], confirmShiftX[1], 0.2);

#endregion



player_marker=lerp(player_marker,room_width/2-progress_length/2+(progress_length/(battles_in_room-1)*(obj_battleControl.battle_progress%5)),0.1);
if(obj_battleControl.battle_progress%5==0){
	player_marker=room_width/2-progress_length/2;
}