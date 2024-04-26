if(curr < 3){
	if(keyboard_check_pressed(ord("1")) && !selected[0]){
		party[curr] = 0;
		curr++;
		selected[0] = true;
	}
	if(keyboard_check_pressed(ord("2")) && !selected[1]){
		party[curr] = 1;
		curr++;
		selected[1] = true;
	}
	if(keyboard_check_pressed(ord("3")) && !selected[2]){
		party[curr] = 2;
		curr++;
		selected[2] = true;
	}
	if(keyboard_check_pressed(ord("4")) && !selected[3]){
		party[curr] = 3;
		curr++;
		selected[3] = true;
	}
	if(keyboard_check_pressed(ord("5")) && !selected[4]){
		party[curr] = 4;
		curr++;
		selected[4] = true;
	}
	if(keyboard_check_pressed(ord("6")) && !selected[5]){
		party[curr] = 5;
		curr++;
		selected[5] = true;
	}
}

if (keyboard_check_pressed(vk_tab) && curr > 0) {
	curr--;
	selected[party[curr]] = false;
	party[curr] = -1;
}

if (keyboard_check_pressed(vk_enter) && curr == 3) {
	for(var i = 0; i < array_length(global.party); i++){
		global.party[i].info=global.players[party[i]];
		global.party[i].grid=[i, 2];
	}
	room_goto_next();
}