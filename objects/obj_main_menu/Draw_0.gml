/// @description Insert description here
// You can write your code in this editor

draw_set_font(fnt_archivo);
draw_set_valign(fa_middle);
for(i=0;i<array_length(big_acronym);i++){
	draw_text_ext_transformed(200-italic_offset*i,50+line_spacing*i,big_acronym[i],50,10000,1,1,0);
	draw_text_ext_transformed(400-italic_offset*i,50+line_spacing*i,full_word[i],50,10000,0.5,0.5,0);
}
draw_set_valign(fa_top);
draw_set_font(fnt_chiaro);