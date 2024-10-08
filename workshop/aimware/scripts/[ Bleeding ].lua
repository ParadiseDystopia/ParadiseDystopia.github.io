--@region HADLE_FOR_UPDATES
--really simple auto updater
local CURRENT_LUA_VERSION = 1.33;


print("Successfuly loaded: " .. CURRENT_LUA_VERSION .. " script version.")
--@endregion


--@region GUI
-------------------ANTI-AIM-------------------
local anti_aim_settings_tab = gui.Tab(gui.Reference("Ragebot"), "anti_aim_settings_tab", "Anti-Aim Settings Tab");

--___________mode selector_____________--
local anti_aim_mode_selector = gui.Groupbox(anti_aim_settings_tab, "Mode", 5, 10, 325, 450);

local advanced_mode = gui.Checkbox(anti_aim_mode_selector, "advanced_mode", "Advanced Mode", false);
--_____________________________________--


--_________condition selector__________--
local anti_aim_condition_selector = gui.Groupbox(anti_aim_settings_tab, "Condition", 5, 100, 325, 450);

local condition_selector = gui.Combobox(anti_aim_condition_selector, "condition_selector", "Select Condition", "General", "Standing",
                                                                                            "Ducking", "Slow Walking", "Moving", "In Air");
--_____________________________________--


--___________simple settings___________--
local anti_aim_simple_settings = gui.Groupbox(anti_aim_settings_tab, "Simple Settings", 5, 100, 325, 350);

local anti_aim_simple_settings_ui = 
{
    desync_type = gui.Combobox(anti_aim_simple_settings, "desync_type", "Desync Type", "Default Desync", "Desync Jitter"),
    desync_angle = gui.Combobox(anti_aim_simple_settings, "desync_angle", "Desync Angle", "Disabled", "Low", "Pred-Medium", "Medium", "Pred-High", "High", "Giant"),
    jitter_angle = gui.Combobox(anti_aim_simple_settings, "jitter_angle", "Jitter Angle", "Disabled", "Low", "Pred-Medium", "Medium", "Pred-High", "High", "Giant"),
    yaw_angle = gui.Slider(anti_aim_simple_settings, "yaw_angle", "Yaw Angle", 0, -180, 180, 1)
}
--_____________________________________--


--__________advanced settings___________--
local anti_aim_advanced_settings = gui.Groupbox(anti_aim_settings_tab, "Advanced Settings", 5, 210, 325, 350);

local anti_aim_names = {"general", "standing", "ducking", "slow_walking", "moving", "air"};
local anti_aim_elements = {};

local function createAntiAimGui()
    --iterating over anti-aim conditions and creating specify element for them
    for element = 1, #anti_aim_names, 1 do

        --names for gui objects
        local element_varname = anti_aim_names[element]

        local element_name = string.gsub((string.upper(string.sub(anti_aim_names[element], 1, 1)) .. string.sub(anti_aim_names[element], 2)), "%_", ' ')

        --creating condition array
        if not anti_aim_elements[element] then
            anti_aim_elements[element] = {}
        end

        local condition_array = anti_aim_elements[element]

        --override condition checkbox
        condition_array.override_condition = gui.Checkbox(anti_aim_advanced_settings, "override_condition_" .. element_varname, "Override " .. element_name, false)

        --desync
        condition_array.desync_type = gui.Combobox(anti_aim_advanced_settings, "desync_type_" .. element_varname, "Desync Type", "Default Desync", "Desync Jitter")

        condition_array.desync_modifier = gui.Combobox(anti_aim_advanced_settings, "desync_modifier_" .. element_varname, "Desync Modifier",
                                          "Static", "Random", "Jitter", "Isolated Jitter")

        condition_array.desync_range_right = gui.Slider(anti_aim_advanced_settings, "desync_range_right_" .. element_varname, "Desync Range Right", 0, 0, 58, 1)
        condition_array.desync_range_left = gui.Slider(anti_aim_advanced_settings, "desync_range_left_" .. element_varname, "Desync Range Left", 0, 0, 58, 1)

        --yaw
        condition_array.yaw_angle_right = gui.Slider(anti_aim_advanced_settings, "yaw_angle_right_" .. element_varname, "Yaw Angle Right", 0, -180, 180, 1)
        condition_array.yaw_angle_left = gui.Slider(anti_aim_advanced_settings, "yaw_angle_left_" .. element_varname, "Yaw Angle Left", 0, -180, 180, 1)

        condition_array.yaw_modifier = gui.Combobox(anti_aim_advanced_settings, "yaw_modifier_" .. element_varname, "Yaw Modifier",
                                       "Static", "Center Jitter", "Offset Jitter","Random Jitter", "Tank Jitter", "Random Tank Jitter", "Fake Flick")

        condition_array.yaw_modifier_range = gui.Slider(anti_aim_advanced_settings, "yaw_modifier_range_" .. element_varname, "Yaw Modifier Range", 0, 0, 180, 1)
        condition_array.yaw_modifier_speed = gui.Slider(anti_aim_advanced_settings, "yaw_modifier_speed_" .. element_varname, "Yaw Modifier Speed", 2, 2, 64, 1)
    end
end

--instantly call this function to create gui anti-aims on load
createAntiAimGui()
--_____________________________________--


--_________binds for anti-aims_________--
local anti_aim_binds = gui.Groupbox(anti_aim_settings_tab, "Binds", 340, 10, 290, 350);

local anti_aim_binds_ui = 
{
    --inverter
    desync_inverter = gui.Keybox(anti_aim_binds, "desync_inverter", "Desync Inverter", 70),

    --manuals
    manual_left = gui.Keybox(anti_aim_binds, "yaw_variables.manual_left", "Manual Left", 90),
    manual_back = gui.Keybox(anti_aim_binds, "yaw_variables.manual_back", "Manual Back", 88),
    manual_right = gui.Keybox(anti_aim_binds, "yaw_variables.manual_right", "Manual Right", 67),
    manual_forward = gui.Keybox(anti_aim_binds, "yaw_variables.manual_forward", "Manual Forward", 38)
};
--_____________________________________--


--___________other settings____________--
local anti_aim_other = gui.Groupbox(anti_aim_settings_tab, "Other", 340, 188, 290, 350);

local anti_aim_other_ui = 
{
    --autodirection
    at_targets = gui.Checkbox(anti_aim_other, "at_targets", "At Targets", false),
    at_edges = gui.Checkbox(anti_aim_other, "at_edges", "At Edges", false),

    --legit anti-aim
    legit_anti_aim = gui.Checkbox(anti_aim_other, "legit_anti_aim", "Legit Anti-Aim", false),
};
--_____________________________________--


--___________rage settings_____________--
local anti_aim_rage = gui.Groupbox(anti_aim_settings_tab, "Rage", 340, 350, 290, 350);

local anti_aim_rage_ui = 
{
    --exploits
    double_fire = gui.Checkbox(anti_aim_rage, "double_fire", "Double Fire", false),
    hide_shots = gui.Checkbox(anti_aim_rage, "hide_shots", "Hide Shots", false)
};
--_____________________________________--


--presets on bottom of the script
local anti_aim_presets_tab = gui.Tab(gui.Reference("Ragebot"), "anti_aim_presets_tab", "Anti-Aim Presets Tab");

----------------------------------------------


-------------------VISUALS--------------------

local visuals_tab = gui.Tab(gui.Reference("Visuals"), "visuals_tab", "Visuals Tab");

--______________hit info_______________--
local visuals_hit_info = gui.Groupbox(visuals_tab, "Hit Info", 5, 10, 325, 450);

local visuals_hit_info_ui = 
{
    world_hitmarker = gui.Checkbox(visuals_hit_info, "world_hitmarker", "World Hitmarker", false),
    world_damage_marker = gui.Checkbox(visuals_hit_info, "world_damage_marker", "World Damage Marker", false),
    screen_hitmarker = gui.Checkbox(visuals_hit_info, "screen_hitmarker", "Screen Hitmarker", false),
};


local world_hitmarker_color = gui.ColorPicker(visuals_hit_info_ui.world_hitmarker, "world_hitmarker_color", "", 255, 255, 255);
local world_damage_marker_color = gui.ColorPicker(visuals_hit_info_ui.world_damage_marker, "world_damage_marker_color", "", 255, 255, 255);
local world_damage_marker_color_headshot = gui.ColorPicker(visuals_hit_info_ui.world_damage_marker, "world_danage_marker_color_headshot", "", 255, 40, 40);
local screen_hitmarker_color = gui.ColorPicker(visuals_hit_info_ui.screen_hitmarker, "screen_hitmarker_color", "", 255, 255, 255);
--_____________________________________--

--_____________user info_______________--
local visuals_user_info = gui.Groupbox(visuals_tab, "User Info", 5, 175, 325, 450);

local visuals_user_info_ui = 
{
    keybinds = gui.Checkbox(visuals_user_info, "keybinds", "Keybinds", false),
    keybinds_position_x, keybinds_position_y,
    weapon_info = gui.Checkbox(visuals_user_info, "weapon_info", "Weapon Info", false),
    weapon_info_position_x, weapon_info_position_y,
    under_crosshair_indicator = gui.Checkbox(visuals_user_info, "under_crosshair_indicator", "Under Crosshair Indicator", false),
    watermark = gui.Checkbox(visuals_user_info, "watermark", "Watermark", false),
    color_theme = gui.Combobox(visuals_user_info, "color_theme", "Color Theme", "Black", "Gray")
};

local under_crosshair_indicator_color = gui.ColorPicker(visuals_user_info_ui.under_crosshair_indicator, "under_crosshair_indicator_color", "", 110, 110, 110, 255)
--_____________________________________--

--___________other visuals_____________--
local visuals_other = gui.Groupbox(visuals_tab, "Other", 340, 10, 290, 350);

local desync_side_indicator = gui.Checkbox(visuals_other, "desync_side_indicator", "Enable Desync Side Indicator", false)
local custom_scope = gui.Checkbox(visuals_other, "custom_scope", "Enable Custom Scope", false)

local visuals_other_ui = 
{
    custom_scope_color = gui.ColorPicker(custom_scope, "custom_scope_color", "", 255, 255, 255, 255),

    custom_scope_length = gui.Slider(visuals_other, "custom_scope_length", "Custom Scope Length", 120, 20, 400),
    custom_scope_indent = gui.Slider(visuals_other, "custom_scope_indent", "Custom Scope Indent", 20, 0, 300),

    desync_side_indicator_color_inactive = gui.ColorPicker(desync_side_indicator, "desync_side_indicator_color_inactive", "", 40, 40, 40, 200),
    desync_side_indicator_color_active = gui.ColorPicker(desync_side_indicator, "desync_side_indicator_color_active", "", 85, 125, 225, 200),

    gui.Text(visuals_other, "\n\t\t World Visuals\n"),

    view_model_changer = gui.Checkbox(visuals_other, "view_model_changer", "Enable Viewmodel Changer", false),
    view_model_changer_x = gui.Slider(visuals_other, "view_model_changer_x", "Viewmodel X", 0, -5, 5, 0.1),
    view_model_changer_y = gui.Slider(visuals_other, "view_model_changer_y", "Viewmodel Y", 0, -5, 5, 0.1),
    view_model_changer_z = gui.Slider(visuals_other, "view_model_changer_z", "Viewmodel Z", 0, -5, 5, 0.1),

    aspect_ratio = gui.Checkbox(visuals_other, "aspect_ratio", "Enable Aspectratio", false),
    aspect_ratio_value = gui.Slider(visuals_other, "aspect_ratio_value", "Aspectratio Value", 0, 0, 3, 0.05),

    world_modifications = gui.Checkbox(visuals_other, "world_modifications", "Enable World Modifications", false),
    world_modifications_exposure = gui.Slider(visuals_other, "world_modifications_exposure", "Exposure", 0, 0, 100, 1),
    world_modifications_ambient = gui.Slider(visuals_other, "world_modifications_ambient", "Ambient", 0, 0, 100, 1),
    world_modifications_bloom = gui.Slider(visuals_other, "world_modifications_bloom", "Bloom", 0, 0, 100, 1),
    world_modifications_ambient_color = gui.ColorPicker(visuals_other, "world_modifications_ambient_color", "Ambient Color", 0, 0, 0)
}

--_____________________________________--

--_____________screen size_____________--
local screen_width, screen_height;

local function getScreenSize()
    screen_width, screen_height = draw.GetScreenSize()
end
--_____________________________________--

----------------------------------------------


--------------------MISC----------------------
local misc_tab = gui.Tab(gui.Reference("Misc"), "misc_tab", "Misc Tab");

--_______________useful________________--
local misc_useful = gui.Groupbox(misc_tab, "Useful", 5, 10, 325, 450);

local misc_useful_ui =
{
    adaptive_autoscope = gui.Checkbox(misc_useful, "adaptive_autoscope", "Enable Adaptive Autoscope", false),
    static_arms = gui.Checkbox(misc_useful, "static_arms", "Enable Static Arms", false),
    viewmodel_in_scope = gui.Checkbox(misc_useful, "viewmodel_in_scope", "Enable Viewmodel In Scope", false)
}

--_____________________________________--

--_______________events________________--
local misc_events = gui.Groupbox(misc_tab, "Events", 5, 180, 325, 450);

local misc_events_ui = 
{
    buy_bot = gui.Checkbox(misc_events, "buy_bot", "Enable Buy Bot", false),
    buy_bot_primary = gui.Combobox(misc_events, "buy_bot_primary", "Buy Bot Primary", "Nothing", "Autosniper", "AWP", "Scout"),
    buy_bot_secondary = gui.Combobox(misc_events, "buy_bot_secondary", "Buy Bot Secondary", "Nothing", "Heavy Pistol", "Elite", "Fast Pistol", "P250"),
    buy_bot_extra = gui.Multibox(misc_events, "Buy Bot Extra")
}

local buy_bot_extra_ui =
{
    buy_bot_extra_nades = gui.Checkbox(misc_events_ui.buy_bot_extra, "buy_bot_extra_nades", "Nades", false),
    buy_bot_extra_defuser = gui.Checkbox(misc_events_ui.buy_bot_extra, "buy_bot_extra_defuser", "Defuser", false),
    buy_bot_extra_taser = gui.Checkbox(misc_events_ui.buy_bot_extra, "buy_bot_extra_taser", "Taser", false),
    buy_bot_extra_helmet = gui.Checkbox(misc_events_ui.buy_bot_extra, "buy_bot_extra_helmet", "Helmet", false),
    buy_bot_extra_kevlar = gui.Checkbox(misc_events_ui.buy_bot_extra, "buy_bot_extra_kevlar", "Kevlar", false)
}
--_____________________________________--
----------------------------------------------

-------------------LAGSYNC--------------------

--__________custom lagsync_____________--
local custom_lagsync_tab = gui.Tab(gui.Reference("Ragebot"), "custom_lagsync_tab", "Anti-Aim Lagsync Tab");

local stages_of_lagsync = gui.Groupbox(custom_lagsync_tab, "Stages of Lagsync", 5, 10, 325, 50);

local lagsync_enable = gui.Checkbox(stages_of_lagsync, "lagsync_enable", "Enable Lagsync", false)
local elements_box = gui.Multibox(stages_of_lagsync, "Select Stage To Edit");
--_____________________________________--

----------------------------------------------
--@endregion





--@region MATH
--returning sum of array elements from first to last indexes
local function sumFromTo(array, first_sum, last_sum)

    local sum = 0

    for counter = first_sum, last_sum, 1 do
        sum = sum + array[counter]
    end

    return sum
end
--@endregion





--@region PROTECTED_CONVARS_PROPS_GUI
--there safe props and convars and gui:SetInvisible(), cuz they are should be installed once

local convar_array = {}

local function setConvar(name, value)

    --checking for convar value is new
    if value and value ~= convar_array[name] or not convar_array[name] then

        --print(name .. " convar installed to the value: " .. value)
        client.SetConVar(name, value, true)
        convar_array[name] = value
   end
end

local prop_array = {}

local function setProp(entity, name, value)

    --checking for prop value is new
    if value and value ~= prop_array[name] or not prop_array[name] then

        --print(name .. " prop installed to the value: " .. value)
        entity:SetProp(name, value)
        prop_array[name] = value
   end
end

local gui_array = {}

local function setInvisible(gui_element, value)

    --checking for convar value is new
    if value and value ~= gui_array[name] or not gui_array[name] then

        --print(name .. " convar installed to the value: " .. value)
        gui_element:SetInvisible(value)
        gui_array[gui_element] = value
   end
end
--@endregion


--@region PROTECTED_CONVARS_PROPS_GUI
--_____________sliders ui______________--
local function slidersUi()

    --creating position sliders later cuz they are need our screen size
    if screen_width and screen_height then
        visuals_user_info_ui.keybinds_position_x = gui.Slider(visuals_user_info, "keybinds_position_x", "Keybinds Postion X", 300, 0, screen_width) 
        visuals_user_info_ui.keybinds_position_y = gui.Slider(visuals_user_info, "keybinds_position_y", "Keybinds Postion Y", 400, 0, screen_height)

        setInvisible(visuals_user_info_ui.keybinds_position_x, true)
        setInvisible(visuals_user_info_ui.keybinds_position_y, true) 

        visuals_user_info_ui.weapon_info_position_x = gui.Slider(visuals_user_info, "weapon_info_position_x", "Weapon Info Postion X", 500, 0, screen_width)
        visuals_user_info_ui.weapon_info_position_y = gui.Slider(visuals_user_info, "weapon_info_position_y", "Weapon Info Postion Y", 400, 0, screen_height)

        setInvisible(visuals_user_info_ui.weapon_info_position_x, true)
        setInvisible(visuals_user_info_ui.weapon_info_position_y, true)
    end
end

local function createScreenSizeBasedUi()

    --this function require Draw callback to get screen sizes
    if not screen_width or not screen_height then
        getScreenSize()
        slidersUi()
    end
end
--_____________________________________--
--@endregion


--@region USEFUL_VALUES

--variables, that using more than 1 time
local handler_variables = 
{
    --constant
    TICK_TIME = 1 / 64, 
    FL_ONGROUND = bit.lshift(1, 0), 
    FL_DUCKING = bit.lshift(1, 1), 
    SHORT_WEAPON_GROUP =  {pistol = {2, 3, 4, 30, 32, 36, 61, 63}, 
                             sniper = {9}, 
                             scout = {40}, 
                             hpistol = {1, 64}, 
                             smg = {17, 19, 23, 24, 26, 33, 34}, 
                             rifle = {60, 7, 8, 10, 13, 16, 39}, 
                             shotgun = {25, 27, 29, 35}, 
                             asniper = {38, 11}, 
                             lmg = {28, 14},
                             zeus = {31}
    }, 

    --non constant
    mouse_pos = {}, 
    advanced_mode_enabled = false,
    real_time = 1,
    tick_count = 1,
    cur_time = 1,
    jitter_switch_time = 0,
    desync_switch_time = 0,
    fps = 0,
    tickrate_ip_updated = false,
    tickrate = client.GetConVar("sv_maxcmdrate"),
    server = "",
    user_name = cheat.GetUserName(),
    fps_per_second = 400;
    current_weapon_group = "shared";
}

--keybinds states handlers
local functions_states = {}
local constants = {}
local props = {}

--getting current weapon group to use it
local function getWeaponGroup()
    if not handler_variables.local_entity or not handler_variables.local_entity:IsAlive() then
        return "shared"
    end

    --get current weapon group
    local local_weapon_id = handler_variables.local_entity:GetWeaponID()

    --iterating over weapon groups
    for group_name, group_weapons in pairs(handler_variables.SHORT_WEAPON_GROUP) do

        --iterating over all weapon ids in weapon grops
        for weapon_id = 1, #group_weapons, 1 do

            --if weapon id == our weapon rerunring group
            if local_weapon_id == group_weapons[weapon_id] then

                return group_name
            end
        end
    end

    --returning shared if not find weapon group
    return "shared"
end

--returning local player condition like moving, in air etc.
local function getAntiAimCondition()

    --if our entity is not valid then returning general
    if not handler_variables.local_entity or not handler_variables.local_entity:IsAlive() or not props.m_flags then
        return 1 --general
    end

    --props.m_flags positions are basing on bitwise operator
    local in_air = ((bit.band(props.m_flags, handler_variables.FL_ONGROUND)) == 0)
    local ducking = ((bit.band(props.m_flags, handler_variables.FL_DUCKING)) == 2)
    ----------------------

    --get anti-aim condition
    if (props.velocity <= 10) and not ducking and not in_air and anti_aim_elements[2].override_condition:GetValue() then

        return 2 --standing

    elseif (ducking or functions_states.fake_duck_active) 
           and not in_air and anti_aim_elements[3].override_condition:GetValue() then

        return 3 --ducking

    elseif (props.velocity > 10) and functions_states.slow_walk_active
           and not ducking and not in_air and anti_aim_elements[4].override_condition:GetValue() then

        return 4 --slow walking

    elseif (props.velocity > 10) and not functions_states.slow_walk_active
           and not ducking and not in_air and anti_aim_elements[5].override_condition:GetValue() then

        return 5 --moving

    elseif in_air and anti_aim_elements[6].override_condition:GetValue() then

        return 6 --air

    else
        return 1 --general
    end
end

--handling all varialbles, that using more that 1 time
local function handlers()

    --entities
    handler_variables.local_entity = entities.GetLocalPlayer()
    handler_variables.current_weapon_group = getWeaponGroup()

    --time
    handler_variables.real_time = globals.RealTime();
    handler_variables.tick_count = globals.TickCount();
    handler_variables.cur_time = globals.CurTime()

    --anti_aims
    handler_variables.anti_aim_condition = getAntiAimCondition()
    handler_variables.advanced_mode_enabled = advanced_mode:GetValue()

    handler_variables.jitter_switch_time = functions_states.double_tap_active and anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_speed:GetValue() 
                                            or handler_variables.fake_lag_factor;

    handler_variables.desync_switch_time = functions_states.double_tap_active and 2 or handler_variables.fake_lag_factor

    --visuals
    handler_variables.fps = (1 / globals.AbsoluteFrameTime()) >= 1000 and 999 or (1 / globals.AbsoluteFrameTime())

    if globals.TickCount() % 32 == 0 then
        handler_variables.fps_per_second = handler_variables.fps
    end

    handler_variables.mouse_pos = {input.GetMousePos()}

    --local info
    if handler_variables.local_entity then

        props.m_flags = handler_variables.local_entity:GetProp("m_fFlags")
        props.velocity = handler_variables.local_entity:GetPropVector("localdata", "m_vecVelocity[0]"):Length()
        props.ping = entities:GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
        props.is_scoped = handler_variables.local_entity:GetPropBool("m_bIsScoped")
        props.tone_map_controller = entities.FindByClass('CEnvTonemapController')[1]

        --updating tickrate after reconnecting 
        if not handler_variables.tickrate_ip_updated then
            handler_variables.server_ip = engine.GetServerIP()
            handler_variables.tickrate = client.GetConVar("sv_maxcmdrate")

            handler_variables.tickrate_ip_updated = true
        end

        --getting server type by his ip
        if handler_variables.server_ip == "loopback" then
            handler_variables.server = "localhost"
        elseif string.find(handler_variables.server_ip, "A") then
            handler_variables.server = "valve"    
        else
            handler_variables.server = handler_variables.server_ip
        end


        --calculating fake lag factor to correct work of jitters speed
        handler_variables.fake_lag_factor = 2 + math.floor(1 + (globals.CurTime() - handler_variables.local_entity:GetPropFloat("m_flSimulationTime")) / globals.TickInterval())
    else

        --showing, that we should change tickrate after reconnect
        handler_variables.tickrate_ip_updated = false
    end
end

--getting all states of keybinds
local function getKeybindsStates()

    --RAGE functions
    functions_states.double_tap_active = (handler_variables.current_weapon_group ~= "zeus" and 
    (                                   gui.GetValue("rbot.accuracy.attack." .. handler_variables.current_weapon_group .. ".fire") == '"Defensive Warp Fire"')
                                        or (gui.GetValue("rbot.accuracy.attack.shared.fire") == '"Defensive Warp Fire"'))

    functions_states.hide_shots_active = (handler_variables.current_weapon_group ~= "zeus" and 
                                         (gui.GetValue("rbot.accuracy.attack." .. handler_variables.current_weapon_group .. ".fire") == '"Shift Fire"')
                                         or (gui.GetValue("rbot.accuracy.attack.shared.fire") == '"Shift Fire"'))

    functions_states.fake_duck_active = cheat.IsFakeDucking()

    functions_states.slow_walk_active = gui.GetValue("rbot.accuracy.movement.slowkey") ~= 0 and input.IsButtonDown(gui.GetValue("rbot.accuracy.movement.slowkey"))
    functions_states.third_person_active = gui.GetValue("esp.world.thirdperson")
    functions_states.fake_latency_active = gui.GetValue("misc.fakelatency.enable") and (gui.GetValue("misc.fakelatency.amount") > 0)
    functions_states.edge_jump_active = gui.GetValue("misc.edgejump") ~= 0 and input.IsButtonDown(gui.GetValue("misc.edgejump"))

    --LEGIT functions
    functions_states.autowall_active = gui.GetValue("lbot.weapon.vis." .. handler_variables.current_weapon_group .. ".autowall")
    functions_states.aimbot_active = gui.GetValue("lbot.aim.enable")
    functions_states.auto_fire_active = gui.GetValue("lbot.aim.autofire")
    functions_states.triggerbot_active = gui.GetValue("lbot.trg.enable") and (gui.GetValue("lbot.trg.key") ~= 0 and input.IsButtonDown(gui.GetValue("lbot.trg.key")))
    functions_states.backtrack_active = gui.GetValue("lbot.posadj.backtrack") and (gui.GetValue("lbot.extra.backtrack") > 0)
    functions_states.legit_aa_active = (gui.GetValue("lbot.antiaim.type") ~= '"Off"')
    functions_states.resolver_active = gui.GetValue("lbot.posadj.resolver")
end
--@endregion






--@region ANTI_AIM_FUNCTIONS

--clamping yaw between -180 and 180
local function clampYaw(yaw)

    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

--inverting desync 
local desync_inverted = false

local function invertDesync()

    if anti_aim_binds_ui.desync_inverter:GetValue() ~= 0 and input.IsButtonPressed(anti_aim_binds_ui.desync_inverter:GetValue()) then

        --inverting
        desync_inverted = not desync_inverted
    end
end
--@endregion


--@region EDIT_GUI

--just a function which controlling gui visibility in some cases
local function changeGui()

    setInvisible(anti_aim_advanced_settings, not handler_variables.advanced_mode_enabled)
    setInvisible(anti_aim_condition_selector, not handler_variables.advanced_mode_enabled)
    setInvisible(anti_aim_simple_settings, handler_variables.advanced_mode_enabled)

    --make invisible not selected elements
    for condition = 1, #anti_aim_elements, 1 do

        --iterating over all elements in condition
        for _, element in pairs(anti_aim_elements[condition]) do

            if (condition_selector:GetValue() + 1) then

                setInvisible(element, (condition_selector:GetValue() + 1) ~= condition)
            end
        end
    end

    setInvisible(anti_aim_elements[1].override_condition, true)


    setInvisible(visuals_other_ui.custom_scope_length, not custom_scope:GetValue())
    setInvisible(visuals_other_ui.custom_scope_indent, not custom_scope:GetValue())

    setInvisible(visuals_other_ui.view_model_changer_x, not visuals_other_ui.view_model_changer:GetValue())
    setInvisible(visuals_other_ui.view_model_changer_y, not visuals_other_ui.view_model_changer:GetValue())
    setInvisible(visuals_other_ui.view_model_changer_z, not visuals_other_ui.view_model_changer:GetValue())

    setInvisible(visuals_other_ui.aspect_ratio_value, not visuals_other_ui.aspect_ratio:GetValue())

    setInvisible(visuals_other_ui.world_modifications_exposure, not visuals_other_ui.world_modifications:GetValue())
    setInvisible(visuals_other_ui.world_modifications_bloom, not visuals_other_ui.world_modifications:GetValue())
    setInvisible(visuals_other_ui.world_modifications_ambient, not visuals_other_ui.world_modifications:GetValue())
    setInvisible(visuals_other_ui.world_modifications_ambient_color, not visuals_other_ui.world_modifications:GetValue())

    setInvisible(misc_events_ui.buy_bot_primary, not misc_events_ui.buy_bot:GetValue())
    setInvisible(misc_events_ui.buy_bot_secondary, not misc_events_ui.buy_bot:GetValue())
    setInvisible(misc_events_ui.buy_bot_extra, not misc_events_ui.buy_bot:GetValue())
end
--@endregion


--@region YAW_MODIFIERS
local static_yaw_time = 0;
local jitter_side_swapper = 1;

local jitter_yaw = 0;
local random_yaw = 0;

--all jitter types, swapper works like side switcher
local function staticJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 0 then
        jitter_yaw = 0
    end
end

local function centerJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 1 then
        if handler_variables.real_time - static_yaw_time >= (handler_variables.jitter_switch_time * handler_variables.TICK_TIME) then

            jitter_yaw = (anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_range:GetValue() / 2) * jitter_side_swapper

            jitter_side_swapper = -jitter_side_swapper   
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function offsetJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 2 then
        if handler_variables.real_time - static_yaw_time >= (handler_variables.jitter_switch_time * handler_variables.TICK_TIME) then

            jitter_yaw = jitter_side_swapper > 0 and anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_range:GetValue() or 0

            jitter_side_swapper = -jitter_side_swapper   
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function randomJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 3 then
        if handler_variables.real_time - static_yaw_time >= (handler_variables.jitter_switch_time * handler_variables.TICK_TIME) then

            jitter_yaw = (math.random(0, anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_range:GetValue()) / 2) * jitter_side_swapper

            jitter_side_swapper = -jitter_side_swapper   
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function tankJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 4 then
        if handler_variables.real_time - static_yaw_time >= (handler_variables.jitter_switch_time * handler_variables.TICK_TIME) then

            jitter_yaw = ((anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_range:GetValue() + math.random(-12, 12)) / 2) * jitter_side_swapper

            jitter_side_swapper = -jitter_side_swapper
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function randomTankJitter()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 5 then
        if handler_variables.tick_count % 32 == 0 then
            random_yaw = math.random(0, anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier_range:GetValue()) / 2
        end

        if handler_variables.real_time - static_yaw_time >= (handler_variables.jitter_switch_time * handler_variables.TICK_TIME) then
            jitter_yaw = (random_yaw + math.random(-6, 6)) * jitter_side_swapper

            jitter_side_swapper = -jitter_side_swapper
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function fakeFlick()

    if anti_aim_elements[handler_variables.anti_aim_condition].yaw_modifier:GetValue() == 6 then
        if handler_variables.real_time - static_yaw_time >= ((jitter_side_swapper > 0 and 1 or handler_variables.jitter_switch_time) * handler_variables.TICK_TIME) then
            jitter_yaw = (jitter_side_swapper > 0 and 0 or (desync_inverted and 100 or -100))

            jitter_side_swapper = -jitter_side_swapper
            static_yaw_time = handler_variables.real_time
        end
    end
end

local function callJitterFunctions()

    if handler_variables.advanced_mode_enabled then
        staticJitter()
        centerJitter();
        offsetJitter();
        randomJitter();
        tankJitter();
        randomTankJitter();
        fakeFlick();
    end
end
--@endregion


--@region YAW_MANUALS

--all yaw function, which using binds
local yaw_variables = 
{
    legit_yaw = 0, 
    manual_yaw = 0, 
    manual_right = false, 
    manual_back = false,
    manual_left = false, 
    manual_forward = false
}

--manual types
local manuals_keys = 
{   
    anti_aim_binds_ui.manual_left, anti_aim_binds_ui.manual_back, 
    anti_aim_binds_ui.manual_right, anti_aim_binds_ui.manual_forward
};
--manual keyboxes
local manuals_values = {yaw_variables.manual_left, yaw_variables.manual_back, yaw_variables.manual_right, yaw_variables.manual_forward};

--manual values
constants.MANUAL_YAW_VALUES = {-90, 0, 90, 180};

--function, that showing, have we active manuals or not
local function isManualActive()

    --iterating over all manuals keyboxes 
    for manual = 1, #manuals_values, 1 do

        --if keybox active then returning, that manual active and his number
        if manuals_values[manual] then

            return {true, manual}
        end
    end

    --else returning, that manuals inactive
    return {false, nil}
end

--setting manuals
local function manualAntiAims()

    --iterating over all manual keyboxes
    for manual = 1, #manuals_keys, 1 do

        --if its active then
        if manuals_keys[manual]:GetValue() ~= 0 and input.IsButtonPressed(manuals_keys[manual]:GetValue()) then

            --switching manual
            manuals_values[manual] = not manuals_values[manual]

            --if manual active then disable other manuals
            if manuals_values[manual] then

                --iterating over all other manuals to disable them
                for i = 1, #manuals_values, 1 do

                    --when current ~= active manual
                    if i ~= manual then

                        --setting it inactive
                        manuals_values[i] = false
                    end
                end
            end
        end
    end
end

--calculating yaw of manuals
local function calculateManualYaw()

    --if manual is not active
    if anti_aim_other_ui.legit_anti_aim:GetValue() or not isManualActive()[1] then
        yaw_variables.manual_yaw = 0

    --if its active
    else
        yaw_variables.manual_yaw = constants.MANUAL_YAW_VALUES[isManualActive()[2]]
    end
end 

--legit aa base
local function legitAntiAims()

    --legit yaw its 180, when legit aa is active
    yaw_variables.legit_yaw = anti_aim_other_ui.legit_anti_aim:GetValue() and 180 or 0
end

--controling pitch, at targets, at edjes, based on legit aa and manuals
local function controleAntiAimStates()

    local pitch_state;
    local at_targets_state;
    local at_edjes_state;

    if anti_aim_other_ui.legit_anti_aim:GetValue() then

        pitch_state = 0
        at_targets_state = false
        at_edjes_state = false
        gui.SetValue("rbot.antiaim.condition.use", false)

    elseif not anti_aim_other_ui.legit_anti_aim:GetValue() and isManualActive()[1] then

        pitch_state = 1
        at_targets_state = false
        at_edjes_state = false

    elseif not anti_aim_other_ui.legit_anti_aim:GetValue() and not isManualActive()[1] then

        pitch_state = 1
        at_targets_state = anti_aim_other_ui.at_targets:GetValue()
        at_edjes_state = anti_aim_other_ui.at_edges:GetValue()    
    end

    gui.SetValue("rbot.antiaim.advanced.pitch", pitch_state)
    gui.SetValue("rbot.antiaim.condition.autodir.targets", at_targets_state)
    gui.SetValue("rbot.antiaim.condition.autodir.edges", at_edjes_state)
end

--calling all manuals functions
local function callManualsFunctions()
    manualAntiAims();
    calculateManualYaw();
    legitAntiAims();
    controleAntiAimStates();
end
--@endregion


--@region MAIN_YAW 
local main_yaw = 0;

--calculating main yaw, which basing on yaw right and left
local function calculateMainYaw()

    --checking for advanced mode
    if handler_variables.advanced_mode_enabled then
        main_yaw = desync_inverted and anti_aim_elements[handler_variables.anti_aim_condition].yaw_angle_right:GetValue() or anti_aim_elements[handler_variables.anti_aim_condition].yaw_angle_left:GetValue()
    else
        main_yaw = desync_inverted and anti_aim_simple_settings_ui.yaw_angle:GetValue() or -anti_aim_simple_settings_ui.yaw_angle:GetValue()
    end
end
--@endregion


--@region DESYNC_TYPE

--showing which desync type is selected
local function getDesyncType()

    return ((anti_aim_elements[handler_variables.anti_aim_condition].desync_type:GetValue() == 0 and handler_variables.advanced_mode_enabled) 
            or (anti_aim_simple_settings_ui.desync_type:GetValue() == 0  and not handler_variables.advanced_mode_enabled)) and " Desync" or " Desync Jitter"
end
--@endregion 


--@region SIMPLE_JITTER
local jitter_angle_simple = 0;

--jitter, that using in simple preset
local function simpleJitter()

    if not handler_variables.advanced_mode_enabled and handler_variables.real_time - static_yaw_time >= (handler_variables.desync_switch_time * handler_variables.TICK_TIME) then

        jitter_angle_simple = (10 * anti_aim_simple_settings_ui.jitter_angle:GetValue()) * jitter_side_swapper

        jitter_side_swapper = -jitter_side_swapper   
        static_yaw_time = handler_variables.real_time
    end
end
--@endregion


--@region SET_FINISH_YAW
local current_jitter_angle = 0;

--setting all yaws
local function setYaw()

    --isolated dessync jitter disabling all yaw jitters
    if anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 3 then
        current_jitter_angle = 0
    end

    --getting current yaw, based on advanced preset is enabled or not
    current_jitter_angle = handler_variables.advanced_mode_enabled and jitter_yaw or jitter_angle_simple

    gui.SetValue("rbot.antiaim.base", tostring(clampYaw(180 + current_jitter_angle + yaw_variables.manual_yaw + yaw_variables.legit_yaw + main_yaw)) .. getDesyncType())
end
--@endregion


--@region DESYNC_MODIFIERS
local static_desync_time = globals.RealTime();
local desync_side_swapper = 1;

local desync_angle = 0;

--desync_side_swapper the same with jitter_side_swapper
local function staticDesync()

    if anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 0 or anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 2 then
        desync_angle = desync_inverted and -anti_aim_elements[handler_variables.anti_aim_condition].desync_range_right:GetValue() 
                       or anti_aim_elements[handler_variables.anti_aim_condition].desync_range_left:GetValue()
    end 
end

local function randomDesync()

    if anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 1 then
        if handler_variables.tick_count % 64 == 0 then

            desync_angle = desync_inverted
                            and -math.random(0, anti_aim_elements[handler_variables.anti_aim_condition].desync_range_right:GetValue()) 
                            or math.random(0, anti_aim_elements[handler_variables.anti_aim_condition].desync_range_left:GetValue())
        end
    end
end

local function jitterDesync()

    if anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 2 then
        if handler_variables.real_time - static_desync_time >= (handler_variables.desync_switch_time * handler_variables.TICK_TIME) then
            desync_inverted = not desync_inverted

            static_desync_time = handler_variables.real_time
        end
    end
end

local function isolatedJitterDesync()

    if anti_aim_elements[handler_variables.anti_aim_condition].desync_modifier:GetValue() == 3 then
        if handler_variables.real_time - static_desync_time >= (handler_variables.desync_switch_time * handler_variables.TICK_TIME) then

            desync_angle = desync_side_swapper > 0 and -anti_aim_elements[handler_variables.anti_aim_condition].desync_range_right:GetValue() 
            or anti_aim_elements[handler_variables.anti_aim_condition].desync_range_left:GetValue()

            desync_side_swapper = desync_side_swapper * -1
            static_desync_time = handler_variables.real_time
        end
    end
end

local function callDesyncFunctions()

    if advanced_mode then
        staticDesync();
        jitterDesync();
        isolatedJitterDesync();
        randomDesync()
    end
end
--@endregion


--@region SIMPLE_DESYNC
local desync_angle_simple = 0;
constants.DESYNC_ANGLE_PER_POSITION = 9.68;

--desync, which using in simple preset
local function simpleDesync()

    if not handler_variables.advanced_mode_enabled then

        desync_angle_simple = desync_inverted 
                                and -math.floor(constants.DESYNC_ANGLE_PER_POSITION * anti_aim_simple_settings_ui.desync_angle:GetValue()) 
                                or math.floor(constants.DESYNC_ANGLE_PER_POSITION * anti_aim_simple_settings_ui.desync_angle:GetValue())
    end
end
--@endregion


--@region SET_FINISH_DESYNC

--setting desync rage
local function setDesync()
    gui.SetValue("rbot.antiaim.base.rotation", handler_variables.advanced_mode_enabled and desync_angle or desync_angle_simple)
end
--@endregion





--@region RAGE_PART

--separate binds for HS and DT
local function setExploits()

    if handler_variables.current_weapon_group ~= "zeus" then

        local exploit_state;

        if anti_aim_rage_ui.double_fire:GetValue() then
            exploit_state = "Defensive Warp Fire"
        elseif anti_aim_rage_ui.hide_shots:GetValue() and not anti_aim_rage_ui.double_fire:GetValue() then
            exploit_state = "Shift Fire"
        else
            exploit_state = "Off" 
        end

        gui.SetValue("rbot.accuracy.attack." .. handler_variables.current_weapon_group .. ".fire", exploit_state)
        gui.SetValue("rbot.accuracy.attack.shared.fire", exploit_state)
    end
end
--@endregion


--@region CUSTOM_DRAW_FUNCTIONS
local function segment(pos_x, pos_y, angle_1, angle_2, start_size, last_size, color)

    for i = angle_1, angle_2, 1 do
        draw.Color(color[1], color[2], color[3], 255)
        draw.Line(pos_x + (math.sin(math.rad(i)) * (start_size - 1)), pos_y + (math.cos(math.rad(i)) * (start_size - 1)), 
                  pos_x + (math.sin(math.rad(i)) * (last_size + 1)), pos_y + (math.cos(math.rad(i))* (last_size + 1)))
     end
end

local function gradientRectRight(position_x, position_y, lenght, width, color)

    if not color[4] then color[4] = 255 end

    if color[4] <= 0 then
        return
    end

    local lenght = color[4] / lenght

    for step = color[4], 0, -lenght do
        draw.Color(color[1], color[2], color[3], step)
        draw.FilledRect(position_x, position_y, position_x + 1, position_y + width)

        position_x = position_x + 1
    end
end

local function gradientRectLeft(position_x, position_y, lenght, width, color)

    if not color[4] then color[4] = 255 end

    if color[4] <= 0 then
        return
    end

    local lenght = color[4] / lenght

    for step = color[4], 0, -lenght do
        draw.Color(color[1], color[2], color[3], step)
        draw.FilledRect(position_x, position_y, position_x - 1, position_y + width)

        position_x = position_x - 1
    end
end

local function gradientRectUp(position_x, position_y, lenght, width, color)

    if not color[4] then color[4] = 255 end

    if color[4] <= 0 then
        return
    end

    local lenght = color[4] / lenght

    for step = color[4], 0, -lenght do
        draw.Color(color[1], color[2], color[3], step)
        draw.FilledRect(position_x, position_y, position_x + width, position_y - 1)

        position_y = position_y - 1
    end
end

local function gradientRectDown(position_x, position_y, lenght, width, color)

    if not color[4] then color[4] = 255 end

    if color[4] <= 0 then
        return
    end

    local lenght = color[4] / lenght

    for step = color[4], 0, -lenght do
        draw.Color(color[1], color[2], color[3], step)
        draw.FilledRect(position_x, position_y, position_x + width, position_y + 1)

        position_y = position_y + 1
    end
end

local function outlinedText(position_x, position_y, text, font, color, font_outlined, color_outlined)

    draw.SetFont(font_outlined)
    draw.Color(color_outlined[1], color_outlined[2], color_outlined[3], color_outlined[4])
    draw.Text(position_x, position_y, text)

    draw.SetFont(font)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.Text(position_x, position_y, text)
end
--@endregion


--@region ANIMATION_SCALE
local MIDDLE_FPS_ANIMATION_VALUE = 450;

--calculating our animation's scale based on frametime, if u have 450 fps - ur animation scale is 1
local function getAnimationScale()
    return MIDDLE_FPS_ANIMATION_VALUE / handler_variables.fps
end
--@endregion





--@region VISUALS
local fonts = 
{
    keybinds_font = draw.CreateFont("Verdana", 12, 750),
    keybinds_font_outlined = draw.CreateFont("Verdana", 12, 750, 1),
    emoji_font = draw.CreateFont("Tahoma", 22),
    world_damage_font = draw.CreateFont("Bahnschrift", 18)
}

local preparation_finished = false;
local load_time = globals.RealTime()

--there random time of preparation
local preparation_time = math.random(15, 30) / 10

constants.PREPARATION_DELAY = 0.75

--preparing script for loading, creating all gui
local function scriptPreparing()

    local delta_time = handler_variables.real_time - load_time

    if not preparation_finished then
        --progress bar
        local progress_of_preparing = (delta_time > preparation_time) and 360 or 360 * (delta_time / preparation_time)

        --color changing on end of preparation
        local color = (delta_time > preparation_time) and {20, 255, 20, 180} or {230, 230, 230, 180}

        segment(screen_width / 2, screen_height / 2, 180, 180 + progress_of_preparing, 80, 90, color)

        draw.Color(25, 25, 25, 130)
        draw.FilledCircle(screen_width / 2, screen_height / 2, 79)


        local text = (delta_time > preparation_time) and "PREPARATION IS FINISHED" or "PREPARING THE SCRIPT"

        draw.SetFont(fonts.keybinds_font)
        local preparing_text_size = {draw.GetTextSize(text)}

        draw.Color(255, 255, 255, 255)
        outlinedText(screen_width / 2- math.floor(preparing_text_size[1] / 2), screen_height / 2 - math.floor(preparing_text_size[2] / 2) - 1, text,
                     fonts.keybinds_font, {255, 255, 255, 255}, fonts.keybinds_font_outlined, {10, 10, 10, 255})
    end

    if delta_time > preparation_time + constants.PREPARATION_DELAY then preparation_finished = true end
end

--there array, which will include all hits
local hit_array = {};

--dinamical animation length of screen hitmarker
local animation_length = 0;

constants.HITMARKER_ANIMATION_LENGTH = 7;
constants.TIME_OF_VISIBILITY = 2;
constants.ALPHA_BY_TIME = 255 / constants.TIME_OF_VISIBILITY;

--listening for player_hurt event and filling hit array
local function getHitEvent(event)

    --checking, that event is not nil
    if not event then 
        return
    end

    --listening for player hurt event
    if event:GetName() == "player_hurt" then

        --checking, that attacker is our entity
        if client.GetPlayerIndexByUserID(event:GetInt("attacker")) == client.GetLocalPlayerIndex() 
            and client.GetPlayerIndexByUserID(event:GetInt("userid")) ~= client.GetLocalPlayerIndex() then

            --calculating hit_position
            local hit_position = entities.GetByUserID(event:GetInt("userid")):GetHitboxPosition(event:GetInt("hitgroup"))

            --inseting everything into array + randomisating position of hit marker
            hit_array[#hit_array + 1] = 
            {   handler_variables.real_time + constants.TIME_OF_VISIBILITY, 
                hit_position.x + (0.1 * math.random(-40, 40)), 
                hit_position.y, 
                hit_position.z + (0.1 * math.random(-20, 20)),
                event:GetInt("dmg_health"), event:GetInt("hitgroup") == 1
            }

            --reseting animation length
            animation_length = constants.HITMARKER_ANIMATION_LENGTH
        end
    end
end

--deleting old data of array
local function clearHitArray()

    --removing elements by time
    for hits = 1, #hit_array, 1 do

        --if element has old data then removing it
        if hit_array[hits] and hit_array[hits][1] - handler_variables.real_time < 0 then

            table.remove(hit_array, hits)
        end
    end
end

--drawing world hitmarker
local function worldHitmarker()

    --checking for enable
    if not visuals_hit_info_ui.world_hitmarker:GetValue() then
        return 
    end

    --iterating over all hits
    for hits = 1, #hit_array, 1 do

        --checking for valid 
        if not hit_array[hits] then return end

        local hit = hit_array[hits]
        local hit_position_screen = {client.WorldToScreen(Vector3(hit[2], hit[3], hit[4]))}

        --hitmarker cross
        if hit_position_screen[1] and hit_position_screen[2] then

            local DISTANCE_FROM_CENTER = 2
            local LENGTH = 5

            local color = {world_hitmarker_color:GetValue()}

            draw.Color(color[1], color[2], color[3],  (hit[1] - handler_variables.real_time) * constants.ALPHA_BY_TIME)

            --right side
            draw.Line(hit_position_screen[1] + DISTANCE_FROM_CENTER, hit_position_screen[2] + DISTANCE_FROM_CENTER, hit_position_screen[1] 
                      + (DISTANCE_FROM_CENTER + LENGTH), hit_position_screen[2] + (DISTANCE_FROM_CENTER + LENGTH))

            draw.Line(hit_position_screen[1] + DISTANCE_FROM_CENTER, hit_position_screen[2] - DISTANCE_FROM_CENTER, hit_position_screen[1]
                      + (DISTANCE_FROM_CENTER + LENGTH),  hit_position_screen[2] - (DISTANCE_FROM_CENTER + LENGTH))

            --left side
            draw.Line(hit_position_screen[1] - DISTANCE_FROM_CENTER, hit_position_screen[2] + DISTANCE_FROM_CENTER, hit_position_screen[1] 
                      - (DISTANCE_FROM_CENTER + LENGTH), hit_position_screen[2] + (DISTANCE_FROM_CENTER + LENGTH))

            draw.Line(hit_position_screen[1] - DISTANCE_FROM_CENTER, hit_position_screen[2] - DISTANCE_FROM_CENTER, hit_position_screen[1] 
                      - (DISTANCE_FROM_CENTER + LENGTH), hit_position_screen[2] - (DISTANCE_FROM_CENTER + LENGTH))
        end
    end
end

--drawing world damage marker
local function worldDamageMarker()

    --checking for enable
    if not visuals_hit_info_ui.world_damage_marker:GetValue() then
        return 
    end

    --iterating over all hits
    for hits = 1, #hit_array, 1 do

        --check for valid 
        if not hit_array[hits] then return end

        local hit = hit_array[hits]
        local hit_position_screen = {client.WorldToScreen(Vector3(hit[2], hit[3], hit[4]))}

        --damage marker
        if hit_position_screen[1] and hit_position_screen[2]then

            draw.SetFont(fonts.world_damage_font)
            local DISTANCE_FROM_CENTER = 10
            local size_of_damage = {draw.GetTextSize(tostring(hit[5]))}

            local color = {world_damage_marker_color:GetValue()}
            local color_headshot = {world_damage_marker_color_headshot:GetValue()}

            local current_color = hit[6] 
            and {color_headshot[1], color_headshot[2], color_headshot[3], (hit[1] - handler_variables.real_time) * constants.ALPHA_BY_TIME} 
            or {color[1], color[2], color[3], (hit[1] - handler_variables.real_time) * constants.ALPHA_BY_TIME}

            --drawing damage text
            draw.Color(current_color[1], current_color[2], current_color[3], current_color[4])
            draw.Text(hit_position_screen[1] - size_of_damage[1] / 2, hit_position_screen[2] - DISTANCE_FROM_CENTER - size_of_damage[2], tostring(hit[5]))
        end
    end
end

constants.SCREEN_HITMARKER_ANIMATION_SPEED = 0.025;
constants.CIRCLE_PART = 360 / 4;
constants.CIRCLE_SIZE = 6;
constants.CIRCLE_DISTANCE_FROM_CENTER = 5;

--drawing screen hitmarker
local function screenHitmarker()

    --checking for enable and animation length
    if not visuals_hit_info_ui.screen_hitmarker:GetValue() or not (animation_length > 0) then
        return
    end

    animation_length = animation_length - (constants.SCREEN_HITMARKER_ANIMATION_SPEED * getAnimationScale())

    local color = {screen_hitmarker_color:GetValue()}

    --segments - base of this hitmarker

    --right side
    segment(screen_width / 2 + (constants.HITMARKER_ANIMATION_LENGTH - animation_length), screen_height / 2 + (constants.HITMARKER_ANIMATION_LENGTH - animation_length), 
    constants.CIRCLE_PART * 0, constants.CIRCLE_PART, constants.CIRCLE_DISTANCE_FROM_CENTER, constants.CIRCLE_SIZE, {color[1], color[2], color[3]})

    segment(screen_width / 2 + (constants.HITMARKER_ANIMATION_LENGTH - animation_length), screen_height / 2 - (constants.HITMARKER_ANIMATION_LENGTH - animation_length), 
    constants.CIRCLE_PART, constants.CIRCLE_PART * 2, constants.CIRCLE_DISTANCE_FROM_CENTER, constants.CIRCLE_SIZE, {color[1], color[2], color[3]})

    --left side
    segment(screen_width / 2 - (constants.HITMARKER_ANIMATION_LENGTH - animation_length), screen_height / 2 - (constants.HITMARKER_ANIMATION_LENGTH - animation_length), 
    constants.CIRCLE_PART * 2, constants.CIRCLE_PART * 3, constants.CIRCLE_DISTANCE_FROM_CENTER, constants.CIRCLE_SIZE, {color[1], color[2], color[3]})

    segment(screen_width / 2 - (constants.HITMARKER_ANIMATION_LENGTH - animation_length), screen_height / 2 + (constants.HITMARKER_ANIMATION_LENGTH - animation_length), 
    constants.CIRCLE_PART * 3, constants.CIRCLE_PART * 4, constants.CIRCLE_DISTANCE_FROM_CENTER, constants.CIRCLE_SIZE, {color[1], color[2], color[3]})
end


local keybind_states_animations = {0, 0, 0, 0, 0, 0, 0} 
local keybind_states_text = {};
local keybind_states_type = {};
local keybind_states_values = {};

constants.KEYBINDS_ANIMATION_SPEED = 0.15;
constants.KEYBINDS_ANIMATION_LENGTH = 15;

--making animations of keybinds
local function keybindsAnimations()

    --selecting current states list
    if gui.GetValue("lbot.master") then
        keybind_states_values = {functions_states.aimbot_active, functions_states.triggerbot_active, functions_states.auto_fire_active, functions_states.autowall_active, 
                                 functions_states.resolver_active, functions_states.legit_aa_active, functions_states.backtrack_active}

        keybind_states_text = {"aimbot", "triggerbot", "auto fire", "autowall", "resolver", "legit aa", "backtrack"}
        keybind_states_type = {"[holding]", "[holding]", "[holding]", "[holding]", "[holding]", "[toggled]", "[toggled]"}
    else
        keybind_states_values = {functions_states.double_tap_active, functions_states.hide_shots_active, functions_states.fake_duck_active, functions_states.fake_latency_active, 
                                 functions_states.edge_jump_active, functions_states.slow_walk_active, functions_states.third_person_active}

        keybind_states_text = {"double tap", "hide shots", "fake duck", "fake latency", "edge jump", "slow walk", "third person"}
        keybind_states_type = {"[toggled]", "[toggled]", "[toggled]", "[holding]", "[holding]", "[toggled]", "[toggled]"}
    end

    --iterating over all states
    for state = 1, #keybind_states_values, 1 do

        --animating them
        if keybind_states_values[state] then
           keybind_states_animations[state] = keybind_states_animations[state] + constants.KEYBINDS_ANIMATION_SPEED * getAnimationScale()

            if keybind_states_animations[state] > constants.KEYBINDS_ANIMATION_LENGTH then 
                keybind_states_animations[state] = constants.KEYBINDS_ANIMATION_LENGTH
            end
        else
            keybind_states_animations[state] = keybind_states_animations[state] - constants.KEYBINDS_ANIMATION_SPEED * getAnimationScale()

            if keybind_states_animations[state] < 0 then 
                keybind_states_animations[state] = 0
            end
        end
    end
end

constants.MAIN_ANIMATION_LENGTH = 25;
constants.MAIN_ANIMATION_SPEED = 0.25;
constants.MAIN_ANIMATION_START_VALUE = 7;
constants.main_animation_value = 0;

--main animation of keybinds's head text
local function mainKeybindsAnimation()

    --checking, that all states are disabling
    if sumFromTo(keybind_states_animations, 1, #keybind_states_animations) < constants.MAIN_ANIMATION_START_VALUE then

        constants.main_animation_value = constants.main_animation_value - constants.MAIN_ANIMATION_SPEED * getAnimationScale()

        if constants.main_animation_value < 0 then
            constants.main_animation_value = 0
        end

    --if state is enabling
    else

        constants.main_animation_value = constants.main_animation_value + constants.MAIN_ANIMATION_SPEED * getAnimationScale()

        if constants.main_animation_value > constants.MAIN_ANIMATION_LENGTH then
            constants.main_animation_value = constants.MAIN_ANIMATION_LENGTH
        end
    end
end

constants.KEYBINDS_DISTANCE_FROM_BORDER = 10;
constants.KEYBINDS_SIZE = 200;
constants.KEYBINDS_HEADER_SIZE = 25;
constants.KEYBINDS_DISTANCE_FROM_HEADER = 10;
local header_color, background_color, text_color, outline_color = {25, 25, 25}, {50, 50, 50}, {255, 255, 255}, {10, 10, 10};
local delta_x, delta_y = 0, 0;

--contoling position of keybinds | weapon info
local function controleVisualsPostion()

    --all gui, that has positions of visuals
    local visuals_positions = {{"esp.visuals_tab.keybinds_position_x", "esp.visuals_tab.keybinds_position_y"},
                               {"esp.visuals_tab.weapon_info_position_x", "esp.visuals_tab.weapon_info_position_y"}
                              }

    local menu = gui.Reference("Menu")
    local menu_pos = {menu:GetValue()}
    local distance_to_menu = vector.Distance(menu_pos[1], menu_pos[2], 0, handler_variables.mouse_pos[1], handler_variables.mouse_pos[2], 0)  

    local closest = 1;
    local closest_distance = math.huge

    --iterating over all visuals
    for visual = 1, #visuals_positions, 1 do

        --getting distance between visuals and mouse
        local between_x = handler_variables.mouse_pos[1] - gui.GetValue(visuals_positions[visual][1])
        local between_y = handler_variables.mouse_pos[2] - gui.GetValue(visuals_positions[visual][2])

        --checking for valid pos
        if (between_x > 0 and between_x <= constants.KEYBINDS_SIZE) and (between_y > 0 and between_y <= constants.KEYBINDS_HEADER_SIZE) then

            --getting closest
            local distance = vector.Distance(gui.GetValue(visuals_positions[visual][1]), gui.GetValue(visuals_positions[visual][2]), 0, 
                                             handler_variables.mouse_pos[1], handler_variables.mouse_pos[2], 0)

            --returning the closest one
            if distance < closest_distance then
                closest = visual
                closest_distance = distance
            end
        end
    end

    --collecting delta data if mouse 1 is not pressed 
    if not input.IsButtonDown(1) then

        --getting distance between visuals and mouse
        delta_x = handler_variables.mouse_pos[1] - gui.GetValue(visuals_positions[closest][1])
        delta_y = handler_variables.mouse_pos[2] - gui.GetValue(visuals_positions[closest][2])
    end

    --setting positions 
    if input.IsButtonDown(1) and (delta_x > 0 and delta_x <= constants.KEYBINDS_SIZE) and (delta_y > 0 and delta_y <= constants.KEYBINDS_HEADER_SIZE) and (distance_to_menu > 50) and menu:IsActive() then

        gui.SetValue(visuals_positions[closest][1], handler_variables.mouse_pos[1] - delta_x)
        gui.SetValue(visuals_positions[closest][2], handler_variables.mouse_pos[2] - delta_y)
    end
end

--selecting black | gray color theme
local function selectColorTheme()

    --colors for themes
    if visuals_user_info_ui.color_theme:GetValue() == 0 then
        header_color, background_color, text_color, outline_color = {25, 25, 25}, {50, 50, 50}, {255, 255, 255}, {10, 10, 10}
    else
        header_color, background_color, text_color, outline_color = {60, 60, 60}, {105, 105, 105}, {255, 255, 255}, {10, 10, 10}
    end
end

--drawing keybinds background and header
local function drawKeybindsBase()

    draw.Color(header_color[1], header_color[2], header_color[3], constants.main_animation_value * 10.2)
    draw.FilledRect(visuals_user_info_ui.keybinds_position_x:GetValue(), visuals_user_info_ui.keybinds_position_y:GetValue(),
                    visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_SIZE, visuals_user_info_ui.keybinds_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE)

    draw.Color(background_color[1], background_color[2], background_color[3], constants.main_animation_value * 8)
    draw.FilledRect(visuals_user_info_ui.keybinds_position_x:GetValue(), visuals_user_info_ui.keybinds_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE,
                    visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_SIZE, 
                    visuals_user_info_ui.keybinds_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE + 
                    sumFromTo(keybind_states_animations, 1, #keybind_states_animations) + constants.KEYBINDS_DISTANCE_FROM_HEADER)
end

--decoding the emoji by bytes
--http://www.unit-conversion.info/texttools/ascii/
local EMOJI_KEYBOARD = string.char(226, 140, 168, 239, 184);

--drawing header text 
local function drawKeybindsHeaderText()

    draw.SetFont(fonts.keybinds_font)
    local keybinds_name_size = {draw.GetTextSize("Keybinds")} 

    draw.SetFont(fonts.emoji_font)
    local emoji_size = {draw.GetTextSize(EMOJI_KEYBOARD)}

    draw.Color(text_color[1], text_color[2], text_color[3], constants.main_animation_value * 10)
    draw.Text(visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER,
              visuals_user_info_ui.keybinds_position_y:GetValue() + math.floor(constants.KEYBINDS_HEADER_SIZE / 2) - math.floor(emoji_size[2] / 2) - 2, EMOJI_KEYBOARD)

    outlinedText(visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER + emoji_size[1] - 12,
                 visuals_user_info_ui.keybinds_position_y:GetValue() + math.floor(constants.KEYBINDS_HEADER_SIZE / 2) - math.floor(keybinds_name_size[2] / 2) - 1, "Keybinds",
                 fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], constants.main_animation_value * 10}, 
                 fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], constants.main_animation_value * 10})
end

--drawing all states of keybinds
local function drawKeybindsStates()

    --iterating over all states
    for state = 1, #keybind_states_values, 1 do

        --if it active
        if keybind_states_animations[state] > 0 then

            --drawing it
            draw.SetFont(fonts.keybinds_font)
            local keybinds_text_size = {draw.GetTextSize(keybind_states_text[state])}
            local keybinds_type_size = {draw.GetTextSize(keybind_states_type[state])}

            --state name
            outlinedText(visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER, 
                        visuals_user_info_ui.keybinds_position_y:GetValue() + constants.KEYBINDS_DISTANCE_FROM_HEADER + sumFromTo(keybind_states_animations, 1, state)
                        - constants.KEYBINDS_ANIMATION_LENGTH + constants.KEYBINDS_HEADER_SIZE - math.floor(keybinds_text_size[2] / 2), keybind_states_text[state],
                        fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], keybind_states_animations[state] * 17}, 
                        fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], keybind_states_animations[state] * 17})

            --state type
            outlinedText(visuals_user_info_ui.keybinds_position_x:GetValue() + constants.KEYBINDS_SIZE - constants.KEYBINDS_DISTANCE_FROM_BORDER - keybinds_type_size[1],
                        visuals_user_info_ui.keybinds_position_y:GetValue() + constants.KEYBINDS_DISTANCE_FROM_HEADER + sumFromTo(keybind_states_animations, 1, state)
                        - constants.KEYBINDS_ANIMATION_LENGTH + constants.KEYBINDS_HEADER_SIZE - math.floor(keybinds_type_size[2] / 2), keybind_states_type[state], 
                        fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], keybind_states_animations[state] * 17}, 
                        fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], keybind_states_animations[state] * 17})
        end
    end
end


constants.WEAPON_INFO_SIZE = 30;
--http://www.unit-conversion.info/texttools/ascii/
constants.INFO_EMOJI = string.char(240, 159, 155, 136);

--drawing weapon info base(background, header)
local function drawWeaponInfo()

    draw.Color(header_color[1], header_color[2], header_color[3], 255)
    draw.FilledRect(visuals_user_info_ui.weapon_info_position_x:GetValue(), visuals_user_info_ui.weapon_info_position_y:GetValue(),
                    visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_SIZE, visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE)

    draw.Color(background_color[1], background_color[2], background_color[3], 200)
    draw.FilledRect(visuals_user_info_ui.weapon_info_position_x:GetValue(), visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE,
                    visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_SIZE, 
                    visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE + constants.WEAPON_INFO_SIZE + constants.KEYBINDS_DISTANCE_FROM_HEADER)

    draw.SetFont(fonts.keybinds_font)
    local keybinds_name_size = {draw.GetTextSize("Weapon Info")} 

    draw.SetFont(fonts.emoji_font)
    local info_emoji_size = {draw.GetTextSize(constants.INFO_EMOJI)}

    draw.Color(text_color[1], text_color[2], text_color[3], 255)
    draw.Text(visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER,
              visuals_user_info_ui.weapon_info_position_y:GetValue() + math.floor(constants.KEYBINDS_HEADER_SIZE / 2) - math.floor(info_emoji_size[2] / 2) - 2, constants.INFO_EMOJI)

    outlinedText(visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER + info_emoji_size[1] + 3,
                visuals_user_info_ui.weapon_info_position_y:GetValue() + math.floor(constants.KEYBINDS_HEADER_SIZE / 2) - math.floor(keybinds_name_size[2] / 2) - 1, "Weapon Info",
                fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], 255}, 
                fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})
end

--drawing all text in weapon info
local function drawWeaponInfoText()

    draw.SetFont(fonts.keybinds_font)
    local weapon_group = handler_variables.current_weapon_group
    local weapon_group_name_size = {draw.GetTextSize(weapon_group)}

    local damage_text = "damage: " .. gui.GetValue("rbot.hitscan.accuracy." .. weapon_group .. ".mindamage")
    local hitchance_text = "hitchance: " .. gui.GetValue("rbot.hitscan.accuracy." .. weapon_group .. ".hitchance")

    local damage_text_size = {draw.GetTextSize(damage_text)}
    local hitchance_text_size = {draw.GetTextSize(hitchance_text)}

    --weapon group
    outlinedText(visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_DISTANCE_FROM_BORDER, 
                 visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE + (constants.WEAPON_INFO_SIZE / 2) - math.floor(weapon_group_name_size[2] / 2) + 3,
                 weapon_group, fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], 255}, 
                 fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})

    --damage
    outlinedText(visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_SIZE - constants.KEYBINDS_DISTANCE_FROM_BORDER - damage_text_size[1], 
                 visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE + (constants.WEAPON_INFO_SIZE / 2) - damage_text_size[2] - 3,
                 damage_text, fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], 255}, 
                 fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})   

    --hitchance
    outlinedText(visuals_user_info_ui.weapon_info_position_x:GetValue() + constants.KEYBINDS_SIZE - constants.KEYBINDS_DISTANCE_FROM_BORDER - hitchance_text_size[1], 
                 visuals_user_info_ui.weapon_info_position_y:GetValue() + constants.KEYBINDS_HEADER_SIZE + (constants.WEAPON_INFO_SIZE / 2) + hitchance_text_size[2] + 3,
                 hitchance_text, fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], 255}, 
                 fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})
end


constants.CHAR_ANIMATION_SPEED = 0.15
constants.BLEEDING_CHARS_SIZE = {}
constants.BLEEDING_CHARS = {"b", "l", "e", "e", "d", "i", "n", "g"};
constants.MAX_CHARS = 4
local colored_char_list = {false, false, false, false, true, true, true, true};
local char_animation_value = 0

constants.UNDER_CROSSHAIR_DISTANCE_FROM_CENTER = 30;
constants.SCOPE_ANIMATION_SPEED = 0.5;
constants.SCOPE_ANIMATION_LENGTH = 40;
constants.UNDER_CROSSHAIR_ANIMATION_SCALE = 50;

local scope_animation_value = 0;
local under_crosshair_indicator_x, under_crosshair_indicator_y = 0, 0;

--drawing main text with special animation
local function drawUnderCrosshairIndicatorMainText()

    --if our desync is inverted then switch colored chars
    if not desync_inverted then

        --setting uncolored, non active side chars(right side)
        for char = 5, #colored_char_list, 1 do
            colored_char_list[char] = false
        end

        --setting colored active side char with animation
        char_animation_value = char_animation_value - constants.CHAR_ANIMATION_SPEED * getAnimationScale()
        if char_animation_value < -constants.MAX_CHARS then
            char_animation_value = -constants.MAX_CHARS
        end

        colored_char_list[5 + math.floor(char_animation_value)] = true
    else
        --setting uncolored, non active side chars(left side)
        for char = 1, 4, 1 do
            colored_char_list[char] = false
        end

        --setting colored active side char with animation
        char_animation_value = char_animation_value + constants.CHAR_ANIMATION_SPEED * getAnimationScale()
        if char_animation_value > constants.MAX_CHARS then
            char_animation_value = constants.MAX_CHARS
        end

        colored_char_list[4 + math.floor(char_animation_value)] = true
    end

    --filling text_sizes
    draw.SetFont(fonts.keybinds_font)
    local bleeding_text_size = {draw.GetTextSize("bleeding")}

    for char = 1, #constants.BLEEDING_CHARS, 1 do   

        --inserting text sizes
        local char_size = {draw.GetTextSize(constants.BLEEDING_CHARS[char])}
        if not constants.BLEEDING_CHARS_SIZE[char] then
            constants.BLEEDING_CHARS_SIZE[char] = char_size[1]
        end
    end

    --iterating over all chars to set color
    for char = 1, #constants.BLEEDING_CHARS, 1 do   

        local char_color = colored_char_list[char] and {under_crosshair_indicator_color:GetValue()} or {text_color[1], text_color[2], text_color[3], 255}

        --drawing char
        outlinedText(under_crosshair_indicator_x + sumFromTo(constants.BLEEDING_CHARS_SIZE, 1, char - 1) + scope_animation_value - math.floor(bleeding_text_size[1] / 2), 
                     under_crosshair_indicator_y + constants.UNDER_CROSSHAIR_DISTANCE_FROM_CENTER - math.floor(bleeding_text_size[2] / 2), 
                     constants.BLEEDING_CHARS[char], fonts.keybinds_font, char_color, 
                     fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})
    end
end

--drawing under crosshair indicators
local function drawUnderCrosshairIndicator()

    --in scope animation
    if props.is_scoped then
        scope_animation_value = scope_animation_value + constants.SCOPE_ANIMATION_SPEED * getAnimationScale()

        if scope_animation_value > constants.SCOPE_ANIMATION_LENGTH then
            scope_animation_value = constants.SCOPE_ANIMATION_LENGTH
        end
    else
        scope_animation_value = scope_animation_value - constants.SCOPE_ANIMATION_SPEED * getAnimationScale()

        if scope_animation_value < 0 then
            scope_animation_value = 0
        end
    end

    --mouse based position
    under_crosshair_indicator_x = under_crosshair_indicator_x + 
                                  (handler_variables.mouse_pos[1] - under_crosshair_indicator_x) / (constants.UNDER_CROSSHAIR_ANIMATION_SCALE * getAnimationScale())

    under_crosshair_indicator_y = under_crosshair_indicator_y + 
                                (handler_variables.mouse_pos[2] - under_crosshair_indicator_y) / (constants.UNDER_CROSSHAIR_ANIMATION_SCALE * getAnimationScale())


    --iterating over all states
    for state = 1, #keybind_states_values, 1 do

        --checking for active
        if keybind_states_animations[state] > 0 then

            draw.SetFont(fonts.keybinds_font)
            local under_crosshair_text_size = {draw.GetTextSize(keybind_states_text[state])}

            outlinedText(under_crosshair_indicator_x - under_crosshair_text_size[1] / 2 + scope_animation_value, 
                        under_crosshair_indicator_y + constants.UNDER_CROSSHAIR_DISTANCE_FROM_CENTER + sumFromTo(keybind_states_animations, 1, state)
                        - math.floor(under_crosshair_text_size[2] / 2), keybind_states_text[state],
                        fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], keybind_states_animations[state] * 17}, 
                        fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], keybind_states_animations[state] * 17})
        end
    end
end


constants.WATERMARK_POSITION = 20;
constants.SIDE_DISTANCE_X = 5;
constants.SIDE_DISTANCE_Y = 6
local watermark_text = " ";

--drawing watermark
local function drawWatermark()

    --creating text with all info
    watermark_text = ("BLEEDING   " .. handler_variables.user_name .. " | " ..  math.floor(handler_variables.fps_per_second) .. 
                      " fps | " .. handler_variables.server .. " | delay: " .. props.ping .. " ms | " .. handler_variables.tickrate .. " tick")

    if visuals_user_info_ui.watermark:GetValue() then

        draw.SetFont(fonts.keybinds_font)
        local watermark_text_size = {draw.GetTextSize(watermark_text)}
        local bleeding_text_size = {draw.GetTextSize("BLEEDING ")}

        --left background
        draw.Color(background_color[1], background_color[2], background_color[3], 175)
        draw.FilledRect(screen_width - constants.WATERMARK_POSITION - watermark_text_size[1] + bleeding_text_size[1], constants.WATERMARK_POSITION - constants.SIDE_DISTANCE_Y, 
                        screen_width - constants.WATERMARK_POSITION + constants.SIDE_DISTANCE_X, constants.WATERMARK_POSITION + 15)

        --right background
        draw.Color(header_color[1], header_color[2], header_color[3], 255)
        draw.FilledRect(screen_width - watermark_text_size[1] - constants.WATERMARK_POSITION - constants.SIDE_DISTANCE_X, constants.WATERMARK_POSITION - constants.SIDE_DISTANCE_Y, 
                        screen_width - watermark_text_size[1] - constants.WATERMARK_POSITION + bleeding_text_size[1] + 2, constants.WATERMARK_POSITION + 15)

        --text
        outlinedText(screen_width - watermark_text_size[1] - constants.WATERMARK_POSITION, constants.WATERMARK_POSITION + 1, watermark_text, 
                    fonts.keybinds_font, {text_color[1], text_color[2], text_color[3], 255}, 
                    fonts.keybinds_font_outlined, {outline_color[1], outline_color[2], outline_color[3], 255})
    end
end


constants.CUSTOM_SCOPE_ANIMATION_SPEED = 0.75;
constants.CUSTOM_SCOPE_MINIMAL_SIZE = 20;
local custom_scope_animation_value = constants.CUSTOM_SCOPE_MINIMAL_SIZE;

--drawing custom scope
local function drawCustomScope()

    --draw hud on disable
    setConvar("cl_drawhud", (custom_scope:GetValue() and custom_scope_animation_value > 20) and 0 or 1)

    --enable hud when dead
    if not handler_variables.local_entity or not handler_variables.local_entity:IsAlive() then 
        setConvar("cl_drawhud", 1)
        return
    end

    --make smooth scope animation
    gui.SetValue("esp.other.noscopeoverlay", not (custom_scope:GetValue() and custom_scope_animation_value > 21.5))

    --animation
    if props.is_scoped then
        custom_scope_animation_value = custom_scope_animation_value + constants.CUSTOM_SCOPE_ANIMATION_SPEED * getAnimationScale()

        if custom_scope_animation_value > visuals_other_ui.custom_scope_length:GetValue() then
            custom_scope_animation_value = visuals_other_ui.custom_scope_length:GetValue()
        end
    else
        custom_scope_animation_value = custom_scope_animation_value - constants.CUSTOM_SCOPE_ANIMATION_SPEED * getAnimationScale()

        if custom_scope_animation_value < constants.CUSTOM_SCOPE_MINIMAL_SIZE then
            custom_scope_animation_value = constants.CUSTOM_SCOPE_MINIMAL_SIZE
        end
    end

    --draw scope
    if custom_scope:GetValue() and custom_scope_animation_value > 20 then

        local scope_color = {visuals_other_ui.custom_scope_color:GetValue()}

        gradientRectRight(screen_width / 2 + visuals_other_ui.custom_scope_indent:GetValue(),
                          screen_height / 2, custom_scope_animation_value, 1, {scope_color[1], scope_color[2], scope_color[3], scope_color[4]})

        gradientRectLeft(screen_width / 2 - visuals_other_ui.custom_scope_indent:GetValue(),
                         screen_height / 2, custom_scope_animation_value, 1, {scope_color[1], scope_color[2], scope_color[3], scope_color[4]})

        gradientRectUp(screen_width / 2, screen_height / 2 - visuals_other_ui.custom_scope_indent:GetValue(), 
                       custom_scope_animation_value, 1, {scope_color[1], scope_color[2], scope_color[3], scope_color[4]})

        gradientRectDown(screen_width / 2, screen_height / 2 + visuals_other_ui.custom_scope_indent:GetValue(), 
                       custom_scope_animation_value, 1, {scope_color[1], scope_color[2], scope_color[3], scope_color[4]})
    end
end


constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER = 30;
constants.DESYNC_SIDE_INDICATOR_SIZE_X = 2;
constants.DESYNC_SIDE_INDICATOR_SIZE_Y = 20;

local function drawDesyncSideIndicator()

    --checking for enable
    if not desync_side_indicator:GetValue() then
        return 
    end

    --checking for desync side
    if desync_inverted then

        --right
        draw.Color(visuals_other_ui.desync_side_indicator_color_active:GetValue())
        draw.FilledRect(screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                        screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER + constants.DESYNC_SIDE_INDICATOR_SIZE_X, 
                        screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)

        --left
        draw.Color(visuals_other_ui.desync_side_indicator_color_inactive:GetValue())
        draw.FilledRect(screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER - constants.DESYNC_SIDE_INDICATOR_SIZE_X, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                        screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER, 
                        screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)
    else

        --right
        draw.Color(visuals_other_ui.desync_side_indicator_color_inactive:GetValue())
        draw.FilledRect(screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                        screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER + constants.DESYNC_SIDE_INDICATOR_SIZE_X, 
                        screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)

        --left
        draw.Color(visuals_other_ui.desync_side_indicator_color_active:GetValue())
        draw.FilledRect(screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER - constants.DESYNC_SIDE_INDICATOR_SIZE_X, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                        screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER, 
                        screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)
    end

    --drawing outline rect for main rects
    draw.Color(10, 10, 10, 255)
    draw.OutlinedRect(screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER - 1, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                      screen_width / 2 + constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER + constants.DESYNC_SIDE_INDICATOR_SIZE_X + 1, 
                      screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)

    draw.OutlinedRect(screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER - constants.DESYNC_SIDE_INDICATOR_SIZE_X - 1, screen_height / 2 + constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 + 1,
                      screen_width / 2 - constants.DESYNC_SIDE_INDICATOR_DISTANCE_FROM_CENTER + 1, 
                      screen_height / 2 - constants.DESYNC_SIDE_INDICATOR_SIZE_Y / 2 - 1)
end

--setting all convars visuals
local function setConvarVisuals()

    if visuals_other_ui.aspect_ratio:GetValue() then
        setConvar("r_aspectratio", visuals_other_ui.aspect_ratio_value:GetValue())
    end

    if visuals_other_ui.view_model_changer:GetValue() then
        setConvar("viewmodel_offset_x", visuals_other_ui.view_model_changer_x:GetValue())
        setConvar("viewmodel_offset_y", visuals_other_ui.view_model_changer_y:GetValue())
        setConvar("viewmodel_offset_z", visuals_other_ui.view_model_changer_z:GetValue())
    end
end

constants.MAX_COLOR_VALUE = 255;
local post_proccesing = gui.Reference("Visuals", "Other", "Effects", "Effects Removal", "No Post Processing");

--cache system will help with values on unload
local world_modifications_caches = {}

--setting all world modifications
local function setWolrdModifications()

    if visuals_other_ui.world_modifications:GetValue() then
        if visuals_other_ui.world_modifications_bloom:GetValue() then
            post_proccesing:SetValue(false)
        end

        if props.tone_map_controller then
            setProp(props.tone_map_controller, "m_flCustomBloomScaleMinimum", visuals_other_ui.world_modifications_bloom:GetValue() * 0.1)
            setProp(props.tone_map_controller, "m_flCustomBloomScale", visuals_other_ui.world_modifications_bloom:GetValue() * 0.1);

            setProp(props.tone_map_controller, "m_flCustomAutoExposureMax", 1.01 - (visuals_other_ui.world_modifications_exposure:GetValue() * 0.01))
            setProp(props.tone_map_controller, "m_flCustomAutoExposureMin", 1.01 - (visuals_other_ui.world_modifications_exposure:GetValue() * 0.01))
        end

        setConvar("r_modelAmbientMin", visuals_other_ui.world_modifications_ambient:GetValue() * 0.1)

        local world_color_ambient = {visuals_other_ui.world_modifications_ambient_color:GetValue()}

        setConvar("mat_ambient_light_r", world_color_ambient[1] / constants.MAX_COLOR_VALUE)
        setConvar("mat_ambient_light_g", world_color_ambient[2] / constants.MAX_COLOR_VALUE)
        setConvar("mat_ambient_light_b", world_color_ambient[3] / constants.MAX_COLOR_VALUE)
    end
end

--reseting visual's tables to set them on reconnect to the new server
local function resetVisualsArrays()

    --clearing convar, props arrays data, when local entity is nil
    if (not props.tone_map_controller or not handler_variables.local_entity) then

        --print("tables has been reseted")
        prop_array = {}
        convar_array = {}   
    end
end
--@endregion




--@region MISC

--getting closest target
local function getClosestToCrosshair()
    local nearest_distance = math.huge                              --giant number
    local nearest_entity;

    --iterating over all player
    for _, entity in pairs(entities.FindByClass("CCSPlayer")) do

        --check entity for valid
        if entity:GetTeamNumber() ~= handler_variables.local_entity:GetTeamNumber() and entity ~= handler_variables.local_entity and entity:IsPlayer() and entity:IsAlive() then

            --getting their on screen distances
            local entity_on_screen = {client.WorldToScreen(entity:GetAbsOrigin())}
            local distance_to_entity = {vector.Distance(screen_width / 2, screen_height / 2, 0, entity_on_screen[1], entity_on_screen[2], 0)}

            --finding closest
            if distance_to_entity[1] < nearest_distance then
                nearest_distance = distance_to_entity[1]
                nearest_entity = entity
            end
        end
    end

    return nearest_entity
end

--autoscope, which basing on distance
local MAX_NOSCOPE_DISTANCE = 300

local function adaptiveAutoscope()

    --if distance to closest target < 300, disabling asniper autostop
    if misc_useful_ui.adaptive_autoscope:GetValue() and getClosestToCrosshair() and handler_variables.current_weapon_group == "asniper" then

        --target and local abs
        local local_abs = handler_variables.local_entity:GetAbsOrigin()
        local entity_abs = getClosestToCrosshair():GetAbsOrigin()

        local distance = vector.Distance(local_abs.x, local_abs.y, local_abs.z, entity_abs.x, entity_abs.y, entity_abs.z)

        gui.SetValue("rbot.accuracy.auto.shared.scopeopts.scope", distance > MAX_NOSCOPE_DISTANCE)
        gui.SetValue("rbot.accuracy.auto.asniper.scopeopts.scope", distance > MAX_NOSCOPE_DISTANCE)
    end
end

--setting static arms
local function staticArms()
    if misc_useful_ui.static_arms:GetValue() then

        setConvar("cl_bob_lower_amt", 5)
        setConvar("cl_bobamt_vert", 0.1000)
        setConvar("cl_bobamt_lat", 0.1000)
        setConvar("cl_bobcycle", 0.98)
        setConvar("cl_viewmodel_shift_right_amt", 0.25000)
        setConvar("cl_viewmodel_shift_left_amt", 0.5000)
    end
end

local function viewmodelInScope()

    setConvar("fov_cs_debug", misc_useful_ui.viewmodel_in_scope:GetValue() and 90 or 0)
end

--getting, what will bought like extra 
local buy_bot_extra_commands = {"buy vesthelm", "buy vest", "buy taser", "buy defuser", "buy hegrenade", "buy molotov; buy incgrenade", "buy smokegrenade"}

local function getBuyBotExtra()
    local buy_bot_extra_array = {}

    local buy_bot_extra_states = 
    {
        buy_bot_extra_ui.buy_bot_extra_helmet:GetValue(), buy_bot_extra_ui.buy_bot_extra_kevlar:GetValue(),
        buy_bot_extra_ui.buy_bot_extra_taser:GetValue(), buy_bot_extra_ui.buy_bot_extra_defuser:GetValue(), 
        buy_bot_extra_ui.buy_bot_extra_nades:GetValue(), buy_bot_extra_ui.buy_bot_extra_nades:GetValue(), 
        buy_bot_extra_ui.buy_bot_extra_nades:GetValue()
    }

    --getting all active checkboxes and commands, which shows items to buy
    for i = 1, #buy_bot_extra_states, 1 do
        if buy_bot_extra_states[i] then
            buy_bot_extra_array[#buy_bot_extra_array + 1] = buy_bot_extra_commands[i]
        end
    end

    --returning a command of buy
    return table.concat(buy_bot_extra_array, "; ")
end

local buy_bot_primary = {"scar20; buy g3sg1", "awp", "ssg08"}
local buy_bot_secondary = {"deagle; buy revolver", "elite", "tec9; buy fiveseven; buy cz75a", "p250"}

--buying selected weapons on round prestart
local function buyBot(event)

    --checking for event valid and checkbox active
    if not event or not misc_events_ui.buy_bot:GetValue() then
        return 
    end

    --buying all weapons on round prestart
    if event:GetName() == "round_prestart" then

        --primary
        if misc_events_ui.buy_bot_primary:GetValue() ~= 0 then
            client.Command("buy " .. buy_bot_primary[misc_events_ui.buy_bot_primary:GetValue()], true)
        end

        --secondary
        if misc_events_ui.buy_bot_secondary:GetValue() ~= 0 then
            client.Command("buy " .. buy_bot_secondary[misc_events_ui.buy_bot_secondary:GetValue()], true)
        end

        --extra
        client.Command(getBuyBotExtra(), true)
    end
end
--@endregion


--@region LAGSYNC

--array, that collecting multibox elements
local elements_array = {};

--array, that collecting settings for stage
local elements_setting_array = {}

--create elements of keybinds
local function createElement()

	--basic multibox
	elements_array[#elements_array + 1] = gui.Checkbox(elements_box, tostring(#elements_array + 1) .. "_element", tostring(#elements_array + 1) .. " Element", false)

	--all varnames and names
	local interface_name = tostring(#elements_setting_array + 1)

	if not elements_setting_array[#elements_setting_array + 1] then
		elements_setting_array[#elements_setting_array + 1] = {}
	end
	local element = elements_setting_array[#elements_setting_array]

	--create settings
	element.desync_angle = gui.Slider(stages_of_lagsync, "desync_angle_" .. interface_name, "Desync Angle", 0, -58, 58, 1)
	element.yaw_angle = gui.Slider(stages_of_lagsync, "yaw_angle_" .. interface_name, "Yaw Angle", 0, -180, 180, 1)
	element.time_to_switch = gui.Slider(stages_of_lagsync, "time_to_switch_" .. interface_name, "Time to Switch", 2, 2, 64, 1)
end

--remove last element
local function removeElement()

    --checking, that elements number is not 0
    if not elements_array[1] or not elements_setting_array[1] then 
        return 
    end

	--removing main element gui
	elements_array[#elements_array]:Remove()

	--removing all settings gui
	elements_setting_array[#elements_setting_array].desync_angle:Remove()
	elements_setting_array[#elements_setting_array].yaw_angle:Remove()
	elements_setting_array[#elements_setting_array].time_to_switch:Remove()

	--clearing tables
	table.remove(elements_array, #elements_array)
	table.remove(elements_setting_array, #elements_setting_array)
end

--get active element
local function getCurrentElement()

	--iterating over all elements to get active
	for element = 1, #elements_array, 1 do

		if elements_array[element]:GetValue() then
			return element
		end
	end
end

--invisible of elements etc
local function changeElementsUi()

	--iterating over all elements to make inactive elements invisible
	for element = 1, #elements_array, 1 do

		--disabling not active elements
		if getCurrentElement() and getCurrentElement() ~= element then

			elements_array[element]:SetValue(false)
		end

		--iterating over all element setting to make them invisible
		for element = 1, #elements_setting_array, 1 do 

			setInvisible(elements_setting_array[element].desync_angle, not elements_array[element]:GetValue())
			setInvisible(elements_setting_array[element].yaw_angle, not elements_array[element]:GetValue())
			setInvisible(elements_setting_array[element].time_to_switch, not elements_array[element]:GetValue())
		end
	end
end

--create first start elements to save in cfg
local function fileExists(file_name)

    local file_exist = false

	--enumerating all files in aimware settings folder to find our
	file.Enumerate(function(file)
		if file == file_name then
			file_exist = true
		end
	end)

	return file_exist
end

--getting filename of cache
local function getFileName()

	local script_name = GetScriptName()

	return string.sub(script_name, 1, string.find(script_name, ".lua") - 1) .. "_last_elements_number.txt"
end

--getting how many elements should we create
local function getLastElementsNumber()
	local elements_number = 5

	--getting filename of script
	local file_name = getFileName()

	--if we have file then checking his data to create elements
	if fileExists(file_name) then

		local file_open = file.Open(file_name, 'r')
		local file_data = file_open:Read()

		file_open:Close()

		elements_number = file_data
	else

		--5 it is default number of stages
		file.Write(file_name, tostring(elements_number))
	end

	return elements_number
end

--creating first elements on load
local is_first_load = true

local function makeFirstElements()

	if is_first_load then

		--iterating over 1 to data of created element to return old script settings
		for created_elements = 1, getLastElementsNumber(), 1 do
			createElement()
		end

		is_first_load = false
	end
end

--create element by button
local create_element_button = gui.Button(stages_of_lagsync, "Create Element", function()
	createElement()
end)

--remove element by button
local remove_element_button = gui.Button(stages_of_lagsync, "Remove Element", function()
	removeElement()
end)

local text_transfer_elements = gui.Text(stages_of_lagsync, '\n')


local lagsync_static_realtime = globals.RealTime();

local general_lagsync_stage = 1;
local current_lagsync_stage = 1;

--counting current lagsync stage
local function lagsyncStageCounter()

    --checking, that elements number is not 0
    if not elements_array[1] or not elements_setting_array[1] then
        return 
    end

	--fixing if we are removing elements
	if current_lagsync_stage > #elements_setting_array then
		current_lagsync_stage = #elements_setting_array
	end

	--general stage its all stages which been counted
	if handler_variables.real_time - lagsync_static_realtime >= elements_setting_array[current_lagsync_stage].time_to_switch:GetValue() * handler_variables.TICK_TIME then

		general_lagsync_stage = general_lagsync_stage + 1

		lagsync_static_realtime = handler_variables.real_time
	end

	--getting current stage by allstages % numberofstages
	current_lagsync_stage = (general_lagsync_stage % #elements_setting_array) + 1
end

--setting yaw
local function lagsyncSetYaw()

	gui.SetValue("rbot.antiaim.base", clampYaw(180 + yaw_variables.manual_yaw + yaw_variables.legit_yaw + elements_setting_array[current_lagsync_stage].yaw_angle:GetValue()))
end

--setting desync
local function lagsyncSetDesync()

	gui.SetValue("rbot.antiaim.base.rotation", elements_setting_array[current_lagsync_stage].desync_angle:GetValue())
end

--@region CALLBACKS
callbacks.Register("Draw", function()  
    --gui
    createScreenSizeBasedUi()
    changeGui()

    --preparing
    scriptPreparing()

    --handlers
    handlers()

    --optimizer
    clearHitArray()

    --visuals
    controleVisualsPostion()

    --making 1 more preparation for lagsync gui
    if lagsync_enable:GetValue() then
        if is_first_load then
            preparation_finished = false
            load_time = globals.RealTime()
        end

        changeElementsUi()
        makeFirstElements()
    end

    if preparation_finished and handler_variables.local_entity then

        --general
        invertDesync()

        --yaw modifiers
        callManualsFunctions()

        --visual events
        worldHitmarker()
        worldDamageMarker()
        screenHitmarker()

        keybindsAnimations()

        if visuals_user_info_ui.keybinds:GetValue() then
            mainKeybindsAnimation()
            drawKeybindsBase()
            drawKeybindsHeaderText()
            drawKeybindsStates()
        end

        if visuals_user_info_ui.weapon_info:GetValue() then
            drawWeaponInfo()
            drawWeaponInfoText()
        end

        if visuals_user_info_ui.under_crosshair_indicator:GetValue() then
            drawUnderCrosshairIndicatorMainText()
            drawUnderCrosshairIndicator()
        end

        drawWatermark()

        drawCustomScope()

        drawDesyncSideIndicator()
    end
end)

callbacks.Register("PostMove", function()
    --handlers
    getKeybindsStates()

    --optimizers
    resetVisualsArrays()

    if preparation_finished and handler_variables.local_entity then

        --changing system of anti-aims
        if not lagsync_enable:GetValue() then
            --yaw modifiers
            callJitterFunctions()
            calculateMainYaw()
            simpleJitter()

            setYaw()

            --desync modifiers
            callDesyncFunctions()
            simpleDesync()

            setDesync()

        else

            lagsyncStageCounter()

            --checking, that we has elements with given number
            if elements_array[current_lagsync_stage] and elements_setting_array[current_lagsync_stage] then
                lagsyncSetYaw()
                lagsyncSetDesync()
            end
        end

        --rage
        setExploits()

        --visuals
        selectColorTheme()
        setConvarVisuals()
        setWolrdModifications()

        --misc
        adaptiveAutoscope()
        staticArms()
        viewmodelInScope()
    end
end)

callbacks.Register("FireGameEvent", function(event)
    if preparation_finished then
        getHitEvent(event)
        buyBot(event)
    end
end)

callbacks.Register("Unload", function()
    --updating our file on unload to get latest number of elements
	local file_name = getFileName()
	file.Delete(file_name)

    --checking to create not null file
    if #elements_array == 0 then
	    file.Write(file_name, "1")
    else
        file.Write(file_name, #elements_array)
    end
end)
--@endregion


--@region ALLOW_LISTENERS
client.AllowListener("player_hurt")
client.AllowListener("round_prestart")
--@endregion


--@region ANTI_AIM_PRESETS
--__________anti-aim presets___________--
local buttons_ui = 
{
    advanced_preset = gui.Button(anti_aim_presets_tab, "Advanced Preset", function()
        advanced_mode:SetValue(true)

        --standing
        anti_aim_elements[2].override_condition:SetValue(true)
        --desync
        anti_aim_elements[2].desync_type:SetValue(0)
        anti_aim_elements[2].desync_modifier:SetValue(0)
        anti_aim_elements[2].desync_range_right:SetValue(58)
        anti_aim_elements[2].desync_range_left:SetValue(58)
        --yaw
        anti_aim_elements[2].yaw_angle_right:SetValue(-3)
        anti_aim_elements[2].yaw_angle_left:SetValue(3)
        anti_aim_elements[2].yaw_modifier:SetValue(6)
        anti_aim_elements[2].yaw_modifier_range:SetValue(0)
        anti_aim_elements[2].yaw_modifier_speed:SetValue(23)

        --ducking
        anti_aim_elements[3].override_condition:SetValue(true)
        --desync
        anti_aim_elements[3].desync_type:SetValue(0)
        anti_aim_elements[3].desync_modifier:SetValue(0)
        anti_aim_elements[3].desync_range_right:SetValue(53)
        anti_aim_elements[3].desync_range_left:SetValue(56)
        --yaw
        anti_aim_elements[3].yaw_angle_right:SetValue(0)
        anti_aim_elements[3].yaw_angle_left:SetValue(0)
        anti_aim_elements[3].yaw_modifier:SetValue(4)
        anti_aim_elements[3].yaw_modifier_range:SetValue(12)
        anti_aim_elements[3].yaw_modifier_speed:SetValue(2)

        --slow walking
        anti_aim_elements[4].override_condition:SetValue(true)
        --desync
        anti_aim_elements[4].desync_type:SetValue(1)
        anti_aim_elements[4].desync_modifier:SetValue(0)
        anti_aim_elements[4].desync_range_right:SetValue(14)
        anti_aim_elements[4].desync_range_left:SetValue(16)
        --yaw
        anti_aim_elements[4].yaw_angle_right:SetValue(-4)
        anti_aim_elements[4].yaw_angle_left:SetValue(6)
        anti_aim_elements[4].yaw_modifier:SetValue(0)
        anti_aim_elements[4].yaw_modifier_range:SetValue(0)
        anti_aim_elements[4].yaw_modifier_speed:SetValue(2)

        --moving
        anti_aim_elements[5].override_condition:SetValue(true)
        --desync
        anti_aim_elements[5].desync_type:SetValue(1)
        anti_aim_elements[5].desync_modifier:SetValue(0)
        anti_aim_elements[5].desync_range_right:SetValue(10)
        anti_aim_elements[5].desync_range_left:SetValue(11)
        --yaw
        anti_aim_elements[5].yaw_angle_right:SetValue(-2)
        anti_aim_elements[5].yaw_angle_left:SetValue(2)
        anti_aim_elements[5].yaw_modifier:SetValue(3)
        anti_aim_elements[5].yaw_modifier_range:SetValue(6)
        anti_aim_elements[5].yaw_modifier_speed:SetValue(2)

        --air
        anti_aim_elements[6].override_condition:SetValue(true)
        --desync
        anti_aim_elements[6].desync_type:SetValue(0)
        anti_aim_elements[6].desync_modifier:SetValue(3)
        anti_aim_elements[6].desync_range_right:SetValue(57)
        anti_aim_elements[6].desync_range_left:SetValue(58)
        --yaw
        anti_aim_elements[6].yaw_angle_right:SetValue(-1)
        anti_aim_elements[6].yaw_angle_left:SetValue(3)
        anti_aim_elements[6].yaw_modifier:SetValue(0)
        anti_aim_elements[6].yaw_modifier_range:SetValue(0)
        anti_aim_elements[6].yaw_modifier_speed:SetValue(2)
    end),

    simple_preset = gui.Button(anti_aim_presets_tab, "Simple Preset", function()
        advanced_mode:SetValue(false)

        anti_aim_simple_settings_ui.desync_type:SetValue(0)
        anti_aim_simple_settings_ui.desync_angle:SetValue(6)
        anti_aim_simple_settings_ui.jitter_angle:SetValue(2)
        anti_aim_simple_settings_ui.yaw_angle:SetValue(7)
    end)
}
--_____________________________________--
--@endregion 