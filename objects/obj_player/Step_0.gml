/// @description Insert description here
// You can write your code in this editor
if(hp<=0){
	sprite_index=sprites.dead;
}else if(is_attacking){
	sprite_index=sprites.gun;
}else{
	sprite_index=sprites.idle;
}
new_coords = obj_gridCreator.get_coordinates(grid_pos[0],grid_pos[1]);
x = lerp(x, new_coords[0], 0.4);
y = lerp(y, new_coords[1], 0.4);