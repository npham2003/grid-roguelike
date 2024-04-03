/// @description Insert description here
// You can write your code in this editor
var _buttonScale = 7;
for (var i = 3; i >= 0; i--) {
	draw_sprite_ext(spr_button_base, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, _primary, optionAlpha);
	draw_sprite_ext(spr_button_outline, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, _characterPrimary, optionAlpha);
}

draw_set_color(_secondary);
draw_rectangle(imgX, imgY, -99, 9990,0);

var _sb = 20;
draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, _sb,_sb, 0,_primary, 1);
draw_sprite_ext(spr_diamond_outline, 0, imgX, imgY, _sb,_sb, 0,_characterPrimary, 1);