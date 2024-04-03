/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < 4; i++) {
	menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 100, 0.2);
	optionAlpha = lerp(optionAlpha, state, 0.1);
}


if (state <= expansionLimit) {
	state += 1;
}

//if keyboard_check_pressed(vk_right) {
//	state += 1;
//}

//if keyboard_check_pressed(vk_left) {
//	state -= 1;
//}