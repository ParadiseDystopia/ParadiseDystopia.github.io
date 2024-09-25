local callbacks = fatality.callbacks;local config = fatality.config;local menu = fatality.menu;local callbacks = fatality.callbacks;local input = fatality.input
local firstFake = config:add_item( "fakef", 0 );local secondFake = config:add_item( "fakes", 0 );local CenterJitter = config:add_item("cent_jitter", 0 );local yawAdd = config:add_item("yaw_jitter", 0 );local yawLeft;local yawRight;
-- fuck fatal config systen
local AddVal = menu:get_reference("rage", "anti-aim", "angles", "add")
local FakeVal = menu:get_reference("rage", "anti-aim", "desync", "fake amount")

local FirstFake_slider = menu:add_slider( "First Fake", "rage", "Anti-Aim", "Angles", firstFake, -100, 100, 0 )
local SecondFake_slider = menu:add_slider( "Second Fake", "rage", "Anti-Aim", "Angles", secondFake, -100, 100, 0 )
local CenterJitter_slider = menu:add_slider("Center Jitter Value", "rage", "anti-aim", "angles", CenterJitter, 0, 180, 1)
local yawAdd_slider = menu:add_slider("Jitter Yaw Add", "rage", "anti-aim", "angles", yawAdd, -50, 50, 1)

local count = 0;
local old = count
local function system()
    if not csgo.interface_handler:get_engine_client():is_connected() then return end
    if CenterJitter:get_int() % 2 == 1 then
        CenterJitter:set_int(CenterJitter:get_int()+1) -- anti crash lua
    end

    yawLeft = CenterJitter:get_int() / -2 + yawAdd:get_int()
    yawRight = CenterJitter:get_int() / 2 + yawAdd:get_int()
    --print (yawLeft .. " " .. yawRight) -- debug
    if (yawLeft+0.5) % 2 == 0 then -- idk maybe this not needed anymore
        yawLeft = yawLeft + 0.5
        yawRight = yawRight + 0.5
    end

    if AddVal:get_int() == yawLeft then -- fake amount jitter made through crutches
        FakeVal:set_int(firstFake:get_int())
    else
        FakeVal:set_int(secondFake:get_int())
    end

    if count >= old+10 then -- delay for jitter
        if AddVal:get_int() == yawLeft then -- yaw add jitter
            AddVal:set_int(yawRight)
        else
            AddVal:set_int(yawLeft)
        end

        old = count
    end

    count = count + 1   
    
end

callbacks:add("paint", system)