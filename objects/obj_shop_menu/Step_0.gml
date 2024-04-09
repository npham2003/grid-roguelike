
if(obj_battleControl.state==BattleState.PlayerUpgrade){
	alpha = lerp(alpha,1,0.05);
	actual_x=lerp(actual_x,x,0.05);
}else{
	alpha = lerp(alpha,0,0.05);
	actual_x=lerp(actual_x,2500,0.05);
}