/// @description Insert description here
// You can write your code in this editor




for (var i = 0; i< gridHoriz;i++){
	for (var j = 0; j < gridVert;j++){
		if(i<5){
			draw_sprite(spr_grid_player_side,0, x + (i*100), y + (j*50));
			if(obj_gridCreator.battle_grid[i][j]._move_highlight){
				draw_sprite_ext(spr_grid_move_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, 0.7);
			}else if(obj_gridCreator.battle_grid[i][j]._move_cursor){
				draw_sprite_ext(spr_grid_move_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, 0.3);
			}
		}else{
			draw_sprite(spr_grid_enemy_side,0, x + (i*100), y + (j*50));
		}
		if(obj_gridCreator.battle_grid[i][j]._attack_highlight){
			draw_sprite_ext(spr_grid_attack_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, 0.5);
		}
		if(obj_gridCreator.battle_grid[i][j]._target_highlight){
			draw_sprite_ext(spr_grid_target_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, _target_transparency);
		}
		if(obj_gridCreator.battle_grid[i][j]._danger_cursor){
			draw_sprite_ext(spr_grid_target_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, _target_transparency);
		}
		if(obj_gridCreator.battle_grid[i][j]._danger_number>0){
			var highlight_color = merge_color(c_yellow, c_red, (obj_gridCreator.battle_grid[i][j]._danger_number-1)/4);
			draw_sprite_ext(spr_grid_danger_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, highlight_color, 1);
		}
		if(obj_gridCreator.battle_grid[i][j]._support_highlight){
			draw_sprite_ext(spr_grid_support_highlight, image_index, x + (i*100), y + (j*50), image_xscale, image_yscale, image_angle, image_blend, 0.5);
		}
		
	}
}

if(_more_visible){
	_target_transparency+=0.01;
}else{
	_target_transparency-=0.01;
}

if(_target_transparency>=0.8){
	_more_visible=false;
}
if(_target_transparency<=0.3){
	_more_visible=true;
}


//var coordinates = get_coordinates(1,1);
//draw_sprite(fighter,0,coordinates[0],coordinates[1]);