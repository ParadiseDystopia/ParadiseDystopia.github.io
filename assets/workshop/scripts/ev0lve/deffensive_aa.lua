
local switch = false
local yawmod = gui.get_combobox('rage.antiaim.yaw_modifier')
local pitch = gui.get_combobox('rage.antiaim.pitch')
local dt = gui.get_checkbox('rage.general.fast_fire')
local yawmodslidercache = gui.get_slider('rage.antiaim.yaw_modifier_amount')
local yawmodslider = gui.get_slider('rage.antiaim.yaw_modifier_amount')
local enabled = gui.checkbox('defenable', 'scripts.elements_a', 'Enable In Air Defensive AA');
local defpitch = gui.combobox('defpitch', 'scripts.elements_a', 'Defensive AA Pitch', 'Up', 'Down');
local defspinspeed = gui.slider('defspinspeed', 'scripts.elements_a', 'Defensive Spin Speed', 15, 50);


local aa = {
  defchecker = 0,
  defensive = false,
}

function on_create_move(cmd, send_packet)
local lp = entities.get_entity(engine.get_local_player())
local air = lp:get_prop("m_hGroundEntity") == -1		
local tickbase = lp:get_prop("m_nTickBase")
aa.defensive = math.abs(tickbase - aa.defchecker) >= 3
aa.defchecker = math.max(tickbase, aa.defchecker or 0)

if not enabled:get() then
defpitch:set_visible(false)
return
end

defpitch:set_visible(true)

if dt:get() then
if air then
if aa.defensive then
pitch:set(defpitch:get())
yawmodslider:set(defspinspeed:get())
yawmod:set('Spin')
end
end
end

if dt:get() then
if air then
if not aa.defensive then
pitch:set('Down')
yawmodslider:set(yawmodslidercache:get())
yawmod:set('Jitter')
end
end
end

if dt:get() then
if not air then
pitch:set('Down')
yawmodslider:set(yawmodslidercache:get())
yawmod:set('Jitter')
end
end

if not dt:get() then
pitch:set('Down')
yawmodslider:set(yawmodslidercache:get())
yawmod:set('Jitter')
end
end

