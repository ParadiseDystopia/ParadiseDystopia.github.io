-- FumoSight project
local aatab = {"LUA", "B"}
local debugtab = {"AA", "Other"}

local vector = require"vector"

local interface = {

    enabled = ui.new_checkbox(aatab[1], aatab[2], "Adaptive double tap speed"),
    mode = ui.new_slider(aatab[1], aatab[2], "Tickbase", 14, 20, 0, true, "tk"),
    dtspeed = ui.new_multiselect(aatab[1], aatab[2], "Adaptive settings", { "Ping", "FPS", "Distance"}),
    tick_correction = ui.new_checkbox(aatab[1], aatab[2], "Tickbase correction"),
    activation = ui.new_checkbox(aatab[1], aatab[2], "FumoSight anti-aim"),
    fs_direction = ui.new_combobox(aatab[1], aatab[2], "Desync direction", {"Standard", "Reverse", "Smart"}),
    byaw_value = ui.new_slider(aatab[1], aatab[2], "Desync value", 0, 3, 2, true, "\n", 1, {[0] = "Off", [1] = "Minimal", [2] = "Optimal", [3] = "High"}),
    byaw_addons = ui.new_multiselect(aatab[1], aatab[2], "Fake angle options", {"Anti-bruteforce", "Lower fake limit", "Jitter when vulernable", "Jitter when invalid index"}),
    ab_options = ui.new_multiselect(aatab[1], aatab[2], "Anti-bruteforce triggers", {"Enemy miss", "Enemy hit", "Log hit angles"}),
    low_limit_key = ui.new_hotkey(aatab[1], aatab[2], "Low delta key"),
    manual_left_key = ui.new_hotkey(aatab[1], aatab[2], "Left yaw"),
    manual_right_key = ui.new_hotkey(aatab[1], aatab[2], "Right yaw"),
    legit_key = ui.new_hotkey(aatab[1], aatab[2], "Legit anti-aim"),
    freestand_key = ui.new_hotkey(aatab[1], aatab[2], "Freestanding"),
    edge_yaw_key = ui.new_hotkey(aatab[1], aatab[2], "Edge yaw"),
    indicator_style = ui.new_combobox(aatab[1], aatab[2], "Indicator style", {"FumoSight", "Invictus", "Prediction", "Ideal yaw", "Keys"}),
    show_binds = ui.new_checkbox(aatab[1], aatab[2], "Show binds"),
    text_label = ui.new_label(aatab[1], aatab[2], "Text color"),
    text_rgb = ui.new_color_picker(aatab[1], aatab[2], "txt_clr", 133, 216, 255, 255),
    fs_label = ui.new_label(aatab[1], aatab[2], "Freestand text color"),
    fs_rgb = ui.new_color_picker(aatab[1], aatab[2], "fs_clr", 255, 107, 107, 255),
    desync_label = ui.new_label(aatab[1], aatab[2], "Desync bar color"),
    desync_rgb = ui.new_color_picker(aatab[1], aatab[2], "dsy_clr", 79, 201, 105, 255),
}


local debug = {

    label = ui.new_label(debugtab[1], debugtab[2], "FumoSight debug"),
    fs_type = ui.new_combobox(debugtab[1], debugtab[2], "Desync direction scan", {"Wall detection", "enemy_last_seen_pos (dormancy)", "Local player safety"}),
    custom_fake_limit = ui.new_slider(debugtab[1], debugtab[2], "Change fake limit", 0, 60, 58, true, "\n", 1),
    manual_state = ui.new_slider(debugtab[1], debugtab[2], "Manual state", 0, 2, 0)
}

-- needed cheat definitions
local animation = {

    standing = nil,
    moving = nil,
    slow_motion = nil,
    jumping = nil,
    crouching = nil,
    legit_aa = nil,

}

local vars = {

    direction = 1,
    prev_dir = 0,
    prev_hit = 0,
    hit_dir = 0,
    letter_dir = nil,
    manual_arrows = nil,
    ideal_yaw = 0,
    yaw_setup = 0,
    misses = { },
    last_miss = 0,
    anti_bruting = false,
    left_manual = false,
    right_manual = false,
    cur_alpha = 255,
    target_alpha = 0,
    max_alpha = 255,
    min_alpha = 0,
    speed = 0.04,

}

-- references
local aa_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local aa_pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local aa_yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local aa_yaw, aa_yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local aa_yaw_jitter, aa_yaw_jitter_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local aa_body_yaw, aa_body_yaw_offset = ui.reference("AA", "Anti-aimbot angles", "body yaw")
local aa_freestand_bodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
--local aa_fake_limit = ui.reference("AA", "Anti-aimbot angles", "fake yaw limit")
local aa_freestand, aa_freestand_key = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local aa_edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
local ref_legmovement = ui.reference("AA", "Other", "Leg movement")
local ref_slow_motion, ref_slow_motion_key = ui.reference("AA", "Other", "Slow motion")
local ref_doubletap, ref_doubletap_key = ui.reference("Rage", "Aimbot", "Double tap")
local ref_onshot, ref_onshot_key = ui.reference("AA", "Other", "On shot anti-aim")
local ref_fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
--local sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local ref_fl_amount = ui.reference("AA", "Fake lag", "Amount")
local ref_fl_limit = ui.reference("AA", "Fake lag", "Limit")
local ref_fl_variance = ui.reference("AA", "Fake lag", "Variance")
local dt, dt_hk = ui.reference("Rage", "Aimbot", "Double tap")
local dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit")
local fl_limit = ui.reference("AA", "Fake lag", "Limit")
--local shifttick = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks")

local multi_exec = function(func, list)
    if func == nil then
        return
    end

    for ref, val in pairs(list) do
        func(ref, val)
    end
end

-- needed functions
local function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local vec_3 = function(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function GetClosestPoint(A, B, P)
    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }

    local atb2 = a_to_b[1]^2 + a_to_b[2]^2

    local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local function doubletap_charged()
    if not ui.get(ref_doubletap) or not ui.get(ref_doubletap_key) or ui.get(ref_fakeduck) then return false end

    local lp = entity.get_local_player()

    if lp == nil or not entity.is_alive(lp) then return false end

    local weapon = entity.get_prop(lp, "m_hActiveWeapon")

    if weapon == nil then return false end

    local next_attack = entity.get_prop(lp, "m_flNextAttack") + 0.25
    local next_primary_attack = entity.get_prop(weapon, "m_flNextPrimaryAttack") + 0.25

    if next_attack == nil or next_primary_attack == nil then return false end

    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

-- animation definitions
local function animation_state()
    
    local lp = entity.get_local_player()
    local flags = entity.get_prop(lp, "m_fFlags")
    local vector_vel = { entity.get_prop(lp, "m_vecVelocity") }
    local true_velocity = math.floor(math.min(10000, math.sqrt(vector_vel[1]^2 + vector_vel[2]^2)) + 0.5)
    local anim_state = "standing"

    if bit.band(flags, 1) ~= 1 then anim_state = "air" else
        if (entity.get_prop(lp, "m_flDuckAmount") > 0.7) then
            anim_state = "crouching"
        elseif true_velocity > 1 then
            if ui.get(interface.low_limit_key) then
                anim_state = "slowwalk"
            elseif ui.get(interface.legit_key) then
                anim_state = "legit"
            else
                anim_state = "running"
            end
        end
    end
    
    if anim_state == "standing" and not ui.get(ref_fakeduck) then -- this is messy but had to do it this way so i could get my animation states simplified and theres a non fd check so ur duck preset is your fakeduck preset (lol yuli noob)
        animation.standing = true
        animation.moving = false
        animation.jumping = false
        animation.crouching = false
        animation.slow_motion = false
        animation.legit_aa = false
    elseif anim_state == "running" and not ui.get(ref_fakeduck) then
        animation.standing = false
        animation.moving = true
        animation.jumping = false
        animation.crouching = false
        animation.slow_motion = false
        animation.legit_aa = false
    elseif anim_state == "air" and not ui.get(ref_fakeduck) then
        animation.standing = false
        animation.moving = false
        animation.jumping = true
        animation.crouching = false
        animation.slow_motion = false
        animation.legit_aa = false
    elseif anim_state == "crouching" or ui.get(ref_fakeduck) then
        animation.standing = false
        animation.moving = false
        animation.jumping = false
        animation.crouching = true
        animation.slow_motion = false
        animation.legit_aa = false
    elseif anim_state == "slowwalk" and not ui.get(ref_fakeduck) then
        animation.standing = false
        animation.moving = false
        animation.jumping = false
        animation.crouching = false
        animation.slow_motion = true
        animation.legit_aa = false
    elseif anim_state == "legit" then
        animation.standing = false
        animation.moving = false
        animation.jumping = false
        animation.crouching = false
        animation.slow_motion = false
        animation.legit_aa = true
    end
end

local entity_get_player_weapon, entity_get_local_player, entity_get_classname, entity_get_prop, entity_get_all, math_sqrt = entity.get_player_weapon, entity.get_local_player, entity.get_classname, entity.get_prop, entity.get_all, math.sqrt
local key_blocked, key_released = false, false
local choked_commands, choked_commands_prev = 0, 0



-- setup_command runs
local function on_setup_cmd(cmd)

    local legit_key = ui.get(interface.legit_key)
    choked_commands = cmd.chokedcommands

    if not legit_key then
        key_released = true
    else
        ui.set(aa_pitch, "Off")
        ui.set(aa_yaw, "Off")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_fake_limit, 58)
        ui.set(aa_freestand_bodyyaw, true)
        ui.set(aa_body_yaw_offset, 180)
        ui.set(aa_edge_yaw, false)
        ui.set(aa_freestand_key, "on hotkey")
    end

    if not ((legit_key or key_blocked) and (choked_commands > 0 or choked_commands_prev > 0)) then
        choked_commands_prev = choked_commands
        return
    end
    choked_commands_prev = choked_commands

    local local_player = entity.get_local_player()
    local vecOrigin = vector(entity.get_prop(local_player, "m_vecOrigin"))

    local planted_bomb = entity.get_all("CPlantedC4")
    if planted_bomb[1] then
        if entity.get_prop(planted_bomb[1], "m_bBombTicking") == 1 and vecOrigin:dist(vector(entity.get_prop(planted_bomb[1], "m_vecOrigin"))) < 100 then
            return
        end
    end

    local hostages = entity.get_all("CHostage")

    for _, v in next, hostages do
        if vecOrigin:dist(vector(entity.get_prop(v, "m_vecOrigin"))) then
            return
        end
    end

    if key_released and not key_blocked then
        key_released, key_blocked = false, true
    end

    cmd.in_use = 0
    if key_blocked and choked_commands == 0 then
        cmd.in_use = 1
        key_blocked = false
    end
end

-- desync fs
local function desync_direction()

    local lp = entity.get_local_player()
    local entities = entity.get_players(true)

    if not ui.get(interface.activation) or not lp or not entity.is_alive(lp) then return end

    ui.set(aa_freestand_bodyyaw, false)

    local curtime = globals.curtime()

    if vars.hit_dir ~= 0 and curtime - vars.prev_hit > 5 then
        vars.prev_dir = 0
        vars.prev_hit = 0
        vars.hit_dir = 0
    end

    local fs_type = ui.get(interface.fs_direction)
    local byaw_value = ui.get(interface.byaw_value)

    local eye_x, eye_y, eye_z = client.eye_position()
    local camera_pitch, camera_yaw = client.camera_angles()

    local trace_vector = {left = 0, right = 0}

    for i = camera_yaw - 90, camera_yaw + 90, 30 do
        if i ~= camera_yaw then
            local rad = math.rad(i)

            local px, py, pz = eye_x + 256 * math.cos(rad), eye_y + 256 * math.sin(rad), eye_z
            local trace_line = client.trace_line(lp, eye_x, eye_y, eye_z, px, py, pz)
            local direction = i < camera_yaw and "left" or "right"
            
            trace_vector[direction] = trace_vector[direction] + trace_line
        end
    end

    vars.direction = trace_vector.left < trace_vector.right and 1 or 2

    if vars.direction == vars.prev_dir then return end

    vars.prev_dir = vars.direction

    if vars.hit_dir ~= 0 then
        vars.direction = vars.hit_dir == 1 and 2 or 1
    end

    if byaw_value == 1 then
        vars.ideal_yaw = 35
    elseif byaw_value == 2 then
        vars.ideal_yaw = 90
    elseif byaw_value == 3 then
        vars.ideal_yaw = 180
    elseif animation.slow_motion then
        vars.ideal_yaw = 45
    end

    --local fake_limit = ui.get(aa_fake_limit)
    local calculated_angle = fs_type == "Reverse" and (vars.direction == 1 and vars.ideal_yaw or -vars.ideal_yaw) or (vars.direction == 1 and -vars.ideal_yaw or vars.ideal_yaw)

    ui.set(aa_body_yaw_offset, calculated_angle)

    if vars.direction == 1 then vars.letter_dir = "RIGHT" elseif vars.direction == 2 then vars.letter_dir = "LEFT" end
end

local on_player_hurt = function(e)

    if not contains(ui.get(interface.fs_direction), "Smart") then
        return
    end

    local lp = entity.get_local_player()
    local userid, attacker = client.userid_to_entindex(e.userid), client.userid_to_entindex(e.attacker)

    if lp == userid and lp ~= attacker then

        vars.prev_dir = 0


        vars.prev_hit = globals.curtime()
        vars.hit_side = vars.direction
    end
end

-- main antiaim handles
local function main_anti_aim(e)

    local lp = entity.get_local_player()
    local lp_vel = get_velocity(lp)

    if not ui.get(interface.activation) or not lp or not entity.is_alive(lp) then return end

    if ui.get(interface.edge_yaw_key) then
        ui.set(aa_edge_yaw, true)
    else
        ui.set(aa_edge_yaw, false)
    end

    if ui.get(interface.freestand_key) then
        --ui.set(aa_freestanding, "Default")
        ui.set(aa_freestand_key, "Always on")
    else
        ui.set(aa_freestand_key, "On hotkey")
    end

    if animation.standing == true then -- standing
        vars.yaw_setup = 7
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 30)
        ui.set(aa_body_yaw, "Static")
        --ui.set(aa_fake_limit, math.random(20, 40))
    elseif animation.moving == true and lp_vel < 115 then -- moving when velocity is below 115
        vars.yaw_setup = 13
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180 Z")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_body_yaw_offset, 65)
        ui.set(aa_fake_limit, 21)
     elseif animation.moving == true and lp_vel >= 115 then -- moving when velocity is above 115
        vars.yaw_setup = 0
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Offset")
        ui.set(aa_yaw_jitter_offset, -5)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_fake_limit, math.random(25, 35))
    elseif animation.jumping == true and client.key_state(0x11) then -- in air crouching
        vars.yaw_setup = 20
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_body_yaw_offset, 60)
        ui.set(aa_fake_limit, math.random(38, 48))
    elseif animation.jumping == true and not client.key_state(0x11) and choked_commands >= 2 then -- in air not crouching and using fakelag
        vars.yaw_setup = 2
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_fake_limit, math.random(38, 48))
    elseif animation.jumping == true and not client.key_state(0x11) and choked_commands < 2 then -- in air not crouching and using doubletap
        vars.yaw_setup = 5
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_body_yaw_offset, 0)
        ui.set(aa_fake_limit, 45)
    elseif animation.slow_motion == true then -- slowwalk
        vars.yaw_setup = 8
        ui.set(aa_pitch, "Default")
        ui.set(aa_yaw, "180 Z")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_body_yaw_offset, 65)
        ui.set(aa_fake_limit, 23)
    elseif animation.crouching == true then -- crouching/fakeduck
        vars.yaw_setup = 15
        ui.set(aa_pitch, "Down")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Center")
        ui.set(aa_yaw_jitter_offset, 0)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_fake_limit, math.random(20, 40))
    elseif animation.legit_aa == true then -- legit antiaim
        vars.yaw_setup = 180
        ui.set(aa_pitch, "Off")
        ui.set(aa_yaw, "180")
        ui.set(aa_yaw_jitter, "Off")
        ui.set(aa_yaw_jitter_offset, -5)
        ui.set(aa_body_yaw, "Static")
        ui.set(aa_fake_limit, 58)
    end
end

-- manual anti aim setup

local bind_system = {
    left = false,
    right = false,
}

function bind_system:update()
    ui.set(interface.manual_left_key, "On hotkey")
    ui.set(interface.manual_right_key, "On hotkey")

    local m_state = ui.get(debug.manual_state)

    local left_state, right_state = 
        ui.get(interface.manual_left_key), 
        ui.get(interface.manual_right_key)

    if  left_state == self.left and 
        right_state == self.right then
        return
    end

    self.left, self.right = 
        left_state, 
        right_state

    if (ui.get(interface.manual_left_key) and m_state == 1) or (ui.get(interface.manual_right_key) and m_state == 2) then
        ui.set(debug.manual_state, 0)
        return
    end

    if ui.get(interface.manual_left_key) and m_state ~= 1 then
        ui.set(debug.manual_state, 1)
        vars.manual_arrows = "<<"
    end

    if ui.get(interface.manual_right_key) and m_state ~= 2 then
        ui.set(debug.manual_state, 2)
        vars.manual_arrows = ">>"
    end
end

local function manual_aa_handle()
    if not ui.get(interface.activation) then return end

    local direction = ui.get(debug.manual_state)

    local manual_yaw = {
        [0] = vars.yaw_setup,
        [1] = -90, [2] = 90
    }

    if direction == 1 or direction == 2 or animation.legit_aa == true then
        ui.set(aa_yaw_base, "Local view")
    else
        ui.set(aa_yaw_base, "At targets")
    end

    ui.set(aa_yaw_offset, manual_yaw[direction])
end

local function new_anti_brute(e)
    if not contains(ui.get(interface.byaw_addons), "Anti-bruteforce") then return end

    local lp = entity.get_local_player()

    if not entity.is_alive(lp) then return end

    local shooter_id = e.userid
    local shooter = client.userid_to_entindex(shooter_id)

    if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

    local enemy_pos = vec_3(entity.get_prop(shooter, "m_vecOrigin"))

    local local_pos = vec_3(entity.hitbox_position(lp, 0))

    local dist = ((e.y - enemy_pos.y)*local_pos.x - (e.x - enemy_pos.x)*local_pos.y + e.x*enemy_pos.y - e.y*enemy_pos.x) / math.sqrt((e.y-enemy_pos.y)^2 + (e.x - enemy_pos.x)^2)

    if math.abs(dist) <= 85 and globals.curtime() - vars.last_miss > 0.015 then
        vars.last_miss = globals.curtime()
        if vars.misses[shooter] == nil then
            vars.misses[shooter] = 1 
        elseif vars.misses[shooter] >= 2 then
            vars.misses[shooter] = nil
        else
            vars.misses[shooter] = vars.misses[shooter] + 1
        end
    end
end

local function indicators()

    local lp = entity.get_local_player()

    if not ui.get(interface.activation) or not lp or not entity.is_alive(lp) then return end

    -- thanks bishal
    if (vars.cur_alpha < vars.min_alpha + 2) then
        vars.target_alpha = vars.max_alpha
    elseif (vars.cur_alpha > vars.max_alpha - 2) then
        vars.target_alpha = vars.min_alpha
    end
    vars.cur_alpha = vars.cur_alpha + (vars.target_alpha - vars.cur_alpha)*vars.speed*(globals.absoluteframetime()*100)
    pulse = math.min(255, vars.cur_alpha)

    local s1, s2 = client.screen_size()
    local center_x, center_y = s1 / 2, s2 / 2
    local body_yaw = math.max(-60, math.min(60, round((entity.get_prop(lp, "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
    local t_r, t_g, t_b, t_a = ui.get(interface.text_rgb)
    local f_r, f_g, f_b, f_a = ui.get(interface.fs_rgb)
    local d_r, d_g, d_b, d_a = ui.get(interface.desync_rgb)
    fs_letter_direction = vars.letter_dir
    manual_dir = vars.manual_arrows

    if ui.get(interface.indicator_style) == "FumoSight" then
        renderer.text(center_x, center_y + 35, 255, 255, 255, 255, "d-", 0, "FUMOSIGHT")
        if ui.get(interface.fs_direction) == "Standard" then
            renderer.text(center_x, center_y + 45, f_r, f_g, f_b, pulse, "d-", 0, "STANDARD:")
            renderer.text(center_x + 42, center_y + 45, 171, 174, 255, pulse, "d-", 0, fs_letter_direction)
        elseif ui.get(interface.fs_direction) == "Reverse" then
            renderer.text(center_x, center_y + 45, f_r, f_g, f_b, pulse, "d-", 0, "REVERSED:")
            renderer.text(center_x + 39, center_y + 45, 171, 174, 255, pulse, "d-", 0, fs_letter_direction)
        elseif ui.get(interface.fs_direction) == "Smart" then
            renderer.text(center_x, center_y + 45, f_r, f_g, f_b, pulse, "d-", 0, "SMART:")
            renderer.text(center_x + 28, center_y + 45, 171, 174, 255, pulse, "d-", 0, fs_letter_direction)
        end
        if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
            if doubletap_charged() then
                renderer.text(center_x, center_y + 55, 0, 255, 0, 255, "d-", 0, "DT")
            else
                renderer.text(center_x, center_y + 55, 255, 0, 0, 255, "d-", 0, "DT")
            end
        else
            renderer.text(center_x, center_y + 55, 255, 255, 255, 120, "d-", 0, "DT")
        end
        if ui.get(ref_onshot) and ui.get(ref_onshot_key) then
            renderer.text(center_x + 11, center_y + 55, 255, 198, 84, 255, "d-", 0, "HS")
        else
            renderer.text(center_x + 11, center_y + 55, 255, 255, 255, 120, "d-", 0, "HS")
        end
        if ui.get(interface.freestand_key) then
            renderer.text(center_x + 23, center_y + 55, 125, 222, 255, 255, "d-", 0, "FS")
        else
            renderer.text(center_x + 23, center_y + 55, 255, 255, 255, 120, "d-", 0, "FS")
        end
        if ui.get(debug.manual_state) == 0 then
            renderer.text(center_x + 34, center_y + 55, 255, 255, 255, pulse, "d-", 0, "M:B")
        elseif ui.get(debug.manual_state) == 1 then
            renderer.text(center_x + 34, center_y + 55, 255, 255, 255, pulse, "d-", 0, "<<")
        elseif ui.get(debug.manual_state) == 2 then
            renderer.text(center_x + 34, center_y + 55, 255, 255, 255, pulse, "d-", 0, ">>")
        end
    end

    if ui.get(interface.indicator_style) == "Invictus" then
        renderer.text(center_x, center_y + 25, 255, 255, 255, 255, "c", 0, body_yaw.."°")
	    renderer.gradient(center_x, center_y + 35, -body_yaw, 3, d_r, d_g, d_b, d_a, 0, 0, 0, 0, true)
	    renderer.gradient(center_x, center_y + 35, body_yaw, 3, d_r, d_g, d_b, d_a, 0, 0, 0, 0, true)
        renderer.text(center_x, center_y + 45, t_r, t_g, t_b, t_a, "c", 0, "FumoSight")
        if ui.get(interface.show_binds) and ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
            if doubletap_charged() then
                renderer.text(center_x, center_y + 55, 0, 255, 0, 255, "c", 0, "DT")
            else
                renderer.text(center_x, center_y + 55, 254, 0, 0, 255, "c", 0, "DT")
            end
        end
        if ui.get(interface.show_binds) and ui.get(ref_onshot) and ui.get(ref_onshot_key) then
            if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
                renderer.text(center_x, center_y + 65, 255, 170, 59, 255, "c", 0, "HS")
            else
                renderer.text(center_x, center_y + 55, 255, 170, 59, 255, "c", 0, "HS")
            end
        end
    end

    if ui.get(interface.indicator_style) == "Prediction" then
        renderer.text(center_x, center_y + 15, t_r, t_g, t_b, t_a, "c-", 0, "FumoSight")
        if ui.get(interface.fs_direction) == "Standard" then
            renderer.text(center_x, center_y + 25, f_r, f_g, f_b, pulse, "c-", 0, "STANDARD")
        elseif ui.get(interface.fs_direction) == "Reverse" then
            renderer.text(center_x, center_y + 25, f_r, f_g, f_b, pulse, "c-", 0, "REVERSED")
        elseif ui.get(interface.fs_direction) == "Smart" then
            renderer.text(center_x, center_y + 25, f_r, f_g, f_b, pulse, "c-", 0, "SMART")
        end
        if ui.get(interface.show_binds) then
            if not doubletap_charged() then
                renderer.text(center_x, center_y + 35, 255, 0, 0, 255, "c-", 0, "DT")
            else
                renderer.text(center_x, center_y + 35, 0, 255, 0, 255, "c-", 0, "DT")
            end
            if ui.get(ref_onshot) and ui.get(ref_onshot_key) then
                renderer.text(center_x, center_y + 45, 255, 170, 59, 255, "c-", 0, "HS")
            end
        end
    end

    if ui.get(interface.indicator_style) == "Ideal yaw" then
        renderer.text(center_x, center_y + 40, 218, 118, 0, 255, nil, 0, "FUMO YAW")
        renderer.text(center_x, center_y + 50, 209, 139, 230, 255, nil, 0, "DYNAMIC")
        if ui.get(interface.show_binds) then
            if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
                renderer.text(center_x, center_y + 60, 0, 255, 0, 255, nil, 0, "DT")
            end
            if ui.get(ref_onshot) and ui.get(ref_onshot_key) then
                if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
                    renderer.text(center_x, center_y + 70, 209, 139, 230, 255, nil, 0, "AA")
                else
                    renderer.text(center_x, center_y + 60, 209, 139, 230, 255, nil, 0, "AA")
                end
            end
        end
    end

    if ui.get(interface.indicator_style) == "Keys" then
        if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
            if not doubletap_charged() then
                renderer.text(center_x, center_y + 25, 255, 0, 0, 255, "c-", 0, "DT")
            else
                renderer.text(center_x, center_y + 25, 255, 255, 255, 255, "c-", 0, "DT")
            end
        end
        if ui.get(ref_onshot) and ui.get(ref_onshot_key) then
            if ui.get(ref_doubletap) and ui.get(ref_doubletap_key) then
                renderer.text(center_x, center_y + 35, 255, 255, 255, 255, "c-", 0, "ONSHOT")
            else
                renderer.text(center_x, center_y + 25, 255, 255, 255, 255, "c-", 0, "ONSHOT")
            end
        end
    end
end

-- needed so anti brute actually works loL!
local function brute_reset()
    vars.misses = { }
    vars.last_miss = 0
end

-- // FPS function
local frametimes = {}
local fps_prev = 0
local last_update_time = 0
local function accumulate_fps()
	local ft = globals.absoluteframetime()
	if ft > 0 then
		table.insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table.remove(frametimes)
	end
	
	local fps = 1 / accum
	local rt = globals.realtime()
	if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	
	return math.floor(fps + 0.5)
end

-- // Shifting tickbase function
local function dtboost()
	ui.set(fl_limit, math.min(61, ui.get(fl_limit))) --so you can serverside in some server HAAHHAHAHAHA

	if ui.get(interface.tick_correction) then
		cvar.cl_clock_correction:set_int(1)
	else
		cvar.cl_clock_correction:set_int(0)
	end

	if ui.get(interface.enabled) then
		ui.set(dt, true)
		if ui.get(interface.mode) == 14 then
			--ui.set(shifttick, 14)
        elseif ui.get(interface.mode) == 15 then
			ui.set(shifttick, 15)
		elseif ui.get(interface.mode) == 16 then
			ui.set(shifttick, 16)
		elseif ui.get(interface.mode) == 17 then
			ui.set(shifttick, 17)
			cvar.cl_clock_correction_force_server_tick:set_int(999)
			cvar.cl_clock_correction_adjustment_min_offset:set_int(10)
	        cvar.cl_clock_correction_adjustment_max_offset:set_int(20)
	        cvar.cl_clock_correction_adjustment_max_amount:set_int(100)
		elseif ui.get(interface.mode) == 18 then
			ui.set(shifttick, 18)
			cvar.cl_clock_correction_force_server_tick:set_int(999)
			cvar.cl_clock_correction_adjustment_min_offset:set_int(10)
			cvar.cl_clock_correction_adjustment_max_offset:set_int(18)
			cvar.cl_clock_correction_adjustment_max_amount:set_int(100)
		elseif ui.get(interface.mode) == 20 then
			ui.set(shifttick, 20)
			cvar.cl_clock_correction_force_server_tick:set_int(99)
			cvar.cl_clock_correction_adjustment_min_offset:set_int(10)
			cvar.cl_clock_correction_adjustment_max_offset:set_int(20)
			cvar.cl_clock_correction_adjustment_max_amount:set_int(100)
		end
	end
end
ui.set_callback(interface.enabled, dtboost)
ui.set_callback(interface.mode, dtboost)
ui.set_callback(fl_limit, dtboost)

local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return round(yaw)
end

local function calc_angle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local ydelta = localplayerypos - enemyypos
    local xdelta = localplayerxpos - enemyxpos
    local relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = normalize_yaw(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = normalize_yaw(relativeyaw + 180)
    end
    return relativeyaw
end

local function get_fov(enemy)
    local camerax, cameray, cameraz = client.camera_angles()
    local hx, hy, hz = entity.hitbox_position(enemy, "head_0")
    local lx, ly, lz = entity.hitbox_position(entity.get_local_player(), "head_0")

    local eyaw = calc_angle(lx, ly, hx, hy)

    local res = normalize_yaw(cameray - eyaw)

    if res ~= res then
        res = 0
    end

    return math.abs(res)
end

local function contains(tab, val, sys)
    for index, value in ipairs(tab) do
        if sys == 1 and index == val then 
            return true
        elseif value == val then
            return true
        end
    end
    return false
end

client.set_event_callback("setup_command", function(e)
	local me = entity.get_local_player()
	if not entity.is_alive(me) then return end

	local final_speed = 1
	local speed_settings = ui.get(interface.dtspeed)

	local localhealth = entity.get_prop(me, "m_iHealth")

    local players = entity.get_players(true)

	local fps = accumulate_fps()

    local fov = 999
    local closestplayer = nil
	for i=1, #players do
		local cur_fov = get_fov(players[i])
		if cur_fov < fov then
			fov = cur_fov
			closestplayer = players[i]
		end
    end
    
	if closestplayer ~= nil and contains(speed_settings, "Distance") then
        local ex, ey, ez = entity.get_prop(closestplayer, "m_vecOrigin")
        if ex ~= nil then
            local lx, ly, lz = entity.get_prop(me, "m_vecOrigin")
            local dx, dy, dz = ex-lx, ey-ly, ez-lz
            local distance = math.sqrt(dx^2 + dy^2 + dz^2)
    
            final_speed = math.max(math.min(round(distance / 500), 3), 1)
        end
    end

	if contains(speed_settings, "Ping") then
		local lat_tick = math.floor(client.latency() / (globals.tickinterval() * 10))
		final_speed = math.min(final_speed + lat_tick, 3)
	end

	if contains(speed_settings, "FPS") then
		if fps < 60 then
			final_speed = 4
		elseif fps < 120 then
			final_speed = 3
		elseif fps > 180 then
			final_speed = 1
		end
	end

	ui.set(dt_fl, final_speed)
end)

client.set_event_callback("run_command", dtboost)

-- all paint func calls
client.set_event_callback("paint", function()

	if not ui.get(interface.activation) then return end

	animation_state()
    bind_system:update()
    indicators()

end)

-- all run command func calls
client.set_event_callback("run_command", function(c)

    manual_aa_handle()

end)

-- all setup command func calls
client.set_event_callback("setup_command", function(cmd)    
    desync_direction()
    main_anti_aim()
    on_setup_cmd(cmd)
end)

ui.set_callback(interface.fs_direction, function(self)
    vars.prev_dir = 0
end)

-- all solo calls
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback('bullet_impact', new_anti_brute)
client.set_event_callback('round_start', brute_reset)
