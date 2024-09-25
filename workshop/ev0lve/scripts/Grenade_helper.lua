--.name Grenade helper
--.description helps you with all da nades
--.author agapornis
require("insecure")

require "render"
render.get_screen_size = render.get_render_size
render.set_standard_resolution(1920, 1080)

local w2s = (function() 
require "vector"

local function vtable_bind(module,interface,index,type)
    local addr = ffi.cast("void***", utils.find_interface(module, interface)) or error(interface..' is nil.')
    return ffi.cast(ffi.typeof(type), addr[0][index]),addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local Matrix4x4 = ffi.cdef[[
    typedef struct {
        union {
            struct {
                float _11, _12, _13, _14;
                float _21, _22, _23, _24;
                float _31, _32, _33, _34;
                float _41, _42, _43, _44;

            };
            float m[4][4];
        };
    } Matrix4x4;
]]

local nativeWorldToScreenMatrix =__thiscall(vtable_bind("engine.dll", "VEngineClient014", 37, "const Matrix4x4&(__thiscall*)(void*)"))

local screenMatrix=nil
local screen_w, screen_h = nil

local function clamp(min,max,value)
    return math.min(math.max(min,value),max)
end

local function transformWorldPositionToScreenPosition(matrix,world_position,clamp_values)
    local w=matrix._41*world_position.x+matrix._42*world_position.y+matrix._43*world_position.z+matrix._44
    if screen_w==nil then
        screen_w, screen_h = render.get_screen_size()
    end
    if w < 0.001 then
        local mw=(matrix._11*world_position.x+matrix._12*world_position.y+matrix._13*world_position.z+matrix._14)/(w*-1)
        local mh=(matrix._21*world_position.x+matrix._22*world_position.y+matrix._23*world_position.z+matrix._24)/(w*-1)
        screen_w_ret=(screen_w/2)*(1+mw)
        screen_h_ret=(screen_h/2)*(1-mh)
        if clamp_values==true or clamp_values==nil then
            screen_w_ret=clamp(0,screen_w,screen_w_ret)
            screen_h_ret=clamp(0,screen_h,screen_h_ret)
        end
        return Vector(screen_w_ret,screen_h_ret,0)
    end
    screen_w_ret=(screen_w/2)*(1+(matrix._11*world_position.x+matrix._12*world_position.y+matrix._13*world_position.z+matrix._14)/w)
    screen_h_ret=(screen_h/2)*(1-(matrix._21*world_position.x+matrix._22*world_position.y+matrix._23*world_position.z+matrix._24)/w)
    return Vector(screen_w_ret,screen_h_ret,1)
end

 
local function worldToScreen(world_position,clamp_values)
    screenMatrix=screenMatrix or nativeWorldToScreenMatrix()
    return transformWorldPositionToScreenPosition(screenMatrix,world_position,clamp_values)
end

return worldToScreen
end)()
local clipboard = require("clipboard")

local engine_is_in_game,engine_exec,engine_get_local_player,engine_get_view_angles,engine_get_player_for_user_id,engine_get_player_info=engine.is_in_game,engine.exec,engine.get_local_player,engine.get_view_angles,engine.get_player_for_user_id,engine.get_player_info
local entities_get_entity,entities_get_entity_from_handle,entities_for_each,entities_for_each_z,entities_for_each_player=entities.get_entity,entities.get_entity_from_handle,entities.for_each,entities.for_each_z,entities.for_each_player
local event_log_add,event_log_output=event_log.add,event_log.output
local gui_checkbox,gui_get_checkbox,gui_color_picker,gui_get_color_picker,gui_combobox,gui_get_combobox,gui_slider,gui_get_slider,gui_textbox,gui_get_textbox,gui_add_notification,gui_is_menu_open,gui_for_each_hotkey=gui.checkbox,gui.get_checkbox,gui.color_picker,gui.get_color_picker,gui.combobox,gui.get_combobox,gui.slider,gui.get_slider,gui.textbox,gui.get_textbox,gui.add_notification,gui.is_menu_open,gui.for_each_hotkey
local game_rules=game_rules
local global_vars=global_vars
local info=info
local input_is_key_down,input_is_mouse_down,input_get_cursor_pos=input.is_key_down,input.is_mouse_down,input.get_cursor_pos
local render_get_screen_size,render_color,render_rect,render_rect_filled,render_rect_filled_multicolor,render_rect_filled_rounded,render_circle,render_circle_filled,render_line,render_line_multicolor,render_triangle,render_triangle_filled,render_triangle_filled_multicolor,render_text,render_create_font,render_get_text_size,render_push_clip_rect,render_pop_clip_rect,render_create_texture,render_push_texture,render_pop_texture,render_get_texture_size,render_push_uv,render_pop_uv,render_create_animator_float,render_create_animator_color=render.get_screen_size,render.color,render.rect,render.rect_filled,render.rect_filled_multicolor,render.rect_filled_rounded,render.circle,render.circle_filled,render.line,render.line_multicolor,render.triangle,render.triangle_filled,render.triangle_filled_multicolor,render.text,render.create_font,render.get_text_size,render.push_clip_rect,render.pop_clip_rect,render.create_texture,render.push_texture,render.pop_texture,render.get_texture_size,render.push_uv,render.pop_uv,render.create_animator_float,render.create_animator_color
local render_align_top,render_align_left,render_align_center,render_align_right,render_align_bottom,render_linear,render_ease_in,render_ease_out,render_ease_in_out,render_elastic_in,render_elastic_out,render_elastic_in_out,render_bounce_in,render_bounce_out,render_bounce_in_out,render_font_flag_shadow,render_font_flag_outline,render_top_left,render_top_right,render_bottom_left,render_bottom_right,render_top,render_left,render_bottom,render_right,render_all=render.align_top,render.align_left,render.align_center,render.align_right,render.align_bottom,render.linear,render.ease_in,render.ease_out,render.ease_in_out,render.elastic_in,render.elastic_out,render.elastic_in_out,render.bounce_in,render.bounce_out,render.bounce_in_out,render.font_flag_shadow,render.font_flag_outline,render.top_left,render.top_right,render.bottom_left,render.bottom_right,render.top,render.left,render.bottom,render.right,render.all

local math_max,math_min,math_sin,math_cos,math_atan2,math_ceil,math_floor,math_pow,math_rad,math_sqrt,math_abs,math_pi=math.max,math.min,math.sin,math.cos,math.atan2,math.ceil,math.floor,math.pow,math.rad,math.sqrt,math.abs,math.pi
local ffi_cast,ffi_cdef,ffi_typeof,ffi_string=ffi.cast,ffi.cdef,ffi.typeof,ffi.string

local function vtable_bind(module, interface, index, type)
    local addr = ffi_cast("void***", utils.find_interface(module, interface)) or error(interface .. " is nil.")
    return ffi_cast(ffi_typeof(type), addr[0][index]), addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local nativeGetLevelName =
    __thiscall(vtable_bind("engine.dll", "VEngineClient014", 53, "const char*(__thiscall*)(void*)"))

local function getLevelName()
    return ffi_string(nativeGetLevelName())
end

local screen_w, screen_h = render_get_screen_size()

local force_shutdown = false

local helper_table = database.load("helper_data")

if helper_table == nil then
    helper_table = {}
end

local helper_enabled_ref = gui_checkbox("misc.helpers.helper_enabled", "misc.helpers", "[Helper] Enable")
local helper_auto_align_ref = gui_checkbox("misc.helpers.helper_auto_align", "misc.helpers", "[Helper] Auto align")
local helper_auto_disable_dt_ref = gui_checkbox("misc.helpers.helper_auto_disable_dt", "misc.helpers", "[Helper] Auto disable dt")
local helper_auto_throw_ref = gui_checkbox("misc.helpers.helper_auto_throw", "misc.helpers", "[Helper] Auto throw")
local helper_load_ref = gui_checkbox("misc.helpers.helper_load", "misc.helpers", "[Helper] Load from clipboard")

local thirdperson_ref = gui_get_checkbox("visuals.other.misc.thirdperson")
local thirdperson_distance_ref = gui_get_slider("visuals.other.misc.thirdperson_distance")
local menu_color_ref = gui_get_color_picker("misc.settings.menu_color")
local antiaim_ref = gui_get_checkbox("rage.antiaim.enable")
local autostrafer_ref = gui_get_combobox("misc.general.auto_strafe")
local fast_fire_ref=gui_get_checkbox("rage.general.fast_fire")
local nade_assistant_ref=gui_get_checkbox("misc.general.nade_assistant")

local HELPER_NULL_TARGET = 0
local HELPER_ALIGN_POSITION = 1
local HELPER_PRE_THROW = 2
local HELPER_PREPARE = 3
local HELPER_RUN = 4
local HELPER_THROW = 5
local HELPER_THROWN = 6
local HELPER_RESET = 7

local state = HELPER_NULL_TARGET

local function optimize_helper_data(data)
    local count = 0
    local data_table = helper_table

    for i, v in pairs(data) do
        if type(v) == "table" then
            data_table[i] = {}
            for x, y in pairs(v) do
                if type(y.name) ~= "table" or type(y.position) ~= "table" or type(y.viewangles) ~= "table" then
                    goto continue
                end
                if
                    type(y.weapon) ~= "string" or type(y.name[2]) ~= "string" or type(y.position[3]) ~= "number" or
                        type(y.viewangles[2]) ~= "number"
                 then
                    goto continue
                end
                if type(y.movement) ~= "nil" then
                    goto continue
                end
                --print(y.name[2])
                table.insert(data_table[i], y)
                ::continue::
            end
            if data_table[i] ~= {} then
                count = count + 1
            else
                data_table[i] = nil
            end
        end
    end

    if count < 1 then
        return
    end

    return data_table
end

helper_load_ref:add_callback(
    function()
        if force_shutdown or not helper_load_ref:get_value() then
            return
        end
        helper_load_ref:set_value(false)

        local helper_data = clipboard.get()
        if helper_data == nil then
            gui_add_notification("Helper", "Failed to import locations")
            return
        end
        helper_data = utils.json_decode(helper_data)
        if helper_data == nil then
            gui_add_notification("Helper", "Locations json format corrupted")
            return
        end
        helper_data = optimize_helper_data(helper_data)
        if helper_data == nil then
            gui_add_notification("Helper", "Locations table format corrupted")
            return
        end

        helper_table = helper_data
        database.save("helper_data", helper_table)

        gui_add_notification("Helper", "Locations imported from clipboard")
    end
)

local function clamp(min, max, value)
    return math_min(math_max(min, value), max)
end

local function angle_vector(angle_x, angle_y)
    local sy = math_sin(math_rad(angle_y))
    local cy = math_cos(math_rad(angle_y))
    local sp = math_sin(math_rad(angle_x))
    local cp = math_cos(math_rad(angle_x))
    return cp * cy, cp * sy, -sp
end

local function getCameraPositionInaccurate()
    local local_player = entities_get_entity(engine_get_local_player())
    local local_pos = Vector(local_player:get_eye_position())
    if not thirdperson_ref:get_value() then
        return local_pos
    end
    local local_angle = Vector(angle_vector(engine_get_view_angles())) * -1
    local camera_pos = local_pos + local_angle * thirdperson_distance_ref:get_value()
    local trace_result = utils.trace(local_pos:vec3(), camera_pos:vec3(), engine_get_local_player())
    local camera_pos = local_pos + local_angle * thirdperson_distance_ref:get_value() * trace_result.fraction * 0.99
    return camera_pos
end

local function getPlayerOrigin(player)
    local x, y = player:get_prop("m_vecOrigin")
    return Vector(x, y, player:get_prop("m_vecOrigin[2]"))
end

local function getPlayerVelocity(player)
    return Vector(player:get_prop("m_vecVelocity[0]"), player:get_prop("m_vecVelocity[1]"), player:get_prop("m_vecVelocity[2]"))
end

local function adjustAngle(angle)
    if angle < 0 then
        angle = (90 + angle * (-1))
    elseif angle > 0 then
        angle = (90 - angle)
    end

    return angle
end

local function getVelocity(player)
    local vx=player:get_prop("m_vecVelocity[0]")
    local vy=player:get_prop("m_vecVelocity[1]")
    return math_sqrt(vx*vx+vy*vy)
end

-- pasted from https://github.com/DreiKamm/gamesense-workshop-luas/blob/main/Helper%20V3%20-%20Grenades%2C%20Movement%2C%20One-ways%20(Legit%20%2B%20HvH).lua
-- modified(improved) by also scanning for map names
local NULL_VECTOR = Vector(0, 0, 0)

local crc32_lt = {}
local function crc32(s, lt)
    lt = lt or crc32_lt
    local b, crc, mask
    if not lt[1] then -- setup table
        for i = 1, 256 do
            crc = i - 1
            for _ = 1, 8 do --eight times
                mask = -bit.band(crc, 1)
                crc = bit.bxor(bit.rshift(crc, 1), bit.band(0xedb88320, mask))
            end
            lt[i] = crc
        end
    end

    crc = 0xffffffff
    for i = 1, #s do
        b = string.byte(s, i)
        crc = bit.bxor(bit.rshift(crc, 8), lt[bit.band(bit.bxor(crc, b), 0xFF) + 1])
    end
    return bit.band(bit.bnot(crc), 0xffffffff)
end

local MAP_PATTERNS = {
    [-2011174878] = "de_train",
    [-1890957714] = "ar_shoots",
    [-1768287648] = "dz_blacksite",
    [-1752602089] = "de_inferno",
    [-1639993233] = "de_mirage",
    [-1621571143] = "de_dust",
    [-1541779215] = "de_sugarcane",
    [-1439577949] = "de_canals",
    [-1411074561] = "de_tulip",
    [-1348292803] = "cs_apollo",
    [-1218081885] = "de_guard",
    [-923663825] = "dz_frostbite",
    [-768791216] = "de_dust2",
    [-692592072] = "cs_italy",
    [-542128589] = "ar_monastery",
    [-222265935] = "ar_baggage",
    [-182586077] = "de_aztec",
    [371013699] = "de_stmarc",
    [405708653] = "de_overpass",
    [549370830] = "de_lake",
    [790893427] = "dz_sirocco",
    [792319475] = "de_ancient",
    [878725495] = "de_bank",
    [899765791] = "de_safehouse",
    [1014664118] = "cs_office",
    [1238495690] = "ar_dizzy",
    [1364328969] = "cs_militia",
    [1445192006] = "de_engage",
    [1463756432] = "cs_assault",
    [1476824995] = "de_vertigo",
    [1507960924] = "cs_agency",
    [1563115098] = "de_nuke",
    [1722587796] = "de_dust2_old",
    [1850283081] = "de_anubis",
    [1900771637] = "de_cache",
    [1964982021] = "de_elysion",
    [2041417734] = "de_cbble",
    [2056138930] = "gd_rialto"
}

local MAP_LOOKUP = {
    de_shortnuke = "de_nuke"
}

local function getMapPattern()
    local world = entities_get_entity(0)
    if world == nil then
        return
    end

    local mins = Vector(world:get_prop("m_WorldMins"))
    local maxs = Vector(world:get_prop("m_WorldMaxs"))

    local str
    if mins ~= NULL_VECTOR or maxs ~= NULL_VECTOR then
        str = string.format("bomb_%.2f_%.2f_%.2f %.2f_%.2f_%.2f", mins.x, mins.y, mins.z, maxs.x, maxs.y, maxs.z)
    end

    if str ~= nil then
        return crc32(str)
    end

    return nil
end

local mapname_cache = {}
local function getMapName()
    local mapname_raw = getLevelName()

    if mapname_raw == nil then
        return
    end

    if mapname_cache[mapname_raw] == nil then
        -- clean up mapname
        local mapname = mapname_raw:gsub("_scrimmagemap$", "")

        if MAP_LOOKUP[mapname] ~= nil then
            -- we have a hardcoded alias for this map
            mapname = MAP_LOOKUP[mapname]
        else
            local is_first_party_map = false
            for key, value in pairs(MAP_PATTERNS) do
                if value == mapname then
                    is_first_party_map = true
                    break
                end
            end

            -- try and find mapname based on patterns if its not a first-party map
            if not is_first_party_map then
                local pattern = getMapPattern()

                if MAP_PATTERNS[pattern] ~= nil then
                    mapname = MAP_PATTERNS[pattern]
                else
                    for key, value in pairs(MAP_PATTERNS) do
                        if string.find(mapname, value) then
                            mapname = value
                            break
                        end
                    end
                end
            end
        end

        mapname_cache[mapname_raw] = mapname
    end

    return mapname_cache[mapname_raw]
end

--paste end

local level_name = getMapName()
function on_level_init()
    level_name = getMapName()
end

local max_alpha = {["fill"] = true}

local font = render_create_font("ev0lve/resources/verdana.ttf", 16, render_font_flag_outline)
local font_icon = render_create_font("ev0lve/resources/undefeated.ttf", 16, render_font_flag_outline)


local icons = {
    ["weapon_molotov"] = "l",
    ["weapon_incgrenade"] = "n",
    ["weapon_hegrenade"] = "j",
    ["weapon_smokegrenade"] = "k",
    ["weapon_flashbang"] = "i"
}

local active_nades = {}

local active_targets = {}

local active_location = nil

local closest_nade = nil
local closest_distance = nil
local closest_difference = nil
local closest_target = nil

local in_attack = bit.lshift(1, 0)
local in_jump = bit.lshift(1, 1)
local in_duck = bit.lshift(1, 2)
local in_forward = bit.lshift(1, 3)
local in_backward = bit.lshift(1, 4)
local in_moveleft = bit.lshift(1, 9)
local in_moveright = bit.lshift(1, 10)
local in_attack2 = bit.lshift(1, 11)
local in_speed = bit.lshift(1, 17)

local auto_throw_ready = false

local function move_to(cmd, origin, pos, speed)
    local vec2pos = pos - origin
    local angle2pos = math_atan2(vec2pos.y, vec2pos.x) * (180 / math_pi)
    local viewpitch, viewyaw = engine_get_view_angles()
    viewyaw = viewyaw - 180
    local moveangle = (adjustAngle(angle2pos - viewyaw) + 90) * (math_pi / 180)
    cmd:set_move(math_cos(moveangle) * speed, math_sin(moveangle) * speed)
end

local function move_angle(cmd, angle, speed)
    local moveangle = angle * (math_pi / 180)
    cmd:set_move(math_cos(moveangle) * speed, math_sin(moveangle) * speed)
end

local start_at = 0
local throw_at = 0
local reset_at = 0
local strafe_backup = autostrafer_ref:get_value()

function on_config_load(name)
    strafe_backup = autostrafer_ref:get_value()
end

local function run_nade_throw(cmd, weapon)
    if active_location == nil then
        state = HELPER_NULL_TARGET
        return
    end
    if active_location.grenade == nil then
        active_location.grenade = {}
    end
    local buttons = {}

    if active_location.duck == 1 then
        buttons[in_duck] = true
    end
    local command_number=cmd:get_command_number()
    local jump = 0
    local run = 0
    local run_yaw = 0
    local strength = 1
    local recovery_yaw = 0
    local delay = 0
    local run_speed = 0
    if active_location.grenade ~= nil then
        strength = active_location.grenade.strength or 1
        jump = active_location.grenade.jump and 1 or 0
        run = active_location.grenade.run or 0
        run_yaw = active_location.grenade.run_yaw or 0
        recovery_yaw = active_location.grenade.recovery_yaw or 0
        delay = active_location.grenade.delay or 0
        run_speed = active_location.grenade.run_speed or 0
        recovery_yaw = -recovery_yaw
        run_yaw = -run_yaw
    end

    cmd:set_view_angles(active_location.viewangles[1], active_location.viewangles[2], 0)

    if state == HELPER_PREPARE or state == HELPER_RUN or state == HELPER_THROWN then
        if strength == 1 then
            buttons[in_attack] = true
            buttons[in_attack2] = false
        elseif strength == 0.5 then
            buttons[in_attack] = true
            buttons[in_attack2] = true
        else
            buttons[in_attack] = false
            buttons[in_attack2] = true
        end
    end
    if
        state == HELPER_PREPARE and weapon:get_prop("m_bPinPulled") == true and
            weapon:get_prop("m_flThrowStrength") == strength
     then
        start_at = command_number
        state = HELPER_RUN
    end

    if state == HELPER_RUN or state == HELPER_THROW or state == HELPER_THROWN then
        if run ~= 0 and run > command_number - start_at then

        elseif state == HELPER_RUN then
            state = HELPER_THROW
        end

        if run ~= 0 then
            if run_speed == 1 then
                buttons[in_speed] = true
            end
            move_angle(cmd, run_yaw, 450)
        end
    end

    if state == HELPER_THROW then
        if jump == 1 then
            buttons[in_jump] = true
        end
        throw_at = command_number
        state = HELPER_THROWN
    end

    if state == HELPER_THROWN then

        if command_number - throw_at >= delay then
            buttons[in_attack] = false
            buttons[in_attack2] = false
        end
        local m_bPinPulled = weapon:get_prop("m_bPinPulled")
        local throw_time = weapon:get_prop("m_fThrowTime")

        if m_bPinPulled == true or (throw_time ~= nil and throw_time > 0 and throw_time < global_vars.curtime) then

        elseif weapon:get_prop("m_fThrowTime")==0 and reset_at~=nil and reset_at>throw_at then
            state = HELPER_RESET
        else
            reset_at = command_number
        end

        local weapon_info = utils.get_weapon_info(weapon:get_prop("m_iItemDefinitionIndex"))
        local console_name =
            weapon_info.console_name == "weapon_incgrenade" and "weapon_molotov" or weapon_info.console_name
        if console_name ~= active_location.weapon then
            reset_at = command_number
            state = HELPER_RESET
        end
    end

    if state == HELPER_RESET then
        autostrafer_ref:set_value(strafe_backup)
        cmd:set_view_angles(active_location.viewangles[1], active_location.viewangles[2], 0)

        if active_location.grenade.run ~= nil then
            local move_yaw
            if active_location.grenade.recovery_yaw ~= nil then
                move_yaw=run_yaw + recovery_yaw
            else
                move_yaw=run_yaw - 180
            end
            move_angle(cmd, move_yaw, 450)
        else
            move_angle(cmd, 0, 0)
        end

        if run ~= 0 and clamp(0,32,run*2) > command_number - reset_at then
        else
            local weapon_info = utils.get_weapon_info(weapon:get_prop("m_iItemDefinitionIndex"))
            local console_name =
            weapon_info.console_name == "weapon_incgrenade" and "weapon_molotov" or weapon_info.console_name
            if console_name ~= active_location.weapon then
                active_location = nil
                state = HELPER_NULL_TARGET
            end
        end
    end

    local cmd_buttons = 0
    for button, pressed in pairs(buttons) do
        if pressed then
            cmd_buttons = cmd_buttons + button
        end
    end

    cmd:set_buttons(cmd_buttons)
end

local stable_ticks = 0
local last_closest_distance=0
local last_last_closest_distance=0

local reenable_fast_fire=false
local reenable_nade_assistant=false

function on_setup_move(cmd)
    if not helper_enabled_ref:get_value() or force_shutdown or level_name == nil then
        return
    end

    local map_data = helper_table[level_name]
    if map_data == nil then
        return
    end

    local camera_pos = getCameraPositionInaccurate()
    local local_player = entities_get_entity(engine_get_local_player())
    if not local_player:is_valid() then
        return
    end
    
    local eye_pos = Vector(local_player:get_eye_position())
    local origin = getPlayerOrigin(local_player)
    local weapon = local_player:get_prop("m_hActiveWeapon")
    if not weapon then
        return
    end

    local weapon = entities_get_entity_from_handle(weapon)
    if not weapon then
        return
    end
    --check to see if netvars are down if true then print(weapon:get_prop("m_iItemDefinitionIndex")) return end
   --[[ if weapon:get_prop("m_iItemDefinitionIndex")==0 then
        gui_add_notification("Helper", "Bro netvars are fucked up again")
        return
    end]]--
    local weapon_info = utils.get_weapon_info(weapon:get_prop("m_iItemDefinitionIndex"))

    if not weapon_info then
        return
    end
    local console_name =
        weapon_info.console_name == "weapon_incgrenade" and "weapon_molotov" or weapon_info.console_name

    active_nades = {}
    active_targets = {}
    local menu_color = menu_color_ref:get_value()
    closest_nade = nil
    closest_distance = nil
    closest_difference = nil
    closest_target = nil
    for i, location in pairs(map_data) do
        if console_name ~= location.weapon then
            max_alpha[i] = 0
            goto skip1
        end
        max_alpha[i] = max_alpha[i] or 0
        max_alpha[i] = max_alpha[i] < 246 and max_alpha[i] + 10 or 255

        local world_pos = Vector(location.position[1], location.position[2], location.position[3])
        local distance = origin:dist_to(world_pos)

        if distance > 1500 then
            goto skip1
        end

        local world_pos_visibility = world_pos:clone()

        if location.position_visibility ~= nil then
            world_pos_visibility =
                world_pos_visibility +
                Vector(
                    location.position_visibility[1],
                    location.position_visibility[2],
                    location.position_visibility[3]
                )
        end
        local do_render = true
        local trace_result = utils.trace(camera_pos:vec3(), world_pos_visibility:vec3(),engine_get_local_player())
        if trace_result.fraction < 0.99 then
            max_alpha[i] = 0
            do_render = false
        end

        table.insert(
            active_nades,
            {
                ["world_pos"] = world_pos,
                ["nade_text"] = icons[weapon_info.console_name] or "v",
                ["location_text"] = location.name[2],
                ["background_alpha"] = clamp(75, math_min(200, max_alpha[i]), 755 - distance),
                ["text_alpha"] = clamp(75, max_alpha[i], 755 - distance),
                ["full_render"] = distance <= 600,
                ["menu_color"] = menu_color,
                ["location"] = location,
                ["do_render"] = do_render
            }
        )

        if distance < 40 then
            local nade_start_position = world_pos:clone()
            nade_start_position.z = nade_start_position.z + (location.duck == 1 and 48 or 64)
            local nade_angle_vector = Vector(angle_vector(location.viewangles[1], location.viewangles[2]))
            local target_location = nade_start_position + nade_angle_vector * 8192
            local trace_result = utils.trace(nade_start_position:vec3(), target_location:vec3(), engine_get_local_player())
            table.insert(
                active_targets,
                {
                    ["world_pos"] = nade_start_position + nade_angle_vector * (8192 * trace_result.fraction),
                    ["location_text"] = location.name[2],
                    ["background_alpha"] = clamp(75, 100, 400 - distance * 10),
                    ["text_alpha"] = clamp(75, 120, 400 - distance * 10),
                    ["related_nade"] = #active_nades,
                    ["menu_color"] = menu_color
                }
            )
            local difference = Vector(angle_vector(engine_get_view_angles())):dist_to(nade_angle_vector)
            if closest_difference == nil or difference * math_sqrt(distance) < closest_difference then
                closest_difference = difference * math_sqrt(distance)
                closest_nade = #active_nades
                closest_target = #active_targets
                closest_distance = distance
            end
        end

        ::skip1::
    end
    local buttons = cmd:get_buttons()
    if
        not helper_auto_align_ref:get_value() or bit.band(buttons, in_forward) == in_forward or
            bit.band(buttons, in_backward) == in_backward or
            bit.band(buttons, in_moveleft) == in_moveleft or
            bit.band(buttons, in_moveright) == in_moveright
     then
        if strafe_backup ~= "Disabled" then
            autostrafer_ref:set_value(strafe_backup)
        end
        if reenable_fast_fire==true then
            reenable_fast_fire=false
            fast_fire_ref:set_value(true)
        end
        if reenable_nade_assistant==true then
            reenable_nade_assistant=false
            nade_assistant_ref:set_value(true)
        end
        last_last_closest_distance=0
        last_closest_distance=0
        state = HELPER_NULL_TARGET
        return
    end

    if state > HELPER_PRE_THROW then
        run_nade_throw(cmd, weapon)
        return
    end

    throw_ready_tick = 0
    jump_tick = 0
    run_tick = 0
    aa_backup = false
   
    if closest_nade ~= nil then
        if helper_auto_disable_dt_ref:get_value() and fast_fire_ref:get_value()==true then
            fast_fire_ref:set_value(false)
            reenable_fast_fire=true
        end
        if nade_assistant_ref:get_value()==true then
            nade_assistant_ref:set_value(false)
            reenable_nade_assistant=true
        end
        if closest_distance > 0.11 and (math_abs(last_last_closest_distance-closest_distance)>0.01 or closest_distance>5) then
            auto_throw_ready = false
            --cmd:set_buttons(bit.bor(buttons, in_speed))
            local velocity = getVelocity(local_player)
            local movement_speed = 450
            if closest_distance < 14 then
                local wishspeed = math.min(450, math.max(1.1+local_player.m_flDuckAmount*10, closest_distance * 9))
                if velocity >= math.min(250, wishspeed)+15 then
                    movement_speed = 0
                else
                    movement_speed = math.max(6, velocity >= math.min(250, wishspeed) and wishspeed*0.9 or wishspeed)
                end
            end
            move_to(cmd, origin, active_nades[closest_nade].world_pos, movement_speed)
            state = HELPER_ALIGN_POSITION
            stable_ticks = 0
            last_last_closest_distance=last_closest_distance
            last_closest_distance=closest_distance
        else
            stable_ticks = stable_ticks + 1
            active_location = active_nades[closest_nade].location
            active_location.id=closest_target
            if active_location.duck then
                active_location.duck = 1
            end

            if active_location.jump then
                active_location.jump = 1
            end
            if active_location.duck == 1 then
                cmd:set_buttons(bit.bor(buttons, in_duck))
            end
            if stable_ticks > 16 then
                state = HELPER_PRE_THROW
                auto_throw_ready = true
                if helper_auto_throw_ref:get_value() then
                    autostrafer_ref:set_value("Disabled")
                    state = HELPER_PREPARE
                end
            end
        end
    else
        stable_ticks = 0
        state = HELPER_NULL_TARGET
        auto_throw_ready = false
        last_last_closest_distance=0
        last_closest_distance=0
    end
end

local render_table={}

local function render_nade_full(nade)
    local w, h = render_get_text_size(font, nade.location_text)
    local w_icon, h_icon = render_get_text_size(font_icon, nade.nade_text)
    w = w + 6
    w_icon = w_icon + 6
    w_total = w + w_icon + 6
    h = h + 2
    local screen_pos = w2s(nade.world_pos)
    local nade_sig=math_ceil(nade.world_pos.x/10)..math_ceil(nade.world_pos.y/10)math_ceil(nade.world_pos.z/10)
    if render_table[nade_sig]~=nil then
        screen_pos.y=math_max(0,screen_pos.y-h*render_table[nade_sig]-2)
        render_table[nade_sig]=render_table[nade_sig]+1
    else
        render_table[nade_sig]=1
    end
    if screen_pos.z == 1 then
        nade.menu_color.a = nade.background_alpha
        render_rect_filled(
            screen_pos.x - w_total / 2,
            screen_pos.y - h / 2,
            screen_pos.x + w_total / 2,
            screen_pos.y - h / 2 - 2,
            nade.menu_color
        )
        render_rect_filled(
            screen_pos.x - w_total / 2,
            screen_pos.y - h / 2,
            screen_pos.x + w_total / 2,
            screen_pos.y + h / 2,
            render_color(40, 40, 40, nade.background_alpha)
        )
        render_text(
            font_icon,
            screen_pos.x - w / 2,
            screen_pos.y,
            nade.nade_text,
            render_color(255, 255, 255, nade.text_alpha),
            render_align_center,
            render_align_center
        )
        render_text(
            font,
            screen_pos.x + w_icon / 2,
            screen_pos.y,
            nade.location_text,
            render_color(255, 255, 255, nade.text_alpha),
            render_align_center,
            render_align_center
        )
    end
end

local function render_nade_icon(nade)
    local w_icon, h_icon = render_get_text_size(font_icon, nade.nade_text)
    h_icon = h_icon + 2
    w_icon = w_icon + 15
    local screen_pos = w2s(nade.world_pos)
    if screen_pos.z == 1 then
        nade.menu_color.a = 75
        render_rect_filled(
            screen_pos.x - w_icon / 2,
            screen_pos.y - h_icon / 2,
            screen_pos.x + w_icon / 2,
            screen_pos.y - h_icon / 2 - 2,
            nade.menu_color
        )
        render_rect_filled(
            screen_pos.x - w_icon / 2,
            screen_pos.y - h_icon / 2,
            screen_pos.x + w_icon / 2,
            screen_pos.y + h_icon / 2,
            render_color(40, 40, 40, 75)
        )
        render_text(
            font_icon,
            screen_pos.x,
            screen_pos.y,
            nade.nade_text,
            render_color(255, 255, 255, 75),
            render_align_center,
            render_align_center
        )
    end
end

local function render_nade(nade)
    if nade.full_render then
        render_nade_full(nade)
    else
        render_nade_icon(nade)
    end
end

local function render_target(target, active)
    local w, h = render_get_text_size(font, target.location_text)
    h = h + 2
    w = w + 15
    local screen_pos = w2s(target.world_pos)
    if screen_pos.z == 0 then
        screen_pos.x = clamp(screen_w / 16, screen_w * (15 / 16), screen_pos.x)
        screen_pos.y = clamp(screen_h / 16, screen_h * (15 / 16), screen_pos.y)
    end
    if active then
        if auto_throw_ready then
            target.menu_color = render_color(50, 255, 100, 0)
        else
            target.menu_color = render_color(255, 50, 100, 0)
        end
    end
    target.menu_color.a = target.background_alpha
    render_rect_filled(
        screen_pos.x - w / 2,
        screen_pos.y - h / 2,
        screen_pos.x + w / 2,
        screen_pos.y - h / 2 - 2,
        target.menu_color
    )
    render_rect_filled(
        screen_pos.x - w / 2,
        screen_pos.y - h / 2,
        screen_pos.x + w / 2,
        screen_pos.y + h / 2,
        render_color(40, 40, 40, target.background_alpha)
    )
    render_text(
        font,
        screen_pos.x,
        screen_pos.y,
        target.location_text,
        render_color(255, 255, 255, target.text_alpha),
        render_align_center,
        render_align_center
    )
end

function on_paint()
    if not helper_enabled_ref:get_value() or force_shutdown then
        return
    end
    render_table={}
    local current_render_target=closest_target
    if active_location~=nil and active_location.id~=nil then
        current_render_target=active_location.id
    end
    if #active_targets > 0 and active_targets[current_render_target]~=nil then
        for i, target in pairs(active_targets) do
            if i ~= current_render_target then
                render_target(target)
            end
        end

        active_targets[current_render_target].background_alpha = clamp(75, 200, 400 - closest_distance * 10)
        active_targets[current_render_target].text_alpha = clamp(75, 255, 400 - closest_distance * 10)
        render_target(active_targets[current_render_target], true)
        active_nades[active_targets[current_render_target].related_nade].do_render = false
        render_nade(active_nades[active_targets[current_render_target].related_nade])

        for i, nade in pairs(active_nades) do
            if not nade.do_render then
                goto next1
            end
            if nade.full_render then
                render_nade_icon(nade)
            end
            ::next1::
        end
        return
    end
    for i, nade in pairs(active_nades) do
        if not nade.do_render then
            goto next2
        end
        render_nade(nade)
        ::next2::
    end
end

function on_shutdown()
    active_nades = {}
    level_name = nil
    force_shutdown = true
end
