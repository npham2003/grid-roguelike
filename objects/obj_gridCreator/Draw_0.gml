/// @description Insert description here
// You can write your code in this editor




for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		if(i<5){
			draw_sprite(spr_grid_player_side,0, x + (i*100), y + (j*50));
		}else{
			draw_sprite(spr_grid_enemy_side,0, x + (i*100), y + (j*50));
		}
		var coordinates = get_coordinates(i,j);
		var _tile = instance_create_layer(coordinates[0],coordinates[1],"Tiles",obj_tile_class);
		battle_grid[i][j]=_tile;
		
		battle_grid[i][j].set_coords(i,j);
	}
}


var coordinates = get_coordinates(1,1);
draw_sprite(fighter,0,coordinates[0],coordinates[1]);