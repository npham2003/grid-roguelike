controls_list = [];

for (var i = 0; i < array_length(global.other_controls); ++i) {
	array_push(controls_list, global.other_controls[i]);
}

for (var i = 0; i < array_length(global.skill_controls); ++i) {
	array_push(controls_list, global.skill_controls[i]);
}


rebind = function(action, _new) {
	input_binding_scan_start(function(_new) {
		input_binding_set_safe(action, _new);
	});
}