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

acting = false;
#endregion

#region spawns
//spawn player(s) on Unit layer
for (var i = 0; i < array_length(global.players); i++) {
	partyUnits[i] = instance_create_layer(x, y, "Units", obj_player, global.players[i]);
	array_push(units, partyUnits[i]);
}


//spawn enemies on Unit layer
//takes in array of enemies from level input
//levelEnemies is 2d arr where each inner arr is [object, x, y]
enemySpawn = function(levelEnemies) {
	for (var i = 0; i < array_length(levelEnemies); i++) {
		enemyUnits[i] = instance_create_layer(levelEnemies[i][1], levelEnemies[i][2], "Units", obj_parent_enemy, levelEnemies[i][0]);
		array_push(units, enemyUnits[i]);
	}
}
#endregion

unitTurnOrder = units;
array_sort(unitTurnOrder, function(inst1, inst2) {
		return variable_struct_get(inst1, _speed) >= variable_struct_get(inst2,speed);
	}
);

#region state management
function BattleStateSelectAction() {
	var _unit = unitTurnOrder[turn];
	
	//check if user esists and is alive
	if (!instance_exists(_unit)) || (_unit.hp <= 0) {
		battleState = BattleStateVictoryCheck();
		exit;
	}
	
	//position = cursor.getCenterCoord();
	position = [0,0];
	BeginAction(_unit.id, global.actionLibrary.baseAttack, variable_struct_get(global.actionLibrary.baseAttack, getCoord(position)));
	
	
}

function BeginAction(_user, _action, _position) {
	battleState = BattleStatePerformAction();
	currentUser = _user;
	currentAction = _action;
	currentTargets = _position;
	
	if (!is_array(currentTargets)){
			currentTargets = [currentTargets];
		}
	
	battleWaitTimeRemaining = battleWaitTimeFrames;//animation buffer
	
	with (_user) {
		acting = true;
		//play user animation if defined
		if (!is_undefined(_action[$"userAnimation"])) && (!is_undefined(_user.sprites[$ _action.userAnimation])) {
				//sprite_index = sprite[ $ _action.userAnimation]; //commented out for now bc its throwing errors at me
				image_index = 0;
			}
	}
	
}

function BattleStatePerformAction() {
	if (currentUster.acting) {
		if(currentUser.image_index >= currentUser.image_number - 1) {
			with (currenUser) {
				sprite_index = sprites.idle;
				image_index = -1;
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
		//if (!instance_exists(oBattleEffect) {
		//	
		//}
	}
}

function BattleStateVictoryCheck() {
	battleStat = BattleStateTurnProgession();
}

function BattleStateTurnProgession() {
	turnCount++;
	turn++;
	
	if (turn > array_length(unitTurnOrder) -1) {
		turn = 0;
		rountCount++;
	}
	
	battleState = BattleStateSelectAction();
}

battleState = BattleStateSelectAction();
#endregion