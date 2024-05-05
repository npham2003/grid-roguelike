// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            up:    input_binding_key("W"),
            down:  input_binding_key("S"),
            left:  input_binding_key("A"),
            right: input_binding_key("D"),
            
            confirm:  input_binding_key(vk_enter),
            back:  input_binding_key(vk_backspace),
			
            first:  input_binding_key("H"),
            second: input_binding_key("J"),
			third: input_binding_key("K"),
			fourth: input_binding_key("L"),
            wait: input_binding_key("Y"),
			
			end_turn: input_binding_key(vk_space)
			
        },
        
        gamepad:
        {
            up:    [input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
            down:  [input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            left:  [input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
            right: [input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
            
            confirm: input_binding_gamepad_button(gp_start),
			back: input_binding_gamepad_button(gp_select),
			
			first:  input_binding_gamepad_button(gp_face1),
            second:  input_binding_gamepad_button(gp_face2),
            third:  input_binding_gamepad_button(gp_face3),
            fourth: input_binding_gamepad_button(gp_face4),
            wait: input_binding_gamepad_button(gp_shoulderrb),
			
			end_turn: input_binding_gamepad_button(gp_shoulderlb)
			
        }
    };
}