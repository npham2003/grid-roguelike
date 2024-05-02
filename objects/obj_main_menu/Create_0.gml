/// @description Insert description here
// You can write your code in this editor


background = layer_background_get_id(layer_get_id("Background"));
background_layer=layer_get_id("Background");

effects_layer=layer_get_id("Effect_1");

initial_bg_hspeed=layer_get_hspeed(background_layer);
initial_bg_vspeed=layer_get_vspeed(background_layer);

current_background_color=global._characterSecondary;
next_background_color=global._characterSecondary;
menu_colors=[global._menu_secondary,global._menu_primary, c_maroon, global._aspect_bars];


line_spacing=90;
character_select_spacing=120;
big_acronym=["O","O","P","S"];
full_word=["bject","riented","hase","hifts"];
italic_offset=50;

initial_logo_x=-300;
actual_logo_x=-300;
logo_x=400;
selector_pos=0;


initial_options_x=2000;
actual_options_x=2000;
options_x=1000;
arrow_spacing=-200

sub_menu=0;

border = 5;
optionRadius = 80;

transition_in=true;

initial_credits_x=2000;
actual_credits_x=2000;
credits_x=room_width/2;

profile_pictures=[spr_nick, spr_emil, spr_will, spr_lu, spr_back];

diamond_fill=#ffb20a;
diamond_outline=#009900;

initial_character_select = -2000;
actual_character_select = -2000;
character_select=200;
portrait_flash=[false,false,false,false,false,false];
portrait_flash_opacity=[1,1,1,1,1,1];
portrait_flash_times=[2.376,2.480,2.573,2.832,3.121,3.298, 4.683];
portrait_final_flash=false;
portrait_fill_flash=0;
beat_increment=0;
beat_length=0.75;

initial_skill_x = 2000;
actual_skill_x=2000;
skill_x_start = 750;
skill_y_start = 30;

selected = [false, false, false, false, false, false];
curr=0;
party=[-1,-1,-1];



audio_play_sound(bgm_xenoblade_x_title,0,true,0.5);

turn_opacity_increase=true;
turn_opacity=50;
turn_text_anim = 0;
turn_life = 100;
turn_banner_animation_started=false;

css_sound_id=pointer_null;

initial_tips = -2000;
actual_tips = -2000;
tips_x = 25;
skill_diamond_size=120;

initial_description_x = 2000;
actual_description_x=2000;
description_x_start = 450;
description_y_start = 30;

tip_box_height=75;
tip_box_width=400;

description_box_width=900;
description_box_height=600;

#region tips

tips=[
	[
		"How to Play (1)",
		"Use (WASD) to move the cursor around on the grid. Your cursor is a white reticle surrounding a tile.\n\nOnce you move it over one of your own units, the menu at the bottom will open showing your unit's skills.\n\The unit's movement range will be previewed with BLUE highlights.\n\nPress (ENTER) to select them."
	],
	[
		"How to Play (2)",
		"Once a unit is selected, tiles within their movement range become highlighted by a darker blue. You can now move them using the cursor.\n\nOnce you move them to a desired position, press (Y) to select the Wait skill. Press (ENTER) to confirm using Wait.\n\nYou cannot move to the opposite side of the grid."
	],
	[
		"How to Play (3)",
		"You can press TAB at any time to unselect a skill or unit.\n\nBefore selecting a unit, you may also press (SPACE) to end your turn. Note that the turn will end automatically if all of your units have performed an action."
	],
	[
		"Hit Points",
		"Hit Points (HP) determine how many hits a unit can take before falling. This is shown via RED diamonds above them on the grid.\n\nEach player unit has maximum hit points between 3 and 5.\n\nPlayer units that have 0 HP cannot move or act.\n\nThey will come back to 1HP at the start of the next battle."
	],
	[
		"Technique Points",
		"Technique Points (TP) are required to use skills. TP can be seen in green diamonds next to the character portrait in the bottom right.\n\nYou regain 4 TP every turn.\n\nTP is shared between the party. Make sure you have enough TP for each party member to use the skills you want!"
	],
	[
		"Using Skills",
		"Units can both move and use a skill on the same turn. Skills, as well as how much TP they cost, are displayed in the menu on the bottom. To use a skill, press the associated button to select it. Press either (ENTER) or the skill button again to confirm.\n\nSome skills require you to pick a target or allow you to aim them. Use (WASD) to select the targeted area with your cursor before confirming.\n\nA skill's range will be shown in RED if it does damage, and GREEN if it doesn't. Tiles affected by the skill being aimed at your cursor position blink WHITE."
	],
	[
		"Friendly Fire",
		"Unless specified, you can target enemies, allies, and empty spaces with skills.\n\nMake sure you don't damage your own units!\n\nThis also applies to enemy attacks!"
	],
	[
		"Shared Skills",
		"Although units each have three unique skills, they share the Wait action and the Attack skill. Attack is always used with (H) and Wait is always used with (Y)."
	],
	[
		"Using the Attack",
		"Press (H) while your cursor is on a player unit to use the Attack skill.\n\nAttack hits the first target in any cardinal direction.\n\nBy default, it will aim towards the right. "
	],
	[
		"Enemy Attacks (1)",
		"Enemies will always aim their attacks before you can act. Tiles targeted by an enemy will show an exclamation mark.\n\nThe more enemies target a tile, the more red the ! becomes.\n\nUnits on these tiles will have their HP flash to show the damage they're projected to take."
	],
	[
		"Enemy Attacks (2)",
		"Enemy attacks are always relative to their position on the grid. Any skills that move enemies on the grid will also move their attacks!\n\nUse this to force enemies to hit each other with their own attacks!"
	],
	[
		"Enemy Attacks (3)",
		"Before selecting a unit, you can move your cursor over an enemy. This makes the specific tiles they are aiming towards glow WHITE until the cursor is moved."
	],
	[
		"Enemy Turn Order",
		"The order enemies will act on their turn is shown via a white number to their bottom right.\n\nIf an early enemy unit kills a later enemy unit, the later one won't be able to attack!"
	],
	[
		"The Flow of Battle",
		"At the beginning of a battle, all enemy units will aim their attacks.\n\nOnce every enemy has aimed their attacks, Player Turn begins. On Player Turn, all alive units can move and attack. Player Turn ends once every unit has moved and used a skill, or the turn is manually ended early with SPACE.\n\nAfter Player Turn, any board obstacles such as Bombastic's mines will explode, affecting any player units in range.\n\nThen, enemies will attack the tiles they aimed at. After this, any board obstacles such as Bombastic's mines will explode again, affecting any enemy units in range.\n\nBoard obstacles that last a specific number of turns have their timer increment during this phase.\n\nThe cycle then repeats, and all remaining enemies will move and aim their attacks."
	],
	[
		"Team Select",
		"Before playing, you must select a team of 3 units! During character selection, you can see their unique skills and how much they cost."
	],
	[
		"Floors",
		"Each floor is made up of 5 battles, and floors increase in difficulty.\n\nCheck how far you are on a floor with the progress tracker at the top!"
	],
	[
		"Gold",
		"Winning battles gives you gold, which can be seen on the top left. Gold can be used to buy upgrades from the shop."
	],
	[
		"Shop",
		"The shop appears every 2 battles, as well as at the end of a floor.\n\nIn the shop, gold can be used to purchase temporary buffs, healing, and skill upgrades for all of your party members."
	],
	[
		"Skill Upgrades",
		"With the exception of Attack and Wait, each skill has 2 different upgrades to choose from.\n\nThese upgrades are generally more powerful but cost more TP. You can only have 1 version of a skill at a time.\n\nYou can revert a skill to its original form in the same menu you upgraded it in."
	],
	[
		"Status: Push",
		"Skills that push targets in a specific direction will show what direction units will move with RED arrows in the targetting phase.\n\nPushed units can collide with other units or the walls of the grid, which will cause all units involved to take 1 damage."
	],
	[
		"Status: Freeze",
		"Frozen units turn blue and will be unable to move or attack until unfrozen.\n\nThe BLUE damage number shows how many turns they will be frozen for. It will reappear every turn to show how many more turns the unit will remain frozen. For player units, this happens right before Player Turn. For enemy units, this happens right after the enmy attack phase.\n\nThis timer appears at the end of player turn for player units, and after enemies attack but before they aim.\n\nUnits can act on the same turn they become unfrozen. Enemies will immediately move and aim after being unfrozen, and player units become actionable immediately as well."
	],
	[
		"Status: Buffs",
		"Buffs refer to any positive status applied to a party member using a skill, such as L'Cifure's Parry or Angel's Haste.\n\nThese apply passive bonuses to individual party members, such as doing extra damage or being granted extra movement.\n\nShield is a buff granted by L'Cifure's Parry and Angel's Protect and Wide Guard skills. Damage taken while having Shield will cause a YELLOW damage number and not affect the target's HP.\n\nBuffs wear off after the specified number of turns in the skill, or at the end of battle. They do not carry over."
	],
	[
		"Board Obstacles",
		"Board obstacles refer to any entity on the grid that is not a player or enemy unit. The main board obstacles in OOPS are Bombastic's various Mines that she can place.\n\nThese mines last a specific number of turns, which are displayed as blue diamonds above them on the grid.\n\nMines will affect player units and enemy units after each side has acted. Player units will get affected by mines at the end of Player Turn. Enemy units will get affected by mines after they attack, but before they aim.\n\nThe turn counter for mines only increments after they attack enemy units\n\nBoard obstacles also remain on the grid in between battles.\n\nBoard obstacles are always considered enemies and cannot be targeted by skills that only target player units. They also do not retain any buffs that the placer had when created."
	],
	[
		"L'Cifure: Summary",
		"L'Cifure is your best party member for doing direct damage.\n\nWith options such as Beam and Mortar, he can target enemies anywhere on the grid for massive damage.\n\nCharge allows him to gain an extra TP for the rest of the party. Use it whenever you have a free turn!"
	],
	[
		"L'Cifure: Beam",
		"L'Cifure's (J) skill Beam hits all units directly in front of him for 2 damage. Use it whenever enemies line up, or if you need to hit something for more damage than normal!\n\nIts first upgrade, Big Beam, also hits the rows above and below him. Additionally, any targets in the same row as L'Cifure take double damage!\n\nIts second upgrade, Repel Beam, also pushes enemies to the right by one tile. Use it to both damage and reposition enemies!"
	],
	[
		"L'Cifure: Charge",
		"L'Cifure's (K) skill Charge grants an extra 1 TP for the rest of the party. Its great when you need just a little more power.\n\nIts first upgrade, Chargeback, grants him 3 TP, but also returns him to where he was before moving. Make sure to only use it in a safe spot!\n\nIts second upgrade, Parry, makes L'Cifure immune to all attacks for 1 turn. Use it when you're in a tough spot!"
	],
	[
		"L'Cifure: Mortar",
		"L'Cifure's (L) skill Mortar hits a target within 3 spaces and all adjacent units.\n\nIts first upgrade, Airstrike, allows him to target any space on the grid, regardless of distance!\n\nIts second upgrade, Force Grenade, does double damage to the center target, as well as pushing all adjacent targets away 1 tile!"
	],
	[
		"Angel: Summary",
		"Angel is a purely supportive party member, with no unique skills that do any damage. However, all 3 of her skills, Protect, Encourage and Haste, enable the rest of her team immensely!\n\nShe also has increased movement compared to the rest of the party, being able to move 3 spaces in a turn!"
	],
	[
		"Angel: Protect",
		"Angel's (J) skill Protect allows her to prevent an adjacent ally from taking damage from 1 attack. If they're stuck in an enemy attack, or in the way of another unit's area of effect skill, make sure to cast Protect on them.\n\nIts first upgrade, Shove, let's her push an adjacent ally away 1 tile. If you need just a little extra movement, Shove is just for you.\n\nIts second upgrade, Wide Guard, protects both Angel and all adjacent allies for 1 attack!"
	],
	[
		"Angel: Encourage",
		"Angel's (K) skill Encourage lets 1 adjacent ally do 1 extra damage on all of their attacks for 2 turns.\n\nIts first upgrade, Rallying Cry, does the same thing, but lets her target an ally up to 3 tiles away! Never be prevented from buffing your allies again!\n\nIts second upgrade, Invigorate, allows an adjacent ally to deal 2 extra damage instead! Use it to deal massive damage in a single turn!"
	],
	[
		"Angel: Haste",
		"Angel's (L) skill Haste allows an adjacent ally to move 1 extra tile for 2 turns!\n\nIts first upgrade, Superspeed, allows them to move up to 2 extra spaces instead!\n\nIts second upgrade, Dance, lets an adjacent ally that has already used their turn act again! Remember that even though they get to move and use a skill, they'll have less TP to make use of."
	],
	[
		"Warpman: Summary",
		"Warpman is another purely supportive party member, but instead of directly buffing the rest of his team, he instead uses his signature teleport skills to reposition allies and disrupt enemies.\n\nUnfortunately, Warpman's armor is incredibly heavy, so he can only move 1 space on a turn. But don't worry! He makes up for this with Misty Step, a free skill that lets him teleport to a nearby space!"
	],
	[
		"Warpman: Misty Step",
		"Warpman's (J) skill Misty Step allows him to teleport to an empty tile up to 2 spaces away! It also costs no TP, making it an excellent movement option.\n\nIts first upgrade, Cartesian Shift, lets him teleport to any space in the same row or column.\n\nIts second upgrade, Dimension Door, lets him move to any empty space on the player side of the grid!"
	],
	[
		"Warpman: Warp",
		"Warpman's (K) skill Warp lets him teleport any adjacent ally to another tile up to 3 spaces away!\n\nIts first upgrade, Swap, lets you swap the positions of 2 allies, regardless of how far away they are.\n\nIts second upgrade, Rescue, teleports an ally up to 3 spaces from their current position to any of Warpman's adjacent tiles! Use it to get out of a pinch."
	],
	[
		"Warpman: Vortex Shift",
		"Warpman's (L) skill Vortex Shift allows him to teleport any enemy to an empty space up to 3 tiles away! This includes the player side of the grid.\n\nIts first upgrade, Vortex Swap, allows him to swap the positions of any 2 enemies!\n\nIts second upgrade, Vortex Warp, allows him to teleport any enemy to any empty space on the grid."
	],
	[
		"Bombastic: Summary",
		"Bombastic specializes in setting traps on the grid. While they don't do any immediate damage, they have a wide range and are incredibly efficient for their TP cost.\n\nMake sure her bombs don't accidentally blow your own units up!"
	],
	[
		"Bombastic: Mine",
		"Bombastic's (J) skill Mine lets her place a mine on the field! This mine does 1 damage to all adjacent units! It lasts 1 turn.\n\nIts first upgrade, Bigger Mine, makes the mine she places affect a 3x3 area instead! This lasts for 2 turns!\n\nIts second upgrade, More Mines, allows her to place 2 mines on a single turn!"
	],
	[
		"Bombastic: Ice Mine",
		"Bombastic's (K) skill Ice Mine allows her to place a mine that freezes units in a 3x3 area for 2 turns. The mine lasts 1 turn.\n\nIts first upgrade, Freezer, places an Ice Mine that lasts for 3 turns!\n\nIts second upgrade, Ice Age, places a larger Ice Mine, which in addition to affecting a 5x5 area, also deals 1 damage to affected units!"
	],
	[
		"Bombastic: Push Mine",
		"Warpman's (L) skill Push Mine, places a mine that pushes adjacent units away from it for 1 tile! It lasts for 1 turn.\n\nIts first upgrade, Gravity Mine, affects units up to 2 tiles away in the same row or column, and pulls units in towards it instead of pushing them away! This lasts 3 turns.\n\nIts second upgrade, Super Push Mine, pushes units away from the mine until they collide with a wall or another unit. This mine lasts for 1 turn"
	],
	[
		"Frozone: Summary",
		"Frozone is focused around inflicting the Freeze status on enemy units. By locking enemies down and making them unable to attack or move, she can allow units to move into previously targeted spaces without actually killing the enemy attacker.\n\n"
	],
	[
		"Frozone: Freeze",
		"Frozone's (J) skill Freeze lets her freeze the first unit in front of her for 1 turn!\n\nIts first upgrade, Deep Freeze, makes the skill freeze for 2 turns!\n\nIts second upgrade, Piercing Freeze, allows her to freeze all units in front of her for 1 turn!"
	],
	[
		"Frozone: Frostbite",
		"Frozone's (K) skill Frostbite hits all enemies in a cone in front of her for 1 damage. It also does 1 extra damage to any frozen units. The cone's range is 3 tiles in front of her.\n\nIts first upgrade, Boreal Wind, attacks everything in the cone in addition to everything in front of Frozone on the same row!\n\nIts second upgrade, Sharp Winds, does an extra 2 damage to frozen units!"
	],
	[
		"Frozone: Icicle Crash",
		"Frozone's (L) skill Icicle Crash, freezes a target within 3 spaces and all adjacent units for 1 turn!\n\nIts first upgrade, Avalanche, allows you to target anywhere on the grid.\n\nIts second upgrade, Absolute Zero, freezes all enemy units for 1 turn!"
	],
	[
		"Oktavia: Summary",
		"Oktavia is a party member specializing in pushing different units around the grid. While her skills don't cause direct damage, pushing units into each other causes collision damage, allowing her to become a great damage source for your party!\n\nThis also causes enemies' attack ranges to move as well, which can help your allies out of a rough spot.\n\nAdditionally, since her skills don't damage their target, you can push your allies around without any risk!"
	],
	[
		"Oktavia: Phase Shifter",
		"Oktavia's (J) skill Phase Shifter targets the first target in front of her and pushes them 1 tile in any direction you want! Use (WASD) to aim the push direction, indicated by the red arrow.\n\nIts first upgrade, Long Phase, pushes the target until they collide with a wall or another unit, guaranteeing damage!\n\nIts second upgrade, Forceful Shift, pushes the target while also dealing 1 damage!"
	],
	[
		"Oktavia: Repelling Blast",
		"Oktavia's (K) skill Repelling Blast affects all enemies in a row in front of her, as well as 1 adjacent row of your choosing. It causes units in these rows to be pushed away from each other, with the row on top being pushed up, and the one below being pushed down.\n\nIts first upgrade, Repelling Shockwave, does the same, but pushes them until they hit a wall or another unit!\n\nIts second upgrade, Compress, targets units in the above and below Oktavia, and pushes them into the row she's currently in."
	],
	[
		"Oktavia: Force Push",
		"Oktavia's (L) skill Force Push, targets the first unit in front of her in every row, and pushes them to the right 1 tile!\n\nIts first upgrade, Row Shift, targets all units in the same row as her, including herself and units behind her. You can then choose to push all of them up or down!\n\nIts second upgrade, Force Pull, does the same as the original skill, but pushes its targets to the left instead!"
	],

]
#endregion

#region sliding menu
current_tip = array_length(tips)-1
_scale=0; _fade=0.5; _whatever=2; //This is not needed, it is simply a preference. We will use these in place of numbers, when we are using arrays.
total_options=array_length(tips); //Total amount of options
option_cur=0; //Current/Selected option we want to look at
y_draw_begin=room_height/2; //Starting y position to draw
y_draw_cur=0; //Current y position we are drawing
y_draw_offset=90; //This is size of the option, used so options are not drawn over each other, change this to whatever size you want, or use the Option's sprite
y_draw_spacing=0; //this will be used as "spacing" inbetween options, totally optional
transition_speed=.20; //This is how "smoothly" we will transition the y_draw_cur value to the y_draw_begin value, increase for faster movement
scale=1; //Starting "scaling" for images (this will make options smaller than the current option
scale_add=0; //The total scaling increase for "selected" options
scale_speed=1; //The speed of scaling
fade=.5; //Fade increments per "distance" from selection
fade_speed=.25; //The speed of fade transition

//Create Option Array
for(i=0;i<total_options;i++){
    option[i,_scale]=1; //Set this Options Current Scaling, this will be used for a smooth scaling when switching options
    option[i,_fade]=1-(abs(i-option_cur)*fade); //Set this Options Current Fade value
    option[i,_whatever]=i*i; //This is just an example on how you can give each option "info" or retrievable data
    }
#endregion


website_urls=["https://twitter.com/AqoursBaelz/", "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "https://wsl7779.itch.io", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"];

menu_options=[
	[
		"Play",
		"Tutorial",
		"Tips",
		"Credits",
		"Exit"
	],
	[
		"Nick Pham",
		"Emil Cheung",
		"Will Lee",
		"Lu Pang",
		""
	]
];


funny_opacity=0;

funny_scale=max(room_height/sprite_get_height(saul_goodman), room_width/sprite_get_width(saul_goodman));

make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}

//draw tp

make_menu = function(_x, _y, _spacing, _len, is_rows) {
	var _res = [];
	var _bars =  _len/5;
	var _rem =  _len%5;
	var _y_offset = 0;
	
	var _lines = _bars + _rem;
	
		for (var i = 0; i < _len; ++i) {
			if (_bars > 0 && is_rows) {
				if (i != 0 && i%5 == 0) {
					for(var j = 0; j<array_length(_res);j++){
						_res[j][1]-=_spacing/3;
						_y_offset+=_spacing*0.45;
					}
				}
			}
			 _res[i] = [_x + _spacing*(i%2) + _y_offset , _y   + (i)*_spacing];
		}

	return _res;
	
}
make_menu_alternate = function(_x, _y, _spacing, _len, is_rows, actual, initial) {
	var _res = [];
	var _bars =  _len/5;
	var _rem =  _len%5;
	var _y_offset = 0;
	
	var _lines = _bars + _rem;
	
		for (var i = 0; i < _len; ++i) {
			if (_bars > 0 && is_rows) {
				if (i != 0 && i%5 == 0) {
					for(var j = 0; j<array_length(_res);j++){
						_res[j][1]-=_spacing/3;
						_y_offset+=_spacing*0.45;
					}
				}
			}
			//show_debug_message(string(((actual - initial)*power(-1,i))));
			 _res[i] = [_x + _spacing*(i%2) + _y_offset + ((initial - actual)*power(-1,i)), _y   + (i)*_spacing];
			 
		}

	return _res;
	
}

make_tp = function(_x, _y, _spacing, _len, is_rows) {
	var _res = [];
	var _bars =  _len/5;
	var _rem =  _len%5;
	var _y_offset = 0;
	
	var _lines = _bars + _rem;
	
		for (var i = 0; i < _len; ++i) {
			if (_bars > 0 && is_rows) {
				if (i != 0 && i%5 == 0) {
					for(var j = 0; j<array_length(_res);j++){
						_res[j][1]-=_spacing/3;
						_y_offset+=_spacing*0.45;
					}
				}
			}
			//show_debug_message(string(((actual - initial)*power(-1,i))));
			 _res[i] = [_x  + (i)*_spacing, _y  - _spacing*(i%2) + _y_offset];
			 
		}

	return _res;
	
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}

draw_lines = function(vertices, _width, _color){
	for (var i = 0; i < array_length(vertices); ++i) {
		_x_1=vertices[i][0];
		_y_1=vertices[i][1];
		_x_2=vertices[(i+1)%array_length(vertices)][0];
		_y_2=vertices[(i+1)%array_length(vertices)][1];
		_offset=1;
		if(_x_1<_x_2){
			_x_1-=_offset;
			_x_2+=_offset;
		}else if(_x_1>_x_2){
			_x_1+=_offset;
			_x_2-=_offset;
		}
		if(_y_1<_y_2){
			_y_1-=_offset;
			_y_2+=_offset;
		}else if(_y_2<_y_1){
			_y_1+=_offset;
			_y_2-=_offset;
		}
		draw_line_width_color(_x_1, _y_1, _x_2, _y_2, _width, _color, _color);
	}
}

text_outline = function(){
	//x,y: Coordinates to draw
	//str: String to draw
	//arugment3 = outwidth: Width of outline in pixels
	//argument4 = outcol: Colour of outline (main text draws with regular set colour)
	//argument5 = outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//argument6 = separation, for the draw_text_EXT command.
	//argument7 = width for the draw_text_EXT command.


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(argument4);

	for(var dto_i=45; dto_i<405; dto_i+=360/argument5)
	{
	  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
	  draw_text_ext(argument0+round(lengthdir_x(argument3,dto_i)),argument1+round(lengthdir_y(argument3,dto_i)),argument2,argument6,argument7);
	}

	draw_set_color(dto_dcol);

	draw_text_ext(argument0,argument1,argument2,argument6,argument7);	
	
	
}

text_outline_scale = function(){
	//x,y: Coordinates to draw
	//str: String to draw
	//arugment3 = outwidth: Width of outline in pixels
	//argument4 = outcol: Colour of outline (main text draws with regular set colour)
	//argument5 = outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//argument6 = separation, for the draw_text_EXT command.
	//argument7 = width for the draw_text_EXT command.
	//argument8 = scale


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(argument4);

	for(var dto_i=45; dto_i<405; dto_i+=360/argument5)
	{
	  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
	  draw_text_ext_transformed(argument0+round(lengthdir_x(argument3,dto_i)),argument1+round(lengthdir_y(argument3,dto_i)),argument2,argument6,argument7,argument8,argument8,0);
	}

	draw_set_color(dto_dcol);

	draw_text_ext_transformed(argument0,argument1,argument2,argument6,argument7,argument8,argument8,0);	
	
	
}