
if(is_dead){
	obj_battleControl.in_animation=true;
	if(image_alpha==0){
		instance_destroy();
		obj_battleControl.in_animation=false;
	}
	image_alpha-=0.01;
	
}