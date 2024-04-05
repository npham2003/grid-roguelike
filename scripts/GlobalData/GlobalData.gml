//Action Library
global.actionLibrary = {
	baseAttack: {
		name: "Base Attack", //probably redundant to have a name but keep it
		description: "Does 1 damage to the first target in a row",
		cost: 1,
		subMenu: 0, //does it show up on screen or is it in a submenu
		userAnimation: "attack",
		//effectSprite: baseAttack,
		damage: 1, // temp damage, until i figure out how to do this damage function thing
		func: function(_user, _targets) {
			var _damage = 1; //math function here
			//BattleChangeHP(_targets);
		},
		skillFunctions: {
			base: function(){
				
				action = actions[0];
				obj_info_panel.set_text("WASD - Aim     Enter - Confirm     Tab - Back\nHits the first target in a row\nCost: "+string(actions[0].cost));
				skill_range = obj_gridCreator.highlighted_target_straight(grid_pos[0]+1, grid_pos[1]);
				obj_cursor.movable_tiles=skill_range;
	
				var _damage = action.damage;
				if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("J"))) {
					audio_play_sound(sfx_base_laser, 0, false);
					for (var i = 0; i < array_length(skill_range); i++) {
						if (!skill_range[i]._is_empty) {
							show_debug_message(skill_range[i]._entity_on_tile.hp);
							skill_range[i]._entity_on_tile.hp -= _damage; // temp var until we get shit moving
							obj_battleEffect.show_damage(skill_range[i]._entity_on_tile, _damage);
							show_debug_message(skill_range[i]._entity_on_tile.hp);
						}
					}
					is_attacking = false;
					skill_complete = true;
					skill_range = obj_gridCreator.reset_highlights_target();
		
				}else if(keyboard_check_pressed(vk_tab)){
					is_attacking = false;
					skill_back = true;
					skill_range = obj_gridCreator.reset_highlights_target();
		
				}
			}
		}
	},
	beam: {
		name: "Beam", //probably redundant to have a name but keep it
		description: "Does 2 damage to all targets in a row",
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
		description: "Hits a target in front and damages all adjacent units",
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
		description: "Gain 1 TP",
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
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead, gun: spr_player_shooting},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar],
		ally: true,
		tpGain: 1
		
	},
	{ //l'cifure
		name: "L'Cifure",
		hp: 5,
		hpMax: 5,
		playerSpeed: 2,
		sprites : { idle: spr_player, dead: spr_player_dead},
		actions : [global.actionLibrary.baseAttack, global.actionLibrary.beam, global.actionLibrary.charge,  global.actionLibrary.mortar],
		ally: true,
		tpGain: 1
	}
	//{ //new member
	//	name: "put new party member here", //refer to example above
	//}
]



//Enemy Data
global.enemies = [
	{
		name: "Slime",
		hp: 2,
		hpMax: 2,
		healthbar_offset: -30,
		sprites: { idle: spr_slime_idle, attack: spr_slime_attack },
		actions: [global.enemyActions.melee],
		sounds: { attack: sfx_slime_attack },
		ally: false,
		gold: 50
	},
	{
		name: "Bat",
		hp: 1,
		hpMax: 1,
		healthbar_offset: -40,
		sprites: { idle: spr_bat_idle, attack: spr_bat_attack },
		actions: [global.enemyActions.ranged_attack],
		sounds: { attack: sfx_bat_attack },
		ally: false,
		gold: 100
	}
]

//Encounters
global.encounters = [
	[
		{
			info: global.enemies[1],
			grid: [8, 3]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		}
		
	],
	[
		{
			info: global.enemies[0],
			grid: [8, 1]
		},
		{
			info: global.enemies[0],
			grid: [8, 2]
		},
		{
			info: global.enemies[0],
			grid: [8, 3]
		}
	],
	[
		{
			info: global.enemies[1],
			grid: [8, 1]
		},
		{
			info: global.enemies[1],
			grid: [8, 3]
		}
	],

]