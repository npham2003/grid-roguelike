/// @description Insert description here
// You can write your code in this editor


var _buttonScale = 5;
for (var i = skills - 1; i >= 0; i--) {
	#region setup
	var _outline = [
		[rootX, rootY-(tpRadius+tpBorder)],
		[rootX, rootY+(tpRadius+tpBorder)],
		[menuX[i], rootY-(tpRadius+tpBorder)],
		[menuX[i], rootY+(tpRadius+tpBorder)],
		[menuX[i]+(tpRadius+tpBorder), rootY]
	]
	tpBorder = 0;
	var _button = [
		[rootX, rootY-(tpRadius+tpBorder)],
		[rootX, rootY+(tpRadius+tpBorder)],
		[menuX[i], rootY-(tpRadius+tpBorder)],
		[menuX[i], rootY+(tpRadius+tpBorder)],
		[menuX[i]+(tpRadius+tpBorder), rootY]
	]
	#endregion
	
	#region draw buttons
	draw_set_color(c_black);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(_outline);
	draw_primitive_end();
	
	draw_set_color(global._primary);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(_button);
	draw_primitive_end();
	#endregion

	var _pips = make_tp(menuX[i] - expandAnim*150, menuY[i] + 20*expandAnim, 14*expandAnim, i*i);

	draw_set_color(global._characterSecondary);
	for (var j = 0; j < array_length(_pips); j++){
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 10* expandAnim));
		draw_primitive_end();
	}
	
	//draw_sprite_ext(spr_button_base, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, global._primary, optionAlpha);
	//draw_sprite_ext(spr_button_outline, 0, menuX[i], menuY[i], _buttonScale, _buttonScale, 0, global._characterPrimary, optionAlpha);
}


draw_set_color(c_white);

#region gold
draw_text_transformed(60, 20, "G: "+ string(obj_battleControl.gold), 1, 1, 0);
#endregion

#region skill details
draw_set_font(fnt_chiaro);
draw_text_ext(148, 128, _text, 40, 1000);
#endregion

//#region tp
//draw_text_transformed(x, y, "TP: " + string(obj_battleControl.tp_current), 1, 1, 0);
//#endregion

if (open) {

	#region fourth
	//draw_text_transformed(menuX[4]+80, menuY[4]-35, player_unit.actions[3].name[player_unit.upgrades[3]]+": L", 0.8, 0.8, 0);
	#endregion

	#region third
	//draw_text_transformed(menuX[3]+80, menuY[3]-35, player_unit.actions[2].name[player_unit.upgrades[2]]+": K", 0.8, 0.8, 0);
	#endregion

	#region second
	//draw_text_transformed(menuX[2]+80, menuY[2]-35, player_unit.actions[1].name[player_unit.upgrades[1]]+": J", 0.8, 0.8, 0);
	#endregion

	#region first
	//draw_text_transformed(menuX[1]+65, menuY[1]-35, player_unit.actions[0].name[player_unit.upgrades[0]]+": H", 0.8, 0.8, 0);
	#endregion
	
	#region hp
	var pc;
	pc = (player_unit.hp / player_unit.hpMax) * 100;
	draw_healthbar(menuX[0]-70, menuY[0]+3, 550, menuY[0]-3, pc, global._primary, global._characterSecondary, global._characterSecondary, 0, true, true)
	//draw_text_transformed(menuX[0]+50, menuY[0]-10, string(player_unit.hp)+"/"+string(player_unit.hpMax), 0.8, 0.8, 0);
	//draw_text_transformed(menuX[0]+50, menuY[0]-35, "HP: " + string(obj_player.hp), 0.8, 0.8, 0);
	#endregion
}


// draw diamond
var _sb = 15;
draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, _sb,_sb, 0, global._primary, 1);
draw_sprite_ext(spr_diamond_outline, 0, imgX, imgY, _sb,_sb, 0, global._characterPrimary, 1);
//draw_rectangle(imgX-150, imgY-150, imgX+160, imgY+100, true);

//draw_sprite_ext(spr_temp_Akeha, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);

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

