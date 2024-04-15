alpha = 0;
actual_x=2500;
selector_pos=[0,0]
fill_alpha = 0;

descriptor_text = [["Heal 1 character for 1 HP","Gain 1 TP","Gain 1 extra TP each turn for 1 battle","Each attack does 1 extra damage for one battle"],["Upgrade one skill down path A","Upgrade one skill down path B","Reset a skill back to its default","Gain 1 random party member"]];

menu_level=0;

heal = function(unit){
	unit.hp+=1;
}

upgrade = function(unit, skill, path){
	unit.upgrades[skill]=path;
}

tp_bonus = function(){
	obj_battleControl.tp_bonus+=1;
}

attack_up = function(){
	for(i=0;i<array_length(obj_battleControl.player_units);i++){
		obj_battleControl.player_units[i].attack_bonus+=1;
	}
}

new_party_member = function(){
	var member = irandom(array_length(global.players)-1);
	obj_battleControl.spawn_unit(global.players[member]);
}