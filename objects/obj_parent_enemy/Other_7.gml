if (sprite_index == sprites.attack) {
	battlecontrol.in_animation = false;
	sprite_index = sprites.idle;
	image_index = 0;
	do_damage();
}