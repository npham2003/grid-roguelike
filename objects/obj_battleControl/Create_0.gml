#region variables
grid = instance_find(obj_gridCreator, 0);

units = [];
turn = 0;
unitTurnOrder = [];
unitRenderOrder = [];


turnCount = 0;
currentUser = noone;
currentAction = -1;
currentTargets = [];
#endregion

#region spawns
//spawn player(s) on Unit layer
for (var i = 0; i < array_length(global.players); i++) {
	partyUnits[i] = instance_create_layer(x, y, "Units", global.party[i]);
	array_push(units, partyUnits[i]);
}


//spawn enemies on Unit layer
//takes in array of enemies from level input
//levelEnemies is 2d arr where each inner arr is [object, x, y]
enemySpawn = function(levelEnemies) {
	for (var i = 0; i < array_length(levelEnemies); i++) {
		enemyUnits[i] = instance_create_layer(levelEnemies[i][1], levelEnemies[i][2], "Units", levelEnemies[i][0]);
		array_push(units, enemyUnits[i]);
	}
}
#endregion

setTurnOrder = array_sort(units, function(inst1, inst2) {
		return inst1.speed >= inst2.speed;
	}
);

#region state management
function BattleStateSelectAction() {
	var _unit = unitTurnOrder[turn];
	
	if (!instance_exists(_unit)) || (_unit.hp <= 0) {
		battleState = BattleStateVictoryCheck();
		exit;
	}
	
	BeginAction(_unit.id, global.actionLibrary.attack);
}

function BeginAction(_user, _action) {
	
}

function BattleStatePerformAction() {
	
}

function BattleStateVictoryCheck() {
	
}

function BattleStateTurnProgession() {
	
}

#endregion

battleState = BattleStateSelectAction();