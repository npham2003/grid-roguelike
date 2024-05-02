/// @description Insert description here
// You can write your code in this editor

//visualize();
//visualize_danger();
//visualize_danger_bool();

if(transition_in){
	if(x<0){
		x=5000;
	}
	x=lerp(x,room_width/2-(GRIDWIDTH)*50,0.1);
}else{
	
	x=lerp(x,-2000,0.05);
}