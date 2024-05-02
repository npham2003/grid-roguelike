// Key press check
var key_A_pressed = keyboard_check_pressed(ord("A"));
var key_W_pressed = keyboard_check_pressed(ord("W"));
var key_S_pressed = keyboard_check_pressed(ord("S"));
var key_D_pressed = keyboard_check_pressed(ord("D"));
var key_J_pressed = keyboard_check_pressed(ord("J"));
var key_K_pressed = keyboard_check_pressed(ord("K"));
var key_L_pressed = keyboard_check_pressed(ord("L"));
var key_H_pressed = keyboard_check_pressed(ord("H"));
var key_Y_pressed = keyboard_check_pressed(ord("Y"));

var key_Enter_pressed = keyboard_check_pressed(vk_enter);
var key_Tab_pressed = keyboard_check_pressed(vk_tab);
var key_Space_pressed = keyboard_check_pressed(vk_space);

var wasd_pressed = key_A_pressed || key_W_pressed || key_S_pressed || key_D_pressed;
var jkl_pressed = key_J_pressed || key_K_pressed || key_L_pressed || key_H_pressed || key_Enter_pressed || key_Y_pressed;

var enough_tp = false;
 


if (transition_count > 0) {
	transition_count-=1;
	return;
}

if (transition_count < 0) {
	
	return;
}



switch (state) {
	
#region Battle Start
	case BattleState.BattleStart:

		obj_menu.win = 0;
		obj_gridCreator.transition_in=true;
		
		if(battle_progress%5==0){
			
			audio_stop_sound(current_music);
			music_track = global.floor_music[floor(battle_progress/5)][irandom_range(0,array_length(global.floor_music[floor(battle_progress/5)])-1)];
			//music_track = global.floor_music[2][0];

			current_music = audio_play_sound(music_track, 0, true, 0.5);
			
		}
		for (var i = 0; i < array_length(player_units); i++) {
			
			
				
		// removes attack buff if 2nd turn
				
			show_debug_message("reset attack bonus");
			player_units[i].attack_bonus_temp=0;
				
			player_units[i].attack_buff_recent=false;
			player_units[i].shield=0;
				
			
				
		// removes move buff if 2nd turn
				
			show_debug_message("reset move bonus");
			player_units[i].move_bonus_temp=0;
				
			player_units[i].move_buff_recent=false;
			player_units[i].has_moved = false;
			player_units[i].has_attacked = false;
			
		}
		obj_menu.set_turn_banner(false);
		obj_draw_bg.colorSwitch = true;
		
		
		obj_cursor.current_x=player_units[0].grid_pos[0];
		obj_cursor.current_y=player_units[0].grid_pos[1];
		//for (var i = 0; i < array_length(board_obstacles); i++) {
		//	board_obstacles[i].despawn();
		//	array_delete(board_obstacles,i,1);
		//	i-=1;
		//}
		
		// sets up aim for board obstacles
		for(i=0;i<array_length(board_obstacles);i++){
			board_obstacles[i].aim();
		}
		// chooses a random encounter. set to a value for debugging
		//var random_battle = irandom(array_length(global.encounters)-1);
		//random_battle=4;
		//battle_progress=11;
		random_battle=battle_progress;
		spawn_enemies(global.encounters[random_battle]);
		//spawn_enemies(global.encounters[3]);
		
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
			
			// if the enemy is frozen
			if(unit.stall_turns>0){
				unit.stall_turns-=1;
				obj_battleEffect.show_damage(unit, unit.stall_turns, c_blue);
				// finishing frozen turns
				if(unit.stall_turns<=0){
					unit.freeze_graphic.sprite_index=spr_freeze_out;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
					unit.freeze_graphic.image_speed=1;
					unit.freeze_graphic=pointer_null;
				}
			}
			
			// error handling. might be unnecessary
			if(unit.stall_turns<0){
				unit.stall_turns=0;
			}
			
			// enemy aims
			if(unit.stall_turns==0){
				
				unit.find_target();
				unit.aim();
				for(i=0;i<enemy_order;i++){
						enemy_units[i].recalc_los();
						in_animation=true;
					}
				
			}
			//obj_menu.set_text(unit.name+" is aiming");
			
			// next enemy
			enemy_order += 1;
		}
		
		//obj_draw_bg.colorSwitch = false;
		
		break;
#endregion

#region Player Preparing
	case BattleState.PlayerPreparing:
		obj_draw_bg.colorSwitch = false;
		turn_count+=1;
		for (var i = 0; i < array_length(player_units); i++) {
			
			// do not remove buffs if the player is frozen
			if(player_units[i].stall_turns==0){
				
				// removes attack buff if 2nd turn
				if(!player_units[i].attack_buff_recent){
					show_debug_message("reset attack bonus");
					player_units[i].attack_bonus_temp=0;
				}
				player_units[i].attack_buff_recent=false;
				
				// removes move buff if 2nd turn
				if(!player_units[i].move_buff_recent){
					show_debug_message("reset move bonus");
					player_units[i].move_bonus_temp=0;
				}
				player_units[i].move_buff_recent=false;
			}
			
			// if unit is frozen
			if(player_units[i].stall_turns>0){
				player_units[i].stall_turns-=1;
				
				// show how many turns left 
				obj_battleEffect.show_damage(player_units[i], player_units[i].stall_turns, c_blue);
				
				// finishing frozen turns
				if(player_units[i].stall_turns<=0){
					player_units[i].freeze_graphic.sprite_index=spr_freeze_out;
					player_units[i].freeze_graphic.image_speed=1;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
					unit.freeze_graphic=pointer_null;
				}
			}
			player_units[i].shield=0;
			// error handling. might be unnecessary
			if(player_units[i].stall_turns<0){
				player_units[i].stall_turns=0;
			}
			
			// reset unit variables for turn tracking and increases tp by unit
			if(player_units[i].hp>0 && player_units[i].stall_turns==0){
				player_units[i].has_moved = false;
				player_units[i].has_attacked = false;
				
			}else if(player_units[i].hp<=0){
				player_units[i].hp=0;
				player_units[i].has_moved = true;
				player_units[i].has_attacked = true;
			}
			
			
			
			
		}
		// tp bonus 
		tp_current+=tp_bonus;
		tp_current+=4;
		
		// makes sure you don't go over max tp
		if (tp_current > tp_max) {
		tp_current=tp_max;	
		}	
		show_debug_message("CURRENT TP: " + string(tp_current));
		
		change_state(BattleState.PlayerWaitingAction);
		
		// cursor can move through whole grid
		obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
		
		//move cursor to first unit
		obj_cursor.reset_cursor(player_units[0].grid_pos[0],player_units[0].grid_pos[1]);
	
		break;
#endregion

#region Player Waiting Action
	case BattleState.PlayerWaitingAction:
		obj_menu.back = false;
		// WASD to move, JKL to use skills, Tab to switch units, Enter to end player turn
		// If all units have attacked, end player's turn
		
		// unit is set to whatever the cursor is on
		unit = obj_gridCreator.battle_grid[obj_cursor.current_x][obj_cursor.current_y]._entity_on_tile;
		
		// removes push arrows
		obj_battleEffect.remove_push_preview();
		var has_all_attacked = true;
		
		if(check_battle_end()){
			change_state(BattleState.BattleEnd);
			break;
		}
		obj_menu.set_text("WASD - Move Cursor     Enter - Select Unit     Space - End Turn");
		// checks if all player units have moved
		for (var i = 0; i < array_length(player_units); i++) {
			if (!player_units[i].has_attacked) {
				has_all_attacked = false;
			}
			if(player_units[i].hp<=0){
				player_units[i].hp=0;
				player_units[i].has_moved = true;
				player_units[i].has_attacked = true;
			}
			obj_gridCreator.battle_grid[player_units[i].grid_pos[0]][player_units[i].grid_pos[1]]._entity_on_tile=player_units[i];
			obj_gridCreator.battle_grid[player_units[i].grid_pos[0]][player_units[i].grid_pos[1]]._is_empty=false;
		}
		if (has_all_attacked) {
			board_obstacle_order = 0;
			change_state(BattleState.PlayerBoardObstacle);
			break;
		}
		
		// if cursor is on a unit
		if(unit!=pointer_null){
			
			// if unit is player unit
			if(unit.ally){
				
				// open the menu
				obj_menu.open_menu();
				obj_menu.player_unit=unit;
				
				// set the tpcost array in the menu to match actual costs
				//obj_menu.tpCost=[0,unit.actions[0].cost[unit.upgrades[0]],unit.actions[1].cost[unit.upgrades[1]],unit.actions[2].cost[unit.upgrades[2]],unit.actions[3].cost[unit.upgrades[3]]];
				//obj_menu.skill_names=["",unit.actions[0].name[unit.upgrades[0]],unit.actions[1].name[unit.upgrades[1]],unit.actions[2].name[unit.upgrades[2]],unit.actions[3].name[unit.upgrades[3]]];
				
				//obj_menu.set_text("WASD - Move Cursor\nSpace - Select Unit\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - End Turn");
				
				
				// resets the ewous grid position to current position. needed for when getting moved when its not their turn (push or teleport)
				unit.prev_grid=[unit.grid_pos[0],unit.grid_pos[1]];
				
				// previews movable tiles
				if(!unit.has_moved && !unit.has_attacked){
					unit.preview_moveable_grids();
				}
				
				// select the unit to move it
				if (key_Enter_pressed) {
					if (!unit.has_moved && !unit.has_attacked) {
						change_state(BattleState.PlayerMoving);
						obj_gridCreator.remove_entity(unit.grid_pos[0],unit.grid_pos[1]);
						unit.show_moveable_grids();
					}
				}
				else if (jkl_pressed) { //choosing a skill
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
							if (enough_tp) { // if there is enough tp to use the skill
								unit.skill_init = false;
								unit.skill_complete = false;
								enough_tp = false;
								unit.skill_progress=0;
								audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
								change_state(BattleState.PlayerAiming);
								
								obj_gridCreator.reset_highlights_cursor();
								obj_menu.set_skill_text(string(unit.actions[unit.skill_used].description[unit.upgrades[unit.skill_used]]));
							}
						}
				}
				else if (key_Tab_pressed) { // changes upgrades for debugging
					//for(i = 1;i<array_length(unit.upgrades);i++){
					//	unit.upgrades[i]+=1;
					//	unit.upgrades[i]=unit.upgrades[i]%3;
					//}
				}
				
			}else{ // enemy unit
				obj_menu.close_menu();
				if(unit.stall_turns==0){
					unit.display_target_highlights();
				}
			}
		}else{
			obj_menu.close_menu();
		}
		if(key_Space_pressed){ //ask end turn
			obj_cursor.movable_tiles=[];
			obj_menu.ask_end = true;
			change_state(BattleState.BattlePause);
			
			
		}
		
		break;
#endregion

#region Player Moving
	case BattleState.PlayerMoving:
		obj_menu.back = true;
		// error handling but unit should always be a player unit here
		if(unit!=pointer_null){
			//obj_menu.set_text("WASD - Move\nJ - "+unit.actions[0].name+"\nK - "+unit.actions[1].name+"\nL - "+unit.actions[2].name+"\n; - "+unit.actions[3].name+"\nEnter - Do Nothing\nTab - Back");
			obj_menu.set_text("WASD - Move");
			
			// moving
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
			else if (key_Tab_pressed){ // back button
					obj_menu.select = 0;
					unit.back_move();
					change_state(BattleState.PlayerWaitingAction);
					for(i=0;i<array_length(enemy_units);i++){
						enemy_units[i].recalc_los();
					}
					obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
					obj_cursor.reset_cursor(unit.grid_pos[0], unit.grid_pos[1]);
				}
			else if (jkl_pressed && obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._is_empty) { // choose a skill. target position must be empty
				
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
			}else if (key_Y_pressed) {
					if (tp_current >= unit.actions[4].cost[unit.upgrades[4]]) {
					unit.skill_used = 4;
					enough_tp = true;
					}else {
						audio_play_sound(sfx_no_tp, 0, false);
					}
			}
			
				if (enough_tp && obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._is_empty) { // enough tp to use a skill
					unit.confirm_move();
					unit.skill_init = false;
					unit.skill_complete = false;
					unit.skill_progress=0;
					enough_tp = false;
					obj_gridCreator.reset_highlights_move();
					audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
					change_state(BattleState.PlayerAiming);
					for(i=0;i<array_length(enemy_units);i++){
						enemy_units[i].recalc_los();
					}
					obj_menu.set_skill_text(string(unit.actions[unit.skill_used].description[unit.upgrades[unit.skill_used]]));
				}
					
				}
			}
			//else if (key_Enter_pressed && obj_gridCreator.battle_grid[unit.grid_pos[0]][unit.grid_pos[1]]._is_empty) { //move without using a skill
			//	unit.confirm_move();
			//	unit.has_moved = true;
			//	unit.has_attacked = true;
			//	change_state(BattleState.PlayerWaitingAction);
			//	for(i=0;i<array_length(enemy_units);i++){
			//		enemy_units[i].recalc_los();
			//	}
				
			//	obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
			//}
		}
		break;
#endregion

#region Player Aiming
	case BattleState.PlayerAiming:
		
		obj_menu.back = true;
		if(unit.skill_back){ // if the player presses tab to go back. this is handled in the skill itself
			obj_menu.confirm = false;
			for(i=0;i<array_length(enemy_units);i++){
				enemy_units[i].recalc_los();
			}
			change_state(BattleState.PlayerMoving);
			unit.show_moveable_grids_prev();
			unit.has_attacked = false;
			unit.skill_back = false;
			unit.back_aim();
			
			
		}else{
			//obj_menu.set_text("WASD - Aim    Tab - Back");
			obj_menu.set_text("WASD - Aim  ");
			obj_menu.set_skill_text(string(unit.actions[unit.skill_used].description[unit.upgrades[unit.skill_used]]));
			obj_menu.confirm = true;
			
			if (unit.skill_complete) {  // did the skill get used and finish
				obj_menu.confirm = false;
				tp_current -= unit.actions[unit.skill_used].cost[unit.upgrades[unit.skill_used]];
				unit.has_attacked = true;
				if(tp_current>tp_max){
					tp_current=tp_max;
				}
				change_state(BattleState.PlayerTakingAction);
			}
			switch(unit.upgrades[unit.skill_used]){ //use the right skill based on upgrade array
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
					if (!unit.has_attacked) { // swap skills while aiming
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
						else if (key_Y_pressed&&unit.skill_used!=4) {
							if (tp_current >= unit.actions[4].cost[unit.upgrades[4]]) {
							unit.skill_used = 4;
							enough_tp = true;
							}else {
								audio_play_sound(sfx_no_tp, 0, false);
							}
					}
							if (enough_tp) {
								unit.skill_init= false;
								unit.skill_complete = false;
								enough_tp = false;
								unit.skill_progress =0;
								unit.play_sound = false;
								unit.thaw_checked = false;
								change_state(BattleState.PlayerAiming);
								obj_gridCreator.reset_highlights_cursor();
								obj_battleEffect.remove_push_preview();
								audio_play_sound(sfx_click, 0, false, 1, 0, 0.7);
								obj_menu.set_skill_text(string(unit.actions[unit.skill_used].description[unit.upgrades[unit.skill_used]]));
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
	
		obj_menu.back = true;
		
		show_debug_message(unit.name + ": taking action");
		
		
		obj_gridCreator.reset_highlights_cursor();
		obj_gridCreator.reset_highlights_attack();
		obj_gridCreator.reset_highlights_target();
		obj_gridCreator.reset_highlights_support();
		obj_battleEffect.remove_push_preview();
		
		// checks if any enemies have died. if they have, remove them from the array
		var enemy_unit = enemy_units[enemy_check_death];
		if (enemy_unit.hp<=0){
			enemy_unit.despawn();
			if(enemy_unit.stall_turns>0){
				unit.freeze_graphic.sprite_index=spr_freeze_out;
				audio_play_sound(sfx_defreeze, 0, false, 0.5);
				unit.freeze_graphic.image_speed=1;
				unit.freeze_graphic=pointer_null;
			}
			array_delete(enemy_units, enemy_check_death, 1);
			enemy_check_death-=1;
			set_enemy_turn_order();
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
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		// check if enemies have died after every eemy attacks
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
			
			// attack
			if (unit.attack_ready && unit.stall_turns==0) {
				unit.attack();
			}
			
			checking_death=true;
		}else{
			// check if any enemies have died
			var enemy_unit = enemy_units[enemy_check_death];
			if (enemy_unit.hp<=0){
				enemy_unit.despawn();
			
				array_delete(enemy_units, enemy_check_death, 1);
				enemy_check_death-=1;
				set_enemy_turn_order();
			}
		
			enemy_check_death += 1;
			if (enemy_check_death >= array_length(enemy_units)) {
				enemy_check_death = 0;
				enemy_order+=1;
				checking_death=false;
			}
		}
		
		obj_draw_bg.colorSwitch = true;
		
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
			battle_progress+=1;
			for (var i = 0; i < array_length(player_units); i++) {
			
				// revives dead units
				if(player_units[i].hp<=0){
					player_units[i].hp=1;
				}
				
			}
			if(battle_progress==array_length(global.encounters)){
				battle_progress=0;
				audio_stop_sound(current_music);
				music_track = bgm_victory;
				//music_track = global.floor_music[2][0];

				current_music = audio_play_sound(music_track, 0, false, 0.7);
				change_state(BattleState.GameWin);
				break;
			}
			tp_current=tp_max;
			if(battle_progress < array_length(global.encounters) && (battle_progress%5==0||battle_progress%2==0)){
				obj_gridCreator.transition_in=false;
				change_state(BattleState.PlayerUpgrade);
			}else{
				if (obj_menu.win == 0) change_state(BattleState.BattleStart);
			}
			if(battle_progress%5==0){
				tp_bonus=0;
				for (var i = 0; i < array_length(player_units); i++) {
					player_units[i].attack_bonus=0;
				}
			}
		}else{
			obj_gridCreator.reset_highlights_cursor();
			//obj_menu.set_text("Press any key to restart");
			audio_stop_sound(current_music);
				music_track = bgm_the_voice_someone_calls;
				//music_track = global.floor_music[2][0];

				current_music = audio_play_sound(music_track, 0, false, 0.7);
			change_state(BattleState.GameLose);
			
		}
		break;
#endregion

#region
	case BattleState.PlayerUpgrade:
		
		break;
#endregion

#region Obstacles hit player units
	case BattleState.PlayerBoardObstacle:
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		
		if (board_obstacle_order >= array_length(board_obstacles)) {
			board_obstacle_order = 0;
			change_state(BattleState.EnemyTakingAction);
			break;
		}
		
		obstacle = board_obstacles[board_obstacle_order];
		
		// attacks
		if(obstacle.stall_turns==0){
			obstacle.attack(true);
			obstacle.aim();
		}
			
		board_obstacle_order+=1;
		break;
#endregion

#region  Obstacles hit enemy units
	case BattleState.EnemyBoardObstacle:
		obj_menu.set_turn_banner(false);
		obj_draw_bg.colorSwitch = true;
		
		if (in_animation) {
			break;
		}
		obj_menu.close_menu();
		
		// check if enemies have died after every obstacle
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
			
			// attacks
			if(obstacle.stall_turns==0){
				obstacle.attack(false);
				obstacle.aim();
				obstacle.turns_remaining-=1;
			}else{
				obstacle.stall_turns-=1;
				obj_battleEffect.show_damage(obstacle, obstacle.stall_turns, c_blue);
				
				// finishing freeze turns
				if(obstacle.stall_turns==0){
					
					obstacle.freeze_graphic.sprite_index=spr_freeze_out;
					obstacle.freeze_graphic.image_speed=1;
					audio_play_sound(sfx_defreeze, 0, false, 0.5);
					unit.freeze_graphic=pointer_null;
			
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
				set_enemy_turn_order();
			}
		
			enemy_check_death += 1;
			
		}
				break;

	

		

#endregion


#region Player beats all 15 levels
	case BattleState.GameWin:
		obj_menu.win = 1;
		if (keyboard_check_pressed(vk_anykey)) {
			audio_stop_sound(current_music)
			room_goto(0);
		}
		break;
#endregion
#region Player loses
	case BattleState.GameLose:
		obj_menu.win = 2;
		if (keyboard_check_pressed(vk_anykey)) {
			audio_stop_sound(current_music)
			room_goto(0);
		}
		break;
		
#endregion
#region Game paused
	case BattleState.BattlePause:
		if(obj_menu.ask_end && key_Space_pressed){ // end the turn
				board_obstacle_order = 0;
				obj_menu.ask_end = false;
				
				for (var i = 0; i < array_length(player_units); i++) {
					if(!(player_units[i].has_attacked || player_units[i].has_moved)){
						player_units[i].attack_bonus_temp=0;
					
					}
				}
				obj_gridCreator.reset_highlights_cursor();
				change_state(BattleState.PlayerBoardObstacle);
				obj_menu.ask_end = false;
			}
			if(obj_menu.ask_end && key_Tab_pressed) {
				obj_menu.ask_end = false;
				obj_cursor.movable_tiles=obj_gridCreator.battle_grid_flattened;
				change_state(BattleState.PlayerWaitingAction);
			}
		break;
#endregion

};