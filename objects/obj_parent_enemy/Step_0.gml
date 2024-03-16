

//if (is_moving) {
//	for (var j = 0; j < moveSpeed; j++)
//	{
//		var i = irandom_range(0,4);
//		switch (i)
//		{
//			case (0):
//			break;
		
//			case(1): // move left
//				for (var i = 0; i < array_length(moveable_tiles); i++) {
//					if (x_pos > GRIDWIDTH/2 && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos-1][y_pos]) {
//					//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
//					x -= CELLWIDTH;
//					x_pos -= 1;
//					break;
//					}
//				}
//			break;
		
//			case(2): // move right
//				for (var i = 0; i < array_length(moveable_tiles); i++) {
//					if (x_pos < (GRIDWIDTH-1) && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos+1][y_pos]) {
//					//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
//					x += CELLWIDTH;
//					x_pos += 1;
//					break;
//					}
//				}
//			break;
		
//			case(3):
//				for (var i = 0; i < array_length(moveable_tiles); i++) {
//					if (y_pos < GRIDHEIGHT-1 && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos][y_pos+1]) {
//					//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
//					y -= CELLHEIGHT;
//					y_pos += 1;
//					break;
//					}
//				}
//			break;
		
//			case(4):
//				for (var i = 0; i < array_length(moveable_tiles); i++) {
//					if (y_pos > 0 && moveable_tiles[i] == obj_gridCreator.battle_grid[x_pos][y_pos-1]) {
//					//obj_gridCreator.battle_grid.move_entity(x_pos, y_pos, (x_pos-1), y_pos);
//					y += CELLHEIGHT; // eventually make it so that we move to the tile coord, not manually move
//					y_pos -= 1;
//					break;
//					}
//				}
//			break;
		
//			default:
//		}
//	}
//	is_moving = false;
//}