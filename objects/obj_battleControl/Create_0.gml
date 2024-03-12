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

acting = false;
#endregion

#region spawns
//spawn player(s) on Unit layer
for (var i = 0; i < array_length(global.players); i++) {
	//var coordinates = obj_gridCreator.get_coordinates()
	partyUnits[i] = instance_create_layer(x, y, "Units", obj_player, global.players[i]);
	array_push(units, partyUnits[i]);
	show_debug_message(partyUnits[i].name);
}


//spawn enemies on Unit layer
//takes in array of enemies from level input
//levelEnemies is 2d arr where each inner arr is [object, x, y]
enemySpawn = function(levelEnemies) {
	for (var i = 0; i < array_length(levelEnemies); i++) {
		enemyUnits[i] = instance_create_layer(levelEnemies[i][1], levelEnemies[i][2], "Units", obj_parent_enemy, levelEnemies[i][0]);
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
	battleState = BattleStatePerformAction;
	
	
	if (!is_array(currentTargets)){
			currentTargets = [currentTargets];
		}
	
	battleWaitTimeRemaining = battleWaitTimeFrames;//animation buffer
	
	with (_user) {
		acting = true;
		//play user animation if defined
		//if (!is_undefined(_action[$"userAnimation"])) && (!is_undefined(_user.sprites[$ _action.userAnimation])) {
		//		//sprite_index = sprite[ $ _action.userAnimation]; //commented out for now bc its throwing errors at me
		//		image_index = 0;
		//	}
	}
	
}

function BattleStatePerformAction() {
	if (currentUser.acting) {
		if(currentUser.image_index >= currentUser.image_number - 1) {
			with (currentUser) {
				// commented out for testing
				//sprite_index = sprites.idle;
				//image_index = -1;
				acting = false;
			}
			
			if (variable_struct_exists(currentAction, "effectSprite")) {
				//play effect over every targeted cell
				//for(var i = 0; i < array_length(currentAction.getCoord())
			}
			//finish sprite shit later
			//else ()
			
			currentAction.func(currentUser, currentTargets);
		}
	}
	
	else {
		if (!instance_exists(obj_battleEffect)) {
			battleWaitTimeRemaining--;
			if (battleWaitTimeRemaining <= 0) {
				battleState = BattleStateVictoryCheck;
			}
		}
	}
}

function BattleStateVictoryCheck() {
	battleState = BattleStateTurnProgession;
}

function BattleStateTurnProgession() {
	turnCount++;
	turn++;
	
	if (turn > array_length(unitTurnOrder) -1) {
		turn = 0;
		rountCount++;
	}
	
	battleState = BattleStateSelectAction;
}

battleState = BattleStateSelectAction;
#endregion