if (colorSwitch) { //enemy
	//layer_background_blend(background, global._enemyTurnMiddle);
	////draw_sprite_ext(gradient, 0, 0, 128, 22, 9, 0, global._enemyTurnTop, 1);
	//draw_sprite_ext(gradient, 0, 0, 128, 22, 5, 0, global._enemyTurnBottom, 1);
	layer_background_blend(background, c_red);
	draw_sprite_ext(enemy_bg, 0, 0, 160, 0.64, 0.27, 0, c_white, 1);
}
else { //player
	//layer_background_blend(background, global._playerTurnMiddle);
	////draw_sprite_ext(gradient, 0, 0, 128, 22, 9, 180, global._playerTurnTop, 1);
	//draw_sprite_ext(gradient, 0, 0, 128, 22, 5, 0, global._playerTurnBottom, 1);
	layer_background_blend(background, global._characterPrimary);
	draw_sprite_ext(player_bg, 0, 0, 160, 0.64, 0.27, 0, c_white, 1);
}


#region draw grid
#endregion

//draw bars
draw_sprite_ext(aspectBar, 0, 0, 0, 22, 2.5, 0, c_white, 1);
draw_sprite_ext(aspectBar, 0, 0, 600, 22, 3, 0, c_white, 1);