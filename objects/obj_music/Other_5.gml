/// @description Insert description here
if (instance_exists(obj_battleControl)) {
	audio_stop_sound(bgm_battleOfRuins);
} else {
	audio_stop_sound(bgm_tutorialBGM);
}