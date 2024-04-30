/// @description Insert description here
// You can write your code in this editor


background = layer_background_get_id(layer_get_id("Background"));
background_layer=layer_get_id("Background");

effects_layer=layer_get_id("Effect_1");

initial_bg_hspeed=layer_get_hspeed(background_layer);
initial_bg_vspeed=layer_get_vspeed(background_layer);

current_background_color=global._characterSecondary;
next_background_color=global._characterSecondary;
menu_colors=[global._menu_secondary,global._menu_primary, c_maroon];


line_spacing=sprite_get_height(spr_diamond_base) * 15/2;;
big_acronym=["O","O","P","S"];
full_word=["bject","riented","hase","hifts"];
italic_offset=50;

initial_logo_x=-300;
actual_logo_x=-300;
logo_x=400;
selector_pos=0;


initial_options_x=2000;
actual_options_x=2000;
options_x=1000;
arrow_spacing=-200

sub_menu=0;

border = 5;
optionRadius = 80;

transition_in=true;

initial_credits_x=2000;
actual_credits_x=2000;
credits_x=room_width/2;

profile_pictures=[spr_nick, spr_emil, spr_will, spr_lu, spr_back];

diamond_fill=#ffb20a;
diamond_outline=#009900;

initial_character_select = -2000;
actual_character_select = -2000;
character_select=200;

initial_skill_x = 2000;
actual_skill_x=2000;
skill_x_start = 750;
skill_y_start = 30;

selected = [false, false, false, false, false, false];
curr=0;
party=[-1,-1,-1];

audio_play_sound(bgm_xenoblade_x_title,0,true);

website_urls=["https://twitter.com/AqoursBaelz/", "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "https://wsl7779.itch.io", "https://www.youtube.com/watch?v=dQw4w9WgXcQ"];

menu_options=[
	[
		"Play",
		"Tutorial",
		"Credits",
		"Exit"
	],
	[
		"Nick Pham",
		"Emil Cheung",
		"Will Lee",
		"Lu Pang",
		""
	]
];


funny_opacity=0;

funny_scale=max(room_height/sprite_get_height(saul_goodman), room_width/sprite_get_width(saul_goodman));

make_diamond = function(_x, _y, _r) {
	return [[_x - _r, _y], [_x ,_y -_r], [_x, _y + _r], [_x + _r, _y]];
}

//draw tp

make_menu = function(_x, _y, _spacing, _len, is_rows) {
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
			 _res[i] = [_x + _spacing*(i%2) + _y_offset , _y   + (i)*_spacing];
		}

	return _res;
	
}
make_menu_alternate = function(_x, _y, _spacing, _len, is_rows, actual, initial) {
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
			//show_debug_message(string(((actual - initial)*power(-1,i))));
			 _res[i] = [_x + _spacing*(i%2) + _y_offset + ((initial - actual)*power(-1,i)), _y   + (i)*_spacing];
			 
		}

	return _res;
	
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
			//show_debug_message(string(((actual - initial)*power(-1,i))));
			 _res[i] = [_x  + (i)*_spacing, _y   + _spacing*(i%2) + _y_offset];
			 
		}

	return _res;
	
}

draw_vertices = function(vertices){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_vertex(vertices[i][0], vertices[i][1]);
	}
}

draw_lines = function(vertices, _width, _color){
	for (var i = 0; i < array_length(vertices); ++i) {
		draw_line_width_color(vertices[i][0], vertices[i][1], vertices[(i+1)%array_length(vertices)][0], vertices[(i+1)%array_length(vertices)][1], _width, _color, _color);
	}
}

text_outline = function(){
	//x,y: Coordinates to draw
	//str: String to draw
	//arugment3 = outwidth: Width of outline in pixels
	//argument4 = outcol: Colour of outline (main text draws with regular set colour)
	//argument5 = outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//argument6 = separation, for the draw_text_EXT command.
	//argument7 = width for the draw_text_EXT command.


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(argument4);

	for(var dto_i=45; dto_i<405; dto_i+=360/argument5)
	{
	  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
	  draw_text_ext(argument0+round(lengthdir_x(argument3,dto_i)),argument1+round(lengthdir_y(argument3,dto_i)),argument2,argument6,argument7);
	}

	draw_set_color(dto_dcol);

	draw_text_ext(argument0,argument1,argument2,argument6,argument7);	
	
	
}

text_outline_small = function(){
	//x,y: Coordinates to draw
	//str: String to draw
	//arugment3 = outwidth: Width of outline in pixels
	//argument4 = outcol: Colour of outline (main text draws with regular set colour)
	//argument5 = outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//argument6 = separation, for the draw_text_EXT command.
	//argument7 = width for the draw_text_EXT command.


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(argument4);
	
	for(var dto_i=45; dto_i<405; dto_i+=360/argument5)
	{
	  //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
	  draw_text_ext(argument0+round(lengthdir_x(argument3,dto_i)),argument1+round(lengthdir_y(argument3,dto_i)),argument2,argument6,argument7);
	}

	draw_set_color(dto_dcol);

	draw_text_ext(argument0,argument1,argument2,argument6,argument7);	
	
}