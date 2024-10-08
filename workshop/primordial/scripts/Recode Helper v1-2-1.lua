--
-- Script name: Helper
-- Script version: 1.2.1
-- Ported by: Klient#1690
--

--
-- dependencies
--

local http = require "Http"
local weapons = require "CSGO Weapons"
local easing = require "Easing"
local pretty_json = require "Pretty JSON"
local file = require "File System"
local images = require "Images"

local json = require "JSON"
local database = require "Database"
local vector = require "Vector"

--
-- vtable
--

local function vtable_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vtable_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            return vtable_entry(instance, index, t)(instance, ...)
        end
    end
end

local function vtable_bind(module, interface, index, typestring)
    local instance = memory.create_interface(module, interface) or error("invalid interface")
    local fnptr = vtable_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
    return function(...)
        return fnptr(tonumber(ffi.cast("void***", instance)), ...)
    end
end

--
-- client helpers
--

function client.error_log(...)
	return client.log_screen(color_t(255, 0, 0), ...)
end

--
-- table helpers
--

local function table_clear(tbl)
	for key in pairs(tbl) do 
		tbl[key] = nil
	end
end

local function table_contains(tbl, val)
	for i = 1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_map(tbl, callback)
	local new = {}

	for key, value in pairs(tbl) do
		new[key] = callback(value)
	end

	return new
end

local function table_map_assoc(tbl, callback)
	local new = {}

	for key, value in pairs(tbl) do
		local new_key, new_value = callback(key, value)

		new[new_key] = new_value
	end

	return new
end

--
-- file system
--

local function readfile(name)
	name = "Helper\\" .. name

	local file_p = file.open(name, "r", "GAME")

	if (file.exists(name, "GAME")) then
		return file_p:read()
	end

	file_p:close()
end

local function writefile(name, data)
	name = "Helper\\" .. name

	local file_p = file.open(name, "wb", "GAME")
	file_p:write(data)
	file_p:close()
end

--
-- setup helper_data.json
--

if not file.exists("Helper\\helper_data.json") then
	writefile("helper_data.json", "")
end

if not file.exists("Helper\\database.json") then
	writefile("database.json", "{}")
end

--
-- debug mode
--

local DEBUG

--
-- fonts
--

local fonts = {}

fonts.verdana = {}
fonts.verdana.default = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
fonts.verdana.bold = render.create_font("Verdana", 12, 600, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

fonts.small = {}
fonts.small.default = render.create_font("Small Fonts", 9, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)

--
-- constants
--

local SOURCE_TYPE_NAMES = {
	["remote"] = "Remote",
	["local"] = "Local",
	["local_file"] = "Local file"
}

local LOCATION_TYPE_NAMES = {
	grenade = "Grenade",
	wallbang = "Wallbang",
	movement = "Movement"
}

local YAW_DIRECTION_OFFSETS = {
	Forward = 0,
	Back = 180,
	Left = 90,
	Right = -90
}

local MOVEMENT_BUTTONS_CHARS = {
	[e_cmd_buttons.ATTACK] = "A",
	[e_cmd_buttons.JUMP] = "J",
	[e_cmd_buttons.DUCK] = "D",
	[e_cmd_buttons.FORWARD] = "F",
	[e_cmd_buttons.MOVELEFT] = "L",
	[e_cmd_buttons.MOVERIGHT] = "R",
	[e_cmd_buttons.BACK] = "B",
	[e_cmd_buttons.USE] = "U",
	[e_cmd_buttons.ATTACK2] = "Z",
	[e_cmd_buttons.SPEED] = "S"
}

local MOVEMENT_ROTATION_KEYS = {
	e_cmd_buttons.FORWARD,
	e_cmd_buttons.MOVERIGHT,
	e_cmd_buttons.BACK,
	e_cmd_buttons.MOVELEFT
}

local GRENADE_WEAPON_NAMES = setmetatable({
	[weapons.weapon_smokegrenade] = "Smoke",
	[weapons.weapon_flashbang] = "Flashbang",
	[weapons.weapon_hegrenade] = "HE",
	[weapons.weapon_molotov] = "Molotov",
}, {
	__index = function(tbl, key)
		if type(key) == "table" and key.name ~= nil then
			tbl[key] = key.name
			return tbl[key]
		end
	end
})

local GRENADE_WEAPON_NAMES_UI = setmetatable({
	[weapons.weapon_smokegrenade] = "Smoke",
	[weapons.weapon_flashbang] = "Flashbang",
	[weapons.weapon_hegrenade] = "High Explosive",
	[weapons.weapon_molotov] = "Molotov",
}, {
	__index = GRENADE_WEAPON_NAMES
})

local WEAPON_ICONS = setmetatable({}, {
	__index = function(tbl, key)
		if key == nil then
			return
		end

		tbl[key] = images.get_weapon_icon(key)
		return tbl[key]
	end
})

local WEPAON_ICONS_OFFSETS = setmetatable({
	[WEAPON_ICONS["weapon_smokegrenade"]] = {0.2, -0.1, 0.35, 0},
	[WEAPON_ICONS["weapon_hegrenade"]] = {0.1, -0.12, 0.2, 0},
	[WEAPON_ICONS["weapon_molotov"]] = {0, -0.04, 0, 0},
}, {
	__index = function(tbl, key)
		tbl[key] = {0, 0, 0, 0}
		return tbl[key]
	end
})

local WEAPON_ALIASES = {
	[weapons["weapon_incgrenade"]] = weapons["weapon_molotov"],
	[weapons["weapon_firebomb"]] = weapons["weapon_molotov"],
	[weapons["weapon_frag_grenade"]] = weapons["weapon_hegrenade"],
}
for idx, weapon in pairs(weapons) do
	if weapon.type == "knife" then
		WEAPON_ALIASES[weapon] = weapons["weapon_knife"]
	end
end

local vector_index_i, vector_index_lookup = 1, {}
local VECTOR_INDEX = setmetatable({}, {
	__index = function(self, key)
		local id = string.format("%.2f %.2f %.2f", key:unpack())
		local index = vector_index_lookup[id]

		-- first time we met this location
		if index == nil then
			index = vector_index_i
			vector_index_lookup[id] = index
			vector_index_i = index + 1
		end

		self[key] = index
		return index
	end,
	__mode = "k"
})

local DEFAULTS = {
	visibility_offset = vector.new(0, 0, 24),
	fov = 0.7,
	fov_movement = 0.1,
	select_fov_legit = 8,
	select_fov_rage = 25,
	max_dist = 6,
	destroy_text = "Break the object",
	source_ttl = 5
}

local MAX_DIST_ICON = 1500
local MAX_DIST_ICON_SQR = MAX_DIST_ICON*MAX_DIST_ICON
local MAX_DIST_COMBINE_SQR = 20*20
local MAX_DIST_TEXT = 650
local MAX_DIST_CLOSE = 28
local MAX_DIST_CLOSE_DRAW = 15
local MAX_DIST_CORRECT = 0.1
local POSITION_WORLD_OFFSET = vector.new(0, 0, 8)
local POSITION_WORLD_TOP_SIZE = 6
local INF = 1/0
local NULL_VECTOR = vector.new(0, 0, 0)
local FL_ONGROUND = 1
local GRENADE_PLAYBACK_PREPARE, GRENADE_PLAYBACK_RUN, GRENADE_PLAYBACK_THROW, GRENADE_PLAYBACK_THROWN, GRENADE_PLAYBACK_FINISHED = 1, 2, 3, 4, 5

local CLR_TEXT_EDIT = {255, 16, 16}

local approach_accurate_Z_OFFSET = 20
local approach_accurate_PLAYER_RADIUS = 16
local approach_accurate_OFFSETS_START = {
	vector.new(approach_accurate_PLAYER_RADIUS*0.7, 0, approach_accurate_Z_OFFSET),
	vector.new(-approach_accurate_PLAYER_RADIUS*0.7, 0, approach_accurate_Z_OFFSET),
	vector.new(0, approach_accurate_PLAYER_RADIUS*0.7, approach_accurate_Z_OFFSET),
	vector.new(0, -approach_accurate_PLAYER_RADIUS*0.7, approach_accurate_Z_OFFSET),
}
local approach_accurate_OFFSETS_END = {
	vector.new(approach_accurate_PLAYER_RADIUS*2, 0, 0),
	vector.new(0, approach_accurate_PLAYER_RADIUS*2, 0),
	vector.new(-approach_accurate_PLAYER_RADIUS*2, 0, 0),
	vector.new(0, -approach_accurate_PLAYER_RADIUS*2, 0),
}
local POSITION_INACCURATE_OFFSETS = {
	vector.new(0, 0, 0),
	vector.new(8, 0, 0),
	vector.new(-8, 0, 0),
	vector.new(0, 8, 0),
	vector.new(0, -8, 0),
}

--
-- menu helpers
-- cringe
--

local menu_callbacks = {}

function menu.set_callback(item_type, name, item, func, cond)
	callbacks.add(e_callbacks.PAINT, function()
		if cond == nil then
			cond = function()
				return {
					first = true,
					second = true
				}
			end
		end

		if menu_callbacks[name] == nil then
			menu_callbacks[name] = {
				itmes = {}, data = {}, clicked_value = 0
			}
		end

		if item_type == "multi_selection" then
			if item ~= nil then
				local items = item:get_items()

				for key, value in ipairs(items) do
					if menu_callbacks[name].data[value] == nil then
						menu_callbacks[name].data[value] = 0
					end

					if item:get(value) and cond() then
						menu_callbacks[name].data[value] = math.min(#items, menu_callbacks[name].data[value] + 1)
					else
						menu_callbacks[name].data[value] = math.max(0, menu_callbacks[name].data[value] - 1)
					end

					if menu_callbacks[name].data[value] == 2 then
						func()
					end
				end
			end
		elseif item_type == "checkbox" then
			if item:get() and cond().first then
				menu_callbacks[name].clicked_value = math.min(3, menu_callbacks[name].clicked_value + 1)
			elseif not item:get() and cond().second then
				menu_callbacks[name].clicked_value = math.max(0, menu_callbacks[name].clicked_value - 1)
			end

			if menu_callbacks[name].clicked_value == 2 then
				func()
			end
		elseif item_type == "selection" or item_type == "list" or item_type == "slider" then
			local value = item:get()

			if menu_callbacks[name].clicked_value and menu_callbacks[name].clicked_value == value then
				goto skip
			end

			if cond().first then
				func()
			end

			menu_callbacks[name].clicked_value = value
			::skip::	
		end
	end)
end

--
-- debug
--

local benchmark = {
	start_times = {},

	measure = function(name, callback, ...)
		if not DEBUG then return end

		local start = client.get_unix_time()
		local values = {callback(...)}
		client.log_screen(string.format("%s took %fms", name, client.get_unix_time()-start))

		return unpack(values)
	end,

	start = function(self, name)
		if not DEBUG then return end

		if self.start_times[name] ~= nil then
			client.error_log("benchmark: " .. name .. " wasn't finished before starting again")
		end
		self.start_times[name] = client.get_unix_time()
	end,

	finish = function(self, name)
		if not DEBUG then return end

		if self.start_times[name] == nil then
			return
		end

		client.log_screen(string.format("%s took %fms", name, client.get_unix_time()-self.start_times[name]))
		self.start_times[name] = nil
	end
}

--
-- builtin assets
--

local CUSTOM_ICONS = {}

-- bhop icon
CUSTOM_ICONS.bhop = images.load_svg([[
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 158 200" height="200mm" width="158mm">
	<g style="mix-blend-mode:normal">
		<path d="m 27.692726,195.58287 c -2.00307,-2.00307 -2.362731,-5.63696 -1.252001,-12.64982 0.51631,-3.25985 0.938744,-6.15692 0.938744,-6.43794 0,-0.28102 -1.054647,-0.68912 -2.343659,-0.9069 -1.289012,-0.21778 -2.343659,-0.46749 -2.343659,-0.55491 0,-0.0874 0.894568,-2.10761 1.987932,-4.48934 4.178194,-9.10153 7.386702,-22.1671 7.386702,-30.07983 v -3.57114 l -3.439063,-0.65356 c -7.509422,-1.42712 -14.810239,-6.3854 -17.132592,-11.63547 -0.617114,-1.39509 -1.6652612,-5.2594 -2.3292172,-8.58736 -0.894299,-4.48252 -1.742757,-6.93351 -3.273486,-9.45625 -2.296839,-3.78538 -2.316583,-5.11371 -0.151099,-10.165583 0.632785,-1.47622 2.428356,-7.85932 3.990157,-14.18467 2.3650332,-9.578444 3.4874882,-12.902312 6.7157522,-19.887083 5.153317,-11.149867 5.357987,-11.987895 3.936721,-16.118875 -1.318135,-3.831228 -1.056436,-5.345174 1.69769,-9.821193 0.98924,-1.607722 2.121218,-4.129295 2.515508,-5.6035 C 25.28429,28.210324 25.23258,27.949807 23.35135,24.502898 21.710552,21.496527 21.306782,19.993816 20.889474,15.340532 20.614927,12.279129 20.380889,8.4556505 20.369393,6.8439185 l -0.02091,-2.930428 9.333915,0.83216 9.333914,0.832161 0.415652,4.4356115 c 0.228605,2.439587 0.232248,9.481725 0.0081,15.649196 l -0.407561,11.213581 3.401641,0.387936 c 1.8709,0.213363 4.456285,0.528941 5.745297,0.701283 l 2.343658,0.31335 0.01922,-4.58462 c 0.01523,-3.630049 0.300834,-5.120017 1.371678,-7.156027 3.087768,-5.870826 9.893488,-10.61208 17.039741,-11.87087 2.720173,-0.479148 4.160963,-0.409507 7.136663,0.344951 8.66897,2.197927 13.98192,9.621168 13.98192,19.535491 0,3.495649 -0.1404,3.901096 -1.99211,5.752805 -1.24394,1.243942 -2.56423,1.992111 -3.51549,1.992111 -1.49731,0 -1.52337,0.07107 -1.52337,4.153986 v 4.15399 l 8.9352,-0.237138 c 5.2858,-0.140285 11.170779,-0.674802 14.408789,-1.308719 l 5.4736,-1.071577 -0.38275,-2.552314 c -0.37145,-2.476984 -0.33603,-2.552315 1.19984,-2.552315 0.87041,0 1.91062,-0.448636 2.31157,-0.996969 0.68332,-0.93449 1.27483,-0.910186 9.43922,0.387872 4.86768,0.773912 12.32893,1.486871 16.91304,1.616118 4.51154,0.127203 8.93123,0.513358 9.82152,0.858128 2.24255,0.86843 2.71036,3.071333 1.03169,4.858196 -2.36272,2.515004 -4.22494,2.914196 -9.65444,2.069567 -6.49602,-1.010535 -9.48434,-0.608226 -12.89073,1.735433 -1.51944,1.045409 -3.78166,2.037422 -5.02716,2.204478 -2.12756,0.285364 -2.24441,0.404325 -1.93193,1.966706 0.54423,2.721143 -0.2472,4.489222 -3.68173,8.225132 -3.77119,4.102112 -4.63155,5.89093 -5.49449,11.423793 -0.94965,6.08886 -1.57396,7.52473 -5.32281,12.24226 -5.48499,6.90229 -11.865029,11.373083 -16.271159,11.401983 -2.96514,0.0195 -5.44164,-1.427403 -10.64598,-6.219683 -6.09285,-5.61044 -11.509723,-9.58715 -13.059111,-9.58715 -0.74413,0 -2.728788,1.56375 -5.069514,3.99435 -2.115662,2.19689 -4.279795,4.24027 -4.809188,4.54084 -0.873942,0.49619 -0.888303,0.97152 -0.156034,5.16456 0.443574,2.539953 1.213393,5.239093 1.710714,5.998093 1.234397,1.88393 4.464204,3.43033 10.249847,4.90755 11.894956,3.03704 24.227356,12.17082 28.700056,21.25618 3.277059,6.65665 3.756559,14.90456 1.06537,18.32585 -2.00495,2.54888 -4.71703,3.29933 -13.73034,3.79931 -12.02449,0.66702 -11.43259,0.30042 -25.191149,15.60203 -3.539415,3.93635 -4.947788,5.02545 -9.098134,7.03552 -6.030466,2.92066 -8.127669,5.18229 -9.759102,10.52427 -1.407053,4.60727 -3.889283,7.93618 -7.163048,9.60633 -3.066476,1.56439 -5.550268,1.48363 -7.270304,-0.2364 z M 99.119321,71.201503 c 3.729129,-4.724307 6.662059,-8.707839 6.517599,-8.852305 -0.14446,-0.144451 -2.7777,1.571678 -5.851649,3.813635 -4.38891,3.20102 -6.56642,4.363275 -10.1411,5.412849 -2.50365,0.73511 -4.68393,1.459682 -4.84506,1.610152 -0.31664,0.295703 6.47662,6.567603 7.13899,6.591103 0.22054,0.008 3.4521,-3.85113 7.18122,-8.575434 z" style="fill:#ffffff;fill-opacity:1;stroke:none;stroke-width:0.585916;stroke-opacity:1" />
	</g>
</svg>
]])


--
-- utility functions
--

local function get_string(msg, ...)
	local str = ""
	local args = {msg, ...}

	for i = 1, #args do
		str = str .. args[i] .. "\x20"
	end

	return str
end

local function hsv_to_rgb(h, s, v)
	-- Returns the RGB equivalent of the given HSV-defined color
	-- (adapted from some code found around the web)

	-- If it's achromatic, just return the value
	if s == 0 then
		return v, v, v
	end

	h = h / 60

	-- Get the hue sector
	local hue_sector = math.floor(h)
	local hue_sector_offset = h - hue_sector

	local p = v * (1 - s)
	local q = v * (1 - s * hue_sector_offset)
	local t = v * (1 - s * (1 - hue_sector_offset))

	if hue_sector == 0 then
		return v, t, p
	elseif hue_sector == 1 then
		return q, v, p
	elseif hue_sector == 2 then
		return p, v, t
	elseif hue_sector == 3 then
		return p, q, v
	elseif hue_sector == 4 then
		return t, p, v
	elseif hue_sector == 5 then
		return v, p, q
	end
end

local function rgb_to_hsv(r, g, b)
	-- Returns the HSV equivalent of the given RGB-defined color
	-- (adapted from some code found around the web)

	local v = math.max(r, g, b)
	local d = v - math.min(r, g, b)

	if 1 > d then
		return 0, 0, v
	end

	-- if the color is purely black
	if v == 0 then
		return -1, 0, v
	end

	local s = d / v

	local h
	if r == v then
		h = (g - b) / d
	elseif g == v then
		h = 2 + (b - r) / d
	else
		h = 4 + (r - g) / d
	end

	h = h * 60
	if h < 0 then
		h = h + 360
	end

	return h, s, v
end

local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end

local function lerp_color(r1, g1, b1, a1, r2, g2, b2, a2, percentage)
	if percentage == 0 then
		return r1, g1, b1, a1
	elseif percentage == 1 then
		return r2, g2, b2, a2
	end

	local h1, s1, v1 = rgb_to_hsv(r1, g1, b1)
	local h2, s2, v2 = rgb_to_hsv(r2, g2, b2)

	local r, g, b = hsv_to_rgb(lerp(h1, h2, percentage), lerp(s1, s2, percentage), lerp(v1, v2, percentage))
	local a = lerp(a1, a2, percentage)

	return math.floor(r), math.floor(g), math.floor(b), math.floor(a)
end

local function normalize_angles(pitch, yaw)
	if yaw ~= yaw or yaw == INF then
		yaw = 0
		yaw = yaw
	elseif not (yaw > -180 and yaw <= 180) then
		yaw = math.fmod(math.fmod(yaw + 360, 360), 360)
		yaw = yaw > 180 and yaw-360 or yaw
	end

	return math.max(-89, math.min(89, pitch)), yaw
end

local function deep_flatten(tbl, ignore_arr, out, prefix)
	if out == nil then
		out = {}
		prefix = ""
	end

	for key, value in pairs(tbl) do
		if type(value) == "table" and (not ignore_arr or #value == 0) then
			deep_flatten(value, ignore_arr, out, prefix .. key .. ".")
		else
			out[prefix .. key] = value
		end
	end

	return out
end

local function deep_compare(tbl1, tbl2)
	if tbl1 == tbl2 then
		return true
	elseif type(tbl1) == "table" and type(tbl2) == "table" then
		for key1, value1 in pairs(tbl1) do
			local value2 = tbl2[key1]

			if value2 == nil then
				-- avoid the type call for missing keys in tbl2 by directly comparing with nil
				return false
			elseif value1 ~= value2 then
				if type(value1) == "table" and type(value2) == "table" then
					if not deep_compare(value1, value2) then
						return false
					end
				else
					return false
				end
			end
		end

		-- check for missing keys in tbl1
		for key2, _ in pairs(tbl2) do
			if tbl1[key2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

local function vector2_rotate(angle, x, y)
	local sin = math.sin(angle)
	local cos = math.cos(angle)

	local x_n = x * cos - y * sin
	local y_n = x * sin + y * cos

	return x_n, y_n
end

local function vector2_dist(x1, y1, x2, y2)
	local dx = x2-x1
	local dy = y2-y1

	return math.sqrt(dx*dx + dy*dy)
end

local function reset_cvar(cvar)
	local val = tonumber(cvar:get_string())
	cvar:set_int(val)
	cvar:set_float(val)
end

local function triangle_rotated(x, y, width, height, angle, r, g, b, a)
	local a_x, a_y = vector2_rotate(angle, width / 2, 0)
	local b_x, b_y = vector2_rotate(angle, 0, height)
	local c_x, c_y = vector2_rotate(angle, width, height)

	local o_x, o_y = vector2_rotate(angle, -width / 2, -height / 2)
	x, y = x + o_x, y + o_y

	render.polygon({vec2_t(x + a_x, y + a_y), vec2_t(x + b_x, y + b_y), vec2_t(x + c_x, y + c_y)}, color_t(r, g, b, a))
end

local function randomid(size)
	local str = ""
	for i=1, (size or 32) do
		str = str .. string.char(client.random_int(97, 122))
	end
	return str
end

local crc32_lt = {}
local function crc32(s, lt)
	-- return crc32 checksum of string as an integer
	-- use lookup table lt if provided or create one on the fly
	-- if lt is empty, it is initialized.
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

	-- compute the crc
	crc = 0xffffffff
	for i = 1, #s do
		b = string.byte(s, i)
		crc = bit.bxor(bit.rshift(crc, 8), lt[bit.band(bit.bxor(crc, b), 0xFF) + 1])
	end
	return bit.band(bit.bnot(crc), 0xffffffff)
end

local function format_duration(secs, ignore_seconds, max_parts)
	local units, dur, part = {"day", "hour", "minute"}, "", 1
	max_parts = max_parts or 4

	for i, v in ipairs({86400, 3600, 60}) do
		if part > max_parts then
			break
		end

		if secs >= v then
			dur = dur .. math.floor(secs / v) .. " " .. units[i] .. (math.floor(secs / v) > 1 and "s" or "") .. ", "
			secs = secs % v
			part = part + 1
		end
	end

	if secs == 0 or ignore_seconds or part > max_parts then
		return dur:sub(1, -3)
	else
		secs = math.floor(secs)
		return dur .. secs .. (secs > 1 and " seconds" or " second")
	end
end

local function console_log_json(str)
end

local function is_grenade_being_thrown(weapon, cmd)
	local pin_pulled = weapon:get_prop("m_bPinPulled")

	if pin_pulled ~= nil then
		if pin_pulled == 0 or cmd:has_button(e_cmd_buttons.ATTACK) or cmd:has_button(e_cmd_buttons.ATTACK2) then
			local throw_time = weapon:get_prop("m_fThrowTime")
			if throw_time ~= nil and throw_time > 0 and throw_time < global_vars.cur_time()+1 then
				return true
			end
		end
	end
	return false
end

local function trace_line_debug(entindex_skip, sx, sy, sz, tx, ty, tz)
	-- print(string.format("called trace_line with source=%s %s %s, target=%s %s %s", sx, sy, sz, tx, ty, tz))
	entindex_skip = type(entindex_skip) == "number" and entity_list.get_entity(entindex_skip) or entindex_skip

	return trace.line(vec3_t(sx, sy, sz), vec3_t(tx, ty, tz), entindex_skip)
end

local function trace_line_skip_entities(start, target, max_traces)
	max_traces = max_traces or 10
	local fraction, entindex_hit = 0, -1
	local hit = start

	local i = 0
	while max_traces >= i and fraction < 1 and (entindex_hit > -1 or i == 0) do
		local hx, hy, hz = hit:unpack()
		local traced_line = trace.line(vec3_t(hx, hy, hz), vec3_t(target:unpack()),  entity_list.get_entity(entindex_hit))

		fraction, entindex_hit = traced_line.fraction, traced_line.entity == nil and -1 or traced_line.entity:get_index()

		hit = hit:lerp(target, fraction)
		i = i + 1
	end

	fraction = start:dist_to(hit) / start:dist_to(target)

	return fraction, entindex_hit, hit
end

local native_GetWorldToScreenMatrix = vtable_bind("engine.dll", "VEngineClient014", 37, "struct {float m[4][4];}&(__thiscall*)(void*)")

local function render_world_to_screen(w_x, w_y, w_z)
	local w2sMatrix = native_GetWorldToScreenMatrix()

    local x = w2sMatrix.m[0][0] * w_x + w2sMatrix.m[0][1] * w_y + w2sMatrix.m[0][2] * w_z + w2sMatrix.m[0][3]
    local y = w2sMatrix.m[1][0] * w_x + w2sMatrix.m[1][1] * w_y + w2sMatrix.m[1][2] * w_z + w2sMatrix.m[1][3]
    local z = 0.0

    local w = w2sMatrix.m[3][0] * w_x + w2sMatrix.m[3][1] * w_y + w2sMatrix.m[3][2] * w_z + w2sMatrix.m[3][3]

    if (w < 0.001) then
        x = x * 100000
        y = y * 100000

        return 0, 0
    end

    x = x / w
    y = y / w

    local screen = render.get_screen_size()

    x = (screen.x / 2.0) + (x * screen.x) / 2.0
    y = (screen.y / 2.0) - (y * screen.y) / 2.0

    return x, y
end

local function world_to_screen_offscreen(x, y, z, matrix, screen_width, screen_height)
	matrix = matrix or native_GetWorldToScreenMatrix()

	local wx = matrix.m[0][0] * x + matrix.m[0][1] * y + matrix.m[0][2] * z + matrix.m[0][3]
	local wy = matrix.m[1][0] * x + matrix.m[1][1] * y + matrix.m[1][2] * z + matrix.m[1][3]
	local ww = matrix.m[3][0] * x + matrix.m[3][1] * y + matrix.m[3][2] * z + matrix.m[3][3]

	local in_front
	if ww < 0.001 then
		local invw = -1.0 / ww
		in_front = false
		wx = wx * invw
		wy = wy * invw
	else
		local invw = 1.0 / ww
		in_front = true
		wx = wx * invw
		wy = wy * invw
	end

	if type(wx) ~= "number" or type(wy) ~= "number" then
	  return
	end

	if screen_width == nil then
		screen_width, screen_height = render.get_screen_size().x, render.get_screen_size().y
	end

	wx = screen_width / 2 + (0.5 * wx * screen_width + 0.5)
	wy = screen_height / 2 - (0.5 * wy * screen_height + 0.5)

	return wx, wy, in_front, ww
end

local function world_to_screen_offscreen_circle(x, y, z, matrix, screen_width, screen_height, cd)
	local wx, wy, in_front = world_to_screen_offscreen(x, y, z, matrix, screen_width, screen_height)

	if wx == nil then
		return
	end

	if cd > wx or wx > screen_width-cd or cd > wy or wy > screen_height-cd or not in_front then
		local cx, cy = screen_width/2, screen_height/2

		local angle = math.atan2(wy-cy, wx-cx)

		local radius = math.min(screen_width, screen_height) / 2 - cd
		local wx_n = cx + radius * math.cos(angle)
		local wy_n = cy + radius * math.sin(angle)

		return wx_n, wy_n, true
	else
		return wx, wy, false
	end
end

local function line_intersection(a_s_x, a_s_y, a_e_x, a_e_y, b_s_x, b_s_y, b_e_x, b_e_y)
	local d = (a_s_x - a_e_x) * (b_s_y - b_e_y) - (a_s_y - a_e_y) * (b_s_x - b_e_x)
	local a = a_s_x * a_e_y - a_s_y * a_e_x
	local b = b_s_x * b_e_y - b_s_y * b_e_x
	local x = (a * (b_s_x - b_e_x) - (a_s_x - a_e_x) * b) / d
	local y = (a * (b_s_y - b_e_y) - (a_s_y - a_e_y) * b) / d
	return x, y
end

local function world_to_screen_offscreen_rect(x, y, z, matrix, screen_width, screen_height, cd)
	local wx, wy, in_front = world_to_screen_offscreen(x, y, z, matrix, screen_width, screen_height)

	if wx == nil then
		return
	end

	if not in_front or cd > wx or wx > screen_width-cd or cd > wy or wy > screen_height-cd then
		local cx, cy = screen_width/2, screen_height/2
		if not in_front then
			local angle = math.atan2(wy-cy, wx-cx)
			local radius = math.max(screen_width, screen_height)
			wx = cx + radius * math.cos(angle)
			wy = cy + radius * math.sin(angle)
		end

		local border_vectors = {
			cd, cd, screen_width-cd, cd,
			screen_width-cd, cd, screen_width-cd, screen_height-cd,
			cd, cd, cd, screen_height-cd,
			cd, screen_height-cd, screen_width-cd, screen_height-cd
		}

		for i=1, #border_vectors, 4 do
			local s_x, s_y, e_x, e_y = border_vectors[i], border_vectors[i+1], border_vectors[i+2], border_vectors[i+3]
			local i_x, i_y = line_intersection(s_x, s_y, e_x, e_y, cx, cy, wx, wy)

			if (i == 1 and wy < cd and i_x >= cd and i_x <= screen_width-cd) or
				 (i == 5 and wx > screen_width-cd and i_y >= cd and i_y <= screen_height-cd) or
				 (i == 9 and wx < cd and i_y >= cd and i_y <= screen_height-cd) or
				 (i == 13 and wy > screen_height-cd and i_x >= cd and i_x <= screen_width-cd) then
				return i_x, i_y, false
			end
		end

		return wx, wy, false
	end

	return wx, wy, true
end

local MOVEMENT_BUTTONS_CHARS_INV = table_map_assoc(MOVEMENT_BUTTONS_CHARS, function(k, v) return v, k end)

local function parse_buttons_str(str)
	local buttons_down, buttons_up = {}, {}

	for c in str:gmatch(".") do
		if c:lower() == c then
			table.insert(buttons_up, MOVEMENT_BUTTONS_CHARS_INV[c:upper()] or false)
		else
			table.insert(buttons_down, MOVEMENT_BUTTONS_CHARS_INV[c] or false)
		end
	end

	return buttons_down, buttons_up
end

local function sanitize_string(str)
	str = tostring(str)
	str = str:gsub('[%c]', '')

	return str
end

local js_api = {
	get_timestamp = function()
		return client.get_unix_time()
	end,

	format_timestamp = function(timestamp)
	    local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(timestamp/86400)

	    while days >= day_count(year) do
	        days = days - day_count(year) year = year + 1
	    end

	    local tab_overflow = function(seed, table) 
	    	for i = 1, #table do 
	    		if seed - table[i] <= 0 then 
	    			return i, seed 
	    		end 

	    		seed = seed - table[i] 
	    	end 
	    end

	    month, days = tab_overflow(days, {31, (day_count(year) == 366 and 29 or 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31})

	    local hours, minutes, seconds = math.floor(timestamp / 3600 % 24), math.floor(timestamp / 60 % 60), math.floor(timestamp % 60)
	    local period = hours > 12 and "pm" or "am"

	    return string.format("%d/%d/%04d %02d:%02d", days, month, year, hours, minutes)
	end
}

local format_timestamp = setmetatable({}, {
	__index = function(tbl, ts)
		tbl[ts] = js_api.format_timestamp(ts)
		return tbl[ts]
	end
})

local realtime_offset = js_api.get_timestamp() - global_vars.real_time()

local function get_unix_timestamp()
	return global_vars.real_time() + realtime_offset
end

local function format_unix_timestamp(timestamp, allow_future, ignore_seconds, max_parts)
	local secs = timestamp - get_unix_timestamp()

	if secs < 0 or allow_future then
		local duration = format_duration(math.abs(secs), ignore_seconds, max_parts)
		return secs > 0 and ("In " .. duration) or (duration .. " ago")
	else
		return format_timestamp[timestamp]
	end
end

local native_GetClipboardTextCount = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

local new_char_arr = ffi.typeof("char[?]")

function get_clipboard_text()
	local len = native_GetClipboardTextCount()
	if len > 0 then
		local char_arr = new_char_arr(len)
		native_GetClipboardText(0, char_arr, len)
		return ffi.string(char_arr, len-1)
	end
end

function set_clipboard_text(text)
	native_SetClipboardText(text, text:len())
end

--
-- movement compression algorithm
--

local function calculate_move(btn1, btn2)
	return btn1 and 450 or (btn2 and -450 or 0)
end

local function compress_usercmds(usercmds)
	local frames = {}

	local current = {
		viewangles = {pitch=usercmds[1].pitch, yaw=usercmds[1].yaw},
		buttons = {}
	}

	-- initialize all buttons as false
	for key, char in pairs(MOVEMENT_BUTTONS_CHARS) do
		current.buttons[key] = false
	end

	local empty_count = 0
	for i, cmd in ipairs(usercmds) do
		local buttons = ""

		for btn, value_prev in pairs(current.buttons) do
			if cmd[btn] and not value_prev then
				buttons = buttons .. MOVEMENT_BUTTONS_CHARS[btn]
			elseif not cmd[btn] and value_prev then
				buttons = buttons .. MOVEMENT_BUTTONS_CHARS[btn]:lower()
			end
			current.buttons[btn] = cmd[btn]
		end

		local frame = {cmd.pitch-current.viewangles.pitch, cmd.yaw-current.viewangles.yaw, buttons, cmd.forwardmove, cmd.sidemove}
		current.viewangles = {pitch=cmd.pitch, yaw=cmd.yaw}

		if frame[#frame] == calculate_move(cmd[e_cmd_buttons.MOVERIGHT], cmd[e_cmd_buttons.MOVELEFT]) then
			frame[#frame] = nil

			if frame[#frame] == calculate_move(cmd[e_cmd_buttons.FORWARD], cmd[e_cmd_buttons.BACK]) then
				frame[#frame] = nil

				if frame[#frame] == "" then
					frame[#frame] = nil

					if frame[#frame] == 0 then
						frame[#frame] = nil

						if frame[#frame] == 0 then
							frame[#frame] = nil
						end
					end
				end
			end
		end

		if #frame > 0 then
			-- first frame after a bunch of empty frames
			if empty_count > 0 then
				table.insert(frames, empty_count)
				empty_count = 0
			end

			-- insert frame normally
			table.insert(frames, frame)
		else
			empty_count = empty_count + 1
		end
	end

	if empty_count > 0 then
		table.insert(frames, empty_count)
		empty_count = 0
	end

	return frames
end

--
-- map patterns section
-- used if the map name doesnt correspond to any known name
--

local function get_map_pattern()
	local world = entity_list.get_entity(0)

	local mins = world:get_prop("m_WorldMins")
	local maxs = world:get_prop("m_WorldMaxs")

	local str
	if mins ~= NULL_VECTOR or maxs ~= NULL_VECTOR then
		str = string.format("bomb_%.2f_%.2f_%.2f %.2f_%.2f_%.2f", mins.x, mins.y, mins.z, maxs.x, maxs.y, maxs.z)
	end

	if str ~= nil then
		return crc32(str)
	end

	return nil
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
	[-923663825]  = "dz_frostbite",
	[-768791216]  = "de_dust2",
	[-692592072]  = "cs_italy",
	[-542128589]  = "ar_monastery",
	[-222265935]  = "ar_baggage",
	[-182586077]  = "de_aztec",
	[371013699]   = "de_stmarc",
	[405708653]   = "de_overpass",
	[549370830]   = "de_lake",
	[790893427]   = "dz_sirocco",
	[792319475]   = "de_ancient",
	[878725495]   = "de_bank",
	[899765791]   = "de_safehouse",
	[1014664118]  = "cs_office",
	[1238495690]  = "ar_dizzy",
	[1364328969]  = "cs_militia",
	[1445192006]  = "de_engage",
	[1463756432]  = "cs_assault",
	[1476824995]  = "de_vertigo",
	[1507960924]  = "cs_agency",
	[1563115098]  = "de_nuke",
	[1722587796]  = "de_dust2_old",
	[1850283081]  = "de_anubis",
	[1900771637]  = "de_cache",
	[1964982021]  = "de_elysion",
	[2041417734]  = "de_cbble",
	[2056138930]  = "gd_rialto",
}

local MAP_LOOKUP = {
	de_shortnuke = "de_nuke",
	de_shortdust = "de_shortnuke",
	["workshop/533515529/bot_aimtrain_textured_v1"] = "bot_aimtrain_textured_v1 "
}

local mapname_cache = {}
local function get_mapname()
	local mapname_raw = engine.get_level_name_short()

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
				local pattern = get_map_pattern()

				if MAP_PATTERNS[pattern] ~= nil then
					mapname = MAP_PATTERNS[pattern]
				end
			end
		end

		mapname_cache[mapname_raw] = mapname
	end

	return mapname_cache[mapname_raw]
end

if DEBUG then
	menu.add_text("Helper Debug", "Helper: Debug")
	menu.add_button("Helper Debug", "Create helper map patterns", function()
		local maps = {
			"de_cache",
			"de_mirage",
			"de_dust2",
			"de_inferno",
			"de_overpass",
			"de_canals",
			"de_train",
			"cs_office",
			"cs_agency",
			"de_vertigo",
			"de_lake",
			"de_nuke",
			"de_safehouse",
			"dz_blacksite",
			"cs_assault",
			"ar_monastery",
			"de_cbble",
			"cs_italy",
			"cs_militia",
			"de_stmarc",
			"ar_baggage",
			"ar_shoots",
			"de_sugarcane",
			"ar_dizzy",
			"de_dust",
			"de_bank",

			-- popular removed maps (old / operation)
			"de_tulip",
			"de_aztec",
			"gd_rialto",
			"de_dust2_old",

			-- shattered web or after
			"dz_sirocco",
			"de_anubis",

			-- operation broken fang maps
			"cs_apollo",
			"de_ancient",
			"de_elysion",
			"de_engage",
			"dz_frostbite",
			"de_guard"
		}

		MAP_PATTERNS = {}

		DEBUG.create_map_patterns_count = #maps
		DEBUG.create_map_patterns_next = {}
		DEBUG.create_map_patterns_index = {}
		DEBUG.create_map_patterns_failed = {}
		for i=1, #maps do
			local map = maps[i]
			if DEBUG.create_map_patterns_next[map] ~= nil then
				error("Duplicate map " .. map)
			end
			DEBUG.create_map_patterns_next[map] = maps[i+1]
			DEBUG.create_map_patterns_index[map] = i
		end

		DEBUG.create_map_patterns = true
		DEBUG.debug_text = "create_map_patterns progress: " .. 1 .. " / " .. DEBUG.create_map_patterns_count
		client.delay_call(function()
			engine.execute_cmd("map " .. maps[1])
		end, 0.5)
	end)
end

--
-- database initialization
--

benchmark:start("db_read")
local db = database.read("helper_db") or {}
db.sources = db.sources or {}
benchmark:finish("db_read")

-- setup default sources
local default_sources = {
	{
		name = "Built-in (Legit)",
		id = "builtin_legit",
		type = "remote",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/builtin_legit.json",
		description = "Built-in legit grenades",
		builtin = true
	},
	{
		name = "SoThatWeMayBeFree",
		id = "builtin_sothatwemaybefree",
		type = "remote",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/sothatwemaybefree.json",
		description = "Grenades from sothatwemaybefree",
		builtin = true
	},
	{
		name = "Built-in (Movement)",
		id = "builtin_movement",
		type = "remote",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/builtin_movement.json",
		description = "Movement locations for popular maps",
		builtin = true
	},
	{
		name = "sigma's HvH locations",
		id = "sigma_hvh",
		type = "remote",
		url = "https://pastebin.com/raw/ewHvQ2tD",
		description = "Revolutionizing spread HvH",
		builtin = true
	}
}

-- first remove all default sources and some old ones
local removed_sources = {
	builtin_local_file = true,
	builtin_hvh = true
}

-- add default sources to remove list
for i=1, #default_sources do
	removed_sources[default_sources[i].id] = true
end

-- remove sources
for i=#db.sources, 1, -1 do
	local source = db.sources[i]

	if source ~= nil and removed_sources[source.id] then
		table.remove(db.sources, i)
	end
end

-- re-add default sources in correct order
for i=1, #default_sources do
	if db.sources[i] == nil or db.sources[i].id ~= default_sources[i].id then
		table.insert(db.sources, i, default_sources[i])
	end
end

if readfile("helper_data.json") then
	table.insert(db.sources, {
		name = "helper_data.json",
		id = "builtin_local_file",
		type = "local_file",
		filename = "helper_data.json",
		description = "Local file",
		builtin = true
	})

	local store_db = (database.read("helper_store") or {})
	store_db.locations = store_db.locations or {}
	store_db.locations["builtin_local_file"] = {}
end

-- table of: source -> map name -> locations
local sources_locations = {}

-- forward declare the ui update func
local update_sources_ui, edit_set_ui_values

-- forward declare runtime map locations
local map_locations, active_locations = {}

local function flush_active_locations(reason)
	active_locations = nil
	table_clear(map_locations)
	-- print("flush_active_locations(", reason, ")")
end

local tickrates_mt = {
	__index = function(tbl, key)
		if tbl.tickrate ~= nil then
			return key / tbl.tickrate
		end
	end
}

local location_mt = {
	__index = {
		get_type_string = function(self)
			if self.type == "grenade" then
				local names = table_map(self.weapons, function(weapon) return GRENADE_WEAPON_NAMES[weapon] end)
				return table.concat(names, "/")
			else
				return LOCATION_TYPE_NAMES[self.type] or self.type
			end
		end,
		get_export_tbl = function(self)
			local tbl = {
				name = (self.name == self.full_name) and self.name or {self.full_name:match("^(.*) to (.*)$")},
				description = self.description,
				weapon = #self.weapons == 1 and self.weapons[1].console_name or table_map(self.weapons, function(weapon) return weapon.console_name end),
				position = {self.position.x, self.position.y, self.position.z},
				viewangles = {self.viewangles.pitch, self.viewangles.yaw},
			}

			if getmetatable(self.tickrates) == tickrates_mt then
				if self.tickrates.tickrate_set then
					tbl.tickrate = self.tickrates.tickrate
				end
			elseif self.tickrates.orig ~= nil then
				tbl.tickrate = self.tickrates.orig
			end

			if self.approach_accurate ~= nil then
				tbl.approach_accurate = self.approach_accurate
			end

			if self.duckamount ~= 0 then
				tbl.duck = self.duckamount == 1 and true or self.duckamount
			end

			if self.position_visibility_different then
				tbl.position_visibility = {
					self.position_visibility.x-self.position.x,
					self.position_visibility.y-self.position.y,
					self.position_visibility.z-self.position.z
				}
			end

			if self.type == "grenade" then
				tbl.grenade = {
					fov = self.fov ~= DEFAULTS.fov and self.fov or nil,
					jump = self.jump and true or nil,
					strength = self.throw_strength ~= 1 and self.throw_strength or nil,
					run = self.run_duration ~= nil and self.run_duration or nil,
					run_yaw = self.run_yaw ~= self.viewangles.yaw and self.run_yaw-self.viewangles.yaw or nil,
					run_speed = self.run_speed ~= nil and self.run_speed or nil,
					recovery_yaw = self.recovery_yaw ~= nil and self.recovery_yaw-self.run_yaw or nil,
					recovery_jump = self.recovery_jump and true or nil,
					delay = self.delay > 0 and self.delay or nil
				}

				if next(tbl.grenade) == nil then
					tbl.grenade = nil
				end
			elseif self.type == "movement" then
				local frames = {}
				tbl.movement = {
					frames = compress_usercmds(self.movement_commands)
				}
			end

			if self.destroy_text ~= nil then
				tbl.destroy = {
					["start"] = self.destroy_start and {self.destroy_start:unpack()} or nil,
					["end"] = {self.destroy_end:unpack()},
					["text"] = self.destroy_text ~= DEFAULTS.destroy_text and self.destroy_text or nil,
				}
			end

			return tbl
		end,
		get_export = function(self, fancy)
			local tbl = self:get_export_tbl()
			local indent = "  "

			local json_str
			if fancy then
				local default_keys, default_fancy, seen = {"name", "description", "weapon", "position", "viewangles", "position_visibility", "grenade"}, {["grenade"] = 1}, {}
				local result = {}

				for i=1, #default_keys do
					local key = default_keys[i]
					local value = tbl[key]
					if value ~= nil then
						local str = default_fancy[key] == 1 and pretty_json.stringify(value, "\n", indent) or json.encode(value)

						if type(value[1]) == "number" and type(value[2]) == "number" and (value[3] == nil or type(value[3]) == "number") then
							str = str:gsub(",", ", ")
						else
							str = str:gsub("\",\"", "\", \"")
						end

						table.insert(result, string.format("\"%s\": %s", key, str))
						tbl[key] = nil
					end
				end

				for key, value in pairs(tbl) do
					table.insert(result, string.format("\"%s\": %s", key, pretty_json.stringify(tbl[key], "\n", indent)))
				end

				json_str = "{\n" .. indent .. table.concat(result, ",\n"):gsub("\n", "\n" .. indent) .. "\n}"
			else
				json_str = json.encode(tbl)
			end

			-- print("json_str: ", json_str:sub(0, 500))

			return json_str
		end
	}
}

local function create_location(location_parsed)
	if type(location_parsed) ~= "table" then
		return "wrong type, expected table"
	end

	if getmetatable(location_parsed) == location_mt then
		return "trying to create an already created location"
	end

	local location = {}

	if type(location_parsed.name) == "string" and location_parsed.name:len() > 0 then
		location.name = sanitize_string(location_parsed.name)
		location.full_name = location.name
	elseif type(location_parsed.name) == "table" and #location_parsed.name == 2 then
		location.name = sanitize_string(location_parsed.name[2])
		location.full_name = sanitize_string(string.format("%s to %s", location_parsed.name[1], location_parsed.name[2]))
	else
		-- print(DEBUG.inspect(location.name))
		return "invalid name, expected string or table of length 2"
	end

	if type(location_parsed.description) == "string" and location_parsed.description:len() > 0 then
		location.description = location_parsed.description
	elseif location_parsed.description ~= nil then
		return "invalid description, expected nil or non-empty string"
	end

	if type(location_parsed.weapon) == "string" and weapons[location_parsed.weapon] ~= nil then
		location.weapons = {weapons[location_parsed.weapon]}
		location.weapons_assoc = {[weapons[location_parsed.weapon]] = true}
	elseif type(location_parsed.weapon) == "table" and #location_parsed.weapon > 0 then
		location.weapons = {}
		location.weapons_assoc = {}

		for i=1, #location_parsed.weapon do
			local weapon = weapons[location_parsed.weapon[i]]
			if weapon ~= nil then
				if location.weapons_assoc[weapon] then
					return "duplicate weapon: " .. location_parsed.weapon[i]
				else
					location.weapons[i] = weapon
					location.weapons_assoc[weapon] = true
				end
			else
				return "invalid weapon: " .. location_parsed.weapon[i]
			end
		end
	else
		return string.format("invalid weapon (%s)", tostring(location_parsed.weapon))
	end

	if type(location_parsed.position) == "table" and #location_parsed.position == 3 then
		local x, y, z = unpack(location_parsed.position)

		if type(x) == "number" and type(y) == "number" and type(z) == "number" then
			location.position = vector.new(x, y, z)
			location.position_visibility = location.position + DEFAULTS.visibility_offset
			location.position_id = VECTOR_INDEX[location.position]
		else
			return "invalid type in position"
		end
	else
		return "invalid position"
	end

	if type(location_parsed.position_visibility) == "table" and #location_parsed.position_visibility == 3 then
		local x, y, z = unpack(location_parsed.position_visibility)

		if type(x) == "number" and type(y) == "number" and type(z) == "number" then
			local origin = location.position
			location.position_visibility = vector.new(origin.x+x, origin.y+y, origin.z+z)
			location.position_visibility_different = true
		else
			return "invalid type in position_visibility"
		end
	elseif location_parsed.position_visibility ~= nil then
		return "invalid position_visibility"
	end

	if type(location_parsed.viewangles) == "table" and #location_parsed.viewangles == 2 then
		local pitch, yaw = unpack(location_parsed.viewangles)

		if type(pitch) == "number" and type(yaw) == "number" then
			location.viewangles = {
				pitch = pitch,
				yaw = yaw
			}
			location.viewangles_forward = vector.new():init_from_angles(pitch, yaw)
		else
			return "invalid type in viewangles"
		end
	else
		return "invalid viewangles"
	end

	if type(location_parsed.approach_accurate) == "boolean" then
		location.approach_accurate = location_parsed.approach_accurate
	elseif location_parsed.approach_accurate ~= nil then
		return "invalid approach_accurate"
	end

	if location_parsed.duck == nil or type(location_parsed.duck) == "boolean" then
		location.duckamount = location_parsed.duck and 1 or 0
	else
		return string.format("invalid duck value (%s)", tostring(location_parsed.duck))
	end
	location.eye_pos = location.position + vector.new(0, 0, 64-location.duckamount*18)

	-- tickrates key is the real tickrate and value is the multiplier for duration etc
	if (type(location_parsed.tickrate) == "number" and location_parsed.tickrate > 0) or location_parsed.tickrate == nil then
		location.tickrates = setmetatable({
			tickrate = location_parsed.tickrate or 64,
			tickrate_set = location_parsed.tickrate ~= nil
		}, tickrates_mt)
	elseif type(location_parsed.tickrate) == "table" and #location_parsed.tickrate > 0 then
		location.tickrates = {
			orig = location_parsed.tickrate
		}

		local orig_tickrate

		for i=1, #location_parsed.tickrate do
			local tickrate = location_parsed.tickrate[i]
			if type(tickrate) == "number" and tickrate > 0 then
				if orig_tickrate == nil then
					orig_tickrate = tickrate
					location.tickrates[tickrate] = 1
				else
					location.tickrates[tickrate] = orig_tickrate/tickrate
				end
			else
				return "invalid tickrate: " .. tostring(location_parsed.tickrate[i])
			end
		end
	else
		return string.format("invalid tickrate (%s)", tostring(location_parsed.tickrate))
	end

	if type(location_parsed.target) == "table" then
		local x, y, z = unpack(location_parsed.target)

		if type(x) == "number" and type(y) == "number" and type(z) == "number" then
			location.target = vector.new(x, y, z)
		else
			return "invalid type in target"
		end
	elseif location_parsed.target ~= nil then
		return "invalid target"
	end

	-- ensure they're all a grenade or none a grenade, then determine type
	local has_grenade, has_non_grenade
	for i=1, #location.weapons do
		if location.weapons[i].type == "grenade" then
			has_grenade = true
		else
			has_non_grenade = true
		end
	end

	if has_grenade and has_non_grenade then
		return "can't have grenade and non-grenade in one location"
	end

	if location_parsed.movement ~= nil then
		location.type = "movement"
		location.fov = DEFAULTS.fov_movement
	elseif has_grenade then
		location.type = "grenade"
		location.throw_strength = 1
		location.fov = DEFAULTS.fov
		location.delay = 0
		location.jump = false
		location.run_yaw = location.viewangles.yaw
	elseif has_non_grenade then
		location.type = "wallbang"
	else
		return "invalid type"
	end

	if location.viewangles_forward ~= nil and location.eye_pos ~= nil then
		local viewangles_target = location.eye_pos + location.viewangles_forward * 700
		local fraction, entindex_hit, vec_hit = trace_line_skip_entities(location.eye_pos, viewangles_target, 2)
		location.viewangles_target = fraction > 0.05 and vec_hit or viewangles_target
	end

	if location.type == "grenade" and type(location_parsed.grenade) == "table" then
		local grenade = location_parsed.grenade
		-- location.throw_strength = 1
		-- location.fov = 0.3
		-- location.jump = false
		-- location.run = false
		-- location.run_yaw = 0

		if type(grenade.strength) == "number" and grenade.strength >= 0 and grenade.strength <= 1 then
			location.throw_strength = grenade.strength
		elseif grenade.strength ~= nil then
			return string.format("invalid grenade.strength (%s)", tostring(grenade.strength))
		end

		if type(grenade.delay) == "number" and grenade.delay > 0 then
			location.delay = grenade.delay
		elseif grenade.delay ~= nil then
			return string.format("invalid grenade.delay (%s)", tostring(grenade.delay))
		end

		if type(grenade.fov) == "number" and grenade.fov >= 0 and grenade.fov <= 180 then
			location.fov = grenade.fov
		elseif grenade.fov ~= nil then
			return string.format("invalid grenade.fov (%s)", tostring(grenade.fov))
		end

		if type(grenade.jump) == "boolean" then
			location.jump = grenade.jump
		elseif grenade.jump ~= nil then
			return string.format("invalid grenade.jump (%s)", tostring(grenade.jump))
		end

		if type(grenade.run) == "number" and grenade.run > 0 and grenade.run < 512 then
			location.run_duration = grenade.run
		elseif grenade.run ~= nil then
			return string.format("invalid grenade.run (%s)", tostring(grenade.run))
		end

		if type(grenade.run_yaw) == "number" and grenade.run_yaw >= -180 and grenade.run_yaw <= 180 then
			location.run_yaw = location.viewangles.yaw + grenade.run_yaw
		elseif grenade.run_yaw ~= nil then
			return string.format("invalid grenade.run_yaw (%s)", tostring(grenade.run_yaw))
		end

		if type(grenade.run_speed) == "boolean" then
			location.run_speed = grenade.run_speed
		elseif grenade.run_speed ~= nil then
			return "invalid grenade.run_speed"
		end

		if type(grenade.recovery_yaw) == "number" then
			location.recovery_yaw = location.run_yaw + grenade.recovery_yaw
		elseif grenade.recovery_yaw ~= nil then
			return "invalid grenade.recovery_yaw"
		end

		if type(grenade.recovery_jump) == "boolean" then
			location.recovery_jump = grenade.recovery_jump
		elseif grenade.recovery_jump ~= nil then
			return "invalid grenade.recovery_jump"
		end
	elseif location_parsed.grenade ~= nil then
		-- print(DEBUG.inspect(location_parsed))
		return "invalid grenade"
	end

	if location.type == "movement" and type(location_parsed.movement) == "table" then
		local movement = location_parsed.movement

		if type(movement.fov) == "number" and movement.fov > 0 and movement.fov < 360 then
			location.fov = movement.fov
		end

		if type(movement.frames) == "table" then
			-- decompress frames
			local frames = {}

			-- step one, insert the empty frames for numbers
			for i, frame in ipairs(movement.frames) do
				if type(frame) == "number" then
					if movement.frames[i] > 0 then
						for j=1, frame do
							table.insert(frames, {})
						end
					else
						return "invalid frame " .. tostring(i)
					end
				elseif type(frame) == "table" then
					table.insert(frames, frame)
				end
			end

			-- step two, delta decompress frames into ready-made usercmds
			local current = {
				viewangles = {pitch=location.viewangles.pitch, yaw=location.viewangles.yaw},
				buttons = {}
			}

			-- initialize all buttons as false
			for key, char in pairs(MOVEMENT_BUTTONS_CHARS) do
				current.buttons[key] = false
			end

			for i, value in ipairs(frames) do
				local pitch, yaw, buttons, forwardmove, sidemove = unpack(value)

				if pitch ~= nil and type(pitch) ~= "number" then
					return string.format("invalid pitch in frame #%d", i)
				elseif yaw ~= nil and type(yaw) ~= "number" then
					return string.format("invalid yaw in frame #%d", i)
				end

				-- update current viewangles with new delta data
				current.viewangles.pitch = current.viewangles.pitch + (pitch or 0)
				current.viewangles.yaw = current.viewangles.yaw + (yaw or 0)

				-- update buttons
				if type(buttons) == "string" then
					local buttons_down, buttons_up = parse_buttons_str(buttons)

					local buttons_seen = {}
					for _, btn in ipairs(buttons_down) do
						if btn == false then
							return string.format("invalid button in frame #%d", i)
						elseif buttons_seen[btn] then
							return string.format("invalid frame #%d: duplicate button %s", i, btn)
						end
						buttons_seen[btn] = true

						-- button is down
						current.buttons[btn] = true
					end

					for _, btn in ipairs(buttons_up) do
						if btn == false then
							return string.format("invalid button in frame #%d", i)
						elseif buttons_seen[btn] then
							return string.format("invalid frame #%d: duplicate button %s", i, btn)
						end
						buttons_seen[btn] = true

						-- button is up
						current.buttons[btn] = false
					end
				elseif buttons ~= nil then
					return string.format("invalid buttons in frame #%d", i)
				end

				-- either copy or reconstruct forwardmove and sidemove
				if type(forwardmove) == "number" and forwardmove >= -450 and forwardmove <= 450 then
					current.forwardmove = forwardmove
				elseif forwardmove ~= nil then
					return string.format("invalid forwardmove in frame #%d: %s", i, tostring(forwardmove))
				else
					current.forwardmove = calculate_move(current.buttons[e_cmd_buttons.FORWARD], current.buttons[e_cmd_buttons.BACK])
				end

				if type(sidemove) == "number" and sidemove >= -450 and sidemove <= 450 then
					current.sidemove = sidemove
				elseif sidemove ~= nil then
					return string.format("invalid sidemove in frame #%d: %s", i, tostring(sidemove))
				else
					current.sidemove = calculate_move(current.buttons[e_cmd_buttons.MOVERIGHT], current.buttons[e_cmd_buttons.MOVELEFT])
				end

				-- copy data from current into the frame
				frames[i] = {
					pitch = current.viewangles.pitch,
					yaw = current.viewangles.yaw,
					move_yaw = current.viewangles.yaw,
					forwardmove = current.forwardmove,
					sidemove = current.sidemove
				}

				-- copy over buttons
				for btn, value in pairs(current.buttons) do
					frames[i][btn] = value
				end
			end

			location.movement_commands = frames
		else
			return "invalid movement.frames"
		end
	elseif location_parsed.movement ~= nil then
		return "invalid movement"
	end

	if type(location_parsed.destroy) == "table" then
		local destroy = location_parsed.destroy
		location.destroy_text = "Break the object"

		if type(destroy.start) == "table" then
			local x, y, z = unpack(destroy.start)

			if type(x) == "number" and type(y) == "number" and type(z) == "number" then
				location.destroy_start = vector.new(x, y, z)
			else
				return "invalid type in destroy.start"
			end
		elseif destroy.start ~= nil then
			return "invalid destroy.start"
		end

		if type(destroy["end"]) == "table" then
			local x, y, z = unpack(destroy["end"])

			if type(x) == "number" and type(y) == "number" and type(z) == "number" then
				location.destroy_end = vector.new(x, y, z)
			else
				return "invalid type in destroy.end"
			end
		else
			return "invalid destroy.end"
		end

		if type(destroy.text) == "string" and destroy.text:len() > 0 then
			location.destroy_text = destroy.text
		elseif destroy.text ~= nil then
			return "invalid destroy.text"
		end
	elseif location_parsed.destroy ~= nil then
		return "invalid destroy"
	end

	return setmetatable(location, location_mt)
end

local function parse_and_create_locations(table_or_json, mapname)
	local locations_parsed
	if type(table_or_json) == "string" then
		local success
		success, locations_parsed = pcall(json.parse, table_or_json)

		if not success then
			error(locations_parsed)
			return
		end
	elseif type(table_or_json) == "table" then
		locations_parsed = table_or_json
	else
		assert(false)
	end

	if type(locations_parsed) ~= "table" then
		error(string.format("invalid type %s, expected table", type(locations_parsed)))
		return
	end

	local locations = {}
	for i=1, #locations_parsed do
		local location = create_location(locations_parsed[i])

		if type(location) == "table" then
			table.insert(locations, location)
		else
			error(location or "failed to parse")
			return
		end
	end

	return locations
end

local function export_locations(tbl, fancy)
	local indent = "  "
	local result = {}

	for i=1, #tbl do
		local str = tbl[i]:get_export(fancy)
		if fancy then
			str = indent .. str:gsub("\n", "\n" .. indent)
		end
		table.insert(result, str)
	end

	return (fancy and "[\n" or "[") .. table.concat(result, fancy and ",\n" or ",") .. (fancy and "\n]" or "]")
end

local function sort_by_distsqr(a, b)
	return a.distsqr > b.distsqr
end

local function sort_by_distsqr_reverse(a, b)
	return b.distsqr > a.distsqr
end

local function source_get_index_data(url, callback)
	http.get(url:gsub("^https://raw.githubusercontent.com/", "https://combinatronics.com/"), {absolute_timeout = 10, network_timeout = 5, params={ts=get_unix_timestamp()}}, function(success, response)
		local data = {}
		if not success or response.status ~= 200 or response.body == "404: Not Found" then
			if response.body == "404: Not Found" then
				callback("404 - Not Found")
			else
				callback(string.format("%s - %s", response.status, response.status_message))
			end

			return
		end

		local valid_json, jso = pcall(json.parse, response.body)
		if not valid_json then
			callback("Invalid JSON: " .. jso)
			return
		end

		-- name is always required
		if type(jso.name) == "string" then
			data.name = jso.name
		else
			callback("Invalid name")
			return
		end

		-- description can be nil or string
		if jso.description == nil or type(jso.description) == "string" then
			data.description = jso.description
		else
			callback("Invalid description")
			return
		end

		-- update_timestamp can be nil or number
		if jso.update_timestamp == nil or type(jso.update_timestamp) == "number" then
			data.update_timestamp = jso.update_timestamp
		else
			callback("Invalid update_timestamp")
			return
		end

		if jso.url_format ~= nil then
			-- dealing with a split location
			if type(jso.url_format) ~= "string" or not jso.url_format:match("^https?://.+$") then
				callback("Invalid url_format")
				return
			end

			-- simple sanity check, make sure <map> is contained in the string
			if not jso.url_format:find("%%map%%") then
				callback("Invalid url_format - %map% is required")
				return
			end

			data.url_format = jso.url_format
		else
			data.url_format = nil
		end

		-- create a lookup table for location aliases, or clear it if no locations are set (only valid for split location, will be checked later)
		data.location_aliases = {}
		data.locations = {}
		if type(jso.locations) == "table" then
			for map, map_data in pairs(jso.locations) do
				if type(map) ~= "string" then
					callback("Invalid key in locations")
					return
				end

				if type(map_data) == "string" then
					-- this is an alias
					data.location_aliases[map] = map_data
				elseif type(map_data) == "table" then
					data.locations[map] = map_data
				elseif jso.url_format ~= nil then
					-- not an alias and non-alias is forbidden for split locations
					callback("Location data is forbidden for split locations")
					return
				end
			end
		elseif jso.locations ~= nil then
			callback("Invalid locations")
			return
		end

		if next(data.location_aliases) == nil then
			data.location_aliases = nil
		end

		if next(data.locations) == nil then
			data.locations = nil
		end

		-- save last_updated to location
		data.last_updated = get_unix_timestamp()

		-- for a normal location, parse locations and update data in helper_store db
		-- if data.url_format == nil then
		-- 	-- data.locations is already checked above, so we can safely use it
		-- 	local new_locations = {}

		-- 	for map, map_data in pairs(data.locations) do
		-- 		if type(map_data) == "table" then
		-- 			print("source_get_index_data calling parse_and_create_locations")
		-- 			print(inspect(data.locations))
		-- 			print(inspect(map_data))
		-- 			local success, locations = pcall(parse_and_create_locations, map_data, map)

		-- 			if not success then
		-- 				return callback(string.format("Invalid locations for %s: %s", map, locations))
		-- 			end

		-- 			data.locations[map] = locations
		-- 		end
		-- 	end
		-- end

		callback(nil, data)
	end)
end

local source_mt = {
	__index = {
		-- update all data for remote source (index for split sources, everything for combined ones)
		update_remote_data = function(self)
			if not self.type == "remote" or self.url == nil then
				return
			end

			self.remote_status = "Loading index data..."
			source_get_index_data(self.url, function(err, data)
				if err ~= nil then
					self.remote_status = string.format("Error: %s", err)
					update_sources_ui()
					return
				end

				self.last_updated = data.last_updated

				if self.last_updated == nil then
					self.remote_status = "Index data refreshed"
					update_sources_ui()
					self.remote_status = nil
				else
					self.remote_status = nil
					update_sources_ui()
				end

				local keys = {"name", "description", "update_timestamp", "url_format"}
				for i=1, #keys do
					-- print(string.format("setting %s to %s", keys[i], data[keys[i]]))
					self[keys[i]] = data[keys[i]]
				end

				-- new url
				if data.url ~= nil and data.url ~= self.url then
					self.url = data.url
					self:update_remote_data()
					return
				end

				local current_map_name = get_mapname()

				-- todo: find a better way to do this
				sources_locations[self] = nil
				local store_db_locations = (database.read("helper_store") or {})["locations"]
				if store_db_locations ~= nil and type(store_db_locations[self.id]) == "table" then
					store_db_locations[self.id] = {}
				end
				flush_active_locations("update_remote_data")

				if data.locations ~= nil then
					sources_locations[self] = {}
					for map, locations_unparsed in pairs(data.locations) do
						-- print("parse_and_create_locations: ", inspect(locations_unparsed))
						local success, locations = pcall(parse_and_create_locations, locations_unparsed, map)
						if not success then
							self.remote_status = string.format("Invalid map data: %s", locations)
							client.error_log(string.format("Failed to load map data for %s (%s): %s", self.name, map, locations))
							update_sources_ui()
							return
						end

						-- set in runtime cache
						sources_locations[self][map] = locations

						-- save runtime cache to db
						self:store_write(map)

						-- remove from runtime cache unless we're on that map
						if map == current_map_name then
							flush_active_locations("B")
						else
							sources_locations[self][map] = nil
						end
					end
				end
			end)
		end,
		store_read = function(self, mapname)
			-- read data from store and parse it into sources_locations[self][mapname]
			if mapname == nil then
				local store_db_locations = (database.read("helper_store") or {})["locations"]
				if store_db_locations ~= nil and type(store_db_locations[self.id]) == "table" then
					for mapname, _ in pairs(store_db_locations[self.id]) do
						self:store_read(mapname)
					end
				end
				return
			end

			local store_db_locations = (database.read("helper_store") or {})["locations"]
			if store_db_locations ~= nil and type(store_db_locations[self.id]) == "table" and type(store_db_locations[self.id][mapname]) == "string" then
				local success, locations = pcall(parse_and_create_locations, store_db_locations[self.id][mapname], mapname)

				if not success then
					self.remote_status = string.format("Invalid map data for %s in database: %s", mapname, locations)
					client.error_log(string.format("Invalid map data for %s (%s) in database: %s", self.name, mapname, locations))
					update_sources_ui()
				else
					sources_locations[self][mapname] = locations
				end
				-- print("read from db! ", inspect(sources_locations[self][mapname]))
			end
		end,
		store_write = function(self, mapname)
			-- write sources_locations[self][mapname] to store db
			if mapname == nil then
				if sources_locations[self] ~= nil then
					for mapname, _ in pairs(sources_locations[self]) do
						self:store_write(mapname)
					end
				end
				return
			end

			-- print("write for ", self.id, " ", mapname)

			local store_db = (database.read("helper_store") or {})
			store_db.locations = store_db.locations or {}
			store_db.locations[self.id] = store_db.locations[self.id] or {}

			store_db.locations[self.id][mapname] = export_locations(sources_locations[self][mapname])

			-- print(inspect(sources_locations[self]))
			-- print(inspect(store_db))

			database.write("helper_store", store_db)
		end,
		get_locations = function(self, mapname, allow_fetch)
			if sources_locations[self] == nil then
				sources_locations[self] = {}
			end

			if sources_locations[self][mapname] == nil then
				self:store_read(mapname)
				local locations = sources_locations[self][mapname]

				if self.type == "remote" and allow_fetch and (self.last_updated == nil or get_unix_timestamp()-self.last_updated > (self.ttl or DEFAULTS.source_ttl)) then
					-- we dont even have up-to-date index data for this source, fetch it first
					-- print("fetching index data for ", self.name, " (", tostring(self.last_updated), ")")
					self:update_remote_data()
				end

				-- read and parse locations if required
				if self.type == "local_file" and mapname ~= nil then

					-- simulate delay for the memes
					client.delay_call(function()
						benchmark:start("readfile")
						local contents_raw = readfile(self.filename)

						local to_parse = "{}"
						local pretty_parsed_status, pretty_parsed_data = pcall(pretty_json.parse, contents_raw)
						local default_parsed_status, default_parsed_data = pcall(json.parse, contents_raw)

						if pretty_parsed_status then
							to_parse = pretty_parsed_data
						elseif default_parsed_status then
							to_parse = default_parsed_data
						end

						contents_raw = json.encode(to_parse)
						local contents = json.parse(contents_raw)

						if type(contents) ~= "table" then
							return
						end

						local current_map_name = get_mapname()

						for mapname, map_locations in pairs(contents) do
							local success, locations = pcall(parse_and_create_locations, map_locations, mapname)
							if not success then
								self.remote_status = string.format("Invalid map data: %s", locations)
								client.error_log(string.format("Failed to load map data for %s (%s): %s", self.name, mapname, locations))
								update_sources_ui()
								return
							end

							-- sanity check for get_export working properly
							if DEBUG then
								local keys_to_remove = {"viewangles", "position"}

								for i=1, #map_locations do
									local location = create_location(map_locations[i])
									if type(location) ~= "table" then
										-- print(inspect(map_locations[i]))
										client.log_screen("failed to create! ", location)
									else
										local export_tbl = location:get_export_tbl()

										for j=1, #keys_to_remove do
											export_tbl[keys_to_remove[j] ] = nil
											map_locations[i][keys_to_remove[j] ] = nil
										end

										if export_tbl.destroy ~= nil then
											export_tbl.destroy["start"] = nil
											export_tbl.destroy["end"] = nil
										end
										if map_locations[i].destroy ~= nil then
											map_locations[i].destroy["start"] = nil
											map_locations[i].destroy["end"] = nil
										end

										local json_str_export = json.encode(export_tbl)
										local json_str_orig = json.encode(map_locations[i])

										if json_str_orig:len() ~= json_str_export:len() then
											client.log_screen("  orig: ", json_str_orig)
											client.log_screen("export: ", json_str_export)
										end
									end
								end
							end

							-- client.log("read locations: ", inspect(locations):sub(0, 500))

							-- set in runtime cache
							sources_locations[self][mapname] = locations

							flush_active_locations()

							-- save runtime cache to db
							self:store_write(mapname)

							-- print("wrote successfully")

							-- remove from runtime cache unless we're on that map
							if mapname ~= current_map_name then
								sources_locations[self][mapname] = nil
							end
						end

						benchmark:finish("readfile")
					end, 0.5)
				elseif locations == nil and allow_fetch and self.type == "remote" and self.url_format ~= nil then
					-- fetch data for this map
					-- print("Fetching missing data for ", self.name, " - ", mapname)

					local url = self.url_format:gsub("%%map%%", mapname):gsub("^https://raw.githubusercontent.com/", "https://combinatronics.com/")

					self.remote_status = string.format("Loading map data for %s...", mapname)
					update_sources_ui()

					http.get(url, {network_timeout=10, absolute_timeout=15, params={ts=get_unix_timestamp()}}, function(success, response)
						if not success or response.status ~= 200 or response.body == "404: Not Found" then
							if response.status == 404 or response.body == "404: Not Found" then
								self.remote_status = string.format("No locations found for %s.", mapname)
							else
								self.remote_status = string.format("Failed to fetch %s: %s %s", mapname, response.status, response.status_message)
							end
							update_sources_ui()
							return
						end

						local success, locations = pcall(parse_and_create_locations, response.body, mapname)
						if not success then
							self.remote_status = string.format("Invalid map data: %s", locations)
							update_sources_ui()
							client.error_log(string.format("Failed to load map data for %s (%s): %s", self.name, mapname, locations))
							return
						end

						-- set in runtime cache
						sources_locations[self][mapname] = locations

						-- save runtime cache to db
						self:store_write(mapname)

						self.remote_status = nil
						update_sources_ui()
						flush_active_locations("C")
					end)
				else
					if locations == nil then
						-- print("failed to fetch locations for: ", inspect(self))
					end
				end

				sources_locations[self][mapname] = locations or {}
			end

			return sources_locations[self][mapname]
		end,
		get_all_locations = function(self)
			local locations = {}

			local store_db_locations = (database.read("helper_store") or {})["locations"]
			if store_db_locations ~= nil and type(store_db_locations[self.id]) == "table" then
				for mapname, _ in pairs(store_db_locations[self.id]) do
					locations[mapname] = self:get_locations(mapname)
				end
			end

			return locations
		end,
		-- called before writing source to db, so remove all temporary stuff etc
		cleanup = function(self)
			self.remote_status = nil
			setmetatable(self, nil)
		end
	}
}

for i=1, #db.sources do
	setmetatable(db.sources[i], source_mt)
end

--
-- dummy menu element for saving per-config settings
-- util functions: get_sources_config, set_sources_config
--

local function get_sources_config()
	local sources_config = database.read("sources_config") or json.parse("{}")

	-- fix up enabled sources
	local source_ids_assoc = {}
	sources_config.enabled = sources_config.enabled or {}
	for i=1, #db.sources do
		local source = db.sources[i]
		source_ids_assoc[source.id] = true
		if sources_config.enabled[source.id] == nil then
			sources_config.enabled[source.id] = true
		end
	end

	-- remove nonexistent sources from config
	for id, enabled in pairs(sources_config.enabled) do
		if source_ids_assoc[id] == nil then
			sources_config.enabled[id] = nil
		end
	end

	return sources_config
end

local function set_sources_config(sources_config)
	database.write("sources_config", sources_config)
end

local function button_with_confirmation(group, name, callback, callback_visibility)
	local button_open, button_cancel, button_confirm
	local ts_open

	button_open = menu.add_button(group, name, function()
		button_open:set_visible(false)
		button_cancel:set_visible(true)
		button_confirm:set_visible(true)

		local realtime = global_vars.real_time()
		ts_open = realtime

		client.delay_call(function()
			if ts_open == realtime then
				button_open:set_visible(true)
				button_cancel:set_visible(false)
				button_confirm:set_visible(false)

				if callback_visibility ~= nil then
					callback_visibility()
				end
			end
		end, 5)
	end)

	button_cancel = menu.add_button(group, name .. " (CANCEL)", function()
		button_open:set_visible(true)
		button_cancel:set_visible(false)
		button_confirm:set_visible(false)

		if callback_visibility ~= nil then
			callback_visibility()
		end

		ts_open = nil
	end)

	button_confirm = menu.add_button(group, name .. " (CONFIRM)", function()
		button_open:set_visible(true)
		button_cancel:set_visible(false)
		button_confirm:set_visible(false)

		ts_open = nil
		callback()

		if callback_visibility ~= nil then
			callback_visibility()
		end
	end)

	button_cancel:set_visible(false)
	button_confirm:set_visible(false)

	return button_open, button_cancel, button_confirm
end

--
-- ui references to default items
--

local airstrafe_reference = menu.find("misc", "main", "movement", "autostrafer")
local aa_pitch_reference = menu.find("antiaim", "main", "angles", "pitch")
local fast_stop_reference = menu.find("misc", "main", "movement", "fast stop")
local fast_stop_cache = fast_stop_reference:get()
local infinite_duck_reference = menu.find("misc", "main", "movement", "infinite duck stamina")

--
-- normal menu items
--

local enabled_reference = menu.add_checkbox("General", "Helper")
local hotkey_reference = enabled_reference:add_keybind("Helper hotkey")
local color_reference = enabled_reference:add_color_picker("Helper color", color_t(120, 120, 255, 255))
local types_reference = menu.add_multi_selection("General", "Helper types", {
	"Smoke",
	"Flashbang",
	"High Explosive",
	"Molotov",
	"Movement",
	"Location",
	"Area"
})
local aimbot_reference = menu.add_selection("General", "Aim at locations", {"Off", "Legit", "Legit (Silent)", "Rage"})
local aimbot_fov_reference = menu.add_slider("General", "Helper Aimbot FOV", 0, 200); aimbot_fov_reference:set(80)
local aimbot_speed_reference = menu.add_slider("General", "Helper Aimbot Speed", 0, 100); aimbot_speed_reference:set(75)
local behind_walls_reference = menu.add_checkbox("General", "Show locations behind walls")

--
-- source management menu items
--

local sources_list_ui = {
	title = menu.add_checkbox("Sources", "Helper: Manage sources"),
	list = menu.add_list("Sources", "Helper sources", {}),
	source_label1 = menu.add_text("Sources", "Source label 1"),
	enabled = menu.add_checkbox("Sources", "Enabled", false),
	source_label2 = menu.add_text("Sources", "Source label 2"),
	source_label3 = menu.add_text("Sources", "Source label 3"),
	name = menu.add_text_input("Sources", "New source name"),
}

--
-- source editing
--

-- forward declare button callbacks
local on_edit_save, on_edit_delete, on_edit_teleport, on_edit_set, on_edit_export

local edit_ui = {
	list = menu.add_list("Sources", "Selected source locations", {}),
	show_all = menu.add_checkbox("Sources", "Show all maps"),
	sort_by = menu.add_selection("Sources", "Sort by", {"Creation date", "Type", "Alphabetically"}),

	type_label = menu.add_text("Edit", "Creating new location"),
	type = menu.add_selection("Edit", "Location Type", {"Grenade", "Movement", "Location", "Area"}),
	from = menu.add_text_input("Edit", "From"),
	to = menu.add_text_input("Edit", "To"),
	description = menu.add_text_input("Edit", "Description (Optional)"),
	grenade_properties = menu.add_multi_selection("Edit", "Grenade Properties", {
		"Jump",
		"Run",
		"Walk (Shift)",
		"Throw strength",
		"Force-enable recovery",
		"Tickrate dependent",
		"Destroy breakable object",
		"Delayed throw"
	}),
	throw_strength = menu.add_selection("Edit",  "Throw strength", {"Left Click", "Left / Right Click", "Right Click"}),
	run_direction = menu.add_selection("Edit",  "Run duration / direction", {"Forward", "Left", "Right", "Back", "Custom"}),
	run_direction_custom = menu.add_slider("Edit",  "Custom run direction", -180, 180),
	run_duration = menu.add_slider("Edit", "Run duration", 1, 256),
	delay = menu.add_slider("Edit", "Throw delay", 1, 40),
	recovery_direction = menu.add_selection("Edit", "Recovery (after throw) direction", {"Back", "Forward", "Left", "Right", "Custom"}),
	recovery_direction_custom = menu.add_slider("Edit", "Custom recovery direction", -180, 180),
	recovery_jump = menu.add_checkbox("Edit", "Recovery bunny-hop"),

	set = menu.add_button("Edit", "Set location", function() on_edit_set() end),
	set_hotkey_label = menu.add_text("Edit", "Helper set location hotkey"),
	teleport = menu.add_button("Edit", "Teleport", function() on_edit_teleport() end),
	teleport_hotkey_label = menu.add_text("Edit", "Helper teleport hotkey"),
	export = menu.add_button("Edit", "Export to clipboard", function() on_edit_export() end),
	save = menu.add_button("Edit", "Save", function() on_edit_save() end),
}

edit_ui.set_hotkey = edit_ui.set_hotkey_label:add_keybind("Set location hotkey")
edit_ui.teleport_hotkey = edit_ui.teleport_hotkey_label:add_keybind("Teleport hotkey")
edit_ui.delete, edit_ui.delete_cancel, edit_ui.delete_confirm = button_with_confirmation("Edit", "Delete", function() on_edit_delete() end, update_sources_ui)
edit_ui.delete_hotkey_label = menu.add_text("Edit", "Helper delete hotkey")
edit_ui.delete_hotkey = edit_ui.delete_hotkey_label:add_keybind("Delete hotkey")

local edit_list, edit_ignore_callbacks, edit_different_map_selected = {}, false, false
local edit_location_selected

--
-- buttons with dummy callbacks so the funcs can be defined later
--

-- forward declare delete, create and import functions
local on_source_edit, on_source_edit_back, on_source_update, on_source_delete, on_source_create, on_source_import, on_source_export

sources_list_ui.edit = menu.add_button("Sources", "Edit", function() on_source_edit() end)
sources_list_ui.update = menu.add_button("Sources", "Update", function() on_source_update() end)
sources_list_ui.delete, sources_list_ui.delete_cancel, sources_list_ui.delete_confirm = button_with_confirmation("Sources", "Delete", function() on_source_delete() end, update_sources_ui)
sources_list_ui.create = menu.add_button("Sources", "Create", function() on_source_create() end)
sources_list_ui.import = menu.add_button("Sources", "Import from clipboard", function() on_source_import() end)
sources_list_ui.export = menu.add_button("Sources", "Export all to clipboard", function() on_source_export() end)
sources_list_ui.back = menu.add_button("Sources", "Back", function() on_source_edit_back() end)

sources_list_ui.source_label4 = menu.add_text("Sources", "Ready.")

local sources_list, sources_ignore_callback = {}, false
local source_editing, source_selected, source_remote_add_status = false
local source_editing_modified, source_editing_has_changed = setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "k"})

local source_editing_hotkeys_prev = {
	[edit_ui.set_hotkey] = false,
	[edit_ui.teleport_hotkey] = false,
	[edit_ui.delete_hotkey] = false
}

-- sets source
local function set_source_selected(source_selected_new)
	source_selected_new = source_selected_new or "add_local"

	-- prevent useless ui updates
	if source_selected_new == source_selected then
		return false
	end

	for i=1, #sources_list do
		if sources_list[i] == source_selected_new then
			sources_list_ui.list:set(i)
			source_editing = false
			return true
		end
	end

	return false
end

local function add_source(name_or_source, typ, source_text)
	local source
	if type(name_or_source) == "string" then
		source = {
			name = name_or_source,
			type = typ,
			id = randomid(8)
		}
	elseif type(name_or_source) == "table" then
		source = name_or_source
		source.type = typ
	else
		assert(false)
	end
	setmetatable(source, source_mt)

	local existing_ids = table_map_assoc(db.sources, function(key, source) return source.id, true end)
	while existing_ids[source.id] do
		source.id = randomid(8)
	end

	-- add to db
	table.insert(db.sources, source)

	-- add to config - handled by get_sources_config() fixup
	set_sources_config(get_sources_config())

	return source
end

local function get_sorted_locations(locations, sorting)
	if sorting == 1 then
		return locations
	elseif sorting == 2 or sorting == 3 then
		local new_tbl = {}

		-- shallow copy the table and return a new, sorted one
		for i=1, #locations do
			table.insert(new_tbl, locations[i])
		end

		table.sort(new_tbl, function(a, b)
			if sorting == 2 then
				return a:get_type_string() < b:get_type_string()
			elseif sorting == 3 then
				return a.name < b.name
			else
				return true
			end
		end)

		return new_tbl
	else
		return locations
	end
end

-- update source ui - stateless
function update_sources_ui()
	local ui_visibility = {}

	for name, reference in pairs(sources_list_ui) do
		if name ~= "title" then
			ui_visibility[reference] = false
		end
	end

	edit_different_map_selected = true

	for name, reference in pairs(edit_ui) do
		ui_visibility[reference] = false
	end

	if enabled_reference:get() and sources_list_ui.title:get() then
		if source_editing and source_selected ~= nil then
			-- print(inspect(source_selected))
			local mapname = get_mapname()
			local show_all = edit_ui.show_all:get()

			-- if we're not ingame show all locations
			if mapname == nil then
				show_all = true
			end

			ui_visibility[sources_list_ui.source_label1] = true
			ui_visibility[sources_list_ui.source_label2] = true
			sources_list_ui.source_label1:set(string.format("Editing %s source: %s", (SOURCE_TYPE_NAMES[source_selected.type] or source_selected.type):lower(), source_selected.name))
			sources_list_ui.source_label2:set(show_all and "Locations on all maps: " or string.format("Locations on %s:", mapname))
			ui_visibility[sources_list_ui.import] = true
			ui_visibility[sources_list_ui.export] = true
			ui_visibility[sources_list_ui.back] = true
			ui_visibility[edit_ui.list] = true
			ui_visibility[edit_ui.show_all] = true
			ui_visibility[edit_ui.sort_by] = true

			local edit_listbox, edit_maps, edit_listbox_i = {}, {}
			table_clear(edit_list)

			local sorting = edit_ui.sort_by:get()

			-- collect all locations for this map (or all if show_all is true)
			if show_all then
				local all_locations = source_selected:get_all_locations()
				local j = 1

				for map, locations in pairs(all_locations) do
					locations = get_sorted_locations(locations, sorting)
					for i=1, #locations do
						local location = locations[i]
						edit_list[j] = location

						local type_str = location:get_type_string()
						edit_listbox[j] = string.format("[%s] %s: %s", map, type_str, location.name)

						edit_maps[j] = map

						j = j + 1
					end
				end
			else
				local locations = source_selected:get_locations(mapname)

				locations = get_sorted_locations(locations, sorting)

				for i=1, #locations do
					local location = locations[i]
					edit_list[i] = location

					local type_str = location:get_type_string()
					edit_listbox[i] = string.format("%s: %s", type_str, location.full_name)

					edit_maps[i] = mapname
				end
			end

			table.insert(edit_listbox, "＋  Create new")
			table.insert(edit_list, "create_new")

			edit_ui.list:set_items(edit_listbox)

			if edit_location_selected == nil then
				-- edit_location_selected = "create_new"
				-- print("setting to ", tostring(edit_location_selected), " ", i-1)

				edit_location_selected = "create_new"
				edit_set_ui_values(true)

				-- print("set to ", edit_location_selected)
			end

			if edit_location_selected == "create_new" then
				edit_different_map_selected = false
			end

			for i=1, #edit_list do
				if edit_list[i] == edit_location_selected then
					edit_ui.list:set(i)

					if edit_maps[i] == mapname and mapname ~= nil then
						edit_different_map_selected = false
					end
				end
			end

			-- update right side
			-- if edit_location_selected ~= nil then
			ui_visibility[edit_ui.type] = true
			ui_visibility[edit_ui.from] = true
			ui_visibility[edit_ui.to] = true
			ui_visibility[edit_ui.description] = true
			ui_visibility[edit_ui.grenade_properties] = true
			ui_visibility[edit_ui.set] = true
			ui_visibility[edit_ui.set_hotkey] = true
			ui_visibility[edit_ui.teleport] = true
			ui_visibility[edit_ui.teleport_hotkey] = true
			ui_visibility[edit_ui.export] = true
			ui_visibility[edit_ui.save] = true

			local properties = edit_ui.grenade_properties

			if properties:get("Run") then
				ui_visibility[edit_ui.run_direction] = true
				ui_visibility[edit_ui.run_duration] = true

				if edit_ui.run_direction:get() == 5 then
					ui_visibility[edit_ui.run_direction_custom] = true
				end
			end

			if properties:get("Jump") or properties:get("Force-enable recovery") then
				ui_visibility[edit_ui.recovery_direction] = true
				ui_visibility[edit_ui.recovery_jump] = true

				if edit_ui.recovery_direction:get() == 5 then
					ui_visibility[edit_ui.recovery_direction_custom] = true
				end
			end

			if properties:get("Delayed throw") then
				ui_visibility[edit_ui.delay] = true
			end

			if properties:get("Throw strength") then
				ui_visibility[edit_ui.throw_strength] = true
			end

			if edit_location_selected ~= nil and edit_location_selected ~= "create_new" then
				ui_visibility[edit_ui.delete] = true
				ui_visibility[edit_ui.delete_hotkey] = true
			end
			-- end
		else
			local sources_config = get_sources_config()

			local sources_listbox, sources_listbox_i = {}
			table_clear(sources_list)

			-- collect all sources (default and custom)
			for i=1, #db.sources do
				local source = db.sources[i]
				sources_list[i] = source
				table.insert(sources_listbox, string.format("%s  %s: %s", sources_config.enabled[source.id] and "☑" or "☐", SOURCE_TYPE_NAMES[source.type] or source.type, source.name))

				if source == source_selected then
					sources_listbox_i = i
				end
			end

			table.insert(sources_listbox, "＋  Add remote source")
			table.insert(sources_list, "add_remote")
			if source_selected == "add_remote" then
				sources_listbox_i = #sources_list
			end

			table.insert(sources_listbox, "＋  Create local")
			table.insert(sources_list, "add_local")
			if source_selected == "add_local" then
				sources_listbox_i = #sources_list
			end

			if sources_listbox_i == nil then
				source_selected = sources_list[1]
				sources_listbox_i = 1
			end

			sources_list_ui.list:set_items(sources_listbox)
			if sources_listbox_i ~= nil then
				sources_list_ui.list:set(sources_listbox_i)
			end

			ui_visibility[sources_list_ui.list] = true
			if source_selected ~= nil then
				ui_visibility[sources_list_ui.source_label1] = true

				if source_selected == "add_remote" then
					sources_list_ui.source_label1:set("Add new remote source")
					ui_visibility[sources_list_ui.import] = true

					if source_remote_add_status ~= nil then
						sources_list_ui.source_label4:set(source_remote_add_status)
						ui_visibility[sources_list_ui.source_label4] = true
					end
				elseif source_selected == "add_local" then
					sources_list_ui.source_label1:set("New source name:")
					ui_visibility[sources_list_ui.name] = true
					ui_visibility[sources_list_ui.create] = true
				elseif source_selected ~= nil then
					ui_visibility[sources_list_ui.enabled] = true
					ui_visibility[sources_list_ui.edit] = source_selected.type == "local" and not source_selected.builtin
					ui_visibility[sources_list_ui.update] = source_selected.type == "remote"
					ui_visibility[sources_list_ui.delete] = not source_selected.builtin

					sources_ignore_callback = true

					sources_list_ui.source_label1:set(string.format("%s source: %s", SOURCE_TYPE_NAMES[source_selected.type] or source_selected.type, source_selected.name))

					if source_selected.description ~= nil then
						ui_visibility[sources_list_ui.source_label2] = true
						sources_list_ui.source_label2:set(string.format("%s", source_selected.description))
					end

					if source_selected.remote_status ~= nil then
						ui_visibility[sources_list_ui.source_label3] = true
						sources_list_ui.source_label3:set(source_selected.remote_status)
					elseif source_selected.update_timestamp ~= nil then
						ui_visibility[sources_list_ui.source_label3] = true
						-- format_unix_timestamp(timestamp, allow_future, ignore_seconds, max_parts)
						sources_list_ui.source_label3:set(string.format("Last updated: %s", format_unix_timestamp(source_selected.update_timestamp, false, false, 1)))
					end

					sources_list_ui.enabled:set(sources_config.enabled[source_selected.id] == true)

					sources_ignore_callback = false
				end
			end
		end
	end

	for reference, visible in pairs(ui_visibility) do
		reference:set_visible(visible)
	end
end

menu.set_callback("checkbox", "sources_list_ui.title", sources_list_ui.title, function()
	if not sources_list_ui.title:get() then
		source_editing = false
	end

	update_sources_ui()
end)

menu.set_callback("list", "sources_list_ui.list", sources_list_ui.list, function()
	local source_selected_prev = source_selected
	local i = sources_list_ui.list:get()

	if i ~= nil then
		source_selected = sources_list[i]

		if source_selected ~= source_selected_prev then
			source_editing = false
			source_remote_add_status = nil
			update_sources_ui()
		end
	-- else
	-- 	error("ui.get on listbox returned nil!")
	end
end)

menu.set_callback("checkbox", "sources_list_ui.enabled", sources_list_ui.enabled, function()
	if type(source_selected) == "table" and not sources_ignore_callback then
		local sources_config = get_sources_config()
		sources_config.enabled[source_selected.id] = sources_list_ui.enabled:get()
		set_sources_config(sources_config)
		update_sources_ui()

		flush_active_locations("D")
	end
end)

menu.set_callback("multi_selection", "types_reference", types_reference, flush_active_locations)

menu.set_callback("checkbox", "edit_ui.show_all", edit_ui.show_all, update_sources_ui)
menu.set_callback("selection", "edit_ui.sort_by", edit_ui.sort_by, update_sources_ui)

local url_fixers = {
	-- transform pastebin to raw urls
	function(url)
		local match = url:match("^https://pastebin.com/(%w+)/?$")

		if match ~= nil then
			return string.format("https://pastebin.com/raw/%s", match)
		end
	end,
	-- transform github to raw urls
	function(url)
		local user, repo, branch, path = url:match("^https://github.com/(%w+)/(%w+)/blob/(%w+)/(.+)$")

		if user ~= nil then
			return string.format("https://github.com/%s/%s/raw/%s/%s", user, repo, branch, path)
		end
	end,
}

function on_source_delete()
	if type(source_selected) == "table" and not source_selected.builtin then
		-- remove from db
		for i=1, #db.sources do
			if db.sources[i] == source_selected then
				table.remove(db.sources, i)
				break
			end
		end

		-- remove from config - handled by get_sources_config() fixup
		set_sources_config(get_sources_config())

		-- update ingame
		flush_active_locations("source deleted")

		set_source_selected()
	end
end

function on_source_update()
	if type(source_selected) == "table" and source_selected.type == "remote"
	 then
		source_selected:update_remote_data()
		update_sources_ui()
	end
end

function on_source_create()
	if source_selected == "add_local" then
		local name = sources_list_ui.name:get()

		if name:gsub(" ", "") == "" then
			return
		end

		-- append (1), (2) etc if local source with same name exists
		local existing_names = table_map_assoc(db.sources, function(i, source) return source.name, source.type == "local" end)
		local name_new, i = name, 2

		while existing_names[name_new] do
			name_new = string.format("%s (%d)", name, i)
			i = i + 1
		end

		name = name_new

		-- actually add source to db etc
		local source = add_source(name, "local")

		-- update ui to add it to listbox, then set it as selected source
		update_sources_ui()
		set_source_selected(source)
	end
end

local function source_import_arr(tbl, mapname)
	local locations = {}
	for i=1, #tbl do
		local location = create_location(tbl[i])
		if type(location) ~= "table" then
			local err = string.format("invalid location #%d: %s", i, location)
			client.error_log("Failed to import " .. tostring(mapname) .. ", " .. err)
			source_remote_add_status = err
			update_sources_ui()
			return
		end
		locations[i] = location
	end

	if #locations == 0 then
		client.error_log("Failed to import: No locations to import")
		source_remote_add_status = "No locations to import"
		update_sources_ui()
		return
	end

	local source_locations = source_selected:get_locations(mapname)
	if source_locations == nil then
		source_locations = {}
		sources_locations[source_selected][mapname] = source_locations
	end

	for i=1, #locations do
		table.insert(source_locations, locations[i])
	end

	update_sources_ui()
	source_selected:store_write()
	flush_active_locations()
end

function on_source_import()
	if source_editing and type(source_selected) == "table" and source_selected.type == "local" and get_clipboard_text then
		-- import data into source
		local text = get_clipboard_text()

		if text == nil then
			local err = "No text copied to clipboard"
			client.error_log("Failed to import: " .. err)
			source_remote_add_status = err
			update_sources_ui()
			return
		end

		local success, tbl = pcall(json.parse, text)

		if success and text:sub(1, 1) ~= "[" and text:sub(1, 1) ~= "{" then
			success, tbl = false, "Expected object or array"
		end

		if not success then
			local err = string.format("Invalid JSON: %s", tbl)
			client.error_log("Failed to import: " .. err)
			source_remote_add_status = err
			update_sources_ui()
			return
		end

		-- heuristics to determine if its a location or an array of locations
		local is_arr = text:sub(1, 1) == "["

		if not is_arr then
			-- heuristics to determine if its a table of mapname -> locations or a single location
			if tbl["name"] ~= nil or tbl["grenade"] ~= nil or tbl["location"] ~= nil then
				tbl = {tbl}
				is_arr = true
			end
		end

		if is_arr then
			local mapname = get_mapname()

			if mapname == nil then
				client.error_log("Failed to import: You need to be in-game")
				source_remote_add_status = "You need to be in-game"
				update_sources_ui()
				return
			end

			source_import_arr(tbl, mapname)
		else
			for mapname, locations in pairs(tbl) do
				if type(mapname) ~= "string" or mapname:find(" ") then
					client.error_log("Failed to import: Invalid map name")
					source_remote_add_status = "Invalid map name"
					update_sources_ui()
					return
				end
			end

			for mapname, locations in pairs(tbl) do
				source_import_arr(locations, mapname)
			end
		end
	elseif source_selected == "add_remote" and get_clipboard_text then
		-- add new remote source
		local text = get_clipboard_text()
		if text == nil then
			client.error_log("Failed to import: Clipboard is empty")
			source_remote_add_status = "Clipboard is empty"
			update_sources_ui()
			return
		end

		local url = sanitize_string(text):gsub(" ", "")

		if not url:match("^https?://.+$") then
			client.error_log("Failed to import: Invalid URL")
			source_remote_add_status = "Invalid URL"
			update_sources_ui()
			return
		end

		for i=1, #url_fixers do
			url = url_fixers[i](url) or url
		end

		for i=1, #db.sources do
			local source = db.sources[i]
			if source.type == "remote" and source.url == url then
				client.error_log("Failed to import: A source with that URL already exists")
				source_remote_add_status = "A source with that URL already exists"
				update_sources_ui()
				return
			end
		end

		source_remote_add_status = "Loading index data..."
		update_sources_ui()
		source_get_index_data(url, function(err, data)
			if source_selected ~= "add_remote" then
				return
			end

			if err ~= nil then
				client.error_log(string.format("Failed to import: %s", err))
				source_remote_add_status = err
				update_sources_ui()
				return
			end
			local source = add_source(data.name, "remote")

			source.url = data.url or url
			source.url_format = data.url_format
			source.description = data.description
			source.update_timestamp = data.update_timestamp
			source.last_updated = data.last_updated

			source_remote_add_status = string.format("Successfully imported %s", source.name)
			update_sources_ui()

			source_selected = nil
			set_source_selected("add_remote")
			update_sources_ui()
		end)
	end
end

function on_source_export()
	if source_editing and type(source_selected) == "table" and source_selected.type == "local" then
		local indent = "  "
		local mapname = get_mapname()
		local show_all = edit_ui.show_all:get()

		-- if we're not ingame show all locations
		if mapname == nil then
			show_all = true
		end

		local export_str
		if show_all then
			local all_locations = source_selected:get_all_locations()

			local maps = {}
			for map, _ in pairs(all_locations) do
				table.insert(maps, map)
			end
			table.sort(maps)

			local tbl = {}
			for i=1, #maps do
				local map = maps[i]
				local locations = all_locations[map]
				local tbl_map = {}
				for i=1, #locations do
					local str = locations[i]:get_export(true)
					table.insert(tbl_map, indent .. (str:gsub("\n", "\n" .. indent .. indent)))
				end

				table.insert(tbl, json.stringify(map) .. ": [\n" .. indent .. table.concat(tbl_map, ",\n" .. indent) .. "\n" .. indent .. "]")
			end

			export_str = "{\n" .. indent .. table.concat(tbl, ",\n" .. indent) .. "\n}"
		else
			local locations = source_selected:get_locations(mapname)

			local tbl = {}
			for i=1, #locations do
				tbl[i] = locations[i]:get_export(true):gsub("\n", "\n" .. indent)
			end

			export_str = "[\n" .. indent .. table.concat(tbl, ",\n" .. indent) .. "\n]"
		end

		if export_str ~= nil then
			if set_clipboard_text ~= nil then
				set_clipboard_text(export_str)
				client.log_screen("Exported location (Copied to clipboard):")
			else
				client.log_screen("Exported location:")
			end
			pretty_json.print_highlighted(export_str)
		end
	end
end

local function edit_update_has_changed()
	if source_editing and edit_location_selected ~= nil and source_editing_modified[edit_location_selected] ~= nil then
		if type(edit_location_selected) == "table" then
			local old = edit_location_selected:get_export_tbl()
			source_editing_has_changed[edit_location_selected] = not deep_compare(old, source_editing_modified[edit_location_selected])
		else
			source_editing_has_changed[edit_location_selected] = true
		end
	end

	return source_editing_has_changed[edit_location_selected] == true
end

function edit_set_ui_values(force)
	local location_tbl = {}
	if source_editing and edit_location_selected ~= nil and source_editing_modified[edit_location_selected] ~= nil then
		location_tbl = source_editing_modified[edit_location_selected]
	end

	if edit_different_map_selected and not force then
		location_tbl = {}
	end

	local yaw_to_name = table_map_assoc(YAW_DIRECTION_OFFSETS, function(k, v) return v, k end)

	edit_ignore_callbacks = true
	local grenade_properties_list = edit_ui.grenade_properties:get_items()
	for key, value in pairs(grenade_properties_list) do
		edit_ui.grenade_properties:set(value, false)
	end

	if edit_different_map_selected then
		edit_ui.type_label:set("Can't edit location on a different map")
	else
		edit_ui.type_label:set(edit_location_selected == "create_new" and "Creating new location" or string.format("Editing %s to %s", location_tbl.name and location_tbl.name[1] or "Unnamed", location_tbl.name and location_tbl.name[2] or "Unnamed"))
	end

	if location_tbl.grenade ~= nil then
		edit_ui.type:set(1)

		edit_ui.recovery_direction:set(2)
		edit_ui.recovery_direction_custom:set(0)
		edit_ui.recovery_jump:set(false)

		edit_ui.run_direction:set(1)
		edit_ui.run_duration:set(20)
		edit_ui.run_direction_custom:set(0)
		edit_ui.delay:set(1)

		local properties = {}
		if location_tbl.grenade.jump then
			table.insert(properties, "Jump")
		end

		if location_tbl.grenade.recovery_yaw ~= nil then
			if not location_tbl.grenade.jump then
				table.insert(properties, "Force-enable recovery")
			end

			if yaw_to_name[location_tbl.grenade.recovery_yaw] ~= nil then
				local recovery_direction_items = edit_ui.recovery_direction:get_items()
				local recovery_direction_index = nil
				local recovery_direction_value = yaw_to_name[location_tbl.grenade.recovery_yaw]
				for key, value in ipairs(recovery_direction_items) do
					if recovery_direction_value == value then
						recovery_direction_index = key
					end
				end

				if recovery_direction_index ~= nil then
					edit_ui.recovery_direction:set(recovery_direction_index)
				end
			else
				edit_ui.recovery_direction:set(5)
				edit_ui.recovery_direction_custom:set(location_tbl.grenade.recovery_yaw)
			end
		end

		if location_tbl.grenade.recovery_jump then
			edit_ui.recovery_jump:set(true)
		end

		if location_tbl.grenade.strength ~= nil and location_tbl.grenade.strength ~= 1 then
			table.insert(properties, "Throw strength")

			edit_ui.throw_strength:set(location_tbl.grenade.strength == 0.5 and 2 or 1)
		end

		if location_tbl.grenade.delay ~= nil then
			table.insert(properties, "Delayed throw")
			edit_ui.delay:set(location_tbl.grenade.delay)
		end

		if location_tbl.grenade.run ~= nil then
			table.insert(properties, "Run")

			if location_tbl.grenade.run ~= 20 then
				edit_ui.run_duration:set(location_tbl.grenade.run)
			end

			if location_tbl.grenade.run_yaw ~= nil then
				if yaw_to_name[location_tbl.grenade.run_yaw] ~= nil then
					local run_direction_items = edit_ui.run_direction:get_items()
					local run_direction_index = nil
					local run_direction_value = yaw_to_name[location_tbl.grenade.run_yaw]
					for key, value in ipairs(run_direction_items) do
						if run_direction_value == value then
							run_direction_index = key
						end
					end

					if run_direction_index ~= nil then
						edit_ui.run_direction:set(run_direction_index)
					end
				else
					edit_ui.run_direction:set(5)
					edit_ui.run_direction_custom:set(location_tbl.grenade.run_yaw)
				end
			end

			if location_tbl.grenade.run_speed then
				table.insert(properties, "Walk (Shift)")
			end
		end

		for key, value in pairs(properties) do
			edit_ui.grenade_properties:set(value, true)
		end
	elseif location_tbl.movement ~= nil then
		edit_ui.type:set(2)
	else
		for key, value in pairs(grenade_properties_list) do
			edit_ui.grenade_properties:set(value, false)
		end
	end

	edit_ignore_callbacks = false
end

local function edit_read_ui_values()
	if edit_ignore_callbacks or edit_different_map_selected then
		return
	end

	if source_editing and source_editing_modified[edit_location_selected] == nil then
		-- print("is nil!")
		if edit_location_selected == "create_new" then
			-- creating new location
			-- source_editing_modified[edit_location_selected] = {}

			-- print("created new!")
		elseif edit_location_selected ~= nil then
			-- editing existing location
			source_editing_modified[edit_location_selected] = edit_location_selected:get_export_tbl()
			edit_set_ui_values()

			-- print("cloned!")
		end
	end

	if source_editing and edit_location_selected ~= nil and source_editing_modified[edit_location_selected] ~= nil then
		local location = source_editing_modified[edit_location_selected]

		local prev = json.encode(location)

		-- todo: get location names here
		local from = edit_ui.from:get()
		if from:gsub(" ", "") == "" then
			from = "Unnamed"
		end

		local to = edit_ui.to:get()
		if to:gsub(" ", "") == "" then
			to = "Unnamed"
		end

		location.name = {from, to}

		local description = edit_ui.description:get()
		if description:gsub(" ", "") ~= "" then
			location.description = description:gsub("^%s+", ""):gsub("%s+$", "")
		else
			location.description = nil
		end

		location.grenade = location.grenade or {}
		local properties = edit_ui.grenade_properties

		if properties:get("Jump") then
			location.grenade.jump = true
		else
			location.grenade.jump = nil
		end

		if properties:get("Jump") or properties:get("Force-enable recovery") then
			-- figure out recovery_yaw
			local recovery_yaw_offset

			local recovery_yaw_option
			local recovery_yaw_option_item = edit_ui.recovery_direction:get()
			local recovery_yaw_option_items = edit_ui.recovery_direction:get_items()

			for key, value in ipairs(recovery_yaw_option_items) do
				if key == recovery_yaw_option_item then
					recovery_yaw_option = value
				end
			end

			if recovery_yaw_option == "Custom" then
				recovery_yaw_offset = edit_ui.recovery_direction_custom:get()

				if recovery_yaw_offset == -180 then
					recovery_yaw_offset = 180
				end
			else
				recovery_yaw_offset = YAW_DIRECTION_OFFSETS[recovery_yaw_option]
			end

			location.grenade.recovery_yaw = (recovery_yaw_offset ~= nil and recovery_yaw_offset ~= 180) and recovery_yaw_offset or (not properties:get("Jump") and 180 or nil)
			location.grenade.recovery_jump = edit_ui.recovery_jump:get() and true or nil

			-- print("saved: ", location.grenade.recovery_yaw)
		else
			location.grenade.recovery_yaw = nil
			location.grenade.recovery_jump = nil
		end

		if properties:get("Run") then
			location.grenade.run = edit_ui.run_duration:get()

			-- figure out run_yaw_offset
			local run_yaw_offset

			local run_yaw_option
			local run_yaw_option_item = edit_ui.run_direction:get()
			local run_yaw_option_items = edit_ui.run_direction:get_items()

			for key, value in ipairs(run_yaw_option_items) do
				if key == run_yaw_option_item then
					run_yaw_option = value
				end
			end

			if run_yaw_option == "Custom" then
				run_yaw_offset = edit_ui.run_direction_custom:get()
			else
				run_yaw_offset = YAW_DIRECTION_OFFSETS[run_yaw_option]
			end

			location.grenade.run_yaw = (run_yaw_offset ~= nil and run_yaw_offset ~= 0) and run_yaw_offset or nil

			if properties:get("Walk (Shift)") then
				location.grenade.run_speed = true
			else
				location.grenade.run_speed = nil
			end
		else
			location.grenade.run = nil
			location.grenade.run_yaw = nil
			location.grenade.run_speed = nil
		end

		if properties:get("Delayed throw") then
			location.grenade.delay = edit_ui.delay:get()
		else
			location.grenade.delay = nil
		end

		if properties:get("Throw strength") then
			local strength = edit_ui.throw_strength:get()
			if strength == 2 then
				location.grenade.strength = 0.5
			elseif strength == 3 then
				location.grenade.strength = 0
			else
				location.grenade.strength = nil
			end
		else
			location.grenade.strength = nil
		end

		if location.grenade ~= nil and next(location.grenade) == nil then
			location.grenade = nil
		end

		if edit_update_has_changed() then
			flush_active_locations("edit_update_has_changed")
		end
	end
	update_sources_ui()
end

menu.set_callback("multi_selection", "edit_ui.grenade_properties", edit_ui.grenade_properties, edit_read_ui_values)
menu.set_callback("selection", "edit_ui.run_direction", edit_ui.run_direction, edit_read_ui_values)
menu.set_callback("slider", "edit_ui.run_direction_custom", edit_ui.run_direction_custom, edit_read_ui_values)
menu.set_callback("slider", "edit_ui.run_duration", edit_ui.run_duration, edit_read_ui_values)
menu.set_callback("selection", "edit_ui.recovery_direction", edit_ui.recovery_direction, edit_read_ui_values)
menu.set_callback("slider", "edit_ui.recovery_direction_custom", edit_ui.recovery_direction_custom, edit_read_ui_values)
menu.set_callback("checkbox", "edit_ui.recovery_jump", edit_ui.recovery_jump, edit_read_ui_values)
menu.set_callback("slider", "edit_ui.delay", edit_ui.delay, edit_read_ui_values)
menu.set_callback("selection", "edit_ui.throw_strength", edit_ui.throw_strength, edit_read_ui_values)

client.delay_call(update_sources_ui, 1)

function on_source_edit()
	if type(source_selected) == "table" and source_selected.type == "local" and not source_selected.builtin then
		source_editing = true
		update_sources_ui()
		flush_active_locations("on_source_edit")
	end
end

function on_source_edit_back()
	source_editing = false
	edit_location_selected = nil

	table_clear(source_editing_modified)
	table_clear(source_editing_has_changed)

	flush_active_locations("on_source_edit_back")
	update_sources_ui()
end

function on_edit_teleport()
	if not edit_different_map_selected and edit_location_selected ~= nil and (edit_location_selected == "create_new" or source_editing_modified[edit_location_selected] ~= nil) then
		if cvars.sv_cheats:get_int() == 0 then
			return
		end

		local location = source_editing_modified[edit_location_selected]

		if location ~= nil then
			engine.execute_cmd(string.format("use %s; setpos_exact %f %f %f", location.weapon, unpack(location.position)))
			engine.set_view_angles(angle_t(location.viewangles[1], location.viewangles[2], 0))

			client.delay_call(function()
				if entity_list.get_local_player():get_prop("m_MoveType") == 8 then
					local x, y, z = unpack(location.position)
					engine.execute_cmd(string.format("noclip off; setpos_exact %f %f %f", x, y, z+64))
				end
			end, 0.1)
		end
	end
end

function on_edit_set()
	if not edit_different_map_selected and edit_location_selected ~= nil then
		if source_editing_modified[edit_location_selected] == nil then
			source_editing_modified[edit_location_selected] = {}
			edit_read_ui_values()
		end

		local local_player = entity_list.get_local_player()

		if local_player == nil then
			client.error_log("join to the map")
			return
		end

		local weapon_ent = local_player:get_active_weapon()
		local weapon = weapons[weapon_ent:get_weapon_data().console_name]

		weapon = WEAPON_ALIASES[weapon] or weapon

		local location = source_editing_modified[edit_location_selected]

		location.position = {vector.from_vec(local_player:get_render_origin()):unpack()}

		local pitch, yaw = engine.get_view_angles().x, engine.get_view_angles().y
		location.viewangles = {pitch, yaw}

		local duckamount = local_player:get_prop("m_flDuckAmount")
		if duckamount ~= 0 then
			location.duck = local_player:get_prop("m_flDuckAmount") == 1
		else
			location.duck = nil
		end

		location.weapon = weapon.console_name

		-- if weapon.type == "grenade" then
		-- 	local throw_strength = weapon_ent:get_prop("m_flThrowStrength")

		-- 	if throw_strength ~= 1 then
		-- 		location.grenade = location.grenade or {}

		-- 		if throw_strength == 0 then
		-- 			location.grenade.strength = 0
		-- 		else
		-- 			location.grenade.strength = 0.5
		-- 		end
		-- 	elseif location.grenade ~= nil then
		-- 		location.grenade.strength = nil
		-- 	end

		-- 	if location.grenade ~= nil and next(location.grenade) == nil then
		-- 		location.grenade = nil
		-- 	end
		-- end

		if edit_update_has_changed() then
			flush_active_locations("edit_update_has_changed")
		end
	end
end

function on_edit_save()
	if not edit_different_map_selected and edit_location_selected ~= nil and source_editing_modified[edit_location_selected] ~= nil then
		-- print("saving to ", edit_location_selected)

		local location = create_location(source_editing_modified[edit_location_selected])

		if type(location) ~= "table" then
			client.error_log("failed to save: " .. location)
			return
		end

		local mapname = get_mapname()

		if mapname == nil then
			return
		end

		local source_locations = sources_locations[source_selected][mapname]
		if source_locations == nil then
			source_locations = {}
			sources_locations[source_selected][mapname] = source_locations
		end
		if edit_location_selected == "create_new" then
			table.insert(source_locations, location)
			source_selected:store_write()
			flush_active_locations()

			edit_location_selected = location
			source_editing_modified[edit_location_selected] = source_editing_modified["create_new"]
			source_editing_modified["create_new"] = nil
		elseif type(edit_location_selected) == "table" then
			-- replace in sources_locations
			for i=1, #source_locations do
				if source_locations[i] == edit_location_selected then
					-- migrate changes to new location
					source_editing_modified[location] = source_editing_modified[source_locations[i]]
					source_editing_modified[source_locations[i]] = nil
					edit_location_selected = location

					-- replace location
					source_locations[i] = location

					source_selected:store_write()
					flush_active_locations()
					break
				end
			end
		end

		-- flush to disk rn to make sure we dont lose data on game crash
		--database.flush()

		edit_set_ui_values()

		update_sources_ui()
		flush_active_locations()
	end
end

function on_edit_export()
	if type(edit_location_selected) == "table" or source_editing_modified[edit_location_selected] ~= nil then
		local location = create_location(source_editing_modified[edit_location_selected]) or edit_location_selected

		if type(location) == "table" then
			local export_str = location:get_export(true)

			if set_clipboard_text ~= nil then
				set_clipboard_text(export_str)
				client.log_screen("Exported location (Copied to clipboard):")
			else
				client.log_screen("Exported location:")
			end
			pretty_json.print_highlighted(export_str)
		else
			client.error_log(location)
		end
	end
end

function on_edit_delete()
	if not edit_different_map_selected and edit_location_selected ~= nil and type(edit_location_selected) == "table" then
		local mapname = get_mapname()
		if mapname == nil then
			return
		end

		local source_locations = sources_locations[source_selected][mapname]

		for i=1, #source_locations do
			if source_locations[i] == edit_location_selected then
				table.remove(source_locations, i)
				source_editing_modified[edit_location_selected] = nil
				edit_location_selected = nil
				update_sources_ui()
				source_selected:store_write()
				--database.flush()
				flush_active_locations()
				break
			end
		end
	end
end

menu.set_callback("list", "edit_ui.list", edit_ui.list, function()
	local edit_location_selected_prev = edit_location_selected
	local i = edit_ui.list:get()

	if i ~= nil then
		edit_location_selected = edit_list[i]
	else
		edit_location_selected = "create_new"
		-- error("ui.get on edit listbox returned nil!")
	end

	-- print("prev: ", tostring(edit_location_selected_prev))
	-- print("cur: ", tostring(edit_location_selected))

	update_sources_ui()
	if edit_location_selected ~= edit_location_selected_prev and not edit_different_map_selected then
		-- print("edit_location_selected changed to ", tostring(edit_location_selected))

		if type(edit_location_selected) == "table" and source_editing_modified[edit_location_selected] == nil then
			-- clone location
			source_editing_modified[edit_location_selected] = edit_location_selected:get_export_tbl()
		end

		edit_set_ui_values()
		update_sources_ui()
		flush_active_locations()
	elseif edit_location_selected ~= edit_location_selected_prev then
		edit_set_ui_values()
	end
end)

update_sources_ui()
client.delay_call(update_sources_ui, 0)

local last_vischeck, weapon_prev, active_locations_in_range = 0
local location_set_closest, location_selected, location_playback

local ICON_EDIT = images.get_panorama_image("icons/ui/edit.svg")
local ICON_WARNING = images.get_panorama_image("icons/ui/warning.svg")

local function on_paint_editing()
	-- hotkeys -> callbacks
	local hotkeys = {
		set_hotkey = on_edit_set,
		teleport_hotkey = on_edit_teleport,
		delete_hotkey = on_edit_delete
	}

	for key, callback in pairs(hotkeys) do
		local value = edit_ui[key]:get()

		if source_editing_hotkeys_prev[key] == nil then
			source_editing_hotkeys_prev[key] = value
		end

		if value and not source_editing_hotkeys_prev[key] then
			callback()
		end

		source_editing_hotkeys_prev[key] = value
	end

	local location = source_editing_modified[edit_location_selected]
	if location ~= nil then
		-- todo: get location names here
		local from = edit_ui.from:get()
		local to = edit_ui.to:get()

		if from:gsub(" ", "") == "" then
			from = "Unnamed"
		end

		if to:gsub(" ", "") == "" then
			to = "Unnamed"
		end

		if (from ~= location.name[1]) or (to ~= location.name[2]) then
			edit_read_ui_values()
		end

		local description = edit_ui.description:get()
		if description:gsub(" ", "") ~= "" then
			description = description:gsub("^%s+", ""):gsub("%s+$", "")
		else
			description = nil
		end

		if location.description ~= description then
			edit_read_ui_values()
		end

		local location_orig = type(edit_location_selected) == "table" and edit_location_selected:get_export_tbl() or {}
		local location_orig_flattened = deep_flatten(location_orig, true)

		local has_changes = source_editing_has_changed[edit_location_selected]
		local key_values = deep_flatten(location, true)
		local key_values_arr = {}

		for key, value in pairs(key_values) do
			local changed = false
			local val_new = json.encode(value)

			if has_changes then
				local val_old = json.encode(location_orig_flattened[key])

				changed = val_new ~= val_old
			end

			local val_new_fancy = pretty_json.highlight(val_new, changed and {244, 147, 134} or {221, 221, 221}, changed and {223, 57, 35} or {218, 230, 30}, changed and {209, 42, 62} or {180, 230, 30}, changed and {209, 42, 62} or {96, 160, 220})
			local text_new = ""
			for i=1, #val_new_fancy do
				local r, g, b, text = unpack(val_new_fancy[i])
				text_new = text_new .. text
			end

			table.insert(key_values_arr, {key, text_new, changed})
		end

		local lookup = {
			name = "\1",
			weapon = "\2",
			position = "\3",
			viewangles = "\4",
		}
		table.sort(key_values_arr, function(a, b)
			return (lookup[b[1]] or b[1]) > (lookup[a[1]] or a[1])
		end)

		local lines = {
			{{ICON_EDIT, 0, 0, 12, 12}, 255, 255, 255, 220, "b", 0, " Editing Location:"}
		}

		for i=1, #key_values_arr do
			local key, value, changed = unpack(key_values_arr[i])

			table.insert(lines, {255, 255, 255, 220, "", 0, key, ": ", value})
		end

		local size_prev = #lines
		if has_changes then
			table.insert(lines, {{ICON_WARNING, 0, 0, 12, 12, 255, 54, 0, 255}, 234, 64, 18, 220, "", 0, "You have unsaved changes! Make sure to click Save."})
		end

		local weapon = weapons[location.weapon]

		if weapon.type == "grenade" then
			local types_enabled = types_reference
			local weapon_name = GRENADE_WEAPON_NAMES_UI[weapon]
			if not types_enabled:get(weapon_name) then
				table.insert(lines, {{ICON_WARNING, 0, 0, 12, 12, 255, 54, 0, 255}, 234, 64, 18, 220, "", 0, "Location not shown because type \"", tostring(weapon_name), "\" is not enabled."})
			end
		end

		local sources_config = get_sources_config()

		if source_selected ~= nil and not sources_config.enabled[source_selected.id] then
			table.insert(lines, {{ICON_WARNING, 0, 0, 12, 12, 255, 54, 0, 255}, 234, 64, 18, 220, "", 0, "Location not shown because source \"", tostring(source_selected.name), "\" is not enabled."})
		end

		if #lines > size_prev then
			table.insert(lines, size_prev+1, {255, 255, 255, 0, "", 0, " "})
		end

		local width, height, line_y = 0, 0, {}
		for i=1, #lines do
			local line = lines[i]
			local has_icon = type(line[1]) == "table"
			local line_size = render.get_text_size(fonts.verdana.default, get_string(select(has_icon and 8 or 7, unpack(line))))
			local w, h = line_size.x, line_size.y

			if has_icon then
				w = w + line[1][4]
			end

			if w > width then
				width = w
			end

			line_y[i] = height
			height = height + h

			if i == 1 then
				height = height + 2
			end
		end

		local screen = render.get_screen_size()
		local screen_width, screen_height = screen.x, screen.y
		local x = screen_width/2-math.floor(width/2)
		local y = 140

		render.push_alpha_modifier(0.7)
		render.rect_filled(vec2_t(x-4, y-3), vec2_t(width+8, height+6), color_t(16, 16, 16, 150))
		render.rect(vec2_t(x-5, y-4), vec2_t(width+10, height+8), color_t(16, 16, 16, 170))
		render.rect(vec2_t(x-6, y-5), vec2_t(width+12, height+10), color_t(16, 16, 16, 195))
		render.rect(vec2_t(x-7, y-6), vec2_t(width+14, height+12), color_t(16, 16, 16, 40))
		render.pop_alpha_modifier()

		render.rect_filled(vec2_t(x+15, y), vec2_t(1, 12), color_t(255, 255, 255, 255))

		for i=1, #lines do
			local line = lines[i]
			local has_icon = type(line[1]) == "table"

			local icon, ix, iy, iw, ih, ir, ig, ib, ia
			if has_icon then
				icon, ix, iy, iw, ih, ir, ig, ib, ia = unpack(line[1])
				icon:draw(x+ix, y+iy+line_y[i], iw, ih, ir, ig, ib, ia)
			end

			local r, g, b, a = lines[i][has_icon and 2 or 1], lines[i][has_icon and 3 or 2], lines[i][has_icon and 4 or 3], lines[i][has_icon and 5 or 4]

			render.text(fonts.verdana.default, get_string(select(has_icon and 8 or 7, unpack(lines[i]))), vec2_t(x+(iw or -3)+3, y+line_y[i]), color_t(r, g, b, a))
		end
	end
end

local function populate_map_locations(local_player, weapon)
	map_locations[weapon] = {}
	active_locations = map_locations[weapon]

	local tickrate = 1/global_vars.interval_per_tick()
	local mapname = get_mapname()
	local sources_config = get_sources_config()
	local types_enabled = types_reference

	-- collect enabled sources
	for i=1, #db.sources do
		local source = db.sources[i]
		if sources_config.enabled[source.id] then
			-- fetch sources if we dont have them
			local source_locations = source:get_locations(mapname, true)

			local editing_current_source = source_editing and source_selected == source

			-- are we editing this source?
			if editing_current_source then
				local source_locations_new = {}

				-- print("editing_current_source!")
				-- print(tostring(edit_location_selected))

				for i=1, #source_locations do
					if source_locations[i] == edit_location_selected and source_editing_modified[source_locations[i]] == nil then
						-- print("source_editing_modified[source_locations[i]] is nil")
					end

					if source_locations[i] == edit_location_selected and source_editing_modified[source_locations[i]] ~= nil then
						local location = create_location(source_editing_modified[source_locations[i]])

						-- print("create!")

						if type(location) == "table" then
							location.editing = source_editing and source_editing_has_changed[source_locations[i]]
							source_locations_new[i] = location
						else
							client.error_log("Failed to initialize editing location: " .. tostring(location))
						end
					else
						source_locations_new[i] = source_locations[i]
					end
				end

				if edit_location_selected == "create_new" and source_editing_modified["create_new"] ~= nil then
					local location = create_location(source_editing_modified[edit_location_selected])

					if type(location) == "table" then
						location.editing = source_editing and source_editing_has_changed[edit_location_selected]
						table.insert(source_locations_new, location)
					else
						client.error_log("Failed to initialize new editing location: " .. tostring(location))
					end
				end

				source_locations = source_locations_new
			end

			-- first create table of position_id -> locations
			for i=1, #source_locations do
				local location = source_locations[i]

				local include = false
				if location.type == "grenade" then
					if location.tickrates[tickrate] ~= nil then
						for i=1, #location.weapons do
							local weapon_name = GRENADE_WEAPON_NAMES_UI[location.weapons[i]]
							if types_enabled:get(weapon_name) then
								include = true
							end
						end
					end
				elseif location.type == "movement" then
					if types_enabled:get("Movement") then
						include = true
					end
				else
					error("not yet implemented: " .. location.type)
				end

				if include and location.weapons_assoc[weapon] then
					local location_set = active_locations[location.position_id]
					if location_set == nil then
						location_set = {
							position=location.position,
							position_approach=location.position,
							position_visibility=location.position_visibility,
							visible_alpha = 0,
							distance_alpha = 0,
							distance_width_mp = 0,
							in_range_draw_mp = 0,
							position_world_bottom = location.position+POSITION_WORLD_OFFSET,
						}
						active_locations[location.position_id] = location_set
					end

					location.in_fov_select_mp = 0
					location.in_fov_mp = 0
					location.on_screen_mp = 0
					table.insert(location_set, location)

					location.set = location_set

					-- if this location has a custom position_visibility, it overrides the location set's one
					if location.position_visibility_different then
						location_set.position_visibility = location.position_visibility
					end

					if location.duckamount ~= 1 then
						location_set.has_only_duck = false
					elseif location.duckamount == 1 and location_set.has_only_duck == nil then
						location_set.has_only_duck = true
					end

					-- if this location has approach_accurate set, set it for the whole location set
					if location.approach_accurate ~= nil then
						if location_set.approach_accurate == nil or location_set.approach_accurate == location.approach_accurate then
							location_set.approach_accurate = location.approach_accurate
						else
							-- todo: better warning here
							client.error_log("approach_accurate conflict found")
						end
					end
				end
			end
		end
	end

	-- combines nearby positions
	local count = 0

	for key, value in pairs(active_locations) do
		if key > count then
			count = key
		end
	end

	for position_id_1=1, count do
		local locations_1 = active_locations[position_id_1]

		-- can be nil if location was already merged
		if locations_1 ~= nil then
			local pos_1 = locations_1.position

			-- loop from current index to end, to avoid checking locations we already checked (just different order)
			for position_id_2=position_id_1+1, count do
				local locations_2 = active_locations[position_id_2]

				-- can be nil if location was already merged
				if locations_2 ~= nil then
					local pos_2 = locations_2.position

					if pos_1:dist_to_sqr(pos_2) < MAX_DIST_COMBINE_SQR then
						-- the position with more locations is seen as the main one
						-- the other one is deleted and all locations are inserted into the main one
						local main = #locations_2 > #locations_1 and position_id_2 or position_id_1
						local other = main == position_id_1 and position_id_2 or position_id_1

						-- copy over locations
						local main_locations = active_locations[main]
						local other_locations = active_locations[other]

						if main_locations ~= nil and other_locations ~= nil then
							local main_count = #main_locations
							for i=1, #other_locations do
								local location = other_locations[i]
								main_locations[main_count+i] = location

								location.set = main_locations

								if location.duckamount ~= 1 then
									main_locations.has_only_duck = false
								elseif location.duckamount == 1 and main_locations.has_only_duck == nil then
									main_locations.has_only_duck = true
								end
							end

							-- print("combining:")
							-- print(inspect(main_locations))
							-- print(inspect(other_locations))

							-- recompute location.position from location.positions
							local sum_x, sum_y, sum_z = 0, 0, 0
							local new_len = #main_locations
							for i=1, new_len do
								local position = main_locations[i].position
								sum_x = sum_x + position.x
								sum_y = sum_y + position.y
								sum_z = sum_z + position.z
							end
							main_locations.position = vector.new(sum_x/new_len, sum_y/new_len, sum_z/new_len)
							main_locations.position_world_bottom = main_locations.position+POSITION_WORLD_OFFSET

							-- delete other
							active_locations[other] = nil
						end
					end
				end
			end
		end
	end

	local sort_by_yaw_fn = function(a, b)
		return a.viewangles.yaw > b.viewangles.yaw
	end

	-- create dynamic per-position data
	for _, location_set in pairs(active_locations) do
		-- sort by yaw to make more right locations draw above
		if #location_set > 1 then
			table.sort(location_set, sort_by_yaw_fn)
		end

		-- figure out approach_accurate with a few traces
		if location_set.approach_accurate == nil then
			local count_accurate_move = 0

			-- go through all directions
			for i=1, #approach_accurate_OFFSETS_END do
				if count_accurate_move > 1 then
					break
				end

				-- set offset added to start for this direction
				local end_offset = approach_accurate_OFFSETS_END[i]

				-- loop through all start points
				for i=1, #approach_accurate_OFFSETS_START do
					local start = location_set.position + approach_accurate_OFFSETS_START[i]
					local start_x, start_y, start_z = start:unpack()

					local target = start + end_offset
					local target_x, target_y, target_z = target:unpack()
					-- client.draw_debug_text(start_x, start_y, start_z, 0, 5, 255, 255, 255, 255, "S", i)
					
					local traced_line = trace.line(vec3_t(start_x, start_y, start_z), vec3_t(target_x, target_y, target_z), local_player)
					local fraction, entindex_hit = traced_line.fraction, traced_line.entity == nil and -1 or traced_line.entity:get_index()
					local end_pos = start + end_offset
					-- client.draw_debug_text(target_x, target_y, target_z, 0, 5, 255, 255, 255, 255, "E", i)

					if entindex_hit == 0 and fraction > 0.45 and fraction < 0.6 then
						count_accurate_move = count_accurate_move + 1
						-- client.draw_debug_text(target_x, target_y, target_z, 1, 5, 0, 255, 0, 100, "HIT ", fraction)
						break
					end
				end
			end

			-- client.draw_debug_text(location.pos.x, location.pos.y, location.pos.z, 0, 5, 255, 255, 255, 255, "hit ", count_accurate_move, " times")
			location_set.approach_accurate = count_accurate_move > 1
		end
	end
end

-- playback variables
local playback_state, playback_begin, playback_sensitivity_set, playback_weapon-- , playback_data.start_at, playback_weapon, playback_data.recovery_start_at, playback_data.throw_at, playback_data.thrown_at, playback_sensitivity_set
local playback_data = {}

-- restore disabled menu elements
local ui_restore = {}

local function restore_disabled()
	for key, value in pairs(ui_restore) do
		key:set(value)
	end

	if playback_sensitivity_set then
		--cvars.sensitivity:set_float(tonumber(cvars.sensitivity:get_string()))
		playback_sensitivity_set = nil
	end

	table_clear(ui_restore)
end

local movetype_prev, waterlevel_prev
local function on_paint()
	if not enabled_reference:get() then
		return
	end

	-- these variables are set every paint, so if we ever early return here or something, make sure to reset them
	location_set_closest = nil
	location_selected = nil

	local local_player = entity_list.get_local_player()
	if local_player == nil then
		active_locations = nil

		if location_playback ~= nil then
			location_playback = nil
			restore_disabled()
		end

		return
	end

	local weapon_entindex = local_player:get_active_weapon()
	if weapon_entindex == nil then
		active_locations = nil

		if location_playback ~= nil then
			location_playback = nil
			restore_disabled()
		end

		return
	end

	local weapon = weapons[weapon_entindex:get_weapon_data().console_name]
	if weapon == nil then
		active_locations = nil

		if location_playback ~= nil then
			location_playback = nil
			restore_disabled()
		end

		return
	end

	if WEAPON_ALIASES[weapon] ~= nil then
		weapon = WEAPON_ALIASES[weapon]
	end

	local weapon_changed = weapon_prev ~= weapon
	if weapon_changed then
		active_locations = nil
		weapon_prev = weapon
	end

	local dpi_scale = 1

	local hotkey = hotkey_reference:get()
	local aimbot = aimbot_reference:get()
	local aimbot_is_silent = aimbot == 3 or aimbot == 4 or (aimbot == 2 and aimbot_speed_reference:get() == 0)

	local screen_width, screen_height = render.get_screen_size().x, render.get_screen_size().y
	local min_height, max_height = math.floor(screen_height*0.012)*dpi_scale, screen_height*0.018*dpi_scale
	local realtime = global_vars.real_time()
	local frametime = global_vars.frame_time()

	local cam_pitch, cam_yaw = engine.get_view_angles().x, engine.get_view_angles().y
	local cam_pos = local_player:get_eye_position()
	cam_pos = vector.new(cam_pos.x, cam_pos.y, cam_pos.z)
	local cam_up = vector.new():init_from_angles(cam_pitch-90, cam_yaw)

	local local_origin = local_player:get_render_origin()
	local_origin = vector.new(local_origin.x, local_origin.y, local_origin.z)

	local position_world_top_offset = cam_up * POSITION_WORLD_TOP_SIZE

	local clr = color_reference:get()
	local r_m, g_m, b_m, a_m = clr.r, clr.g, clr.b, clr.a

	if location_playback ~= nil and (not hotkey or not local_player:is_alive() or local_player:get_prop("m_MoveType") == 8) then
		location_playback = nil
		restore_disabled()
	end

	if source_editing then
		on_paint_editing()
	end

	if active_locations == nil then
		benchmark:start("create active_locations")
		active_locations = {}
		active_locations_in_range = {}
		last_vischeck = 0

		-- create map_locations entry for this weapon
		if map_locations[weapon] == nil then
			populate_map_locations(local_player, weapon)
		else
			active_locations = map_locations[weapon]

			if weapon_changed then
				for _, location_set in pairs(active_locations) do
					location_set.visible_alpha = 0
					location_set.distance_alpha = 0
					location_set.distance_width_mp = 0
					location_set.in_range_draw_mp = 0

					for i=1, #location_set do
						location_set[i].set = location_set
					end
				end
			end
		end

		benchmark:finish("create active_locations")
	end

	if active_locations ~= nil then
		-- benchmark:start("[helper] frame")
		if realtime > last_vischeck+0.07 then
			table_clear(active_locations_in_range)
			last_vischeck = realtime

			for _, location_set in pairs(active_locations) do
				location_set.distsqr = local_origin:dist_to_sqr(location_set.position)
				location_set.in_range = location_set.distsqr <= MAX_DIST_ICON_SQR
				if location_set.in_range then
					location_set.distance = math.sqrt(location_set.distsqr)
					local sx, sy, sz = cam_pos:unpack()
					local traced_line = trace_line_debug(local_player, sx, sy, sz, location_set.position_visibility:unpack())
					local fraction, entindex_hit = traced_line.fraction, traced_line.entity

					location_set.visible = entindex_hit == -1 or fraction > 0.99
					location_set.in_range_text = location_set.distance <= MAX_DIST_TEXT

					table.insert(active_locations_in_range, location_set)
				else
					location_set.distance_alpha = 0
					location_set.in_range_text = false
					location_set.distance_width_mp = 0
				end
			end

			table.sort(active_locations_in_range, sort_by_distsqr)
		end

		if #active_locations_in_range == 0 then
			return
		end

		-- find any location sets that we're on and store closest one
		for i=1, #active_locations_in_range do
			local location_set = active_locations_in_range[i]

			if location_set_closest == nil or location_set.distance < location_set_closest.distance then
				location_set_closest = location_set
			end
		end

		-- override drawing if we're playing back a location
		local location_playback_set = location_playback ~= nil and location_playback.set or nil

		local closest_mp = 1
		if location_playback_set ~= nil then
			location_set_closest = location_playback_set
			closest_mp = 1
		elseif location_set_closest.distance < MAX_DIST_CLOSE then
			closest_mp = 0.4+easing.quad_in_out(location_set_closest.distance, 0, 0.6, MAX_DIST_CLOSE)
		else
			location_set_closest = nil
		end

		local behind_walls = behind_walls_reference:get()

		local boxes_drawn_aabb = {}
		for i=1, #active_locations_in_range do
			local location_set = active_locations_in_range[i]
			local is_closest = location_set == location_set_closest

			location_set.distance = local_origin:dist_to(location_set.position)
			location_set.distance_alpha = location_playback_set == location_set and 1 or easing.quart_out(1 - location_set.distance / MAX_DIST_ICON, 0, 1, 1)

			local display_full_width = location_set.in_range_text and (closest_mp > 0.5 or is_closest)
			if display_full_width and location_set.distance_width_mp < 1 then
				location_set.distance_width_mp = math.min(1, location_set.distance_width_mp + frametime*7.5)
			elseif not display_full_width and location_set.distance_width_mp > 0 then
				location_set.distance_width_mp = math.max(0, location_set.distance_width_mp - frametime*7.5)
			end
			local distance_width_mp = easing.quad_in_out(location_set.distance_width_mp, 0, 1, 1)

			local invisible_alpha = (behind_walls and location_set.distance_width_mp > 0) and 0.45 or 0
			local invisible_fade_mp = (behind_walls and location_set.distance_width_mp > 0 and not location_set.visible) and 0.33 or 1

			if (location_set.visible and location_set.visible_alpha < 1) or (location_set.visible_alpha < invisible_alpha) then
				location_set.visible_alpha = math.min(1, location_set.visible_alpha + frametime*5.5*invisible_fade_mp)
			elseif not location_set.visible and location_set.visible_alpha > invisible_alpha then
				location_set.visible_alpha = math.max(invisible_alpha, location_set.visible_alpha - frametime*7.5*invisible_fade_mp)
			end
			local visible_alpha = easing.sine_in_out(location_set.visible_alpha, 0, 1, 1) * (is_closest and 1 or closest_mp) * location_set.distance_alpha

			if not is_closest then
				location_set.in_range_draw_mp = 0
			end

			if visible_alpha > 0 then
				local position_bottom = location_set.position_world_bottom
				local wx_bot, wy_bot = render_world_to_screen(position_bottom:unpack())

				if wx_bot ~= nil then
					local wx_top, wy_top = render_world_to_screen((position_bottom + position_world_top_offset):unpack())

					if wx_top ~= nil then
						local width_text, height_text = 0, 0
						local lines = {}

						-- get text and its size
						for i=1, #location_set do
							local location = location_set[i]
							local name = location.name
							local r, g, b, a = r_m, g_m, b_m, a_m

							if location.editing then
								r, g, b = unpack(CLR_TEXT_EDIT)
							end

							table.insert(lines, {r, g, b, a, "d", name})
						end

						for i=1, #lines do
							local r, g, b, a, flags, text = unpack(lines[i])
							local line_size = render.get_text_size(fonts.verdana.default, text)
							local lw, lh = line_size.x, line_size.y
							lh = lh - 1
							if lw > width_text then
								width_text = lw
							end
							lines[i].y_o = height_text-1
							height_text = height_text + lh
							lines[i].width = lw
							lines[i].height = lh
						end

						if location_set.distance_width_mp < 1 then
							width_text = width_text * location_set.distance_width_mp
							height_text = math.max(lines[1] and lines[1].height or 0, height_text * math.min(1, location_set.distance_width_mp * 1))

							-- modify text and make it smaller
							for i=1, #lines do
								local r, g, b, a, flags, text = unpack(lines[i])

								for j=text:len(), 0, -1 do
									local text_modified = text:sub(1, j)
									local text_size = render.get_text_size(fonts.verdana.default, text_modified)
									local lw = text_size.x

									if width_text >= lw then
										-- got new text, update shit
										lines[i][6] = text_modified
										lines[i].width = lw
										break
									end
								end
							end
						end

						if location_set.distance_width_mp > 0 then
							width_text = width_text + 2
						else
							width_text = 0
						end

						-- get icon
						local wx_icon, wy_icon, width_icon, height_icon, width_icon_orig, height_icon_orig
						local icon

						local location = location_set[1]
						if location.type == "movement" and location.weapons[1].type ~= "grenade" then
							icon = CUSTOM_ICONS.bhop
						else
							icon = WEAPON_ICONS[location_set[1].weapons[1]]
						end

						local ox, oy, ow, oh
						if icon ~= nil then
							ox, oy, ow, oh = unpack(WEPAON_ICONS_OFFSETS[icon])
							local _height = math.min(max_height, math.max(min_height, height_text+2, math.abs(wy_bot-wy_top)))
							width_icon_orig, height_icon_orig = icon:measure(nil, _height)
							-- wx_icon, wy_icon = wx_bot-width_icon/2, wy_top+(wy_bot-wy_top)/2-_height/2

							ox = ox * width_icon_orig
							oy = oy * height_icon_orig
							width_icon = width_icon_orig + ow * width_icon_orig
							height_icon = height_icon_orig + oh * height_icon_orig
						end

						-- got all the width's, calculate our topleft position
						local full_width, full_height = width_text, height_text
						if width_icon ~= nil then
							full_width = full_width+(location_set.distance_width_mp*8*dpi_scale)+width_icon
							full_height = math.max(height_icon, height_text)
						else
							full_height = math.max(math.floor(15*dpi_scale), height_text)
						end

						local wx_topleft, wy_topleft = math.floor(wx_top-full_width/2), math.floor(wy_bot-full_height)

						for i=1, #boxes_drawn_aabb do
							local x2, y2, w2, h2 = unpack(boxes_drawn_aabb[i])

							-- while wx_topleft < x2+w2 and x2 < wx_bot and wy_topleft < y2+h2 and y2 < wy_bot do
							-- 	wy_bot = wy_bot-1
							-- 	wy_topleft = wy_topleft-1
							-- end

							-- if wx_topleft < x2+w2 and x2 < wx_bot and wy_topleft < y2+h2 and y2 < wy_bot then
							-- 	visible_alpha = visible_alpha * 0.1
							-- end
						end

						if width_icon ~= nil then
							wx_icon = wx_bot-full_width/2+ox
							wy_icon = wy_bot-full_height+oy

							if height_text > height_icon then
								wy_icon = wy_icon + (height_text-height_icon)/2
							end
						end

						render.push_alpha_modifier(visible_alpha)
						render.rect_filled(vec2_t(wx_topleft-2, wy_topleft-2), vec2_t(full_width+4, full_height+4), color_t(16, 16, 16, 180))
						render.rect(vec2_t(wx_topleft-3, wy_topleft-3), vec2_t(full_width+6, full_height+6), color_t(16, 16, 16, 170))
						render.rect(vec2_t(wx_topleft-4, wy_topleft-4), vec2_t(full_width+8, full_height+8), color_t(16, 16, 16, 195))
						render.rect(vec2_t(wx_topleft-5, wy_topleft-5), vec2_t(full_width+10, full_height+10), color_t(16, 16, 16, 40))
						render.pop_alpha_modifier()

						local r_m, g_m, b_m = r_m, g_m, b_m
						if location_set[1].editing and #location_set == 1 then
							r_m, g_m, b_m = unpack(CLR_TEXT_EDIT)
						end

						if location_set.distance_width_mp > 0 then
							if width_icon ~= nil then
								-- draw divider
								render.push_alpha_modifier(visible_alpha)
								render.rect_filled(vec2_t(wx_topleft+width_icon+3, wy_topleft+2), vec2_t(1, full_height-3), color_t(r_m, g_m, b_m, a_m))
								render.pop_alpha_modifier()
							end

							-- draw text lines vertically centered
							local wx_text, wy_text = wx_topleft+(width_icon == nil and 0 or width_icon+8*dpi_scale), wy_topleft
							if full_height > height_text then
								wy_text = wy_text + math.floor((full_height-height_text) / 2)
							end

							for i=1, #lines do
								local r, g, b, a, flags, text = unpack(lines[i])
								local _x, _y = wx_text, wy_text+lines[i].y_o

								if lines[i].y_o+lines[i].height-4 > height_text then
									break
								end

								render.push_alpha_modifier(visible_alpha)
								render.text(fonts.verdana.default, text, vec2_t(_x, _y), color_t(r, g, b, a))
								render.pop_alpha_modifier()
							end
						end

						-- draw icon
						if icon ~= nil then
							local outline_size = math.min(2, full_height*0.03)

							local outline_a_mp = 1
							if outline_size > 0.6 and outline_size < 1 then
								outline_a_mp = (outline_size-0.6)/0.4
								outline_size = 1
							else
								outline_size = math.floor(outline_size)
							end

							local outline_r, outline_g, outline_b, outline_a = 0, 0, 0, 80
							local outline_mod = outline_a_mp
							if outline_size > 0 then
								render.push_alpha_modifier(visible_alpha)
								icon:draw(wx_icon-outline_size, wy_icon, width_icon_orig, height_icon_orig, outline_r, outline_g, outline_b, outline_a, true)
								icon:draw(wx_icon+outline_size, wy_icon, width_icon_orig, height_icon_orig, outline_r, outline_g, outline_b, outline_a, true)
								icon:draw(wx_icon, wy_icon-outline_size, width_icon_orig, height_icon_orig, outline_r, outline_g, outline_b, outline_a, true)
								icon:draw(wx_icon, wy_icon+outline_size, width_icon_orig, height_icon_orig, outline_r, outline_g, outline_b, outline_a, true)
								render.pop_alpha_modifier()
							end

							-- renderer.rectangle(wx_icon, wy_icon, width_icon, height_icon, 255, 0, 0, 180)
							render.push_alpha_modifier(visible_alpha)
							icon:draw(wx_icon, wy_icon, width_icon_orig, height_icon_orig, r_m, g_m, b_m, a_m, true)
							render.pop_alpha_modifier()

							-- local o = client.random_int(-10, 10)
							-- renderer.line(wx+o, wy, wx_top+o, wy_top, 255, 0, 0, 255)
						end

						-- renderer.line(wx_top, wy_top, wx_bot, wy_bot, 255, 0, 0, 255)
						-- renderer.text(wx_top, wy_top-6, 255, 0, 0, 255, "c", 0, math.abs(wy_bot-wy_top))

						table.insert(boxes_drawn_aabb, {wx_topleft-10, wy_topleft-10, full_width+10, full_height+10})
					end
				end
			end
		end

		if location_set_closest ~= nil then
			if location_set_closest.distance == nil then
				location_set_closest.distance = local_origin:dist_to(location_set_closest.position)
			end
			local in_range_draw = location_set_closest.distance < MAX_DIST_CLOSE_DRAW

			if location_set_closest == location_playback_set then
				location_set_closest.in_range_draw_mp = 1
			elseif in_range_draw and location_set_closest.in_range_draw_mp < 1 then
				location_set_closest.in_range_draw_mp = math.min(1, location_set_closest.in_range_draw_mp + frametime*8)
			elseif not in_range_draw and location_set_closest.in_range_draw_mp > 0 then
				location_set_closest.in_range_draw_mp = math.max(0, location_set_closest.in_range_draw_mp - frametime*8)
			end

			if location_set_closest.in_range_draw_mp > 0 then
				local matrix = native_GetWorldToScreenMatrix()

				-- find selected location (closest to crosshair and in fov)
				local location_closest
				for i=1, #location_set_closest do
					local location = location_set_closest[i]

					if location.viewangles_target ~= nil then
						local pitch, yaw = location.viewangles.pitch, location.viewangles.yaw
						local dp, dy = normalize_angles(cam_pitch - pitch, cam_yaw - yaw)
						location.viewangles_dist = math.sqrt(dp*dp + dy*dy)

						if location_closest == nil or location_closest.viewangles_dist > location.viewangles_dist then
							location_closest = location
						end

						if aimbot == 2 or (aimbot == 3 and location.type == "movement") then
							location.is_in_fov_select = location.viewangles_dist <= aimbot_fov_reference:get()*0.1
						else
							location.is_in_fov_select = location.viewangles_dist <= (location.fov_select or aimbot == 4 and DEFAULTS.select_fov_rage or DEFAULTS.select_fov_legit)
						end

						local dist = local_origin:dist_to(location.position)
						local dist2d = local_origin:dist_to_2d(location.position)
						if dist2d < 1.5 then
							dist = dist2d
						end

						-- if hotkey then
						-- 	print(local_origin)
						-- 	print(location.position)
						-- 	print(dist)
						-- 	print(dist2d)
						-- end

						location.is_position_correct = dist < MAX_DIST_CORRECT and local_player:get_prop("m_flDuckAmount") == location.duckamount

						-- print(globals.realtime())
						-- print(location.duckamount)
						-- print(entity.get_prop(local_player, "m_flDuckAmount"))
						-- print(location_set_closest.distance)
						-- print(location_set_closest.distance < MAX_DIST_CORRECT)
						-- print(entity.get_prop(local_player, "m_flDuckAmount") == location.duckamount)
						-- print(location.is_position_correct)

						if location.fov ~= nil then
							location.is_in_fov = location.is_in_fov_select and ((not (location.type == "movement" and aimbot == 3) and aimbot_is_silent) or location.viewangles_dist <= location.fov)
						end
					end
				end

				-- local visible_alpha = easing.sine_in_out(location_set.visible_alpha, 0, 1, 1) * (is_closest and 1 or closest_mp)

				local in_range_draw_mp = easing.cubic_in(location_set_closest.in_range_draw_mp, 0, 1, 1)

				for i=1, #location_set_closest do
					local location = location_set_closest[i]

					if location.viewangles_target ~= nil then
						local is_closest = location == location_closest
						local is_selected = is_closest and location.is_in_fov_select
						local is_in_fov = is_selected and location.is_in_fov

						-- determine distance based multiplier
						local in_fov_select_mp = 1
						if location.is_in_fov_select ~= nil then
							if is_selected and location.in_fov_select_mp < 1 then
								location.in_fov_select_mp = math.min(1, location.in_fov_select_mp + frametime*2.5*(is_in_fov and 2 or 1))
							elseif not is_selected and location.in_fov_select_mp > 0 then
								location.in_fov_select_mp = math.max(0, location.in_fov_select_mp - frametime*4.5)
							end

							in_fov_select_mp = location.in_fov_select_mp
						end

						-- determine if we pass the fov check (for legit)
						local in_fov_mp = 1
						if location.is_in_fov ~= nil then
							if is_in_fov and location.in_fov_mp < 1 then
								location.in_fov_mp = math.min(1, location.in_fov_mp + frametime*6.5)
							elseif not is_in_fov and location.in_fov_mp > 0 then
								location.in_fov_mp = math.max(0, location.in_fov_mp - frametime*5.5)
							end

							in_fov_mp = (location.is_position_correct or location == location_playback) and location.in_fov_mp or location.in_fov_mp * 0.5
						end

						if is_selected then
							location_selected = location
						end

						local t_x, t_y, t_z = location.viewangles_target:unpack()
						local wx, wy, on_screen = world_to_screen_offscreen_rect(t_x, t_y, t_z, matrix, screen_width, screen_height, 40)

						if wx ~= nil then
							wx, wy = math.floor(wx+0.5), math.floor(wy+0.5)

							-- local _wx, _wy = wx, wy

							if on_screen and location.on_screen_mp < 1 then
								location.on_screen_mp = math.min(1, location.on_screen_mp + frametime*3.5)
							elseif not on_screen and location.on_screen_mp > 0 then
								location.on_screen_mp = math.max(0, location.on_screen_mp - frametime*4.5)
							end

							local visible_alpha = (0.5 + location.on_screen_mp * 0.5) * in_range_draw_mp

							local name = "»" .. location.name
							local description

							local title_size = render.get_text_size(fonts.verdana.bold, name)
							local title_width, title_height = title_size.x, title_size.y
							local description_width, description_height = 0, 0

							if location.description ~= nil then
								description = location.description:upper():gsub(" ", "  ")
								local description_size = render.get_text_size(fonts.small.default, description .. " ")

								description_width, description_height = description_size.x, description_size.y
								description_width = description_width
							end
							local extra_target_width = math.floor(description_height/2)
							extra_target_width = extra_target_width - extra_target_width % 2

							local full_width, full_height = math.max(title_width, description_width), title_height+description_height

							local r_m, g_m, b_m = r_m, g_m, b_m

							if location.editing then
								r_m, g_m, b_m = unpack(CLR_TEXT_EDIT)
							end

							local circle_size = math.floor(title_height / 2 - 1) * 2
							local target_size = 0
							if location.on_screen_mp > 0 then
								target_size = math.floor((circle_size + 8*dpi_scale) * location.on_screen_mp) + extra_target_width

								full_width = full_width + target_size
							end

							wx, wy = wx-circle_size/2-extra_target_width/2, wy-full_height/2

							-- adjust if offscreen to the right
							local wx_topleft = math.min(wx, screen_width-40-full_width)
							local wy_topleft = wy

							-- draw background

							local background_mp = easing.sine_out(visible_alpha, 0, 1, 1)

							render.push_alpha_modifier(background_mp)
							render.rect_filled(vec2_t(wx_topleft-2, wy_topleft-2), vec2_t(full_width+4, full_height+4), color_t(16, 16, 16, 150))
							render.rect(vec2_t(wx_topleft-3, wy_topleft-3), vec2_t(full_width+6, full_height+6), color_t(16, 16, 16, 170))
							render.rect(vec2_t(wx_topleft-4, wy_topleft-4), vec2_t(full_width+8, full_height+8), color_t(16, 16, 16, 195))
							render.rect(vec2_t(wx_topleft-5, wy_topleft-5), vec2_t(full_width+10, full_height+10), color_t(16, 16, 16, 40))
							render.pop_alpha_modifier()

							if not on_screen then
								local triangle_alpha = 1 - location.on_screen_mp

								if triangle_alpha > 0 then
									local cx, cy = screen_width/2, screen_height/2

									local angle = math.atan2(wy_topleft+full_height/2-cy, wx_topleft+full_width/2-cx)
									local triangle_angle = angle+math.rad(90)
									local offset_x, offset_y = vector2_rotate(triangle_angle, 0, -screen_height/2+100)

									local tx, ty = screen_width/2+offset_x, screen_height/2+offset_y

									local dist_triangle_text = vector2_dist(tx, ty, wx_topleft+full_width/2, wy_topleft+full_height/2)
									local dist_center_triangle = vector2_dist(tx, ty, cx, cy)
									local dist_center_text = vector2_dist(cx, cy, wx_topleft+full_width/2, wy_topleft+full_height/2)

									local a_mp_dist = 1
									if 40 > dist_triangle_text then
										a_mp_dist = (dist_triangle_text-30)/10
									end

									if dist_center_text > dist_center_triangle and a_mp_dist > 0 then
										local height = math.floor(title_height*1.5)

										local realtime_alpha_mp = 0.2 + math.abs(math.sin(global_vars.real_time()*math.pi*0.8 + i * 0.1)) * 0.8

										render.push_alpha_modifier(math.min(1, visible_alpha*1.5)*triangle_alpha*a_mp_dist*realtime_alpha_mp)
										triangle_rotated(tx, ty, height*1.66, height, triangle_angle, r_m, g_m, b_m, a_m)
										render.pop_alpha_modifier()
									end
								end
							end

							if location.on_screen_mp > 0.5 and in_range_draw_mp > 0 then
								-- in_fov_select_mp
								-- CIRCLE_GREEN_R

								local c_a = 255
								local red_r, red_g, red_b = 255, 10, 10
								local green_r, green_g, green_b = 20, 236, 0
								local white_r, white_g, white_b = 140, 140, 140

								-- fade from red to green based on selection
								local sel_r, sel_g, sel_b = lerp_color(red_r, red_g, red_b, 0, green_r, green_g, green_b, 0, in_fov_mp)

								-- fade from white to red/green
								local c_r, c_g, c_b = lerp_color(white_r, white_g, white_b, 0, sel_r, sel_g, sel_b, 0, in_fov_select_mp)

								local c_x, c_y = wx+circle_size/2 + extra_target_width/2, wy+full_height/2
								local c_radius = circle_size/2

								-- outline
								local mod = 1*in_range_draw_mp*easing.expo_in(location.on_screen_mp, 0, 1, 1)
								render.push_alpha_modifier(mod*0.6)
								render.circle(vec2_t(c_x, c_y), c_radius+1, color_t(16, 16, 16, c_a))
								render.pop_alpha_modifier()
	
								-- circle
								render.push_alpha_modifier(mod)
								render.circle_filled(vec2_t(c_x, c_y), c_radius, color_t(c_r, c_g, c_b, c_a))
								render.pop_alpha_modifier()

								-- gradient (kind of)
								render.push_alpha_modifier(mod*0.3)
								render.circle(vec2_t(c_x, c_y), c_radius+1, color_t(16, 16, 16, c_a))
								render.pop_alpha_modifier()

								render.push_alpha_modifier(mod*0.2)
								render.circle(vec2_t(c_x, c_y), c_radius, color_t(16, 16, 16, c_a))
								render.pop_alpha_modifier()

								render.push_alpha_modifier(mod*0.1)
								render.circle(vec2_t(c_x, c_y), c_radius-1, color_t(16, 16, 16,c_a))
								render.pop_alpha_modifier()

								-- -- crosshair
								-- render.rect_filled(vec2_t(wx-1, wy-5), vec2_t(2, 10), vec2_t(0, 0, 0, math.floor(120*in_fov_select_mp)))
								-- render.rect_filled(vec2_t(wx-5, wy-1), vec2_t(4, 2), vec2_t(0, 0, 0, math.floor(120*in_fov_select_mp)))
								-- render.rect_filled(vec2_t(wx+1, wy-1), vec2_t(4, 2), vec2_t(0, 0, 0, math.floor(120*in_fov_select_mp)))
							end
							-- divider
							if target_size > 1 then
								render.push_alpha_modifier(visible_alpha*location.on_screen_mp)
								render.rect_filled(vec2_t(wx_topleft+target_size-4*dpi_scale, wy_topleft+1), vec2_t(1, full_height-1), color_t(r_m, g_m, b_m, a_m))
								render.pop_alpha_modifier()
							end

							-- text
							render.push_alpha_modifier(visible_alpha)
							render.text(fonts.verdana.bold, name, vec2_t(wx_topleft+target_size, wy), color_t(r_m, g_m, b_m, a_m))
							render.pop_alpha_modifier()

							if description ~= nil then
								render.push_alpha_modifier(visible_alpha*0.92)
								local d_r, d_g, d_b, d_a = math.floor(math.min(255, r_m*1.2)), math.floor(math.min(255, g_m*1.2)), math.floor(math.min(255, b_m*1.2)), a_m
								render.text(fonts.small.default, description, vec2_t(wx_topleft+target_size, wy+title_height), color_t(d_r, d_g, d_b, d_a))
								render.pop_alpha_modifier()
							end

							-- renderer.rectangle(_wx-2, _wy-2, 4, 4, 255, 255, 255, 255)
						end
					end
				end			
			end
		end

		-- run smooth aimbot in paint
		if hotkey and location_selected ~= nil and ((location_selected.type == "movement" and aimbot ~= 4) or (location_selected.type ~= "movement" and aimbot == 2)) then
			if (not location_selected.is_in_fov or location_selected.viewangles_dist > 0.1) then
				local speed = aimbot_speed_reference:get()/100

				if speed == 0 then
					if location_selected.type == "grenade" and local_player:get_active_weapon():get_prop("m_bPinPulled") == 1 then
						-- local aim_pitch, aim_yaw = location_selected.viewangles.pitch, location_selected.viewangles.yaw
						engine.set_view_angles(angle_t(location_selected.viewangles.pitch, location_selected.viewangles.yaw, 0))
					end
				else
					local aim_pitch, aim_yaw = location_selected.viewangles.pitch, location_selected.viewangles.yaw
					local dp, dy = normalize_angles(cam_pitch - aim_pitch, cam_yaw - aim_yaw)

					local dist = location_selected.viewangles_dist
					dp = dp / dist
					dy = dy / dist

					local mp = math.min(1, dist/3)*0.5
					local delta_mp = (mp + math.abs(dist*(1-mp)))*global_vars.frame_time()*15*speed

					local pitch = cam_pitch - dp*delta_mp*client.random_float(0.7, 1.2)
					local yaw = cam_yaw - dy*delta_mp*client.random_float(0.7, 1.2)

					engine.set_view_angles(angle_t(pitch, yaw, 0))
				end
			end
		end

		-- benchmark:finish("[helper] frame")
	end
end

local function cmd_remove_user_input(cmd)
	cmd:remove_button(e_cmd_buttons.FORWARD)
	cmd:remove_button(e_cmd_buttons.BACK)
	cmd:remove_button(e_cmd_buttons.MOVELEFT)
	cmd:remove_button(e_cmd_buttons.MOVERIGHT)

	cmd.move.x = 0
	cmd.move.y = 0

	cmd:remove_button(e_cmd_buttons.JUMP)
	cmd:remove_button(e_cmd_buttons.SPEED)
end

local function cmd_location_playback_grenade(cmd, local_player, weapon)
	local tickrate = 1/global_vars.interval_per_tick()
	local tickrate_mp = location_playback.tickrates[tickrate]

	if playback_state == nil then
		playback_state = GRENADE_PLAYBACK_PREPARE
		table_clear(playback_data)

		-- playback_data = {}
		-- playback_data.start_at = nil
		-- playback_data.recovery_start_at = nil
		-- playback_data.throw_at = nil
		-- playback_data.thrown_at = nil

		local aimbot = aimbot_reference:get()
		if aimbot == 2 or aimbot == 1 then
			--cvars.sensitivity:set_float(0)
			playback_sensitivity_set = true
		end

		local begin = playback_begin

		client.delay_call(function()
			if location_playback ~= nil and playback_begin == begin then
				client.error_log("[helper] playback timed out")

				location_playback = nil
				restore_disabled()
			end
		end, (location_playback.run_duration or 0)*tickrate_mp*2+2)
	end

	if weapon ~= playback_weapon and playback_state ~= GRENADE_PLAYBACK_FINISHED then
		location_playback = nil

		restore_disabled()

		return
	end

	local move_yaw = vec2_t(0, 0)
	if playback_state ~= GRENADE_PLAYBACK_FINISHED then
		cmd_remove_user_input(cmd, location_playback)

		if (location_playback.duckamount == 1) then
			cmd:add_button(e_cmd_buttons.DUCK)
		end

        local movedirection = location_playback.run_yaw
        local angle = vector.new():init_from_angles(0, engine.get_view_angles().y - movedirection)

       	move_yaw.x = angle.x
        move_yaw.y = angle.y
	elseif playback_sensitivity_set then
		--cvars.sensitivity:set_float(tonumber(cvars.sensitivity:get_string()))
		playback_sensitivity_set = nil
	end

	-- prepare for the playback, here we make sure we have the right throwstrength etc
	if playback_state == GRENADE_PLAYBACK_PREPARE or playback_state == GRENADE_PLAYBACK_RUN or playback_state == GRENADE_PLAYBACK_THROWN then
		if location_playback.throw_strength == 1 then
			cmd:add_button(e_cmd_buttons.ATTACK)
			cmd:remove_button(e_cmd_buttons.ATTACK2)
		elseif location_playback.throw_strength == 0.5 then
			cmd:add_button(e_cmd_buttons.ATTACK)
			cmd:add_button(e_cmd_buttons.ATTACK2)
		elseif location_playback.throw_strength == 0 then
			cmd:remove_button(e_cmd_buttons.ATTACK)
			cmd:add_button(e_cmd_buttons.ATTACK2)
		end
	end

	-- check if we have the right throwstrength and go to next state
	if playback_state == GRENADE_PLAYBACK_PREPARE and weapon:get_prop("m_flThrowStrength") == location_playback.throw_strength then
		playback_state = GRENADE_PLAYBACK_RUN
		playback_data.start_at = cmd.command_number
	end

	if playback_state == GRENADE_PLAYBACK_RUN or playback_state == GRENADE_PLAYBACK_THROW or playback_state == GRENADE_PLAYBACK_THROWN then
		local step = cmd.command_number-playback_data.start_at

		if location_playback.run_duration ~= nil and location_playback.run_duration*tickrate_mp > step then
		elseif playback_state == GRENADE_PLAYBACK_RUN then
			playback_state = GRENADE_PLAYBACK_THROW
		end

		if location_playback.run_duration ~= nil then
			cmd.move.x = 450 * move_yaw.x
			cmd.move.y = 450 * move_yaw.y
			cmd:add_button(e_cmd_buttons.FORWARD)

			if location_playback.run_speed then
				cmd:add_button(e_cmd_buttons.SPEED)
			end

			if aa_pitch_reference:get() ~= 1 then
				waterlevel_prev = local_player:get_prop("m_nWaterLevel")
				local_player:set_prop("m_nWaterLevel", 2)

				movetype_prev = local_player:get_prop("m_MoveType")
				local_player:set_prop("m_MoveType", 1)
			end
		end
	end

	if playback_state == GRENADE_PLAYBACK_THROW then
		if location_playback.jump then
			cmd:add_button(e_cmd_buttons.JUMP)
		end

		playback_state = GRENADE_PLAYBACK_THROWN
		playback_data.throw_at = cmd.command_number
	end

	if playback_state == GRENADE_PLAYBACK_THROWN then
		--[[local pulled = weapon:get_prop("m_bPinPulled")
		local throw_time = weapon:get_prop("m_fThrowTime")

		print("time since start: ", cmd.command_number - playback_data.throw_at)
		print("throw_time: ", playback_data.throw_at)
		print("pulled: ", pulled)]]
		
		if cmd.command_number-1 - playback_data.throw_at >= location_playback.delay then
			cmd:remove_button(e_cmd_buttons.ATTACK)
			cmd:remove_button(e_cmd_buttons.ATTACK2)
		end
	end

	if playback_state == GRENADE_PLAYBACK_FINISHED then
		if location_playback.jump then
			local onground = local_player:has_player_flag(e_player_flags.ON_GROUND)
			
			if onground then
				-- print("was onground at ", globals.tickcount())
				playback_state = nil
				location_playback = nil

				restore_disabled()
			else
				local aimbot = aimbot_reference:get()

				-- recovery strafe after throw
				if aimbot == 4 and not cmd:has_button(e_cmd_buttons.FORWARD) and not cmd:has_button(e_cmd_buttons.BACK) and 
				not cmd:has_button(e_cmd_buttons.MOVELEFT) and not cmd:has_button(e_cmd_buttons.MOVERIGHT) and not cmd:has_button(e_cmd_buttons.JUMP) then
					cmd_remove_user_input(cmd)

			        local movedirection = location_playback.recovery_yaw or location_playback.run_yaw-180
		        	local angle = vector.new():init_from_angles(0, engine.get_view_angles().y - movedirection)

		        	move_yaw.x = angle.x
		        	move_yaw.y = angle.y

					cmd.move.x = 450 * move_yaw.x
					cmd.move.y = 450 * move_yaw.y
					cmd:add_button(e_cmd_buttons.FORWARD)

					if location_playback.recovery_jump then
						cmd:add_button(e_cmd_buttons.JUMP)
					else
						cmd:remove_button(e_cmd_buttons.JUMP)
					end
				end
				-- turn airstrafe back on
				if ui_restore[airstrafe_reference] then
					ui_restore[airstrafe_reference] = nil

					-- either enable it next frame or in a bit of time, depending on magic number
					client.delay_call(function()
						airstrafe_reference:set(true)
					end, cvars.sv_airaccelerate:get_float() > 50 and 0 or 0.05)
				end
			end
		elseif location_playback.recovery_yaw ~= nil then
				local aimbot = aimbot_reference:get()
				if aimbot == 4 and not cmd:has_button(e_cmd_buttons.FORWARD) and not cmd:has_button(e_cmd_buttons.BACK) and 
				not cmd:has_button(e_cmd_buttons.MOVELEFT) and not cmd:has_button(e_cmd_buttons.MOVERIGHT) and not cmd:has_button(e_cmd_buttons.JUMP) then
				if playback_data.recovery_start_at == nil then
					playback_data.recovery_start_at = cmd.command_number
				end

				local recovery_duration = math.min(32, location_playback.run_duration or 16) + 13 + (location_playback.recovery_jump and 10 or 0)

				if playback_data.recovery_start_at+recovery_duration >= cmd.command_number then
			        local movedirection = location_playback.recovery_yaw
		        	local angle = vector.new():init_from_angles(0, engine.get_view_angles().y - movedirection)

		        	move_yaw.x = angle.x
		        	move_yaw.y = angle.y

					cmd.move.x = 450 * move_yaw.x
					cmd.move.y = 450 * move_yaw.y
					cmd:add_button(e_cmd_buttons.FORWARD)

					if location_playback.recovery_jump then
						cmd:add_button(e_cmd_buttons.JUMP)
					else
						cmd:remove_button(e_cmd_buttons.JUMP)
					end
				end
			else
				location_playback = nil

				restore_disabled()
			end
		end
	end

	if playback_state == GRENADE_PLAYBACK_THROWN then
		if location_playback.jump and airstrafe_reference:get() then
			ui_restore[airstrafe_reference] = true
			airstrafe_reference:set(false)
		end

		local aimbot = aimbot_reference:get()
		local throw_time = weapon:get_prop("m_fThrowTime")

		if is_grenade_being_thrown(weapon, cmd) then
			playback_data.thrown_at = cmd.command_number

			-- actually aim
			if aimbot == 3 or aimbot == 4 then
				cmd.viewangles = angle_t(location_playback.viewangles.pitch, location_playback.viewangles.yaw, 0)
			end

			-- just a little failsafe to make sure we turn stuff back on
			client.delay_call(restore_disabled, 0.8)
		elseif weapon:get_prop("m_fThrowTime") == 0 and playback_data.thrown_at ~= nil and playback_data.thrown_at > playback_data.throw_at then
			playback_state = GRENADE_PLAYBACK_FINISHED

			-- timeout incase user starts noclipping after throwing or something
			local begin = playback_begin
			client.delay_call(function()
				if playback_state == GRENADE_PLAYBACK_FINISHED and playback_begin == begin then
					location_playback = nil

					restore_disabled()
				end
			end, 0.6)
		end
	end
end

local function cmd_location_playback_movement(cmd, local_player, weapon)
	if playback_state == nil then
		playback_state = 1

		table_clear(playback_data)
		playback_data.start_at = cmd.command_number
		playback_data.last_offset_swap = 0
	end

	local is_grenade = location_playback.weapons[1].type == "grenade"
	local current_weapon = weapons[weapon:get_prop("m_iItemDefinitionIndex")]

	if weapon ~= playback_weapon and not (is_grenade and current_weapon.type == "knife") then
		location_playback = nil
		restore_disabled()
		return
	end

	local index = cmd.command_number-playback_data.start_at+1
	local command = location_playback.movement_commands[index]

	if command == nil then
		location_playback = nil
		restore_disabled()
		return
	end

	if airstrafe_reference:get() then
		ui_restore[airstrafe_reference] = true
		airstrafe_reference:set(false)
	end

	if infinite_duck_reference:get() then
		ui_restore[infinite_duck_reference] = true
		infinite_duck_reference:set(false)
	end

	local aimbot = aimbot_reference:get()
	local ignore_pitch_yaw = false--aimbot == 4
	local aa_enabled = aa_pitch_reference:get() ~= 1

	local onground = local_player:has_player_flag(e_player_flags.ON_GROUND)

	local origin = vector.from_vec(local_player:get_render_origin())
	local velocity = math.sqrt(math.pow(local_player:get_prop("m_vecVelocity[0]"), 2) + math.pow(local_player:get_prop("m_vecVelocity[1]"), 2))

	if aa_enabled then
		waterlevel_prev = local_player:get_prop("m_nWaterLevel")
		local_player:set_prop("m_nWaterLevel", 2)

		movetype_prev = local_player:get_prop("m_MoveType")
		local_player:set_prop("m_MoveType", 1)
	end

	for key, value in pairs(command) do
		local set_key = true

		if key == "pitch" or key == "yaw" then
			set_key = false
		elseif key == e_cmd_buttons.USE and value == false then
			set_key = false
		elseif key == e_cmd_buttons.ATTACK or key == e_cmd_buttons.ATTACK2 then
			if is_grenade and current_weapon.type == 9 then
				set_key = true
			elseif value == false then
				set_key = false
			end
		end

		if set_key then
            if key == "sidemove" then
                cmd.move.y = value
            elseif key == "forwardmove" then
                cmd.move.x = value
            --[[elseif key == "move_yaw" then
		        local movedirection = value
	        	local angle = vector.new():init_from_angles(0, engine.get_view_angles().y - movedirection)

	        	cmd.move.x = angle.x * 450
	        	cmd.move.y = angle.y * 450]]
            elseif type(key) == "number" then
            	if value then
	            	cmd:add_button(key)
	            else
	            	cmd:remove_button(key)
	            end
            end
		end
	end

	if aimbot == 4 and aa_enabled and (is_grenade or (not cmd:has_button(e_cmd_buttons.ATTACK) and not cmd:has_button(e_cmd_buttons.ATTACK2))) and (not is_grenade or (is_grenade and playback_data.thrown_at == nil)) then
		if cmd.command_number - playback_data.last_offset_swap > 16 then
			local _, target_yaw = normalize_angles(0, cmd:has_button(e_cmd_buttons.USE) and cmd.viewangles.y or cmd.viewangles.y - 180)
			playback_data.set_pitch = not cmd:has_button(e_cmd_buttons.USE)

			local min_diff, new_offset = 90
			-- find closest 90 deg offset of command.yaw to target_yaw
			for o=-180, 180, 90 do
				local _, command_yaw = normalize_angles(0, command.yaw+o)
				local diff = math.abs(command_yaw-target_yaw)

				if min_diff > diff then
					min_diff = diff
					new_offset = o
				end
			end

			if new_offset ~= playback_data.last_offset then
				if DEBUG then
					print("offset switched from ", playback_data.last_offset, " to ", new_offset)
				end
				playback_data.last_offset = new_offset
				playback_data.last_offset_swap = cmd.command_number
			end
		end

		if playback_data.last_offset ~= nil then
			cmd.viewangles.y = command.yaw + playback_data.last_offset

			if playback_data.set_pitch then
				cmd.viewangles.x = 89
			end
		end
	end

	if not ignore_pitch_yaw then
		engine.set_view_angles(angle_t(command.pitch, command.yaw, 0))

		if not aa_enabled then
			cmd.viewangles.x = command.pitch
			cmd.viewangles.y = command.yaw
		end

		playback_sensitivity_set = true
	elseif (is_grenade and current_weapon.type == 9) and aimbot == 4 and is_grenade_being_thrown(weapon, cmd) then
		cmd.viewangles.x = command.pitch
		cmd.viewangles.y = command.yaw

		playback_data.thrown_at = cmd.command_number
	end

	if DEBUG then
		print(string.format("cmd #%03d onground: %5s in_jump: %5s origin: %s velocity: %s", index, onground, cmd:has_button(e_cmd_buttons.JUMP), origin:to_vec(), velocity))
	end
end

local function cmd_location_playback(cmd, local_player, weapon)
	if location_playback.type == "grenade" then
		cmd_location_playback_grenade(cmd, local_player, weapon)
	elseif location_playback.type == "movement" then
		cmd_location_playback_movement(cmd, local_player, weapon)
	end
end

local function on_run_command(e)
	if not enabled_reference:get() then
		return
	end
	
	if movetype_prev ~= nil or waterlevel_prev ~= nil then
		local local_player = entity_list.get_local_player()

		if waterlevel_prev ~= nil then
			local_player:set_prop("m_nWaterLevel", waterlevel_prev)
			waterlevel_prev = false
		end

		if movetype_prev ~= nil then
			local_player:set_prop("m_MoveType", movetype_prev)
			movetype_prev = nil
		end
	end
end

local function on_setup_command(cmd)
	if not enabled_reference:get() then
		return
	end

	local local_player = entity_list.get_local_player()

	if local_player == nil then
		return
	end

	local local_origin = vector.from_vec(local_player:get_render_origin())
	local hotkey = hotkey_reference:get()
	local weapon = local_player:get_active_weapon()

	if hotkey then
		fast_stop_reference:set(false)
	else
		fast_stop_reference:set(true)
	end

	if location_playback ~= nil then
		local weapon = local_player:get_active_weapon()

		cmd_location_playback(cmd, local_player, weapon)
	elseif location_selected ~= nil and hotkey and location_selected.is_in_fov and location_selected.is_position_correct then
		local speed = math.sqrt(math.pow(local_player:get_prop("m_vecVelocity[0]"), 2) + math.pow(local_player:get_prop("m_vecVelocity[1]"), 2))
		local pin_pulled = weapon:get_prop("m_bPinPulled") == 1

		if location_selected.duckamount == 1 or location_set_closest.has_only_duck then
			cmd:add_button(e_cmd_buttons.DUCK)
		end

		local is_grenade = location_selected.weapons[1].type == "grenade"
		local is_in_attack = cmd:has_button(e_cmd_buttons.ATTACK) or cmd:has_button(e_cmd_buttons.ATTACK2)

		if (location_selected.type == "movement" and speed < 2 and (not is_grenade or is_in_attack))
		or (location_selected.type == "grenade" and hotkey and speed < 2)
		and location_selected.duckamount == local_player:get_prop("m_flDuckAmount") then
			location_playback = location_selected
			playback_state = nil
			playback_weapon = weapon
			playback_begin = cmd.command_number

			cmd_location_playback(cmd, local_player, weapon)
		elseif not pin_pulled and (cmd:has_button(e_cmd_buttons.ATTACK) or cmd:has_button(e_cmd_buttons.ATTACK2)) then
			-- just started holding attack for the first cmd, here we still have the chance to instantly go to the right throwstrength
			if location_selected.throw_strength == 1 then
				cmd:add_button(e_cmd_buttons.ATTACK)
				cmd:remove_button(e_cmd_buttons.ATTACK2)
			elseif location_selected.throw_strength == 0.5 then
				cmd:add_button(e_cmd_buttons.ATTACK)
				cmd:add_button(e_cmd_buttons.ATTACK2)
			elseif location_selected.throw_strength == 0 then
				cmd:remove_button(e_cmd_buttons.ATTACK)
				cmd:add_button(e_cmd_buttons.ATTACK2)
			end
		end
	elseif location_set_closest ~= nil and hotkey then
		-- move towards closest location set
		local target_position = (location_selected ~= nil and location_selected.is_in_fov) and location_selected.position or location_set_closest.position_approach
		local distance = local_origin:dist_to(target_position)
		local distance_2d = local_origin:dist_to_2d(target_position)

		if (distance_2d < 0.5 and distance > 0.08 and distance < 5) or (location_set_closest.inaccurate_position and distance < 40) then
			distance = distance_2d
		end

		if ((location_selected ~= nil and location_selected.duckamount == 1) or location_set_closest.has_only_duck) and distance < 10 then
			cmd:add_button(e_cmd_buttons.DUCK)
		end

		if cmd.move.x == 0 and cmd.move.y == 0 and not cmd:has_button(e_cmd_buttons.FORWARD) and not cmd:has_button(e_cmd_buttons.BACK) and not cmd:has_button(e_cmd_buttons.MOVERIGHT) and not cmd:has_button(e_cmd_buttons.MOVELEFT) then
			if distance < 32 and distance >= MAX_DIST_CORRECT*0.5 then
				local fwd1 = target_position - local_origin

				local pos1 = target_position + fwd1:normalized()*10

				local fwd = pos1 - local_origin
				local pitch, yaw = fwd:angles()

				if yaw == nil then
					return
				end

		        cmd:remove_button(e_cmd_buttons.SPEED)

		        local moved_speed = 0

		        if location_set_closest.approach_accurate then
		        	moved_speed = 450
		        else
		        	if distance > 14 then
		        		moved_speed = 450
		        	else
						local wishspeed = math.min(450, math.max(1.1+local_player:get_prop("m_flDuckAmount")*10, distance * 9))
						local vel = math.sqrt(math.pow(local_player:get_prop("m_vecVelocity[0]"), 2) + math.pow(local_player:get_prop("m_vecVelocity[1]"), 2))

						if vel >= math.min(250, wishspeed)+15 then
							moved_speed = 0
						else
							moved_speed = math.max(6, vel >= math.min(250, wishspeed) and wishspeed*0.9 or wishspeed)
						end
		        	end
		        end

		        local movedirection = yaw
		        local angle = vector.new():init_from_angles(0, engine.get_view_angles().y - movedirection)
		        cmd.move.x = angle.x * moved_speed
		        cmd.move.y = angle.y * moved_speed
			end
		end
	end
end

local function update_basic_ui()
	local enabled = enabled_reference:get()

	types_reference:set_visible(enabled)
	color_reference:set_visible(enabled)
	aimbot_reference:set_visible(enabled)
	behind_walls_reference:set_visible(enabled)
	sources_list_ui.title:set_visible(enabled)

	update_sources_ui()

	local aimbot = enabled and aimbot_reference:get()
	aimbot_fov_reference:set_visible(enabled and aimbot == 2)
	aimbot_speed_reference:set_visible(enabled and aimbot == 2)
end

-- normal callbacks are linked to the ui element
menu.set_callback("checkbox", "enabled_reference", enabled_reference, update_basic_ui)
menu.set_callback("selection", "aimbot_reference", aimbot_reference, update_basic_ui)
update_basic_ui()

callbacks.add(e_callbacks.EVENT, function(event)
	source_selected = nil

	source_editing = false
	edit_location_selected = nil

	table_clear(source_editing_modified)
	table_clear(source_editing_has_changed)

	update_sources_ui()
	flush_active_locations()
end, "switch_team")

callbacks.add(e_callbacks.EVENT, function(event)
	location_playback = nil
end, "round_end")

callbacks.add(e_callbacks.SHUTDOWN, function()
	-- clear metatables
	for i=1, #db.sources do
		if db.sources[i].cleanup ~= nil then
			db.sources[i]:cleanup()
		end
	end

	restore_disabled()

	benchmark:start("db_write")
	database.write("helper_db", db)
	benchmark:finish("db_write")
end)

callbacks.add(e_callbacks.PAINT, on_paint)

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)