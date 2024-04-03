//Action Library
global.actionLibrary = {
	baseAttack: {
		name: "Base Attack", //probably redundant to have a name but keep it
		description: "placeholder",
		cost: 1,
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 1, // temp damage, until i figure out how to do this damage function thing
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
		damage: 2, // temp damage, until i figure out how to do this damage function thing
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
		damage: 4, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		getCoord: function(_centerCoord) { //_centerCoord returns a list [x,y]
			//return 2d array of all coordinates affected
			// I DON'T UNDERSTAND THIS NGL
			return [[0,0], [0,1]];
		}
	},
	charge: {
		name: "Charge", //probably redundant to have a name but keep it
		description: "placeholder",
		cost: 0,
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
		range: [
			[-1, 0], [-1, -1], [-1, 1],
			[-2, 0], [-2, -1], [-2, 1],
			[-3, 0]
		]
	},
	ranged_attack: {
		name: "ranged attack",
		range: [
			[-5, 0], [-6, 0], [-7, 0], [-8, 0], [-9, 0],
			[-4, 0], [-3, 0], [-2, 0], [-1, 0]
		]
	}
}

//Player(s) Data
global.players = [
	{ //l'cifure
		name: "L'Cifure",
		hp: 5,
		hpMax: 5,
		tp: 10,
		tpMax: 15,
		strength: 6,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar],
		ally: true
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
		hp: 5,
		hpMax: 5,
		mp: 0,
		mpMax: 0,
		strength: 5,
		_speed: 1,
		sprites: { idle: spr_slime_idle, attack: spr_slime_attack },
		actions: [global.enemyActions.melee],
		sounds: { attack: sfx_slime_attack },
		ally: false
	},
	{
		name: "Bat",
		obj: obj_bat,
		hp: 3,
		hpMax: 3,
		mp: 0,
		mpMax: 0,
		strength: 4,
		_speed: 2,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.ranged_attack],
		sounds: { attack: sfx_bat_attack },
		ally: false
	}
]