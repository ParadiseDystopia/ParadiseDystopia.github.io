local yaw_ref = gui.get_combobox("rage.antiaim.yaw")
local yaw_override_ref = gui.get_combobox("rage.antiaim.yaw_override")

local on_left, on_right = false;

local manual_left = { menu = gui.checkbox("rage.antiaim.manual_to_left", "rage.antiaim", "Manual Left"), value = nil}
local manual_right = { menu = gui.checkbox("rage.antiaim.manual_to_right", "rage.antiaim", "Manual Right"), value = nil}

manual_left.menu:add_callback( function( )
    yaw_ref:set_value( "View angle" );
    yaw_override_ref:set_value( "Right" );
    manual_left.val = manual_left.menu:get_value( );
    on_left = true;
    on_right = false;
end );

manual_right.menu:add_callback( function( )
    yaw_ref:set_value( "View angle" );
    yaw_override_ref:set_value( "Left" );
    manual_right.val = manual_right.menu:get_value( );
    on_left = false;
    on_right = true;
end );


function on_paint( )        
    if manual_left.val and on_left then
        yaw_ref:set_value( "View angle" );
        manual_right.menu:set_value( false );
    end

    if manual_right.val and on_right then
        yaw_ref:set_value( "View angle" );
        manual_left.menu:set_value( false );
    end

    if not manual_left.val and not manual_right.val then
        yaw_ref:set_value( "At target" );
        yaw_override_ref:set_value( "None" );
    end
end