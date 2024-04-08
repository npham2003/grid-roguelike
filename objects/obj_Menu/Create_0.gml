/// @description Insert description here
// You can write your code in this editor

state = 0;
skills = 5;
open = true;
_text = "Hi";

#region location & size
imgX = 200;
imgY = 680;

rootX = imgX;
rootY = imgY + 32;
menuX = [rootX, rootX, rootX, rootX, rootX];
menuY = [rootY, rootY, rootY, rootY, rootY];

optionAlpha = 0;
optionRadius = 40;
spacing = 200;

tpRadius = 32;
tpBorder = 5;
tpRadius = 40;
#endregion


#region control

player_unit = obj_player;
currCharSprite = spr_temp_Akeha;


close_menu = function(){
	open = false;
	//expansionLimit = 0;
}

open_menu = function(){
	open = true;
	//expansionLimit = 1.3;
}

set_text = function(_new_text){
	_text = _new_text;
}

#endregion

#region draw helpers
//draw a diamond given center and radius
make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}

//draw tp
make_tp = function(_x, _y, _spacing, _len) {
	var _res = [];
	var _bars =  _len/5;
	var _rem =  _len%5;
	
	for (var j = 0; j < _bars; ++j) {
		for (var i = 0; i < 5; ++i) {
			_res[i] = [_x + i*_spacing, _y - _spacing*(i%2)];
		}
	}
	return _res;
	
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}

#endregion

expandAnim = state;