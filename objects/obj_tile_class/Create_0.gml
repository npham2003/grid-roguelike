_x_coord = 0;
_y_coord = 0;

_is_empty = true;

_entity_on_tile = pointer_null;

_move_highlight = false;

_attack_highlight = false;

_target_highlight = false;

_danger_highlight = false;

_danger_number = 0;

_support_highlight = false;

_move_cursor = false;

_danger_cursor = false;

set_coords = function(_x_coordinate, _y_coordinate){
	_x_coord = _x_coordinate;
	_y_coord = _y_coordinate;
}


set_entity = function(_entity_pointer){
	_entity_on_tile = _entity_pointer;
	_is_empty = false;
}

remove_entity = function(){
	_entity_on_tile = pointer_null;
	_is_empty = true;
}
