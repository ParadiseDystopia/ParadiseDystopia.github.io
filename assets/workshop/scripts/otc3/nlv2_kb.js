var easing = {
    lerp: function(a, b, percentage) {
        return a + (b - a) * percentage
    }
}

var mouse_on_object = function(x, y, length, height) {
    var cursor = Input.GetCursorPosition()
    if (cursor[0] > x && cursor[0] < x + length && cursor[1] > y && cursor[1] < y + height)
        return true
    return false
}

UI.AddSliderInt("nl_hotkey_x", 0, Global.GetScreenSize()[0])
UI.AddSliderInt("nl_hotkey_y", 0, Global.GetScreenSize()[1])
UI.SetEnabled("Script items", "nl_hotkey_x", false)
UI.SetEnabled("Script items", "nl_hotkey_y", false)

UI.AddDropdown("Theme", ["Dark Blue", "Light", "Dark"])

var classes = {
    theme: {
        color: {
            [0]: {
                r: 13,
                g: 18,
                b: 31,

                t_r: 255,
                t_g: 255,
                t_b: 255,

                i_r: 43,
                i_g: 155,
                i_b: 255
            },
            [1]: {
                r: 204,
                g: 204,
                b: 204,

                t_r: 0,
                t_g: 0,
                t_b: 0,

                i_r: 0,
                i_g: 0,
                i_b: 0
            },
            [2]: {
                r: 15,
                g: 15,
                b: 15,

                t_r: 255,
                t_g: 255,
                t_b: 255,

                i_r: 43,
                i_g: 155,
                i_b: 255
            }
        }
    },

    keybinds: {
        list: [
            ["Slow motion", ["Anti-Aim", "Extra", "Slow walk"], 0],
            ["Force body aim", ["Rage", "General", "Force body aim"], 0],
            ["Force safe point", ["Rage", "General", "Force safe point"], 0],
            ["Anti-aim inverter", ["Anti-Aim", "Fake angles", "Inverter"], 0],
            ["Auto peek", ["Misc", "Movement", "Auto peek"], 0],
            ["Edge jump", ["Misc", "Movement", "Edge jump"], 0],
            ["Fake duck", ["Anti-Aim", "Extra", "Fake duck"], 0],
            ["Hide shots", ["Rage", "Exploits", "Hide shots"], 0],
            ["Double tap", ["Rage", "Exploits", "Doubletap"], 0],
        ],

        alpha: 0,
        latest_item_width: 0,
        item_width: 0,
        width: 0,
        height: 0,
        kb: new Array,
        kbh: new Array,
        stored: false,
        drag: new Array(0, 0, 0),

        on_draw: function() {
            var pos = {
                x: UI.GetValue("Script items", "nl_hotkey_x"),
                y: UI.GetValue("Script items", "nl_hotkey_y")
            }

            var font = Render.AddFont("MuseoSansCyrl-900", 9, 900)
            var font1 = Render.AddFont("MuseoSansCyrl-500", 9, 500)
            var icon = Render.AddFont("untitled-font-1", 13, 100)
            var color = classes.theme.color[UI.GetValue("Script items", "Theme")]

            for (i = 0; i < classes.keybinds.list.length; i++) {
                if (UI.IsHotkeyActive.apply(null, classes.keybinds.list[i][1])) {
                    if (classes.keybinds.kb.indexOf(classes.keybinds.list[i][0]) == -1) {
                        classes.keybinds.kb.push(classes.keybinds.list[i][0])
                        classes.keybinds.kbh.push(["on", classes.keybinds.list[i][2], classes.keybinds.list[i][1]])
                    }
                }
            }

            if (UI.IsMenuOpen() || classes.keybinds.kb.length > 0) {
                if (classes.keybinds.alpha <= 1) {
                    classes.keybinds.alpha = easing.lerp(classes.keybinds.alpha, 1, Globals.Frametime() * 12)
                } else {
                    classes.keybinds.alpha = 1
                }
            } else {
                if (classes.keybinds.alpha >= 0) {
                    classes.keybinds.alpha = easing.lerp(classes.keybinds.alpha, 0, Globals.Frametime() * 12)
                } else {
                    classes.keybinds.alpha = 0
                }
            }

            for (i = 0; i < classes.keybinds.kb.length; i++) {
                if (Render.TextSizeCustom(classes.keybinds.kb[i], font)[0] > classes.keybinds.latest_item_width) {
                    classes.keybinds.latest_item_width = Render.TextSizeCustom(classes.keybinds.kb[i], font1)[0]
                    classes.keybinds.item_width = classes.keybinds.latest_item_width
                }
            }
            classes.keybinds.width = easing.lerp(classes.keybinds.width, classes.keybinds.item_width + 80, Globals.Frametime() * 12)

            classes.keybinds.height = easing.lerp(classes.keybinds.height, 30 + 16 * (classes.keybinds.kb.length), Globals.Frametime() * 12)
            classes.keybinds.height = classes.keybinds.kb.length == 0 ? 0 : classes.keybinds.height

            var sy = pos.y + 11

            for (i = 0; i < classes.keybinds.list.length; i++) {
                if (UI.IsHotkeyActive.apply(null, classes.keybinds.list[i][1])) {
                    classes.keybinds.list[i][2] = easing.lerp(classes.keybinds.list[i][2], 1, Globals.Frametime() * 12)
                } else {
                    classes.keybinds.list[i][2] = easing.lerp(classes.keybinds.list[i][2], 0, Globals.Frametime() * 12)

                    classes.keybinds.kb.splice(i)
                    classes.keybinds.kbh.splice(i)
                    classes.keybinds.latest_item_width = 0
                }

                sy += 16 * classes.keybinds.list[i][2]

                Render.StringCustom(pos.x + 4, sy, 0, classes.keybinds.list[i][0], [255, 255, 255, 255 * classes.keybinds.alpha * classes.keybinds.list[i][2]], font1)
                Render.StringCustom((pos.x - Render.TextSizeCustom("on", font1)[0] - 5) + classes.keybinds.width, sy, 0, "on", [255, 255, 255, 255 * classes.keybinds.alpha * classes.keybinds.list[i][2]], font1)
            }
            
            Render.FilledRect(pos.x - 1, pos.y, classes.keybinds.width, classes.keybinds.height, [200, 200, 200, 15 * classes.keybinds.alpha])

            Render.FilledRect(pos.x, pos.y - 1, classes.keybinds.width - 2, 25 - 4, [color.r, color.g, color.b, 255 * classes.keybinds.alpha])
            Render.FilledRect(pos.x - 1, pos.y, classes.keybinds.width, 23 - 4, [color.r, color.g, color.b, 255 * classes.keybinds.alpha])
            Render.FilledRect(pos.x - 1, pos.y, classes.keybinds.width, 26 - 4, [color.r, color.g, color.b, 255 * classes.keybinds.alpha])

            Render.StringCustom(pos.x + 44, pos.y + 5 - 1, 1, "Binds", [color.t_r, color.t_g, color.t_b, 255 * classes.keybinds.alpha], font)
            Render.StringCustom(pos.x + 13, pos.y + 3 - 1, 1, "a", [color.i_r, color.i_g, color.i_b, 255 * classes.keybinds.alpha], icon)


            var cursor = Input.GetCursorPosition()
            if(mouse_on_object(pos.x - 2, pos.y - 2, classes.keybinds.width + 2, 26 - 1)){
                if ((Input.IsKeyPressed(0x01)) && (classes.keybinds.drag[0] == 0)) {
                    classes.keybinds.drag[0] = 1
                    classes.keybinds.drag[1] = pos.x - cursor[0]
                    classes.keybinds.drag[2] = pos.y - cursor[1]
                }
            }
            if (!Input.IsKeyPressed(0x01)) classes.keybinds.drag[0] = 0
            if (classes.keybinds.drag[0] == 1 && UI.IsMenuOpen()) {
                UI.SetValue("Script items", "nl_hotkey_x", cursor[0] + classes.keybinds.drag[1])
                UI.SetValue("Script items", "nl_hotkey_y", cursor[1] + classes.keybinds.drag[2])
            }
        }
    },
}
Cheat.RegisterCallback("Draw", "classes.keybinds.on_draw")