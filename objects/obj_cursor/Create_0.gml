// hide the actual cursor
cursor_sprite=-1;
window_set_cursor(cr_none);

// initializes the timer for the cursor animation
alarm[0] = 60;

// start with the player deselected.
global.p_select = false;