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

hit_anim_index=[spr_hit, spr_explosion, spr_hit_electric, spr_charge, spr_defend, spr_push];

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