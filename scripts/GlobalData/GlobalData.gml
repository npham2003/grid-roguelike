//Action Library
global.actionLibrary = {
	baseAttack: {
		name: "Base Attack", //probably redundant to have a name but keep it
		description: "placeholder",
		cost: 1,
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		getCoord: function(_centerCoord) { //_centerCoord returns a list [x,y]
			//return 2d array of all coordinates affected
			return [[0,0], [0,1]];
		}
	},
	beam: {
		name: "Beam", //probably redundant to have a name but keep it
		description: "placeholder",
		cost: 3,
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		getCoord: function(_centerCoord) { //_centerCoord returns a list [x,y]
			//return 2d array of all coordinates affected
			return [[0,0], [0,1]];
		}
	},
	mortar: {
		name: "Mortar", //probably redundant to have a name but keep it
		description: "placeholder",
		cost: 6,
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		getCoord: function(_centerCoord) { //_centerCoord returns a list [x,y]
			//return 2d array of all coordinates affected
			// I DON'T UNDERSTAND THIS NGL
			return [[0,0], [0,1]];
		}
	}
}

global.enemyActions = {
	melee: {
		name: "melee",
		range: [[-1, 0], [-2, 0]]
	},
	ranged_attack: {
		name: "ranged attack",
		range: [[-3, 0], [-4, 0], [-5, 0], [-2, 0], [-1, 0]]
	}
}

//Player(s) Data
global.players = [
	{ //l'cifure
		name: "L'Cifure",
		hp: 89,
		hpMax: 89,
		tp: 10,
		tpMax: 15,
		strength: 6,
		playerSpeed: 2,
		//sprites : { idle: lc_idle, attack: lc_attack, defend: lc_defend, down: lc_down},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.mortar]
	}
	//{ //new member
	//	name: "put new party member here", //refer to example above
	//}
]



//Enemy Data
global.enemies = [
	{
		name: "Slime",
		obj: obj_slime,
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		strength: 5,
		_speed: 1,
		sprites: { idle: spr_slime_idle },
		actions: [global.enemyActions.melee],
	},
	{
		name: "Bat",
		obj: obj_bat,
		hp: 15,
		hpMax: 15,
		mp: 0,
		mpMax: 0,
		strength: 4,
		_speed: 2,
		sprites: { idle: spr_bat_idle },
		actions: [global.enemyActions.ranged_attack],
	}
]