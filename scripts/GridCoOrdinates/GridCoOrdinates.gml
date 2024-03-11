// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
get_coordinates = function(_x_value, _y_value){
	coordinates = [x+CELLWIDTH/2+(_x_value*CELLWIDTH), y+CELLHEIGHT/2+(_y_value*CELLHEIGHT) ];
	return coordinates;
}