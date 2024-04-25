var hint_text = "Type numbers to put guys in your team\n";
hint_text += "Press Enter to confirm your selection\n";
hint_text += "Press Tab to cancel current selection\n";

for (var i = 0; i < array_length(member_name); i++) {
	hint_text += string(i + 1) + ". " + member_name[i] + "\n";
}

draw_set_font(fnt_chiaro);
draw_text_ext_transformed(100, 100, hint_text, 50, 800, 1, 1, 0);

var member_text = "";

for (var i = 0; i < array_length(party); i++) {
	if (i == 0) member_text += "1st: ";
	else if (i == 1) member_text += "2nd: ";
	else if (i == 2) member_text += "3rd: ";
	
	if (party[i] != -1) {
		member_text += member_name[party[i]];
	}
	
	member_text += "\n";
}
draw_text_ext_transformed(800, 300, member_text, 50, 800, 1, 1, 0);