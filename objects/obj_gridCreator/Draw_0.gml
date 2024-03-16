/// @description Insert description here
// You can write your code in this editor




for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		if(i<5){
			draw_sprite(spr_grid_player_side,0, x + (i*100), y + (j*50));
			if(obj_gridCreator.battle_grid[i][j]._move_highlight){
				draw_sprite(spr_grid_move_highlight,0, x + (i*100), y + (j*50));
			}
		}else{
			draw_sprite(spr_grid_enemy_side,0, x + (i*100), y + (j*50));
		}
	}
}


//var coordinates = get_coordinates(1,1);
//draw_sprite(fighter,0,coordinates[0],coordinates[1]);