

--[[
    Holo panel.lua
    Author: glock#0690

    Credits:
    » Salvatore: Some functions from anti-aim library examples + solus and the entire idea.
    » Bass: Previously helped with animations.
    » Clown: Spoonfed me easing a while ago.
    » Yukine: Spoonfed weapon attachment stuff.
    » Midnight: Updated the weapon attachment stuff to work with riptide.
    » All the other people who helped with this project
]]

local panorama = panorama.open()

local requires = {
    ['easing'] = 'https://gamesense.pub/forums/viewtopic.php?id=22920',
    ['antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665',
    ['clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678',
    ['base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619'
}

local notified = 0
for name, url in pairs(requires) do
    if not pcall(require, ('gamesense/%s'):format(name)) then
        print('Missing dependencies found, opening them in your browser.')
        print(('[%s]: %s'):format(name, url))
        panorama.SteamOverlayAPI.OpenExternalBrowserURL(url)
        print('Subscribe to the dependencies, reinject for the script to work.')
    end
end

local ffi = require 'ffi'
local vector = require 'vector'

local easing = require 'gamesense/easing'
local anti_aim = require 'gamesense/antiaim_funcs'
local clipboard = require 'gamesense/clipboard'
local base64 = require 'gamesense/base64'

local pulse = function(a) return math.sin(math.abs(math.pi+(globals.realtime())%(-math.pi*2)))*a end
local round = function(b,c)local d=10^(c or 0)return math.floor(b*d+0.5)/d end
local clamp = function(b,c,d)return math.min(d,math.max(c,b))end
local contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end
local hsv_to_rgb = function(b,c,d,e)local f,g,h;local i=math.floor(b*6)local j=b*6-i;local k=d*(1-c)local l=d*(1-j*c)local m=d*(1-(1-j)*c)i=i%6;if i==0 then f,g,h=d,m,k elseif i==1 then f,g,h=l,d,k elseif i==2 then f,g,h=k,d,m elseif i==3 then f,g,h=k,l,d elseif i==4 then f,g,h=m,k,d elseif i==5 then f,g,h=d,k,l end;return f*255,g*255,h*255,e*255 end
local table_visible = function(a,b)for c,d in pairs(a)do if type(a[c])=='table'then for e,d in pairs(a[c])do ui.set_visible(a[c][e],b)end else ui.set_visible(a[c],b)end end end
local colors = {{255,0,0},{237,27,3},{235,63,6},{229,104,8},{228,126,10},{220,169,16},{213,201,19},{176,205,10},{124,195,13}}
local math_num = function(b,c,d)local b=b>c and c or b;local e=c/b;if not d then d=c end;local f=d/e;f=f>=0 and math.floor(f+0.5)or math.ceil(f-0.5)return f end
local get_color = function(b,c)local d=math_num(b,c,#colors)return colors[d<=1 and 1 or d][1],colors[d<=1 and 1 or d][2],colors[d<=1 and 1 or d][3],d end

local lerp = function(a, b, t)
    if type(a) == 'table' then
        local result = {}
        for k, v in pairs(a) do
            result[k] = a[k] + (b[k] - a[k]) * t
        end
        return result
    elseif type(a) == 'cdata' then
        return vector(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t)
    else
        return a + (b - a) * t
    end
end

local menu = {
    tab = {'AA', 'LUA'},
    container = {'Other', 'B'}
}

local reference = {
    third_person = { ui.reference('VISUALS', 'Effects', 'Force third person (alive)') }, -- this could mean a lot honestly
    double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
    on_shot = { ui.reference('AA', 'Other', 'On shot anti-aim') }
}
local interface = {   
    main = {
        enabled = ui.new_checkbox(menu.tab[1], menu.container[1], 'Attachment panel'),

        elements = {
            color = ui.new_color_picker(menu.tab[1], menu.container[1], 'Attachment panel color', 142, 165, 229, 255),
            pallete = ui.new_combobox(menu.tab[1], menu.container[1], 'Color pallete', {'Solid', 'Fade', 'Dynamic fade'}),
            perspective = ui.new_multiselect(menu.tab[1], menu.container[1], 'Perspective mode', {'First person', 'Third person'}),
            link = {
                mode = ui.new_combobox(menu.tab[1], menu.container[1], 'Link to the muzzle', {'Off', 'Line', 'Glow line'}),
                color = ui.new_color_picker(menu.tab[1], menu.container[1], 'Link color', 85, 85, 85, 255),
                second_color = ui.new_color_picker(menu.tab[1], menu.container[1], 'Link color 2', 142, 165, 229, 255),
            },
            scope = ui.new_checkbox(menu.tab[1], menu.container[1], 'Show panel in scope'),
        }
    },

    editor = {
        enabled = ui.new_checkbox(menu.tab[2], menu.container[2], 'Attachment panel editor'),

        elements = {
            blur = ui.new_checkbox(menu.tab[2], menu.container[2], 'Panorama blur'),
            smoothing = ui.new_slider(menu.tab[2], menu.container[2], 'Smoothing', 50, 200, 100, true, '', 0.01, {}),
            perspective = {
                mode = ui.new_combobox(menu.tab[2], menu.container[2], 'Panel perspective options', {'First person', 'Third person'}),
                first = {
                    offset = ui.new_slider(menu.tab[2], menu.container[2], 'Panel lean offset', 0, 260, 45, true, 'px', 1, {}),
                    angle = ui.new_slider(menu.tab[2], menu.container[2], 'Panel lean angle', 0, 360, 315, true, '°', 1, {}),
                },
                third = {
                    offset = ui.new_slider(menu.tab[2], menu.container[2], 'Panel lean offset', 0, 260, 45, true, 'px', 1, {}),
                    angle = ui.new_slider(menu.tab[2], menu.container[2], 'Panel lean angle', 0, 360, 315, true, '°', 1, {}),
                }
            },

            header = {
                thickness = ui.new_slider(menu.tab[2], menu.container[2], 'Header thickness', 0, 10, 2, true, 'px', 1, {}),
                offset = ui.new_slider(menu.tab[2], menu.container[2], 'Fade offset', 1, 1000, 825, false, nil, 0.001),
                frequency = ui.new_slider(menu.tab[2], menu.container[2], 'Fade frequency', 1, 100, 10, false, nil, 0.01),
                split_ratio = ui.new_slider(menu.tab[2], menu.container[2], 'Fade split ratio', 0, 100, 100, false, nil, 0.01)
            },

            _ = ui.new_label(menu.tab[2], menu.container[2], 'Background color'),
            color = ui.new_color_picker(menu.tab[2], menu.container[2], 'Background color', 17, 17, 17, 85),

            glow_line = {
                step = ui.new_slider(menu.tab[2], menu.container[2], 'Glow line step', 2, 48, 6, true, '', 1, {}),
                width = ui.new_slider(menu.tab[2], menu.container[2], 'Glow line width [*fps]', 1, 16, 8, true, '', 1, {}),
                interpolation = ui.new_slider(menu.tab[2], menu.container[2], 'Glow line interpolatio [*fps]', 2, 256, 32, true, '', 1, {}),
                pulse_speed = ui.new_slider(menu.tab[2], menu.container[2], 'Glow line pulse speed', 0, 500, 0, true, '', 0.01, {})
            }
        },
    }
}

local get_bar_color = function()
    local r, g, b, a = ui.get(interface.main.elements.color)

    local palette = ui.get(interface.main.elements.pallete)

    if palette ~= 'Solid' then
        local rgb_split_ratio = ui.get(interface.editor.elements.header.split_ratio) / 100

        local h = palette == 'Dynamic fade' and
            globals.realtime() * (ui.get(interface.editor.elements.header.frequency) / 100) or
            ui.get(interface.editor.elements.header.offset) / 1000

        r, g, b = hsv_to_rgb(h, 1, 1, 1)
        r, g, b =
            r * rgb_split_ratio,
            g * rgb_split_ratio,
            b * rgb_split_ratio
    end

    return r, g, b, a
end

local log = function(msg, ...)
    local arg = {...}
    local con = table.concat(arg, ' ')

    local r, g, b, a = ui.get(interface.main.elements.color)

    client.color_log(r, g, b, '[Attachment Panel] \0')
    client.color_log(255, 255, 255, msg, con)
end

local line_gradient = function(pos1, pos2, color1, color2, step)
    if color1[4] < 5 and color2[4] < 5 then
        return
    end

    local difference, step = pos2-pos1, step or 16
    local width, height = difference.x, difference.y

    local length = math.min(step, math.sqrt(width*width + height*height))
    local step_x, step_y = width / length, height / length

    for i=1, length do
        local pos1_1 = vector(pos1.x + step_x*(i-1), pos1.y + step_y*(i-1))
        local pos2_2 = vector(pos1.x + step_x*i, pos1.y + step_y*i)

        local lerped = lerp(color1, color2, i/length)

        renderer.line(
            pos1_1.x, pos1_1.y, pos2_2.x, pos2_2.y, lerped[1], lerped[2], lerped[3], lerped[4]
        )
    end
end

local glow_line = function(pos1, pos2, color1, color2, color_interp, width, step, speed) -- salvatore kodenz for neverlose
    local lerp_center = lerp(pos1, pos2, 0.5)

    local clr1 = { color1[1], color1[2], color1[3], 0 }

    line_gradient(pos1, lerp_center, clr1, color1, color_interp)
    line_gradient(lerp_center, pos2, color1, color2, color_interp)

    local a = color1[4] * .5
    local lerp_step = 1 / (width*step)

    local realtime =
        math.sin(globals.realtime() * speed) * .5 + .5

    local perpendicular =
        pos1:to(pos2):cross(vector(0, 0, 1))
        lerp(pos1, pos2, realtime)

    for i = 1, width do
        local v1, v2 =
            pos1 + perpendicular * i,
            pos2 + perpendicular * i

        local v1v2center = lerp(v1, v2, realtime)

        v1, v2 =
            lerp(v1v2center, v1, 1 - lerp_step * i),
            lerp(v1v2center, v2, 1 - lerp_step * i)


        local v3, v4 =
            pos1 - perpendicular * i,
            pos2 - perpendicular * i

        local v3v4center = lerp(v3, v4, .5)

        v3, v4 =
            lerp(v3v4center, v3, 1 - lerp_step * i),
            lerp(v3v4center, v4, 1 - lerp_step * i)


        local multiplier = 1 - math.log10(i) / math.log10(width)
        local alpha = a * multiplier

        if speed and speed > 0 then
            alpha = alpha * realtime
        end

        local clr_step = { color1[1], color1[2], color1[3], alpha }
        local clr_2 = { color2[1], color2[2], color2[3], 0 }

        line_gradient(v1, v1v2center, clr1, clr_step, color_interp)
        line_gradient(v1v2center, v2, clr_step, clr_2, color_interp)
        line_gradient(v3, v3v4center, clr1, clr_step, color_interp)
        line_gradient(v3v4center, v4, clr_step, clr_2, color_interp)
    end
end
ui.new_button(menu.tab[2], menu.container[2], 'Copy preset', function()
    pcall(function()
        local preset = {}


        for k, v in pairs(interface.editor.elements) do
            if k ~= '_' then
                if type(v) == 'table' then
                    for k2, v2 in pairs(v) do
                        if type(v2) == 'table' then
                            for k3, v3 in pairs(v2) do
                                preset[k .. '_' .. k2 .. '_' .. k3] = ui.get(v3)
                            end
                        else
                            preset[k .. '_' .. k2] = ui.get(v2)
                        end
                    end
                else
                    preset[k] = ui.get(v)
                end
            end
        end

        for k, v in pairs(interface.main.elements) do
            if type(v) == 'table' then
                for k2, v2 in pairs(v) do
                    preset[k .. '_' .. k2] = ui.get(v2)
                end
            else
                preset[k] = ui.get(v)
            end
        end
        
        local str = json.stringify(preset)
        clipboard.set(base64.encode(str))
    
        log('Preset copied to clipboard')
    end)
end)

local copy_button = ui.reference(menu.tab[2], menu.container[2], 'Copy preset')

ui.new_button(menu.tab[2], menu.container[2], 'Paste preset', function()
    pcall(function()
        local preset = json.parse(base64.decode(clipboard.get()))

        for k, v in pairs(interface.editor.elements) do
            if k ~= '_' then
                if type(v) == 'table' then
                    for k2, v2 in pairs(v) do
                        if type(v2) == 'table' then
                            for k3, v3 in pairs(v2) do
                                ui.set(v3, preset[k .. '_' .. k2 .. '_' .. k3])
                            end
                        else
                            ui.set(v2, preset[k .. '_' .. k2])
                        end
                    end
                else
                    ui.set(v, preset[k])
                end
            end
        end

        for k, v in pairs(interface.main.elements) do
            if type(v) == 'table' then
                for k2, v2 in pairs(v) do
                    ui.set(v2, preset[k .. '_' .. k2])
                end
            else
                ui.set(v, preset[k])
            end
        end
    
        log('Preset pasted from clipboard.')
    end)
end)
local paste_button = ui.reference(menu.tab[2], menu.container[2], 'Paste preset')

local handle_interface = function()
    local enabled = ui.get(interface.main.enabled)
    local link_mode = ui.get(interface.main.elements.link.mode)
    local editor = ui.get(interface.editor.enabled)

    table_visible(interface.main.elements, enabled)
    table_visible({interface.editor.elements.blur, interface.editor.elements.smoothing, interface.editor.elements._, interface.editor.elements.color}, enabled and editor)
    table_visible(interface.editor.elements.perspective, enabled and editor)
    table_visible(interface.editor.elements.perspective.first, enabled and editor and ui.get(interface.editor.elements.perspective.mode) == 'First person')
    table_visible(interface.editor.elements.perspective.third, enabled and editor and ui.get(interface.editor.elements.perspective.mode) == 'Third person')
    table_visible(interface.editor.elements.header, enabled and editor)
    table_visible({interface.editor.elements.header.offset, interface.editor.elements.header.frequency, interface.editor.elements.header.split_ratio}, enabled and editor and ui.get(interface.main.elements.pallete) ~= 'Solid')
    table_visible({interface.editor.elements.glow_line, interface.main.elements.link.second_color}, enabled and link_mode == 'Glow line')
    ui.set_visible(interface.editor.enabled, enabled)
    ui.set_visible(copy_button, enabled and editor)
    ui.set_visible(paste_button, enabled and editor)
end

pClientEntityList = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("invalid interface", 2)
fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)")

ffi.cdef('typedef struct { float x; float y; float z; } bbvec3_t;')

local fnGetAttachment = vtable_thunk(84, "bool(__thiscall*)(void*, int, bbvec3_t&)")
local fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(468, "int(__thiscall*)(void*, void*)")
local fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(469, "int(__thiscall*)(void*)")

local get_attachment_vector = function(world_model)
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local model =
        world_model and
        entity.get_prop(wpn, 'm_hWeaponWorldModel') or
        entity.get_prop(me, 'm_hViewModel[0]')

    if me == nil or wpn == nil then
        return
    end

    local active_weapon = fnGetClientEntity(pClientEntityList, wpn)
    local g_model = fnGetClientEntity(pClientEntityList, model)

    if active_weapon == nil or g_model == nil then
        return
    end

    local attachment_vector = ffi.new("bbvec3_t[1]")
    local att_index = world_model and
        fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
        fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)
        
    if att_index > 0 then
        if fnGetAttachment(g_model, att_index, attachment_vector[0]) then
            return vector(attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z)
        end
    end
end

local old_pos = vector()
local on_paint = function()
    local local_player = entity.get_local_player()
    local is_alive = entity.is_alive(local_player)
    if not local_player or not is_alive then return end

    local main = {
        color = {ui.get(interface.main.elements.color)},
        pallete = ui.get(interface.main.elements.pallete),
        perspective = ui.get(interface.main.elements.perspective),
        link = {
            mode = ui.get(interface.main.elements.link.mode),
            color = {ui.get(interface.main.elements.link.color)},
            second_color = {ui.get(interface.main.elements.link.second_color)},
        },
        scope = ui.get(interface.main.elements.scope),
    }

    local editor = {
        blur = ui.get(interface.editor.elements.blur),
        smoothing = ui.get(interface.editor.elements.smoothing),

        perspective = {
            mode = ui.get(interface.editor.elements.perspective.mode),
            first = {
                offset = ui.get(interface.editor.elements.perspective.first.offset),
                angle = ui.get(interface.editor.elements.perspective.first.angle),
            },
            
            third = {
                offset = ui.get(interface.editor.elements.perspective.third.offset),
                angle = ui.get(interface.editor.elements.perspective.third.angle),
            }
        },

        header = {
            thickness = ui.get(interface.editor.elements.header.thickness),
        },

        background = {
            color = {ui.get(interface.editor.elements.color)},
        },

        glow_line = {
            step = ui.get(interface.editor.elements.glow_line.step),
            width = ui.get(interface.editor.elements.glow_line.width),
            interpolation = ui.get(interface.editor.elements.glow_line.interpolation),
            pulse_speed = ui.get(interface.editor.elements.glow_line.pulse_speed),
        }
    }

    local third_person = ui.get(reference.third_person[1]) and ui.get(reference.third_person[2])
    if not contains(main.perspective, 'First person') and not third_person then
        return
    end

    if not contains(main.perspective, 'Third person') and third_person then
        return
    end

    if entity.get_prop(local_player, 'm_bIsScoped') > 0 and not main.scope and not third_person then
        return
    end

    local muzzle_vec = get_attachment_vector(false)
    if not muzzle_vec then return end

    local muzzle_pos = vector(renderer.world_to_screen(muzzle_vec:unpack()))
    if not muzzle_pos.x then return end

    local hitbox_vec = vector(entity.hitbox_position(local_player, 2))
    if not hitbox_vec then return end

    local hitbox_pos = vector(renderer.world_to_screen(hitbox_vec:unpack()))
    if not hitbox_pos.x then return end

    local color = {get_bar_color()}

    local camera_angles = { client.camera_angles() }
    local by = anti_aim.normalize_angle(camera_angles[2] - anti_aim.get_body_yaw(1) - 120)
    local fy = anti_aim.normalize_angle(camera_angles[2] - anti_aim.get_body_yaw(2) - 120)

    local desync = math.abs(anti_aim.get_desync(1))
    local overlap = anti_aim.get_overlap(false)
    local left, right = 1 - overlap, overlap
    local r, g, b = get_color(desync, 28)
    
    local dt_status = anti_aim.get_double_tap() and 'SHIFTING TICKBASE' or ''
    local os_status = ui.get(reference.on_shot[1]) and ui.get(reference.on_shot[2]) and '\a00FF00FF ON' or '\aFF0000FF OFF'

    new_pos = third_person and
    vector(hitbox_pos.x + math.sin(math.rad(editor.perspective.third.angle)) * editor.perspective.third.offset, hitbox_pos.y - math.cos(math.rad(editor.perspective.third.angle)) * editor.perspective.third.offset) or
    vector(muzzle_pos.x + math.sin(math.rad(editor.perspective.first.angle)) * editor.perspective.first.offset, muzzle_pos.y - math.cos(math.rad(editor.perspective.first.angle)) * editor.perspective.first.offset)
    
    local base_pos = third_person and hitbox_pos or muzzle_pos

    local speed = globals.absoluteframetime() * 100
    new_pos.x = easing.quad_out(1, old_pos.x, (new_pos.x - old_pos.x) * speed, editor.smoothing)
    new_pos.y = easing.quad_out(1, old_pos.y, (new_pos.y - old_pos.y) * speed, editor.smoothing)

    if main.link.mode == 'Line' then
        renderer.line(base_pos.x, base_pos.y, new_pos.x, new_pos.y, main.link.color[1], main.link.color[2], main.link.color[3], main.link.color[4])
    elseif main.link.mode == 'Glow line' then
        glow_line(base_pos, new_pos, main.link.color, main.link.second_color, editor.glow_line.interpolation, editor.glow_line.width, editor.glow_line.step, editor.glow_line.pulse_speed * .01)
    end

    local w, h = 145, 55
    local add = (anti_aim.get_double_tap() and 10 or 0)
    h = h + add

    local x, y = new_pos.x - w, new_pos.y - h

    -- Don't worry I wasted my time pixel perfecting this shit (a while ago) I probably should've added DPI scaling
    renderer.rectangle(x, y, w, h, editor.background.color[1], editor.background.color[2], editor.background.color[3], editor.background.color[4])
    
    if editor.blur then
        renderer.blur(x, y, w, h)
    end

    if main.pallete == 'Solid' then
        renderer.rectangle(x, y - editor.header.thickness, 145, editor.header.thickness, color[1], color[2], color[3], color[4])
    else
        renderer.gradient(x, y - editor.header.thickness, (w/2)+1, editor.header.thickness, color[2], color[3], color[1], color[4], color[1], color[2], color[3], color[4], true)
        renderer.gradient(x + w/2, y - editor.header.thickness, w-w/2, editor.header.thickness, color[1], color[2], color[3], color[4], color[3], color[1], color[2], color[4], true)
    end

    renderer.text(x + 2, y + 3, 255, 255, 255, 255, '-', 0, 'ANTI-AIMBOT DEBUG')

    renderer.circle_outline(x + 130, y + 17, 15, 15, 15, 125, 8, 0, 1, 2)
    renderer.circle_outline(x + 130, y + 17, 150, 150, 150, 220, 8, by, 0.05, 2)
    renderer.circle_outline(x + 130, y + 17, main.color[1], main.color[2], main.color[3], 255, 8, fy, 0.1, 2)

    renderer.gradient(x + 6 , y + 25 - 1, 2, 7, r, g, b, 0, r, g, b, 255, false)
    renderer.gradient(x + 6 , y + 25 + 6, 2, 7, r, g, b, 255, b, g, b, 0, false)
    renderer.text(x + 11, y + 25, 255, 255, 255, 255, '', 0, string.format('FAKE (%s°)', round(desync, 1)))

    renderer.text(x + 10, y + 39, 255, 255, 255, 255, '-', 0, 'SP:')

    renderer.rectangle(x + 28, y + 42, 20, 6, 17, 17, 17, 255)
    renderer.rectangle(x + 29, y + 43, clamp(-18, 18, 60*right/3), 4, main.color[1], main.color[2], main.color[3], 255)

    renderer.rectangle(x + 50, y + 42, 20, 6, 17, 17, 17, 255)
    renderer.rectangle(x + 51, y + 43, clamp(-18, 18, 60*left/3), 4, main.color[1], main.color[2], main.color[3], 255)

    renderer.text(x + 11, y + 50, 255, 255, 255, pulse(255), '-', 0, dt_status)
    renderer.text(x + 105, y + 40 + add, 255, 255, 255, 255, '-', 0, string.format('OSAA:%s', os_status))
    
    old_pos = vector(new_pos.x, new_pos.y)
end

local handle_callback = function(self)
    local handle = ui.get(self) and client.set_event_callback or client.unset_event_callback

    handle('paint', on_paint)
end

ui.set_callback(interface.main.enabled, function() handle_interface() handle_callback(interface.main.enabled) end) handle_interface() handle_callback(interface.main.enabled)
ui.set_callback(interface.editor.elements.perspective.mode, handle_interface)
ui.set_callback(interface.main.elements.pallete, handle_interface)
ui.set_callback(interface.editor.enabled, handle_interface)
ui.set_callback(interface.main.elements.link.mode, handle_interface)

