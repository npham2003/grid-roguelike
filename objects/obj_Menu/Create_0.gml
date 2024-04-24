state = 0;
skills = 5;
_text = "";

open = true;
playerTurn = false;
enemyTurn = true;

confirm = false;

tp_opacity_increase=true;
tp_opacity=0;

turn_opacity_increase=true;
turn_opacity=50;
turn_count = 0;
turn_max = 3;
turn_text_anim = 0;
turn_life = 100;
turn_banner_animation_started=false;

#region location & size
imgX = 200;
imgY = 680;

rootX = imgX+20;
rootY = imgY + 32;
select_shift = 30;

menuX = [rootX, rootX, rootX, rootX, rootX];
menuY = [rootY, rootY, rootY, rootY, rootY];

portraitScale = 0.55;
playerScale = 15;
playerDim = sprite_get_height(spr_diamond_base) * playerScale/2;

optionAlpha = 0;
portraitAlpha=1;

optionRadius = 40;
spacing = 150;

confirmRadius = 40;
confirmX = [850, 1050];
confirmY = 660;

border = 5;
#endregion

#region control

player_unit = obj_player;
currCharSprite = spr_temp_Taion;
tpCost = [0, 1, 5, 7, 12];


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

set_select = function(_option) {
	select = _option;
}
#endregion

#region draw helpers
//draw a diamond given center and radius
make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}

//draw tp
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

set_turn_banner = function(player_turn){
	if(!turn_banner_animation_started){
		if(player_turn){
			turn="PLAYER TURN";	
		}else{
			turn="ENEMY TURN";
		}
		turn_life=100;
		turn_banner_animation_started=true;
		turn_opacity=100;
		turn_count = 0;
		turn_max = 3;
		turn_text_anim = 0;
		turn_life = 100;
	}
}

#endregion

expandAnim = state;