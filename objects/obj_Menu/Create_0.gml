/// @description Insert description here
// You can write your code in this editor

state = 0;
expansionLimit = 1;

#region location
imgX = 200;
imgY = 670;

rootX = imgX;
menuX = [rootX, rootX, rootX, rootX, rootX];
rootY = imgY + 32;
menuY = [rootY, rootY, rootY, rootY, rootY];

spacing = 100;
optionAlpha = 0;
#endregion

#region colors
_primary = #d1a578;
_secondary = #1cc6e0;

_playerTurnTop = #194DD0;
//_playerTurnMiddle = 
_playerTurnBottom = #148d95;

_enemyTurnTop = #da7066;
_enemyTurnMiddle = #cd5075;
_enemyTurnBottom = #665d6c;

_tpBar = #a4cda4;
_tpBorder = #6ccf48;

_characterPrimary = #0cac87; //change per party member later
_characterSecondary = #386467;
#endregion

#region control
currCharSprite = spr_temp_Akeha;
#endregion