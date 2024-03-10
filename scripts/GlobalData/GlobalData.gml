//Action Library
global.actionLibrary = {
	baseAttack: {
		name: "baseAttack", //probably redundant to have a name but keep it
		description: "placeholder",
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		func: function(_user, _targets) {
			var _damage = 0; //math function here
		},
		getCoord: function(_centerCoord) { //_centerCoord returns a list [x,y]
			//return 2d array of all coordinates affected
			return [[0,0], [0,1]];
		}
	},
	beam: {
		name: "Beam", //copy formatting above
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
		_speed: 5,
		//sprites : { idle: lc_idle, attack: lc_attack, defend: lc_defend, down: lc_down},
		actions : []
	}
	//{ //new member
	//	name: "put new party member here", //refer to example above
	//}
]



//Enemy Data
global.enemies = {
	slimeG: 
	{
		name: "Slime",
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		strength: 5,
		_speed: 1,
		//sprites: { idle: sSlime, attack: sSlimeAttack},
		actions: [],
		AIscript : function()
		{
			//enemy turn ai goes here
		}
	}
	,
	bat: 
	{
		name: "Bat",
		hp: 15,
		hpMax: 15,
		mp: 0,
		mpMax: 0,
		strength: 4,
		_speed: 2,
		//sprites: { idle: sBat, attack: sBatAttack},
		actions: [],
		AIscript : function()
		{
			//enemy turn ai goes here
		}
	}
}
