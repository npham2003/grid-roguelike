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



enemy_check_death = 0;
checking_death = false;
gold = 0;
battle_gold = 0;
unit = pointer_null;

board_obstacle_order = 0;
obstacle = pointer_null;

#region Spawns

// Spawn player units

// Temp struct for player data, may move to a config file or generate dynamically in the future
var player_data = [
	{
		info: global.players[1],
		grid: [3, 2]		
	},
	{
		info: global.players[0],
		grid: [0, 2]		
	}
];

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
	unit.upgrades = [0,0,1,1];
	obj_gridCreator.battle_grid[player_data[i].grid[0]][player_data[i].grid[1]]._entity_on_tile=unit;
	
}

spawn_unit = function(new_unit){
	
	var empty_tile = obj_gridCreator.find_empty_tile_ally(2,2,5);
	var coord = obj_gridCreator.get_coordinates(empty_tile._x_coord, empty_tile._y_coord);
	empty_tile._is_empty=false;
	
	var var_struct = variable_clone(new_unit);
	var_struct.grid_pos = [empty_tile._x_coord, empty_tile._y_coord];
	
	unit = instance_create_layer(
		coord[0], coord[1], "Units", obj_player, var_struct);
	
	array_push(player_units, unit);
	unit.prev_grid[0] = unit.grid_pos[0];
	unit.prev_grid[1] = unit.grid_pos[1];
	unit.upgrades = [0,2,2,2];
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

randomize();

spawn_enemies = function(enemy_data){
	battle_gold=0;
	for (var i = 0; i < array_length(enemy_data); i++) {
		var coord = obj_gridCreator.get_coordinates(enemy_data[i].grid[0], enemy_data[i].grid[1]);
		if(obj_gridCreator.battle_grid[enemy_data[i].grid[0]][enemy_data[i].grid[1]]._is_empty){
			obj_gridCreator.battle_grid[enemy_data[i].grid[0]][enemy_data[i].grid[1]]._is_empty=false;
			var var_struct = variable_clone(enemy_data[i].info);
			var_struct.grid_pos = enemy_data[i].grid;
	
			var unit = instance_create_layer(
				coord[0], coord[1], "Units", obj_parent_enemy, var_struct);
		
			array_push(enemy_units, unit);
			obj_gridCreator.battle_grid[enemy_data[i].grid[0]][enemy_data[i].grid[1]]._entity_on_tile=unit;
			unit.grid_pos=[enemy_data[i].grid[0],enemy_data[i].grid[1]];
			battle_gold+=unit.gold;
		}
	}
}


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

state = BattleState.BattleStart;
show_debug_message("Battle Start");

function change_state(new_state) {
	state = new_state;
	
	switch (new_state) {
		case BattleState.EnemyAiming:
			show_debug_message("Change to state Enemy Aiming");
			break;
		case BattleState.PlayerPreparing:
			show_debug_message("Change to state Player Preparing");
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
			break;
		case BattleState.BattleEnd:
			show_debug_message("Change to state Battle End");
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