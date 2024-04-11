/// @description Insert description here
// You can write your code in this editor

state = 0;
expansionLimit = 1;
open = true;

#region location
imgX = 200;
imgY = 680;

rootX = imgX+150;
menuX = [rootX, rootX, rootX, rootX, rootX];
rootY = imgY + 20;
menuY = [rootY, rootY, rootY, rootY, rootY];

spacing = 100;
optionAlpha = 0;

portraitAlpha=1;
#endregion


#region control

player_unit = obj_player;
currCharSprite = spr_temp_Akeha;

#endregion

close_menu = function(){
	open = false;
	expansionLimit=0;
}

open_menu = function(){
	open = true;
	expansionLimit=1.3;
}