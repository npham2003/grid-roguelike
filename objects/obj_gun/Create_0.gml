is_dead = false;

// set entity on the grid

function despawn(){
	is_dead=true;
	obj_gridCreator.remove_entity(grid_pos[0],grid_pos[1]);
	remove_danger_highlights();
}