position = obj_gridCreator.get_coordinates(current_x,current_y);
x = lerp(x, position[0]-CELLWIDTH/2, 0.4);
y = lerp(y, position[1]-CELLHEIGHT/2, 0.4);


if(battlecontrol.state!=BattleState.EnemyAiming && battlecontrol.state!=BattleState.EnemyTakingAction && battlecontrol.state!=BattleState.PlayerUpgrade){

	if (input_check_pressed("left")) {
		move_cursor(current_x-1,current_y);
	}
	if (input_check_pressed("right")) {
		move_cursor(current_x+1,current_y);
	}
	if (input_check_pressed("down") && current_y < obj_gridCreator.gridVert-1) {
		move_cursor(current_x,current_y+1);
	}
	if (input_check_pressed("up") && current_y > 0) {
		move_cursor(current_x,current_y-1);
	}
}
	
