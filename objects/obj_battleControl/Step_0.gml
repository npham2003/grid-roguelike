// Key press check
var key_A_pressed = keyboard_check_pressed(ord("A"));
var key_W_pressed = keyboard_check_pressed(ord("W"));
var key_S_pressed = keyboard_check_pressed(ord("S"));
var key_D_pressed = keyboard_check_pressed(ord("D"));
var key_J_pressed = keyboard_check_pressed(ord("J"));
var key_K_pressed = keyboard_check_pressed(ord("K"));
var key_L_pressed = keyboard_check_pressed(ord("L"));
var key_semi_pressed = keyboard_check_pressed(186);

var key_Enter_pressed = keyboard_check_pressed(vk_enter);
var key_Tab_pressed = keyboard_check_pressed(vk_tab);
var key_Space_pressed = keyboard_check_pressed(vk_space);

var wasd_pressed = key_A_pressed || key_W_pressed || key_S_pressed || key_D_pressed;
var jkl_pressed = key_J_pressed || key_K_pressed || key_L_pressed || key_semi_pressed;

var enough_tp = false;


// Note that these routines are called each frame
switch (state) {
	
#region Battle Start
	case BattleState.BattleStart:
		for (var i = 0; i < array_length(player_units); i++) {
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
		var random_battle = irandom(array_length(global.encounters)-1);
		spawn_enemies(global.encounters[random_battle]);
		change_state(BattleState.EnemyAiming);
		break;
#endregion
	
#region Enemy Aiming
	case BattleState.EnemyAiming:
		
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
			unit.find_target();
			unit.aim();
			obj_info_panel.set_text(unit.name+" is aiming");
		
			enemy_order += 1;
		}
		break;
#endregion

#region Player Preparing
	case BattleState.PlayerPreparing:
		
		for (var i = 0; i < array_length(player_units); i++) {
			if(player_units[i].hp>0){
				player_units[i].has_moved = false;
				player_units[i].has_attacked = false;
				tp_current+=player_units[i].tpGain;
			}else{
				player_units[i].hp=0;
			}
			
		}
		
		if (tp_current > tp_max) {
		tp_current=tp_max;	
		}	
		show_debug_message("CURRENT TP: " + string(tp_current));
		
		change_state(BattleState.PlayerWaitingAction);
		obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
	
		break;
#endregion

#region Player Waiting Action
	case BattleState.PlayerWaitingAction:
		
		// WASD to move, JKL to use skills, Tab to switch units, Enter to end player turn
		// If all units have attacked, end player's turn
		unit = obj_gridCreator.battle_grid[obj_cursor.current_x][obj_cursor.current_y]._entity_on_tile;
		
		
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
			change_state(BattleState.EnemyTakingAction);
			break;
		}
		
		if(unit!=pointer_null){
			if(unit.ally){
				//obj_info_panel.set_text("WASD - Move Cursor\nSpace - Select Unit\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - End Turn");
				obj_info_panel.set_text("WASD - Move Cursor     Space - Select Unit     Enter - End Turn");
				unit.prev_grid = [unit.grid_pos[0], unit.grid_pos[1]];
				if(!unit.has_moved && !unit.has_attacked){
					unit.preview_moveable_grids();
				}
				if (key_Space_pressed) {
					if (!unit.has_moved && !unit.has_attacked) {
						change_state(BattleState.PlayerMoving);
						unit.show_moveable_grids();
					}
				}
				else if (jkl_pressed) { // optimize eventually
					if (!unit.has_attacked) {
						if (key_J_pressed) {
							if (tp_current >= unit.actions[0].cost) {
								unit.skill_used = 0;
								enough_tp = true;
							}
							else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
				
					}
					else if (key_K_pressed) {
						if (tp_current >= unit.actions[1].cost) {
						unit.skill_used = 1;
						enough_tp = true;
						}
						else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
					}
					else if (key_L_pressed) {
						if (tp_current >= unit.actions[2].cost) {
						unit.skill_used = 2;
						enough_tp = true;
						}
						else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
					}else if (key_semi_pressed) {
						if (tp_current >= unit.actions[3].cost) {
						unit.skill_used = 3;
						enough_tp = true;
						}
						else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
					}
						if (enough_tp) {
							
							unit.skill_complete = false;
							enough_tp = false;
							change_state(BattleState.PlayerAiming);
							obj_gridCreator.reset_highlights_cursor();
						}
					}
				}
				else if (key_Tab_pressed) {
					//player_order += 1;
					//if (player_order >= array_length(player_units)) {
					//	player_order = 0;
					//}
					//show_debug_message("Switch to next player unit");
				}
				
			}else{
				
				unit.display_target_highlights();
			}
		}
		if(key_Enter_pressed){
			change_state(BattleState.EnemyTakingAction);
		}
		break;
#endregion

#region Player Moving
	case BattleState.PlayerMoving:
		
		if(unit!=pointer_null){
			//obj_info_panel.set_text("WASD - Move\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - Do Nothing\nTab - Back");
			obj_info_panel.set_text("WASD - Move     Enter - Do Nothing     Tab - Back");
			
		
			if (wasd_pressed) {
				//show_debug_message(unit.name + ": moving");
				if (key_W_pressed) {
					unit.move_up();
				}
				else if (key_A_pressed) {
					unit.move_left();
				}
				else if (key_S_pressed) {
					unit.move_down();
				}
				else if (key_D_pressed) {
					unit.move_right();
				}
			
				show_debug_message("Move to ({0},{1})", unit.grid_pos[0], unit.grid_pos[1]);
			}
			else if (key_Tab_pressed){
					unit.back_move();
					change_state(BattleState.PlayerWaitingAction);
					obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
					obj_cursor.reset_cursor(unit.grid_pos[0], unit.grid_pos[1]);
				}
			else if (jkl_pressed) { // optimize eventually
				if (!unit.has_attacked) {
					if (key_J_pressed) {
						if (tp_current >= unit.actions[0].cost) {
							unit.skill_used = 0;
							enough_tp = true;
						}
						else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				
				}
				else if (key_K_pressed) {
					if (tp_current >= unit.actions[1].cost) {
					unit.skill_used = 1;
					enough_tp = true;
					}
					else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				}
				else if (key_L_pressed) {
					if (tp_current >= unit.actions[2].cost) {
					unit.skill_used = 2;
					enough_tp = true;
					}
					else {
							audio_play_sound(sfx_no_tp, 0, false);
						}
				}
				else if (key_semi_pressed) {
					if (tp_current >= unit.actions[3].cost) {
					unit.skill_used = 3;
					enough_tp = true;
					}
			}
			else if (key_semi_pressed) {
				if (tp_current >= unit.actions[3].cost) {
				unit.skill_used = 3;
				enough_tp = true;
				}
				else {
						audio_play_sound(sfx_no_tp, 0, false);
					}
			}
				if (enough_tp) {
					unit.confirm_move();
					unit.skill_complete = false;
					enough_tp = false;
					change_state(BattleState.PlayerAiming);
				}
					if (enough_tp) {
						unit.confirm_move();
						unit.skill_complete = false;
						enough_tp = false;
						change_state(BattleState.PlayerAiming);
					}
				}
			}
			else if (key_Enter_pressed) {
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
			
		}else if (unit.skill_used == 0) {
			unit.baseattack();
			if (unit.skill_complete) {
				tp_current -= unit.actions[0].cost;
				unit.has_attacked = true;
				unit.skill_complete = false;
				change_state(BattleState.PlayerTakingAction);
			}
		}
		else if (unit.skill_used == 1) {
			unit.skill1();
			if (unit.skill_complete) {
				tp_current -= unit.actions[1].cost;
				unit.has_attacked = true;
				unit.skill_complete = false;
				change_state(BattleState.PlayerTakingAction);
			}
		}
		else if (unit.skill_used == 2) {
			unit.skill2();
			if (unit.skill_complete) {
				tp_current -= unit.actions[2].cost;
				unit.has_attacked = true;
				unit.skill_complete = false;
				change_state(BattleState.PlayerTakingAction);
			}
		}
		else if (unit.skill_used == 3) {
			unit.skill3();
			if (unit.skill_complete) {
				tp_current -= unit.actions[3].cost;
				unit.has_attacked = true;
				unit.skill_complete = false;
				change_state(BattleState.PlayerTakingAction);
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
				change_state(BattleState.BattleEnd);
			}
			else {
				change_state(BattleState.PlayerWaitingAction);
				obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
			}
		}
		
		break;
#endregion

#region Enemy Taking Action
	case BattleState.EnemyTakingAction:
		
		if (in_animation) {
			break;
		}
		
		
		if(!checking_death){
			if (enemy_order >= array_length(enemy_units)) {
				enemy_order = 0;
				obj_gridCreator.reset_highlights_enemy();
				if (check_battle_end()) {
					change_state(BattleState.BattleEnd);
				}else{
					change_state(BattleState.EnemyAiming);
				}
				break;
			}
		
			unit = enemy_units[enemy_order];
			if (unit.attack_ready) {
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
		if(in_animation){
			break;
		}
		if(array_length(enemy_units)==0){
			gold+=battle_gold;
			obj_gridCreator.reset_highlights_enemy();
			change_state(BattleState.BattleStart);
		}else{
			if(keyboard_check_pressed(vk_anykey)){
				obj_gridCreator.reset_highlights_cursor();
				obj_info_panel.set_text("Press any key to restart");
				room_restart();
			}
			
		}
		break;
#endregion

};