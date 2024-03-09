//Action Library
#region action library
global.actionLibrary = {
	name: "baseAttack",
	description: "placeholder",
	subMenu: 0,
	userAnimation: "attack",
	effectSprite: baseAttack,
	func: function(_user, _targets) {
		var _damage = 0; //math function here
	}
}
#endregion

//Player(s) Data
#region player
global.players = [
	{
		name: "L'Cifure",
		hp: 89,
		hpMax: 89,
		tp: 10,
		tpMax: 15,
		strength: 6,
		sprites : { idle: lc_idle, attack: lc_attack, defend: lc_defend, down: lc_down},
		actions : []
	}
]
#endregion


//Enemy Data
#region enemies
global.enemies = {
	slimeG: 
	{
		name: "Slime",
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		strength: 5,
		sprites: { idle: sSlime, attack: sSlimeAttack},
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
		sprites: { idle: sBat, attack: sBatAttack},
		actions: [],
		AIscript : function()
		{
			//enemy turn ai goes here
		}
	}
}
#endregion