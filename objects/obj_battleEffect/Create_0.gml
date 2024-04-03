function show_damage(_object, _damage) { // show damage
	var current_coords = obj_gridCreator.get_coordinates(_object.grid_pos[0],_object.grid_pos[1]);
	with instance_create_layer(current_coords[0] - 10, current_coords[1] - (20+ CELLHEIGHT), "DamageNumber", obj_damage_number) {
		damage_num = _damage;
	}
}