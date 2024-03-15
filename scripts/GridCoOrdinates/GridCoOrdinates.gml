get_coordinates = function(_x_value, _y_value){
	coordinates = [x+CELLWIDTH/2+(_x_value*CELLWIDTH), y+CELLHEIGHT/2+(_y_value*CELLHEIGHT) ];
	return coordinates;
}