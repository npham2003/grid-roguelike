#region confirm
if (confirm) {
	var c_border = border;
	var c_outline1 = [
		[confirmX[0]-(confirmRadius+c_border), confirmY],
		[confirmX[0], confirmY-(confirmRadius+c_border)],
		[confirmX[0], confirmY+(confirmRadius+c_border)],
		[confirmX[1], confirmY-(confirmRadius+c_border)],
		[confirmX[1], confirmY+(confirmRadius+c_border)],
		[confirmX[1]+(confirmRadius+c_border), confirmY]
	]
	var c_outline2 = [
		[confirmX[0]-(confirmRadius+c_border*2), confirmY],
		[confirmX[0], confirmY-(confirmRadius+c_border*2)],
		[confirmX[0], confirmY+(confirmRadius+c_border*2)],
		[confirmX[1], confirmY-(confirmRadius+c_border*2)],
		[confirmX[1], confirmY+(confirmRadius+c_border*2)],
		[confirmX[1]+(confirmRadius+c_border*2), confirmY]
	]
	c_border = 0;
	var c_button = [
		[confirmX[0]-(confirmRadius+c_border), confirmY],
		[confirmX[0], confirmY-(confirmRadius+c_border)],
		[confirmX[0], confirmY+(confirmRadius+c_border)],
		[confirmX[1], confirmY-(confirmRadius+c_border)],
		[confirmX[1], confirmY+(confirmRadius+c_border)],
		[confirmX[1]+(confirmRadius+c_border), confirmY]
	]
	
	draw_set_color(c_black);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(c_outline2);
	draw_primitive_end();
	
	draw_set_color(global._characterPrimary);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(c_outline1);
	draw_primitive_end();
	
	draw_set_color(global._primary);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(c_button);
	draw_primitive_end();
	
	draw_set_color(global._characterSecondary);
	draw_text_ext_transformed(confirmX[0]+20, 615, "Confirm: Enter", 30, confirmY-160, 0.7, 0.7, 0);
	
	//draw_text_color(550, );
}
#endregion

#region buttons
var _buttonScale = 5;
for (var i = skills - 1; i >= 0; i--) {

	#region setup
	var _border = border;
	var _outline1 = [
		[rootX, rootY-(optionRadius+_border)],
		[rootX, rootY+(optionRadius+_border)],
		[menuX[i], rootY-(optionRadius+_border)],
		[menuX[i], rootY+(optionRadius+_border)],
		[menuX[i]+(optionRadius+_border), rootY]
	]
	var _outline2 = [
		[rootX, rootY-(optionRadius+_border*2)],
		[rootX, rootY+(optionRadius+_border*2)],
		[menuX[i], rootY-(optionRadius+_border*2)],
		[menuX[i], rootY+(optionRadius+_border*2)],
		[menuX[i]+(optionRadius+_border*2), rootY]
	]
	_border = 0;
	var _button = [
		[rootX, rootY-(optionRadius+_border)],
		[rootX, rootY+(optionRadius+_border)],
		[menuX[i], rootY-(optionRadius+_border)],
		[menuX[i], rootY+(optionRadius+_border)],
		[menuX[i]+(optionRadius+_border), rootY]
	]
	#endregion
	
	#region draw buttons
	draw_set_color(c_black);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(_outline2);
	draw_primitive_end();
	
	draw_set_color(global._characterPrimary);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(_outline1);
	draw_primitive_end();
	
	draw_set_color(global._primary);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertices(_button);
	draw_primitive_end();
	#endregion
	
	#region draw tp
	var _pips = make_tp(menuX[i] - expandAnim*70, menuY[i] + 15*expandAnim, 7*expandAnim, tpCost[i], true);

	draw_set_color(global._characterSecondary);
	for (var j = 0; j < array_length(_pips); j++){
		draw_primitive_begin(pr_trianglestrip);
		draw_vertices(make_diamond(_pips[j][0],_pips[j][1], 5*expandAnim));
		draw_primitive_end();
	}
	#endregion

	//text			player_unit.actions[i].name[player_unit.upgrades[i]]+ ": " +
	if i < 4 draw_text_transformed_colour(menuX[i+1]-expandAnim*60, menuY[i]-35, global.controls[i], 0.5, 0.5, 0, global._characterSecondary, global._characterSecondary, global._characterSecondary, global._characterSecondary, expandAnim);
}
#endregion

#region hp
if (open) {
	var pc;
	pc = (player_unit.hp / player_unit.hpMax) * 100;
	draw_healthbar(menuX[0]-70, menuY[0]+3, menuX[0], menuY[0]-3, pc, global._primary, global._characterSecondary, global._characterSecondary, 0, true, true)
	draw_text_transformed(menuX[0]-expandAnim*50, menuY[0], string(player_unit.hp)+"/"+string(player_unit.hpMax), 0.5, 0.5, 0);
	//draw_text_transformed(menuX[0]+50, menuY[0]-35, "HP: " + string(obj_player.hp), 0.8, 0.8, 0);
}
#endregion

#region party tp
var _pips = make_tp(rootX+120, rootY-70, 15, obj_battleControl.tp_max, false);
for (var i = 0; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	//draw_set_color(global._tpBorder);
	//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 10*expandAnim));
	draw_set_color(global._tpBar);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 18));
	//draw_set_color(global._tpBorder);
	//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
	draw_primitive_end();
	draw_primitive_begin(pr_trianglestrip);
	
	draw_set_color(global._aspect_bars);
	
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 12));
	//draw_set_color(global._tpBorder);
	//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
	//draw_set_color(global._tpBar);
	//draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
	draw_primitive_end();
}


var _pips = make_tp(rootX+120, rootY-70, 15, obj_battleControl.tp_current, false);
//show_debug_message(string(obj_battleControl.tp_current));
for (var i = 0; i < array_length(_pips); ++i){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(global._tpBorder);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 6));
	draw_set_color(global._tpBar);
	draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
	draw_primitive_end();
}

if(obj_battleControl.state==BattleState.PlayerAiming){
	for (var i = array_length(_pips)-1; i > array_length(_pips)-1-player_unit.actions[player_unit.skill_used].cost[player_unit.upgrades[player_unit.skill_used]]; --i){
		draw_primitive_begin(pr_trianglestrip);
		
		draw_set_color(c_black);
		draw_set_alpha(tp_opacity);
		draw_vertices(make_diamond(_pips[i][0],_pips[i][1], 5));
		draw_primitive_end();
	}
}
draw_set_alpha(1);
#endregion

#region draw diamond
draw_set_color(c_black);
draw_primitive_begin(pr_trianglestrip);
draw_vertices(make_diamond(imgX,imgY,playerDim+10));
draw_primitive_end();

draw_set_color(global._characterPrimary);
draw_primitive_begin(pr_trianglestrip);
draw_vertices(make_diamond(imgX,imgY,playerDim+5));
draw_primitive_end();

draw_set_color(global._primary);
draw_primitive_begin(pr_trianglestrip);
draw_vertices(make_diamond(imgX,imgY,playerDim));
draw_primitive_end();
#endregion

#region draw character
gpu_set_blendenable(false);
gpu_set_colorwriteenable(false, false, false, true);
draw_set_alpha(0);
draw_rectangle(imgX-150, imgY-150, imgX+160, imgY+100, false); //invisible rectangle

//mask
draw_set_alpha(portraitAlpha);
//draw_sprite_ext(spr_diamond_base, 0, imgX, imgY, portraitScale, portraitScale, 0, c_white, 1);
draw_set_color(c_white);
draw_primitive_begin(pr_trianglestrip);
draw_vertices(make_diamond(imgX,imgY,playerDim));
draw_primitive_end();

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);

//draw over mask
gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
//gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_src_alpha, portraitAlpha, bm_inv_src_alpha);

//gpu_set_blendmode_ext_sepalpha(portraitAlpha, portraitAlpha, portraitAlpha, portraitAlpha);
gpu_set_alphatestenable(true);
//draw_sprite_ext(spr_temp_Akeha_under, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, 1);
draw_sprite_ext(player_unit.portrait, 0, imgX, imgY-20, -0.55, 0.55, 0, c_white, portraitAlpha);
gpu_set_alphatestenable(false);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);




#endregion

#region gold
draw_primitive_begin(pr_trianglestrip);
draw_set_color(global._primary);
draw_vertices(make_diamond(87, 53, 30));
draw_primitive_end();
draw_primitive_begin(pr_trianglestrip);
draw_set_color(global._aspect_bars);
draw_vertices(make_diamond(87, 53, 25));
draw_primitive_end();

draw_set_color(global._primary);
draw_text_transformed(75, 20, "G    "+ string(obj_battleControl.gold), 0.8, 0.8, 0);
#endregion

#region skill details
draw_set_font(fnt_chiaro);
draw_set_color(c_white);
draw_text_ext(300, 10, _text, 40, 1000);
#endregion

#region turn banner
if (turn_banner_animation_started) {
	turn_life--;
	show_debug_message(turn_life);
	draw_set_color(global._primary);
	
	if (turn_life > 50) {
		draw_set_alpha(turn_opacity/100);
	}
	else {
		turn_life--;
		draw_set_alpha(turn_life/100);
	}
	if(turn_life<=0){
		turn_banner_animation_started=false;	
	}
	draw_rectangle_colour(0, 350, room_width, 250, global._aspect_bars, global._aspect_bars, global._aspect_bars, global._aspect_bars, false);
	draw_set_color(global._primary);
	draw_set_halign(fa_center);
	draw_text_transformed(room_width/2, 260, turn, turn_text_anim, 1, 0);
	
}
else {
	turn_count = 0;
	turn_life = 100;
}
draw_set_alpha(1);
draw_set_halign(fa_left);
#endregion