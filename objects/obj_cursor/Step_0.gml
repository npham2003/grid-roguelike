position = obj_gridCreator.get_coordinates(current_x,current_y);
x = lerp(x, position[0]-CELLWIDTH/2, 0.4);
y = lerp(y, position[1]-CELLHEIGHT/2, 0.4);


if(obj_battleControl.state!=BattleState.EnemyAiming && obj_battleControl.state!=BattleState.EnemyTakingAction && obj_battleControl.state!=BattleState.PlayerUpgrade){

	if (keyboard_check_pressed(ord("A"))) {
		move_cursor(current_x-1,current_y);
	}
	if (keyboard_check_pressed(ord("D"))) {
		move_cursor(current_x+1,current_y);
	}
	if (keyboard_check_pressed(ord("S")) && current_y < obj_gridCreator.gridVert-1) {
		move_cursor(current_x,current_y+1);
	}
	if (keyboard_check_pressed(ord("W")) && current_y > 0) {
		move_cursor(current_x,current_y-1);
	}
}
	
