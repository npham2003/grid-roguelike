/// @description Insert description here
// You can write your code in this editor
var _buttonScale = 4;
for (var i = 3; i >= 0; i--) {
	draw_sprite_ext(sButton,0,menuX[i],menuY[i],_buttonScale,_buttonScale,0,c_yellow,optionAlpha);
}

draw_set_color(c_black);
draw_rectangle(imgX, imgY, -99, 9990,0);

var _sb = 12;
draw_sprite_ext(sDiamond,0,imgX,imgY,_sb,_sb,0,c_yellow,1);