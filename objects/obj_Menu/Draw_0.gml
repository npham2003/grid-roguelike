/// @description Insert description here
// You can write your code in this editor

var _buttonScale = 7;
for (var i = 4; i >= 0; i--) {
	draw_sprite_ext(spr_button_base, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, global._primary, optionAlpha);
	draw_sprite_ext(spr_button_outline, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, global._characterPrimary, optionAlpha);
}

//draw_set_color(_secondary);

var _sb = 20;
draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, _sb,_sb, 0, global._primary, 1);
draw_sprite_ext(spr_diamond_outline, 0, imgX, imgY, _sb,_sb, 0, global._characterPrimary, 1);
//draw_rectangle(imgX-150, imgY-150, imgX+160, imgY+100, true);

//draw_sprite_ext(spr_temp_Akeha, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);

#region tp
draw_text_transformed(x, y, "TP: " + string(obj_battleControl.tp_current), 1, 1, 0);
#endregion

#region draw character

gpu_set_blendenable(false);
gpu_set_colorwriteenable(false, false, false, true);
draw_set_alpha(0);
draw_rectangle(imgX-150, imgY-150, imgX+160, imgY+100, false); //invisible rectangle

//mask
draw_set_alpha(1);
draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, _sb, _sb, 0, c_white, 1);
gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);

//draw over mask
gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
gpu_set_alphatestenable(true);
//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
draw_sprite_ext(currCharSprite, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
gpu_set_alphatestenable(false);
gpu_set_blendmode(bm_normal);

#endregion

