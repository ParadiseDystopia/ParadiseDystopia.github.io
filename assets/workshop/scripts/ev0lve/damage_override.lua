local enable = gui.checkbox("rage.general.dmg_override_enable", "rage.general", "MinDmg override")

-- store references to menu items, backup values, ui elements
local values, dyn_values, backup, dyn_backup, ui = {}, {}, {}, {}, {}

-- all available groups
local groups = {
    general         = 'general',
    pistol          = 'pistol',
    heavy_pistol    = 'heavy_pistol',
    automatic       = 'automatic',
    awp             = 'awp',
    scout           = 'scout',
    auto_sniper     = 'auto_sniper'
}

-- set value for group
local function set()
	for k, v in pairs(values) do
		-- callback get's called twice
		if values[k]:get_value() ~= ui[k]:get_value() then
			-- backup old value if needed
			if backup[k] == nil then
				backup[k] = values[k]:get_value()
			end
			
			if dyn_backup[k] == nil then
				dyn_backup[k] = dyn_values[k]:get_value()
			end
			
			-- set override value
			values[k]:set_value(ui[k]:get_value())
			dyn_values[k]:set_value(false)
		end
	end
end

-- reset value for group
local function reset()
	for k, v in pairs(values) do
		-- set backup value if we have one
		if backup[k] ~= nil then
			values[k]:set_value(backup[k])
		end
		
		if dyn_backup[k] ~= nil then
			dyn_values[k]:set_value(dyn_backup[k])
		end
	end
end

for k, v in pairs(groups) do 
	-- get mindmg slider from weapon tab
	values[k] = gui.get_slider(string.format("rage.weapon.%s.minimal_damage", v))
	dyn_values[k] = gui.get_checkbox(string.format("rage.weapon.%s.dynamic", v))
	
	-- add callback to backup values
	values[k]:add_callback(function()
		if not enable:get_value() then
			backup[k] = values[k]:get_value()
		end
	end)

	-- add callbacks to original values
	dyn_values[k]:add_callback(function()
		if not enable:get_value() then
			dyn_backup[k] = dyn_values[k]:get_value()
		end
	end)
	
	-- add values to ui
	ui[k] = gui.slider(string.format("rage.weapon.%s.dmg_override_value", v), string.format("rage.weapon.%s", v), "Override MinDmg", 0, 100, "%0.fHP")
end

enable:add_callback(function()
		if enable:get_value() then
			set()
		else
			reset()
		end
	end)

function on_shutdown()
    reset()
end