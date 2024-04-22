// Array of player instances
player_units = [];
// Array of enemy instances
enemy_units = [];

board_obstacles = [];

// Current order of player unit in action
player_order = 0;
// Current order of enemy unit in action
enemy_order = 0;

// maybe these are in the wrong spot? but anyway yea
tp_max = 10;
tp_current = 6;
tp_bonus=0;

in_animation = false;
transition_count = 0;


enemy_check_death = 0;
checking_death = false;
gold = 0;
battle_gold = 0;
unit = pointer_null;

board_obstacle_order = 0;
obstacle = pointer_null;

battle_progress=0;

#region Spawns

// Spawn player units

// Temp struct for player data, may move to a config file or generate dynamically in the future
var player_data = [
	//{
	//	info: global.players[1],
	//	grid: [3, 2]		
	//},
	{
		info: global.players[2],
		grid: [2, 2]		
	},
	{
		info: global.players[0],
		grid: [2, 1]		
	}
];

// spawns units at the very start
for (var i = 0; i < array_length(player_data); i++) {
	var coord = obj_gridCreator.get_coordinates(player_data[i].grid[0], player_data[i].grid[1]);
	obj_gridCreator.battle_grid[player_data[i].grid[0]][player_data[i].grid[1]]._is_empty=false;
	
	var var_struct = variable_clone(player_data[i].info);
	var_struct.grid_pos = player_data[i].grid;
	
	unit = instance_create_layer(
		coord[0], coord[1], "Units", obj_player, var_struct);
	
	array_push(player_units, unit);
	unit.prev_grid[0] = unit.grid_pos[0];
	unit.prev_grid[1] = unit.grid_pos[1];
	unit.upgrades = [0,2,0,2];
	obj_gridCreator.battle_grid[player_data[i].grid[0]][player_data[i].grid[1]]._entity_on_tile=unit;
	
}

// spawns a new unit
spawn_unit = function(new_unit){
	
	var empty_tile = obj_gridCreator.find_empty_tile_ally(2,2,5);
	var coord =[empty_tile.x, empty_tile.y];
	empty_tile._is_empty=false;
	
	var var_struct = variable_clone(new_unit);
	var_struct.grid_pos = [empty_tile._x_coord, empty_tile._y_coord];
	
	unit = instance_create_layer(
		coord[0], coord[1], "Units", obj_player, var_struct);
	
	array_push(player_units, unit);
	unit.prev_grid[0] = unit.grid_pos[0];
	unit.prev_grid[1] = unit.grid_pos[1];
	
	unit.upgrades = [0,0,0,0];
	empty_tile._entity_on_tile=unit;
	
}

// Spawn enemies
var enemy_data = [
	{
		info: global.enemies[0],
		grid: [8, 2]
	},
	{
		info: global.enemies[1],
		grid: [8, 3]
	}
];

// needed to randomize seed
randomize();

// spawns enemies given enemy data. format should be the same as above struct. should be called from global.encounters
spawn_enemies = function(enemy_data){
	battle_gold=0;
	for (var i = 0; i < array_length(enemy_data); i++) {
		var empty_tile = obj_gridCreator.find_empty_tile_enemy(enemy_data[i].grid[0], enemy_data[i].grid[1], 5);
		var coord =[empty_tile.x, empty_tile.y];
		show_debug_message("Empty at "+string(coord));
		
			obj_gridCreator.battle_grid[empty_tile._x_coord][empty_tile._y_coord]._is_empty=false;
			var var_struct = variable_clone(enemy_data[i].info);
			var_struct.grid_pos = [empty_tile._x_coord,empty_tile._y_coord];
	
			var unit = instance_create_layer(
				coord[0], coord[1], "Units", obj_parent_enemy, var_struct);
		
			array_push(enemy_units, unit);
			obj_gridCreator.battle_grid[empty_tile._x_coord][empty_tile._y_coord]._entity_on_tile=unit;
			unit.grid_pos=[empty_tile._x_coord,empty_tile._y_coord];
			battle_gold+=unit.gold;
			unit.enemy_turn_order=array_length(enemy_units);
		
	}
}

// spawns an enemy on the ally side of the board. if target tile is not empty it will find a nearby empty one
spawn_summon_ally_side = function(enemy_data, _summoner){
	battle_gold=0;
	for (var i = 0; i < array_length(enemy_data); i++) {
		empty_tile = obj_gridCreator.find_empty_tile_ally(enemy_data[i].grid[0], enemy_data[i].grid[1], 5);
		var coord =[empty_tile.x, empty_tile.y];
		show_debug_message("Empty at "+string(coord)+ " which is ("+string(empty_tile._x_coord)+", "+string(empty_tile._y_coord)+")");
		
			obj_gridCreator.battle_grid[empty_tile._x_coord][empty_tile._y_coord]._is_empty=false;
			var var_struct = variable_clone(enemy_data[i].info);
			var_struct.grid_pos = [empty_tile._x_coord,empty_tile._y_coord];
	
			var unit = instance_create_layer(
				coord[0], coord[1], "Units", obj_parent_enemy, var_struct);
			with (unit){
				summoner=_summoner;
			}
			array_insert(enemy_units,0,unit);
			obj_gridCreator.battle_grid[empty_tile._x_coord][empty_tile._y_coord]._entity_on_tile=unit;
			unit.grid_pos=[empty_tile._x_coord,empty_tile._y_coord];
			battle_gold+=unit.gold;
		
	}
	set_enemy_turn_order();
}

set_enemy_turn_order = function(){
	for(i=0;i<array_length(enemy_units);i++){
		enemy_units[i].enemy_turn_order=i+1
	}
}

// spawns a board obstacle. 
spawn_obstacle = function(obstacle, grid_pos){
	
	
		var coord = obj_gridCreator.get_coordinates(grid_pos[0], grid_pos[1]);
	
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._is_empty=false;
		var var_struct = variable_clone(obstacle);
		var_struct.grid_pos=[grid_pos[0],grid_pos[1]];
	
		var unit = instance_create_layer(
			coord[0], coord[1], "Units", obj_board_obstacle, var_struct);
		
		array_push(board_obstacles, unit);
		obj_gridCreator.battle_grid[grid_pos[0]][grid_pos[1]]._entity_on_tile=unit;
		
		unit.grid_pos=[grid_pos[0],grid_pos[1]];
		unit.aim();
		
	
}

obj_cursor.movable_tiles=obj_gridCreator.battle_grid;


#endregion

enum BattleState {
	BattleStart,
	EnemyAiming,
	PlayerPreparing,
	PlayerWaitingAction,
	PlayerMoving,
	PlayerAiming,
	PlayerTakingAction,
	EnemyTakingAction,
	BattleEnd,
	PlayerUpgrade,
	PlayerBoardObstacle,
	EnemyBoardObstacle
};

//state = BattleState.PlayerUpgrade;
state = BattleState.BattleStart;
show_debug_message("Battle Start");

function change_state(new_state) {
	state = new_state;
	
	switch (new_state) {
		case BattleState.EnemyAiming:
			show_debug_message("Change to state Enemy Aiming");
			transition_count = 120;
			break;
		case BattleState.PlayerPreparing:
			show_debug_message("Change to state Player Preparing");
			obj_menu.set_turn_banner(true);
			transition_count = 100;
			break;
		case BattleState.PlayerWaitingAction:
			show_debug_message("Change to state Player Waiting Action");
			break;
		case BattleState.PlayerMoving:
			show_debug_message("Change to state Player Moving");
			break;
		case BattleState.PlayerAiming:
			show_debug_message("Change to state Player Aiming");
			break;
		case BattleState.PlayerTakingAction:
			show_debug_message("Change to state Player Taking Action");
			break;
		case BattleState.EnemyTakingAction:
			show_debug_message("Change to state Enemy Taking Action");
			obj_menu.set_turn_banner(false);
			transition_count = 100;
			break;
		case BattleState.BattleEnd:
			show_debug_message("Change to state Battle End");
			transition_count = 120;
			break;
		case BattleState.PlayerUpgrade:
			show_debug_message("Change to state Player Upgrade");
			break;
	};
	
}

function check_battle_end() {
	// todo
	result = true;
	for (var i =0;i<array_length(player_units);i++){
		if(player_units[i].hp>0){
			result=false;
		}
	}
	return array_length(enemy_units)==0||result;
}