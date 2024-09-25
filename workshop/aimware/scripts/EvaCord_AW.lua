-- Pwned by obamaware deobfuscator

print("Project Eva :>\nThank you for being with us! [EvaCord Crack AW]")
--[[SETUP START]]--
--guimodify
local function guiModify(guiObject, x, y, width)
    if not guiObject then return end
    if x then guiObject:SetPosX(x) end
    if y then guiObject:SetPosY(y) end
    if width then guiObject:SetWidth(width) end
end
--guimodify end
--fonts
local font = draw.CreateFont('Verdana', 12)
local font2 = draw.CreateFont('Verdana', 12, 12)
--fonts end
--menu
local Window = gui.Window( "evacordwindow", "EvaCord Crack", 150, 150, 643, 710)
local SelectorTab = gui.Groupbox(Window, "", 16, 10, 606, 0)
local Tab = gui.Combobox(SelectorTab, "tabs", "", unpack({"Anti-Aim ├ù Rage", "Misc", "Visual", "Other"}))
guiModify(Tab, 10, -20, 555)
local miscGroup = gui.Groupbox(Window, "Misc", 16,84,296,100)
local rainbow_hudGroup = gui.Groupbox(Window, "Rainbow Hud", 16,84,296,100)
local picture_espGroup = gui.Groupbox(Window, "Picture ESP", 16,254,296,100)
local tracerGroup = gui.Groupbox(Window, "Other", 326,84,296,100)
local aaGroup = gui.Groupbox(Window, "Anti-Aim", 16,84,296,100)
local stages_of_lagsync = gui.Groupbox(Window, "",326,365,296,50);
local rageGroup = gui.Groupbox(Window, "Rage", 326,84,296,100)
local infoGroup = gui.Groupbox(Window, "Info", 16,84,606,100)
miscGroup:SetInvisible(true)
rainbow_hudGroup:SetInvisible(true)
picture_espGroup:SetInvisible(true)
tracerGroup:SetInvisible(true)
aaGroup:SetInvisible(true)
stages_of_lagsync:SetInvisible(true)
rageGroup:SetInvisible(true)
infoGroup:SetInvisible(true)
--menu end
--buttons
    --visual
    local enable = gui.Checkbox( picture_espGroup, "esp.picture.enemy.active", "Enable Picture ESP", false)
        local picture = gui.Combobox( picture_espGroup, "esp.picture.enemy.type", "Picture", "EvaCord", "Custom", "Nolove", "Elon Musk", "Elon Musk 2" ,"XaNe", "Hot Girl", "Rias Gremory", "Donald Trump")
        local customLink = gui.Editbox( picture_espGroup, "esp.picture.enemy.customlink", "Custom Link")
    local rainbowcheckbox = gui.Checkbox( rainbow_hudGroup, "enable", "Rainbow Hud", false ) rainbowcheckbox:SetDescription("ΓÇó Make's your hud rainbow.")
        local rainbowslider = gui.Slider( rainbow_hudGroup, "interval", "Rainbow Hud Interval", 1, 0, 5, 0.05 ) rainbowslider:SetDescription("ΓÇó Interval of color switch.")
    local SHOW = gui.Checkbox( tracerGroup, "bulletimpacts", "Server-Side Bullet Impacts", false )
        SHOW:SetDescription("ΓÇó Show server-side bullet impacts.")
    local SHOW_CLIENT = gui.Checkbox( tracerGroup, "bulletimpacts", "Client-Side Bullet Impacts", false )
        SHOW_CLIENT:SetDescription("ΓÇó Show client-side bullet impacts.")
    local COLOR = gui.ColorPicker( SHOW, "bulletimpacts.color", "Color", 0, 0, 255, 50 )
    --visual end
    --aa
    local aabox = gui.Multibox(aaGroup, "AntiAim presets")
        local strongaa = gui.Checkbox(aabox, "strongaa", "Strong preset", false)
        local tankaa = gui.Checkbox(aabox, "tankaa", "Tank preset", false)
        local wayaa = gui.Checkbox(aabox, "wayaa", "Way AA", false)
    local legfucker = gui.Checkbox(aaGroup, "legfucker", "Leg Fucker", false) legfucker:SetDescription("ΓÇó Breaks the animation of your legs.")
    local desync_side_indicator = gui.Checkbox(aaGroup, "desync_side_indicator", "Manual/Desync Arrows", false) desync_side_indicator:SetDescription("ΓÇó Render Manual arrows.")
    local desync_side_indicator_color_active = gui.ColorPicker(desync_side_indicator, "desync_side_indicator_color_active", "", 200, 200, 200, 220)
    local check_indicator = gui.Checkbox( aaGroup, "manualaa", "Enable Manual AA", false) check_indicator:SetDescription("ΓÇó Allows use Manual AA.")
    local LeftButton = gui.Keybox(aaGroup, "Anti-Aim_Left", "Left Keybind", 90)
    local RightButton = gui.Keybox(aaGroup, "Anti-Aim_Right", "Right Keybind", 67)
            callbacks.Register("Draw", function()
                if not check_indicator:GetValue() then
                    RightButton:SetDisabled(true)
                    LeftButton:SetDisabled(true)
                else
                    RightButton:SetDisabled(false)
                    LeftButton:SetDisabled(false)
                end
            end)
    --aa end
    --rage
    local double_tap = gui.Checkbox( rageGroup, 'doubletap', 'Double tap', false ) double_tap:SetDescription("ΓÇó bind this to enable DoubleTap.")
    local double_tap_type = gui.Combobox( rageGroup, 'doubletap_type', 'Type', 'Defensive Fire', 'Defensive Warp Fire' )
    local hide_shots = gui.Checkbox( rageGroup, 'hideshots', 'Hide shots', false ) hide_shots:SetDescription("ΓÇó bind this to enable HideShots.")
    local body_aim = gui.Checkbox( rageGroup, "bodyaim", "Force BodyAim", false ) body_aim:SetDescription("ΓÇó bind this to enable BodyAim.")
    --rage end
    --misc
    local watermark = gui.Checkbox(miscGroup, "watermark", "Watermark", true)
    local engineradar = gui.Checkbox(miscGroup, "engineradar", "Engine Radar", false)
    local UnlockInvAccess = gui.Checkbox(miscGroup, "unlockinvaccess", "Unlock inventory access", flLastTime) UnlockInvAccess:SetDescription("ΓÇó Allows to use various weapons during the game.")
    local killsay = gui.Checkbox(miscGroup, "killsay", "KillSay", true)
    local doorspam = gui.Keybox(miscGroup, "doorspam", "Door Spam Key", 0) doorspam:SetDescription("ΓÇó Working due to '+use' spaming.")
    --misc end
    --other
        --info
        local discordbutton = gui.Button(infoGroup, "Join to discord server", function( )
            panorama.RunScript( 'SteamOverlayAPI.OpenExternalBrowserURL( "https://discord.gg/cjD3gx4DPV" )' )
        end )
        guiModify(discordbutton, 7, -10, 560)
        local infoText = gui.Text(infoGroup, ' ├ù EvaCord Crack [AW] ΓÇö script from "Project Eva" for AimWare users!')
        local infoText = gui.Text(infoGroup, ' ├ù "Project Eva" ΓÇö a team of developers of modifications for cheats')
        local infoText = gui.Text(infoGroup, ' ├ù The script is intended for free use only!(can be sold together with cfg)')
        local infoText = gui.Text(infoGroup, 'Thank you for being with us! with love Project Eva')
        --info end
    --other end
--buttons end
--refs
local e_list = {
        WEAPONS = {"shared", "asniper", "hpistol", "knife", "lmg", "pistol", "rifle", "scout", "shotgun", "smg", "sniper", "zeus"},
    WEAPONS_baim = {"shared", "asniper", "hpistol", "lmg", "pistol", "rifle", "scout", "shotgun", "smg", "sniper", "zeus"}
}
local Return_AntiAim_Value = {
        0,
        0,
        -1,
        0,
        180,
        0,
        0,
        0,
        0,
        0,
        0
}
local function SetTab()
        if Tab:GetValue() == 0 then
        miscGroup:SetInvisible(true)
        rainbow_hudGroup:SetInvisible(true)
        picture_espGroup:SetInvisible(true)
        tracerGroup:SetInvisible(true)
        aaGroup:SetInvisible(false)
        stages_of_lagsync:SetInvisible(false)
        rageGroup:SetInvisible(false)
        infoGroup:SetInvisible(true)
        elseif Tab:GetValue() == 1 then
        miscGroup:SetInvisible(false)
        rainbow_hudGroup:SetInvisible(true)
        picture_espGroup:SetInvisible(true)
        tracerGroup:SetInvisible(true)
        aaGroup:SetInvisible(true)
        stages_of_lagsync:SetInvisible(true)
        rageGroup:SetInvisible(true)
        infoGroup:SetInvisible(true)
        elseif Tab:GetValue() == 2 then
        miscGroup:SetInvisible(true)
        rainbow_hudGroup:SetInvisible(false)
        picture_espGroup:SetInvisible(false)
        tracerGroup:SetInvisible(false)
        aaGroup:SetInvisible(true)
        stages_of_lagsync:SetInvisible(true)
        rageGroup:SetInvisible(true)
        infoGroup:SetInvisible(true)
        elseif Tab:GetValue() == 3 then
        miscGroup:SetInvisible(true)
        rainbow_hudGroup:SetInvisible(true)
        picture_espGroup:SetInvisible(true)
        tracerGroup:SetInvisible(true)
        aaGroup:SetInvisible(true)
        stages_of_lagsync:SetInvisible(true)
        rageGroup:SetInvisible(true)
        infoGroup:SetInvisible(false)
        end
end
callbacks.Register('Draw', SetTab)
--refs end
Window:SetOpenKey( 45 )
if gui.Reference("Menu"):IsActive() then
    Window:SetActive(true);
else
    Window:SetActive(false);
end
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
--[[SETUP END]]--
--[[AA(WAY) START]]--
--gui
local elements_box = gui.Multibox(stages_of_lagsync, "Way AA");
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
                        elements_setting_array[element].desync_angle:SetInvisible(not elements_array[element]:GetValue())
                        elements_setting_array[element].yaw_angle:SetInvisible(not elements_array[element]:GetValue())
                        elements_setting_array[element].time_to_switch:SetInvisible(not elements_array[element]:GetValue())
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
--getting filename of our cache
local function getFileName()
        local script_name = GetScriptName()
        return string.sub(script_name, 1, string.find(script_name, ".lua") - 1) .. "WayAA.txt"
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
                file.Write(file_name, "5")
        end
        return elements_number
end
callbacks.Register("Unload", function()
        --updating our file on unload to get latest number of elements
        local file_name = getFileName()
        file.Delete(file_name)
        file.Write(file_name, "5")
end)
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
--anti-aims
local function clampYaw(yaw)
    --clamping our yaw
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end
local static_realtime = globals.RealTime();
local TICK_TIME = 1 / 64;
local general_stage = 1;
local current_stage = 1;
--counting current lagsync stage
local function stageCounter()
        --fixing if we are removing elements
        if current_stage > #elements_setting_array then
                current_stage = #elements_setting_array
        end
        --general stage its all stages which been counted
        if globals.RealTime() - static_realtime >= elements_setting_array[current_stage].time_to_switch:GetValue() * TICK_TIME then
                general_stage = general_stage + 1
                static_realtime = globals.RealTime()
        end
        --getting current stage by allstages % numberofstages
        current_stage = (general_stage % #elements_setting_array) + 1
end
--setting yaw
local function setYaw()
        gui.SetValue("rbot.antiaim.base", clampYaw(180 + elements_setting_array[current_stage].yaw_angle:GetValue()))
end
--setting desync
local function setDesync()
        gui.SetValue("rbot.antiaim.base.rotation", elements_setting_array[current_stage].desync_angle:GetValue())
end
--callbacks
callbacks.Register('Draw', function()
    if not wayaa:GetValue() then return end
        changeElementsUi()
        makeFirstElements()
        stageCounter()
end)
callbacks.Register("PostMove", function()
    if not wayaa:GetValue() then return end
        setYaw()
        setDesync()
end)
--[[AA(WAY) END]]--
--[[BULLET IMPACT START]]--
-- Server Side Bullet Impacts by stacky
local bulletImpacts = {}
callbacks.Register( "Draw", function()
    if not SHOW:GetValue() then return end
    if not entities.GetLocalPlayer() then return end
    if table.getn(bulletImpacts) == 0 then return end
    if globals.CurTime() >= bulletImpacts[1][2] then
        table.remove(bulletImpacts, 1)
    end
    for i = 1, #bulletImpacts do
        local vecBullet = bulletImpacts[i][1]
        local topLeftBottomX, topLeftBottomY = client.WorldToScreen( vecBullet + Vector3(2, -2, 2) )
        local topLeftTopX, topLeftTopY = client.WorldToScreen( vecBullet + Vector3(-2, -2, 2) )
        local topRightBottomX, topRightBottomY = client.WorldToScreen( vecBullet + Vector3(2, 2, 2) )
        local topRightTopX, topRightTopY = client.WorldToScreen( vecBullet + Vector3(-2, 2, 2) )
        local botLeftBottomX, botLeftBottomY = client.WorldToScreen( vecBullet + Vector3(2, -2, -2) )
        local botLeftTopX, botLeftTopY = client.WorldToScreen( vecBullet + Vector3(-2, -2, -2) )
        local botRightBottomX, botRightBottomY = client.WorldToScreen( vecBullet + Vector3(2, 2, -2) )
        local botRightTopX, botRightTopY = client.WorldToScreen( vecBullet + Vector3(-2, 2, -2) )
        if topLeftBottomX == nil or topLeftTopX == nil or topRightBottomX == nil or topRightTopX == nil or botLeftBottomX == nil or botLeftTopX == nil or botRightBottomX == nil or botRightTopX == nil then
            goto continue
        end
        draw.Color( 0, 0, 0, 100 )
        draw.Line( topLeftBottomX, topLeftBottomY, topLeftTopX, topLeftTopY )
        draw.Line( topLeftTopX, topLeftTopY, topRightTopX, topRightTopY )
        draw.Line( topRightTopX, topRightTopY, topRightBottomX, topRightBottomY )
        draw.Line( topRightBottomX, topRightBottomY, topLeftBottomX, topLeftBottomY )
        draw.Line( botLeftBottomX, botLeftBottomY, botLeftTopX, botLeftTopY )
        draw.Line( botLeftTopX, botLeftTopY, botRightTopX, botRightTopY )
        draw.Line( botRightTopX, botRightTopY, botRightBottomX, botRightBottomY )
        draw.Line( botRightBottomX, botRightBottomY, botLeftBottomX, botLeftBottomY )
        draw.Line( topLeftBottomX, topLeftBottomY, botLeftBottomX, botLeftBottomY )
        draw.Line( topLeftTopX, topLeftTopY, botLeftTopX, botLeftTopY )
        draw.Line( topRightTopX, topRightTopY, botRightTopX, botRightTopY )
        draw.Line( topRightBottomX, topRightBottomY, botRightBottomX, botRightBottomY )
        draw.Color( COLOR:GetValue() )
        draw.Triangle( topLeftTopX, topLeftTopY, botLeftTopX, botLeftTopY, botLeftBottomX, botLeftBottomY )
        draw.Triangle( topLeftTopX, topLeftTopY, topLeftBottomX, topLeftBottomY, botLeftBottomX, botLeftBottomY )
        draw.Triangle( topRightTopX, topRightTopY, botRightTopX, botRightTopY, botRightBottomX, botRightBottomY )
        draw.Triangle( topRightTopX, topRightTopY, topRightBottomX, topRightBottomY, botRightBottomX, botRightBottomY )
        draw.Triangle( topLeftTopX, topLeftTopY, botLeftTopX, botLeftTopY, botRightTopX, botRightTopY )
        draw.Triangle( topLeftTopX, topLeftTopY, topRightTopX, topRightTopY, botRightTopX, botRightTopY )
        draw.Triangle( topLeftBottomX, topLeftBottomY, botLeftBottomX, botLeftBottomY, botRightBottomX, botRightBottomY )
        draw.Triangle( topLeftBottomX, topLeftBottomY, topRightBottomX, topRightBottomY, botRightBottomX, botRightBottomY )
        draw.Triangle( topLeftTopX, topLeftTopY, topLeftBottomX, topLeftBottomY, topRightBottomX, topRightBottomY )
        draw.Triangle( topLeftTopX, topLeftTopY, topRightTopX, topRightTopY, topRightBottomX, topRightBottomY )
        draw.Triangle( botLeftTopX, botLeftTopY, botLeftBottomX, botLeftBottomY, botRightBottomX, botRightBottomY )
        draw.Triangle( botLeftTopX, botLeftTopY, botRightTopX, botRightTopY, botRightBottomX, botRightBottomY )
        ::continue::
    end
end )
callbacks.Register( "FireGameEvent", function(event)
    if event:GetName() ~= "bullet_impact" then return end
    if not SHOW:GetValue() then return end
    if client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) ) ~= client.GetLocalPlayerIndex() then return end
    table.insert(bulletImpacts, {Vector3(event:GetFloat("x"), event:GetFloat("y"), event:GetFloat("z")), globals.CurTime() + 4})
end )
client.AllowListener( "bullet_impact" )
callbacks.Register( "CreateMove", function()
    if SHOW_CLIENT:GetValue() then
        client.SetConVar( "sv_showimpacts", 2, true )
    else
        client.SetConVar( "sv_showimpacts", 0, true )
    end
end )
--[[BULLET IMPACT END]]--
--[[FPS BOOST START]]--
--[[FPS BOOST END]]--
--[[FORCE BODY AIM START]]--
local cache_baim = {}
local reset = true
callbacks.Register("Draw", function()
    local key = body_aim:GetValue()
    if key == 0 or key == nil then return end
    if reset == true then
        for i = 1, 9 do
            cache_baim[i] = gui.GetValue(string.format("rbot.hitscan.hitbox.%s.head.priority", e_list.WEAPONS_baim[i]))
            cache_baim[i] = gui.GetValue(string.format("rbot.hitscan.hitbox.%s.body.priority", e_list.WEAPONS_baim[i]))
        end
    end
    if key then
        for i = 1, 9 do
            gui.SetValue(string.format("rbot.hitscan.hitbox.%s.head.priority", e_list.WEAPONS_baim[i]), 0)
            gui.SetValue(string.format("rbot.hitscan.hitbox.%s.body.priority", e_list.WEAPONS_baim[i]), 1)
        end
        reset = false
    elseif reset == false then
        for i = 1, 9 do
            gui.SetValue(string.format("rbot.hitscan.hitbox.%s.head.priority", e_list.WEAPONS_baim[i]), cache_baim[i])
            gui.SetValue(string.format("rbot.hitscan.hitbox.%s.body.priority", e_list.WEAPONS_baim[i]), cache_baim[i])
        end
        reset = true
    end
end)
--[[FORCE BODY AIM END]]--
--[[EXPLOITS START]]--
local exploits = {}
function exploits.handle()
        local fire_mode = 'Off'
        if double_tap:GetValue( ) then
                fire_mode = double_tap_type:GetString( )
        elseif hide_shots:GetValue( ) then
                fire_mode = 'Shift Fire'
        end
        for _, value in ipairs( e_list.WEAPONS ) do
                gui.SetValue( string.format( 'rbot.accuracy.attack.%s.fire', value ), fire_mode )
        end
end
callbacks.Register( 'Draw', 'exploits', exploits.handle)
--[[EXPLOITS END]]--
--[[PICTURE ESP START]]--
--- Variables
local x1, y1, x2, y2;
local imageLink = "https://cdn.discordapp.com/attachments/1054899066418507848/1065346140368801862/Avatar_EvaCord.png"
local imageData = http.Get(imageLink);
local imgRGBA, imgWidth, imgHeight = common.DecodePNG(imageData);
local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight)
--- Update Function for the button.
local function update()
    if picture:GetValue() == 0 then
        imageLink = "https://cdn.discordapp.com/attachments/1054899066418507848/1065346140368801862/Avatar_EvaCord.png"
    elseif picture:GetValue() == 1 then
        imageLink = customLink:GetValue()
    elseif picture:GetValue() == 2 then
        imageLink = "https://cdn.discordapp.com/attachments/1054899066418507848/1073624999493120071/god.png"
    elseif picture:GetValue() == 3 then
        imageLink = "https://i.imgur.com/ZruIM1Z.jpg"
    elseif picture:GetValue() == 4 then
        imageLink = "https://i.imgur.com/bmM6gUP.png"
    elseif picture:GetValue() == 5 then
        imageLink = "https://i.ytimg.com/vi/hEDYqAAL_48/hqdefault.jpg"
    elseif picture:GetValue() == 6 then
        imageLink = "https://images.vectorhq.com/images/previews/dfa/girl-with-big-ass-psd-407902.png"
    elseif picture:GetValue() == 7 then
        imageLink = "https://i.imgur.com/O5mew0e.png"
    elseif picture:GetValue() == 8 then
        imageLink = "https://purepng.com/public/uploads/large/purepng.com-donald-trumpdonald-trumpdonaldtrumppresidentpoliticsbusinessmanborn-in-queens-1701528042636xgni1.png"
    end
    if not imageLink then
        return
    end
    imageData = http.Get(imageLink);
    if string.sub(imageLink, -3) == "jpg" then
        imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(imageData);
    else
        imgRGBA, imgWidth, imgHeight = common.DecodePNG(imageData);
    end
    texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight)
end
local updatebutton = gui.Button(picture_espGroup, "Update ESP", update)
callbacks.Register("DrawESP", function(builder)
    if enable:GetValue() then
        local builderEntity = builder:GetEntity()
        if builderEntity:IsPlayer() and builderEntity:IsAlive() and builderEntity:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber() then
            x1, y1, x2, y2 = builder:GetRect()
            draw.SetTexture(texture)
            draw.FilledRect(x1, y1, x2, y2)
        end
    end
end)
--[[PICTURE ESP END]]--
--[[AA PRESETS START]]--
local function NormalizateAA()
        if strongaa:GetValue() then return end
        Return_AntiAim_Value[4] = 180 .. gui.GetValue('rbot.antiaim.base')
        rotate_of = gui.GetValue('rbot.antiaim.base.rotation')
end
callbacks.Register('CreateMove', NormalizateAA)
local function StrongAA()
        if not strongaa:GetValue() or Return_AntiAim_Value[9] ~= 0 then return end
        if Return_AntiAim_Value[0] == 0 then
                NormalizateAA()
                Return_AntiAim_Value[0] = 1
        end
        ticks = globals.TickCount()%17
        gui.SetValue("rbot.antiaim.base", 180 .. " Desync Jitter")
        -- 256 - on air, 262 on air crouching, 263 - crouching, 257 - on ground
        if entities.GetLocalPlayer():GetProp("m_fFlags") == 256 or entities.GetLocalPlayer():GetProp("m_fFlags") == 262 then
                if ticks % 6 == 0 then
                        gui.SetValue("rbot.antiaim.base.rotation", math.random(9,21))
                end
                if ticks % 4 == 0 then
                        gui.SetValue("rbot.antiaim.base.rotation", math.random(9,21))
                end
                if ticks % 3 == 0 then
                        gui.SetValue("rbot.antiaim.base.rotation", math.random(9,21))
                end
        end
        if entities.GetLocalPlayer():GetProp("m_fFlags") == 257 then
                if ticks % 4 == 0 then
                        gui.SetValue("rbot.antiaim.base.rotation", math.random(16,21))
                end
        end
        if entities.GetLocalPlayer():GetProp("m_fFlags") == 263 then
                if ticks % 2 == 0 then
                        gui.SetValue("rbot.antiaim.base.rotation", math.random(18,25))
                end
        end
end
callbacks.Register('CreateMove', StrongAA)
local function TankAA()
        if not tankaa:GetValue() or Return_AntiAim_Value[9] ~= 0 then return end
        if Return_AntiAim_Value[10] == 0 then
                NormalizateAA()
                Return_AntiAim_Value[10] = 1
        end
        ticks = globals.TickCount()%18
        gui.SetValue("rbot.antiaim.base", -180 .. " Desync Jitter")
        if ticks % 4 == 0 then
                gui.SetValue("rbot.antiaim.base.rotation", -10)
                goto skip
        end
        if ticks % 2 == 0 then
                gui.SetValue("rbot.antiaim.base.rotation", math.random(-8,-21))
        end
        ::skip::
end
callbacks.Register('CreateMove', TankAA)
--[[AA PRESETS END]]--
--[[MANUAL AA START]]--
local gui_set = gui.SetValue;
local gui_get = gui.GetValue;
local LeftKey = 0;
local RightKey = 0;
local function main()
    if input.IsButtonPressed(LeftButton:GetValue()) then
        LeftKey = LeftKey + 1;
        BackKey = 0;
        RightKey = 0;
    elseif input.IsButtonPressed(RightButton:GetValue()) then
        RightKey = RightKey + 1;
        LeftKey = 0;
        BackKey = 0;
    end
end
function CountCheck()
   if ( LeftKey == 1 ) then
        RightKey = 0;
    elseif ( RightKey == 1 ) then
        LeftKey = 0;
    elseif ( LeftKey == 2 ) then
        LeftKey = 0;
        RightKey = 0;
   elseif ( RightKey == 2 ) then
        LeftKey = 0;
        RightKey = 0;
   end
end
function SetLeft()
   gui_set("rbot.antiaim.base", 90);
end
function SetRight()
   gui_set("rbot.antiaim.base", -90);
end
function SetAuto()
   gui_set("rbot.antiaim.base", 180);
end
function start_manuals()
    if check_indicator:GetValue() then
        if ( LeftKey == 1 ) then
            SetLeft();

        elseif ( RightKey == 1 ) then
            SetRight();

        elseif ((LeftKey == 0) and (RightKey == 0)) then
            SetAuto();
        end
    end
end
callbacks.Register( "Draw", "main", main);
callbacks.Register( "Draw", "CountCheck", CountCheck);
callbacks.Register( "Draw", "SetLeft", SetLeft);
callbacks.Register( "Draw", "SetRight", SetRight);
callbacks.Register( "Draw", "SetAuto", SetAuto);
callbacks.Register( "Draw", "start_manuals", start_manuals);
--[[MANUAL AA END]]--
--[[ARROWS START]]--
local function handleVariables()
    local_entity = entities.GetLocalPlayer()
    real_time = globals.RealTime()
end
local function drawManualIndicators()
    if not desync_side_indicator:GetValue() or not local_entity or not local_entity:IsAlive() then
        return
    end
    local screen_width, screen_height = draw.GetScreenSize()
    if RightKey == 1 then
        draw.Color(desync_side_indicator_color_active:GetValue())
        draw.Triangle(screen_width / 2 + 30 + 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 + 30 + 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 + 30 + 3 + 17,
                      screen_height / 2)
        draw.Color(9,9,9, 100)
        draw.Triangle(screen_width / 2 - 30 - 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 - 30 - 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 - 30 - 3 - 17,
                      screen_height / 2)

    elseif LeftKey == 1 then
        draw.Color(desync_side_indicator_color_active:GetValue())
        draw.Triangle(screen_width / 2 - 30 - 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 - 30 - 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 - 30 - 3 - 17,
                      screen_height / 2)
        draw.Color(9,9,9, 100)
        draw.Triangle(screen_width / 2 + 30 + 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 + 30 + 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 + 30 + 3 + 17,
                      screen_height / 2)
    elseif not (LeftKey == 1) or (RightKey == 1) then
        draw.Color(9,9,9, 100)
        draw.Triangle(screen_width / 2 - 30 - 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 - 30 - 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 - 30 - 3 - 17,
                      screen_height / 2)
        draw.Color(9,9,9, 100)
        draw.Triangle(screen_width / 2 + 30 + 3,
                      screen_height / 2 - 17 / 2,
                      screen_width / 2 + 30 + 3,
                      screen_height / 2 + 17 / 2,
                      screen_width / 2 + 30 + 3 + 17,
                      screen_height / 2)
    end
end
callbacks.Register("Draw", handleVariables)
callbacks.Register("Draw", drawManualIndicators)
--[[ARROWS END]]--
--[[KILLSAY START]]--
local killsays = {
    "(Γÿ₧∩╛ƒπâ«∩╛ƒ)Γÿ₧ || EvaCord Crack",
    "(Γê¬.Γê¬ )...zzz || EvaCord Crack",
    "\\(πÇç_o)/ || EvaCord Crack",
    "ßòª(├▓_├│╦ç)ßòñ || EvaCord Crack",
    "(^\\\\\\^) || EvaCord Crack",
    "( ΓÇó╠Ç ╧ë ΓÇó╠ü )Γ£º || EvaCord Crack",
    "\\^o^/ || EvaCord Crack",
    "EvaCord Crack custom resolver || discord- cjD3gx4DPV",
    "EvaCord Crack ╨║╨░╤ü╤é╨╛╨╝╨╜╤ï╨╣ ╤Ç╨╡╨╖╨╛╨╗╤î╨▓╨╡╤Ç || discord- cjD3gx4DPV",
    "Better resolver || EvaCord Crack",
    "╨ú╨╗╤â╤ç╤ê╨╡╨╜╨╜╤ï╨╣ ╤Ç╨╡╨╖╨╛╨╗╤î╨▓╨╡╤Ç || EvaCord Crack",
    "Don't be ashamed || EvaCord Crack",
    "╨¥╨╡ ╨┐╨╛╨╖╨╛╤Ç╤î╤ü╤Å || EvaCord Crack",
    "Wanna buy EvaCord Crack? || discord- cjD3gx4DPV",
    "╨Ñ╨╛╤ç╨╡╤ê╤î ╨║╤â╨┐╨╕╤é╤î EvaCord Crack? || discord- cjD3gx4DPV",
    "Still playing with EastLua? || EvaCord Crack",
    "╨Æ╤ü╤æ ╨╡╤ë╨╡ ╨╕╨│╤Ç╨░╨╡╤ê╤î ╤ü EastLua? || EvaCord Crack",
    "Get good, get EvaCord Crack || discord- cjD3gx4DPV",
    "EvaCord Crack have free version || discord- cjD3gx4DPV",
    "EvaCord Crack ╨╕╨╝╨╡╨╡╤é ╨▒╨╡╤ü╨┐╨╗╨░╤é╨╜╤â╤Ä ╨▓╨╡╤Ç╤ü╨╕╤Ä || discord- cjD3gx4DPV",
    "Best lua for pandora/AW? || EvaCord Crack",
    "╨¢╤â╤ç╤ê╨░╤Å ╨╗╤â╨░ ╨╜╨░ ╨┐╨░╨╜╨┤╨╛╤Ç╤â/╨É╨Æ? || EvaCord Crack",
    "youtu.be/H6IbQJrCWrc || EvaCord Crack",
    "My bad. || EvaCord Crack",
    "╨ƒ╤Ç╨╛╤ü╤é╨╕ ╨╡╤ü╨╗╨╕ ╤é╨░╨┐╨╜╤â╨╗. || EvaCord Crack",
    "Wanna buy my LUA&CFG? || discord- cjD3gx4DPV",
    "╨Ñ╨╛╤ç╨╡╤ê╤î ╨║╤â╨┐╨╕╤é╤î ╨╝╨╛╨╕ ╨¢╨ú╨É&╨Ü╨ñ╨ô? || discord- cjD3gx4DPV",
    "Don't worry || EvaCord Crack",
    "╨¥╨╡ ╨┐╨╡╤Ç╨╡╨╢╨╕╨▓╨░╨╣ || EvaCord Crack"
}
local function KillSay(Event)
    if not killsay:GetValue() then return end
        if (Event:GetName() == 'player_death') then
        local ME = client.GetLocalPlayerIndex();
        local INT_UID = Event:GetInt('userid');
        local INT_ATTACKER = Event:GetInt('attacker');
        local NAME_Victim = client.GetPlayerNameByUserID(INT_UID);
        local INDEX_Victim = client.GetPlayerIndexByUserID(INT_UID);
        local NAME_Attacker = client.GetPlayerNameByUserID(INT_ATTACKER);
        local INDEX_Attacker = client.GetPlayerIndexByUserID(INT_ATTACKER);
    if (INDEX_Attacker == ME and INDEX_Victim ~= ME) then
        client.ChatSay(' ' .. tostring(killsays[math.random(#killsays)]) .."");
        end
    end
end
client.AllowListener('player_death')
callbacks.Register('FireGameEvent', KillSay)
--[[KILLSAY END]]--
--[[RAINBOW HUD START]]--
local color = 1
local time = globals.CurTime()
local orig = client.GetConVar( "cl_hud_color" )
local function RainbowHud()
    if rainbowcheckbox:GetValue() then
        client.Command( "cl_hud_color " .. color, true )
        if globals.CurTime() - rainbowslider:GetValue() >= time then
            color = color + 1
            time = globals.CurTime()
        end
        if color > 9 then color = 1 end
    else
        client.Command( "cl_hud_color " .. orig, true )
    end
end
callbacks.Register( "Draw", function()
    RainbowHud()
end)
--[[RAINBOW HUD END]]--
--[[UNCLOCK INV ACCESS START]]--
local function UnlockInventoryAccess()
        panorama.RunScript([[
        LoadoutAPI.IsLoadoutAllowed = () => {
                return true;
        };
        ]])
end
local function LockInventoryAccess()
        panorama.RunScript([[
        LoadoutAPI.IsLoadoutAllowed = () => {
                return false;
        };
        ]])
end
callbacks.Register("Draw", function()
    if UnlockInvAccess:GetValue() == true then
        UnlockInventoryAccess()
    else
        LockInventoryAccess()
    end
end)
--[[UNCLOCK INV ACCESS END]]--
--[[WATERMARK START]]--
local cheat = "EvaCord Crack"
local font_wm = draw.CreateFont("Verdana", 12, 400)
local ft_prev = 0
local function get_fps()
    ft_prev = ft_prev * 0.9 + global_vars.absoluteframetime * 0.1
    return math.ceil(1 / ft_prev)
end
local function on_paint()
    if (watermark:GetValue() ~= true) then return end
    local width, height = draw.GetScreenSize()
    local lp = entities.GetLocalPlayer()
    local Ping = true
    local UserName = true
    local playerResources = entities.GetPlayerResources()
    local text = string.format("%s", cheat)
    if lp == nil then return end
    if Ping == true then
        text = string.format("|| %s || delay: %dms", text, playerResources:GetPropInt("m_iPing", lp:GetIndex()))
    end
    if UserName == true then
        text = string.format("%s ||", text)
    end
    local w, h = draw.GetTextSize(text);
    local weightPadding, heightPadding = 20, 15;
    local watermarkWidth = weightPadding + w;
    local x = 855
    local y = 1060
    draw.Color(17, 17, 17, 200)
    draw.FilledRect(x+190,y+15,w+665,h+1045)

    draw.Color(255, 255, 255, 255)
    draw.Text(x, y, text)
    draw.SetFont(font_wm)
end
callbacks.Register("Draw", on_paint)
--[[WATERMARK END]]--
--[[ENGINE RADAR]]--
local function engine_radar_draw()
    for index, Player in pairs(entities.FindByClass("CCSPlayer")) do
        if not engineradar:GetValue() then
            Player:SetProp("m_bSpotted", 0);
        else
            Player:SetProp("m_bSpotted", 1);
        end
    end
end
callbacks.Register("Draw", "engine_radar_draw", engine_radar_draw);
--[[ENGINE RADAR END]]--
--[[DOOR SPAM]]--
local switch = false
callbacks.Register( "CreateMove", function(cmd)
    if doorspam:GetValue() ~= 0 then
        if input.IsButtonDown(doorspam:GetValue()) then
            if switch then client.Command("+use", true)
            else client.Command("-use", true) end
            switch = not switch
        else
            if not switch then client.Command("-use", true) end
        end
    end
end )
--[[DOOR SPAM END]]--
--[[LEGS FUCKER START]]--
local slidewalk = "misc.slidewalk"
local last = 0
local state = true
local function Draw()
    if not legfucker:GetValue() then return end
    if globals.CurTime() > last then
        state = not state
        last = globals.CurTime() + 0.01
        gui.SetValue(slidewalk, state and true or false)
    end
end
callbacks.Register( "Draw", "Legfucker", Draw )
--[[LEGS FUCKER END]]--
