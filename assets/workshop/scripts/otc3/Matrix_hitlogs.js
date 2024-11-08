if (!String.format) {
    String.format = function(format) {
        var args = Array.prototype.slice.call(arguments, 1)
        return format.replace(/{(\d+)}/g, function(match, number) { 
            return typeof args[number] != "undefined" ? args[number] : match
        })
    }
}

function TIME_TO_TICKS(time) {
    return Math.round(time / Globals.TickInterval())
}

var t_style = UI.AddDropdown("Text style", ["Default", "Shadow"])

var hit_color = UI.AddColorPicker("Hit color")
var shot_color = UI.AddColorPicker("Shot color")

Render.ShadowStringCustom = function(x, y, alignid, text, color, font) {
	Render.StringCustom(x + 1, y + 1, alignid, text, [0, 0, 0, 255 * color[3] / 255], font)
	Render.StringCustom(x, y, alignid, text, color, font)
}

var renderer = {
	measure_multi_color_text: function(lines, font) {
	    var w = 0
	    for (var x = 0; x < lines.length; x++) {
	        w += Render.TextSizeCustom(lines[x][0], font)[0]
	    }
	    return w
	},

	multi_color_text: function(x, y, lines, font, alpha) {
	    var x_pad = 0
	    for (var i = 0; i < lines.length; i++) {
	        var line = lines[i]
	        var text = line[0]
	       	var color = line[1]
	       	//color = color == 1 ? UI.GetColor.apply(null, hit_color) : UI.GetColor.apply(null, shot_color)
	       	if (line[1] == 1) {
	       		color = UI.GetColor.apply(null, hit_color)
	       	} else if (line[1] == 0) {
	       		color = UI.GetColor.apply(null, shot_color)
	       	}

	        Render[UI.GetValue.apply(null, t_style) == 0 ? "StringCustom" : "ShadowStringCustom"](x + x_pad, y, 0, text, [color[0], color[1], color[2], color[3] * alpha], font)
	        var w = Render.TextSizeCustom(text, font)[0]
	        x_pad += w
	    }
	}
}

var easing = {
    lerp: function(a, b, percentage) {
        return a + (b - a) * percentage
    }
}

var hitboxes = ["generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "body"]
var get_hitbox = function(i){ return hitboxes[i] || "Generic" }

var hitlog = {
	hlogs: new Array,

	on_draw: function() {
		var font = Render.AddFont("Verdana", 7, 400)

		var size = Render.GetScreenSize()
		size = [size[0], size[1] - 300]
		var sy = size[1]

		if (!World.GetServerString()) {
			hitlog.hlogs.splice(0, hitlog.hlogs.length)
		}

		for (var i = 0; i < hitlog.hlogs.length; i++) {
			var text = hitlog.hlogs[i][0]
			var curtime = hitlog.hlogs[i][4]

			var time = curtime + 7
			var time_left = time - Globals.Curtime()

			if (time_left < 0.6) {
				hitlog.hlogs[i][2] = easing.lerp(hitlog.hlogs[i][2], 10, Globals.Frametime() * 8)
				hitlog.hlogs[i][3] = easing.lerp(hitlog.hlogs[i][3], 0, Globals.Frametime() * 8)
			} else {
				hitlog.hlogs[i][3] = easing.lerp(hitlog.hlogs[i][3], 1, Globals.Frametime() * 8)
				hitlog.hlogs[i][1] = easing.lerp(hitlog.hlogs[i][1], 1, Globals.Frametime() * 8)
				hitlog.hlogs[i][2] = easing.lerp(hitlog.hlogs[i][2], 0, Globals.Frametime() * 8)
			}

			if (hitlog.hlogs[i][3] <= 0) {
				hitlog.hlogs.splice(i, 1)
			}

			if (hitlog.hlogs.length > 5) {
				hitlog.hlogs.pop()
			}

			sy = sy + 13 * hitlog.hlogs[i][1]

			renderer.multi_color_text(((size[0] / 2) - (renderer.measure_multi_color_text(text, font) / 2)) + 12 * hitlog.hlogs[i][2], sy, text, font, hitlog.hlogs[i][3]);
		}
	},

	on_player_hurt: function() {
	    var uid = Entity.GetEntityFromUserID(Event.GetInt("userid"))
	    var attacker = Entity.GetEntityFromUserID(Event.GetInt("attacker"))

        var text_hit = [
            ["Hit ", [255, 255, 255, 255]],
            [Entity.GetName(uid), 1],
            [" in the ", [255, 255, 255, 255]],
            [get_hitbox(Event.GetInt("hitgroup")), 1],
            [" for ", [255, 255, 255, 255]],
            [Event.GetInt("dmg_health").toString(), 1],
            [" damage (", [255, 255, 255, 255]],
            [Event.GetInt("health").toString(), 1],
            [" health remaining", [255, 255, 255, 255]],
            [")", [255, 255, 255, 255]]
        ]

        var text_shot = [
            [Entity.GetName(attacker), 0],
            [" shot at you in the ", [255, 255, 255, 255]],
            [get_hitbox(Event.GetInt("hitgroup")), 0],
            [" for ", [255, 255, 255, 255]],
            [Event.GetInt("dmg_health").toString(), 0],
            [" damage", [255, 255, 255, 255]]
        ];

	    if(Entity.IsLocalPlayer(attacker) && attacker != uid) {
	    	hitlog.hlogs.unshift([text_hit, 0, 0, 0, Globals.Curtime()])
	    }

	    if (!Entity.IsLocalPlayer(attacker) && uid == Entity.GetLocalPlayer()) {
	    	hitlog.hlogs.unshift([text_shot, 0, 0, 0, Globals.Curtime()])
	    }
	}
}

Cheat.RegisterCallback("Draw", "hitlog.on_draw")
Cheat.RegisterCallback("player_hurt", "hitlog.on_player_hurt")