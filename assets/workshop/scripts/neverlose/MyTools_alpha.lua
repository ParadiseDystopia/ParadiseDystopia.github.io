-- leak by qwerty.gang
local render_world_to_screen, rage_exploit, ui_get_binds, ui_get_alpha, entity_get_players, entity_get, entity_get_entities, entity_get_game_rules, common_set_clan_tag, common_is_button_down, common_get_username, common_get_date, ffi_cast, ffi_typeof, render_gradient, render_text, render_texture, render_rect_outline, render_rect, entity_get_local_player, ui_create, ui_get_style, math_floor, math_abs, math_max, math_ceil, math_min, math_random, utils_trace_bullet, render_screen_size, render_load_font, render_load_image_from_file, render_measure_text, render_poly, render_poly_blur, common_add_notify, common_add_event, utils_console_exec, utils_execute_after, utils_create_interface, utils_trace_line, ui_find, entity_get_threat, string_format, hooked_function, entity_get_player_resource, common_get_unixtime, table_insert = render.world_to_screen, rage.exploit, ui.get_binds, ui.get_alpha, entity.get_players, entity.get, entity.get_entities, entity.get_game_rules, common.set_clan_tag, common.is_button_down, common.get_username, common.get_date, ffi.cast, ffi.typeof, render.gradient, render.text, render.texture, render.rect_outline, render.rect, entity.get_local_player, ui.create, ui.get_style, math.floor, math.abs, math.max, math.ceil, math.min, math.random, utils.trace_bullet, render.screen_size, render.load_font, render.load_image_from_file, render.measure_text, render.poly, render.poly_blur, common.add_notify, common.add_event, utils.console_exec, utils.execute_after, utils.create_interface, utils.trace_line, ui.find, entity.get_threat, string.format, nil, entity.get_player_resource, common.get_unixtime, table.insert

local clipboard = require 'neverlose/clipboard'
local base64 = require 'neverlose/base64'
local drag_system = require 'neverlose/drag_system'
local smoothy = require 'neverlose/smoothy'
local get_defensive = require 'neverlose/get_defensive'
local md5 = require 'neverlose/md5'
local inspect = require 'neverlose/inspect'
local events = require 'neverlose/events'
local table_clear = require 'table.clear'

local cloudsystem do
    local ws = require 'neverlose/websockets'
    local base64 = require 'neverlose/sec-base64'
    local md5 = require 'neverlose/md5'

    local userInformation = {  }
    local md5_encyption = 'fnaymemishauwu'

    local table_combine = function(tbl, tbl2)
        for n,v in pairs(tbl2) do
            tbl[n] = v
        end

        return tbl
    end

    local function sort_and_concat(tbl)
        local keys = {}
        for k in pairs(tbl) do
        keys[#keys + 1] = k
        end
        table.sort(keys)

        local result = ""
        for i, k in ipairs(keys) do
            local k = tostring(k)
            local j = tostring(tbl[k])

            result = result..k..j
        end

        return result
    end

    local json_stringify = function(tbl)
        local signature = sort_and_concat(tbl) .. md5_encyption

        if not tbl.signature then
            tbl['signature'] = md5.sumhexa(signature)
        end

        return json.stringify(tbl)
    end

    local Cipher, deCipher do
        local Xor = function(str)
            local key = '6a 75 73 74 73 69 6d 70 6c 65 74 65 78 74'
            local strlen, keylen = #str, #key

            local strbuf = ffi.new('char[?]', strlen+1)
            local keybuf = ffi.new('char[?]', keylen+1)

            local success,_ = pcall(function()
                return string.dump(ffi.copy)
            end)

            if success then
                print_error 'You are not allowed to edit FFI Struct.'
                common.unload_script()

                return
            end

            ffi.copy(strbuf, str)
            ffi.copy(keybuf, key)

            for i=0, strlen-1 do
                strbuf[i] = bit.bxor(strbuf[i], keybuf[i % keylen])
            end

            return ffi.string(strbuf, strlen)
        end

        Cipher = function(a)
            return tostring(base64.encode(Xor(a)))
        end

        deCipher = function(a)
            return tostring(Xor(base64.decode(a)))
        end
    end

    local generateAuthSignature = function(data)
        local str = string.format('username%smethod%sinstance%skey%s', data.username, data.method, data.instance, data.key)
        data.signature = md5.sumhexa(str .. md5_encyption)

        return data
    end

    local buildXuidObject = function(shutdown)
        local me = entity.get_local_player()

        if not me then
            return
        end

        local xuid = me:get_xuid()

        if not xuid then
            return
        end

        return {
            username = common.get_username(),
            instance = userInformation.instance,
            method = 'xuidUpdate',
            tickcount = globals.tickcount,
            xuid = shutdown and false or xuid
        }
    end

    local ws_callbacks = {
        open = function(this)
            this:send(Cipher(json_stringify(generateAuthSignature({ username = common.get_username(), method = 'validateNewConnection', instance = userInformation.instance, key = userInformation.key, tickcount = globals.tickcount }))))

            events.ws_status:call(1)
        end,

        message = function(this, message)
            local parsed_msg = json.parse(deCipher(message))
            if parsed_msg.type ~= 'heartbeat' then
                return
            end

            if parsed_msg.method == 'authorizeResponse' and parsed_msg.success == true then
                events.ws_status:call(4)

                this:send(Cipher(json_stringify({
                    username = common.get_username(),
                    tickcount = globals.tickcount,
                    method = 'update',
                    instance = userInformation.instance,
                    cloud = true,
                })))

                utils.execute_after(1, function()
                    local data = buildXuidObject()

                    if data then
                        this:send(Cipher(json_stringify(data)))
                    end
                end)

                events.level_init(function()
                    local data = buildXuidObject()

                    if data then
                        this:send(Cipher(json_stringify(data)))
                    end
                end)

                events.shutdown(function()
                    local data = buildXuidObject(true)

                    if data then
                        this:send(Cipher(json_stringify(data)))
                    end
                end)
            end

            if parsed_msg.method == 'updateOnlineUsers' and parsed_msg.activeConnections > 0  then
                events['#activeConnections#']:call(parsed_msg.activeConnections)
            end

            if parsed_msg.method == 'usersXuid' and parsed_msg.instance == userInformation.instance then
                events['#getUsersXuid#']:call(json.parse(parsed_msg.data))
            end

            if parsed_msg.method == 'cloudUpdate' and parsed_msg.instance == userInformation.instance then
                local parsedConfigs = json.parse(parsed_msg.configs)

                local newObject = {  }
                local affiliation = false
                local configNameCounts = {}

                for n,v in pairs(parsedConfigs) do
                    local object = {
                        author = n,
                        configData = v.configData,
                        uploadTimestamp = v.uploadTimestamp
                    }

                    if n == common.get_username() then
                        affiliation = true
                    end

                    local configName = v.configName
                    if configNameCounts[configName] ~= nil then
                        configNameCounts[configName] = configNameCounts[configName] + 1
                        configName = configName .. " #" .. configNameCounts[configName]
                    else
                        configNameCounts[configName] = 1
                    end

                    newObject[configName] = object
                end

                events['#cloudSystem#']:call(newObject, affiliation)
            end
        end,

        error = function(this, error)
            events.ws_status:call(2)
        end,

        close = function(this, error)
            events.ws_status:call(0)
        end
    }

    local methodsList = { ['insert'] = true, ['remove'] = true, ['update'] = true, ['user_info'] = true }

    local connectWebsocket = function(isReconnecting)
        events.ws_status:call(isReconnecting and 3 or 2)

        return ws.connect('ws://89.208.106.98:443', ws_callbacks)
    end

    local wss
    cloudsystem = {
        initialize = function(self, instance, key)
            local verifyCode = md5.sumhexa(instance .. md5_encyption)
            if verifyCode ~= key or not instance then
                print_error '[cloudSystem Framework] ~ An attempt of unauthorized entry was detected'

                common.unload_script()
                return
            end

            userInformation = {
                instance = instance,
                key = key
            }

            wss = connectWebsocket()
            events.ws_status(function(enum)
                if enum ~= 0 then
                    return
                end

                wss = connectWebsocket(true)
            end)

            return setmetatable({}, {
                __metatable = false,
                __index = {
                    subscribe = function(th, event, callback, state)
                        local event_name = string.format('#%s#', event)
                        if state == nil then
                            state = true
                        end

                        return events[event_name](callback, state)
                    end,
                    interact = function(th, method, data)
                        local requestData = data or {  }
                        if not methodsList[method] then
                            print_error(string.format('[%s Method] is not found.'))

                            return
                        end

                        requestData = table_combine({
                            username = common.get_username(),
                            method = method,
                            instance = userInformation.instance,
                            timestamp = common.get_unixtime(),
                            tickcount = globals.tickcount,
                            cloud = true
                        }, requestData)

                        if wss == nil then
                            print_error 'Instance is stil initializing..'

                            return
                        end

                        wss:send(Cipher(json_stringify(requestData)))
                    end
                }
            })
        end,

        on = function(code, callback)
            if code == 'statusChange' then
                events.ws_status(callback)
            elseif code == 'ready' then
                events.ws_status(function(enum)
                    if enum == 1 then
                        callback(4)
                    end
                end)
            end
        end
    }
end

local app = cloudsystem:initialize('mytools', '71c7ff633d11f83996b5041a926c40fa')

local function on_load() cvar.clear:call() print_raw('\a'..ui_get_style('Link Active'):to_hex()..'mytools \a85858DFF· \aDEFAULTWelcome, '..common.get_username()..'!') end;on_load()

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } c_animlayers;
]]

local function this_call(call_function, parameters) return function(...) return call_function(parameters, ...) end end
local function gradient_textz(r1, g1, b1, a1, r2, g2, b2, a2, text) local output = '' local len = #text-1 local rinc = (r2 - r1) / len local ginc = (g2 - g1) / len local binc = (b2 - b1) / len local ainc = (a2 - a1) / len for i=1, len+1 do output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i)) r1 = r1 + rinc g1 = g1 + ginc b1 = b1 + binc a1 = a1 + ainc end return output end
local clamp = function(b,c,d)local e=b;e=e<c and c or e;e=e>d and d or e;return e end
function lerp(time,a,b) return a * (1-time) + b * time end
function contains(table, element) for i = 1, #table do if table[i] == element then return true end end end
local ifHashed = function(tbl, val) for n,v in pairs(tbl) do if val == v then return true end end return false end

files.create_folder("nl/scripts/mytools")
local entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)
local engine_client = ffi.cast(ffi.typeof('void***'), utils.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])
local font, verdana, verdanab = render.load_font('Calibri Bold', vector(25, 22, -1), 'a, d'), render.load_font("Verdana", 20, 'a'), render.load_font('Verdana', 13, 'a, d, b')
ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set('Quick Switch', 'Auto Pistols')
local current = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):get()
local active_color, color_link = ui_get_style('Link Active'):to_hex(), ui_get_style('Link'):to_hex()
local anim_tbl, easing_table = {}, smoothy.new(anim_tbl)
local hitlog, modify = {}, {}
local disabled_windows, windows_table = {}, {}
check_windows = function() windows_table = {} for i = 1, 4 do if (ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i] ~= nil) and not contains(disabled_windows, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i]) then table.insert(windows_table, ui.find("Miscellaneous", "Main", "Other", "Windows"):get()[i]) end end ui.find("Miscellaneous", "Main", "Other", "Windows"):set(windows_table) end

modify.math_breathe = function(offset, multiplier) return math.abs(math.sin(globals.realtime * (multiplier or 1) % math.pi + (offset or 0))) end
modify.typing_text = function(s, callback) num, length = 0, #s:gsub('[\128-\191]', '') result = '' for char in s:gmatch('.[\128-\191]*') do num = num + 1 factor = num / length result = string_format('%s\a%s%s', result, callback(num, length, char, factor):to_hex(), char) end return result end
modify.gradient_text = function(s, a, b) return modify.typing_text(s, function(num, length, char, factor) return a:lerp(b, factor) end) end
modify.gradient = function(s, a, b, t) return modify.typing_text(s, function(num, length, char, factor) interpolation = modify.math_breathe(factor, t) return a:lerp(b, interpolation) end) end
modify.static_gradient = function(s, clr1, clr2) return modify.gradient_text(s, clr1, clr2) end

local render_interpolate_string = function(name, position, font, text_color, flags, ...)
    local text = table.concat({...})

    if anim_tbl[name] == nil then
        anim_tbl[name] = 0
        easing_table = smoothy.new(anim_tbl)
    end

    local text_size = easing_table(.1, { [name] = render.measure_text(font, nil, ...)})[name]

    local normal_size = render.measure_text(font, nil, ...)

    render.push_clip_rect(vector(position.x - normal_size.x, position.y - text_size.y/2), vector(position.x + text_size.x/2, position.y + text_size.y/2), true)
    render.text(font, vector(position.x - text_size.x/2, position.y - text_size.y/2), text_color, flags, ...)
    render.pop_clip_rect()
end

local function get_type(value)
    if type(getmetatable(value)) == 'table' and value.__type then
        return value.__type.name:lower()
    end

    if type(value) == 'boolean' then
        value = value and 1 or 0
    end

    return type(value)
end

local ctx = new_class()
    :struct 'cheat' {
        screen_size = render_screen_size(),
        version = 'Nightly', -- Release, Alpha, Nightly
        username = common_get_username(),
    }

    :struct 'impt' {
        play_sound = function(name , volume)
            local IEngineSoundClient = ffi_cast("void***" , utils_create_interface("engine.dll", "IEngineSoundClient003")) or error("Failed to find IEngineSoundClient003!")
            local play_sound_fn = ffi_cast("void(__thiscall*)(void*, const char*, float, int, int, float)",IEngineSoundClient[0][12])

            return play_sound_fn( IEngineSoundClient, name , volume , 100 ,0,0)
        end
    }

    :struct 'menu' {
        var_update = {
            active_color = nil,
            link = nil,
        },

        init = function(self)

            local tabs = ui_create('General', 'Tabs')
            local info_group = ui_create('General', 'Info', 2)
            local sc_tab = ui_create('General', 'Settings', 1)
            local links_group = ui_create('General', 'Links', 2)
            local antiaims_configs_group = ui_create('General', 'Local Presets', 1)
            local local_configs = ui_create('General', 'Local Configs', 1)
            local configs = ui_create('General', 'Cloud Configs', 2)
            local config_stealer = ui_create('General', 'Cheat Additionals', 1)
            local antiaim_group = ui_create('General', 'AA Misc', 1)
            local antiaims_builder_tab = ui_create('General', 'Anti Aim Settings', 2)
            local conditions = ui_create('General', 'Conditions', 2)
            local misc_group = ui_create('General', 'Misc', 2)
            local rage_group = ui_create('General', 'Rage Bot', 1)
            local visuals_group = ui_create('General', 'Indicators', 2)
            local visuals_group_misc = ui_create('General', 'Other', 1)
            info_group:label("\a{Link Active}   \aDEFAULTWelcome, \a{Link Active}"..common.get_username().."!")
            info_group:label("\a{Link Active}   \aDEFAULTScript Build: \a{Link Active}"..self.cheat.version.."")
            info_group:label("\a{Link Active}   \aDEFAULTLast Update: \a{Link Active}12.09.2023 11:23 GMT+3")
            onlineUsers = info_group:label("\a{Link Active}   \aDEFAULTOnline Users: \a{Link Active}Connecting...")

            cloudsystem.on('ready', function()

            app:subscribe('activeConnections',
                function(activeConnections)
                        if not activeConnections then
                            return
                    end

                    onlineUsers:name(string.format("\a{Link Active}   \aDEFAULTOnline Users: \a%s%s                              ", ui_get_style('Link Active'):to_hex(), activeConnections + 10))
                end)
            end)

            cloudsystem.on('statusChange', function(enum)
                if enum == 4 then
                    utils.execute_after(1, function()
                        common.add_notify("Mytools Cloud Server", "✅  Successfully connected to the cloud server.")
                    end)
                end
            end)

            events.pre_render:set(function()
                local current_colors = {
                    active_color = ui_get_style()["Link Active"],
                    link = ui_get_style()["Link"]
                }

                if current_colors.link ~= self.var_update.link or current_colors.active_color ~= self.var_update.active_color then
                    events.on_style_change:call()
                end

                self.var_update = current_colors
            end)

           local global do
                global = {}

                local config_data = files.read('nl/scripts/mytools/mytools.config')
                local success, config_data = pcall(function()
                    return json.parse(config_data)
                end)

                if not success or #config_data == 0 then
                    config_data = {'\a{Link Active}Mytools. \aCBC9C9FFCreate preset.'}
                else
                    local name_list = {}
                    for i=1, #config_data do
                        table.insert(name_list, config_data[i].name)
                    end

                    config_data = name_list
                end

                tabs = tabs:list("", {'   Information', '   Configurations', '   Anti-Aims', '   Visuals', '     \aDEFAULTMiscellaneous'})
                tabs:set_callback(function(self)
                    if self:get() == 1 then
                        self:update({'\a{Link Active}      \aDEFAULTInformation', '     Configurations',  '    Anti-Aims', '     Visuals', '    \aDEFAULTMiscellaneous'})
                        config_stealer:visibility(false)
                        local_configs:visibility(false)
                        antiaims_configs_group:visibility(false)
                        info_group:visibility(true)
                        links_group:visibility(true)
                        antiaim_group:visibility(false)
                        antiaims_builder_tab:visibility(false)
                        conditions:visibility(false)
                        misc_group:visibility(false)
                        rage_group:visibility(false)
                        visuals_group:visibility(false)
                        visuals_group_misc:visibility(false)
                        configs:visibility(false)
                        sc_tab:visibility(true)
                    elseif self:get() == 2 then
                        self:update({'      Information', '\a{Link Active}     \aDEFAULTConfigurations',  '    Anti-Aims', '     Visuals', '    \aDEFAULTMiscellaneous'})
                        config_stealer:visibility(true)
                        local_configs:visibility(true)
                        antiaims_configs_group:visibility(true)
                        info_group:visibility(false)
                        links_group:visibility(false)
                        antiaim_group:visibility(false)
                        antiaims_builder_tab:visibility(false)
                        conditions:visibility(false)
                        misc_group:visibility(false)
                        rage_group:visibility(false)
                        visuals_group:visibility(false)
                        visuals_group_misc:visibility(false)
                        configs:visibility(true)
                        sc_tab:visibility(false)
                    elseif self:get() == 3 then
                        self:update({'      Information', '     Configurations',  '\a{Link Active}    \aDEFAULTAnti-Aims', '     Visuals', '    \aDEFAULTMiscellaneous'})
                        config_stealer:visibility(false)
                        local_configs:visibility(false)
                        antiaims_configs_group:visibility(false)
                        info_group:visibility(false)
                        links_group:visibility(false)
                        antiaim_group:visibility(true)
                        antiaims_builder_tab:visibility(true)
                        conditions:visibility(true)
                        misc_group:visibility(false)
                        rage_group:visibility(false)
                        visuals_group:visibility(false)
                        visuals_group_misc:visibility(false)
                        configs:visibility(false)
                        sc_tab:visibility(false)
                    elseif self:get() == 4 then
                        self:update({'      Information', '     Configurations',  '    Anti-Aims', '\a{Link Active}     \aDEFAULTVisuals', '    \aDEFAULTMiscellaneous'})
                        config_stealer:visibility(false)
                        local_configs:visibility(false)
                        antiaims_configs_group:visibility(false)
                        info_group:visibility(false)
                        links_group:visibility(false)
                        antiaim_group:visibility(false)
                        antiaims_builder_tab:visibility(false)
                        conditions:visibility(false)
                        misc_group:visibility(false)
                        rage_group:visibility(false)
                        visuals_group:visibility(true)
                        visuals_group_misc:visibility(true)
                        configs:visibility(false)
                        sc_tab:visibility(false)
                    elseif self:get() == 5 then
                        self:update({'      Information', '     Configurations',  '    Anti-Aims', '     \aDEFAULTVisuals', '\a{Link Active}    \aDEFAULTMiscellaneous'})
                        config_stealer:visibility(false)
                        local_configs:visibility(false)
                        antiaims_configs_group:visibility(false)
                        info_group:visibility(false)
                        links_group:visibility(false)
                        antiaim_group:visibility(false)
                        antiaims_builder_tab:visibility(false)
                        conditions:visibility(false)
                        misc_group:visibility(true)
                        rage_group:visibility(true)
                        visuals_group:visibility(false)
                        visuals_group_misc:visibility(false)
                        configs:visibility(false)
                        sc_tab:visibility(false)
                    end
                end, true)

                local configsCache = {  }

                local cloudList = configs:list('Cloud Configs System:', { 'Loading..' })
                local cloudAuthor = configs:label('Author: Unknown')
                local cloudLastUpdate = configs:label('Last Update: Never')
                local cloudUploadName = configs:input('Name for Uploading:', 'My Config')

                local cloudLoad = configs:button('\a{Link Active}   \aDEFAULTLoad Cloud Settings', function()
                    local this = cloudList
                    local list = this:list()
                    local object = configsCache[list[this:get()]]

                    if object == nil then common.add_notify("Mytools Cloud Server", "❌  There was an error when importing the config.")  return end
                    self.config_system:import(object.configData)
                end, true)

                local cloudUpload = configs:button('\a{Link Active}  ', function()
                    local Code = self.config_system:export()

                    if cloudUploadName:get():gsub(' ', '') == '' or cloudUploadName:get() == '' then common.add_notify('Mytools Cloud Server', '❌ Enter valid config name') return end
                    app:interact('insert', { configName = cloudUploadName:get(), configData = Code })
                    cvar.play:call("ambient\\tones\\elev1")
                end, true):disabled(true)

                local cloudRemove = configs:button('\a{Link Active}  ', function() app:interact('remove') cvar.play:call("ambient\\tones\\elev1") end, true):disabled(true)

                cloudsystem.on('statusChange', function(enum)
                    local cloudSystem_ListUpdate = function(this, configsData)
                        local success, error = pcall(function()
                            local list = this:list()
                            local color = ui_get_style 'Link Active'
                            local object = configsData[list[this:get()]]

                            cloudAuthor:name(string.format('Author: \a%s%s', color:to_hex(), object.author))
                            cloudLastUpdate:name(string.format('Last Update: \a%s%s', color:to_hex(), common.get_date('%d/%m/%Y %H:%M %p', object.uploadTimestamp)))
                        end)
                    end

                    if enum == 4 then
                    -- handle messages
                        app:subscribe('cloudSystem', function(configs, affiliation)
                            --turn on system
                            cloudUpload:disabled(false)
                            cloudRemove:disabled(not affiliation)

                            --replace name [pikachu]
                            local table_replace = function(tbl, old_key, new_key)
                                local output = {  }

                                for n, v in pairs(tbl) do

                                    if n ~= old_key then
                                        output[n] = v
                                    else
                                        output[new_key] = v
                                    end
                                end

                                return output
                            end

                            local should_replace
                            for name, object in pairs(configs) do
                                if object.author == 'pikachu' then
                                    should_replace = name
                                end
                            end

                            if should_replace then
                                configs = table_replace(configs, should_replace, 'Default Config \a5FFF58FF· Pinned')
                            end

                            --update cloudlist
                            local name_list = {  }
                            for name,object in pairs(configs) do
                            if object.author == 'pikachu' then
                                    table.insert(name_list, 1, name)
                                else
                                    table.insert(name_list, name)
                                end
                            end

                            cloudList:update(name_list or {  })
                            configsCache = configs

                            if not cloudUpload:disabled() then
                                cloudList:set_callback(function(th)
                                    cloudSystem_ListUpdate(cloudList, configs)
                                end, true)
                            end
                        end)
                    end

                    if enum == 3 then
                        cloudUpload:disabled(true)
                        cloudRemove:disabled(true)
                    end
                end)

                cloudRemove:tooltip("Remove From Cloud")
                cloudUpload:tooltip("Upload To Cloud")
                --cloud configs @ end

                global.preset_list = antiaims_configs_group:list('', config_data)
                global.preset_name = antiaims_configs_group:input('Name: ')
                global.save_preset = antiaims_configs_group:button('\a{Link Active}', function() self.config_system:save() end, true)
                global.delete_preset = antiaims_configs_group:button('\a{Link Active}', function() self.config_system:delete() end, true)
                global.load_preset = antiaims_configs_group:button('            Load            ', function() self.config_system:load() end)
                global.import_preset = antiaims_configs_group:button('\a{Link Active}', function() self.config_system:import() end, true)
                global.export_preset = antiaims_configs_group:button('\a{Link Active}', function() common_add_notify('mytools', '\a89F2CAFF✔️ Successfully Exported Your Config') self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12) self.config_system:export() end, true)

                skip_data = local_configs:selectable("Skip import data:", {'Anti-Aims', 'Ragebot', 'Misc/Vis'})
                skip_data:tooltip("Does not import the tabs that are selected.")
                global.import_preset1 = local_configs:button('\a{Link Active}  \aDEFAULTImport', function() self.config_system:import() end, true)
                global.export_preset1 = local_configs:button('\a{Link Active}  \aDEFAULTExport', function() common_add_notify('mytools', '\a89F2CAFF✔️ Successfully Exported Your Config') self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12) self.config_system:export() end, true)

                --global_config
                --global.fnay_label = configs_group:label("")
                global.load_defauls = local_configs:button("🪐 \aFFFFFFFFDefault", function() self.config_system:import('[mytools]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[/mytools]') end, true)
                global.save_preset:tooltip("Save / Create Preset")
                global.delete_preset:tooltip("Delete Preset")
                global.import_preset:tooltip("Import")
                global.export_preset:tooltip("Export")

                --llinks
                global.discord = info_group:button('\a{Link Active}  \aDEFAULTDiscord', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/yXUNrR8") end, true)

                global.verify = info_group:button('\a{Link Active}  \aDEFAULTGet Discord Role\aFFFCD2FF*', function()
                    --clipboard.set(self.cheat.version == 'Nightly' and '02405b_mytools' or '02405s_mytools')
                    local signObject = function(object)
                        local key = 'ioa0w3424mytools'
                        local signature = string.format('%s%s%s', object.username, object.build, key)

                        return md5.sumhexa(signature)
                    end

                    local _NAME = common.get_username()
                    local _BUILD = (self.cheat.version == 'Nightly' and 'beta' or 'stable') --[[stable, beta, yauma]]

                    network.get(string.format('http://89.208.106.98:4444/discord?username=%s&build=%s&signature=%s', _NAME, _BUILD, signObject({ username = _NAME, build = _BUILD })), {  }, function(data)
                        if not data then
                            print_error 'хз'
                        end

                        clipboard.set(data)
                    end)


                    common_add_notify('mytools', '\a89F2CAFF✔️Token Copied to Your Clipboard')
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end, true)

                global.verify:tooltip("To get a role in our discord, click on this button and a token will be copied to your clipboard.\n\nAfter that, go to our Discord channel in the #✅-verify category\n\nType the command: /redeem and in the prompt insert your token")
                global.neverlose_config = links_group:button('\a{Link Active}  \aDEFAULTNeverlose CFG ', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/bEb3IN") end, true)
                global.youtube = links_group:button('\a{Link Active}  \aDEFAULTYoutube ', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtube.com/@PikazHvH") end, true)
                global.projects = links_group:button('\a{Link Active}  \aDEFAULTOur Projects ', function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/?page=0&search=author:pikachu&sort=drec0&type=2&filter=0") end, true)
            end


            events.render:set(function()
                if ui_get_alpha() < 0.3 then return end
                link_color = ui_get_style()["Link Active"]

                text = modify.gradient('mytools', color(173, 173, 173), color(link_color.r, link_color.g, link_color.b), 1.5)
                ui.sidebar(text .. '\aADADADFF • \a{Link Active}'..self.cheat.version..'', '')
            end)

            local elements do
                elements = {
                    antiaims = {},
                    ragebot = {},
                    visuals = {},
                    misc = {},
                    antiaims_builder = {}
                }
                local active_color = ui_get_style('Link Active'):to_hex()

                elements.misc.scoreboard_icon = sc_tab:switch("\a{Link Active}   \aDEFAULTShared Logo", true)
                elements.misc.scoreboard_icon:tooltip("Shows players with a script on server through icon in scoreboard")

                app:subscribe("getUsersXuid", function(data)
                    if not elements.misc.scoreboard_icon:get() then
                        return
                    end

                    entity.get_players(false, true, function(ptr)
                        local playerXuid = ptr:get_xuid()
                        ptr:set_icon(ifHashed(data, playerXuid) and 'https://cdn.discordapp.com/attachments/946153393192321034/1139540637058859158/tSqXhl3.png' or '')
                    end)
                end)

                elements.misc.config_stealer = config_stealer:switch '\a{Link Active}   \aDEFAULTEnable Cheat Config Stealer'

                elements.misc.muteunmute = misc_group:switch 'Unmute Silenced Players'
                elements.misc.muteunmute:tooltip('Removes mute from all players who are muted for abuse, updating on round start.')

                elements.visuals.on_screen = visuals_group:switch 'On-Screen Indicators' do
                    local settings = elements.visuals.on_screen:create()
                    elements.visuals.select = settings:combo('Select', {'Disable', 'Default'}, 0)
                    elements.visuals.fonts = settings:combo("Font", {"Small", "Default"})
                    elements.visuals.indicator_color = settings:color_picker('Indicator Color', color(255, 255, 255))
                    elements.visuals.build_color = settings:color_picker('Build Color', color(215, 163, 111))
                    elements.visuals.glow_px = settings:slider("Glow Offset", 0, 100, 40, nil, 'px')
                    elements.visuals.dmg_indx = settings:slider("posxdmg", 0, render_screen_size().x, 965)
                    elements.visuals.dmg_indy = settings:slider("posydmg", 0, render_screen_size().y, 525)
                end

                elements.visuals.dmg_indx:visibility(false)
                elements.visuals.dmg_indy:visibility(false)

                elements.visuals.select:set_callback(function(self)
                    elements.visuals.indicator_color:visibility(self:get() == 'Default')
                    elements.visuals.build_color:visibility(self:get() == 'Default')
                    elements.visuals.glow_px:visibility(self:get() == 'Default')
                    elements.visuals.fonts:visibility(self:get() == 'Default')
                end, true)

                elements.visuals.damage_indicator = visuals_group:switch 'Damage Indicator' do
                    local settings = elements.visuals.damage_indicator:create()

                    elements.visuals.damage_font = settings:combo('Damage Font', 'Small', 'Default')
                    elements.visuals.dis_animation = settings:switch("Disable Damage Animation", false)
                end

                elements.visuals.damage_indicator:set_callback(function(self)
                    elements.visuals.damage_font:visibility(self:get())
                    elements.visuals.dis_animation:visibility(self:get())
                end, true)

                elements.visuals.velocity_warning = visuals_group:switch 'Velocity Indicator' do
                    local settings = elements.visuals.velocity_warning:create()

                    elements.visuals.velocity_color = settings:color_picker("Velocity Color", color(145, 178, 239))
                    elements.visuals.velocity_x = settings:slider("posxvelocity", 0, render_screen_size().x, 900)
                    elements.visuals.velocity_y = settings:slider("posyvelocity", 0, render_screen_size().y, 250)
                    elements.visuals.velocity_x:visibility(false)
                    elements.visuals.velocity_y:visibility(false)
                end

                elements.visuals.sindicators = visuals_group:selectable('500$ Indicators', {'Double tap', 'Dormant aimbot', 'Minimum damage', 'Ping spike', 'Fake duck', 'Freestanding', 'Spectator list', 'Hit Percentage', 'Bomb info', 'Body aim', 'Hide shots', 'Choked commands'}, 0)

                elements.ragebot.aimbot_logging = rage_group:switch 'Custom Event Logs' do
                    local settings = elements.ragebot.aimbot_logging:create()

                    elements.ragebot.select_log = settings:selectable('Select Log', {'Console', 'Screen'})
                    elements.ragebot.purchases = settings:switch("Purchase Logs", true)
                    elements.ragebot.dis_glow = settings:switch('Disable Glow')
                    elements.ragebot.accent_color = settings:color_picker("Screen Logs Color", color(144, 151, 255))
                end

                elements.ragebot.select_log:set_callback(function(self)
                    elements.ragebot.accent_color:visibility(self:get("Screen"))
                    elements.ragebot.dis_glow:visibility(self:get("Screen"))
                end, true)

                elements.visuals.custom_scope = visuals_group_misc:switch 'Scope Overlay' do
                    local settings = elements.visuals.custom_scope:create()

                    elements.visuals.scope_style = settings:combo('Select Style', {'Default', 'Reversed'})
                    elements.visuals.remove_line = settings:selectable('Exclude Line', {'Left', 'Right', 'Up', 'Down'})
                    elements.visuals.scope_gap = settings:slider("Scope Gap", 0, 500, 7)
                    elements.visuals.scope_size = settings:slider("Scope Size", 0, 1000, 105)
                    elements.visuals.scope_color = settings:color_picker("Scope Color", color(255, 255, 255))

                end

                elements.visuals.solus_widgets = visuals_group_misc:switch 'Widgets' do
                    local settings = elements.visuals.solus_widgets:create()
                    elements.visuals.solus_widgets_s = settings:selectable("Windows", {"Hotkeys", "Spectators"})
                    elements.visuals.accent_col = settings:color_picker("Widgets Color", color(150, 150, 255))
                    elements.visuals.pos_x_s = settings:slider("posx", 0, render_screen_size().x, 150)
                    elements.visuals.pos_y_s = settings:slider("posy", 0, render_screen_size().y, 150)
                    elements.visuals.pos_x1_s = settings:slider("posx1", 0, render_screen_size().x, 250)
                    elements.visuals.pos_y1_s = settings:slider("posy1", 0, render_screen_size().y, 250)
                end

                elements.visuals.pos_x_s:visibility(false)
                elements.visuals.pos_y_s:visibility(false)
                elements.visuals.pos_x1_s:visibility(false)
                elements.visuals.pos_y1_s:visibility(false)

                elements.visuals.viewmodel_changer = misc_group:switch 'Viewmodel Changer' do
                    local settings = elements.visuals.viewmodel_changer:create()

                    elements.visuals.viewmodel_fov = settings:slider('FOV', -100, 100, 68)
                    elements.visuals.viewmodel_x = settings:slider("Offset X", -150, 150, 25, 0.1)
                    elements.visuals.viewmodel_y = settings:slider("Offset Y", -150, 150, 0, 0.1)
                    elements.visuals.viewmodel_z = settings:slider("Offset Z", -150, 150, -15, 0.1)
                    settings:button('Reset values to default', function() elements.visuals.viewmodel_fov:set(68) elements.visuals.viewmodel_x:set(25) elements.visuals.viewmodel_y:set(0) elements.visuals.viewmodel_z:set(-15) end)
                end

                elements.visuals.viewmodel_aspectratio = misc_group:slider('Aspect Ratio', 0, 200, 0, 0.01, function(self)
                    if self == 0 then
                        return 'Off'
                    end
                end)

                --miscellneous
                elements.misc.killsay = misc_group:switch 'Trash Talk' do
                    local settings = elements.misc.killsay:create()


                    elements.misc.killsay_disablers = settings:switch('Disable on Warmup', false)

                end

                elements.misc.clantag_changer = misc_group:switch 'Clan Tag'
                elements.visuals.markers = visuals_group_misc:switch('Aimbot Markers', false) do
                    local settings = elements.visuals.markers:create()

                    elements.visuals.kibit_marker = settings:switch 'Kibit Hit Marker'
                    elements.visuals.miss_marker = settings:switch '3D Miss Marker'
                    elements.visuals.ot_marker = settings:switch 'OT Damage Marker'
                end

                elements.visuals.console_changer = visuals_group_misc:switch 'Console Color Changer' do
                    local settings = elements.visuals.console_changer:create()

                    elements.visuals.console_color = settings:color_picker("Console Color", color(255, 255, 255, 255))
                end

                elements.misc.grenade_release = misc_group:switch 'Grenade Release' do
                    local settings = elements.misc.grenade_release:create()

                    elements.misc.min_dmg = settings:slider('Min. Damage', 0, 50, 50)
                end

                elements.misc.grenade_release:tooltip("Throws a grenade when it is possible to inflict minimum damage specified in script settings, in case of a molotov if molotov will hit the enemy. Works with grenade prediction enabled.")

               --othergroup
                elements.misc.grenade_fix = misc_group:switch 'Nade Throw Fix'
                elements.misc.grenade_fix:tooltip("Fix the moment when you try to throw a grenade and it is not thrown.")
                elements.misc.taskbar = misc_group:switch '\aCCCC6FFFFlash Icon On Round Start'

                --anti-aims
                elements.antiaims.antiaim_mode = antiaims_builder_tab:combo('\a{Link Active}   \aDEFAULTMode', {'Disabled', 'Classic Jitter', 'Defensive Preset', 'Conditional'})
                elements.antiaims.manual_aa = antiaims_builder_tab:combo("\a{Link Active}   \aDEFAULTManual AA", {'Disabled', 'Left', 'Right', 'Forward'}) do
                    local settings = elements.antiaims.manual_aa:create()

                    elements.antiaims.disablermanual = settings:switch 'Disable Yaw Modifiers'
                    --elements.antiaims.manual_vis = settings:switch 'Arrows'
                end

                elements.antiaims.condition = conditions:combo("Current Condition", {"Global", "Standing", "Moving", "Slow motion", "Air", "Air Crouch", "Crouch", 'Crouch Move'}, 0)
                elements.antiaims.tp = antiaims_builder_tab:label("You are using an automatic preset, you don't need to adjust it. Just press it and go play.")
                elements.antiaims.antiaims_tweaks = antiaim_group:selectable("\a{Link Active}   \aDEFAULTTweaks", {'Bombsite E Fix', 'Legit AA', 'Dis. AA on Warmup', 'Avoid Backstab', 'Fluctuate Fake Lag', 'Auto Teleport', 'Fast Ladder', 'No Fall Damage'}) do
                    local settings = elements.antiaims.antiaims_tweaks:create()

                    elements.antiaims.weapons = settings:selectable("[AutoTP] Weapons", "Pistols", "Auto Snipers", "AWP", "SSG-08", "Heavy Pistols", "Knife/Taser")
                    elements.antiaims.delayticks = settings:slider('[AutoTP] Delay', 1, 16, 1, nil, 't')
                end

                elements.antiaims.antiaims_tweaks:set_callback(function(self)
                    elements.antiaims.weapons:visibility(self:get('Auto Teleport'))
                    elements.antiaims.delayticks:visibility(self:get('Auto Teleport'))
                end, true)


                elements.antiaims.safehead = antiaim_group:selectable("\a{Link Active}   \aDEFAULTSafe Head", {'Bomb', 'Knife / Taser', 'Fake-Lag', 'Crouching'})
                --elements.antiaims.manual_aa = antiaims_builder_tab:combo("Manual AA", {'Disabled', 'Left', 'Right', 'Forward'})

                elements.antiaims.force_lag = antiaim_group:switch '\a{Link Active}   \aDEFAULTForce Break LC' do
                    local settings = elements.antiaims.force_lag:create()

                    elements.antiaims.lag_conditions = settings:selectable("Conditions", {'In Air', 'Standing', 'Moving', 'Slow Walking', 'Crouching', 'Crouch Move'})
                end

                elements.antiaims.defensive_aa = antiaim_group:switch('\a{Link Active}   \aDEFAULTDefensive AA', false) do
                    local settings = elements.antiaims.defensive_aa:create()

                    elements.antiaims.defensive_type = settings:combo('Type', {'Presets', 'Custom'})
                    elements.antiaims.defensive_pitch = settings:combo('Pitch', {'Disabled', 'Up', 'Down', 'Semi Up', 'Semi Down', 'Random'})
                    elements.antiaims.defensive_yaw = settings:combo('Yaw', {'Disabled', 'Sideways', 'Opposite', 'Spin', 'Random', '3-Way', '5-Way'})
                    elements.antiaims.custom_pitch = settings:slider('Custom Pitch', -89, 89, 0)
                    elements.antiaims.custom_yaw = settings:slider('Custom Yaw', -180, 180, 0)
                    elements.antiaims.defensive_disablers = settings:selectable("Disablers", {'Manuals', 'Grenades'})
                    elements.antiaims.espam = settings:switch("E-Spam while Safe Head")
                end

                elements.antiaims.defensive_type:set_callback(function(self)
                    elements.antiaims.defensive_pitch:visibility(self:get() == 'Presets')
                    elements.antiaims.defensive_yaw:visibility(self:get() == 'Presets')
                    elements.antiaims.custom_pitch:visibility(self:get() == 'Custom')
                    elements.antiaims.custom_yaw:visibility(self:get() == 'Custom')
                end, true)

                elements.antiaims.freestanding = antiaim_group:switch '\a{Link Active}   \aDEFAULTFreestanding' do
                    local settings = elements.antiaims.freestanding:create()

                    elements.antiaims.body_freestanding = settings:switch 'Body Freestanding'
                    elements.antiaims.disable_manual = settings:switch 'Disable on Manuals'
                    elements.antiaims.yawmodif = settings:switch 'Disable Yaw Mod.'
                end

                elements.antiaims.anim_breakers = antiaim_group:switch("\a{Link Active}   \aDEFAULTAnim. Breakers") do
                    local settings = elements.antiaims.anim_breakers:create()

                    elements.antiaims.type_legs_ground = settings:combo('On Ground', {'Disable', 'Follow Direction', 'Moon Walk', 'Jitter'})
                    elements.antiaims.type_legs_air = settings:combo('In Air', {'Disable', 'Static', 'Moon Walk'})
                    --elements.antiaims.move_lean = settings:slider('Move Lean', -180, 180, 0)
                    elements.antiaims.static_slow = settings:switch("Sliding On Slow-Walk")
                    elements.antiaims.custom_move = settings:switch("Move Lean")
                    elements.antiaims.move_lean = settings:slider('Move Lean Force', 0, 100, 0, nil, '%')
                end

                elements.antiaims.custom_move:set_callback(function(self)
                    elements.antiaims.move_lean:visibility(self:get())
                end, true)


                --elements.antiaims.movement_helpers:tooltip('\a{Link Active}Auto jumpbug.\aDEFAULT\nWill try to prevent you from getting damage when falling from high height.\n\n\a{Link Active}Fast ladder.\aDEFAULT\nYou climb faster on ladder.')

                --ragegroup
                 elements.ragebot.rev_help = rage_group:switch 'Revolver Helper'
                 elements.ragebot.rev_help:tooltip('Shows "DMG+" indicator next to opponent if you can give 100 damage an opponent with a revolver.\nYou can edit indicator position in esp settings.')

                    elements.ragebot.hc_enable = rage_group:switch 'Hitchance Additionals' do
                     local settings = elements.ragebot.hc_enable:create()

                     elements.ragebot.hc_cond = settings:selectable('Condition', {'Air', 'No scope'})
                     elements.ragebot.hc_air = settings:slider('Air', 0, 100, 55)
                     elements.ragebot.hc_ns = settings:slider('No scope', 0, 100, 55)
                 end

                 elements.ragebot.hc_cond:set_callback(function(self)
                    elements.ragebot.hc_air:visibility(self:get('Air'))
                    elements.ragebot.hc_ns:visibility(self:get('No scope'))
                end, true)

                 elements.ragebot.fakelatency = rage_group:switch 'Unlock Fake Latency'
                 elements.ragebot.fakelatency:tooltip('Removes 100ms limit in ping spike')
            end

            local antiaim_builder do
                antiaim_builder = {}

                for i=1, 8 do
                    local spaces = string.rep(' ', i)
                    elements.antiaims_builder[i] = { }

                    elements.antiaims_builder[i].enabled = conditions:switch("Enable Condition" .. spaces, false)
                    elements.antiaims_builder[i].pitch = conditions:combo("Pitch" .. spaces, {'Disabled', 'Down', 'Fake Down', 'Fake Up'})

                    elements.antiaims_builder[i].yaw = conditions:combo("Yaw" .. spaces, {'Disabled', 'Backward', 'Static'}) do
                        local settings = elements.antiaims_builder[i].yaw:create()

                        elements.antiaims_builder[i].base = settings:combo('Base' .. spaces, {'Local View', 'At Target'})
                        elements.antiaims_builder[i].type = settings:combo("Yaw Mode" .. spaces, {'Default', 'Left/Right', 'Delayed'})
                        elements.antiaims_builder[i].delay = settings:switch("Swap compatible with inverter" .. spaces)
                        elements.antiaims_builder[i].offset_l = settings:slider("Offset" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].offset_r = settings:slider("Offset R" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].per_tick = settings:slider("Delay ticks" .. spaces, 3, 24, 12, nil, 't')
                        --elements.antiaims_builder[i].hidden = settings:switch("Hidden" .. spaces, false)
                    end

                    elements.antiaims_builder[i].jyaw = conditions:combo("Yaw Modifier" .. spaces, {'Disabled', 'Center', 'Offset', 'Random', 'Spin', '3-Way', '5-Way'}) do
                        local settings = elements.antiaims_builder[i].jyaw:create()

                        elements.antiaims_builder[i].mode = settings:combo("Mode" .. spaces, {"Static", "Random (From/To)", 'Left/Right'})
                        elements.antiaims_builder[i].type_mod = settings:combo("Settings" .. spaces, {"Default", "Custom"})
                        elements.antiaims_builder[i].offset_one = settings:slider("Offset #1" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].offset_two = settings:slider("Offset #2" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way1 = settings:slider("1 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way2 = settings:slider("2 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way3 = settings:slider("3 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way4 = settings:slider("4 Way" .. spaces, -180, 180, 0, nil, '°')
                        elements.antiaims_builder[i].way5 = settings:slider("5 Way" .. spaces, -180, 180, 0, nil, '°')
                    end

                    elements.antiaims_builder[i].body_yaw = conditions:switch("Body Yaw" .. spaces, false) do
                        local settings = elements.antiaims_builder[i].body_yaw:create()

                        elements.antiaims_builder[i].fake_slider_main = settings:slider("Left Limit" .. spaces, 0, 60, 60, nil, '°')
                        elements.antiaims_builder[i].fake_slider_next = settings:slider("Right Limit" .. spaces, 0, 60, 60, nil, '°')
                        elements.antiaims_builder[i].fake_op = settings:selectable("Fake Options" .. spaces, {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}, 0)
                        elements.antiaims_builder[i].freestand = settings:combo("Freestand DS" .. spaces, {"Off", "Peek Fake", "Peek Real"}, 0)
                        elements.antiaims_builder[i].inverter = settings:switch("Inverter AA" .. spaces, false)
                    end
                end



                local custom_aa = elements.antiaims_builder

                antiaim_builder.hide_all_custom = function()
                    for i = 1, 8 do
                        for _, k in pairs(custom_aa[i]) do
                            if not k:visibility() then goto skip end
                            k:visibility(false)
                            ::skip::
                        end
                    end
                end

                antiaim_builder.unhide_cur_custom = function(zxc, num)
                    if custom_aa[num].enabled:get() then
                        for _, k in pairs(custom_aa[num]) do
                            if k:visibility() then goto skip end
                            k:visibility(true)
                            ::skip::
                        end
                    else
                        for _, k in pairs(custom_aa[num]) do
                            if not k:visibility() then goto skip end
                            k:visibility(false)
                            ::skip::
                        end
                    end

                    custom_aa[num].enabled:visibility(true)
                end

                antiaim_builder.unhide_cur_enable_state = function(zxc, num)
                    custom_aa[num].enabled:visibility(true)
                end



                antiaim_builder.strange = function(zxc, condition_tab)

                    if condition_tab == 'Global' then
                        return 0
                    elseif condition_tab == 'Standing' then
                        return 1
                    elseif condition_tab == 'Moving' then
                        return 2
                    elseif condition_tab == 'Slow motion' then
                        return 3
                    elseif condition_tab == 'Air' then
                        return 4
                    elseif condition_tab == 'Air Crouch' then
                        return 5
                    elseif condition_tab == 'Crouch' then
                        return 6
                    elseif condition_tab == 'Crouch Move' then
                        return 7
                    elseif condition_tab == 'Dormant' then
                        return 8
                    end
                end


                antiaim_builder.init_handle = function(self)
                    events.pre_render:set(function()
                        if ui_get_alpha() ~= 1 then return end

                        local state = elements.antiaims.antiaim_mode:get()

                        antiaim_builder:hide_all_custom()
                        elements.antiaims.condition:visibility(state == 'Conditional')

                        if state == 'Conditional' then
                            antiaim_builder:unhide_cur_custom(antiaim_builder:strange(elements.antiaims.condition:get()) + 1)
                            antiaim_builder:unhide_cur_enable_state(antiaim_builder:strange(elements.antiaims.condition:get()) + 1)
                            for i=1, 8 do
                                if (custom_aa[i].jyaw:get() == '5-Way' or custom_aa[i].jyaw:get() == '3-Way') then custom_aa[i].mode:visibility(false) end
                                if (custom_aa[i].jyaw:get() == '3-Way' and custom_aa[i].type_mod:get() == 'Custom') then custom_aa[i].offset_one:visibility(false) custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(true) custom_aa[i].way2:visibility(true) custom_aa[i].way3:visibility(true) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end
                                if (custom_aa[i].jyaw:get() == '5-Way' and custom_aa[i].type_mod:get() == 'Custom') then custom_aa[i].offset_one:visibility(false) custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(true) custom_aa[i].way2:visibility(true) custom_aa[i].way3:visibility(true) custom_aa[i].way4:visibility(true) custom_aa[i].way5:visibility(true) end
                                if (custom_aa[i].jyaw:get() == '5-Way' and custom_aa[i].type_mod:get() == 'Default') then custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end
                                if (custom_aa[i].jyaw:get() == '3-Way' and custom_aa[i].type_mod:get() == 'Default') then custom_aa[i].offset_two:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end
                                if (custom_aa[i].jyaw:get() ~= '5-Way' and custom_aa[i].jyaw:get() ~= '3-Way') then custom_aa[i].type_mod:visibility(false) custom_aa[i].way1:visibility(false) custom_aa[i].way2:visibility(false) custom_aa[i].way3:visibility(false) custom_aa[i].way4:visibility(false) custom_aa[i].way5:visibility(false) end
                                if custom_aa[i].type:get() ~= 'Delayed' then custom_aa[i].per_tick:visibility(false) custom_aa[i].delay:visibility(false) end
                                if custom_aa[i].type:get() == 'Default' then custom_aa[i].offset_r:visibility(false) end
                                if custom_aa[i].mode:get() == 'Static' then custom_aa[i].offset_two:visibility(false) end

                            end

                            custom_aa[1].enabled:visibility(false)
                            custom_aa[1].enabled:set(true)
                            elements.antiaims.condition:visibility(true)
                        end

                    end)
                end
            end

            self.global = global
            self.info_group = info_group
            self.elements = elements
            self.antiaim_builder = antiaim_builder

            --set callbacks
            antiaim_builder:init_handle()
        end
    }

    :struct 'refs' {
        enable_desync = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        yaw_base = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        pitch = ui_find("Aimbot", "Anti Aim", "Angles", "Pitch"),
        yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        fake_op = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
        base_yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        --lby = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
        freestand = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
        --desync_os = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
        hidden = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
        slowwalk = ui_find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
        jyaw = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
        jyaw_slider = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
        fake_duck = ui_find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
        freestanding_def = ui_find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        left_limit = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
        right_limit = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
        dt = ui_find('Aimbot', 'Ragebot', 'Main', 'Double Tap'),
        hs = ui_find('Aimbot', 'Ragebot', 'Main', 'Hide shots'),
        body_aim = ui_find('Aimbot', 'Ragebot', 'Safety', 'Body Aim'),
        safe_point = ui_find("Aimbot", "Ragebot", "Safety", "Safe Points"),
        auto_peek = ui_find('Aimbot', 'Ragebot', 'Main', 'Peek Assist'),
        freestanding_yaw = ui_find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        hitchance = ui_find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
        min_dmg = ui_find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
        base = ui_find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        dormantaim = ui_find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
        pingspike = ui_find("Miscellaneous", "Main", "Other", "Fake Latency"),
        legmovement = ui_find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
        logs = ui_find("Miscellaneous", "Main", "Other", "Log Events"),
        inverter1 = ui_find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
        disablers = ui_find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
    }

    :struct 'config_system' {
        init = function(self)
            local config_system do
                local path = 'nl/scripts/mytools/mytools.config'
                config_system = {}

                local Xor = function(str)
                    local key = '6a 75 73 74 73 69 6d 70 6c 65 74 65 78 74'
                    local strlen, keylen = #str, #key

                    local strbuf = ffi.new('char[?]', strlen+1)
                    local keybuf = ffi.new('char[?]', keylen+1)

                    local success,_ = pcall(function()
                        return string.dump(ffi.copy)
                    end)

                    if success then
                        print_error 'You are not allowed to edit FFI Struct.'
                        common.unload_script()

                        return
                    end

                    ffi.copy(strbuf, str)
                    ffi.copy(keybuf, key)

                    for i=0, strlen-1 do
                        strbuf[i] = bit.bxor(strbuf[i], keybuf[i % keylen])
                    end

                    return ffi.string(strbuf, strlen)
                end

                Cipher = {
                    encode = function(a, b)
                        return '[mytools]' .. tostring(base64.encode(Xor(a,Cipher_code))) .. '[/mytools]'
                    end,

                    decode = function(a, b)
                        local prefix = '[mytools]'
                        local bypassed_prefix = '[/mytools]'

                        local q,e = a:find(prefix, 1, true)
                        local z,x = a:find(bypassed_prefix, 1, true)

                        a = a:sub(e + 1, z - 1):gsub(' ', '')

                        return tostring(Xor(base64.decode(a),Cipher_code))
                    end
                }

                config_system.import = function(zxc, c, only_aa)
                    local success, config_file = pcall(function()
                        return json.parse(Cipher.decode((type(zxc) == 'table' and clipboard.get()) or zxc))
                    end)

                    if c ~= nil then
                        success, config_file = pcall(function()
                            return json.parse(Cipher.decode(c))
                        end)
                    end

                    if not success then
                        self.impt.play_sound('error.wav', 0.12)
                        common_add_notify('mytools', '\aFF8B7AFF❌ There was an Error while Loading Your Config!')
                        return
                    end

                    for k,v in pairs(config_file) do
                        local imported_tbl = v

                        for m,j in pairs(self.menu.elements) do
                            if skip_data:get('Anti-Aims') then
                                if string.find(m, 'antiaims') == nil then
                                    goto skip
                                end

                                if string.find(m, 'antiaims_builder') == nil then
                                    goto skip
                                end
                            end

                            if skip_data:get('Ragebot') then
                                if string.find(m, 'ragebot') == nil then
                                    goto skip
                                end
                            end

                            if skip_data:get('Misc/Vis') then
                                if string.find(m, 'misc') == nil then
                                    goto skip
                                end

                                if string.find(m, 'visuals') == nil then
                                    goto skip
                                end
                            end

                            if m == v.tab then
                                for ce,net in pairs(j) do
                                    if get_type(net) == 'table' then
                                        for fnay,mishkat in pairs(net) do
                                            if v.name == mishkat:name() then
                                                mishkat:set(v.var)
                                            end
                                        end

                                        goto skip end

                                    if v.name == net:name() then
                                        net:set(v.var)
                                    end
                                    ::skip::
                                end
                            end

                            ::skip::
                        end
                    end

                    common_add_notify('mytools', '\a89F2CAFF✔️ Successfully Loaded Your Config')
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end

                config_system.save = function()
                    local preset_name = self.menu.global.preset_name:get()

                    local successed_export, exported_config = pcall(function()
                        local config_data = files.read(path)
                        local success, config_data = pcall(function()
                            return json.parse(config_data)
                        end)

                        if not success or #config_data == 0 then
                            config_data = {}
                        end


                        local num = self.menu.global.preset_list:get()
                        local presets_list = self.menu.global.preset_list:list()


                        local do_save = 0

                        if preset_name:gsub(' ', '') == '' or preset_name == '' then
                            do_save = 1

                            for i=1, #config_data do
                                local config_name = config_data[i].name
                                if config_name == presets_list[num] then
                                    do_save = -1
                                    config_data[i].code = self.config_system:export()
                                    files.write(path, json.stringify(config_data))
                                end
                            end
                        end



                        for i=1, #config_data do
                            local config_name = config_data[i].name

                            if config_name == preset_name then
                                do_save = 2

                                config_data[i].code = self.config_system:export()
                                files.write(path, json.stringify(config_data))
                                self.menu.global.preset_name:set('')
                                do_save = -2
                                break
                            end
                        end

                        if preset_name:gsub(' ', '') ~= '' then
                            local work = true

                            for i=1, #config_data do
                                local config_name = config_data[i].name

                                if config_name == preset_name then
                                    work = false
                                end
                            end

                            if work then
                                do_save = 3

                                table.insert(config_data, {code = self.config_system:export(), name = preset_name})

                                local name_file = {}
                                for i=1, #config_data do
                                    table.insert(name_file, config_data[i].name)
                                end

                                files.write(path, json.stringify(config_data))
                                self.menu.global.preset_list:update(name_file)
                                self.menu.global.preset_name:set('')
                                do_save = -3
                            end
                        end

                        if do_save == 1 then
                            self.impt.play_sound('error.wav', 0.12)
                            common_add_notify('mytools', '\aFF8B7AFF⚠️ Enter Valid Config Name!')

                            return
                        end


                        if do_save ~= 0 then
                            common_add_notify('mytools', '\a89F2CAFF✔️ Successfully Saved Your Config')
                            self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                        else
                            self.impt.play_sound('error.wav', 0.12)
                            common_add_notify('mytools', '\aFF8B7AFF❌ There was an Error while Loading Your Config!')
                        end
                    end)
                end

                config_system.delete = function()
                    local num = self.menu.global.preset_list:get()

                    local config_data = files.read(path)
                    local success, config_data = pcall(function()
                        return json.parse(config_data)
                    end)

                    if not success or #config_data == 0 then
                        config_data = {}
                    end

                    table.remove(config_data, num)
                    files.write(path, json.stringify(config_data))

                    local name_list = {}
                    for i=1, #config_data do
                        table.insert(name_list, config_data[i].name)
                    end

                    self.menu.global.preset_list:update(#name_list == 0 and {'\a{Link Active}Mytools. \aCBC9C9FFCreate preset.'} or name_list)
                    self.impt.play_sound('physics/wood/wood_plank_impact_hard4.wav', 0.12)
                end
            end

            config_system.export = function()
                local tbl = {}
                local ignore_list = {}

                for itab,tab in pairs(self.menu.elements) do
                    for k,v in pairs(tab) do
                        if get_type(v) == 'table' then
                            for k,v in pairs(v) do
                                table.insert(tbl, {tab = itab, name = v:name(), var = get_type(v:get()) == 'imcolor' and v:get():to_hex() or v:get()})
                            end
                            goto skip end
                        table.insert(tbl, {tab = itab, name = v:name(), var = get_type(v:get()) == 'imcolor' and v:get():to_hex() or v:get()})
                        ::skip::
                    end
                end

                local config = Cipher.encode(json.stringify(tbl))

                clipboard.set(config)
                return config
            end

            config_system.load = function()
                local last_config = db.last_config or { }

                local path = 'nl/scripts/mytools/mytools.config'
                local num = self.menu.global.preset_list:get()

                local config_data = files.read(path)
                local success, config_data = pcall(function()
                    return json.parse(config_data)
                end)

                local name_list = {}

                for i=1, #config_data do
                    table.insert(name_list, config_data[i].name)
                end

                if #name_list == 0 then
                    self.impt.play_sound('error.wav', 0.12)
                    common_add_notify('mytools', '\aFF8B7AFF❌ There was an Error while Loading Your Config!')
                    return
                end

                if not success or #config_data == 0 then
                    config_data = {}
                end

                config_system:import(config_data[num].code, true)
            end

            self.save = config_system.save
            self.delete = config_system.delete
            self.import = config_system.import
            self.export = config_system.export
            self.load = config_system.load
        end
    }


ctx.menu:init()
ctx.config_system:init()

local Ways = {
    Number = 0
}

local custom_aa = ctx.menu.elements.antiaims_builder

local antiaim_builder do
    antiaim_builder = {}

    antiaim_builder.get_velocity = function(s, player)
        if player == nil then
            return
        end

        local vel = player["m_vecVelocity"]
        if vel.x == nil then return end
        return math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z)
    end

    antiaim_builder.state = function(asd, lp_vel, player, cmd)
        local is_crouching = function()
            local localplayer = entity_get_local_player()
            local flags = localplayer['m_fFlags']

            if bit.band(flags, 4) == 4 then
                return true
            end

            return false
        end

        if lp_vel == nil then
            return
        end

        player = 0
        local get_player = nil
        local is_dormant = false
        local localplayer = entity_get_local_player()


        if false then
            cnds = 9
        elseif lp_vel < 5 and not cmd.in_jump and not (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 2
        elseif cmd.in_jump and not is_crouching(localplayer) then
            cnds = 5
        elseif cmd.in_jump and is_crouching(localplayer) then
            cnds = 6
        elseif lp_vel > 5 and (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 8
        elseif (is_crouching(localplayer) or ctx.refs.fake_duck:get()) then
            cnds = 7
        else
            if ctx.refs.slowwalk:get() then
            cnds = 4
            else
            cnds = 3
            end
        end

        return cnds
    end

    antiaim_builder.custom_preset = function()
        events.createmove:set(function(cmd)
            if entity_get_local_player() == nil then return end

            local lp = entity_get_local_player()
            local lp_vel = antiaim_builder:get_velocity(lp)
            local state = antiaim_builder:state(lp_vel, nil, cmd)

            local b, c = state, side
            if custom_aa[b] == nil then
                return
            end

            if ctx.menu.elements.antiaims.antiaim_mode:get() == 'Classic Jitter' or ctx.menu.elements.antiaims.antiaim_mode:get() == 'Defensive Preset' then
                if ctx.menu.elements.antiaims.antiaim_mode:get() == 'Classic Jitter' then
                    if b == 1 then
                        ctx.refs.pitch:override("Down")
                        ctx.refs.enable_desync:override(true)
                    elseif b == 2 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -20 or 28)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-20)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 3 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -6 or 10)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-58)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(36)
                        ctx.refs.right_limit:override(36)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 4 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -30 or 42)
                        ctx.refs.jyaw:override("Spin")
                        ctx.refs.jyaw_slider:override(-15)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(45)
                        ctx.refs.right_limit:override(45)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 5 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(35)
                        ctx.refs.jyaw:override("Offset")
                        ctx.refs.jyaw_slider:override(-50)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(60)
                        ctx.refs.right_limit:override(60)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 6 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and 5 or 20)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-42)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                    elseif b == 7 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Center")
                        ctx.refs.jyaw_slider:override(-15)
                        ctx.refs.fake_op:override({""})
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(true)
                        ctx.refs.enable_desync:override(true)
                    end

                elseif ctx.menu.elements.antiaims.antiaim_mode:get() == 'Defensive Preset' then
                    --defensivemeta
                    if b == 1 then
                        ctx.refs.pitch:override("Down")
                        ctx.refs.enable_desync:override(true)
                    elseif b == 2 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 3 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and -25 or 28)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(58)
                        ctx.refs.right_limit:override(58)
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 4 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        ctx.refs.yaw:override(43)
                        ctx.refs.jyaw:override("Offset")
                        ctx.refs.jyaw_slider:override(math.random(-65, -85))
                        ctx.refs.fake_op:override({"Jitter"})
                        ctx.refs.left_limit:override(30)
                        ctx.refs.right_limit:override(30)
                        ctx.refs.hidden:override(false)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
                    elseif b == 5 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                        else
                            ctx.refs.yaw:override(40)
                            ctx.refs.jyaw:override("Random")
                            ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -44)
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(60)
                            ctx.refs.right_limit:override(60)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    elseif b == 6 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                        else
                            ctx.refs.yaw:override(rage.antiaim:inverter() == true and 15 or 37)
                            ctx.refs.jyaw:override("Offset")
                            ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and 0 or -89)
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(60)
                            ctx.refs.right_limit:override(60)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.inverter1:override(false)
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    elseif b == 7 then
                        ctx.refs.base_yaw:override("At Target")
                        ctx.refs.pitch:override("Down")
                        ctx.refs.yaw_base:override("Backward")
                        if not ctx.refs.dt:get() and not ctx.refs.hs:get() then
                            ctx.refs.yaw:override(0)
                            ctx.refs.jyaw:override("Disabled")
                            ctx.refs.jyaw_slider:override(0)
                            ctx.refs.fake_op:override("")
                            ctx.refs.left_limit:override(25)
                            ctx.refs.right_limit:override(25)
                            ctx.refs.inverter1:override(false)
                        else
                            ctx.refs.yaw:override(rage.antiaim:inverter() == true and 0 or -15)
                            ctx.refs.jyaw:override("3 Way")
                            ctx.refs.jyaw_slider:override(math.random(-45, -70))
                            ctx.refs.fake_op:override({"Jitter"})
                            ctx.refs.left_limit:override(38)
                            ctx.refs.right_limit:override(29)
                            ctx.refs.inverter1:override(false)
                        end
                        ctx.refs.hidden:override(true)
                        ctx.refs.freestand:override("Off")
                        ctx.refs.enable_desync:override(true)
                        ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
                        ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
                        rage.antiaim:override_hidden_pitch(math.random(-89, 89))
                    end

                end

                if ctx.menu.elements.antiaims.safehead:get('Crouching') then
                   if b == 7 then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                if ctx.menu.elements.antiaims.safehead:get('Bomb') then
                    if entity_get_local_player():get_player_weapon() == nil then return end
                    bomb = entity_get_local_player():get_player_weapon():get_weapon_index() == 49
                    if bomb then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                if ctx.menu.elements.antiaims.safehead:get('Knife / Taser') then
                    if entity_get_local_player():get_player_weapon() == nil then return end
                    knifetaser = entity_get_local_player():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31
                    if knifetaser then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                if (ctx.menu.elements.antiaims.manual_aa:get() == "Right" or ctx.menu.elements.antiaims.manual_aa:get() == "Left" or ctx.menu.elements.antiaims.manual_aa:get() == "Forward") and ctx.menu.elements.antiaims.disablermanual:get() then
                    ctx.refs.fake_op:override({})
                    ctx.refs.jyaw:override("Disabled")
                end

                if ctx.menu.elements.antiaims.freestanding:get() and ctx.menu.elements.antiaims.yawmodif:get() then
                    ctx.refs.fake_op:override({})
                    ctx.refs.jyaw:override("Disabled")
                end

                if ctx.menu.elements.antiaims.safehead:get('Fake-Lag') then
                    if cmd.choked_commands > 1 then
                        ctx.refs.yaw:override(0)
                        ctx.refs.jyaw:override("Disabled")
                        ctx.refs.jyaw_slider:override(0)
                        ctx.refs.fake_op:override("")
                        ctx.refs.left_limit:override(25)
                        ctx.refs.right_limit:override(25)
                        ctx.refs.inverter1:override(true)
                    end
                end

                ctx.refs.base_yaw:override(ctx.menu.elements.antiaims.manual_aa:get() ~= 'Disabled' and 'Local view' or nil)
                if ctx.menu.elements.antiaims.manual_aa:get() ~= 'Disabled' then
                    ctx.refs.yaw:override(ctx.menu.elements.antiaims.manual_aa:get() == 'Left' and -90 or 90)
                    if ctx.menu.elements.antiaims.manual_aa:get() == 'Forward' then ctx.refs.yaw:override(-180) end
                end
            end

            if ctx.menu.elements.antiaims.antiaim_mode:get() ~= 'Conditional' then
                return
            end


            local d = custom_aa[b].enabled:get() and b or 1
            ctx.refs.yaw:set(0)
            ctx.refs.pitch:override(custom_aa[d].pitch:get())
            ctx.refs.yaw_base:override(custom_aa[d].yaw:get())
            ctx.refs.base_yaw:override(custom_aa[d].base:get())
            ctx.refs.enable_desync:override(custom_aa[d].body_yaw:get())
            ctx.refs.left_limit:override(custom_aa[d].fake_slider_main:get())
            ctx.refs.right_limit:override(custom_aa[d].fake_slider_next:get())
            --ctx.refs.hidden:override(custom_aa[d].hidden:get())
            ctx.refs.inverter1:override(custom_aa[d].inverter:get())

            if custom_aa[d].jyaw:get() == '5-Way' then

                if custom_aa[d].type_mod:get() == 'Custom' then
                    local Way = { 0, 0, 0 };
                    ctx.refs.jyaw:override('Disabled')
                    ctx.refs.jyaw_slider:override(0)

                    Way = { custom_aa[d].way1:get(), custom_aa[d].way2:get(), custom_aa[d].way3:get(), custom_aa[d].way4:get(), custom_aa[d].way5:get() };

                    local NewYaw = ctx.refs.yaw:get();

                    Ways.Number = Ways.Number + 1;

                    if (Ways.Number > #Way) then
                        Ways.Number = 1;
                    end

                    if (Way[Ways.Number] ~= nil) then
                        NewYaw = NewYaw + Way[Ways.Number];
                    end

                    ctx.refs.yaw:override(NewYaw);

                elseif custom_aa[d].type_mod:get() == 'Default' then
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())
                    ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                end

            elseif custom_aa[d].jyaw:get() == '3-Way' then

                if custom_aa[d].type_mod:get() == 'Custom' then
                    local Way = { 0, 0, 0 };
                    ctx.refs.jyaw:override('Disabled')
                    ctx.refs.jyaw_slider:override(0)

                    Way = { custom_aa[d].way1:get(), custom_aa[d].way2:get(), custom_aa[d].way3:get() };

                    local NewYaw = ctx.refs.yaw:get();

                    Ways.Number = Ways.Number + 1;

                    if (Ways.Number > #Way) then
                        Ways.Number = 1;
                    end

                    if (Way[Ways.Number] ~= nil) then
                        NewYaw = NewYaw + Way[Ways.Number];
                    end

                    ctx.refs.yaw:override(NewYaw);

                elseif custom_aa[d].type_mod:get() == 'Default' then
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())
                    ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                end


                else
                    ctx.refs.jyaw:override(custom_aa[d].jyaw:get())

                    if custom_aa[d].type:get() == 'Default' then
                        ctx.refs.yaw:override(custom_aa[d].offset_l:get())
                    elseif custom_aa[d].type:get() == 'Left/Right' then
                        ctx.refs.yaw:override(rage.antiaim:inverter() == true and custom_aa[d].offset_l:get() or custom_aa[d].offset_r:get())
                    elseif custom_aa[d].type:get() == 'Delayed' then
                        if globals.tickcount % custom_aa[d].per_tick:get() == (custom_aa[d].per_tick:get() - 1) then some_var = not some_var end
                        ctx.refs.yaw:override(some_var and custom_aa[d].offset_l:get() or custom_aa[d].offset_r:get())
                        if custom_aa[d].delay:get() then
                            ctx.refs.inverter1:override(some_var and true or false)
                        end
                    end

                    if custom_aa[d].mode:get() == 'Static' then
                        ctx.refs.jyaw_slider:override(custom_aa[d].offset_one:get())
                    elseif custom_aa[d].mode:get() == 'Random (From/To)' then
                        ctx.refs.jyaw_slider:override(math.random(custom_aa[d].offset_one:get(), custom_aa[d].offset_two:get()))
                    elseif custom_aa[d].mode:get() == 'Left/Right' then
                        ctx.refs.jyaw_slider:override(rage.antiaim:inverter() == true and custom_aa[d].offset_one:get() or custom_aa[d].offset_two:get())
                    end

            end

            ctx.refs.fake_op:override(custom_aa[d].fake_op:get())
            ctx.refs.freestand:override(custom_aa[d].freestand:get())

            local f = ctx.menu.elements.antiaims.manual_aa:get()


            if ctx.menu.elements.antiaims.safehead:get('Crouching') then
                if b == 7 then
                     ctx.refs.yaw:override(0)
                     ctx.refs.jyaw:override("Disabled")
                     ctx.refs.jyaw_slider:override(0)
                     ctx.refs.fake_op:override("")
                     ctx.refs.left_limit:override(25)
                     ctx.refs.right_limit:override(25)
                     ctx.refs.inverter1:override(true)
                 end
             end

            if ctx.menu.elements.antiaims.safehead:get('Bomb') then
                if entity_get_local_player():get_player_weapon() == nil then return end
                bomb = entity_get_local_player():get_player_weapon():get_weapon_index() == 49
                if bomb then
                    ctx.refs.yaw:override(0)
                    ctx.refs.jyaw:override("Disabled")
                    ctx.refs.jyaw_slider:override(0)
                    ctx.refs.fake_op:override("")
                    ctx.refs.left_limit:override(25)
                    ctx.refs.right_limit:override(25)
                    ctx.refs.inverter1:override(true)
                end
            end

            if ctx.menu.elements.antiaims.safehead:get('Knife / Taser') then
                if entity_get_local_player():get_player_weapon() == nil then return end
                knifetaser = entity_get_local_player():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31
                if knifetaser then
                    ctx.refs.yaw:override(0)
                    ctx.refs.jyaw:override("Disabled")
                    ctx.refs.jyaw_slider:override(0)
                    ctx.refs.fake_op:override("")
                    ctx.refs.left_limit:override(25)
                    ctx.refs.right_limit:override(25)
                    ctx.refs.inverter1:override(true)
                end
            end

            if ctx.menu.elements.antiaims.safehead:get('Fake-Lag') then
                if cmd.choked_commands > 1 then
                    ctx.refs.yaw:override(0)
                    ctx.refs.jyaw:override("Disabled")
                    ctx.refs.jyaw_slider:override(0)
                    ctx.refs.fake_op:override("")
                    ctx.refs.left_limit:override(25)
                    ctx.refs.right_limit:override(25)
                    ctx.refs.inverter1:override(true)
                end
            end

            if (f == "Right" or f == "Left" or f == "Forward") and ctx.menu.elements.antiaims.disablermanual:get() then
                ctx.refs.fake_op:override({})
                ctx.refs.jyaw:override("Disabled")
            end

            if ctx.menu.elements.antiaims.freestanding:get() and ctx.menu.elements.antiaims.yawmodif:get() then
                ctx.refs.fake_op:override({})
                ctx.refs.jyaw:override("Disabled")
            end

            ctx.refs.base_yaw:override(f ~= 'Disabled' and 'Local view' or custom_aa[d].base:get())
            if f ~= 'Disabled' then
                ctx.refs.yaw:override(f == 'Left' and -90 or 90)
                if f == 'Forward' then ctx.refs.yaw:override(-180) end
            end
        end)
    end
    antiaim_builder:custom_preset()
end

--console
function paint_c(fn)
    table.foreach(materials.get_materials("vgui/hud/800"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)

    table.foreach(materials.get_materials("vgui_white"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)
end

cvar.toggleconsole:set_callback(function()
    if not ctx.menu.elements.visuals.console_changer:get() then
        return
    end

    paint_c(color())

    if not console_is_visible(engine_client) then
        paint_c(ctx.menu.elements.visuals.console_color:get())
    end
end)

ctx.menu.elements.visuals.console_color:set_callback(function(self)
    if not ctx.menu.elements.visuals.console_changer:get() then
        return
    end

    paint_c(color())

    if console_is_visible(engine_client) then
        paint_c(ctx.menu.elements.visuals.console_color:get())
    end
end)

ctx.menu.elements.visuals.console_changer:set_callback(function(self)
    if not self:get() then
        paint_c(color())
    else
        paint_c(ctx.menu.elements.visuals.console_color:get())
    end
end, true)

--console end

local handlers do
    local loadTime = common_get_unixtime()

    local mt = {
        __index = {
            events_cache = {  },

            add = function(self, event, callback, target_bool, name)
                target_bool = true
                if self.events_cache[event] == nil then
                    self.events_cache[event] = {  }
                end

                table_insert(self.events_cache[event], { callback, target_bool == nil and true or target_bool, name })
            end,

            action = function(self)
                local last_tick = 0

                local t = self.events_cache

                for n,_ in pairs(t) do
                    events[n](function(arg)

                        for _,func_tbl in pairs(t[n]) do
                            if func_tbl[2] then
                                local successfullInit, output = pcall(function() return func_tbl[1](arg) end)

                                if not successfullInit then
                                    local targetFunction = func_tbl[3] or 'unnamed'

                                    local output = output
                                        :gsub(' B9BECB', '')
                                        :gsub(' 9AEFEA', '')
                                        :gsub('BFFF90', ' ')

                                    print_raw(string_format('got unexpected error ∴ [%s ~ %s] - \aF42E12FF%s', targetFunction, n, output:gsub('FF4040', '\aECC257')))

                                    local formatedLog = base64.encode(string_format('[%s:%s] - %s', targetFunction, n, output:gsub('FF4040', '')))

                                    local time = common_get_unixtime()-loadTime
                                    local signature = md5.sumhexa(string_format('%s%s%s%sidealyawenc0192', common.get_username(), time, 'mytools', formatedLog))

                                    local ctime = math.ceil(globals.realtime)

                                    if last_tick == ctime then
                                        return
                                    end

                                    cvar.play:call 'ambient\\weather\\rain_drip1'

                                    -- SEND CRASH LOG
                                    network.get('http://62.122.215.145:1120/relayCrashLog?username='..common.get_username()..'&time='..time..'&luaPrefix=mytools&errorLog='..formatedLog..'&signature=' .. signature, {  }, function() end)

                                    last_tick = ctime
                                end
                            end
                        end
                    end)
                end
            end
        },

        __metatable = false
    }

    handlers = setmetatable({  }, mt)
end

aa_state, dt_alpha, hs_alpha, dmg_alpha, x_value, wp = 'TARGET', 0, 0, 0, 0, 0

handlers:add('createmove', function(cmd)
    if ctx.menu.elements.antiaims.defensive_aa:get() then
        local def_pitch = ctx.menu.elements.antiaims.defensive_pitch:get()
        local def_yaw = ctx.menu.elements.antiaims.defensive_yaw:get()

        if ctx.menu.elements.antiaims.defensive_type:get() == 'Presets' then
            if def_pitch == "Disabled" then
                rage.antiaim:override_hidden_pitch(0)
            elseif def_pitch == "Up" then
                rage.antiaim:override_hidden_pitch(-89)
            elseif def_pitch == "Down" then
                rage.antiaim:override_hidden_pitch(89)
            elseif def_pitch == "Semi Up" then
                rage.antiaim:override_hidden_pitch(-45)
            elseif def_pitch == "Semi Down" then
                rage.antiaim:override_hidden_pitch(45)
            elseif def_pitch == "Random" then

                local stage = globals.tickcount % 5

                if stage == 0 then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif stage == 1 then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif stage == 2 then
                    rage.antiaim:override_hidden_pitch(0)
                elseif stage == 3 then
                    rage.antiaim:override_hidden_pitch(89)
                elseif stage == 4 then
                    rage.antiaim:override_hidden_pitch(89)
                end
            end

            --yaw
            if def_yaw == "Disabled" then
                rage.antiaim:override_hidden_yaw_offset(0)
            elseif def_yaw == "Sideways" then

                local stage = cmd.tickcount % 3

                if stage == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-100, -90))
                elseif stage == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 180))
                end
                elseif def_yaw == "Opposite" then
                    rage.antiaim:override_hidden_yaw_offset(-180)
                elseif def_yaw == "Spin" then
                    local calcspin = (globals.curtime * 550)
                    calcspin = math.normalize_yaw(calcspin)

                    rage.antiaim:override_hidden_yaw_offset(calcspin)
                elseif def_yaw == "Random" then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, 180))
                elseif def_yaw == "3-Way" then

                    local stage = cmd.tickcount % 3

                    if stage == 0 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(-110, -90))
                    elseif stage == 1 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 120))
                    elseif stage == 2 then
                        rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -150))
                    end

                elseif def_yaw == "5-Way" then

                local stage = cmd.tickcount % 5
                if stage == 0 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-90, -75))
                elseif stage == 1 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-45, -30))
                elseif stage == 2 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(-180, -160))
                elseif stage == 3 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(45, 60))
                elseif stage == 4 then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 110))
                end
            end
        end

        if ctx.menu.elements.antiaims.defensive_type:get() == 'Custom' then
            rage.antiaim:override_hidden_pitch(ctx.menu.elements.antiaims.custom_pitch:get())
            rage.antiaim:override_hidden_yaw_offset(ctx.menu.elements.antiaims.custom_yaw:get())
        end

        local lp = entity_get_local_player()
        local lp_vel = antiaim_builder:get_velocity(lp)
        local state = antiaim_builder:state(lp_vel, nil, cmd)
        local b = state

        local cond_active = false

        if (b == 2 and ctx.menu.elements.antiaims.lag_conditions:get("Standing")) or
        (b == 3 and ctx.menu.elements.antiaims.lag_conditions:get("Moving")) or
        (b == 4 and ctx.menu.elements.antiaims.lag_conditions:get("Slow Walking")) or
        (b == 7 and ctx.menu.elements.antiaims.lag_conditions:get("Crouching")) or
        (b == 8 and ctx.menu.elements.antiaims.lag_conditions:get("Crouch Move")) or
        ((b == 5 or b == 6) and ctx.menu.elements.antiaims.lag_conditions:get("In Air"))
        then
            cond_active = true
        else
            cond_active = false
        end

        if cond_active == true and ctx.menu.elements.antiaims.defensive_aa:get() then
            ctx.refs.hidden:override(true)
        else
            ctx.refs.hidden:override()
        end

        local f = ctx.menu.elements.antiaims.manual_aa:get()

        if (f == "Right" or f == "Left" or f == "Forward" or ctx.menu.elements.antiaims.freestanding:get()) and
            ctx.menu.elements.antiaims.defensive_disablers:get('Manuals')
        then
            ctx.refs.hidden:override(false)
        end

        if ctx.menu.elements.antiaims.espam:get() then

            if entity_get_local_player():get_player_weapon() == nil then return end
            knifetaser = entity_get_local_player():get_player_weapon():get_classname() == "CKnife" or weapon_index == 31

            if ctx.menu.elements.antiaims.safehead:get('Knife / Taser') and knifetaser then
                rage.antiaim:override_hidden_pitch(0)
                rage.antiaim:override_hidden_yaw_offset(180)
            end

            bomb = entity_get_local_player():get_player_weapon():get_weapon_index() == 49

            if ctx.menu.elements.antiaims.safehead:get('Bomb') and bomb then
                rage.antiaim:override_hidden_pitch(0)
                rage.antiaim:override_hidden_yaw_offset(180)
            end

            if ctx.menu.elements.antiaims.safehead:get('Crouching') and b == 7 then
                rage.antiaim:override_hidden_pitch(0)
                rage.antiaim:override_hidden_yaw_offset(180)
            end
        end

    end
end, true, 'custom_defensive')


handlers:add('createmove', function()
    if entity.get_local_player() == nil then return end
    if entity.get_local_player():get_player_weapon() == nil then return end

    local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
    local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

    if (ctx.menu.elements.antiaims.defensive_aa:get() and ctx.menu.elements.antiaims.defensive_disablers:get('Grenades')) and is_grenade then ctx.refs.hidden:override(false) end
end, true, 'grenades_defensive')

--tag
local misc = {}
misc._last_clantag = nil
misc._set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', utils.opcode_scan('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local set_clantag = function(v)
    if v == misc._last_clantag then return end
    misc._set_clantag(v, v)
    misc._last_clantag = v
  end

  local build_tag = function(tag)
    local ret = { ' ' }

    for i = 1, #tag do
        table.insert(ret, tag:sub(1, i))
    end

    for i = #ret - 1, 1, -1 do
        table.insert(ret, ret[i])
    end

    return ret
end

handlers:add('render', function()
    if not ctx.menu.elements.misc.clantag_changer:get() then set_clantag(" ", " ") return end
    if not globals.is_connected then return end
    tag = build_tag('mytools    ')
    local netchann_info = utils.net_channel()
    if netchann_info == nil then return end

    local latency = netchann_info.avg_latency[0] / globals.client_tick
    local tickcount_pred = globals.tickcount + latency
    local iter = math.floor(math.fmod(tickcount_pred / 30, #tag + 1) + 1)

    set_clantag(tag[iter])
end, true, 'clantag')

local hit, misses = 0, 0

handlers:add('aim_ack', function(e)
    if ctx.menu.elements.visuals.sindicators:get('Hit Percentage') then
        if e.state == nil then hit = hit + 1 else misses = misses + 1 end
    end
end, true, 'aim_ack_aimbot_stats')

local c4_info = {
    planting = false,
    on_plant_time = 0,
    fill = 0,
    planting_site = ""
}

local c4_img = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(100, 100))

local OldChoke, toDraw4, toDraw3, toDraw2, toDraw1, toDraw0 = 0, 0, 0, 0, 0, 0

handlers:add('createmove', function(cmd)
    if entity_get_local_player() == nil or entity_get_local_player():is_alive() == false then return end

    if cmd.choked_commands < OldChoke then
        toDraw0 = toDraw1
        toDraw1 = toDraw2
        toDraw2 = toDraw3
        toDraw3 = toDraw4
        toDraw4 = OldChoke
    end

    OldChoke = cmd.choked_commands
end, true, 'chokes_commands')

render_indicator = function(str, ay, clr, circle_clr, circle_degree, bomb_ic)
    local x, y = render_screen_size().x/100 + 9, render_screen_size().y/1.47
    ts = render.measure_text(font, nil, str)


    render.gradient(vector(x/1.9, y + ay), vector(x/1.9 + (ts.x) / 2 + 5, y + ay + ts.y + 11), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
    render.gradient(vector(x/1.9 + (ts.x) / 2 + 5, y + ay), vector(x/1.9 + (ts.x) + 40, y + ay + ts.y + 11), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
    render.text(font, vector(x, y + 8 + ay), clr, nil, str)

    if bomb_ic == true then
        render.texture(c4_img, vector(x, y + ay + 2), vector(32, 30), clr, 'f', 1)
    end

    if circle_clr and circle_degree then
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+8), color(0, 0, 0, 255), 10, 1, 10, 5)
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+8), circle_clr, 9, 1, circle_degree, 3)
    end
end

handlers:add('render', function()
    local player = entity_get_local_player()
        if player == nil then
            return
        end

        local c4 = entity.get_entities("CPlantedC4", true)[1]
        local bombsite = ""
        local timer = 0
        local defused = false
        local damage = 0
        local dmg = 0
        local willKill = false
        if c4 ~= nil then
        timer = (c4.m_flC4Blow - globals.curtime)
        defused = c4.m_bBombDefused
        if timer > 0 and not defused then
            local defusestart = c4.m_hBombDefuser ~= 4294967295
            local defuselength = c4.m_flDefuseLength
            local defusetimer = defusestart and (c4.m_flDefuseCountDown - globals.curtime) or -1
            if defusetimer > 0 then
                local clr = timer > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)

                local barlength = (((render_screen_size().y - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, render_screen_size().y), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, render_screen_size().y), color(25, 25, 25, 160))

                render.rect(vector(0, render_screen_size().y - barlength), vector(16, render_screen_size().y), clr)
            end

            bombsite = c4.m_nBombSite == 0 and "A" or "B"

            local eLoc = c4.m_vecOrigin


            if player.m_hObserverTarget and (player.m_iObserverMode == 4 or player.m_iObserverMode == 5) then
                lLoc = player.m_hObserverTarget['m_vecOrigin']
                health = player.m_hObserverTarget['m_iHealth']
                armor = player.m_hObserverTarget['m_ArmorValue']
            else
                lLoc = player.m_vecOrigin
                health = player.m_iHealth
                armor = player.m_ArmorValue
            end

            if armor == nil then return end
            if health == nil then return end
            if lLoc == nil then return end

            local distance = eLoc:dist(lLoc)
            local a = 450.7
            local b = 75.68
            local c = 789.2
            local d = (distance - b) / c;

            damage = a * math.exp(-d * d)

            if armor > 0 then
                local newDmg = damage * 0.5;

                local armorDmg = (damage - newDmg) * 0.5
                if armorDmg > armor then
                    armor = armor * (1 / .5)
                    newDmg = damage - armorDmg
                end
                damage = newDmg;
            end

            dmg = math.ceil(damage)

            if dmg >= health then
                willKill = true
            else
                willKill = false
            end
        end
    end

    if c4_info.planting then
        c4_info.fill = 3.125 - (3.125 + c4_info.on_plant_time - globals.curtime)
        if(c4_info.fill > 3.125) then
            c4_info.fill = 3.125
        end
    end


    local adjust_adding = 40
    local add_y = 0

    for _, enemy in ipairs(entity.get_players(true)) do
        if enemy == nil then fnayf = false end
        if enemy ~= nil and enemy:is_enemy() and enemy:is_dormant() then fnayf = true else
            fnayf = false end
    end

    smdmg, fnaychance = false, 0

    chance = (hit / (misses + hit))*100
    if hit == 0 and misses == 0 then fnaychance = 0 else fnaychance = chance end

    local binds = ui.get_binds()
    for k, v in pairs(binds) do
        if v.active and v.name == 'Min. Damage' then
            smdmg = true
        end
    end

    local binds = {
        {string_format('%i-%i-%i-%i-%i', toDraw4, toDraw3, toDraw2, toDraw1, toDraw0), ctx.menu.elements.visuals.sindicators:get('Choked commands') and player:is_alive(), color(200, 199, 197)},
        {string_format("%s", math.floor(fnaychance)) .. "%", ctx.menu.elements.visuals.sindicators:get('Hit Percentage') and player:is_alive(), color(200, 199, 197)},
        {"PING", ctx.menu.elements.visuals.sindicators:get('Ping spike') and player:is_alive() and ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get() > 0 and player:is_alive(), color(163, 194, 43)},
        {"BODY", ctx.menu.elements.visuals.sindicators:get('Body Aim') and player:is_alive() and ctx.refs.body_aim:get() == 'Force', color(200, 199, 197)},
        {"DT", ctx.menu.elements.visuals.sindicators:get('Double tap') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), rage.exploit:get() == 1 and color(200, 199, 197) or color(255, 0, 50)},
        {"DA", ctx.menu.elements.visuals.sindicators:get('Dormant aimbot') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):get(), fnayf == true and color(200, 199, 197) or color(255, 0, 50)},
        {"DUCK", ctx.menu.elements.visuals.sindicators:get('Fake duck') and player:is_alive() and ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(200, 199, 197)},
        {"MD", ctx.menu.elements.visuals.sindicators:get('Minimum damage') and player:is_alive() and smdmg == true, color(200, 199, 197)},
        {"FS", ctx.menu.elements.visuals.sindicators:get('Freestanding') and player:is_alive() and ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):get(), color(200, 199, 197)},
        {"        " .. bombsite .." - " .. string_format("%.1f", timer) .. "s", ctx.menu.elements.visuals.sindicators:get('Bomb info') and timer > 0 and not defused, color(200, 199, 197), nil, nil, true},
        {"FATAL", ctx.menu.elements.visuals.sindicators:get('Bomb info') and willKill, color(255, 0, 50, 255)},
        {"-" .. dmg .. " HP", ctx.menu.elements.visuals.sindicators:get('Bomb info') and not willKill and damage > 0.5, color(210, 216, 112, 255)},
        {"        " .. c4_info.planting_site, ctx.menu.elements.visuals.sindicators:get('Bomb info') and c4_info.planting, color(210, 216, 112, 255), color(255, 255), c4_info.fill/3.2, true},
        {"OSAA", ctx.menu.elements.visuals.sindicators:get('Hide shots') and player:is_alive() and ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and not ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(200, 199, 197)}
    }

    for k, v in pairs(binds) do
        if v[2] then
            render_indicator(v[1], add_y, v[3], v[4], v[5], v[6])
            add_y = add_y - adjust_adding
        end
    end
end, true, 'sindicators')

c4_info.reset = function()
    if not ctx.menu.elements.visuals.sindicators:get('Bomb info') then return end
    c4_info.planting = false
	c4_info.fill = 0
	c4_info.on_plant_time = 0
	c4_info.planting_site = ""
end

c4_info.bomb_beginplant = function(e)
    if not ctx.menu.elements.visuals.sindicators:get('Bomb info') then return end
    local player_resource = entity_get_player_resource()

    if player_resource == nil then
        return
    end

    c4_info.on_plant_time = globals.curtime
    c4_info.planting = true

    if c4_info.on_plant_time == nil then return end

    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB

    local userid = entity.get(e.userid, true)
    if userid == nil then return end

    local userid_origin = userid:get_origin()
    if userid_origin == nil then return end

    if m_bombsiteCenterA == nil or m_bombsiteCenterB == nil then return end

    local dist_to_a = userid_origin:dist(m_bombsiteCenterA)
    local dist_to_b = userid_origin:dist(m_bombsiteCenterB)

    c4_info.planting_site = dist_to_a < dist_to_b and "A" or "B"
end

handlers:add('bomb_beginplant', function(e) c4_info.bomb_beginplant(e) end, true, 'bombbegin')
handlers:add('bomb_abortplant', function() c4_info.reset() end, true, 'bombabort')
handlers:add('bomb_planted', function() c4_info.reset() end, true, 'bombplanted')
handlers:add('bomb_defused', function() c4_info.reset() end, true, 'bombdefused')
handlers:add('bomb_pickup', function() c4_info.reset() end, true, 'bombpickup')
handlers:add('round_start', function() c4_info.reset() end, true, 'roundstart')

handlers:add('render', function()
    local x, y = render_screen_size().x, render_screen_size().y
    if ctx.menu.elements.visuals.on_screen:get() and ctx.menu.elements.visuals.select:get() == 'Default' then
        if entity_get_local_player() == nil then return end
        if entity_get_local_player():is_alive() == false then return end

        --states
        local velocity = function(ent)
            local speed_x = ent["m_vecVelocity[0]"]
            local speed_y = ent["m_vecVelocity[1]"]
            local speed = math.sqrt(speed_x * speed_x + speed_y * speed_y)
            return speed
        end

        local lp_vel = velocity(entity_get_local_player())
        local jumping = bit.band(entity_get_local_player()["m_fFlags"], bit.lshift(1,0)) == 0 or common.is_button_down(0x20)
        local is_crouching = entity_get_local_player()["m_flDuckAmount"] > 0.8 or common.is_button_down(0xA2)
        local mdmg = false

        if (jumping and not is_crouching) or (jumping and is_crouching) then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- JUMPING -" or "jumping"
        elseif not jumping and not common.is_button_down(0x20) and is_crouching or ctx.refs.fake_duck:get() then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- CROUCH -" or "crouch"
        elseif (not is_crouching or ctx.refs.fake_duck) and not jumping and not ctx.refs.slowwalk:get() and lp_vel > 4 then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- MOVING -" or "moving"
        elseif ctx.refs.slowwalk:get() then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- SLOWWALK -" or "slowwalk"
        elseif lp_vel < 5 and (not is_crouching or ctx.refs.fake_duck) and not jumping then
            aa_state = ctx.menu.elements.visuals.fonts:get() == 'Small' and "- STANDING -" or "standing"
        end
        --

        local binds = ui_get_binds();
        for k, v in pairs(binds) do
            if v.active and v.name == 'Min. Damage' then
            mdmg = true
            end
        end

        if entity.get_local_player():get_player_weapon() == nil then return end
        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
        local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

        x_value = lerp(globals.frametime * 16, x_value, entity_get_local_player().m_bIsScoped and x/2 + 43 or x/2)
        dt_alpha = lerp(globals.frametime * 8, dt_alpha, (ctx.refs.dt:get() and (is_grenade and 100 or 255) or 0))
        hs_alpha = lerp(globals.frametime * 8, hs_alpha, (ctx.refs.hs:get() and (is_grenade and 100 or 255) or 0))
        dmg_alpha = lerp(globals.frametime * 8, dmg_alpha, (mdmg == true and (is_grenade and 100 or 255) or 0))
        wp = lerp(globals.frametime * 8, wp, (is_grenade and 100 or 255))

        alpha_cl = clamp((math.floor(math.sin(globals.realtime * 5) * (1*255/2-1) + 1*255/2) or 1*255), 35, 255)
        render.shadow(ctx.menu.elements.visuals.fonts:get() == 'Small' and vector(x_value - 20, y/2 + 20) or vector(x_value - 35, y/2 + 20), ctx.menu.elements.visuals.fonts:get() == 'Small' and vector(x_value + 20, y/2 + 20) or vector(x_value + 30, y/2 + 20), ctx.menu.elements.visuals.indicator_color:get(), ctx.menu.elements.visuals.glow_px:get(), 0, 0)

        indicator_text = modify.gradient(ctx.menu.elements.visuals.fonts:get() == 'Small' and (ctx.cheat.version == 'Nightly' and 'NIGHTLY' or (ctx.cheat.version == 'Alpha' and "ALPHA" or 'LUA')) or (ctx.cheat.version == 'Nightly' and 'nightly' or (ctx.cheat.version == 'Alpha' and "alpha" or 'lua')), color(ctx.menu.elements.visuals.build_color:get().r, ctx.menu.elements.visuals.build_color:get().g, ctx.menu.elements.visuals.build_color:get().b, alpha_cl), color(ctx.menu.elements.visuals.build_color:get().r, ctx.menu.elements.visuals.build_color:get().g, ctx.menu.elements.visuals.build_color:get().b, alpha_cl))

        render_text(ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, vector(x_value, y/2 + 20), color(ctx.menu.elements.visuals.indicator_color:get().r, ctx.menu.elements.visuals.indicator_color:get().g, ctx.menu.elements.visuals.indicator_color:get().b, wp), "c", ctx.menu.elements.visuals.fonts:get() == 'Small' and ("MYTOOLS  " .. indicator_text) or ("mytools " .. indicator_text))
        render_interpolate_string("aa_ind", vector(x_value, y/2 + 30), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, wp), nil, aa_state)

        if ctx.refs.dt:get() and not ui_find("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, dt_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'DT  ' or 'dt ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'DT  ' or 'dt ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        elseif ctx.refs.dt:get() and ui_find("Aimbot", "Ragebot", "Main", "Peek Assist"):get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, dt_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'IDEALTICK  ' or 'idealtick ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'IDEALTICK  ' or 'idealtick ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        elseif ctx.refs.hs:get() and not ctx.refs.dt:get() then
            render_interpolate_string("dt_ind", vector(x_value, y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, hs_alpha), nil, rage.exploit:get() == 1 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'HIDE  ' or 'hide ') .. (get_defensive(entity_get_local_player(), true) > 2 and (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\a7FFFFFFFACTIVE' or '\a7FFFFFFFactive') or (ctx.menu.elements.visuals.fonts:get() == 'Small' and '\aC0FF91FFREADY' or '\aC0FF91FFready')) or (ctx.menu.elements.visuals.fonts:get() == 'Small' and 'HIDE  ' or 'hide ') .. (ctx.menu.elements.visuals.fonts:get() == 'Small' and "\aFF9494FFWAITING" or "\aFF9494FFwaiting"))
        end

        render_interpolate_string("dmg_ind", vector(x_value, (ctx.refs.dt:get() or ctx.refs.hs:get()) and y/2 + 50 or y/2 + 40), ctx.menu.elements.visuals.fonts:get() == 'Small' and 2 or 1, color(255, 255, 255, mdmg == true and 255 or 0), nil, ctx.menu.elements.visuals.fonts:get() == 'Small' and (mdmg == true and "DMG" or "   ") or (mdmg == true and "dmg" or "   "))
    end

    if ctx.menu.elements.visuals.sindicators:get('Spectator list') then
        local me = entity_get_local_player()
        if me == nil then return end
        if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
            me = me.m_hObserverTarget
        end

        local speclist = me:get_spectators()
        if speclist == nil then return end

        for idx,player_ptr in ipairs(speclist) do
            local sx, sy = render_screen_size().x, render_screen_size().y

            local name = player_ptr:get_name()
            local tx = render_measure_text(1, '', name).x

            if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
            render_text(1, vector(sx - tx - 7, -10 + (idx*20)), color(), 'u', name)
            ::skip::
        end
    end
end, true, 'indicators')

local anti_aim_on_use, start_curtime = false, globals.curtime

handlers:add('createmove', function(cmd)
    local local_player = entity_get_local_player()
    if local_player == nil then return end
    local m_iTeamNum = local_player.m_iTeamNum
    local use = bit.rshift(bit.lshift(cmd.buttons, 26), 31)
    if local_player:get_player_weapon() == nil then return end
    local anti_aim_on_use_work = true
    for i, entities in pairs({entity.get_entities("CPlantedC4"), entity.get_entities("CHostage")}) do
        for i, entity in pairs(entities) do
            if local_player:get_origin():dist(entity:get_origin()) < 65 and local_player:get_origin():dist(entity:get_origin()) > 1 and m_iTeamNum == 3 then
                anti_aim_on_use_work = false
            end
        end
    end
    if m_iTeamNum == 2 and local_player.m_bInBombZone and local_player:get_player_weapon():get_weapon_index() == 49 then
        anti_aim_on_use_work = false
    end


    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Legit AA') and ctx.menu.elements.antiaims.manual_aa:get() == 'Left' or ctx.menu.elements.antiaims.manual_aa:get() == 'Right' or ctx.menu.elements.antiaims.manual_aa:get() == 'Forward' or ctx.refs.freestanding_def:get() and use ~= 0 and anti_aim_on_use_work then return end
    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Legit AA') and use ~= 0 and anti_aim_on_use_work then
        if globals.curtime - start_curtime > 0.02 then
            cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
            anti_aim_on_use = true
            ctx.refs.left_limit:override(60)
            ctx.refs.right_limit:override(60)
            ctx.refs.pitch:override('Disabled')
            ctx.refs.yaw:override(180)
            ctx.refs.jyaw_slider:override(5)
            ctx.refs.base:override('Local View')
        end
    else
        start_curtime = globals.curtime
		anti_aim_on_use = false
    end
end, true, 'legit_antiaim')

handlers:add('createmove', function(c)
    if ctx.menu.elements.antiaims.antiaims_tweaks:get("Bombsite E Fix") then
        local plocal = entity_get_local_player()
        if entity_get_local_player() == nil then return end
        if plocal:get_player_weapon() == nil then return end
        local team_num, on_bombsite, defusing = plocal.m_iTeamNum, plocal.m_bInBombZone, team_num == 3
        local trynna_plant = team_num == 2 and has_bomb
        local inbomb = on_bombsite ~= false

        local use = common.is_button_down(0x45)

        if not inbomb and ctx.menu.elements.antiaims.antiaims_tweaks:get('Legit AA') then return end
        if inbomb and not trynna_plant and not defusing and use then
            ctx.refs.jyaw_slider:override(0)
            ctx.refs.left_limit:override(0)
            ctx.refs.right_limit:override(0)
            ctx.refs.pitch:override('Disabled')
            ctx.refs.yaw_base:override('Disabled')
            ctx.refs.base:override('Local View')
        end

        if inbomb and not trynna_plant and not defusing then
            c.in_use = 0
        end
    end
end, true, 'bombsitefix')

local raw_hwnd 			= utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
local raw_FlashWindow 	= utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
local raw_insn_jmp_ecx 	= utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
local raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4")
local hwnd_ptr 		= ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow 	= ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx 	= ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

local function get_csgo_hwnd()
	return hwnd_ptr[0]
end

local function get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

local function notify_user()
	local csgo_hwnd = get_csgo_hwnd()
	if get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

handlers:add('round_start', function()
    if ctx.menu.elements.misc.taskbar:get() then
        notify_user()
    end
end, true, 'taskbarnotify')

handlers:add('round_start', function()
    local state = ctx.menu.elements.misc.muteunmute:get()

    if not state then
        return
    end

    entity.get_players(false, true, function(player_ptr)
        local player = panorama.MatchStatsAPI.GetPlayerXuid(
            player_ptr:get_index()
        )

        if panorama.GameStateAPI.HasCommunicationAbuseMute(player) then
        if not panorama.GameStateAPI.IsSelectedPlayerMuted(player) then goto skip end

        panorama.GameStateAPI.ToggleMute(player)
        ::skip::
        end
    end)
end, true, 'autounmute')

handlers:add('createmove', function(cmd)
    if ctx.menu.elements.antiaims.anim_breakers:get() and ctx.menu.elements.antiaims.type_legs_ground:get() == 'Jitter' then
        ctx.refs.legmovement:override(cmd.command_number % 3 == 0 and 'Default' or 'Sliding')
    end
end, true, 'slider_legs')

local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(ffi.typeof('void***'),b)return ffi.cast('c_animlayers**',ffi.cast('char*',b)+0x2990)[0][c]end

handlers:add('post_update_client_side_animation', function()
    if entity_get_local_player() == nil then return end
    if not entity_get_local_player():is_alive() then return end

    if not ctx.menu.elements.antiaims.anim_breakers:get() then return end

    if ctx.menu.elements.antiaims.type_legs_air:get() == 'Static' then
        entity_get_local_player().m_flPoseParameter[6] = 1
    end

    if ctx.menu.elements.antiaims.type_legs_ground:get() == 'Follow Direction' then
        entity_get_local_player().m_flPoseParameter[0] = 1
        ctx.refs.legmovement:set('Sliding')
    end

    if ctx.menu.elements.antiaims.type_legs_ground:get() == 'Jitter' then
        entity_get_local_player().m_flPoseParameter[0] = globals.tickcount % 4 > 1 and 0.5 or 1
        ctx.refs.legmovement:set('Sliding')
    end

    if ctx.menu.elements.antiaims.type_legs_ground:get() == 'Moon Walk' then
        entity_get_local_player().m_flPoseParameter[7] = 0
        ctx.refs.legmovement:set('Walking')
    end

    if ctx.menu.elements.antiaims.static_slow:get() and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
        entity_get_local_player().m_flPoseParameter[9] = 0
    end

    if ctx.menu.elements.antiaims.custom_move:get() then
        get_anim_layer(get_entity_address(entity_get_local_player():get_index()), 12).m_flWeight = ctx.menu.elements.antiaims.move_lean:get()/100
    end


    if ctx.menu.elements.antiaims.type_legs_air:get() == 'Moon Walk' then
        local velocity = function(ent)
            local speed_x = ent["m_vecVelocity[0]"]
            local speed_y = ent["m_vecVelocity[1]"]
            local speed = math.sqrt(speed_x * speed_x + speed_y * speed_y)
            return speed
        end

        if bit.band(entity_get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 and velocity(entity_get_local_player()) > 2 then
            get_anim_layer(get_entity_address(entity_get_local_player():get_index()), 6).m_flWeight = 1
        end
    end
end, true, 'anim_breakers')

handlers:add('createmove', function(cmd)
    if not ctx.menu.elements.antiaims.antiaims_tweaks:get('Fast Ladder') then return end

    self = entity_get_local_player()

    if self == nil then return end

    if self.m_MoveType == 9 then
        cmd.view_angles.y = math.floor(cmd.view_angles.y + 0.5)

        if cmd.forwardmove > 0 then
            if cmd.view_angles.x < 45 then
                cmd.view_angles.x = 89
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1

                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                end

                if cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                end

                if cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
            end
        elseif cmd.forwardmove < 0 then
            cmd.view_angles.x = 89
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            cmd.in_forward = 1
            cmd.in_back = 0

            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end

            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 150
            end

            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 30
            end
        end
    end
end, true, 'fastladder')

handlers:add('shutdown', function()
    set_clantag(" ", " ")
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
    cvar.r_aspectratio:float(0)
    ctx.refs.logs:override()
    ctx.refs.pitch:override()
    ctx.refs.yaw_base:override()
    ctx.refs.enable_desync:override()
    ctx.refs.left_limit:override()
    ctx.refs.right_limit:override()
    ctx.refs.jyaw:override()
    ctx.refs.jyaw_slider:override()
    ctx.refs.fake_op:override()
    ctx.refs.freestand:override()
    ctx.refs.yaw:override()
    ctx.refs.inverter1:override()
    ctx.refs.body_aim:override()
    ctx.refs.disablers:override()
    cvar.sv_maxunlag:float(0.2)
    if not entity.get_local_player() == nil then entity.get_local_player():set_icon() end
    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override()
    ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
    ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override()
    ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
    ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(current)

    paint_c(color(255, 255, 255, 255))
end, true, 'disable_lua')

handlers:action()


--indicators
local example1 = smoothy.new(ctx.refs.min_dmg:get())
local gr_alpha = 0

local new_drag_object = drag_system.register({ctx.menu.elements.visuals.dmg_indx, ctx.menu.elements.visuals.dmg_indy}, vector(20, 15), "Test", function(self)
    if entity_get_local_player() == nil then return end
    if entity_get_local_player():is_alive() == false then return end
    if ctx.menu.elements.visuals.damage_indicator:get() and ui_get_alpha() > 0.3 then
        render_rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100), 0, 5)
    end

    local example1_val = example1(0.05, ctx.refs.min_dmg:get(), easing_fn)

    if entity.get_local_player():get_player_weapon() == nil then return end
    local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
    local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

    gr_alpha = lerp(globals.frametime * 8, gr_alpha, is_grenade and 100 or 255)

    if ctx.menu.elements.visuals.damage_indicator:get() and {ui_get_alpha() > 0.3 or entity_get_local_player():is_alive()} then
        render_text(ctx.menu.elements.visuals.damage_font:get() == 'Small' and 2 or 1, vector(self.position.x + 11, self.position.y + 7), color(255, gr_alpha), "c", not ctx.menu.elements.visuals.dis_animation:get() and ((example1.value / ctx.refs.min_dmg:get()) < 1 and math.ceil(example1.value) or math.floor(example1.value)) or ctx.refs.min_dmg:get())
    end
end)

events.mouse_input:set(function()
    if ui_get_alpha() > 0.3 then return false end
end)

events.render:set(function()
    new_drag_object:update()
end)

--breakers
--local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(ffi.typeof('void***'),b)return ffi.cast('c_animlayers**',ffi.cast('char*',b)+0x2990)[0][c]end

--ot
onetap_data = {}

local hitlog = new_class()
:struct 'hit_mark' {
    hitlogger =
    (function()
        local b = {callback_registered = false, maximum_count, 8, data = {}}
        function b:register_callback()
        if self.callback_registered then
            return
        end
        events.render:set(function()

                local c = {56, 56, 57}
                local d = 10
                local e = self.data
                for f = #e, 1, -1 do
                    self.data[f].time = self.data[f].time - globals.frametime
                    local g, h = 255, 0
                    local i = e[f]
                    if i.time < 0 then
                        table.remove(self.data, f)
                    else
                        local j = i.def_time - i.time
                        local j = j > 1 and 1 or j
                        local k = 0.20
                        local l = 0
                        if i.time < 0.20 then
                            l = (j < 1 and j or i.time) / 0.20
                        end
                        if j < k then
                            l = (j < 1 and j or i.time) / 0.20
                        end
                        if i.time < 0.20 then
                            h = (j < 1 and j or i.time) / 0.20
                            g = h * 255
                            if h < 0.2 then
                                d = d - 15 * (1.0 - h / 0.2)
                            end
                        end
                        local xui = i.time < 0.20 and -1 or 1
                        i.draw = tostring(i.draw):upper()
                        if i.draw == "" then
                            goto m
                        end

                        if i.shot_pos == nil or render_world_to_screen(i.shot_pos) == nil then
                            return
                        end

                        local sx, sy = render_world_to_screen(i.shot_pos).x, render_world_to_screen(i.shot_pos).y
                        local xyeta = 55 * (g*xui) / 255*xui

                        render_text(verdana, vector(sx, sy - 20), color(255, 255, 255, g/4), "c", i.draw)
                        render_text(verdana, vector(sx, sy - 20), color(255, 0, 0, g/1.2), "c", i.draw)


                        d = d + 25
                        ::m::
                    end
                end
                self.callback_registered = true
            end
        )
    end
    function b:paint(p, q, userdata)
        local r = tonumber(p) + 1
        for f = 2, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
            self.data[1] = {time = r, def_time = r, draw = q, shot_pos = userdata}
            self:register_callback()
        end
        return b
    end)()
    }

    :struct 'aim_hit' {
    init = function(self)
        events.aim_ack:set(function(e)
            if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.ot_marker:get() then
                if e.hitgroup == 1 then clr = color(255, 0, 0):to_hex() else clr = color(255, 255, 255):to_hex() end

                if e.state == nil then
                    self.hit_mark.hitlogger:paint(2, "\a"..clr.."" .. e.damage, e.aim)
                end
            end

    end)
end
}
hitlog.aim_hit:init()

local function register_marker(z)
    if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.ot_marker:get() then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            if z.state == nil then
                table.insert(onetap_data,  {z.aim, globals.realtime + 3})
            end
        end
    end
end

local function onetap_marker()
    if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.ot_marker:get() then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            for k, v in pairs(onetap_data) do

                if globals.realtime > v[2] then
                    table.remove(onetap_data, 1)
                end

                if v[1]:to_screen() ~= nil then
                    render.line(vector(v[1]:to_screen().x + 4, v[1]:to_screen().y + 4), vector(v[1]:to_screen().x + (4 * 2), v[1]:to_screen().y + (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x - 4, v[1]:to_screen().y + 4), vector(v[1]:to_screen().x - (4 * 2), v[1]:to_screen().y + (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x + 4, v[1]:to_screen().y - 4), vector(v[1]:to_screen().x + (4 * 2), v[1]:to_screen().y - (4 * 2)), color(255, 255, 255, 255))
                    render.line(vector(v[1]:to_screen().x - 4, v[1]:to_screen().y - 4), vector(v[1]:to_screen().x - (4 * 2), v[1]:to_screen().y - (4 * 2)), color(255, 255, 255, 255))
                end
            end
        end
    end
end
events.aim_ack:set(register_marker)
events.render:set(onetap_marker)
events.round_prestart:set(function() onetap_data = {} end)

--kibit
kibit_data = {}

local function register_marker(z)
    if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.kibit_marker:get() then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            if z.state == nil then
                table.insert(kibit_data,  {z.aim, globals.realtime + 3})
            end
        end
    end
end

local function kibit_marker()
    if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.kibit_marker:get() then
        if entity_get_local_player() ~= nil and entity_get_local_player():is_alive() then
            for k, v in pairs(kibit_data) do

                if globals.realtime > v[2] then
                    table.remove(kibit_data, 1)
                end

                if v[1]:to_screen() ~= nil then
                    render.rect(vector(v[1]:to_screen().x - 1, v[1]:to_screen().y - 6), vector(v[1]:to_screen().x + 1, v[1]:to_screen().y + 6), color(34, 214, 132, 255))
                    render.rect(vector(v[1]:to_screen().x - 6, v[1]:to_screen().y - 1), vector(v[1]:to_screen().x + 6, v[1]:to_screen().y + 1) , color(108, 182, 203, 255))
                end
            end
        end
    end
end

events.aim_ack:set(register_marker)
events.render:set(kibit_marker)
events.round_prestart:set(function() kibit_data = {} end)

--logs
local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

events.item_purchase:set(function(e)
    if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.purchases:get() then

        local playerz = entity.get(e.userid, true)
        local weaponz = e.weapon

        if playerz == nil then return end
        if weaponz == 'weapon_unknown' then return end
        if not playerz:is_enemy() then return end

        print_raw(('\a{Link Active}mytools \a85858DFF·\aD5D5D5FF %s bought \aACFF86FF%s'):format(string.lower(playerz:get_name()), weaponz))
        print_dev(('%s bought \aACFF86FF%s\aDEFAULT'):format(playerz:get_name(), weaponz))

    end
end)

events.aim_ack:set(function(e)
    if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Console") then
        local me = entity_get_local_player()
        local target = entity.get(e.target)
        local state, state1 = e.state, e.state
        if not target then return end
        if target == nil then return end
        local health = target["m_iHealth"]
        if entity_get_local_player() == nil then return end

        --paste
        if state1 == "spread" then
            state1 = "\aFEEA7DFFspread"
        end
        if state1 == "prediction error" then
            state1 = "\aFEEA7DFFpred. error"
        end
        if state1 == "correction" then
            state1 = "\aFF5959FFresolver"
        end
        if state1 == "damage rejection" then
            state1 = "\aFF5959FFdamage rejection"
        end
        if state1 == "misprediction" then
            state1 = "\aFEEA7DFFmisprediction"
        end
        if state1 == "lagcomp failure" then
            state1 = "\aFF5959FFlagcomp failure"
        end
        if state1 == "backtrack failure" then
            state1 = "\aFF5959FFbacktrack failure"
        end
        if state == "correction" then
            state = "resolver"
        end
        --

        if state == nil then
            print_dev(("Hit \a"..active_color..""..target:get_name().." \aDEFAULTin the \a"..active_color.."%s \aDEFAULTfor \a"..active_color.."%d \aDEFAULTdamage (\a"..active_color..""..health.." \aDEFAULThealth remaining) Δ: \a"..active_color.."%s\aDEFAULT"):format(hitgroup_str[e.hitgroup], e.damage, e.backtrack))
            print_raw(("\a{Link Active}mytools \a85858DFF· \aD5D5D5FFHit \a"..active_color..""..string.lower(target:get_name()).." \aDEFAULTin the \a"..active_color.."%s \aDEFAULTfor \a"..active_color.."%d\aDEFAULT(\a"..active_color..""..string_format("%.f", e.wanted_damage).."\aDEFAULT) damage (\a"..active_color..""..health.." \aDEFAULThealth remaining) (aim: "..hitgroup_str[e.wanted_hitgroup].." | bt(Δ): %s)"):format(hitgroup_str[e.hitgroup], e.damage, e.backtrack))
        else
            print_dev(('Missed shot in \a{Link Active}'..target:get_name()..'\aDEFAULT\'s \aDEFAULT%s \aDEFAULTdue to \a{Link Active}'..state..' \aDEFAULTΔ: \a{Link Active}%s\aDEFAULT'):format(hitgroup_str[e.wanted_hitgroup], e.backtrack))
            print_raw(('\a{Link Active}mytools \a85858DFF· \aD5D5D5FFMissed shot in \a{Link Active}%s\aDEFAULT\'s \a{Link Active}%s \aDEFAULTdue to '..state1..'\aD5D5D5FF (hc: '..string_format("%.f", e.hitchance)..' | dmg: '..string_format("%.f", e.wanted_damage)..' | bt(Δ): %s)'):format(string.lower(target:get_name()), hitgroup_str[e.wanted_hitgroup], e.backtrack))
        end


    end
end)

events.player_hurt:set(function(e)
    if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Console") then
            local me = entity_get_local_player()
            local attacker = entity.get(e.attacker, true)
            local weapon = e.weapon
            local type_hit = 'hit'

            if weapon == 'hegrenade' then
                type_hit = 'Naded'
            end

            if weapon == 'inferno' then
                type_hit = 'Burned'
            end

            if weapon == 'knife' then
                type_hit = 'Knifed'
            end

            if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then

            if me == attacker then
                local user = entity.get(e.userid, true)
                print_raw(('\a{Link Active}mytools \a85858DFF· \aD5D5D5FF'..type_hit..' \a{Link Active}%s \aDEFAULTfor \a{Link Active}%d\aDEFAULT damage (\a{Link Active}%d \aDEFAULThealth remaining)'):format(string.lower(user:get_name()), e.dmg_health, e.health))
                print_dev((''..type_hit..' \a{Link Active}'..user:get_name()..' \aDEFAULTfor \a{Link Active}%d \aDEFAULTdamage (\a{Link Active}%d \aDEFAULThealth remaining)'):format(e.dmg_health, e.health))
            end
        end
    end--]]
end)

--velocity
local smoothy_warning = smoothy.new({
    alpha = 0,
    vel_mod = 0
})

local new_drag_object_5 = drag_system.register({ctx.menu.elements.visuals.velocity_x, ctx.menu.elements.visuals.velocity_y}, vector(185, 50), "Test1", function(self)
    local me = entity.get_local_player()

    local vel_mod = smoothy_warning.value.vel_mod
    local percentage = math.floor((1-vel_mod)*100)
    local alpha = smoothy_warning.value.alpha

    smoothy_warning(.05, {
        vel_mod = not me and .34 or me.m_flVelocityModifier,
        alpha = (ctx.menu.elements.visuals.velocity_warning:get() and ((percentage ~= 0 and  me) or ui_get_alpha() > 0.3)) and 255 or 0
    })

    local success, should_render = pcall(function()
        return (not me:is_alive() and ui_get_alpha() ~= 1)
    end)

    if success and should_render then
        return
    end

    local target_color = color('EA6868FF'):lerp(color(ctx.menu.elements.visuals.velocity_color:get():to_hex()), vel_mod)
    local text = string.format('⛔ Max velocity reduced by %i%%', percentage)

    render.text(1, vector(self.position.x + 94, self.position.y + self.size.y - 21), color(255, alpha), 'c', text)
    render.shadow(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x - 7, self.position.y + self.size.y - 7), target_color:alpha_modulate(alpha), 14, 0, 3)
    render.rect(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x - 7, self.position.y + self.size.y - 7), color(0, alpha), 3)
    render.rect(vector(self.position.x + 7, self.position.y + self.size.y - 10), vector(self.position.x + self.size.x*vel_mod - 7, self.position.y - 7 + self.size.y), target_color:alpha_modulate(alpha), 3)
end)

events.render:set(function()
    if ctx.menu.elements.visuals.velocity_warning:get() then
        new_drag_object_5:update()
    end
end)

--nade fix
events.createmove:set(function()
    if ctx.menu.elements.misc.grenade_fix:get() then
        if entity.get_local_player() == nil then return end
        if entity.get_local_player():get_player_weapon() == nil then return end

        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
        local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

        if is_grenade then
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set({''})
        else
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(current)
        end
    end
end)
--

--logs under
local id = 1
events.player_hurt:set(function(e)
    if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Screen") then
		local me = entity_get_local_player()
		local attacker = entity.get(e.attacker, true)
        if me == attacker then
        local user = entity.get(e.userid, true)
        local hitgroup = hitgroup_str[e.hitgroup]
		local weapon_name = e.weapon
        if weapon_name == 'hegrenade' or weapon_name == 'inferno' or weapon_name == 'knife' then return end

        if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Screen") and not ctx.menu.elements.ragebot.select_log:get("Console") then
        print_raw(('\a{Link Active}mytools \a85858DFF· \aD5D5D5FFHit %s in the '..hitgroup..' for %d damage (%d hp remaining)'):format(user:get_name(), e.dmg_health, e.health))
        end

        if e.health < 1 then
            hitlog[#hitlog+1] = {("\aFFFFFFC8Hit \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..user:get_name().." \aFFFFFFC8in the \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..hitgroup.." \aFFFFFFC8for \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..e.dmg_health.." \aFFFFFFC8damage (\a"..ctx.menu.elements.ragebot.accent_color:get():to_hex().."dead\aFFFFFFC8)"), globals.tickcount + 300, 0}
        else
            hitlog[#hitlog+1] = {("\aFFFFFFC8Hit \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..user:get_name().." \aFFFFFFC8in the \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..hitgroup.." \aFFFFFFC8for \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..e.dmg_health.." \aFFFFFFC8damage (\a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..e.health.." \aFFFFFFC8hp remaining)"), globals.tickcount + 300, 0}
		end

        id = id == 999 and 1 or id + 1
	    end
    end
end)


events.grenade_prediction:set(function(e)
    if ctx.menu.elements.misc.grenade_release:get() then
        if entity.get_local_player() == nil then return end
        if entity.get_local_player():get_player_weapon() == nil then return end

        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()

        if not weapon_index == 44 or not weapon_index == 46 then return end

        if e.damage >= ctx.menu.elements.misc.min_dmg:get() then utils.console_exec('+attack') utils.execute_after(.1, function() utils.console_exec('-attack') end) end
    end
end)

events.aim_ack:set(function(shot)
	if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Screen") then
	player_name = shot.target:get_name()
    hitgroup = hitgroup_str[shot.hitgroup]
    wanted_hitgroup = hitgroup_str[shot.wanted_hitgroup]

    local state = shot.state

    if state == 'correction' then
        state = 'resolver'
    end

    if state == 'prediction error' then
        state = 'pred. error'
    end

    if not (state == nil) and ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Screen") and not ctx.menu.elements.ragebot.select_log:get("Console") then
        print_raw(("\a"..active_color.."mytools \a85858DFF· \aD5D5D5FFMissed shot in %s in the %s due to %s"):format(string.lower(player_name), wanted_hitgroup, state))
    end

	if not (state == nil) then
        hitlog[#hitlog+1] = {("\aFFFFFFC8Missed shot in \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..player_name.."'s \aFFFFFFC8"..wanted_hitgroup.." \aFFFFFFC8due to \a"..ctx.menu.elements.ragebot.accent_color:get():to_hex()..""..state.." "), globals.tickcount + 300, 0}
    end

	id = id == 999 and 1 or id + 1

    end
end)

events.render:set(function()
    if #hitlog > 0 then
        if globals.tickcount >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = render.measure_text(1, nil, hitlog[i][1]).x
           if hitlog[i][3] < 255 then
                hitlog[i][3] = hitlog[i][3] + 10
            end
            if ctx.menu.elements.ragebot.aimbot_logging:get() and ctx.menu.elements.ragebot.select_log:get("Screen") then
                if not ctx.menu.elements.ragebot.dis_glow:get() then
                    render.shadow(vector(render_screen_size().x/2 - text_size/2 + 40, render_screen_size().y/1.29 - (hitlog[i][3]/45) + 15 * i + 10), vector(render_screen_size().x/2 - text_size/2 + text_size + 25, render_screen_size().y/1.29 - (hitlog[i][3]/45) + 15 * i + 10), color(ctx.menu.elements.ragebot.accent_color:get().r, ctx.menu.elements.ragebot.accent_color:get().g, ctx.menu.elements.ragebot.accent_color:get().b, 255), 30, 0, 0)
                end
                render_text(1, vector(render_screen_size().x/2 - text_size/2 + 35, render_screen_size().y/1.3 - (hitlog[i][3]/45) + 15 * i + 10), color(255, 255, 255, hitlog[i][3]), nil, hitlog[i][1])
            end
		end
    end
end)


--viewmodel
events.render:set(function()
    if ctx.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(ctx.menu.elements.visuals.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(ctx.menu.elements.visuals.viewmodel_x:get()/10, true)
		cvar.viewmodel_offset_y:float(ctx.menu.elements.visuals.viewmodel_y:get()/10, true)
		cvar.viewmodel_offset_z:float(ctx.menu.elements.visuals.viewmodel_z:get()/10, true)
    end

    cvar.r_aspectratio:float(ctx.menu.elements.visuals.viewmodel_aspectratio:get()/100)

end)

ctx.menu.elements.visuals.viewmodel_changer:set_callback(function()
    if not ctx.menu.elements.visuals.viewmodel_changer:get() then
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
        end
end)

ctx.menu.elements.ragebot.fakelatency:set_callback(function()
    if ctx.menu.elements.ragebot.fakelatency:get() then
        cvar.sv_maxunlag:float(0.4)
    else
        cvar.sv_maxunlag:float(0.2)
    end
end, true)

--scope
local scope_line = {}
scope_line.screen = render_screen_size()
scope_line.var = ui_find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
scope_line.anim_num = 0
scope_line.lerp = function(a, b, t)
    return a + (b - a) * t
end

scope_line.on_draw = function()
    if ctx.menu.elements.visuals.custom_scope:get() then
        local_player = entity_get_local_player()

        if not local_player or not local_player:is_alive() or not local_player["m_bIsScoped"] then
            scope_line.anim_num = scope_line.lerp(scope_line.anim_num, 0, 15 * globals.frametime)
        else
            scope_line.anim_num = scope_line.lerp(scope_line.anim_num, 1, 15 * globals.frametime)
        end

        scope_line.var:override("Remove All")
        scope_line.offset = ctx.menu.elements.visuals.scope_gap:get() * scope_line.anim_num
        scope_line.length = ctx.menu.elements.visuals.scope_size:get() * scope_line.anim_num
        scope_line.col_1 = ctx.menu.elements.visuals.scope_color:get()
        scope_line.width = 1

        scope_line.col_1.a = scope_line.col_1.a * scope_line.anim_num

        scope_line.start_x = scope_line.screen.x / 2
        scope_line.start_y = scope_line.screen.y / 2

        if ctx.menu.elements.visuals.scope_style:get() == 'Default' then
            render.gradient(vector(scope_line.start_x - scope_line.offset, scope_line.start_y), vector(scope_line.start_x - scope_line.offset - scope_line.length, scope_line.start_y + scope_line.width), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x + scope_line.offset, scope_line.start_y), vector(scope_line.start_x + scope_line.offset + scope_line.length, scope_line.start_y + scope_line.width), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x, scope_line.start_y + scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y + scope_line.offset + scope_line.length), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
            render.gradient(vector(scope_line.start_x, scope_line.start_y - scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y - scope_line.offset - scope_line.length), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(255, 255, 255, 0))
        else
            render.gradient(vector(scope_line.start_x - scope_line.offset, scope_line.start_y), vector(scope_line.start_x - scope_line.offset - scope_line.length, scope_line.start_y + scope_line.width), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Left') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x + scope_line.offset, scope_line.start_y), vector(scope_line.start_x + scope_line.offset + scope_line.length, scope_line.start_y + scope_line.width), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Right') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x, scope_line.start_y + scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y + scope_line.offset + scope_line.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Down') and 0 or scope_line.col_1.a))
            render.gradient(vector(scope_line.start_x, scope_line.start_y - scope_line.offset), vector(scope_line.start_x + scope_line.width, scope_line.start_y - scope_line.offset - scope_line.length), color(255, 255, 255, 0), color(255, 255, 255, 0), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a), color(scope_line.col_1.r, scope_line.col_1.g, scope_line.col_1.b, ctx.menu.elements.visuals.remove_line:get('Up') and 0 or scope_line.col_1.a))
        end
    end
end
events.render:set(scope_line.on_draw)

ctx.menu.elements.visuals.custom_scope:set_callback(function()
    if not ctx.menu.elements.visuals.custom_scope:get() then
        scope_line.var:override()
    end
end)

events.createmove:set(function()
    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Fluctuate Fake Lag') then
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override(globals.tickcount % 9 == 9 - 1 and 1 or ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):get())
    else
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override()
    end
end)



events.createmove:set(function()
    local self = entity_get_local_player()
    if self == nil then return end
    if self:get_player_weapon() == nil then return end
    if ctx.refs.hs:get() then return end

    local weapon_index = self:get_player_weapon():get_weapon_index()

    local is_pistol = weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 30 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61 or weapon_index == 63
    local is_auto = weapon_index == 11 or weapon_index == 38
    local is_awp = weapon_index == 9
    local is_ssg = weapon_index == 40
    local is_heavy = weapon_index == 1 or weapon_index == 64
    local is_knifetaser = self:get_player_weapon():get_classname() == "CKnife" or weapon_index == 31
    local players = entity.get_players(true, false)

    --if globals.tickcount % custom_aa[d].per_tick:get() == (custom_aa[d].per_tick:get() - 1) then some_var = not some_var end

    for i, weapons in pairs({is_pistol, is_auto, is_awp, is_ssg, is_heavy, is_knifetaser,
    not (is_pistol or is_auto or is_awp or is_ssg or is_heavy or is_knifetaser)
    }) do
        if ctx.menu.elements.antiaims.antiaims_tweaks:get('Auto Teleport') and ctx.menu.elements.antiaims.weapons:get(i) and weapons and bit.band(self.m_fFlags, bit.lshift(1, 0)) == 0 then
            for i = 1, #players do
                if players[i]:is_alive() and players[i]:is_visible(players[i]:get_origin()) then
                    if globals.tickcount % ctx.menu.elements.antiaims.delayticks:get() == (ctx.menu.elements.antiaims.delayticks:get() - 1) then
                        rage.exploit:force_teleport()
                    end
                end
            end
        end
    end
end)

--killsay
local misc = new_class()
:struct 'killsay' {

    killsay_pharases = {
        {'⠀1', 'nice iq'},
        {'cgb gblfhfc', 'спи пидорас'},
        {'пздц', 'игрок'}

    },

    death_say = {
        {'фу ты заебал конч'},
        {')', 'хорош)'},
        {'норм трекаешь', 'ублюдина'},
        {'а че', 'хайдшоты на фд уже не работают?'}
    },

    init = function(self)
        events.player_death:set(function(e)

            delayed_msg = function(delay, msg)
                return utils.execute_after(delay, function() utils.console_exec('say ' .. msg) end)
            end

            local delay = 2.3
            local me = entity_get_local_player()
            local victim = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            local killsay_delay = 0
            local deathsay_delay = 0

            if entity_get_local_player() == nil then return end
            local gamerule = entity.get_game_rules()
            local warmup = gamerule["m_bWarmupPeriod"]

            if ctx.menu.elements.misc.killsay_disablers:get() and warmup == true then return end
            if not ctx.menu.elements.misc.killsay:get() then return end

            if (victim ~= attacker and attacker == me) then
                local phase_block = self.killsay.killsay_pharases[math_random(1, #self.killsay.killsay_pharases)]

                for i=1, #phase_block do
                    local phase = phase_block[i]
                    local interphrase_delay = #phase_block[i]/24*delay
                    killsay_delay = killsay_delay + interphrase_delay

                    delayed_msg(killsay_delay, phase)
                end
            end

            if (victim == me and attacker ~= me) then
                local phase_block = self.killsay.death_say[math_random(1, #self.killsay.death_say)]

                for i=1, #phase_block do
                    local phase = phase_block[i]
                    local interphrase_delay = #phase_block[i]/20*delay
                    deathsay_delay = deathsay_delay + interphrase_delay

                    delayed_msg(deathsay_delay, phase)
                end
            end
        end)
    end
}
misc.killsay:init()

--r8
local revolverhelper = esp.enemy:new_text("R8 Helper", "\a2FD500FFDMG+", function(player)
	local localplayer = entity_get_local_player()

    local dist_local = localplayer:get_origin()
    local dist_enemy = player:get_origin()
    local un = dist_local:dist(dist_enemy)

	if not localplayer then return end
	if localplayer:is_alive() then
		if (localplayer:get_player_weapon():get_weapon_index() == 64) then
			if (player['m_ArmorValue']) == 0 then
                if un < 585 then
					return "\a2FD500FFDMG+"
                else
                    return " "
				end
			end
		end
    end
end)

ctx.menu.elements.ragebot.rev_help:set_callback(function()
    if ctx.menu.elements.ragebot.rev_help:get() then revolverhelper:set(true) end
    if not ctx.menu.elements.ragebot.rev_help:get() then revolverhelper:set(false) end
end)
--end r8

events.createmove:set(function(cmd)
    if ctx.menu.elements.antiaims.antiaim_mode:get() == 'Defensive Preset' then return end
    local is_crouching = function()
    local localplayer = entity_get_local_player()
    local flags = localplayer['m_fFlags']

    if bit.band(flags, 4) == 4 then
        return true
    end

    return false
    end

    local cond_active = false

    local lp = entity_get_local_player()
    local lp_vel = antiaim_builder:get_velocity(lp)
    local state = antiaim_builder:state(lp_vel, nil, cmd)
    local b  = state

    local localplayer = entity_get_local_player()
    if ctx.menu.elements.antiaims.force_lag:get() then

        if (b == 2 and ctx.menu.elements.antiaims.lag_conditions:get("Standing")) or (b == 3 and ctx.menu.elements.antiaims.lag_conditions:get("Moving")) or
        (b == 4 and ctx.menu.elements.antiaims.lag_conditions:get("Slow Walking")) or
        (b == 7 and ctx.menu.elements.antiaims.lag_conditions:get("Crouching")) or
        (b == 8 and ctx.menu.elements.antiaims.lag_conditions:get("Crouch Move")) or
        ((b == 5 or b == 6) and ctx.menu.elements.antiaims.lag_conditions:get("In Air"))
        then
            cond_active = true
        else
            cond_active = false
        end

        if cond_active == true then
            ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
            ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
        else
            ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override()
            ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override()
        end
    end
end)

ctx.menu.elements.antiaims.force_lag:set_callback(function(self)
    if not self:get() then ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override() ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override() end
end)

function hitchanceoverride(cmd)
    local hc = ui_find("Aimbot", "Ragebot", "Selection", "Hit Chance")

    if not ctx.menu.elements.ragebot.hc_enable:get() then return end

    local me = entity_get_local_player()
    if not me then
        return
    end

    local weap = me:get_player_weapon()
    if weap == nil then return end
    local sniper = weap:get_weapon_index() == 38 or weap:get_weapon_index() == 11 or weap:get_weapon_index() == 9 or weap:get_weapon_index() == 40

    if ctx.menu.elements.ragebot.hc_cond:get("No scope") and not me.m_bIsScoped and sniper then
        hc:override(ctx.menu.elements.ragebot.hc_ns:get())
    end

    if ctx.menu.elements.ragebot.hc_cond:get("Air") and cmd.in_jump and sniper then
        hc:override(ctx.menu.elements.ragebot.hc_air:get())
    end

    if not (ctx.menu.elements.ragebot.hc_cond:get("No scope") and not cmd.in_jump and not me.m_bIsScoped and sniper) and not (ctx.menu.elements.ragebot.hc_cond:get("Air") and cmd.in_jump and sniper) then
    hc:override()
    end
end
events.createmove:set(hitchanceoverride)

--threemarker
local hitlog = new_class()
:struct 'custom_miss_logger' {
    hitlogger =
    (function()
        local b = {callback_registered = false, maximum_count, 8, data = {}}
        function b:register_callback()
        if self.callback_registered then
            return
        end
        events.render:set(function()
                local c = {56, 56, 57}
                local d = 10
                local e = self.data
                for f = #e, 1, -1 do
                    self.data[f].time = self.data[f].time - globals.frametime
                    local g, h = 255, 0
                    local i = e[f]
                    if i.time < 0 then
                        table.remove(self.data, f)
                    else
                        local j = i.def_time - i.time
                        local j = j > 1 and 1 or j
                        local k = 0.48
                        local l = 0
                        if i.time < 0.48 then
                            l = (j < 1 and j or i.time) / 0.48
                        end
                        if j < k then
                            l = (j < 1 and j or i.time) / 0.48
                        end
                        if i.time < 0.48 then
                            h = (j < 1 and j or i.time) / 0.48
                            g = h * 255
                            if h < 0.2 then
                                d = d - 15 * (1.0 - h / 0.2)
                            end
                        end
                        local xui = i.time < 0.48 and -1 or 1
                        i.draw = tostring(i.draw):upper()
                        if i.draw == "" then
                            goto m
                        end

                        if i.shot_pos == nil or render_world_to_screen(i.shot_pos) == nil then
                            return
                        end

                        local sx, sy = render_world_to_screen(i.shot_pos).x, render_world_to_screen(i.shot_pos).y
                        local xyeta = 55 * (g*xui) / 255*xui

                        render_text(2,vector(sx, sy), color(255, 145, 145, g), "", "\aFFFFFFFFx   \aDEFAULT" .. i.draw)
                        d = d + 25
                        ::m::
                    end
                end
                self.callback_registered = true
            end
        )
    end
    function b:paint(p, q, userdata)
        local r = tonumber(p) + 1
        for f = 1, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
            self.data[1] = {time = r, def_time = r, draw = q, shot_pos = userdata}
            self:register_callback()
        end
        return b
    end)()
    }

    :struct 'aim_hit' {
    init = function(self)
        events.aim_ack:set(function(e)
        if e.state == "correction" then
            e.state = "resolver"
        end

        if e.state == "lagcomp failure" then
            e.state = "lagcomp"
        end

        if ctx.menu.elements.visuals.markers:get() and ctx.menu.elements.visuals.miss_marker:get() then
            if e.state ~= nil then
                self.custom_miss_logger.hitlogger:paint(2, e.state, e.aim)
            end
        end
    end)
end
}
hitlog.aim_hit:init()

--hideaa
events.createmove:set(function(cmd)
    if (ctx.menu.elements.antiaims.antiaim_mode:get() == 'Classic Jitter' or ctx.menu.elements.antiaims.antiaim_mode:get() == 'Defensive Preset') and ui_get_alpha() > 0.3 then
        ctx.refs.pitch:override()
        ctx.refs.yaw:override()
        ctx.refs.jyaw:override()
        ctx.refs.jyaw_slider:override()
        ctx.refs.base:override()
        ctx.refs.fake_op:override()
        ctx.refs.left_limit:override()
        ctx.refs.right_limit:override()
        ctx.refs.hidden:override()
    end
end)

--@: sowus - helpers
local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0

events.render:set(function()
    if not ctx.menu.elements.visuals.on_screen:get() or ctx.menu.elements.visuals.select:get() == 'Disable' then

        if not globals.is_in_game then 
            return 
        end

        idc = modify.gradient('M Y T O O L S', color(), color(61, 115, 235, 255))
        render_text(1, vector(25, render_screen_size().y/2), color(), nil, idc .. (ctx.cheat.version == 'Nightly' and ' \aFF7777FF[DEV]' or ' '))
    end
end)

function window(x, y, w, h, name, alpha)
	local name_size = render.measure_text(1, "", name)
	local r, g, b = ctx.menu.elements.visuals.accent_col:get().r, ctx.menu.elements.visuals.accent_col:get().g, ctx.menu.elements.visuals.accent_col:get().b

    if ctx.menu.elements.visuals.solus_widgets:get()  then
        render.rect(vector(x-3, y), vector(x+w+6, y+3+h), color(0, 0, 0, alpha/3), 0)
		render.shadow(vector(x-3, y), vector(x+w+6, y+3+h), color(r, g, b, alpha/1.1), 15, nil, 0)
        render_text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 1 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    end

end

local suc_wm, data_wm = pcall(function() return render.load_image(network.get("https://cdn.discordapp.com/attachments/766390146479685662/1092052169814986843/star-solid.png")) end)

local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec, alpha_s = render_screen_size().x, render_screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1, 0

--@: sowus - keybinds
local new_drag_object3 = drag_system.register({ctx.menu.elements.visuals.pos_x_s, ctx.menu.elements.visuals.pos_y_s}, vector(120, 60), "Test", function(self)
    if ctx.menu.elements.visuals.solus_widgets:get() and ctx.menu.elements.visuals.solus_widgets_s:get('Hotkeys') then

    if not contains(disabled_windows, "Hotkeys") then
        table.insert(disabled_windows, "Hotkeys")
        check_windows()
    end

    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local total_width = 66
    local active_binds = {}

    local binds = ui_get_binds()
    for i = 1, #binds do
            local bind = binds[i]
            local get_mode = binds[i].mode == 1 and 'holding' or (binds[i].mode == 2 and 'toggled') or '[?]'
            local get_value = binds[i].value

            local c_name = binds[i].name
            if c_name == 'Peek Assist' then c_name = 'Quick peek' end
            if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
            if c_name == 'Hide Shots' then c_name = 'Hide shots' end
            if c_name == 'Min. Damage' then c_name = 'Minimum damage' end
            if c_name == 'Fake Latency' then c_name = 'Ping spike' end
            if c_name == 'Fake Duck' then c_name = 'Fake duck' end
            if c_name == 'Safe Points' then c_name = 'Safe point' end
            if c_name == 'Body Aim' then c_name = 'Body aim' end
            if c_name == 'Double Tap' then c_name = 'Double tap' end
            if c_name == 'Yaw Base' then c_name = 'Manual override' end
            if c_name == 'Slow Walk' then c_name = 'Slow motion' end
            if c_name == 'Dormant Aimbot' then c_name = 'Dormant aimbot' end


            local bind_state_size = render.measure_text(1, "", get_mode)
            local bind_name_size = render.measure_text(1, "", c_name)
            if data_k[bind.name] == nil then data_k[bind.name] = {alpha_k = 0} end
            data_k[bind.name].alpha_k = lerp(frametime, data_k[bind.name].alpha_k, (bind.active and 255 or 0))

            render_text(1, vector(self.position.x+3, self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)

            if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                render_text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
            else
                render_text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 23 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
            end

            add_y = add_y + 16 * data_k[bind.name].alpha_k/255

            local width_k = bind_state_size.x + bind_name_size.x + 18
            if width_k > 130-11 then
                if width_k > max_width then
                    max_width = width_k
                end
            end

            if binds.active then
                    table.insert(active_binds, binds)
                end
            end

            alpha_k = lerp(frametime, alpha_k, (ui_get_alpha() > 0 or add_y > 0) and 1 or 0)

            width_ka = lerp(frametime,width_ka, math.max(max_width, 130-11))
            if ui_get_alpha()>0 or add_y > 6 then alphabinds = lerp(frametime, alphabinds, math.max(ui_get_alpha()*255, (add_y > 1 and 255 or 0))) elseif add_y < 15.99 and ui.get_alpha() == 0 then alphabinds = lerp(frametime, alphabinds, 0) end

            if ui_get_alpha() or #active_binds > 0 then
                window(self.position.x, self.position.y, width_ka, 16, 'keybinds', alphabinds)
            end
    end
end)

--@: sowus - spec.list
local suc_fn, data_fn = pcall(function() return render.load_image(network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg")) end)

local new_drag_object4 = drag_system.register({ctx.menu.elements.visuals.pos_x1_s, ctx.menu.elements.visuals.pos_y1_s}, vector(120, 60), "Test2", function(self)
    if ctx.menu.elements.visuals.solus_widgets:get() and ctx.menu.elements.visuals.solus_widgets_s:get('Spectators') then

    if not contains(disabled_windows, "Spectators") then
        table.insert(disabled_windows, "Spectators")
        check_windows()
    end

    local frametime = globals.frametime * 16
    if ui_get_alpha() > 0 then alpha_s = lerp(frametime, alpha_s, math.max(ui_get_alpha()*255, (0 > 1 and 255 or 0))) elseif ui_get_alpha() == 0 then alpha_s = lerp(frametime, alpha_s, 0) end
    window(self.position.x, self.position.y, 120, 16, 'spectators', alpha_s)

    local me = entity_get_local_player()
    if me == nil then return end

    if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        me = me.m_hObserverTarget
    end

    local speclist = me:get_spectators()
    if speclist == nil then return end

    for idx, player_ptr in ipairs(speclist) do
        local name = player_ptr:get_name()
        local tx = render.measure_text(1, '', name).x
        name_sub = string.len(name) > 17 and string.sub(name, 0, 17) .. "..." or name;
        local avatar = player_ptr:get_steam_avatar()
        if (avatar == nil or avatar.width <= 5) then avatar = (suc_fn and data_fn or "") end

        if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
        render_text(1, vector(self.position.x + 17, self.position.y + 8 + (idx*16)), color(), 'u', name_sub)
        render_texture(avatar, vector(self.position.x + 1, self.position.y + 8 + (idx*16)), vector(12, 12), color(), 'f', 0)
        ::skip::
    end

    if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        window(self.position.x, self.position.y, 120, 16, 'spectators', 255)
    end

    end
end)

events.render:set(function()
    new_drag_object3:update()
    new_drag_object4:update()
end)

--nofall
local function trace(length)
    local x, y, z = entity_get_local_player()["m_vecOrigin"].x, entity_get_local_player()["m_vecOrigin"].y, entity_get_local_player()["m_vecOrigin"].z
    local max_radias = math.pi * 2
    local step = max_radias / 8

    for a = 0, max_radias, step do
        local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
        local trace = utils_trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-length), entity_get_local_player())
        local fraction, entity = trace.fraction, trace.entity

        if fraction~=1 then
            return true
        end
    end
    return false
end

events.createmove:set(function(cmd)
    if not ctx.menu.elements.antiaims.antiaims_tweaks:get('No Fall Damage') then return end

    me = entity_get_local_player()

    if me == nil then return end

    if me.m_vecVelocity.z >= -500 then
        no_fall_damage = false
    else
        if trace(15) then
            no_fall_damage = false
        elseif trace(75) then
            no_fall_damage = true
        end
    end

    if me.m_vecVelocity.z < -500 then
        if no_fall_damage then
            cmd.in_duck = 1
        else
            cmd.in_duck = 0
        end
    end
end)

ctx.menu.elements.antiaims.antiaims_tweaks:set_callback(function(self)
    if self:get('Avoid Backstab') then
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override(true)
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override()
    end
end, true)

events.createmove:set(function()
    if ctx.menu.elements.antiaims.freestanding:get() then
        ctx.refs.freestanding_yaw:set(true)
    else
        ctx.refs.freestanding_yaw:set(false)
    end

    local f = ctx.menu.elements.antiaims.manual_aa:get()

    if ctx.menu.elements.antiaims.freestanding:get() and ctx.menu.elements.antiaims.body_freestanding:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override(true)
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override()
    end

    if ctx.menu.elements.antiaims.freestanding:get() and ctx.menu.elements.antiaims.disable_manual:get() then
        if ctx.refs.freestanding_yaw:get() and (f == "Right" or f == "Left" or f == "Forward") then
            ctx.refs.freestanding_yaw:set(false)
        end
    end
end)

events.createmove:set(function()
    if entity_get_local_player() == nil then return end
    local gamerule = entity.get_game_rules()
    local warmup = gamerule["m_bWarmupPeriod"]

    --print(gamerule["m_gamePhase"])

    if ctx.menu.elements.antiaims.antiaims_tweaks:get('Dis. AA on Warmup') and warmup then
        ctx.refs.enable_desync:override(false)
        ctx.refs.yaw:override(math.random(-180, 180))
        ctx.refs.yaw_base:override('Static')
        ctx.refs.pitch:override('Disabled')
    end
end)

local configsData = db.tab_mover or {  }
local menu_tabs = {
    ['Aimbot'] = {
        'Ragebot',
        'Anti Aim'
    },

    ['Visuals'] = {
        'Players',
        'World',
        'Inventory'
    },

    ['Miscellaneous'] = {
        'Main'
    }
}

local contains = function(name, group)
    for n,v in pairs(group) do
        if n == name or v == name then
            return true
        end
    end

    return false
end

local system do
    system = {  }

    system.parse_remote = function(self, url)
        network.get(url, {}, function(content)
            local success, data = pcall(function()
                return json.parse(content)
            end)

            if not success then
                print_error 'url parser error'
                return
            end

            for n,v in pairs(configsData) do

                configsData[n] = v
            end

            return true
        end)
    end

    system.export = function(self, name)
        local name = name or 'Last Config'
        local exportData = {  }

        for tab,refs in pairs(menu_tabs) do
            exportData[tab] = {  }

            for idx,ref in ipairs(refs) do
                local group = ui.find(tab, ref)
                exportData[tab][ref] = group:export()
            end
        end

        exportData = json.stringify({
            config = exportData
        })

        configsData[name] = exportData
        return exportData
    end

    system.import = function(self, data, whitelist)
        local success, data = pcall(function()
            return json.parse(data)
        end)

        if not success then
            print_error 'An error occured: provided config data is outdated'
            return
        end

        for tab,refs in pairs(menu_tabs) do
            local config = data.config[tab]

            if config ~= nil then
                for _,ref in pairs(refs) do
                    if contains(ref, config) and contains(ref, whitelist) then
                        local was_success, group = pcall(function()
                            return ui.find(tab, ref)
                        end)

                        if not was_success then
                            print_error 'An error occured: skipped [%s=>%s] - outdated'
                            goto continue end

                        group:import(data.config[tab][ref])
                    end

                    ::continue::
                end
            end
        end
    end

    system = setmetatable({}, {
        __index = system,
        __metatable = false
    })
end

local menu do
    menu = {  }

    local make_group = function(tab, name, callback)
        local group = ui.create(tab, name)

        callback(menu, group)
    end

    make_group('General', 'Cheat Additionals', function(th, group)
        local show_items = {  }

        for _,ref in pairs(menu_tabs) do

            for _,item in pairs(ref) do
                table.insert(show_items, item)
            end
        end

        th.mover_tabs = group:listable('', show_items)

        th.export_btn = group:button('\a{Link Active}   \aDEFAULTExport Cheat Config', function()
            local config_data = system:export()

            clipboard.set(config_data)


        end, true)

        th.import_btn = group:button('\a{Link Active}   \aDEFAULTImport Cheat Config', function()
            local config_data = clipboard.get()
            local whitelist = {  }

            for _,v in pairs(th.mover_tabs:list()) do
                if th.mover_tabs:get(v) then
                    table.insert(whitelist, v)
                end
            end

            system:import(config_data, whitelist)
        end, true)

        ctx.menu.elements.misc.config_stealer:set_callback(function(self)
            th.mover_tabs:visibility(self:get())
            th.export_btn:visibility(self:get())
            th.import_btn:visibility(self:get())
        end, true)

    end)
end

events.shutdown:set(function()
    db.tab_mover = configsData
end)

ctx.menu.elements.ragebot.aimbot_logging:set_callback(function(self)
    if self:get() then
        ctx.refs.logs:override("")
    else
        ctx.refs.logs:override()
    end
end, true)

ctx.menu.elements.antiaims.antiaim_mode:set_callback(function(self)
    if self:get() == 'Disabled' then

        ctx.menu.elements.antiaims.force_lag:visibility(true)
    elseif self:get() == 'Classic Jitter' then

        ctx.menu.elements.antiaims.force_lag:visibility(true)
    elseif self:get() == 'Defensive Preset' then

        ctx.menu.elements.antiaims.force_lag:visibility(false)
    elseif self:get() == 'Conditional' then

        ctx.menu.elements.antiaims.force_lag:visibility(true)
    end

    ctx.menu.elements.antiaims.tp:visibility(self:get() == 'Classic Jitter' or self:get() == 'Defensive Preset')
    if self:get() ~= 'Defensive Preset' then ui_find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override() ui_find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override() end
end, true)




