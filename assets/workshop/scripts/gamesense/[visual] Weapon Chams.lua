-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_set_event_callback, globals_realtime, materialsystem_arms_material, materialsystem_viewmodel_material, ui_reference, pairs, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_label, ui_new_slider, ui_set, ui_set_callback, ui_set_visible = client.set_event_callback, globals.realtime, materialsystem.arms_material, materialsystem.viewmodel_material, ui.reference, pairs, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_label, ui.new_slider, ui.set, ui.set_callback, ui.set_visible

local materials =  {
    ["Glow"] = "vgui/achievements/glow",
    ["Dogtag light"] = "models/inventory_items/dogtags/dogtags_lightray",
    ["MP3 detail"] = "models/inventory_items/music_kit/darude_01/mp3_detail",
    ["Speech info"] = "models/extras/speech_info",
    ["Branches"] = "models/props_foliage/urban_tree03_branches",
    ["Dogstags"] = "models/inventory_items/dogtags/dogtags",
    ["Dreamhack star"] = "models/inventory_items/dreamhack_trophies/dreamhack_star_blur",
    ["Fishnet"] = "models/props_shacks/fishing_net01",
    ["Light glow"] = "sprites/light_glow04",
}
local refs = {
    viewmodel_chams =  { ui_reference("VISUALS", "Colored models", "Weapon viewmodel") },
    hands_chams = { ui_reference("VISUALS", "Colored models", "Hands") }
}
local function getMenuItems(table)
    local names = {}
    for k, v in pairs(table) do
        names[#names + 1] = k
    end
    return names
end

ui_new_label("VISUALS", "Colored models", "-- [ ADVANCED CHAMS ] --")
local weapon = {
    enable_checkbox = ui_new_checkbox("VISUALS", "Colored models", "> Weapon Chams"),
    material_combobox = ui_new_combobox("VISUALS", "Colored models", "-> Weapon - Material", getMenuItems(materials)),
    material = nil,
    wireframe_checkbox = ui_new_checkbox("VISUALS", "Colored models", "-> Weapon - Wireframe"),
    additive_checkbox = ui_new_checkbox("VISUALS", "Colored models", "-> Weapon - Additive"),
    color_picker = ui_new_color_picker("VISUALS", "Colored models", "-> Weapon - Color"),
    r = 255, g = 0, b = 0, a = 255,
    size_slider = ui_new_slider("VISUALS", "Colored models", "-> Weapon - Size", 1, 100),
    speed_slider = ui_new_slider("VISUALS", "Colored models", "-> Weapon - Animation speed", 1, 10, 5),
    speed = 5
}
ui_new_label("VISUALS", "Colored models", "-- [ ============== ] --")
local arms = {
    enable_checkbox = ui_new_checkbox("VISUALS", "Colored models", "> Arms Chams"),
    material_combobox = ui_new_combobox("VISUALS", "Colored models", "-> Arms - Material", getMenuItems(materials)),
    material = nil,
    wireframe_checkbox = ui_new_checkbox("VISUALS", "Colored models", "-> Arms - Wireframe"),
    additive_checkbox = ui_new_checkbox("VISUALS", "Colored models", "-> Arms - Additive"),
    color_picker = ui_new_color_picker("VISUALS", "Colored models", "-> Arms - Animation Color"),
    r = 255, g = 0, b = 0, a = 255,
    size_slider = ui_new_slider("VISUALS", "Colored models", "-> Arms - Material Size", 1, 100),
    speed_slider = ui_new_slider("VISUALS", "Colored models", "-> Arms - Animation Speed", 1, 10, 10),
    speed = 5
}
ui_new_label("VISUALS", "Colored models", "-- [ ============== ] --")

ui_set_callback(weapon.enable_checkbox, function()
    local bState = ui_get(weapon.enable_checkbox)
    if (not bState and weapon.material ~= nil) then weapon.material:reload() end

    ui_set(refs.viewmodel_chams[1], bState)
    ui_set_visible(weapon.material_combobox, bState)
    ui_set_visible(weapon.wireframe_checkbox, bState)
    ui_set_visible(weapon.additive_checkbox, bState)
    ui_set_visible(weapon.color_picker, bState)
    ui_set_visible(weapon.size_slider, bState)
    ui_set_visible(weapon.speed_slider, bState)
end)
ui_set_callback(weapon.color_picker, function()
    weapon.r, weapon.g, weapon.b, weapon.a = ui_get(weapon.color_picker)
    if weapon.material ~= nil then
        weapon.material:color_modulate(weapon.r, weapon.g, weapon.b)
        weapon.material:alpha_modulate(weapon.a)
    end
end)
ui_set_callback(arms.enable_checkbox, function()
    local bState = ui_get(arms.enable_checkbox)
    if (not bState and arms.material ~= nil) then arms.material:reload() end

    ui_set(refs.hands_chams[1], bState)
    ui_set_visible(arms.material_combobox, bState)
    ui_set_visible(arms.wireframe_checkbox, bState)
    ui_set_visible(arms.additive_checkbox, bState)
    ui_set_visible(arms.color_picker, bState)
    ui_set_visible(arms.size_slider, bState)
    ui_set_visible(arms.speed_slider, bState)
end)
ui_set_callback(arms.color_picker, function()
    arms.r, arms.g, arms.b, arms.a = ui_get(arms.color_picker)
    if arms.material ~= nil then
        arms.material:color_modulate(arms.r, arms.g, arms.b)
        arms.material:alpha_modulate(arms.a)
    end
end)

client_set_event_callback("paint", function()
    if ui_get(arms.enable_checkbox) then
        arms.material = materialsystem_arms_material()
        arms.speed = globals_realtime() * ui_get(arms.speed_slider) * 0.1
        arms.material:set_shader_param("$basetexture", materials[ui_get(arms.material_combobox)])
        arms.material:set_shader_param("$basetexturetransform", ui_get(arms.size_slider), arms.speed, arms.speed)
        arms.material:set_material_var_flag(28, ui_get(arms.wireframe_checkbox))
        arms.material:set_material_var_flag(7, ui_get(arms.additive_checkbox))
    end
    if ui_get(weapon.enable_checkbox) then
        weapon.material = materialsystem_viewmodel_material()
        weapon.speed = globals_realtime() * ui_get(weapon.speed_slider) * 0.1
        weapon.material:set_shader_param("$basetexture", materials[ui_get(weapon.material_combobox)])
        weapon.material:set_shader_param("$basetexturetransform", ui_get(weapon.size_slider), weapon.speed, weapon.speed)
        weapon.material:set_material_var_flag(28, ui_get(weapon.wireframe_checkbox))
        weapon.material:set_material_var_flag(7, ui_get(weapon.additive_checkbox))
    end
end)

function init()
    ui_set_visible(weapon.material_combobox, false)
    ui_set(weapon.material_combobox, "Light glow")
    ui_set_visible(weapon.wireframe_checkbox, false)
    ui_set_visible(weapon.additive_checkbox, false)
    ui_set_visible(weapon.color_picker, false)
    ui_set_visible(weapon.size_slider, false)
    ui_set_visible(weapon.speed_slider, false)

    ui_set_visible(arms.material_combobox, false)
    ui_set(arms.material_combobox, "Light glow")
    ui_set_visible(arms.wireframe_checkbox, false)
    ui_set_visible(arms.additive_checkbox, false)
    ui_set_visible(arms.color_picker, false)
    ui_set_visible(arms.size_slider, false)
    ui_set_visible(arms.speed_slider, false)
end
init()

client_set_event_callback("shutdown", function()    
    if weapon.material ~= nil then weapon.material:reload() end
    if arms.material ~= nil then arms.material:reload() end
end)