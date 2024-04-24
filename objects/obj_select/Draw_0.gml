/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_chiaro);
draw_text_ext_transformed(100, 100, "Type numbers to put guys in your team\n1. Damage Guy\n2. Dancer Guy\n3. Teleport Guy\n4. Bomb Guy\n5. Freeze Guy", 50, 800, 1, 1, 0);

if(keyboard_check_pressed(vk_anykey)){
	if(keyboard_check_pressed(ord("1"))){
		array_push(party, 0);
	}
	if(keyboard_check_pressed(ord("2"))){
		array_push(party, 1);
	}
	if(keyboard_check_pressed(ord("3"))){
		array_push(party, 2);
	}
	if(keyboard_check_pressed(ord("4"))){
		array_push(party, 3);
	}
	if(keyboard_check_pressed(ord("5"))){
		array_push(party, 4);
	}

}

if(array_length(party)>=3){
	for( i=0;i<array_length(global.party);i++){
		global.party[i].info=global.players[party[i]];
		global.party[i].grid=[i,2];
	}
	room_goto_next();
}