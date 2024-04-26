//options
if (obj_battleControlTut.teachingBasic == true) { // open menu once we can basic attack
for (var i = 0; i < skills; ++i) {
	
	if(obj_battleControlTut.state==BattleState.PlayerAiming){
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
}

expandAnim = lerp(expandAnim, state, 0.2);
tpCost=[0,player_unit.actions[0].cost[player_unit.upgrades[0]],player_unit.actions[1].cost[player_unit.upgrades[1]],player_unit.actions[2].cost[player_unit.upgrades[2]],player_unit.actions[3].cost[player_unit.upgrades[3]]];
}
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

//press enter opacity
if(_enter_opacity_increase){
	_enter_opacity+=0.01;
}else{
	_enter_opacity-=0.01;
}
if(_enter_opacity>=1){
	_enter_opacity_increase=false;
}
if(_enter_opacity<=0.5){
	_enter_opacity_increase=true;
}

//turn opacity
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

#region confirm opacity
if(confirm){
	confirmShiftX[0] = 850;
	confirmShiftX[1] = 1050;
	confirmShiftY = 660;
	

}else{
	confirmShiftX[0] = 800;
	confirmShiftX[1] = 1000;
	confirmShiftY = 700;
}

confirmY = lerp(confirmY, confirmShiftY, 0.2);
confirmX[0] = lerp(confirmX[0], confirmShiftX[0], 0.2);
confirmX[1] = lerp(confirmX[1], confirmShiftX[1], 0.2);

#endregion

#region ask end
if (ask_end){
	draw_rectangle_colour(0, 250, room_width, 450, global._aspect_bars, global._aspect_bars, global._aspect_bars, global._aspect_bars, false);
	draw_set_color(global._primary);
	draw_set_halign(fa_center);
	draw_text_transformed(650, 260, "You still have units with actions remaining.\nDo you want to end your turn now?\nConfirm: Space   Back: Tab", 0.8, 0.8, 0);
}
draw_set_halign(fa_left);
#endregion