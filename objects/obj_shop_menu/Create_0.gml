alpha = 0;
fill_alpha = 0;

actual_x=2500;
selector_pos=[0,0]
character_select_pos=0;
skill_select_pos=0;

new_skill_upgrade=0;
character_spacing=260;
upgrade_offset = 0;

skill_x_start = 150;
skill_y_start = 30;

optionRadius = 40;
border = 5;

descriptor_text = ["Heal 1 character for 1 HP",
					"Gain 1 extra TP each turn until the next floor",
					"Each attack does 1 extra damage until the next floor", 
					"Upgrade a skill on this character",
					"Upgrade a skill on this character",
					"Upgrade a skill on this character",];
menu_level=0;

cost = [2, 8, 5, 6, 6, 6,];

selectable = [true, true, true, true, true, true];

playerDim = sprite_get_height(spr_diamond_base) * 15/2;


// do not allow unit to be selected if theyre at max health
heal = function(unit){
	unit.hp+=1;
	obj_battleControl.gold-=cost[0];
}

upgrade = function(unit, skill, path){
	unit.upgrades[skill]=path;
	switch(path){
		case 1:
			obj_battleControl.gold-=cost[3];
			break;
		case 2:
			obj_battleControl.gold-=cost[4];
			break;
		case 0:
			obj_battleControl.gold-=cost[5];
			break;
	}
}

tp_bonus = function(){
	obj_battleControl.tp_bonus+=1;
	obj_battleControl.gold-=cost[1];
}

attack_up = function(){
	for(i=0;i<array_length(obj_battleControl.player_units);i++){
		obj_battleControl.player_units[i].attack_bonus+=1;
	}
	obj_battleControl.gold-=cost[2];
}

// in future maybe implement a way to not get repeats? maybe repeats are ok?
new_party_member = function(){
	show_debug_message("new member");
	var member = irandom(array_length(global.players)-1);
	obj_battleControl.spawn_unit(global.players[member]);
	obj_battleControl.gold-=cost[7];
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}

//draw a diamond given center and radius
make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
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
			if (is_rows) _res[i] = [_x + (i%5)*_spacing, _y - _spacing*((i%5)%2) + _y_offset];
			else _res[i] = [_x + (i)*_spacing, _y - _spacing*(i%2) + _y_offset];
		}

	return _res;
	
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}

make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}