var _x_coord = 0;
var _y_coord = 0;

var _is_empty = true;

var _entity_on_tile = pointer_null;

set_coords = function(_x_coordinate, _y_coordinate){
	_x_coord = _x_coordinate;
	_y_coord = _y_coordinate;
}

is_empty = function(){
	return _is_empty;
}

