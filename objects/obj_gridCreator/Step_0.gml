/// @description Insert description here
// You can write your code in this editor


// get co-ordinates for the middle of the tile at (x,y)
// (0,0) is top left
// arr[0] is the x and arr[1] is the y
// make sure your sprites are aligned at the middle of their feet
get_coordinates = function(_x_value, _y_value){
	
	coordinates = [x+CELLWIDTH/2+(_x_value*CELLWIDTH), y+CELLHEIGHT/2+(_y_value*CELLHEIGHT) ];
	return coordinates;
}