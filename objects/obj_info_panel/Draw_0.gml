/// @description Insert description here
// You can write your code in this editor
draw_sprite_ext(spr_info_panel, image_index, x, y, 10, 5, image_angle, image_blend, 1);

draw_set_font(fnt_chiaro); 

draw_text_transformed(x+1050, y, "TP: " + string(obj_battleControl.tp_current), 1, 1, 0);



draw_text_ext(x+20, y, _text, 30, 1000);