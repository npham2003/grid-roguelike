push_cursors = [];

function show_damage(_object, _damage) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_object.grid_pos[0],_object.grid_pos[1]);
	with instance_create_layer(current_coords[0] - 10, current_coords[1] - (20+ CELLHEIGHT), "DamageNumber", obj_damage_number) {
		damage_num = _damage;
	}
}

function shield_damage(_object, _damage) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_object.grid_pos[0],_object.grid_pos[1]);
	with instance_create_layer(current_coords[0] - 10, current_coords[1] - (20+ CELLHEIGHT), "DamageNumber", obj_shield_damage_number) {
		damage_num = _damage;
	}
}

function health_bar(health_x, health_y, percentage){
	draw_healthbar(health_x, health_y, health_x+20, health_y, percentage, c_white, c_red, c_red, 0, true, true)
	
}

hit_anim_index=[spr_hit, spr_explosion, spr_hit_electric, spr_charge, spr_defend, spr_push, spr_teleport_in, spr_teleport_out, spr_teleport_out_alt];

function hit_animation(_object, index) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_object.grid_pos[0],_object.grid_pos[1]);
	var animation = hit_anim_index[index];
	with instance_create_layer(current_coords[0], current_coords[1], "DamageNumber", obj_hit_animation) {
		sprite_index=animation;
	}
}

function hit_animation_coordinates(_x, _y, index) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_x,_y);
	var animation = hit_anim_index[index];
	with instance_create_layer(current_coords[0], current_coords[1], "DamageNumber", obj_hit_animation) {
		sprite_index=animation;
	}
}

function push_animation(_object, _rotation) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_object.grid_pos[0],_object.grid_pos[1]);
	var x_scale = 1;
	var y_scale = 1;
	var _angle = 0;
	switch(_rotation){
		case 1:
			_angle=90;
			break;
		case 2:
			x_scale=-1;
			break;
		case 3:
			_angle=90;
			x_scale=-1;
			break;
	}
	with instance_create_layer(current_coords[0], current_coords[1], "DamageNumber", obj_hit_animation) {
		sprite_index=spr_push;
		image_angle=_angle;
		
		image_xscale=x_scale;
		image_yscale=y_scale;
	}
}

function push_preview(_tile, _direction){
	var current_coords = obj_gridCreator.get_coordinates(_tile._x_coord,_tile._y_coord);
	var _image;
	switch(_direction){
		case 0:
			current_coords[0]+=50;
			_image = spr_push_right_arrow;
			break;
		case 1:
			current_coords[0]-=50;
			_image = spr_push_left_arrow;
			break;
		case 2:
			current_coords[1]+=25;
			_image = spr_push_down_arrow;
			break;
		case 3:
			current_coords[1]-=25;
			_image = spr_push_up_arrow;
			break;
	}

	push_cursor = instance_create_layer(current_coords[0], current_coords[1], "DamageNumber", obj_push_preview);
	with (push_cursor){
		sprite_index = _image;
	}
	array_push(push_cursors,push_cursor);
}

function remove_push_preview(){
	while (array_length(push_cursors)>0){
		var temp = push_cursors[0];
		instance_destroy(temp);
		array_delete(push_cursors,0,1);
	}
}