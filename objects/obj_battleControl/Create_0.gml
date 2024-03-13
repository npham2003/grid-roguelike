
#region variables
grid = instance_find(obj_gridCreator, 0);
cursor = instance_find(obj_cursor, 0);

units = [];
turn = 0;
unitTurnOrder = [];
unitRenderOrder = [];


turnCount = 0;
rountCount = 0;
currentUser = noone;
currentAction = -1;
currentTargets = [];
battleWaitTimeFrames = 30;

test_ready = false; // TEMP TEST VAR
#endregion

show_debug_message(obj_player);
#region spawns
//spawn player(s) on Unit layer
for (var i = 0; i < array_length(global.players); i++) {
	var coordinates = obj_gridCreator.get_coordinates(3,2);
	partyUnits[i] = instance_create_layer(coordinates[0], coordinates[1], "Units", obj_player, global.players[i]);
	obj_gridCreator.battle_grid[3][2].set_entity(obj_player);
	array_push(units, partyUnits[i]);
	
	show_debug_message(partyUnits[i].name);
	
	partyUnits[i].moveSpeed=global.players[0].playerSpeed;
	show_debug_message(partyUnits[i].moveSpeed);
	//show_debug_message(string(array_length(obj_gridCreator.highlighted_move_array)));
	//show_debug_message(string(obj_gridCreator.highlighted_move_array[7]._x_coord));
}


//spawn enemies on Unit layer
//takes in array of enemies from level input
//levelEnemies is 2d arr where each inner arr is [object, x, y]
enemySpawn = function(levelEnemies) {
	for (var i = 0; i < array_length(levelEnemies); i++) {
		enemyUnits[i] = instance_create_layer(levelEnemies[i][1], levelEnemies[i][2], "Units", levelEnemies[i][0].obj, levelEnemies[i][0]);
		array_push(units, enemyUnits[i]);
		show_debug_message(enemyUnits[i].name);
	}
}

var coordinates = obj_gridCreator.get_coordinates(8,2);
enemySpawn([[global.enemies.bat, coordinates[0], coordinates[1]]]);
#endregion

unitTurnOrder = units;
array_sort(unitTurnOrder, function(inst1, inst2) {
		return (inst1.unitSpeed >= inst2.unitSpeed);
	}
);

#region state management
function BattleStateSelectAction() {
	show_debug_message("select action");
	var _unit = unitTurnOrder[turn];
	
	//check if user esists and is alive
	if (!instance_exists(_unit)) || (_unit.hp <= 0) {
		battleState = BattleStateVictoryCheck;
		exit;
	}
	
	//position = cursor.getCenterCoord();
	position = [0,0];
	
	BeginAction(_unit.id, global.actionLibrary.baseAttack, global.actionLibrary.baseAttack.getCoord(position));
	//show_debug_message(str(_unit.id));
	//show_debug_message(str(global.actionLibrary.baseAttack));
	//show_debug_message(str(global.actionLibrary.baseAttack.getCoord(position)));
}

function BeginAction(_user, _action, _position) {
	currentUser = _user;
	currentAction = _action;
	currentTargets = _position;
	if (!currentUser.is_moving) { // this should only happen one time in a turn
	_user.CheckTiles();
	battleWaitTimeRemaining = battleWaitTimeFrames;//animation buffer
	currentUser.is_moving = true;
	currentUser.is_acting = true;
	}
	battleState = BattleStatePerformAction;
	
	if (!is_array(currentTargets)){
			currentTargets = [currentTargets];
		}
	
	
	with (_user) {
		//play user animation if defined
		//if (!is_undefined(_action[$"userAnimation"])) && (!is_undefined(_user.sprites[$ _action.userAnimation])) {
		//		//sprite_index = sprite[ $ _action.userAnimation]; //commented out for now bc its throwing errors at me
		//		image_index = 0;
		//	}
	}
	
}

function BattleStatePerformAction() {
	show_debug_message("perform action");
	if (currentUser.is_acting && !currentUser.is_moving) {
		if(currentUser.image_index >= currentUser.image_number - 1) {
			with (currentUser) {
				// commented out for testing
				//sprite_index = sprites.idle;
				//image_index = -1;
				is_acting = false;
			}
			if (variable_struct_exists(currentAction, "effectSprite")) {
				//play effect over every targeted cell
				//for(var i = 0; i < array_length(currentAction.getCoord())
			}
			//finish sprite shit later
			//else ()
			
			//currentAction.func(currentUser, currentTargets);
		}
	}
	else if (!currentUser.is_acting){
		if (!instance_exists(obj_battleEffect)) {
			show_debug_message(battleWaitTimeRemaining);
			if (battleWaitTimeRemaining <= 0) {
				battleState = BattleStateVictoryCheck;
			}
			else {
				battleWaitTimeRemaining--;
			}
		}
	}
}

function BattleStateVictoryCheck() {
	show_debug_message("victory check");
	battleState = BattleStateTurnProgession;
}

function BattleStateTurnProgession() {
	turnCount++;
	turn++;
	// comment this out later
	//turn=0;	
	
	
	
	if (turn > array_length(unitTurnOrder) -1) {
		turn = 0;
		rountCount++;
	}
	
	battleState = BattleStateSelectAction;
}

battleState = BattleStateSelectAction;
#endregion