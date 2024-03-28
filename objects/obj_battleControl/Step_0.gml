// Key press check
var key_A_pressed = keyboard_check_pressed(ord("A"));
var key_W_pressed = keyboard_check_pressed(ord("W"));
var key_S_pressed = keyboard_check_pressed(ord("S"));
var key_D_pressed = keyboard_check_pressed(ord("D"));
var key_J_pressed = keyboard_check_pressed(ord("J"));
var key_K_pressed = keyboard_check_pressed(ord("K"));
var key_L_pressed = keyboard_check_pressed(ord("L"));

var key_Enter_pressed = keyboard_check_pressed(vk_enter);
var key_Tab_pressed = keyboard_check_pressed(vk_tab);
var key_Space_pressed = keyboard_check_pressed(vk_space);

var wasd_pressed = key_A_pressed || key_W_pressed || key_S_pressed || key_D_pressed;
var jkl_pressed = key_J_pressed || key_K_pressed || key_L_pressed;

var enough_tp = false;


// Note that these routines are called each frame
switch (state) {
	
#region Battle Start
	case BattleState.BattleStart:
		change_state(BattleState.EnemyAiming);
		break;
#endregion
	
#region Enemy Aiming
	case BattleState.EnemyAiming:
		
		if (in_animation) {
			break;
		}
		
		var unit = enemy_units[enemy_order];
		unit.find_target();
		unit.aim();
		obj_info_panel.set_text(unit.name+" is aiming");
		if(!in_animation){
			enemy_order += 1;
			if (enemy_order >= array_length(enemy_units))
			{
				enemy_order = 0;
				change_state(BattleState.PlayerPreparing);
			}
		}
		
		
		break;
#endregion

#region Player Preparing
	case BattleState.PlayerPreparing:
		
		for (var i = 0; i < array_length(player_units); i++) {
			player_units[i].has_moved = false;
			player_units[i].has_attacked = false;
		}
		
		if (tp_current < tp_max) {
		tp_current++;	
		}	
		show_debug_message("CURRENT TP: " + string(tp_current));
		
		change_state(BattleState.PlayerWaitingAction);
	
		break;
#endregion

#region Player Waiting Action
	case BattleState.PlayerWaitingAction:
		// WASD to move, JKL to use skills, Tab to switch units, Enter to end player turn
		// If all units have attacked, end player's turn
		var unit = player_units[player_order];
		obj_info_panel.set_text("Space - Move Unit\nJ - "+unit.skill_names[0]+"\nK - "+unit.skill_names[1]+"\nL - "+unit.skill_names[2]+"\nEnter - End Turn");
		var has_all_attacked = true;
		for (var i = 0; i < array_length(player_units); i++) {
			if (!player_units[i].has_attacked) {
				has_all_attacked = false;
			}
		}
		if (has_all_attacked) {
			change_state(BattleState.EnemyTakingAction);
			break;
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
			}
				if (enough_tp) {
					unit.confirm_move();
					unit.skill_complete = false;
					enough_tp = false;
					change_state(BattleState.PlayerAiming);
				}
			}
		}
		else if (key_Tab_pressed) {
			player_order += 1;
			if (player_order >= array_length(player_units)) {
				player_order = 0;
			}
			show_debug_message("Switch to next player unit");
		}
		else if (key_Enter_pressed) {
			change_state(BattleState.EnemyTakingAction);
		}
		
		break;
#endregion

#region Player Moving
	case BattleState.PlayerMoving:
		var unit = player_units[player_order];
		
		obj_info_panel.set_text("WASD - Move\nJ - "+unit.skill_names[0]+"\nK - "+unit.skill_names[1]+"\nL - "+unit.skill_names[2]+"\nEnter - Do Nothing\nTab - Back");
		
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
		}

		break;
#endregion

#region Player Aiming
	case BattleState.PlayerAiming:
	
		var unit = player_units[player_order];
		if(unit.skill_back){
			show_debug_message("hi");
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
		
		
		//if (key_Enter_pressed) {
		//	show_debug_message(unit.name + ": confirm action");
		//	unit.has_attacked = true;
		//	change_state(BattleState.PlayerTakingAction);
		//}
		
		break;
#endregion

#region Player Taking Action
	case BattleState.PlayerTakingAction:
	
		var unit = player_units[player_order];
		
		show_debug_message(unit.name + ": taking action");
		
		
		
		var enemy_unit = enemy_units[enemy_order];
		if (enemy_unit.hp<=0){
			enemy_unit.despawn();
			instance_destroy(enemy_unit);
			array_delete(enemy_units, enemy_order, 1);
			enemy_order-=1;
			if(array_length(enemy_units)==0){
				change_state(BattleState.BattleEnd);
			}
		}
		
		enemy_order += 1;
		if (enemy_order >= array_length(enemy_units)) {
			enemy_order = 0;
			if (check_battle_end()) {
				change_state(BattleState.BattleEnd);
			}
			else {
				change_state(BattleState.PlayerWaitingAction);
			}
		}
		
		break;
#endregion

#region Enemy Taking Action
	case BattleState.EnemyTakingAction:
		
		var unit = enemy_units[enemy_order];
		if (unit.attack_ready) {
			unit.attack();
		}
		
		enemy_order += 1;
		if (enemy_order >= array_length(enemy_units)) {
			enemy_order = 0;
			
			obj_gridCreator.reset_highlights_enemy();
			
			change_state(BattleState.EnemyAiming);
		}
	
		break;
#endregion

};