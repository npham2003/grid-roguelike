/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < 5; i++) {
	menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 50, 0.2);
	optionAlpha = lerp(optionAlpha, state, 0.1);
}


if(open){
	if (state <= expansionLimit) {
		state += 0.5;
	}
}else{
	if (state >= expansionLimit) {
		state -= 0.5;
	}
}