draw_set_font(fnt_chiaro);
_tutorial_text = "";
printout_Text = "";

length = string_length(_tutorial_text);

letterNextPage = 0;
jumpToNextPage = 240;
letter_Add = 0;

alarm[0] = 2;

paddingTop = 70;
paddingBottom = 15;
paddingSide = 370;


textSeperation = 40;
textBreakWidth = 1200;
textScale = 0.7;

textColor1 = c_black;
textColor2 = c_black;
textColor3 = c_black;
textColor4 = c_black;

textAlpha = 1;
image_alpha = 1;

tutorial_text = function(_new_text){
	_tutorial_text = _new_text;
}

kill = function(){
	image_alpha = 0;
	instance_destroy();
}