local wireframe_pulse = gui.Checkbox(gui.Reference("Visuals", "Other", "Extra"), "wireframepulse", "Wireframe Pulse on Shoot", false);
local wireframe_pulse_clr = gui.ColorPicker(gui.Reference("Visuals", "Other", "Extra", "Wireframe Pulse on Shoot"), "wireframepulseclr", "", 255, 255, 255, 255)
local wireframe_speed = gui.Slider(gui.Reference("Visuals", "Other", "Extra"), "wireframespeed", "Wireframe Pulse Speed", 6, 0, 25)
local do_pulse = false;

local function wireframePulseFunc()

    if wireframe_pulse:GetValue() == true and do_pulse == true then

        local r, g, b = wireframe_pulse_clr:GetValue()
        gui.SetValue("esp.chams.localweapon.overlay", 1);
        local o = 255
        o = math.floor(math.sin((globals.RealTime()) * wireframe_speed:GetValue()) * 68 + 112) - 44;
        gui.SetValue("esp.chams.localweapon.overlay.clr", r, g, b, o);
        
        if(o == 0) then

            do_pulse = false;

        end

    end

end

client.AllowListener("weapon_fire");
callbacks.Register("Draw", wireframePulseFunc);

callbacks.Register("FireGameEvent", function(event)

    if event:GetName() ~= "weapon_fire" then

        return;

    end

    local index = client.GetPlayerIndexByUserID(event:GetInt("userid"));
    local local_player = client.GetLocalPlayerIndex();

    if(index == local_player) then

        do_pulse = true;
        
    end

end)