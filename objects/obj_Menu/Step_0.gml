//options
for (var i = 0; i < skills; ++i) {
	
	if(obj_battleControl.state==BattleState.PlayerAiming){
		if(i==player_unit.skill_used){
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200 - 50, 0.2);
		}else if(i==player_unit.skill_used+1){
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200 + 50, 0.2);
		}else{
			menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200, 0.2);
		}
	}else{
		menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200, 0.2);
	}
	optionAlpha = lerp(optionAlpha, state, 0.1);
}

expandAnim = lerp(expandAnim, state, 0.2);
tpCost=[0,player_unit.actions[0].cost[player_unit.upgrades[0]],player_unit.actions[1].cost[player_unit.upgrades[1]],player_unit.actions[2].cost[player_unit.upgrades[2]],player_unit.actions[3].cost[player_unit.upgrades[3]]];

//portrait opacity
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


//tp opacity
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


//if (select == 0) {
//	select_anim = lerp(select_anim, 0, 0.2);
//}