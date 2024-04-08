/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < skills; ++i) {
	menuX[i] = lerp(menuX[i], rootX + i * spacing * state + state * 200, 0.2);
	optionAlpha = lerp(optionAlpha, state, 0.1);
}

expandAnim = lerp(expandAnim, state, 0.2);

if (open) {
	state = 1;
}
else {
	state = 0;
}