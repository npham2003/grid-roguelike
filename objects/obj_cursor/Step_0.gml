//place keyboard input here.
var mx = CELLSIZE/2;
var my = CELLSIZE/2;
var px = CELLSIZE*(obj_player.x / CELLSIZE);
var py = CELLSIZE*(obj_player.y / CELLSIZE);

if mx = px && my = py {
    show_debug_message("PLAYER SELECTED");
    global.p_select = true;
    with obj_player {
		//temp
	}
}
else {
    show_debug_message("PLAYER NOT SELECTED");
    global.p_select = false;
}