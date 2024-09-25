local menu = fatality.menu
local render = fatality.render
local callbacks = fatality.callbacks
local input = fatality.input

local screensize = render:screen_size()
local x, y = screensize.x / 2, screensize.y / 2
local font = render:create_font("Verdana", 13, 500, true)
local color = csgo.color(191, 117, 255, 255)

local idealtick = {
    autopeek_state = 0,
    doubletap_state = 0,
    freestanding_state = 0,

    active = true
}

local refs = {
   doubletap = menu:get_reference("Rage", "Aimbot", "Aimbot", "Double tap"),
   freestanding = menu:get_reference("Rage", "Anti-aim", "Angles", "Freestand"),
   autopeek = menu:get_reference("Misc", "Movement", "Movement", "Peek assist")
}

local key = 0x58 -- default key is "B" https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes

callbacks:add("paint", function()
    if not csgo.interface_handler:get_engine_client():is_in_game() then
        return
    end

    if input:is_key_down(key) then
        
        render:text(font, x - 17, y + 20, "IDEAL", color)

        if idealtick.active then
            idealtick.autopeek_state = refs.autopeek:get_bool()
            idealtick.doubletap_state = refs.doubletap:get_bool()
            --idealtick.freestanding_state = refs.freestanding:get_bool()

            idealtick.active = false
        end

        refs.doubletap:set_bool(true)
        refs.autopeek:set_bool(true)
        --refs.freestanding:set_bool(true)
    else
        if not idealtick.active then
            refs.autopeek:set_bool(idealtick.autopeek_state)
            refs.doubletap:set_bool(idealtick.doubletap_state)
            --refs.freestanding:set_bool(idealtick.freestanding_state)

            idealtick.active = true
        end
    end
end)