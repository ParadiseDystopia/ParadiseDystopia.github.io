var easing = {
    lerp: function(a, b, percentage) {
        return a + (b - a) * percentage
    }
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

var anti_aimbot = {
    get_desync: function() {
        var RealYaw = Local.GetRealYaw();
        var FakeYaw = Local.GetFakeYaw();
        var delta = Math.min(Math.abs(RealYaw - FakeYaw) / 2, 58).toFixed(1);

        return delta
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

Render.CircleOutline = function(x, y, color, radius, start_angle, percent, thickness) {
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

Render.RoundedRectangle = function(x, y, w, h, color) {
    Render.FilledRect(x, y, w - 4, h, color)
    Render.FilledRect(x - 1, y + 1, w - 2, h - 2, color)
}

var fonts = function(size, h) {
    return {
        verdana: Render.AddFont("Verdana", size == undefined ? 7 : size, h == undefined ? 400 : h),
        small: Render.AddFont("Small fonts", size == undefined ? 5 : size, h == undefined ? 400 : h)
    }
}

UI.AddSliderInt("", 0, 0)

var main_color = UI.AddColorPicker("Main color")
var add_x = UI.AddSliderInt("Add x", -1000, 1000)
var add_y = UI.AddSliderInt("Add y", -1000, 1000)
var enable_line = UI.AddCheckbox("Enable line")

UI.SetValue("Script Items", "Add x", -20)
UI.SetValue("Script Items", "Add y", 30)
UI.SetColor("Script Items", "Main color", [142, 165, 229, 255])

UI.AddSliderInt("", 0, 0)

var holo = {
    hud: {
        x: 0,
        y: 0,

        line_x: 0,
        line_y: 0,

        alpha: 0,

        width: 0,
        height: 0,

        sp_width: 0,
        exp_width: 0,

        add_line_x: 100,
        add_line_y: 0,
        anim_line_x: 0,
        anim_line_y: 0,

        g_paint_handler: function() {
            var self = holo.hud

            var font = {
                verdana: fonts().verdana,
                small: fonts().small
            }

            var me = {
                player: Entity.GetLocalPlayer(),
                hitbox: Entity.GetHitboxPosition(Entity.GetLocalPlayer(), 3),
                desync: anti_aimbot.get_desync(),
                cam: Local.GetViewAngles(),
                h: Entity.GetHitboxPosition(Entity.GetLocalPlayer(), 0),
                p: Entity.GetHitboxPosition(Entity.GetLocalPlayer(), 2)
            }
            var pos = {
                world: Render.WorldToScreen(me.hitbox)
            }
            var color = {
                main: UI.GetColor.apply(null, main_color),
                desync: [170 + (154 - 186) * me.desync / 60 , 0 + (255 - 0) * me.desync / 60 , 16 + (0 - 16) * me.desync / 60 , 255]
            }

            var yaw = normalize_yaw(calc_angle(me.p[0], me.p[1], me.h[0], me.h[1]) - me.cam[1] + 120)
            var bodyyaw = Local.GetRealYaw() - Local.GetFakeYaw()
            var fakeangle = normalize_yaw(yaw + bodyyaw)

            if (UI.IsHotkeyActive("Visuals", "World", "View", "Thirdperson")) {
                self.x = easing.lerp(self.x, pos.world[0] + 100 + UI.GetValue.apply(null, add_x), Globals.Frametime() * 8)
                self.y = easing.lerp(self.y, pos.world[1] - 150 + UI.GetValue.apply(null, add_y), Globals.Frametime() * 8)

                self.alpha = easing.lerp(self.alpha, 1, Globals.Frametime() * 8)

                self.width = easing.lerp(self.width, 150, Globals.Frametime() * 8)
            } else {
                self.alpha = easing.lerp(self.alpha, 0, Globals.Frametime() * 8)
            }
            self.sp_width = easing.lerp(self.sp_width, (28 / 58) * me.desync, Globals.Frametime() * 4)
            self.exp_width = easing.lerp(self.exp_width, Exploit.GetCharge() < 0.3 ? 0 : Exploit.GetCharge(), Globals.Frametime() * 4)

            if (Exploit.GetCharge() > 0.3) {
                self.height = easing.lerp(self.height, 78, Globals.Frametime() * 8)
                self.add_line_y = easing.lerp(self.add_line_y, 75, Globals.Frametime() * 8)
            } else {
                self.height = easing.lerp(self.height, 65, Globals.Frametime() * 8)
                self.add_line_y = easing.lerp(self.add_line_y, 85, Globals.Frametime() * 8)       
            }

            Render.FilledRect(self.x, self.y, self.width, self.height, [15, 15, 15, 100 * self.alpha])
            Render.FilledRect(self.x, self.y, self.width, 2, [color.main[0], color.main[1], color.main[2], color.main[3] * self.alpha])

            Render.CircleOutline(self.x + 128, self.y + 20, [20, 20, 20, 200 * self.alpha], 10, 0, 360, 2.5)
            Render.CircleOutline(self.x + 128, self.y + 20, [color.main[0], color.main[1], color.main[2], 200 * self.alpha], 10, (fakeangle * -1) - 15, 36, 2.5)
            Render.CircleOutline(self.x + 128, self.y + 20, [255, 255, 255, 200 * self.alpha], 10, (yaw * -1) - 15, 36, 2.5)

            if (UI.GetValue.apply(null, enable_line)) {
                self.line_x = easing.lerp(self.line_x, pos.world[0], Globals.Frametime() * 8)
                self.line_y = easing.lerp(self.line_y, pos.world[1], Globals.Frametime() * 8)

                if (UI.GetValue.apply(null, add_x) <= -280) {
                    self.add_line_x = easing.lerp(self.add_line_x, 100 + self.width, Globals.Frametime() * 8)
                } else {
                    self.add_line_x = easing.lerp(self.add_line_x, 100, Globals.Frametime() * 8)
                }

                self.anim_line_x = easing.lerp(self.anim_line_x, self.add_line_x + UI.GetValue.apply(null, add_x), Globals.Frametime() * 8)
                self.anim_line_y = easing.lerp(self.anim_line_y, -self.add_line_y + UI.GetValue.apply(null, add_y), Globals.Frametime() * 8)

                Render.Line(self.line_x, self.line_y, self.line_x + self.anim_line_x, self.line_y + self.anim_line_y, [255, 255, 255, 125 * self.alpha]);
            }

            Render.OutlineStringCustom(self.x + 7, self.y + 7, 0, "ANTI-AIMBOT DEBUG", [255, 255, 255, 255 * self.alpha], font.small)

            var dec = [color.desync[0] - (color.desync[0] / 100 * 50), color.desync[1] - (color.desync[1] / 100 * 50), color.desync[2] - (color.desync[2] / 100 * 50)]
            Render.GradientRect(self.x + 7, self.y + (25 - 4), 2, (18 / 2), 0, [dec[0], dec[1], dec[2], 0 * self.alpha], [color.desync[0], color.desync[1], color.desync[2], 255 * self.alpha]);
            Render.GradientRect(self.x + 7, self.y + ((25 + 18 / 2) - 4), 2, (18 / 2), 0, [color.desync[0], color.desync[1], color.desync[2], 255 * self.alpha], [dec[0], dec[1], dec[2], 0 * self.alpha]);
            Render.StringCustom(self.x + 15, self.y + 23, 0, "FAKE (" + me.desync.toString() + ")", [255, 255, 255, 255 * self.alpha], font.verdana)

            Render.OutlineStringCustom(self.x + 7, self.y + 48, 0, "SP:", [255, 255, 255, 255 * self.alpha], font.small)

            Render.RoundedRectangle(self.x + 25, self.y + 49, 28, 6, [15, 15, 15, 70 * self.alpha])
            if (Local.GetRealYaw() - Local.GetFakeYaw() > 0) {
                Render.RoundedRectangle(self.x + 25, self.y + 49, self.sp_width, 6, [color.main[0], color.main[1], color.main[2], 255 * self.alpha])
            }

            Render.RoundedRectangle(self.x + 54, self.y + 49, 28, 6, [15, 15, 15, 70 * self.alpha])
            if (Local.GetRealYaw() - Local.GetFakeYaw() < 0){
                Render.RoundedRectangle(self.x + 54, self.y + 49, self.sp_width, 6, [color.main[0], color.main[1], color.main[2], 255 * self.alpha])
            }

            if (Exploit.GetCharge() > 0.3) {
                Render.OutlineStringCustom(self.x + 7, self.y + 63, 0, "EXPLOITING:", [255, 255, 255, 255 * self.alpha], font.small)

                Render.RoundedRectangle(self.x + 104, self.y + 63, 40, 6, [15, 15, 15, 70 * self.alpha])
                Render.RoundedRectangle(self.x + 104, self.y + 63, 40 * self.exp_width, 6, [color.main[0], color.main[1], color.main[2], 255 * self.alpha])
            }

            var osa_state = "OFF"
            var osa_color = [255, 0, 0, 255]

            if (UI.IsHotkeyActive("Rage", "Exploits", "Hide shots")) {
                osa_state = "ON"
                osa_color = [0, 255, 0, 255]
            }

            Render.OutlineStringCustom(self.x + ((self.width - 15) - Render.TextSizeCustom(osa_state, font.small)[0] / 2), self.y + 48, 0, osa_state, [osa_color[0], osa_color[1], osa_color[2], 255 * self.alpha], font.small)
            Render.OutlineStringCustom(self.x + ((self.width - 15) - ((Render.TextSizeCustom(osa_state, font.small)[0] / 2) + 24)), self.y + 48, 0, "OSAA:", [255, 255, 255, 255 * self.alpha], font.small)
        }
    }
}
Cheat.RegisterCallback("Draw", "holo.hud.g_paint_handler")