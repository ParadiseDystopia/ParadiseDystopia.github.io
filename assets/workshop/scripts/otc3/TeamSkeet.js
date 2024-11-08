// By Klient

UI.AddSliderInt("p_x", 0, Render.GetScreenSize()[0])
UI.AddSliderInt("p_y", 0, Render.GetScreenSize()[1])
UI.SetEnabled("Script items", "p_x", false)
UI.SetEnabled("Script items", "p_y", false)

UI.AddMultiDropdown("Teamskeet ESP", ["Indicators", "Key states", "Anti-aim"])
UI.AddMultiDropdown("Indicator settings", ["Desync", "Speed", "Gradient", "Show values", "Big"])
UI.AddColorPicker("Indicator color picker")
UI.SetColor("Script items", "Indicator color picker", [175, 255, 0, 255])

UI.AddDropdown("Anti-aim indicator type", ["Arrows", "Circle", "Static"])
UI.AddColorPicker("Indicator desync color")
UI.SetColor("Script items", "Indicator desync color", [0, 200, 255, 255])

UI.AddHotkey("Manual left");
UI.AddHotkey("Manual right");
UI.AddHotkey("Manual back");

var dragging = false

function check_f() {
    var val = UI.GetValue("Script items", "Teamskeet ESP")
    var value = UI.GetValue("Script items", "Indicator settings")

    if (val & (1<<0) || val & (1<<1)) {
        UI.SetEnabled("Script items", "Indicator settings", true)
    } else {
        UI.SetEnabled("Script items", "Indicator settings", false)
    }

    if (val & (1<<2)) {
        UI.SetEnabled("Script items", "Anti-aim indicator type", true)
        UI.SetEnabled("Script items", "Indicator desync color", true)
        UI.SetEnabled("Script items", "Manual left", true)
        UI.SetEnabled("Script items", "Manual right", true)
        UI.SetEnabled("Script items", "Manual back", true)
    } else {
        UI.SetEnabled("Script items", "Anti-aim indicator type", false)
        UI.SetEnabled("Script items", "Indicator desync color", false)
        UI.SetEnabled("Script items", "Manual left", false)
        UI.SetEnabled("Script items", "Manual right", false)
        UI.SetEnabled("Script items", "Manual back", false)
    }
}
Cheat.RegisterCallback("Draw", "check_f")

function is_dragging(x, y, w, h) {
    var mx = Input.GetCursorPosition()[0], my = Input.GetCursorPosition()[1]
    var click = Input.IsKeyPressed(0x01)
    
    var in_x = mx > x && mx < x + w 
    var in_y = my > y && my < y + h 

    return in_x && in_y && click && UI.IsMenuOpen()
}

function run_dragging() {
    var click = Input.IsKeyPressed(0x01)
    var mx = Input.GetCursorPosition()[0], my = Input.GetCursorPosition()[1]
    var x = UI.GetValue("Script items", "p_x"), y = UI.GetValue("Script items", "p_y")
    var sx = Render.GetScreenSize()[0], sy = Render.GetScreenSize()[1]

    if (dragging) {
        var dx = x - ox, dy = y - oy
        UI.SetValue("Script items", "p_x", Math.min(Math.max(mx + dx, 0), sx))
        UI.SetValue("Script items", "p_y", Math.min(Math.max(my + dy, 0), sy))
        ox = mx
        oy = my
    } else {
        ox = mx
        oy = my
    }   
}

Render.OutlineStringCustom = function(x, y, alignid, text, color, font) {
    Render.StringCustom(x - 1, y - 1, alignid, text, [0, 0, 0, color[3]], font);
    Render.StringCustom(x - 1, y, alignid, text, [0, 0, 0, color[3]], font); 

    Render.StringCustom(x - 1, y + 1, alignid, text, [0, 0, 0, color[3]], font);   
    Render.StringCustom(x, y + 1, alignid, text, [0, 0, 0, color[3]], font);

    Render.StringCustom(x, y - 1, alignid, text, [0, 0, 0, color[3]], font);
    Render.StringCustom(x + 1, y - 1, alignid, text, [0, 0, 0, color[3]], font);

    Render.StringCustom(x + 1, y, alignid, text, [0, 0, 0, color[3]], font);
    Render.StringCustom(x + 1, y + 1, alignid, text, [0, 0, 0, color[3]], font);

    Render.StringCustom(x, y, alignid, text, color, font);
}

function GetVelocity(index) {
    var velocity = Entity.GetProp(index, "CBasePlayer", "m_vecVelocity[0]");
    return Math.sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]);
}

Math.rad = function(degrees) {
  return degrees * Math.PI / 180;
}

function rotate_point(x, y, rot, size) {
    return [Math.cos(Math.rad(rot)) * size + x, Math.sin(Math.rad(rot)) * size + y]
}

function normalize_yaw(yaw) {
    while (yaw > 180) { yaw = yaw - 360 }
    while (yaw < -180) { yaw = yaw + 360 }
    return yaw
}

function calc_angle(local_x, local_y, enemy_x, enemy_y) {
    var ydelta = local_y - enemy_y
    var xdelta = local_x - enemy_x

    var relativeyaw = Math.atan(ydelta / xdelta)
    relativeyaw = normalize_yaw(relativeyaw * 180 / Math.PI)

    if (xdelta >= 0) {
        relativeyaw = normalize_yaw(relativeyaw + 180)
    }
    
    return relativeyaw
}

function renderer_arrow(x, y, color, rotation, size) {
    var x0 = rotate_point(x, y, rotation, 45)[0]
    var y0 = rotate_point(x, y, rotation, 45)[1]

    var x1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))[0]
    var y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))[1]

    var x2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))[0]
    var y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))[1]

    Render.Polygon([[x0, y0], [x1, y1], [x2, y2]], color)
}

function renderer_circle_outline(x, y, color, radius, start_angle, percent, thickness) {
    var precision = (2 * Math.PI) / 30;
    var step = Math.PI / 180;
    var inner = radius - thickness;
    var end_angle = (start_angle + percent) * step;
    var start_angle = (start_angle * Math.PI) / 180;

    for (; radius > inner; --radius) {
        for (var angle = start_angle; angle < end_angle; angle += precision) {
            var cx = Math.round(x + radius * Math.cos(angle));
            var cy = Math.round(y + radius * Math.sin(angle));

            var cx2 = Math.round(x + radius * Math.cos(angle + precision));
            var cy2 = Math.round(y + radius * Math.sin(angle + precision));

            Render.Line(cx, cy, cx2, cy2, color);
        }
    }
}

function get_sliders(plocal) {
    var arr = []

    var sim_time = Entity.GetProp(plocal, "CBaseEntity", "m_flSimulationTime");

    var RealYaw = Local.GetRealYaw();
    var FakeYaw = Local.GetFakeYaw();
    var delta = Math.min(Math.abs(RealYaw - FakeYaw) / 2, 60).toFixed(0);

    var speed = GetVelocity(plocal)

    var val = UI.GetValue("Script items", "Indicator settings")

    if (val & (1<<0)) {
        arr[arr.length + 0] = {
            v: delta,
            p: delta / 60,
            t: "FAKE YAW",
        }
    }

    if (val & (1<<1)) {
        arr[arr.length + 0] = {
            v: Math.round(speed).toString(),
            p: speed / 250,
            t: "VELOCITY"
        }
    }
    return arr
}

function get_keys() {
    var arr = []

    if (UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap")) {
        arr[arr.length + 0] = {
            t: "DOUBLE TAP",
            v: "TOGGLED"
        }
    }
    if (UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots")) {
        arr[arr.length + 0] = {
            t: "HIDE SHOTS",
            v: "TOGGLED"
        }
    }
    if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Slow walk")) {
        arr[arr.length + 0] = {
            t: "SLOW WALK",
            v: "HOLD"
        }
    }
    if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Fake duck")) {
        arr[arr.length + 0] = {
            t: "FAKE DUCK",
            v: "HOLD"
        }
    }
    if (UI.IsHotkeyActive("Misc", "GENERAL", "Movement", "Auto peek")) {
        arr[arr.length + 0] = {
            t: "AUTO PEEK",
            v: "HOLD"
        }
    }
    if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point")) {
        arr[arr.length + 0] = {
            t: "FORCE SAFE POINT",
            v: "TOGGLED"
        }
    }
    if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim")) {
        arr[arr.length + 0] = {
            t: "FORCE BODY AIM",
            v: "TOGGLED"
        }
    }
    return arr
}

function onCreateMove() {
    if (UI.IsHotkeyActive("Script items", "Manual left")) {
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", -90);
    }
    if (UI.IsHotkeyActive("Script items", "Manual right")) {
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", 90);
    }
    if (UI.IsHotkeyActive("Script items", "Manual back")) {
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", 0);
    }
}
Cheat.RegisterCallback("CreateMove", "onCreateMove");

function draw() {
    var sx = Render.GetScreenSize()[0]
    var sy = Render.GetScreenSize()[1]

    var plocal = Entity.GetLocalPlayer()
    var click = Input.IsKeyPressed(0x01)
    
    var font = Render.AddFont("Small fonts", 6, 400)
    var val = UI.GetValue("Script items", "Indicator settings")

    var sliders = []
    var keys = []
    var x = UI.GetValue("Script items", "p_x")
    var y = UI.GetValue("Script items", "p_y")

    var scale = 1
    if(val & (1<<4)) {
        scale = 1.5 
    }

    var w = 200 * scale
    var h =  20 * scale
    var i_dist = scale == 1 && 16 || 18 

    var text_size = function(text) {
        return Render.TextSizeCustom(text, font)
    }

    var color = UI.GetColor("Script items", "Indicator color picker")
    var color1 = UI.GetColor("Script items", "Indicator desync color")

    var value1 = UI.GetValue("Script items", "Teamskeet ESP")
    if (value1 & (1<<0)) {
        sliders = get_sliders(plocal)

        Render.FilledRect(x, y, w, h, [20, 20, 20, 255])
        Render.OutlineStringCustom(x + (w / 2) - (text_size("INDICATORS")[0] / 2), y + (i_dist / 2) - (text_size("INDICATORS")[1] / 2) + 1, 0, "INDICATORS", [255, 255, 255, 255], font)    

        if (val & (1<<2)) {
            Render.GradientRect(x, y, w / 2, scale * 2, 1, [0, 200, 255, 255], [255, 0, 255, 255])
            Render.GradientRect(x + w / 2, y, w / 2, scale * 2, 1, [255, 0, 255, 255], [175, 255, 0, 255])
        } else {
            Render.FilledRect(x, y, w, scale * 2, color)
            Render.FilledRect(x, y, w, scale * 2, color)
        }

        var m_h = (sliders.length * i_dist)

        Render.FilledRect(x, y + i_dist, w, m_h, [25, 25, 25, 255])
        Render.FilledRect(x, y + i_dist + m_h, w, 5, [20, 20, 20, 255])

        for (var i = 0; i < sliders.length; i++) {
            Render.OutlineStringCustom(x + 5, y + ((i + 1) * i_dist) + 3, 0, sliders[i].t, [255, 255, 255, 255], font)

            var stx = x + Math.floor(w / 4.5) + 8
            var sty = y + ((i + 1) * i_dist) + 4
            var m_w = Math.floor(w / 1.33) + (scale == 1 && 0 || 1) - 8
            var height = scale == 1 && h / 2.25 || h / 2.75

            if (val & (1<<3)) {
                stx = x + Math.floor(w / 3.25) + 5
                sty = y + ((i + 1) * i_dist) + 4
                m_w = Math.floor(w / 1.5) - 5
                Render.OutlineStringCustom(x + Math.floor(w / 4.5) + text_size(sliders[i].t)[0] - 35, y + ((i + 1) * i_dist) + 3, 0, sliders[i].v, [255, 255, 255, 255], font)
            }

            var width = Math.max(Math.min(m_w, m_w * sliders[i].p), 5)

            if (val & (1<<2)) {
                Render.GradientRect(stx, sty, Math.floor(m_w / 2), height, 1, [0, 200, 255, 255], [255, 0, 255, 255])
                Render.GradientRect(stx + Math.floor(m_w / 2), sty, Math.floor(m_w / 2), height, 1, [255, 0, 255, 255], [175, 255, 0, 255])
                Render.FilledRect(stx + 1, sty + 1, m_w - 3, height - 2, [25, 25, 25, 150])

                var amt = m_w - width
                if (amt > 0) {
                    Render.FilledRect(x + w - 5 - amt, sty, amt, height, [25, 25, 25, 255])
                }
            } else {
                Render.FilledRect(stx, sty, width, height, color)
                Render.FilledRect(stx + 1, sty + 1, width - 3, height - 2, [25, 25, 25, 150])
            }
        }

        if (is_dragging(x, y, w, h)) {
            dragging = true
        } else if (!click) {
            dragging = false
        }
    }

    if (value1 & (1<<1)) {
        var x2 = x, y2 = y + h + (sliders.length * i_dist) + 5

        Render.FilledRect(x2, y2, w, h, [20, 20, 20, 255])
        Render.OutlineStringCustom(x2 + (w / 2) - (text_size("KEYBINDS")[0] / 2), y2 + (i_dist / 2) - (text_size("KEYBINDS")[1] / 2) + 1, 0, "KEYBINDS", [255, 255, 255, 255], font)    
    
        if (val & (1<<2)) {
            Render.GradientRect(x2, y2, w / 2, scale * 2, 1, [0, 200, 255, 255], [255, 0, 255, 255])
            Render.GradientRect(x2 + w / 2, y2, w / 2, scale * 2, 1, [255, 0, 255, 255], [175, 255, 0, 255])
        } else {
            Render.FilledRect(x2, y2, w, scale * 2, color)
            Render.FilledRect(x2, y2, w, scale * 2, color)
        }

        keys = get_keys()

        Render.FilledRect(x2, y2 + i_dist, w, keys.length * i_dist, [25, 25, 25, 255])

        for (var i = 0; i < keys.length; i++) {
            var tw = Render.TextSizeCustom(keys[i].v, font)[0], th = Render.TextSizeCustom(keys[i].v, font)[1]
            var cur_pos = y2 + ((i + 1) * i_dist) + 3

            if (val & (1<<2)) {
                Render.OutlineStringCustom(x2 + 5, cur_pos, 0, keys[i].t, [100, 200, 255, 255], font)
                Render.OutlineStringCustom(x2 + w - 10 - tw, cur_pos, 0, keys[i].v, [175, 255, 0, 255], font)
            } else {
                Render.OutlineStringCustom(x2 + 5, cur_pos, 0, keys[i].t, color, font)
                Render.OutlineStringCustom(x2 + w - 10 - tw, cur_pos, 0, keys[i].v, [255, 255, 255, 255], font)
            }
        }
        if (is_dragging(x2, y2, w, (keys.length * i_dist) + h)) {
            dragging = true
        } else if (!click) {
            dragging = false
        }
    }

    if (value1 & (1<<2)) {
        var cx = sx / 2
        var cy = sy / 2

        var cam = Local.GetViewAngles()

        var h = Entity.GetHitboxPosition(plocal, 0)
        var p = Entity.GetHitboxPosition(plocal, 2)

        var yaw = normalize_yaw(calc_angle(p[0], p[1], h[0], h[1]) - cam[1] + 120)
        var bodyyaw = Local.GetRealYaw() - Local.GetFakeYaw()
        var fakeangle = normalize_yaw(yaw + bodyyaw)
        var offset = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset")

        var values = UI.GetValue("Script items", "Anti-aim indicator type")

        if (values == 1) {
            renderer_circle_outline(cx, cy + 1, [100, 100, 100, 100], 30, 0, 360, 4)
            renderer_circle_outline(cx, cy + 1, color, 30, (fakeangle * -1) - 15, 36, 4)
            renderer_circle_outline(cx, cy + 1, color1, 30, (yaw * -1) - 15, 36, 4)
        } else if (values == 0) {
            renderer_arrow(cx, cy, color, (yaw - 25) * -1, 45)
            renderer_arrow(cx, cy, color1, (fakeangle - 25) * -1, 25)
        } else {
            Render.Polygon([[cx + 55, cy + 1], [cx + 42, cy + 10], [cx + 42, cy - 8]],
                [
                    offset == 90 && color[0] || 35, 
                    offset == 90 && color[1] || 35, 
                    offset == 90 && color[2] || 35, 
                    offset == 90 && color[3] || 150
                ]
            )
            Render.Polygon([[cx - 55, cy + 2], [cx - 42, cy - 7], [cx - 42, cy + 11]], 
                [
                    offset == -90 && color[0] || 35, 
                    offset == -90 && color[1] || 35, 
                    offset == -90 && color[2] || 35, 
                    offset == -90 && color[3] || 150
                ]
            )
            Render.FilledRect(cx + 38, cy - 7, 2, 18, 
                [
                    bodyyaw < 0 && color1[0] || 35,
                    bodyyaw < 0 && color1[1] || 35,
                    bodyyaw < 0 && color1[2] || 35,
                    bodyyaw < 0 && color1[3] || 150
                ]
            )
            Render.FilledRect(cx - 40, cy - 7, 2, 18,          
                [   
                    bodyyaw > 0 && color1[0] || 35,
                    bodyyaw > 0 && color1[1] || 35,
                    bodyyaw > 0 && color1[2] || 35,
                    bodyyaw > 0 && color1[3] || 150
                ]
            )
        }
    }

    run_dragging(dragging)
}
Cheat.RegisterCallback("Draw", "draw")