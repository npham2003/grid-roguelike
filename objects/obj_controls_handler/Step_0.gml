/// @description Insert description here
// You can write your code in this editor

global.other_controls = [input_binding_get("up"), input_binding_get("left"), input_binding_get("down"), input_binding_get("right"), input_binding_get("confirm"), input_binding_get("back"), input_binding_get("endturn")];
global.skill_controls = [input_binding_get("attack"), input_binding_get("skill1"), input_binding_get("skill2"), input_binding_get("skill3"), input_binding_get("wait")];

if(room_get_name(room)=="Initial"){
	room_goto(1);
}
