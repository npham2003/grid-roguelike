// Key press check
var key_A_pressed = keyboard_check_pressed(ord("A"));
var key_W_pressed = keyboard_check_pressed(ord("W"));
var key_S_pressed = keyboard_check_pressed(ord("S"));
var key_D_pressed = keyboard_check_pressed(ord("D"));
var key_J_pressed = keyboard_check_pressed(ord("J"));
var key_K_pressed = keyboard_check_pressed(ord("K"));
var key_L_pressed = keyboard_check_pressed(ord("L"));
var key_H_pressed = keyboard_check_pressed(ord("H"));

var key_Enter_pressed = keyboard_check_pressed(vk_enter);
var key_Tab_pressed = keyboard_check_pressed(vk_tab);
var key_Space_pressed = keyboard_check_pressed(vk_space);

var wasd_pressed = key_A_pressed || key_W_pressed || key_S_pressed || key_D_pressed;
var jkl_pressed = key_J_pressed || key_K_pressed || key_L_pressed || key_H_pressed;

var enough_tp = false;

if (transition_count > 0) {
	transition_count--;
	return;
}

switch (state) {
	
#region Battle Start
	case BattleState.BattleStart:
		for (var i = 0; i < array_length(player_units); i++) {
			player_units[i].attack_bonus=0;
			if(player_units[i].hp<=0){
				player_units[i].hp=1;
			}
			if(i==0){
				obj_cursor.current_x=player_units[i].grid_pos[0];
				obj_cursor.current_y=player_units[i].grid_pos[1];
				//obj_cursor.current_x=0;
				//obj_cursor.current_y=0;
				
			}
		}
		//for (var i = 0; i < array_length(board_obstacles); i++) {
		//	board_obstacles[i].despawn();
		//	array_delete(board_obstacles,i,1);
		//	i-=1;
		//}
		for(i=0;i<array_length(board_obstacles);i++){
			board_obstacles[i].aim();
		}
		var random_battle = irandom(array_length(global.encounters)-1);
		//random_battle=3;
		spawn_enemies(global.encounters[random_battle]);
		//spawn_enemies(global.encounters[3]);
		
		obj_menu.enemyTurn = true;
		obj_menu.playerTurn = false;
		change_state(BattleState.EnemyAiming);
		break;
#endregion
	
#region Enemy Aiming
	case BattleState.EnemyAiming:
		obj_menu.playerState = false;
		obj_menu.enemyState = false;
		
		if (in_animation) {
			break;
		}else{
		
			if (enemy_order >= array_length(enemy_units))
			{
				enemy_order = 0;
				change_state(BattleState.PlayerPreparing);
				break;
			}
			show_debug_message(string(enemy_order));
			unit = enemy_units[enemy_order];
			if(unit.stall_turns>0){
				unit.stall_turns-=1;
				obj_battleEffect.show_damage(unit, unit.stall_turns, c_blue);
				if(unit.stall_turns<=0){
					unit.freeze_graphic.sprite_index=spr_freeze_out;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
					unit.freeze_graphic.image_speed=1;
				}
			}
			if(unit.stall_turns<0){
				unit.stall_turns=0;
			}
			if(unit.stall_turns==0){
				
				unit.find_target();
				unit.aim();
			}
			obj_menu.set_text(unit.name+" is aiming");
		
			enemy_order += 1;
		}
		break;
#endregion

#region Player Preparing
	case BattleState.PlayerPreparing:
		obj_menu.playerState = false;
		obj_menu.enemyState = false;
		
		for (var i = 0; i < array_length(player_units); i++) {
			show_debug_message(string(i)+" Buffed: "+string(player_units[i].attack_buff_recent));
			if(player_units[i].stall_turns==0){
				if(!player_units[i].attack_buff_recent){
					show_debug_message("reset attack bonus");
					player_units[i].attack_bonus_temp=0;
				}
				player_units[i].attack_buff_recent=false;
				
				if(!player_units[i].move_buff_recent){
					show_debug_message("reset move bonus");
					player_units[i].move_bonus_temp=0;
				}
				player_units[i].move_buff_recent=false;
			}
			if(player_units[i].stall_turns>0){
				player_units[i].stall_turns-=1;
				obj_battleEffect.show_damage(player_units[i], player_units[i].stall_turns, c_blue);
				if(player_units[i].stall_turns<=0){
					player_units[i].freeze_graphic.sprite_index=spr_freeze_out;
					player_units[i].freeze_graphic.image_speed=1;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
				}
			}
			if(player_units[i].stall_turns<0){
				player_units[i].stall_turns=0;
			}
			
			
			if(player_units[i].hp>0 && player_units[i].stall_turns==0){
				player_units[i].has_moved = false;
				player_units[i].has_attacked = false;
				tp_current+=player_units[i].tpGain;
			}else if(player_units[i].hp<0){
				player_units[i].hp=0;
			}
			
			
			
			
		}
		tp_current+=tp_bonus;
		if (tp_current > tp_max) {
		tp_current=tp_max;	
		}	
		show_debug_message("CURRENT TP: " + string(tp_current));
		
		change_state(BattleState.PlayerWaitingAction);
		obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
		obj_cursor.reset_cursor(player_units[0].grid_pos[0],player_units[0].grid_pos[1]);
	
		break;
#endregion

#region Player Waiting Action
	case BattleState.PlayerWaitingAction:
		
		// WASD to move, JKL to use skills, Tab to switch units, Enter to end player turn
		// If all units have attacked, end player's turn
		unit = obj_gridCreator.battle_grid[obj_cursor.current_x][obj_cursor.current_y]._entity_on_tile;
		
		obj_battleEffect.remove_push_preview();
		var has_all_attacked = true;
		
		if(check_battle_end()){
			change_state(BattleState.BattleEnd);
			break;
		}
		for (var i = 0; i < array_length(player_units); i++) {
			if (!player_units[i].has_attacked) {
				has_all_attacked = false;
			}
		}
		if (has_all_attacked) {
			board_obstacle_order = 0;
			change_state(BattleState.PlayerBoardObstacle);
			break;
		}
		
		if(unit!=pointer_null){
			if(unit.ally){
				obj_menu.open_menu();
				obj_menu.player_unit=unit;
				obj_menu.tpCost=[0,unit.actions[0].cost[unit.upgrades[0]],unit.actions[1].cost[unit.upgrades[1]],unit.actions[2].cost[unit.upgrades[2]],unit.actions[3].cost[unit.upgrades[3]]];
				//obj_menu.set_text("WASD - Move Cursor\nSpace - Select Unit\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - End Turn");
				obj_menu.set_text("WASD - Move Cursor     Space - Select Unit     Enter - End Turn");
				unit.prev_grid=[unit.grid_pos[0],unit.grid_pos[1]];
				if(!unit.has_moved && !unit.has_attacked){
					unit.preview_moveable_grids();
				}
				if (key_Space_pressed) {
					if (!unit.has_moved && !unit.has_attacked) {
						change_state(BattleState.PlayerMoving);
						obj_gridCreator.remove_entity(unit.grid_pos[0],unit.grid_pos[1]);
						unit.show_moveable_grids();
					}
				}
				else if (jkl_pressed) { // optimize eventually
					obj_gridCreator.reset_highlights_cursor();
					if (!unit.has_attacked) {
						if (key_H_pressed) {
							if (tp_current >= unit.actions[0].cost[unit.upgrades[0]]) {
								//obj_menu.set_select(1);
								unit.skill_used = 0;
								enough_tp = true;
							}
							else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
				
						}
						else if (key_J_pressed) {
							if (tp_current >= unit.actions[1].cost[unit.upgrades[1]]) {
								//obj_menu.set_select(2);
								unit.skill_used = 1;
								enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}
						else if (key_K_pressed) {
							if (tp_current >= unit.actions[2].cost[unit.upgrades[2]]) {
								//obj_menu.set_select(3);
								unit.skill_used = 2;
								enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}else if (key_L_pressed) {
							if (tp_current >= unit.actions[3].cost[unit.upgrades[3]]) {
								//obj_menu.set_select(4);
								unit.skill_used = 3;
								enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}
							if (enough_tp) {
								unit.skill_init = false;
								unit.skill_complete = false;
								enough_tp = false;
								change_state(BattleState.PlayerAiming);
								obj_gridCreator.reset_highlights_cursor();
							}
						}
				}
				else if (key_Tab_pressed) {
					for(i = 1;i<array_length(unit.upgrades);i++){
						unit.upgrades[i]+=1;
						unit.upgrades[i]=unit.upgrades[i]%3;
					}
				}
				
			}else{
				obj_menu.close_menu();
				if(unit.stall_turns==0){
					unit.display_target_highlights();
				}
			}
		}else{
			obj_menu.close_menu();
		}
		if(key_Enter_pressed){
			board_obstacle_order = 0;
			for (var i = 0; i < array_length(player_units); i++) {
				if(!(player_units[i].has_attacked || player_units[i].has_moved)){
					player_units[i].attack_bonus_temp=0;
					
				}
			}
			change_state(BattleState.PlayerBoardObstacle);
		}
		break;
#endregion

#region Player Moving
	case BattleState.PlayerMoving:
		
		if(unit!=pointer_null){
			//obj_menu.set_text("WASD - Move\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - Do Nothing\nTab - Back");
			obj_menu.set_text("WASD - Move     Enter - Do Nothing     Tab - Back");
			
		
			if (wasd_pressed) {
				//show_debug_message(unit.name + ": moving");
				if (key_W_pressed) {
					unit.move_up();
				}
				if (key_A_pressed) {
					unit.move_left();
				}
				if (key_S_pressed) {
					unit.move_down();
				}
				if (key_D_pressed) {
					unit.move_right();
				}
			
				show_debug_message("Move to ({0},{1})", unit.grid_pos[0], unit.grid_pos[1]);
			}
			else if (key_Tab_pressed){
					obj_menu.select = 0;
					unit.back_move();
					change_state(BattleState.PlayerWaitingAction);
					obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
					obj_cursor.reset_cursor(unit.grid_pos[0], unit.grid_pos[1]);
				}
			else if (jkl_pressed && obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._is_empty) { // optimize eventually
				
				obj_gridCreator.reset_highlights_cursor();
				if (!unit.has_attacked) {
					if (key_H_pressed) {
						if (tp_current >= unit.actions[0].cost[unit.upgrades[0]]) {
							unit.skill_used = 0;
							enough_tp = true;
						}
						else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				
				}
				else if (key_J_pressed) {
					if (tp_current >= unit.actions[1].cost[unit.upgrades[1]]) {
					unit.skill_used = 1;
					enough_tp = true;
					}
					else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				}
				else if (key_K_pressed) {
					if (tp_current >= unit.actions[2].cost[unit.upgrades[2]]) {
					unit.skill_used = 2;
					enough_tp = true;
					}
					else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				}
				else if (key_L_pressed) {
					if (tp_current >= unit.actions[3].cost[unit.upgrades[3]]) {
					unit.skill_used = 3;
					enough_tp = true;
					}else {
						audio_play_sound(sfx_no_tp, 0, false);
					}
			}
			
				if (enough_tp) {
					unit.confirm_move();
					unit.skill_init = false;
					unit.skill_complete = false;
					enough_tp = false;
					change_state(BattleState.PlayerAiming);
				}
					
				}
			}
			else if (key_Enter_pressed && obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._is_empty) {
				unit.confirm_move();
				unit.has_moved = true;
				unit.has_attacked = true;
				change_state(BattleState.PlayerWaitingAction);
				
				
				obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
			}
		}
		break;
#endregion

#region Player Aiming
	case BattleState.PlayerAiming:
	
		
		if(unit.skill_back){
			
			change_state(BattleState.PlayerMoving);
			unit.show_moveable_grids_prev();
			unit.has_attacked = false;
			unit.skill_back = false;
			unit.back_aim();
			
			
		}else{
			
			obj_menu.set_text("WASD - Aim     Enter - Confirm     Tab - Back\n"+""+string(unit.actions[unit.skill_used].name[unit.upgrades[unit.skill_used]])+"\n"+string(unit.actions[unit.skill_used].description[unit.upgrades[unit.skill_used]]));
			if (unit.skill_complete) {
				tp_current -= unit.actions[unit.skill_used].cost[unit.upgrades[unit.skill_used]];
				unit.has_attacked = true;
				
				change_state(BattleState.PlayerTakingAction);
			}
			switch(unit.upgrades[unit.skill_used]){
				case 0:
					
					unit.actions[unit.skill_used].skillFunctions.base(unit);
					
					break;
				case 1:
					unit.actions[unit.skill_used].skillFunctions.upgrade1(unit);
					
					break;
				
				case 2:
					unit.actions[unit.skill_used].skillFunctions.upgrade2(unit);
					
					break;
				}
		}
		enough_tp=false;
					if (!unit.has_attacked) {
						if (key_H_pressed&&unit.skill_used!=0) {
							obj_gridCreator.reset_highlights_cursor();
							obj_gridCreator.reset_highlights_attack();
							obj_gridCreator.reset_highlights_target();
							obj_gridCreator.reset_highlights_support();
							if (tp_current >= unit.actions[0].cost[unit.upgrades[0]]) {
								unit.skill_used = 0;
								enough_tp = true;
							}
							else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
				
						}
						else if (key_J_pressed&&unit.skill_used!=1) {
							obj_gridCreator.reset_highlights_cursor();
							obj_gridCreator.reset_highlights_attack();
							obj_gridCreator.reset_highlights_target();
							obj_gridCreator.reset_highlights_support();
							if (tp_current >= unit.actions[1].cost[unit.upgrades[1]]) {
							unit.skill_used = 1;
							enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}
						else if (key_K_pressed&&unit.skill_used!=2) {
							obj_gridCreator.reset_highlights_cursor();
							obj_gridCreator.reset_highlights_attack();
							obj_gridCreator.reset_highlights_target();
							obj_gridCreator.reset_highlights_support();
							if (tp_current >= unit.actions[2].cost[unit.upgrades[2]]) {
							unit.skill_used = 2;
							enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}else if (key_L_pressed&&unit.skill_used!=3) {
							obj_gridCreator.reset_highlights_cursor();
							obj_gridCreator.reset_highlights_attack();
							obj_gridCreator.reset_highlights_target();
							obj_gridCreator.reset_highlights_support();
							if (tp_current >= unit.actions[3].cost[unit.upgrades[3]]) {
							unit.skill_used = 3;
							enough_tp = true;
							}
							else {
									audio_play_sound(sfx_no_tp, 0, false);
								}
						}
							if (enough_tp) {
								unit.skill_init= false;
								unit.skill_complete = false;
								enough_tp = false;
								
								change_state(BattleState.PlayerAiming);
								obj_gridCreator.reset_highlights_cursor();
								obj_battleEffect.remove_push_preview();
							}
						}
				
		
		
		
		
		//if (key_Enter_pressed) {
		//	show_debug_message(unit.name + ": confirm action");
		//	unit.has_attacked = true;
		//	change_state(BattleState.PlayerTakingAction);
		//}
		
		break;
#endregion

#region Player Taking Action
	case BattleState.PlayerTakingAction:
	
		
		
		show_debug_message(unit.name + ": taking action");
		
		
		obj_gridCreator.reset_highlights_cursor();
		obj_gridCreator.reset_highlights_attack();
		obj_gridCreator.reset_highlights_target();
		obj_gridCreator.reset_highlights_support();
		obj_battleEffect.remove_push_preview();
		var enemy_unit = enemy_units[enemy_check_death];
		if (enemy_unit.hp<=0){
			enemy_unit.despawn();
			
			array_delete(enemy_units, enemy_check_death, 1);
			enemy_check_death-=1;
		}
		
		enemy_check_death += 1;
		
		if (enemy_check_death >= array_length(enemy_units)) {
			enemy_check_death = 0;
			if (check_battle_end()) {
				unit.is_attacking = false;
				change_state(BattleState.BattleEnd);
			}
			else {
				change_state(BattleState.PlayerWaitingAction);
				
				unit.is_attacking = false;
				obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
			}
		}
		
		break;
#endregion

#region Enemy Taking Action
	case BattleState.EnemyTakingAction:
		obj_menu.playerState = false;
		obj_menu.enemyState = true;
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		if(!checking_death){
			if (enemy_order >= array_length(enemy_units)) {
				enemy_order = 0;
				
				if (check_battle_end()) {
					change_state(BattleState.BattleEnd);
				}else{
					
					change_state(BattleState.EnemyBoardObstacle);
				}
				break;
			}
			
			unit = enemy_units[enemy_order];
			if (unit.attack_ready && unit.stall_turns==0) {
				unit.attack();
			}
			
			checking_death=true;
		}else{
			var enemy_unit = enemy_units[enemy_check_death];
			if (enemy_unit.hp<=0){
				enemy_unit.despawn();
			
				array_delete(enemy_units, enemy_check_death, 1);
				enemy_check_death-=1;
			}
		
			enemy_check_death += 1;
			if (enemy_check_death >= array_length(enemy_units)) {
				enemy_check_death = 0;
				enemy_order+=1;
				checking_death=false;
			}
		}
		
		break;
#endregion

#region Battle End
	case BattleState.BattleEnd:
		tp_bonus=0;
		if(in_animation){
			break;
		}
		if(array_length(enemy_units)==0){
			gold+=battle_gold;
			obj_gridCreator.reset_highlights_enemy();
			change_state(BattleState.PlayerUpgrade);
		}else{
			if(keyboard_check_pressed(vk_anykey)){
				obj_gridCreator.reset_highlights_cursor();
				obj_menu.set_text("Press any key to restart");
				room_restart();
			}
			
		}
		break;
#endregion

#region
	case BattleState.PlayerUpgrade:
		if (key_Tab_pressed) {
			change_state(BattleState.BattleStart);
			
		}
		break;
#endregion

#region
	case BattleState.PlayerBoardObstacle:
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		if(!checking_death){
			if (board_obstacle_order >= array_length(board_obstacles)) {
				board_obstacle_order = 0;
				change_state(BattleState.EnemyTakingAction);
				break;
			}
		
			obstacle = board_obstacles[board_obstacle_order];
			if(obstacle.stall_turns==0){
				obstacle.attack(true);
				obstacle.aim();
			}
			checking_death=true;
		}else{
			if (enemy_check_death >= array_length(enemy_units)) {
				enemy_check_death = 0;
				board_obstacle_order+=1;
				checking_death=false;
				break;
			}
			var enemy_unit = enemy_units[enemy_check_death];
			if (enemy_unit.hp<=0){
				enemy_unit.despawn();
			
				array_delete(enemy_units, enemy_check_death, 1);
				enemy_check_death-=1;
			}
		
			enemy_check_death += 1;
			
		}
		break;
#endregion

#region
	case BattleState.EnemyBoardObstacle:
		obj_menu.playerState = false;
		obj_menu.enemyState = false;
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		if(!checking_death){
			if (board_obstacle_order >= array_length(board_obstacles)) {
				board_obstacle_order = 0;
				obj_gridCreator.reset_highlights_enemy();
				for(i=0;i<array_length(board_obstacles);i++){
					board_obstacles[i].aim();
				}
				change_state(BattleState.EnemyAiming);
				break;
			}
		
			obstacle = board_obstacles[board_obstacle_order];
			if(obstacle.stall_turns==0){
				obstacle.attack(false);
				obstacle.aim();
				obstacle.turns_remaining-=1;
			}else{
				obstacle.stall_turns-=1;
				obj_battleEffect.show_damage(obstacle, obstacle.stall_turns, c_blue);
				if(obstacle.stall_turns==0){
					
					obstacle.freeze_graphic.sprite_index=spr_freeze_out;
					obstacle.freeze_graphic.image_speed=1;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
			
				}
			}
			
			if(obstacle.turns_remaining<=0){
				obstacle.despawn();
			
				array_delete(board_obstacles, board_obstacle_order, 1);
				board_obstacle_order-=1;
			}
		
			checking_death=true;
		}else{
			if (enemy_check_death >= array_length(enemy_units)) {
				enemy_check_death = 0;
				board_obstacle_order+=1;
				checking_death=false;
				break;
			}
			var enemy_unit = enemy_units[enemy_check_death];
			if (enemy_unit.hp<=0){
				enemy_unit.despawn();
			
				array_delete(enemy_units, enemy_check_death, 1);
				enemy_check_death-=1;
			}
		
			enemy_check_death += 1;
			
		}
		break;
#endregion

};