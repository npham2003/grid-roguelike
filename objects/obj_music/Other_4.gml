/// @description Insert description here
if (instance_exists(obj_battleControl)) {
	audio_play_sound(bgm_battleOfRuins, 0, true);
} else {
	audio_play_sound(bgm_tutorialBGM, 0, true);
}