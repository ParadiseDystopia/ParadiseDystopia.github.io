var renderer = {
	triangle: function(x0, y0, x1, y1, x2, y2, r, g, b, a) {
		return Render.Polygon([[x0, y0], [x1, y1], [x2, y2]], [r, g, b, a]);
	}
}

var menu = {
    Switch: function(name, state) {
        UI.AddCheckbox(name)
        UI.SetValue("Script items", name, state)
    },

    Hotkey: function(name) {
        return UI.AddHotkey(name)
    },

    SliderInt: function(name, default_value, min, max) {
        UI.AddSliderInt(name, min, max)
        UI.SetValue("Script items", name, default_value)
    },

    SliderFloat: function(name, default_value, min, max) {
        UI.AddSliderFloat(name, min, max)
        UI.SetValue("Script items", name, default_value)
    },

    ColorEdit: function(name, color) {
        UI.AddColorPicker(name)
        UI.SetColor("Script items", name, color)
    },

    Combo: function(name, elements) {
        return UI.AddMultiDropdown(name, elements)
    },

    Text: function(name) {
        return UI.AddLabel(name)
    },

    Block: function(name) {
        return UI.AddSliderFloat(name, 0, 0)
    },

    SetVisible: function(name, state) {
        return UI.SetEnabled("Script items", name, state)
    },

    GetValue: function(name) {
        return UI.GetValue("Script items", name)
    },

    GetColor: function(name) {
        return UI.GetColor("Script items", name)
    },

    SetValue: function(name, value) {
        return UI.SetValue("Script items", name, value)
    }
}

menu.Switch("Enable China hat", true)
menu.ColorEdit("China color", [0, 255, 255, 255])
menu.Switch("Gradient", false)
menu.SliderInt("Speed China", 5, 1, 10)

var renderer_triangle = function(v2_A, v2_B, v2_C, r, g, b, a) {
    var i = function(j, k, l) {
        var m = (k.y - j.y) * (l.x - k.x) - (k.x - j.x) * (l.y - k.y)

        if (m < 0) { 
        	return true 
        }
        return false
    }

    if (i(v2_A, v2_B, v2_C)) { 
    	renderer.triangle(v2_A.x, v2_A.y, v2_B.x, v2_B.y, v2_C.x ,v2_C.y, r, g, b, a)
    } else if (i(v2_A, v2_C, v2_B)) { 
    	renderer.triangle(v2_A.x, v2_A.y, v2_C.x, v2_C.y, v2_B.x, v2_B.y, r, g, b, a)
    } else if (i(v2_B, v2_C, v2_A)) { 
    	renderer.triangle(v2_B.x, v2_B.y, v2_C.x, v2_C.y, v2_A.x, v2_A.y, r, g, b, a)
    } else if (i(v2_B, v2_A, v2_C)) { 
    	renderer.triangle(v2_B.x, v2_B.y, v2_A.x, v2_A.y, v2_C.x, v2_C.y, r, g, b, a)
    } else if (i(v2_C, v2_A, v2_B)) { 
    	renderer.triangle(v2_C.x, v2_C.y, v2_A.x, v2_A.y, v2_B.x, v2_B.y, r, g, b, a)
    } else {
    	renderer.triangle(v2_C.x, v2_C.y, v2_B.x, v2_B.y, v2_A.x, v2_A.y, r, g, b, a) 
    }
}

var hsv_to_rgb = function(h, s, v) {
    var r, g, b, i, f, p, q, t;

    if (arguments.length === 1) {
        s = h.s, v = h.v, h = h.h;
    }

    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);

    switch (i % 6) {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;
        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;
        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break;
    }

    return {
        r: Math.round(r * 255),
        g: Math.round(g * 255),
        b: Math.round(b * 255)
    }
}

Math.rad = function(degree){
    return degree * Math.PI / 180.0;
}

var world_circle = function(origin, size) {
	if(origin[0] == null) return

	var last_point = null

    var gradient_g = menu.GetValue("Gradient")
    var color_g = [menu.GetColor("China color")[0], menu.GetColor("China color")[1], menu.GetColor("China color")[2], menu.GetColor("China color")[3]]

    for (var i = 0; i < 361; i++) {
        var new_point = [
            origin[0] - (Math.sin(Math.rad(i)) * size),
            origin[1] - (Math.cos(Math.rad(i)) * size),
            origin[2]
        ]

        var actual_color = color_g

        if (gradient_g) {
        	var hue_offset = 0

        	hue_offset = ((Globals.Realtime() * (menu.GetValue("Speed China") * 50)) + i) % 360
        	hue_offset = Math.min(360, Math.max(0, hue_offset))

        	var g_color = hsv_to_rgb(hue_offset / 360, 1, 1)

        	color_g = [g_color.r, g_color.g, g_color.b, 255]
        }

    	if (last_point != null) {
    		var old_screen_point = Render.WorldToScreen([last_point[0], last_point[1], last_point[2]])
    		var new_screen_point = Render.WorldToScreen([new_point[0], new_point[1], new_point[2]])
    		var origin_screen_point = Render.WorldToScreen([origin[0], origin[1], origin[2] + 8])

    		if (old_screen_point[0] != null && new_screen_point[0] != null && origin_screen_point[0] != null) {
            	renderer_triangle({"x": old_screen_point[0], "y": old_screen_point[1]}, {"x": new_screen_point[0], "y": new_screen_point[1]}, {"x": origin_screen_point[0], "y": origin_screen_point[1]}, color_g[0], color_g[1], color_g[2], 50)     
    		}
    	}
    	last_point = new_point
    }
}

var on_paint = function() {
    var master_state = menu.GetValue("Enable China hat")
    menu.SetVisible("China color", master_state)
    menu.SetVisible("Gradient", master_state)
    menu.SetVisible("Speed China", master_state && menu.GetValue("Gradient"))

    if (!master_state || !UI.IsHotkeyActive("Visuals", "World", "View", "Thirdperson") || !Entity.GetLocalPlayer() || !Entity.IsAlive(Entity.GetLocalPlayer())) {
        return
    }

	var hb = Entity.GetHitboxPosition(Entity.GetLocalPlayer(), 0)
	world_circle([hb[0], hb[1], hb[2]], 10)
}

Cheat.RegisterCallback("Draw", "on_paint");