// Array of player instances
player_units = [];
// Array of enemy instances
enemy_units = [];

// Current order of player unit in action
player_order = 0;
// Current order of enemy unit in action
enemy_order = 0;

#region Spawns

// Spawn player units

// Temp struct for player data, may move to a config file or generate dynamically in the future
var player_data = [
	{
		info: global.players[0],
		grid: [3, 2]		
	}
];

for (var i = 0; i < array_length(player_data); i++) {
	var coord = obj_gridCreator.get_coordinates(player_data[i].grid[0], player_data[i].grid[1]);
	
	var var_struct = variable_clone(player_data[i].info);
	var_struct.grid = player_data[i].grid;
	
	var unit = instance_create_layer(
		coord[0], coord[1], "Units", obj_player, var_struct);
	
	array_push(player_units, unit);
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


for (var i = 0; i < array_length(enemy_data); i++) {
	var coord = obj_gridCreator.get_coordinates(enemy_data[i].grid[0], enemy_data[i].grid[1]);
	
	var var_struct = variable_clone(enemy_data[i].info);
	var_struct.grid = enemy_data[i].grid;
	
	var unit = instance_create_layer(
		coord[0], coord[1], "Units", obj_parent_enemy, var_struct);
	unit.grid = enemy_data[i].grid;
		
	array_push(enemy_units, unit);
}
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
	};
	
}

function check_battle_end() {
	// todo
	return false;
}