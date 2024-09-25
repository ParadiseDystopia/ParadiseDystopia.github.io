const globals_tickcount = Globals.Tickcount, globals_tickrate = Globals.Tickrate, globals_tick_interval = Globals.TickInterval, globals_curtime = Globals.Curtime, globals_realtime = Globals.Realtime, globals_frametime = Globals.Frametime, ui_get_value = UI.GetValue, ui_set_value = UI.SetValue, ui_add_checkbox = UI.AddCheckbox, ui_add_slider_int = UI.AddSliderInt, ui_add_slider_float = UI.AddSliderFloat, ui_add_hotkey = UI.AddHotkey, ui_add_label = UI.AddLabel, ui_add_dropdown = UI.AddDropdown, ui_add_multi_dropdown = UI.AddMultiDropdown, ui_add_color_picker = UI.AddColorPicker, ui_add_textbox = UI.AddTextbox, ui_set_enabled = UI.SetEnabled, ui_get_string = UI.GetString, ui_get_color = UI.GetColor, ui_set_color = UI.SetColor, ui_is_hotkey_active = UI.IsHotkeyActive, ui_toggle_hotkey = UI.ToggleHotkey, ui_is_menu_open = UI.IsMenuOpen, entity_get_entities = Entity.GetEntities, entity_get_entities_by_class_id = Entity.GetEntitiesByClassID, entity_get_players = Entity.GetPlayers, entity_get_enemies = Entity.GetEnemies, entity_get_teammates = Entity.GetTeammates, entity_get_local_player = Entity.GetLocalPlayer, entity_get_game_rules_proxy = Entity.GetGameRulesProxy, entity_get_entity_from_user_id = Entity.GetEntityFromUserID, entity_is_teammate = Entity.IsTeammate, entity_is_enemy = Entity.IsEnemy, entity_is_bot = Entity.IsBot, entity_is_local_player = Entity.IsLocalPlayer, entity_is_valid = Entity.IsValid, entity_is_alive = Entity.IsAlive, entity_is_dormant = Entity.IsDormant, entity_get_class_id = Entity.GetClassID, entity_get_class_name = Entity.GetClassName, entity_get_name = Entity.GetName, entity_get_weapon = Entity.GetWeapon, entity_get_weapons = Entity.GetWeapons, entity_get_render_origin = Entity.GetRenderOrigin, entity_get_render_box = Entity.GetRenderBox, entity_get_prop = Entity.GetProp, entity_set_prop = Entity.SetProp, entity_get_hitbox_position = Entity.GetHitboxPosition, entity_get_eye_position = Entity.GetEyePosition, render_string = Render.String, render_text_size = Render.TextSize, render_line = Render.Line, render_rect = Render.Rect, render_filled_rect = Render.FilledRect, render_gradient_rect = Render.GradientRect, render_circle = Render.Circle, render_filled_circle = Render.FilledCircle, render_polygon = Render.Polygon, render_world_to_screen = Render.WorldToScreen, render_add_font = Render.AddFont, render_find_font = Render.FindFont, render_string_custom = Render.StringCustom, render_textured_rect = Render.TexturedRect, render_add_texture = Render.AddTexture, render_text_size_custom = Render.TextSizeCustom, render_get_screen_size = Render.GetScreenSize, convar_get_int = Convar.GetInt, convar_set_int = Convar.SetInt, convar_get_float = Convar.GetFloat, convar_set_float = Convar.SetFloat, convar_get_string = Convar.GetString, convar_set_string = Convar.SetString, event_get_int = Event.GetInt, event_get_float = Event.GetFloat, event_get_string = Event.GetString, trace_line = Trace.Line, trace_bullet = Trace.Bullet, usercmd_set_movement = UserCMD.SetMovement, usercmd_get_movement = UserCMD.GetMovement, usercmd_set_angles = UserCMD.SetAngles, usercmd_force_jump = UserCMD.ForceJump, usercmd_force_crouch = UserCMD.ForceCrouch, sound_play = Sound.Play, sound_play_microphone = Sound.PlayMicrophone, sound_stop_microphone = Sound.StopMicrophone, local_latency = Local.Latency, local_get_view_angles = Local.GetViewAngles, local_set_view_angles = Local.SetViewAngles, local_set_clan_tag = Local.SetClanTag, local_get_real_yaw = Local.GetRealYaw, local_get_fake_yaw = Local.GetFakeYaw, local_get_spread = Local.GetSpread, local_get_inaccuracy = Local.GetInaccuracy, cheat_get_username = Cheat.GetUsername, cheat_register_callback = Cheat.RegisterCallback, cheat_execute_command = Cheat.ExecuteCommand, cheat_frame_stage = Cheat.FrameStage, cheat_print = Cheat.Print, cheat_print_chat = Cheat.PrintChat, cheat_print_color = Cheat.PrintColor, input_get_cursor_position = Input.GetCursorPosition, input_is_key_pressed = Input.IsKeyPressed, world_get_map_name = World.GetMapName, world_get_server_string = World.GetServerString, antiaim_get_override = AntiAim.GetOverride, antiaim_set_override = AntiAim.SetOverride, antiaim_set_real_offset = AntiAim.SetRealOffset, antiaim_set_fake_offset = AntiAim.SetFakeOffset, antiaim_set_lby_offset = AntiAim.SetLBYOffset, exploit_get_charge = Exploit.GetCharge, exploit_recharge = Exploit.Recharge, exploit_disable_recharge = Exploit.DisableRecharge, exploit_enable_recharge = Exploit.EnableRecharge, ragebot_get_target = Ragebot.GetTarget, ragebot_ignore_target = Ragebot.IgnoreTarget, ragebot_force_target = Ragebot.ForceTarget, ragebot_force_target_safety = Ragebot.ForceTargetSafety, ragebot_force_target_hitchance = Ragebot.ForceTargetHitchance, ragebot_force_target_minimum_damage = Ragebot.ForceTargetMinimumDamage, ragebot_force_hitbox_safety = Ragebot.ForceHitboxSafety, material_create = Material.Create, material_destroy = Material.Destroy, material_get = Material.Get, material_set_key_value = Material.SetKeyValue, material_refresh = Material.Refresh;
const math_pi = Math.PI, math_cos = Math.cos, math_round = Math.round, math_sin = Math.sin, math_sqrt = Math.sqrt;

var antatctica = 0;
var version = "live"
var build = "2.3.5"

//taked from cynosa
Cheat.GetFixedUsername = function() {
	var username = Cheat.GetUsername();
    return username.split('').map(function(char) {
        return char >= 'а' && char <= 'я' ? '?' : char;
    }).join('');
};

const keybinds_x = UI.AddSliderInt("keybinds_x", 0, Global.GetScreenSize()[0])
const keybinds_y = UI.AddSliderInt("keybinds_y", 0, Global.GetScreenSize()[1])

function in_bounds(vec, x, y, x2, y2)
{
   return (vec[0] > x) && (vec[1] > y) && (vec[0] < x2) && (vec[1] < y2)
}

 function xy()
 {
     UI.SetEnabled("Misc", "JAVASCRIPT", "Script items", "keybinds_x", false)
     UI.SetEnabled("Misc", "JAVASCRIPT", "Script items", "keybinds_y", false)
 }
 xy();

var Animation = {
    OutExpo: function(check, name, value, speed) {
        if (check) return name + (value - name) * Globals.Frametime() * speed
        else return name - (value + name) * Globals.Frametime() * speed / 2
    }
}

function math_random(min, max) {
	min = Math.ceil(min);
	max = Math.floor(max);
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function lerpframe(a, b, t) {
    var clock = Globals.Frametime() * 175 * t;
    a = lerp(a, b, clock);

	if (Math.abs(b - a) < .001) return b;

    return a;
};

var ctx = {
    name: "ANTARCTICA",
    available: false,
    local: 0,
    alive: true,
    screen_size: render_get_screen_size(),
    available: world_get_server_string().length > 0,
    on_create_move: function () {
        this.local = entity_get_local_player();
        this.alive = entity_is_alive(this.local);
    }
}

Render.Arc = function (x, y, radius, radius_inner, start_angle, end_angle, segments, color)
{
    segments = 360 / segments;

    for (var i = start_angle; i < start_angle + end_angle; i = i + segments)
    {

        var rad = i * Math.PI / 180;
        var rad2 = (i + segments) * Math.PI / 180;

        var rad_cos = Math.cos(rad);
        var rad_sin = Math.sin(rad);
        
        var rad2_cos = Math.cos(rad2);
        var rad2_sin = Math.sin(rad2);

        var x1_inner = x + rad_cos * radius_inner;
        var y1_inner = y + rad_sin * radius_inner;

        var x1_outer = x + rad_cos * radius;
        var y1_outer = y + rad_sin * radius;

        var x2_inner = x + rad2_cos * radius_inner;
        var y2_inner = y + rad2_sin * radius_inner;
        // какой ебанутый человек это создал 
        // ему наверное это приснилось и он просто наебашил 3 тонны математики с бодуна
        var x2_outer = x + rad2_cos * radius;
        var y2_outer = y + rad2_sin * radius;
        Render.Polygon( [
            [ x1_outer, y1_outer ],
            [ x2_outer, y2_outer ],
            [ x1_inner, y1_inner ] ],
            color
        );

        Render.Polygon( [
            [ x1_inner, y1_inner ],
            [ x2_outer, y2_outer ],
            [ x2_inner, y2_inner ] ],
            color
        );
    }
}

Render.FilledRectRounded = function(x, y, w, h, color, round_offset) {

  //БЕГИТЕ Я ЕБАНУТЫЙ
  
  var seg = 12
  var round = Math.min(round_offset, h / 2 )
  Render.FilledRect(x + round, y, w - round * 2, h, color)
  Render.FilledRect(x, y + round, round, h - round * 2, color)
  Render.FilledRect(x + w - round, y + round, round, h - round * 2, color)
  Render.Arc(x + round - 0.5, y + round - 0.5, round, 0, 180, 90, seg, color)
  Render.Arc(x + w - round - 0.5, y + round - 0.5, round, 0, 270, 90, seg, color)
  Render.Arc(x + round - 0.5, y + h - 0.5 - round, round, 0, 90, 90, seg, color)
  Render.Arc(x + w - round - 0.5, y + h - 0.5 - round, round, 0, 0, 90, seg, color)

}

Render.RectRounded = function(x, y, w, h, color, round_offset) {

  //БЕГИТЕ Я ЕБАНУТЫЙ
  
  var seg = 12
  var round = Math.min(round_offset, h / 2 )
  Render.Arc(x + round - 0.5, y + round - 0.5, round, round - 1, 180, 90, seg, color)
  Render.Arc(x + w - round - 0.5, y + round - 0.5, round, round - 1, 270, 90, seg, color)
  Render.Arc(x + round - 0.5, y + h - 0.5 - round, round, round - 1, 90, 90, seg, color)
  Render.Arc(x + w - round - 0.5, y + h - 0.5 - round, round, round - 1, 0, 90, seg, color)
  Render.FilledRect(x, y + round, 1, h - round * 2, color)
  Render.FilledRect(x + w, y + round, 1, h - round * 2, color)
  Render.FilledRect(x + round, y, w - round * 2, 1, color)
  Render.FilledRect(x + round, y + h, w - round * 2, 1, color)

}

Render.testv4otc = function(x, y, w, h, color, round_offset) {
  var seg = 12
  var round = Math.min(round_offset, h / 2 )
  Render.Arc(x + round - 0.5, y + round - 0.5, round, round - 1, 180, 90, seg, color)
  Render.Arc(x + w - round - 0.5, y + round - 0.5, round, round - 1, 270, 90, seg, color)
  Render.FilledRect(x + round, y, w - round * 2, 1, color)

}

Render.FadedCircle = function (rolayne, tashieka, kadynce, akendra) {
    var tyann = akendra[3] / kadynce;
    var tylan = 0;
    for (; tylan <= kadynce; tylan++) {
        render_filled_circle(rolayne, tashieka, tylan, [akendra[0], akendra[1], akendra[2], akendra[3] - tyann * tylan]);
    }
  };

Render.FadedRect = function (rolayne, tashieka, kadynce, kadynce, akendra) {
    var tyann = akendra[3] / kadynce;
    var tylan = 0;
    for (; tylan <= kadynce; tylan++) {
        Render.FilledRect(rolayne - tylan, tashieka, tylan, tylan, [akendra[0], akendra[1], akendra[2], akendra[3] - tyann * tylan]);
    }
};

var math_util = {
    lerp: function (start, end, time) {
        return start + (end - start) * time;
    }
}

var render_util = {
    string_shadow: function (x, y, align, text, color, font) {
        render_string_custom(x + 1, y + 1, align, text, [0, 0, 0, color[3] / 2], font);
        render_string_custom(x, y, align, text, color, font);
    },
    string_outline: function (x, y, align, text, color, font) {
        const outline = [0, 0, 0, color[3]];
        render_string_custom(x + 1, y + 0, align, text, outline, font);
        render_string_custom(x + 0, y + 1, align, text, outline, font);
        render_string_custom(x + 1, y + 1, align, text, outline, font);
        render_string_custom(x - 1, y + 1, align, text, outline, font);
        render_string_custom(x - 1, y - 0, align, text, outline, font);
        render_string_custom(x - 0, y - 1, align, text, outline, font);
        render_string_custom(x - 1, y - 1, align, text, outline, font);
        render_string_custom(x + 1, y - 1, align, text, outline, font);
        render_string_custom(x, y, align, text, color, font);
    },
    string_outlinewcolor: function (x, y, align, text, color, font) {
      const outline = [color[0], color[1], color[2], color[3]];
      render_string_custom(x + 1, y + 0, align, text, outline, font);
      render_string_custom(x + 0, y + 1, align, text, outline, font);
      render_string_custom(x + 1, y + 1, align, text, outline, font);
      render_string_custom(x - 1, y + 1, align, text, outline, font);
      render_string_custom(x - 1, y - 0, align, text, outline, font);
      render_string_custom(x - 0, y - 1, align, text, outline, font);
      render_string_custom(x - 1, y - 1, align, text, outline, font);
      render_string_custom(x + 1, y - 1, align, text, outline, font);
      render_string_custom(x, y, align, text, color, font);
  },
  string_outlisafecolor: function (x, y, align, text, color, font) {
    const outline = [color[0] / 2, color[1] / 2, color[2] / 2, color[3] / 2];
    render_string_custom(x + 1, y + 0, align, text, outline, font);
    render_string_custom(x + 0, y + 1, align, text, outline, font);
    render_string_custom(x + 1, y + 1, align, text, outline, font);
    render_string_custom(x - 1, y + 1, align, text, outline, font);
    render_string_custom(x - 1, y - 0, align, text, outline, font);
    render_string_custom(x - 0, y - 1, align, text, outline, font);
    render_string_custom(x - 1, y - 1, align, text, outline, font);
    render_string_custom(x + 1, y - 1, align, text, outline, font);
    render_string_custom(x, y, align, text, color, font);
},
    glow_rect: function(x, y, w, h, color, round_offset) {
        for (var i = 1; i < 10; i++) {
            FilledRectRounded(x - i, y - i, w + i * 2, h + i * 2, [color[0], color[1], color[2], color[3]], round_offset)
        }
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
        return UI.AddDropdown(name, elements)
    },

    MultiCombo: function(name, elements) {
        return UI.AddMultiDropdown(name, elements)
    },

    Text: function(name) {
        return UI.AddLabel(name)
    },

    Block: function(name) {
        return UI.AddSliderFloat(name, 0, 0)
    },

    TextBox: function(name) {
        return UI.AddTextbox(name)
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
    },

    DropdownValue: function(value, index) {
        var mask = 1 << index;
        return value & mask ? true : false;
    }
}

ui_add_label("              ");   
ui_add_label("> antarctica <");    
ui_add_label("<    live    >");   
ui_add_label("              "); 
ui_add_dropdown("tab", ["info", "rage", "anti hit", "visuals", "misc"]);

var menu_elements = ["infobar", "inds #1", "inds #2", "hotkeys", "watermark", "skeet inds", "manual on", "inverter on"]

menu.MultiCombo("visual tab", menu_elements)

var cfg = {
    rage: {

    },
    aa: {
        enabled: false,
        condition: 0,
        conditions: [
            "[g]",
            "[s]",
            "[c]",
            "[sw]",
            "[m]",
            "[a]",
            "[ac]"
        ],
        override: [true],
        yaw: [],
        yaw2: [],
        tar: [],
        inv: [],
        jitter: [],
        eba: [],
        pitch: []

    },
    visuals: {
        namever: false,
        aspect_ratio: false,
        aspect_ratio_value: 0,
        thirdperson: false,
        thirdperson_value: 0,
        inds: {
            inds: 0,
            accent: [0, 0, 0, 0],
            accent2: [0, 0, 0, 0]
        }
    },
    misc: {
        strafer: false,
        strafer_value: 0
    },
    init: function () {
    ui_add_slider_int("slow_x", 0, Render.GetScreenSize()[0]);
    ui_add_slider_int("slow_y", 0, Render.GetScreenSize()[1]);
    ui_set_enabled("slow_x", false);
    ui_set_enabled("slow_y", false);

    ui_add_label("user: " + Cheat.GetFixedUsername());
    ui_add_label("current version: " + build +  ", " + version + "");
    ui_add_label("dsc.gg/antarcticaviolet");   
    
    ui_add_dropdown("rage tab", ["none", "aimbot", "damage and hitchance"]);
    ui_add_hotkey("dormant aimbot");
    ui_add_checkbox("enable mindmg");
    ui_add_dropdown("weapon", ["pistols", "heavy", "scout", "awp", "auto", "general"]);   
    ui_add_label("-binds");  
    ui_add_hotkey("damage override")  
    ui_add_label("+damage");      
    ui_add_slider_int("general dmg", 0, 130);
    ui_add_slider_int("auto dmg", 0, 130);
    ui_add_slider_int("awp dmg", 0, 130);
    ui_add_slider_int("ssg08 dmg", 0, 130);
    ui_add_slider_int("revolver dmg", 0, 130);
    ui_add_slider_int("deagle dmg", 0, 130);
    ui_add_slider_int("pistol dmg", 0, 130);
    

        ui_add_checkbox("enabled");
        ui_add_dropdown("functions", ["conditions", "switch", "direction", "other", "sets"]);
        ui_add_dropdown("condition", ["global", "stand", "crouch", "slow walk", "move", "air", "air crouch"]);

        for (var i in this.aa.conditions) {
            const condition = this.aa.conditions[i];
            if (i > 0)
            ui_add_checkbox(condition + " override");
            ui_add_checkbox(condition + " target");
            ui_add_dropdown(condition + " pitch", ["off", "down", "emotion", "zero", "up", "fake up", "fake down"]);
            ui_add_slider_int(condition + " yaw left", -180, 180);
            ui_add_slider_int(condition + " yaw right", -180, 180);
            ui_add_slider_int(condition + " jitter", -180, 180);
            ui_add_checkbox(condition + " desync");
            ui_add_checkbox(condition + " desync switch");
            ui_add_slider_int(condition + " time desync switch", 1, 60);
        }
        //ui_add_checkbox("desync switch");
        ui_add_dropdown("manual dir", ["off", "northon style", "default"]);
        ui_add_dropdown("manual target", ["off", "enabled"]);
        ui_add_hotkey("manual left");
        ui_add_hotkey("manual right");
        ui_add_dropdown("manuals", ["zero", "left", "right"]);
        ui_add_hotkey("freestand key");
        ui_add_checkbox("custom jitter");
        ui_add_checkbox("jitter break");
        ui_add_checkbox("desync break");
        ui_add_checkbox("pitch switch");
        ui_add_checkbox("fakelag switch");
        ui_add_hotkey("legit aa key");
        ui_add_dropdown("legit type", ["no target", "target"]);
        ui_add_checkbox("pitch on land");

        ui_add_multi_dropdown("indicators", ["center", "infobar"]);
        ui_add_checkbox("desync line")
        ui_add_checkbox("watermark")
        ui_add_checkbox("meta center")
        ui_add_dropdown("glow style", ["off" , "full / 2" , "full"]);
        ui_add_checkbox("inverter inds on")
        ui_add_dropdown("inverter style", ["static", "to delta"]);
        ui_add_dropdown("inverter inds", ["0", "1"]);
        ui_add_checkbox("manual inds on")
        ui_add_dropdown("manual style", ["static", "to delta"]);
        ui_add_dropdown("manual inds", ["0", "1"]);
        ui_add_color_picker("accent color");
        ui_add_color_picker("background color");
        ui_add_checkbox("viewmodel in scope")
        ui_add_checkbox("skeet indicators")
        ui_add_checkbox( "keybinds" );
        ui_add_checkbox( "hit/miss ratio" );
        ui_add_checkbox( "reset on round start" );

        ui_add_checkbox("aspect ratio");
        ui_add_slider_float("aspect ratio ", 0, 2);
        ui_add_checkbox("thirdperson");
        ui_add_slider_int("thirdperson ", 0, 300);

        ui_add_checkbox("better strafer");
        ui_add_slider_int("better strafer ", 0, 100);
        ui_add_checkbox("clantag");
        ui_add_hotkey("ping spike")
        ui_add_checkbox("load preset");

        ui_set_value("Misc", "PERFORMANCE & INFORMATION", "Information", "Restrictions", 0);
    },
    update: function () {
        this.aa.enabled = ui_get_value("Script items", "enabled");
        this.aa.condition = ui_get_value("Script items", "condition");

        for (var i in this.aa.conditions) {
            const condition = this.aa.conditions[i];
            if (i > 0)
            this.aa.override[i] = ui_get_value("Script items", "Script items", condition + " override");
            this.aa.tar[i] = ui_get_value("Script items", "Script items", condition + " target");
            this.aa.pitch[i] = ui_get_value("Script items", "Script items", condition + " pitch");
            this.aa.yaw[i] = ui_get_value("Script items", "Script items", condition + " yaw left");
            this.aa.yaw2[i] = ui_get_value("Script items", "Script items", condition + " yaw right");
            this.aa.jitter[i] = ui_get_value("Script items", "Script items", condition + " jitter");
            this.aa.eba[i] = ui_get_value("Script items", "Script items", condition + " desync");
            this.aa.inv[i] = ui_get_value("Script items", "Script items", condition + " desync switch");
        }

        if (this.aa.jitter)
        ui_set_value("Anti-Aim", "Jitter offset", 0);

        this.visuals.aspect_ratio = ui_get_value("Script items", "aspect ratio");
        this.visuals.namever = ui_get_value("Script items", "name version");
        this.visuals.aspect_ratio_value = ui_get_value("Script items", "aspect ratio ");
        this.visuals.thirdperson = ui_get_value("Script items", "thirdperson");
        this.visuals.thirdperson_value = ui_get_value("Script items", "thirdperson ");

        this.misc.strafer = ui_get_value("Script items", "better strafer");
        this.misc.strafer_value = ui_get_value("Script items", "better strafer ");

        if (this.visuals.thirdperson)
            ui_set_value("Visual", "WORLD", "View", "Thirdperson", this.visuals.thirdperson_value);

        convar_set_float("r_aspectratio", this.visuals.aspect_ratio ? math_round(this.visuals.aspect_ratio_value * 100) / 100 : 0);

        if (this.misc.strafer)
            ui_set_value("Misc", "GENERAL", "Movement", "Turn speed", this.misc.strafer_value * 10); 

        if (!ui_is_menu_open())
            return;

        const tab = ui_get_value("Script items", "tab");
        const fun = ui_get_value("Script items", "functions");
        //rage
        ui_set_enabled("user: " + Cheat.GetFixedUsername(), tab == 0);
        ui_set_enabled("dsc.gg/antarcticaviolet", tab == 0);
        ui_set_enabled("current version: " + build +  ", " + version + "", tab == 0);

        const isVisible = ui_get_value("Script items", "enable mindmg");
        const isVisible2 = ui_get_value("Script items", "fast recharge");
        const tabw = ui_get_value("Script items", "weapon");
        const tabr = ui_get_value("Script items", "rage tab");
        ui_set_enabled("Script Items", "dormant aimbot", tabr == 1 && tab == 1);
        ui_set_enabled("Script Items", "enable mindmg", tab == 1 && tabr == 2 );
        ui_set_enabled("Script Items", "damage override", tab == 1 && tabr == 2 && isVisible);
        ui_set_enabled("Script Items", "deagle dmg", tabw == 1 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "revolver dmg", tabw == 1 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "ssg08 dmg", tabw == 2 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "awp dmg", tabw == 3 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "pistol dmg", tabw == 0 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "general dmg", tabw == 5 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "auto dmg", tabw == 4 && tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "weapon", tabr == 2 && tab == 1);
        ui_set_enabled("Script Items", "+damage", tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "-binds", tabr == 2 && tab == 1 && isVisible);
        ui_set_enabled("Script Items", "rage tab", tab == 1);

        //anti hit
        ui_set_enabled("Script items", "enabled", tab == 2);
        ui_set_enabled("Script items", "condition", tab == 2 && fun == 0 && this.aa.enabled);
        ui_set_enabled("Script items", "functions", tab == 2 && this.aa.enabled);

        for (var i in this.aa.conditions) {
            const condition = this.aa.conditions[i];
            if (i > 0)
            ui_set_enabled("Script items", condition + " override", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i);
            ui_set_enabled("Script items", condition + " target", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " pitch", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " yaw left", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " yaw right", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " jitter", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " desync", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            //if (i > 1)
            ui_set_enabled("Script items", condition + " desync switch", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
            ui_set_enabled("Script items", condition + " time desync switch", tab == 2 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
        }
        //ui_set_enabled("Script items","desync switch", tab == 2  && fun == 1 && this.aa.enabled);
        const vis = ui_get_value("Script items", "manual dir") > 0;

        ui_set_enabled("Script items", "pitch switch", tab == 2 && fun == 1 && this.aa.enabled);
        ui_set_enabled("Script items", "fakelag switch", tab == 2 && fun == 1 && this.aa.enabled);
        ui_set_enabled("Script items", "pitch on land", tab == 2 && fun == 1 && this.aa.enabled);
        ui_set_enabled("Script items", "[g] desync switch", tab == 99 && fun == 0 && this.aa.enabled && this.aa.condition == i && this.aa.override[i]);
        ui_set_enabled("Script items", "freestand key", tab == 2 && fun == 2 && this.aa.enabled);
        ui_set_enabled("Script items", "manual dir", tab == 2 && fun == 2 && this.aa.enabled);
        ui_set_enabled("Script items", "manual target", tab == 2 && fun == 2 && this.aa.enabled);
        ui_set_enabled("Script items", "manual left", tab == 2 && fun == 2 && vis && this.aa.enabled);
        ui_set_enabled("Script items", "manuals", tab == 44444 && fun == 44444444);
        ui_set_enabled("Script items", "custom jitter", tab == 2 && fun == 3 && this.aa.enabled);
        ui_set_enabled("Script items", "jitter break", tab == 2 && fun == 3 && this.aa.enabled);
        ui_set_enabled("Script items", "desync break", tab == 2 && fun == 3 && this.aa.enabled);
        ui_set_enabled("Script items", "manual right", tab == 2 && fun == 2 && vis && this.aa.enabled);
        ui_set_enabled("Script items", "legit aa key", tab == 2 && fun == 1 && this.aa.enabled);
        ui_set_enabled("Script items", "legit type", tab == 2 && fun == 1 && this.aa.enabled);
        ui_set_enabled("Script items", "load preset", tab == 2 && fun == 4 && this.aa.enabled);
        //visuals
        const visiblility = ui_get_value("Script items", "hit/miss ratio");
        const visiblility2 = ui_get_value("Script items", "indicators");
        const vise = menu.DropdownValue(menu.GetValue("visual tab"), 6);
        const vis3 = menu.DropdownValue(menu.GetValue("visual tab"), 7);
        const vis4 = menu.DropdownValue(menu.GetValue("visual tab"), 3) || menu.DropdownValue(menu.GetValue("visual tab"), 4);
        ui_set_enabled("Script items", "indicators", tab == 99);
        ui_set_enabled("Script items", "visual tab", tab == 3);
        ui_set_enabled("Script items", "watermark", tab == 99);
        ui_set_enabled("Script items", "slowed down", tab == 3);
        ui_set_enabled("Script items", "desync line", tab == 9 && visiblility2);
        ui_set_enabled("Script items", "accent color", tab == 3);
        ui_set_enabled("Script items", "background color", tab == 9);
        ui_set_enabled("Script items", "skeet indicators", tab == 99);
        ui_set_enabled("Script items", "inverter inds", tab == 3 && vis3);
        ui_set_enabled("Script items", "inverter inds on", tab == 99);
        ui_set_enabled("Script items", "manual inds", tab == 3 && vise);
        ui_set_enabled("Script items", "meta center", tab == 99);    
        ui_set_enabled("Script items", "manual style", tab == 3 && vise);
        ui_set_enabled("Script items", "glow style", tab == 3 && vis4);
        ui_set_enabled("Script items", "inverter style", tab == 3 && vis3);
        ui_set_enabled("Script items", "manual inds on", tab == 99);
        ui_set_enabled("Script items", "viewmodel in scope", tab == 3);
        ui_set_enabled("Script items", "keybinds", tab == 9);
        ui_set_enabled("Script items", "hit/miss ratio", tab == 9);
        ui_set_enabled("Script items", "reset on round start", tab == 9 && visiblility);
        ui_set_enabled("Script items", "aspect ratio", tab == 3);
        ui_set_enabled("Script items", "aspect ratio ", tab == 3 && this.visuals.aspect_ratio);
        ui_set_enabled("Script items", "thirdperson", tab == 3);
        ui_set_enabled("Script items", "thirdperson ", tab == 3 && this.visuals.thirdperson);
        //misc
        ui_set_enabled("Script items", "clantag", tab == 4);
        ui_set_enabled("Script items", "better strafer", tab == 4);
        ui_set_enabled("Script items", "better strafer ", tab == 4 && this.misc.strafer);
        ui_set_enabled("Script items", "ping spike", tab == 4);

        this.visuals.inds.inds = ui_get_value("Script items", "indicators");
        this.visuals.inds.accent = ui_get_color("Script items", "accent color");
        this.visuals.inds.accent2 = ui_get_color("Script items", "background color");
    }
}

var aa = {
    ground_ticks: 0,
    cond: [],
    on_create_move: function () {
        if (!ctx.alive)
            return;

        if (!cfg.aa.enabled) {
            antiaim_set_override(0);

            return;
        }

        var condition = 1;
        const velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]");
        const flags = entity_get_prop(ctx.local, "DT_BasePlayer", "m_fFlags");
        if (flags & (1 << 0)){
            this.ground_ticks++;
            cond = "4";          
        }
        else{
            this.ground_ticks = 0;   
            cond = "5";     
        }
        if (this.ground_ticks > 1) {
            if (flags & (1 << 1)){
                condition = 2;
                cond = "3";             
            }
            else if (ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk")){
              condition = 3;
              cond = "1";
            }     
            else if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 1.1){
               condition = 4;
               cond = "2";
            }        
        }
        else{
            condition = flags & (1 << 1) ? 6 : 5;
            cond = "0";     
        }


        condition = cfg.aa.override[condition] ? condition : 0;

        ui_set_value("Anti-Aim", "Extra", "Pitch", cfg.aa.pitch[condition]);
        ui_set_value("Anti-Aim", "Yaw offset", cfg.aa.yaw[condition]);
        if (ui_is_hotkey_active("Anti-Aim", "Fake angles", "Inverter"))
        ui_set_value("Anti-Aim", "Yaw offset", cfg.aa.yaw2[condition]);
        ui_set_value("Anti-Aim", "Jitter offset", cfg.aa.jitter[condition]);
        ui_set_value("Anti-Aim", "At targets", cfg.aa.tar[condition]);
        ui_set_value("Fake angles", "Inverter", cfg.aa.inv[condition]);
        ui_set_value("Anti-aim", "Fake angles", "Enabled", cfg.aa.eba[condition]);
    }
}



var visuals = {
    font: 0,
    small_font: 0,
    wehr_font: 0,
    align_anim: 0,
    test: 0,
    arrows: 0,
    indicators: function () {

      var localPlayer = Entity.GetLocalPlayer();
      var localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");
      var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")
      var me = Entity.GetLocalPlayer();
      var modifier = Entity.GetProp(me, "CCSPlayer", "m_flVelocityModifier")

        var local_player = entity_get_local_player()
        if (!entity_is_alive(local_player))
            return
            
        in_scope_animation = lerp(in_scope_animation, entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? 1 : 0, globals_frametime() * 3)
        test = lerp(test, UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter") ? 1 : 0.5, globals_frametime() * 3)
        test2 = lerp(test2, UI.IsHotkeyActive("Script items", "manual left") ? 255 : 0, globals_frametime() * 3)
        test3 = lerp(test3, UI.IsHotkeyActive("Script items", "manual right") ? 255 : 0, globals_frametime() * 3)

        local = Entity.GetLocalPlayer();
        real_yaw = Local.GetRealYaw();
        fake_yaw = Local.GetFakeYaw();
        delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);
        cf = lerp(cf, delta, globals_frametime() * 2)
        
        var screen_size = render_get_screen_size()
        var center_screen = [screen_size[0] / 2, screen_size[1] / 2]
    

        if (ui_get_value("Script items", "inverter style") == 1) {
            if (menu.DropdownValue(menu.GetValue("visual tab"), 7)) {
          if (ui_get_value("Script items", "inverter inds") == 0) {
          if(ui_get_value("Script items", "[s] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 5) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) || ui_get_value("Script items", "[sw] desync switch") && ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") || ui_get_value("Script items", "[m] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20 && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 263) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk"))  || ui_get_value("Script items", "[a] desync switch") && (InAir()) && (localPlayerFlags == 256) || ui_get_value("Script items", "[ac] desync switch") && (InAir()) && (localPlayerFlags == 262) || ui_get_value("Script items", "[c] desync switch") && (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262)){
                render_util.string_outline(center_screen[0] + 27 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
                render_util.string_outline(center_screen[0] - 27 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
          }
          else {
          if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter"))
          render_util.string_outline(center_screen[0] + 27 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
          else 
          render_util.string_outline(center_screen[0] - 27 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)            
          }            
          } else {
            if(ui_get_value("Script items", "[s] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 5) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) || ui_get_value("Script items", "[sw] desync switch") && ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") || ui_get_value("Script items", "[m] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20 && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 263) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk"))  || ui_get_value("Script items", "[a] desync switch") && (InAir()) && (localPlayerFlags == 256) || ui_get_value("Script items", "[ac] desync switch") && (InAir()) && (localPlayerFlags == 262) || ui_get_value("Script items", "[c] desync switch") && (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262)){
              render_util.string_outline(center_screen[0] + 27 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
              render_util.string_outline(center_screen[0] - 27 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
        }
        else {
        if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter"))
        render_util.string_outline(center_screen[0] + 27 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
        else 
        render_util.string_outline(center_screen[0] - 27 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)            
        }  
          }
        }
    } else {
        if (menu.DropdownValue(menu.GetValue("visual tab"), 7)) {
            if (ui_get_value("Script items", "inverter inds") == 0) {
            if(ui_get_value("Script items", "[s] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 5) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) || ui_get_value("Script items", "[sw] desync switch") && ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") || ui_get_value("Script items", "[m] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20 && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 263) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk"))  || ui_get_value("Script items", "[a] desync switch") && (InAir()) && (localPlayerFlags == 256) || ui_get_value("Script items", "[ac] desync switch") && (InAir()) && (localPlayerFlags == 262) || ui_get_value("Script items", "[c] desync switch") && (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262)){
                  render_util.string_outline(center_screen[0] + 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
                  render_util.string_outline(center_screen[0] - 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
            }
            else {
            if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter"))
            render_util.string_outline(center_screen[0] + 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
            else 
            render_util.string_outline(center_screen[0] - 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)            
            }            
            } else {
              if(ui_get_value("Script items", "[s] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 5) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) || ui_get_value("Script items", "[sw] desync switch") && ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") || ui_get_value("Script items", "[m] desync switch") && (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20 && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 263) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk"))  || ui_get_value("Script items", "[a] desync switch") && (InAir()) && (localPlayerFlags == 256) || ui_get_value("Script items", "[ac] desync switch") && (InAir()) && (localPlayerFlags == 262) || ui_get_value("Script items", "[c] desync switch") && (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) && !(InAir()) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262)){
                render_util.string_outline(center_screen[0] + 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
                render_util.string_outline(center_screen[0] - 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
          }
          else {
          if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter"))
          render_util.string_outline(center_screen[0] + 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
          else 
          render_util.string_outline(center_screen[0] - 27 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)            
          }  
            }
          }  
    }
    if (ui_get_value("Script items", "manual style") == 1) {
        if (menu.DropdownValue(menu.GetValue("visual tab"), 6)) {
          if (ui_get_value("Script items", "manual inds") == 0) {
          render_util.string_outline(center_screen[0] - 47 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)

          render_util.string_outline(center_screen[0] + 47 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)

          if (UI.IsHotkeyActive("Script items", "manual left"))
              render_util.string_outlisafecolor(center_screen[0] - 47 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [200, 200, 200, test2], this.arrows)
          else if (UI.IsHotkeyActive("Script items", "manual right"))
              render_util.string_outlisafecolor(center_screen[0] + 47 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [200, 200, 200,  test3 ], this.arrows)
          }
          else {
            render_util.string_outline(center_screen[0] - 47 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)

            render_util.string_outline(center_screen[0] + 47 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
  
            if (UI.IsHotkeyActive("Script items", "manual left"))
                render_util.string_outlisafecolor(center_screen[0] - 47 - cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [200, 200, 200, test2], this.arrows)
            else if (UI.IsHotkeyActive("Script items", "manual right"))
                render_util.string_outlisafecolor(center_screen[0] + 47 + cf, center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [200, 200, 200,  test3 ], this.arrows)
          }
        }
    } else {
        if (menu.DropdownValue(menu.GetValue("visual tab"), 6)) {
            if (ui_get_value("Script items", "manual inds") == 0) {
            render_util.string_outline(center_screen[0] - 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
  
            render_util.string_outline(center_screen[0] + 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
  
            if (UI.IsHotkeyActive("Script items", "manual left"))
                render_util.string_outlisafecolor(center_screen[0] - 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [200, 200, 200, test2], this.arrows)
            else if (UI.IsHotkeyActive("Script items", "manual right"))
                render_util.string_outlisafecolor(center_screen[0] + 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [200, 200, 200,  test3 ], this.arrows)
            }
            else {
              render_util.string_outline(center_screen[0] - 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [22, 22, 22, 22], this.arrows)
  
              render_util.string_outline(center_screen[0] + 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [22, 22, 22, 22], this.arrows)
    
              if (UI.IsHotkeyActive("Script items", "manual left"))
                  render_util.string_outlisafecolor(center_screen[0] - 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "X", [200, 200, 200, test2], this.arrows)
              else if (UI.IsHotkeyActive("Script items", "manual right"))
                  render_util.string_outlisafecolor(center_screen[0] + 47 , center_screen[1] - 7 - 10 * in_scope_animation, 1, "Z", [200, 200, 200,  test3 ], this.arrows)
            }
          }   
    }

        //if (UI.IsHotkeyActive("Script items", "manual left"))
        //    render_util.string_outline(text_position[0] - 5, text_position[1] + 19, 0, "<", [255, 255, 255, 255], font)
        //else if (UI.IsHotkeyActive("Script items", "manual right"))
        //    render_util.string_outline(text_position[0] + 47, text_position[1] + 19, 0, ">", [255, 255, 255, 255], font)

        if (!menu.DropdownValue(menu.GetValue("visual tab"), 0)) 
        return

        this.align_anim = math_util.lerp(this.align_anim, entity_get_prop(ctx.local, "DT_CSPlayer", "m_bIsScoped") ? 1 : 0, 0.1);

        var offset_v = 10;
        const upper = ctx.name.toUpperCase();
        const width = render_text_size_custom(upper, this.small_font)[0];
        const center = [ctx.screen_size[0] / 2, ctx.screen_size[1] / 2];
        const pos = [center[0] - width / 2, center[1] + offset_v];
        var username = Cheat.GetUsername();

        render_gradient_rect(0, pos[1] - 9, 160, 35, 2, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255], [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 0]);
        render_filled_rect(5, pos[1], 30, 6, [255, 255, 255, 255]);
        render_filled_rect(5, pos[1] + 6, 30, 6, [0, 0, 255, 255]);
        render_filled_rect(5, pos[1] + 12, 30, 6, [255, 0, 0, 255]);
        render_util.string_outline(40, pos[1], 0, "ANTARCTICA  VIOLET[LIVE]", [255, 255, 255, 255], this.small_font);
        render_util.string_outline(40, pos[1] + 10, 0, "USER:  " + Cheat.GetFixedUsername().toUpperCase(), [255, 255, 255, 255], this.small_font);
        
    },
    indicators2: function () {
        if (!menu.DropdownValue(menu.GetValue("visual tab"), 2)) 
        return

            this.align_anim = math_util.lerp(this.align_anim, entity_get_prop(ctx.local, "DT_CSPlayer", "m_bIsScoped") ? 1 : 0, globals_frametime() * 3); 
            test4 = lerp(test4, ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck") ? 255 : 1 , globals_frametime() * 4)
            b = lerp(b, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force body aim") ? 255 : 1 , globals_frametime() * 4)
            d = lerp(d, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force safe point") ? 255 : 1 , globals_frametime() * 4)
            c = lerp(c, ui_get_value("Miscellaneous", "Extended backtracking") ? 255 : 1 , globals_frametime() * 2)
            m = lerp(m, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Hide shots") ? 255 : 1 , globals_frametime() * 4)
            k = lerp(k, ui_is_hotkey_active("Script items", "damage override") ? 255 : 1 , globals_frametime() * 4)
            a = lerp(a, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap") ? 255 : 1 , globals_frametime() * 4)
            g = lerp(g, ui_is_hotkey_active("Script items", "dormant aimbot") ? 255 : 1 , globals_frametime() * 4)
            f = lerp(f, ui_get_value("Anti-Aim", "Rage Anti-Aim", "Auto direction") ? 255 : 1 , globals_frametime() * 4)  
            expc = lerp(expc, Exploit.GetCharge() == 1 ? 55 : 255 , globals_frametime() * 2)  
            exp = lerp(exp, Exploit.GetCharge() == 1 ? 255 : 0 , globals_frametime() * 2)  

            
            local = Entity.GetLocalPlayer();
            real_yaw = Local.GetRealYaw();
            fake_yaw = Local.GetFakeYaw();
            var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")
            if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 1.1 && ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap"))
            {
            delta = Math.min(Math.abs(80 - 30) , 80).toFixed(0);   
            }
            else
            {
            delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);            
            }
            cf = lerp(cf, delta, globals_frametime() * 3)
             var offset_v = 10;
             const upper = ctx.name.toUpperCase();
             const width = render_text_size_custom(upper, this.small_font)[0];
             const center = [ctx.screen_size[0] / 2, ctx.screen_size[1] / 2];
             const pos = [center[0] - width / 2, center[1] + offset_v];
             //Render.FadedCircle(pos[0] + 22 + this.align_anim * 33, pos[1] + 23, 30, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 25]);
             render_util.string_outline(pos[0] + this.align_anim * 33, pos[1] + 10, 0, upper, [255, 255, 255, 111], this.small_font);

             render_filled_rect(pos[0] + this.align_anim * 33, pos[1] + 20, 45, 4.9, [22, 22, 22, 200]);
             render_filled_rect(pos[0] + this.align_anim * 33, pos[1] + 21, 0.76 * cf, 2.9, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255]);
             render_rect(pos[0] + this.align_anim * 33, pos[1] + 20, 45, 4.9, [22, 22, 22, 255]);

             if (ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap")){
                var text = "DT";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [expc, 255, expc, a], this.small_font);  
                offset_v += 10
             }

             if (ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Hide shots")){
                var text = "HS";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, exp, exp, m], this.small_font);  
                offset_v += 10
             }

             if (ui_is_hotkey_active("Rage", "GENERAL", "General", "Force safe point")){
                var text = "SF";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, d], this.small_font);  
                offset_v += 10
             }

             if (ui_is_hotkey_active("Rage", "GENERAL", "General", "Force body aim")){
                var text = "BA";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, b], this.small_font);  
                offset_v += 10
             }

             if (ui_is_hotkey_active("Script items", "dormant aimbot")){
                var text = "DA";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, g], this.small_font);  
                offset_v += 10
             }

             if (ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck") ){
                var text = "FD";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, test4], this.small_font);  
                offset_v += 10
             }
         
             if (ui_get_value("Anti-Aim", "Rage Anti-Aim", "Auto direction")){
                var text = "FS";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 17 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, f], this.small_font);  
                offset_v += 10
             }
             
             if (ui_get_value("Miscellaneous", "Extended backtracking")){
                var text = "PING";
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 14 + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [ping_spike.color[0], ping_spike.color[1], ping_spike.color[2], c], this.small_font);  
                ping_spike.color = lerp_color(ping_spike.color, ping_spike.get_color(), Globals.Frametime() * 175 * .095);
                offset_v += 10
             }

             if (ui_is_hotkey_active("Script items", "damage override")){
                const dmg = UI.GetValue("Script items", get_weaponname() + ' dmg')
                var text = "DMG: " + dmg;
                var text_sz = Render.TextSizeCustom(text, this.small_font);
                render_util.string_outline(pos[0] + 13.5  + this.align_anim * 33, pos[1] + offset_v + 15, 0, text, [255, 255, 255, k], this.small_font);  
                offset_v += 10
             }


   
             var offset_h = 0;
             const mul = 510 / upper.length;
            for (var i in upper) {
                const ch = upper[i];
                 const anim = (globals_tickcount() * 3 - i * mul) % 510;
                 render_string_custom(pos[0] + offset_h + this.align_anim * 33, pos[1] + 10, 0, ch, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], anim > 255 ? 510 - anim : anim], this.small_font);
   
                 offset_h += render_text_size_custom(ch, this.small_font)[0];
             }
   
    },
    on_draw: function () {
        if (!this.font)
            this.font = render_add_font("Verdana", 13, 100);

        if (!this.small_font)
            this.small_font = render_add_font("Small Fonts", 5, 400);

        if (!this.wehr_font)
            this.wehr_font = render_add_font('Verdana', 7, 900);

        if (!this.arrows)
            this.arrows = render_add_font("Acta Symbols W95 Arrows", 15, 900);

        if (ctx.alive){
            this.indicators();
            this.indicators2();
        }
            
    }
}

var callbacks = {
    init: function () {
        cheat_register_callback("CreateMove", "callbacks.on_create_move");
        cheat_register_callback("Draw", "callbacks.on_draw");
    },
    on_create_move: function () {
        ctx.on_create_move();
        aa.on_create_move();
    },
    on_draw: function () {
        cfg.update();

        if (ctx.available)
            visuals.on_draw();
    }
}

cfg.init();
callbacks.init();

function CHE()
{
  const localPlayer = Entity.GetLocalPlayer();
  const localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");

if (ui_get_value("Script items", "Script items", "desync break")) {  
  switch (Globals.Tickcount() % 6) {
      case 0:
        UI.SetValue("Script items", "[s] desync", true);
        UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 2); 
          break;
      case 1:
        UI.SetValue("Script items", "[s] desync", false);
        UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 14); 
          break;
      case 2:
            UI.SetValue("Script items", "[s] desync", false);
            UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 16); 
            break;
  }
  switch (Globals.Tickcount() % 6) {
    case 0:
      UI.SetValue("Script items", "[sw] desync", true);
      UI.SetValue("Script items", "[sw] pitch", 1);
      UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 2); 
        break;
    case 1:
      UI.SetValue("Script items", "[sw] desync", false);
      UI.SetValue("Script items", "[sw] pitch", 0);
      UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 14); 
        break;
    case 2:
          UI.SetValue("Script items", "[sw] desync", false);
          UI.SetValue("Script items", "[sw] pitch", 3);
          UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", 16); 
          break;

}
switch (Globals.Tickcount() % 5) {
  case 0:
    UI.SetValue("Script items", "[m] desync", true);
      break;
  case 1:
    UI.SetValue("Script items", "[m] desync", false);
      break;
}
switch (Globals.Tickcount() % 2) {
  case 0:
    UI.SetValue("Script items", "[a] desync", true);
      break;
  case 1:
    UI.SetValue("Script items", "[a] desync", false);
      break;
}
}


set = require("set.cfg");

var move = set.move;
var stand = set.stand;
var crouch = set.crouch;
var slowwalk = set.walk;
var air = set.air;
var airc = set.airc;
var minusmove = set.minusmove;
var minusstand = set.minusstand;
var minuscrouch = set.minuscrouch;
var minusslowwalk = set.minuswalk;
var minusair = set.minusair;
var minusairc = set.minusairc;

if(!UI.GetValue("load preset")) return;
UI.SetValue("enabled", true);
UI.SetValue("[m] override", true);
UI.SetValue("[m] desync", true);
UI.SetValue("[m] yaw left", move);
UI.SetValue("[m] yaw right", minusmove);
UI.SetValue("[m] desync switch", true);
UI.SetValue("[m] pitch", 1);
UI.SetValue("[c] override", true);
UI.SetValue("[c] desync", true);
UI.SetValue("[c] yaw left", crouch);
UI.SetValue("[c] yaw right", minuscrouch);
UI.SetValue("[c] desync switch", true);
UI.SetValue("[c] pitch", 1);
UI.SetValue("[sw] override", true);
UI.SetValue("[sw] desync", true);
UI.SetValue("[sw] yaw left", slowwalk);
UI.SetValue("[sw] yaw right", minusslowwalk);
UI.SetValue("[sw] desync switch", true);
UI.SetValue("[sw] pitch", 1);
UI.SetValue("[a] override", true);
UI.SetValue("[a] desync", true);
UI.SetValue("[a] yaw left", air);
UI.SetValue("[a] yaw right", minusair);
UI.SetValue("[a] desync switch", true);
UI.SetValue("[a] pitch", 1);
UI.SetValue("[ac] override", true);
UI.SetValue("[ac] desync", true);
UI.SetValue("[ac] yaw left", airc);
UI.SetValue("[ac] yaw right", minusairc);
UI.SetValue("[ac] desync switch", true);
UI.SetValue("[ac] pitch", 1);
UI.SetValue("[s] override", true);
UI.SetValue("[s] desync", true);
UI.SetValue("[s] yaw left", stand);
UI.SetValue("[s] yaw right", minusstand);
UI.SetValue("[s] pitch", 1);
UI.SetValue("load preset", false);
}
var groundCounter = 0;

function getVelocity(index) {
	var localPlayer = Entity.GetLocalPlayer();
		var velocity = Entity.GetProp(localPlayer, "DT_BasePlayer", "m_vecVelocity[0]");
		var speed = Math.sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]);
	return speed;
}
//CYNOSA
var tickcount = Globals.Tickcount();
function InAir() {
    if (!Entity.GetProp(Entity.GetLocalPlayer(), "CBasePlayer", "m_hGroundEntity") && tickcount + 1 < Globals.Tickcount()) { 
		return false; 
	}

    if (Entity.GetProp(Entity.GetLocalPlayer(), "CBasePlayer", "m_hGroundEntity")) {
        tickcount = Globals.Tickcount();
        return true;
    } else { 
		return true;
	}
}

function sstate() {
  var localPlayer = Entity.GetLocalPlayer();
  var localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");
  var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")

 if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20) {
  sstate = "MOVING"
} if (InAir()) {
  sstate = "AIR"
} else if (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) {
  sstate = "DUCK"
} else if (ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk")) {
  sstate = "WALKING"
} else if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 1.1) {
 sstate = "STANDING"
}

}
Cheat.RegisterCallback("Draw", "sstate");

function state() {
  var localPlayer = Entity.GetLocalPlayer();
  var localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");
  var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")
  var me = Entity.GetLocalPlayer();
  var modifier = Entity.GetProp(me, "CCSPlayer", "m_flVelocityModifier")

  if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 20 && !InAir() && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount') && !ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck")) {
  state = "-MOVING-"
} else if (InAir()) {
  state = "-AIR-"
} else if (Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount')) {
  state = "-CROUCH-"
} else if (ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk")) {
  state = "-WALKING-"
} else if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 1.1 && !Entity.GetProp(Entity.GetLocalPlayer(), 'DT_BasePlayer', 'm_flDuckAmount') && !(ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck"))) {
 state = "-STANDING-"
}



}
Cheat.RegisterCallback("Draw", "state");

function fswitch() {
  var delaym = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[m] time desync switch")
  var delaya = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[a] time desync switch")
  var delayac = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[ac] time desync switch")
  var delaysw = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[sw] time desync switch")
  var delays = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[s] time desync switch")
  var delayc = (Globals.Curtime() * 700000).toFixed(1) % ui_get_value("Script items", "[c] time desync switch")
  var localPlayer = Entity.GetLocalPlayer();
  
  var localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");
  var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")
if (ui_get_value("Script items", "Script items", "[ac] desync switch") && InAir() && (localPlayerFlags == 262) && !(localPlayerFlags == 256) && !(localPlayerFlags == 263) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items", "legit aa key")) {  
    switch (delayac) {
        case 0:
            UI.ToggleHotkey("Fake angles", "Inverter");
            break;
        case 1:
            UI.ToggleHotkey("Fake angles", "Inverter");
            break;
    }
}
if (ui_get_value("Script items", "Script items", "[a] desync switch") && InAir() && (localPlayerFlags == 256) && !(localPlayerFlags == 263) && !(localPlayerFlags == 262) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right")&& !ui_is_hotkey_active("Script items", "legit aa key")) {  
  switch (delaya) {
      case 0:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
      case 1:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
  }
}
if (ui_get_value("Script items", "Script items", "[c] desync switch") && (localPlayerFlags == 263) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right")&& !ui_is_hotkey_active("Script items", "legit aa key")) {  
  switch (delayc) {
      case 0:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
      case 1:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
  }
}


if (ui_get_value("Script items", "Script items", "[sw] desync switch") && ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !(localPlayerFlags == 263) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right")&& !ui_is_hotkey_active("Script items", "legit aa key")) {  
  switch (delaysw) {
      case 0:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
      case 1:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
  }
}

if (ui_get_value("Script items", "Script items", "[m] desync switch") && math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 2.9 && !(localPlayerFlags == 263) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items", "legit aa key")) {  
  switch (delaym) {
      case 0:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
      case 1:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
  }
}

if (ui_get_value("Script items", "Script items", "[s] desync switch") && math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 1.1 && !(localPlayerFlags == 263) && !(localPlayerFlags == 256) && !(localPlayerFlags == 262) && !ui_is_hotkey_active("Anti-Aim", "Extra", "Slow walk") && !ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items", "legit aa key")) {  
  switch (delays) {
      case 0:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
      case 1:
          UI.ToggleHotkey("Fake angles", "Inverter");
          break;
  }
}
}

Cheat.RegisterCallback("Draw", "fswitch");


function fast_switch() {
if (ui_get_value("Script items", "Script items", "pitch switch")) {
    switch ((Globals.Curtime() * 700000).toFixed(12) % 13) {
        case 0:
            ui_set_value("Anti-aim", "Extra", "Pitch", 1);
            break;
        case 1:
            ui_set_value("Anti-aim", "Extra", "Pitch", 5);
            break;
    }
}
if (ui_get_value("Script items", "Script items", "legit type") == 0){
    if (Input.IsKeyPressed(0x45) && legit() && ui_is_hotkey_active("Script items", "legit aa key")) 
    {                                                      /*legit*/
        Cheat.ExecuteCommand("-use");                     /*legit*/
        ui_set_value("Anti-aim", "Extra", "Pitch", 0);   /*legit*/
        ui_set_value("Anti-Aim", "Yaw offset", -180);   /*legit*/
        ui_set_value("Anti-aim", "At targets", false); /*legit*/
        Cheat.ExecuteCommand("-use");
    }     
}
else if (ui_get_value("Script items", "Script items", "legit type") == 1) {
    if (Input.IsKeyPressed(0x45) && legit() && ui_is_hotkey_active("Script items", "legit aa key"))
    {
    Cheat.ExecuteCommand("-use");
    ui_set_value("Anti-aim", "Extra", "Pitch", 0);   
    ui_set_value("Anti-Aim", "Yaw offset", -180);  
    ui_set_value("Anti-aim", "At targets", true); 
    Cheat.ExecuteCommand("-use");           
    }
}

var localPlayer = Entity.GetLocalPlayer();
var localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");
var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")

if (ui_get_value("Script items", "Script items", "fakelag switch")) {
    switch (Globals.Tickcount() % 4) {
        case 0:
            ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 1);
            ui_set_value("Anti-aim", "Fake-Lag", "Limit", 14);
            ui_set_value("Anti-aim", "Fake-Lag", "Jitter", 90);
            ui_set_value("Anti-aim", "Fake-Lag", "Trigger limit", 16);
            break;
        case 1:
            ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 1);
            ui_set_value("Anti-aim", "Fake-Lag", "Limit", 14);
            ui_set_value("Anti-aim", "Fake-Lag", "Jitter", 14);
            ui_set_value("Anti-aim", "Fake-Lag", "Trigger limit", 14);
            break;
        case 2:
            ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 1);
            ui_set_value("Anti-aim", "Fake-Lag", "Limit", 16);
            ui_set_value("Anti-aim", "Fake-Lag", "Jitter", 16);
            ui_set_value("Anti-aim", "Fake-Lag", "Trigger limit", 13);
            break;
        case 3:
            ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 1);
            ui_set_value("Anti-aim", "Fake-Lag", "Limit", 13);
            ui_set_value("Anti-aim", "Fake-Lag", "Jitter", 50);
            ui_set_value("Anti-aim", "Fake-Lag", "Trigger limit", 14);
            break;   
        case 4:
            ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 1);
            ui_set_value("Anti-aim", "Fake-Lag", "Limit", 7);
            ui_set_value("Anti-aim", "Fake-Lag", "Jitter", 0);
            ui_set_value("Anti-aim", "Fake-Lag", "Trigger limit", 7);
            break;  
    }
if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) < 1.1)
ui_set_value("Anti-aim", "Fake-Lag", "Enabled", 0);
}

if (ui_is_hotkey_active("Script items", "freestand key")) 
{
    ui_set_value("Anti-Aim", "Rage Anti-Aim", "Auto direction", true);
} 
else 
{
    ui_set_value("Anti-Aim", "Rage Anti-Aim", "Auto direction", false);
}

if (ui_get_value("Script items", "Script items", "custom jitter")) {
    switch (Globals.Tickcount() % 3) {
        case 0:
            ui_set_value("Anti-Aim", "Yaw offset", -40);  
            break;
        case 1:
            ui_set_value("Anti-Aim", "Yaw offset", 40);  
            break;
    }
    switch (Globals.Tickcount() % 3) {
        case 0:
            ui_set_value("Anti-Aim", "Yaw offset", 40);  
            break;
        case 1:
            ui_set_value("Anti-Aim", "Yaw offset", -40);  
            break;
    }
}

if (ui_get_value("Script items", "Script items", "jitter break")) {
    switch (Globals.Tickcount() % 2) {
        case 0:
            UI.ToggleHotkey("Anti-Aim", "Jitter offset");
            break;
        case 1:
            UI.ToggleHotkey("Anti-Aim", "Jitter offset");
            break;
    }
}

if (ui_get_value("Script items", "Script items", "manual target") == 0) {
    if (ui_get_value("Script items", "Script items", "manual dir") == 1) 
{
    if (ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items", "legit aa key"))
{
    ui_set_value("Script items","manuals", 1); 
      ui_set_value("Anti-Aim", "Jitter offset", 0);
      ui_set_value("Anti-aim", "Fake angles", "Enabled", false);
      ui_set_value("Anti-aim", "At targets", false);
}
    if (ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items", "legit aa key"))
{
         
       ui_set_value("Anti-Aim", "Jitter offset", 0);
       ui_set_value("Script items","manuals", 2);
       ui_set_value("Anti-aim", "Fake angles", "Enabled", false);
       ui_set_value("Anti-aim", "At targets", false);
}
}
    
if (ui_get_value("Script items", "Script items", "manual dir") == 2)
{
    if (ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items", "legit aa key"))
{
    ui_set_value("Script items","manuals", 1);
        ui_set_value("Anti-aim", "At targets", false);
}
    if (ui_is_hotkey_active("Script items","manual right")  && !ui_is_hotkey_active("Script items", "legit aa key"))
{
          
        ui_set_value("Script items","manuals", 2);
        ui_set_value("Anti-aim", "At targets", false);
}
}
if (!ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items","manual left")) {
    ui_set_value("Script items","manuals", 0);   
}
}
else if (ui_get_value("Script items", "Script items", "manual target") == 1) {
if (ui_get_value("Script items", "Script items", "manual dir") == 1) {
if (ui_is_hotkey_active("Script items","manual left") && !ui_is_hotkey_active("Script items", "legit aa key")){
    ui_set_value("Script items","manuals", 1);
  ui_set_value("Anti-Aim", "Jitter offset", 0);
  ui_set_value("Anti-aim", "Fake angles", "Enabled", false);
}
if (ui_is_hotkey_active("Script items","manual right") && !ui_is_hotkey_active("Script items", "legit aa key")){
   ui_set_value("Anti-Aim", "Jitter offset", 0);
   ui_set_value("Script items","manuals", 2);
   ui_set_value("Anti-aim", "Fake angles", "Enabled", false);
}

}

if (ui_get_value("Script items", "Script items", "manual dir") == 2) {
    if (ui_is_hotkey_active("Script items","manual left")  && !ui_is_hotkey_active("Script items", "legit aa key")){
        ui_set_value("Script items","manuals", 1);
    }
    if (ui_is_hotkey_active("Script items","manual right")  && !ui_is_hotkey_active("Script items", "legit aa key"))
{
    ui_set_value("Script items","manuals", 2);
}

}
}

if (ui_get_value("Script items", "Script items", "manuals") == 2 && !ui_is_hotkey_active("Script items", "legit aa key")) {
    ui_set_value("Anti-Aim", "Yaw offset", 90); 
}

if (ui_get_value("Script items", "manuals") == 0) {
    for (var i in this.aa.conditions) {
        const conditionw = this.aa.conditions[i];
    ui_set_value("Anti-Aim", "Yaw offset", ui_is_hotkey_active("Anti-Aim", "Fake angles", "Inverter") ? conditionw + " yaw left" : conditionw + " yaw right"); 
    }
}

if (ui_get_value("Script items", "Script items", "manuals") == 1 && !ui_is_hotkey_active("Script items", "legit aa key")) {
    ui_set_value("Anti-Aim", "Yaw offset", -90); 
}

if (ui_is_hotkey_active("Script items","manual left") && ui_is_hotkey_active("Script items","manual right")){
 UI.ToggleHotkey("Script items","manual right");
UI.ToggleHotkey("Script items","manual left");   
}


if (ui_is_hotkey_active("Script items", "ping spike"))
{
    ui_set_value("Misc", "General", "Extended backtracking", 1)
}
else 
{                 
    ui_set_value("Misc", "General", "Extended backtracking", 0)
}

if (!UI.GetValue("Misc", "JavaScript", "Script itemes", "pitch on land")) return;
if (!Entity.GetLocalPlayer()) return;

const localPlayer = Entity.GetLocalPlayer();
const localPlayerFlags = Entity.GetProp(localPlayer, "CBasePlayer", "m_fFlags");



if (localPlayerFlags == 256 || localPlayerFlags == 262) {
    groundCounter = 0;
}

    if (localPlayerFlags == 257 || localPlayerFlags == 261 || localPlayerFlags == 263) {
        groundCounter = groundCounter + 1;
    }

    if (groundCounter > 10 && groundCounter < 50) {
        UI.SetValue("Anti-aim", "Extra", "Pitch", 5);
    } else {
        UI.SetValue("Anti-aim", "Extra", "Pitch", 1);
    }
}

function get_weaponname() {
  const weapon = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
  switch (weapon) {
      case 'ssg 08':
          return 'ssg08';

      case 'scar 20':
      case 'g3sg1':
          return 'auto';

      case 'awp':
          return 'awp';

      case 'desert eagle':
          return 'deagle';

      case 'r8 revolver':
      case ' 52>;L25@ r8':
          return 'revolver';

      case 'p2000':
      case 'five seven':
      case 'p250':
      case 'usp s':
      case 'dual berettas':
      case 'cz75 auto':
      case 'tec 9':
      case 'glock 18':
          return 'pistol';

      case 'ak 47':
      case 'galil ar':
      case 'sg 553':
      case 'mac 10':
      case 'mp5 sd`':
      case 'mp7':
      case 'ump 45':
      case 'p90':
      case 'pp bizon':
      case 'nova':
      case 'xm1014':
      case 'sawed off':
      case 'm249':
      case 'negev':
      case 'famas':
      case 'm4a4':
      case 'm4a1 s':
      case 'mp9':
      case 'mag 7':
          return 'general';
  }
}

function dmgoverride() {
  if (!UI.IsHotkeyActive("Script items", "damage override")) return;

  const damage_slider = UI.GetValue("Script items", get_weaponname() + ' dmg');

  enemies = Entity.GetEnemies();
  for (i = 0; i < enemies.length; i++) {
      if (!Entity.IsValid(enemies[i]) || !Entity.IsAlive(enemies[i])) continue;
      Ragebot.ForceTargetMinimumDamage(enemies[i], damage_slider);
  }
}

Cheat.RegisterCallback('CreateMove', 'dmgoverride');

var x = 30, y = 420;

var gun_fired = false;
var font_size = 4;


var other_weapons =
[
    "knife",
    "knife_t",
    "knife_karambit",
    "knife_m9_bayonet",
    "knife_survival_bowie",
    "knife_butterfly",
    "knife_flip",
    "knife_push",
    "knife_tactical",
    "knife_falchion",
    "knife_gut",
    "knife_ursus",
    "knife_gypsy_jackknife",
    "knife_stiletto",
    "knife_widowmaker",
    "knife_css",
    "knife_cord",
    "knife_canis",
    "knife_outdoor",
    "knife_skeleton",
    "bayonet",
    "hegrenade",
    "smokegrenade",
    "molotov",
    "incgrenade",
    "flashbang",
    "decoy",
    "taser"
];

var shots =
{
    fired: 0,
    hit: 0,
    missed: 0,
    hit_chance: 0,
    miss_chance: 0
};

function is_gun(weapon_name) {
  
    for(var i = 0; i < other_weapons.length; i++) {
      
        if(weapon_name == "weapon_" + other_weapons[i]) {

            return false;

        }

    }

    return true;

}

function weapon_fire() {
    var player_id = Event.GetInt("userid");
    var player_weapon = Event.GetString("weapon");

    if(Entity.IsLocalPlayer(Entity.GetEntityFromUserID(player_id)) && is_gun(player_weapon)) {

        shots.fired = shots.fired + 1;
        gun_fired = true;

    }
}

function player_hurt() {
    var attacker_id = Event.GetInt("attacker");
    var attacker_weapon = Event.GetString("weapon");

    if(Entity.IsLocalPlayer(Entity.GetEntityFromUserID(attacker_id)) && is_gun(attacker_weapon) && gun_fired) {

        shots.hit = shots.hit + 1;
        gun_fired = false;

    }
}

function round_prestart() {
    if( UI.GetValue("Misc", "JAVASCRIPT", "reset on round start") ) {
        for (var key in shots){
            shots[key] = 0;
        }
    }
}

function main() {

    if(Global.GetMapName() == "" || !UI.GetValue("Misc", "JAVASCRIPT", "hit/miss ratio"))
        return;
  
    shots.missed = shots.fired - shots.hit;
    shots.hit_chance = ( (shots.hit / shots.miss_chance) * 100 );
    shots.miss_chance = ( (shots.missed / shots.fired) * 100 );
  
    text_size = Render.TextSize("total: " + shots.fired, font_size);

    if(shots.fired > 0) {

       // Render.String(x, y + (text_size[1]-12)*4.5, 0, shots.hit + " / " + shots.missed + " ( " + Math.round(shots.hit_chance) + "% )", [255, 255, 255, 255], font_size);

    }

}

 function lerp_color(a, b, t) {
    return [
        lerp(a[0], b[0], t),
        lerp(a[1], b[1], t),
        lerp(a[2], b[2], t),
        lerp(a[3], b[3], t)
    ];
};

var ping_spike = {};
ping_spike.color = [255, 255, 255];
	
ping_spike.get_ping = function() {
	return Math.floor(Entity.GetProp(Entity.GetLocalPlayer(), "CPlayerResource", "m_iPing")).toString()
}
    
ping_spike.get_color = function() {
	var ping = ping_spike.get_ping();
		
    if (ping < 80) return [255, 255, 255];
        
    if (ping < 120) return [255, 200, 200];
		
    if (ping < 150) return [255, 255, 150];
		
    return [127, 177, 26];
};

var is_ready = function(ent) {
	if (!ent) return false;
	
    var next_attack = Entity.GetProp(ent, 'CBaseCombatCharacter', 'm_flNextAttack');
    return next_attack < Globals.Curtime();
};

function skeet(){
	const screen = Render.GetScreenSize();
    const font = Render.AddFont('Calibri Bold', 20, 600);
	const position = [10, screen[1] * .707]; 
	
	Render.Indicator = function(color, text) {
        text_sz = Render.TextSizeCustom(text, font);     
		var width = text_sz[0] * .5;
        var height = text_sz[1] + 4;

        position[1] -= height;
        var offset = [position[0], position[1]];

        Render.GradientRect(position[0], position[1] , width, height, 1, [0, 0, 0, 0], [0, 0, 0, 50]);
        Render.GradientRect(position[0] + width, position[1] , width, height, 1, [0, 0, 0, 50], [0, 0, 0, 0]);

        offset[0] += 10;
        offset[1] += height * 0.5 - text_sz[1] * 0.5;

        Render.StringCustom(offset[0] + 1, offset[1] + 1 , 0, text, [0, 0, 0, color[3] * 0.5], font);
        Render.StringCustom(offset[0], offset[1] , 0, text, color, font);

        position[1] -= 4;
    }

    test4 = lerp(test4, ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck") ? 255 : 1 , globals_frametime() * 8)
    b = lerp(b, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force body aim") ? 255 : 1 , globals_frametime() * 8)
    d = lerp(d, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force safe point") ? 255 : 1 , globals_frametime() * 8)
    c = lerp(c, ui_get_value("Miscellaneous", "Extended backtracking") ? 255 : 1 , globals_frametime() * 8)
    m = lerp(m, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Hide shots") ? 255 : 1 , globals_frametime() * 8)
    k = lerp(k, ui_is_hotkey_active("Script items", "damage override") ? 255 : 1 , globals_frametime() * 8)
    a = lerp(a, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap") ? 255 : 1 , globals_frametime() * 8)
    g = lerp(g, ui_is_hotkey_active("Script items", "dormant aimbot") ? 255 : 1 , globals_frametime() * 8)
    f = lerp(f, ui_get_value("Anti-Aim", "Rage Anti-Aim", "Auto direction") ? 255 : 1 , globals_frametime() * 8)    
   
    if (!menu.DropdownValue(menu.GetValue("visual tab"), 5)) 
    return

    if (ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck"))
      Render.Indicator([230, 230, 230, test4], 'DUCK' );

	if (ui_is_hotkey_active("Rage", "GENERAL", "General", "Force safe point"))
		Render.Indicator([230, 230, 230, d], 'SAFE');

	if(ui_get_value("Miscellaneous", "Extended backtracking"))
		Render.Indicator([ping_spike.color[0], ping_spike.color[1], ping_spike.color[2], c], 'PING');
		ping_spike.color = lerp_color(ping_spike.color, ping_spike.get_color(), Globals.Frametime() * 175 * .095);

	if (ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap") && ui_get_value("Rage", "GENERAL", "Exploits", "Doubletap")) {
		var color = is_ready(Entity.GetLocalPlayer()) && Exploit.GetCharge() == 1 ? [230, 230, 230] : [a, 12, 50];
		
		Render.Indicator([color[0], color[1], color[2], a], 'DT');
	} else if (UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots")){
		var color = is_ready(Entity.GetLocalPlayer()) && Exploit.GetCharge() == 1 ? [230, 230, 230] : [m, 12, 50];
		
		Render.Indicator([color[0], color[1], color[2], m], 'OSAA');
	}

	if (ui_is_hotkey_active("Rage", "GENERAL", "General", "Force body aim"))
		Render.Indicator([230, 230, 230, b], 'BODY');

	if(ui_is_hotkey_active("Script items", "dormant aimbot")) 
		Render.Indicator([230, 230, 230, g], 'DA');  

    if(ui_is_hotkey_active("Script items", "damage override"))
		Render.Indicator([230, 230, 230, k], 'MD');

	if(ui_get_value("Anti-Aim", "Rage Anti-Aim", "Auto direction"))	
		Render.Indicator([230, 230, 230, f], 'FS');     

}

function waterskeet() {
    if (!menu.DropdownValue(menu.GetValue("visual tab"), 4)) 
    return
  var screen = Render.GetScreenSize() 
  var x2 = screen[0] - 2; var y2 = screen[1] / 1 - 1400;
  var x = Global.GetScreenSize()[0] - 2;
  var today = new Date();
  const username = Cheat.GetUsername();
  var hours1 = today.getHours();
  var minutes1 = today.getMinutes();
  var seconds1 = today.getSeconds();
  var hours = hours1 <= 9 ? "0" + today.getHours() + ":" : today.getHours() + ":";
  var minutes = minutes1 <= 9 ? "0" + today.getMinutes() + ":" : today.getMinutes() + ":";
  var seconds = seconds1 <= 9 ? "0" + today.getSeconds() : today.getSeconds();
  var ping = Math.floor(Global.Latency() * 1000 / 1.5);
  var font = Render.AddFont("Small Fonts", 5, 400);
  var text = "ANTARCTICA | " + Cheat.GetFixedUsername().toUpperCase() + " | DELAY: " + ping + " | " + hours + minutes + seconds;
  var w = Render.TextSizeCustom(text, font)[0] + 8;
  x = x - w - 10;
  if (ui_get_value("Script items", "glow style") == 1){
    Render.FadedCircle( x + w - 2, 18, 12, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50]);
    Render.FadedCircle( x, 18, 12, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50]);    
    }
  render_filled_rect( x , 10, w, 18, [ 17, 17, 17, 255 ]); 
  render_filled_rect( x , 12.5, 2, 14, [ cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255 ]); 
  render_filled_rect( x + w - 2, 12.5, 2, 14, [ cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255 ]); 
  //render_filled_rect( x , 10, w , 4, [ 255, 255, 255, 255 ]);
  render_util.string_outline( x + 4, 14, 0, text.toUpperCase(), [ 255, 255, 255, 255 ], font ); 
  if (ui_get_value("Script items", "glow style") == 2){
  Render.FadedCircle( x + w - 2, 18, 15, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50]);
  Render.FadedCircle( x, 18, 15, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50]);
  }
}
function keybinds()
 {


    if (!menu.DropdownValue(menu.GetValue("visual tab"), 1)) 
    return

      if (!font)
          font = render_add_font("Small Fonts", 5, 400)
  
      var local_player = entity_get_local_player()
      if (!entity_is_alive(local_player))
          return
          
      in_scope_animation = lerp(in_scope_animation, entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? 1 : 0, globals_frametime() * 2)
      test4 = lerp(test4, ui_is_hotkey_active("Anti-Aim", "Extra", "Fake duck") ? 255 : 1 , globals_frametime() * 8)
      b = lerp(b, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force body aim") ? 255 : 1 , globals_frametime() * 8)
      d = lerp(d, ui_is_hotkey_active("Rage", "GENERAL", "General", "Force safe point") ? 255 : 1 , globals_frametime() * 8)
      c = lerp(c, ui_get_value("Miscellaneous", "Extended backtracking") ? 255 : 1 , globals_frametime() * 8)
      m = lerp(m, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Hide shots") ? 255 : 1 , globals_frametime() * 8)
      k = lerp(k, ui_is_hotkey_active("Script items", "damage override") ? 255 : 1 , globals_frametime() * 8)
      a = lerp(a, ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap") ? 255 : 1 , globals_frametime() * 8)
      g = lerp(g, ui_is_hotkey_active("Script items", "dormant aimbot") ? 255 : 1 , globals_frametime() * 8)
      f = lerp(f, ui_get_value("Anti-Aim", "Rage Anti-Aim", "Auto direction") ? 255 : 1 , globals_frametime() * 8)

      for (var i in indicators_list) {
        var indicator = indicators_list[i]
      if (af <= 1 && ui_is_hotkey_active.apply(null, indicator.reference)) {
        af = 1;
    } else {
        af = lerp(af, 1, Globals.Frametime() * 3);;
    }
}
      
      var screen_size = render_get_screen_size()
      var center_screen = [screen_size[0] / 2, screen_size[1] / 2]
      var center_text = "ANTARCTICA"
      var center_text_size = render_text_size_custom(center_text, font)
      var half_center_text_width = center_text_size[0] / 2
      var text_position = [center_screen[0] - half_center_text_width + (half_center_text_width + 10) * in_scope_animation, center_screen[1] + 10]
      var alpha = Math.abs(Math.sin(Globals.Realtime() * 1.5));
      var vertext = "YAW"
      render_util.string_outline(text_position[0], text_position[1] + 20, 0, center_text, [255, 255, 255, 255], font)
      render_util.string_outline(text_position[0] + 47, text_position[1] + 20, 0, vertext, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], alpha*255], font)      
  

      //if (UI.IsHotkeyActive("Script items", "manual left"))
      //    render_util.string_outline(text_position[0] - 5, text_position[1] + 19, 0, "<", [255, 255, 255, 255], font)
      //else if (UI.IsHotkeyActive("Script items", "manual right"))
      //    render_util.string_outline(text_position[0] + 47, text_position[1] + 19, 0, ">", [255, 255, 255, 255], font)

      text_position[1] += 10

      var screen_size2 = render_get_screen_size()
      var center_screen2 = [screen_size2[0] / 2, screen_size2[1] / 2]
      var center_text2 = '' +state+ ''
      var center_text_size2 = render_text_size_custom(center_text2, font)
      var half_center_text_width2 = center_text_size2[0] / 2
      var text_position3 = [center_screen2[0] - half_center_text_width2 + (half_center_text_width2 + 10) * in_scope_animation, center_screen2[1] + 10]

      render_util.string_outline(text_position3[0], text_position3[1] + 30, 0, center_text2, [255, 255, 255, 255], font)

      text_position[1] += 10 
  
        local = Entity.GetLocalPlayer();
        real_yaw = Local.GetRealYaw();
        fake_yaw = Local.GetFakeYaw();
        var velocity = entity_get_prop(ctx.local, "DT_BasePlayer", "m_vecVelocity[0]")
        if (math_sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]) > 1.1 && ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap"))
        {
        delta = Math.min(Math.abs(60 - 30) , 70).toFixed(0);   
        }
        else
        {
        delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);            
        }

        cf = lerp(cf, delta, globals_frametime() * 8)
        render_filled_rect(text_position[0], text_position[1] - 10, 45, 4.9, [22, 22, 22, 200]);
        render_gradient_rect(text_position[0], text_position[1] - 9, 0.781 * cf, 2.9, 2, [255, 255, 255, 255], [255, 255, 255, 0]);
        render_rect(text_position[0], text_position[1] - 10, 45, 4.9, [22, 22, 22, 255]);
        text_position[1] += 20 
  
      //render_util.glow_rect(text_position1[0] + 15, text_position1[1] + 10, 10, 4,[255, 255, 255,55], 5)
         
      for (var i in indicators_list) {
        var indicator = indicators_list[i]
        if (!ui_is_hotkey_active.apply(null, indicator.reference))
            continue
        var name_size = render_text_size_custom(indicator.name, font)
        var half_name_width = name_size[0] / 2
        text_position[0] = center_screen[0] - half_name_width + (half_name_width + 10) * in_scope_animation
        render_util.string_outline(text_position[0], text_position[1], 0, indicator.name, [255, 255, 255, 255 * af], font)

        text_position[1] += 10 
    }

      var is_double_tap_enabled = ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap")
      if (is_double_tap_enabled) {
        var screen_size = render_get_screen_size()
        var center_screen = [screen_size[0] / 2, screen_size[1] / 2]
        var ver_text_size = render_text_size_custom(center_text, font)
        var half_ver_text_width = ver_text_size[0] / 2
        var text_position2 = [center_screen[0] - half_ver_text_width + (charge_amount == 1 ? half_ver_text_width + 7 : half_ver_text_width + 5) * in_scope_animation, center_screen[1] + 9]
          var indicator_name = "DT"
          var charge_amount = exploit_get_charge()
          var text_color = charge_amount == 1 ? [255, 255, 255, a] : [255, 0, 0, a]
          render_util.string_outline(entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? charge_amount == 1 ? text_position2[0] + 5 : text_position2[0] + 5 : charge_amount == 1 ? text_position2[0] + 5 : text_position2[0] + 3, text_position[1] + 1, 0, indicator_name, text_color, font)
          //render_util.string_outline(text_position2[0] + 18, text_position2[1] + 31, 0, charge_amount == 1 ? "READY" : "CHARGING", entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? [255,255,255,0] : text_color, font)

          
      }
          const upper = charge_amount == 1 ? "READY" : "CHARGE";
          var offset_h = 0;
          const mul = 510 / upper.length;
          for (var i2 in upper) {
            const ch = upper[i2];
            const anim = (globals_tickcount() * 9 - i2 * mul) % 510;
            render_util.string_outline(charge_amount == 1 ? text_position2[0] + 17 + offset_h : text_position2[0] + 13.5 + offset_h, text_position[1] + 1, 0, ch, entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? charge_amount == 1 ? [255,255,255,0] : [anim > 255 ? 510 - anim : anim, 0, 0, 0] : charge_amount == 1 ? [255,255,255,a] : [anim > 255 ? 510 - anim : anim, 0, 0, a], font);

            offset_h += render_text_size_custom(ch, font)[0];
           }
           text_position[1] += 10
  
          //var indicator_name_size = render_text_size_custom(indicator_name, font)
          //var bar_position = [text_position[0] + indicator_name_size[0] + 4, text_position[1] + 2]
          //var bar_size = [center_text_size[0] - indicator_name_size[0] - 4, 4]
          //render_filled_rect(bar_position[0], bar_position[1] + 20, bar_size[0], bar_size[1], [0, 0, 0, 128])
          //render_filled_rect(bar_position[0] + 1, bar_position[1] + 19, (bar_size[0] - 2) * charge_amount, bar_size[1] - 2, [255, 255, 255, 255])
          //render_rect(bar_position[0], bar_position[1]  + 20, bar_size[0], bar_size[1], [0, 0, 0, 255])
    }


var Inair = function() {
    if(!(Entity.GetProp(Entity.GetLocalPlayer(), "CBasePlayer", "m_fFlags") & (1 << 0))) {
        return true;
    } else {
        return false;
    }
}

var getVelocity = function(index) {
	players = Entity.GetPlayers();
	for(i = 0; i < players.length; i++); {
		var velocity = Entity.GetProp(index, "CBasePlayer", "m_vecVelocity[0]");
		var speed = Math.sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]);
	}
	return speed;
}

var lerp = function (start, end, amount) {
    return start + (end - start) * amount
}

var indicators_list = [
   // {
   // name: "DT",
   // reference: ["Rage", "GENERAL", "Exploits", "Doubletap"]
   // },
    {
        name: "DORMANT",
        reference: ["Script items", "dormant aimbot"]
    },   
    {
    name: "HIDE",
    reference: ["Rage", "GENERAL", "Exploits", "Hide shots"]
    },
    {
        name: "BODY",
        reference: ["Rage", "GENERAL", "Genral", "Force body aim"]
    },

    {
        name: "SAFE",
        reference: ["Rage", "GENERAL", "Genral", "Force safe point"]
    },
    {
        name: "DUCK",
        reference: ["Anti-Aim", "Extra", "Fake duck"]
    },
    //{
    //   name: "SLOW",
    //    reference: ["Anti-Aim", "Extra", "Slow walk"]
    //},
    {
        name: "EJUMP",
        reference: ["Misc", "GENERAL", "Movement", "Edge jump"]
    },
    {
        name: "PEEK",
        reference: ["Misc", "GENERAL", "Movement", "Auto peek"]
    },
    {
        name: "DMG",
        reference: ["Script items", "damage override"]
    },
    {
        name: "FREESTAND",
        reference: ["Script items", "freestand key"]
    }
]
/*    if (cfg.visuals.inds.inds & (1 << 0)) {

    if (!font)
        font = render_add_font("Small Fonts", 5, 400)

    var local_player = entity_get_local_player()
    if (!entity_is_alive(local_player))
        return

    in_scope_animation = lerp(in_scope_animation, entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? 1 : 0, 0.1)

    
    var screen_size = render_get_screen_size()
    var center_screen = [screen_size[0] / 2, screen_size[1] / 2]
    var center_text = "ANTARCTICA"
    var center_text_size = render_text_size_custom(center_text, font)
    var half_center_text_width = center_text_size[0] / 2
    var text_position = [center_screen[0] - half_center_text_width + (half_center_text_width + 10) * in_scope_animation, center_screen[1] + 10]
    var alpha = Math.abs(Math.sin(Globals.Realtime() * 1.5));
    var vertext = "BETA"
    if (!UI.GetValue("Script items", "desync line")){
    render_util.string_outline(text_position[0] + 47, text_position[1] + 10, 0, vertext, [255, 255, 255, alpha*255], font)
    render_util.string_outline(text_position[0], text_position[1] + 10, 0, center_text, [255, 255, 255, 255], font)      
    }
    else {
    render_util.string_outline(text_position[0], text_position[1] + 20, 0, center_text, [255, 255, 255, 255], font)
    render_util.string_outline(text_position[0] + 47, text_position[1] + 20, 0, vertext, [255, 255, 255, alpha*255], font)      
    }

    //if (UI.IsHotkeyActive("Script items", "manual left"))
    //    render_util.string_outline(text_position[0] - 5, text_position[1] + 19, 0, "<", [255, 255, 255, 255], font)
    //else if (UI.IsHotkeyActive("Script items", "manual right"))
    //    render_util.string_outline(text_position[0] + 47, text_position[1] + 19, 0, ">", [255, 255, 255, 255], font)
    if (!UI.GetValue("Script items", "desync line"))
    text_position[1] += 10
    else
    text_position[1] += 10

    if (UI.GetValue("Script items", "desync line")) {
      local = Entity.GetLocalPlayer();
      real_yaw = Local.GetRealYaw();
      fake_yaw = Local.GetFakeYaw();
      delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);
      render_filled_rect(text_position[0], text_position[1], 45, 4.9, [22, 22, 22, 200]);
      render_gradient_rect(text_position[0], text_position[1] + 1, 0.781 * delta, 2.9, 2, [255, 255, 255, 255], [255, 255, 255, 0]);
      render_rect(text_position[0], text_position[1], 45, 4.9, [22, 22, 22, 255]);
      text_position[1] += 10 
    }

    //render_util.glow_rect(text_position1[0] + 15, text_position1[1] + 10, 10, 4,[255, 255, 255,55], 5)
       


    var is_double_tap_enabled = ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Doubletap")
    var is_hide_shots_enabled = ui_is_hotkey_active("Rage", "GENERAL", "Exploits", "Hide shots")
    if (is_double_tap_enabled || is_hide_shots_enabled) {
      var screen_size = render_get_screen_size()
      var center_screen = [screen_size[0] / 2, screen_size[1] / 2]
      var ver_text_size = render_text_size_custom(center_text, font)
      var half_ver_text_width = ver_text_size[0] / 2
      var text_position2 = [center_screen[0] - half_ver_text_width + (half_ver_text_width + 3) * in_scope_animation, center_screen[1] + 9]
        var indicator_name = is_double_tap_enabled ? "DT" : "HS"
        var charge_amount = exploit_get_charge()
        var text_color = charge_amount == 1 ? [255, 255, 255, 255] : [255, 50, 80, 255]
        render_util.string_outline(text_position2[0] + 7, text_position2[1] + 31, 0, indicator_name, text_color, font)
        render_util.string_outline(text_position2[0] + 18, text_position2[1] + 31, 0, charge_amount == 1 ? "READY" : "CHARGING", entity_get_prop(local_player, "DT_CSPlayer", "m_bIsScoped") ? [255,255,255,0] : text_color, font)

        var indicator_name_size = render_text_size_custom(indicator_name, font)
        //var bar_position = [text_position[0] + indicator_name_size[0] + 4, text_position[1] + 2]
        //var bar_size = [center_text_size[0] - indicator_name_size[0] - 4, 4]
        //render_filled_rect(bar_position[0], bar_position[1] + 20, bar_size[0], bar_size[1], [0, 0, 0, 128])
        //render_filled_rect(bar_position[0] + 1, bar_position[1] + 19, (bar_size[0] - 2) * charge_amount, bar_size[1] - 2, [255, 255, 255, 255])
        //render_rect(bar_position[0], bar_position[1]  + 20, bar_size[0], bar_size[1], [0, 0, 0, 255])

        text_position[1] += 10
    }

    for (var i in indicators_list) {
        var indicator = indicators_list[i]
        if (!ui_is_hotkey_active.apply(null, indicator.reference))
            continue

        var name_size = render_text_size_custom(indicator.name, font)
        var half_name_width = name_size[0] / 2
        text_position[0] = center_screen[0] - half_name_width + (half_name_width + 10) * in_scope_animation
        render_util.string_outline(text_position[0], text_position[1] + 10, 0, indicator.name, [255, 255, 255, 255], font)

        text_position[1] += 10
    } */
var font = 0
var in_scope_animation = 0
var test = 0
var test2 = 0
var test3 = 0
var test4 = 0
var f = 0
var cf = 0
var af = 0
var g = 0
var a = 0
var d = 0
var m = 0
var expc = 0
var exp = 0
var b = 0
var c = 0
var k = 0
var kb = new Array

var legit = function()                                                                                                                                                                                                                                                                                                                                                                                                                                                                 {if (!Entity.IsAlive(Entity.GetLocalPlayer())) return false; var lorigin = Entity.GetRenderOrigin(Entity.GetLocalPlayer()); var disablers = Entity.GetEntitiesByClassID(97).concat(Entity.GetEntitiesByClassID(128)); for (var i = 0; i < disablers.length; i++) { var origin = Entity.GetRenderOrigin(disablers[i]); var distance = distance_to_pos(lorigin, origin); if (distance > 64) continue; return false; } return true; };

function on_draw() {
  local = Entity.GetLocalPlayer();
  scoped = Entity.GetProp(local, "CCSPlayer", "m_bIsScoped");

  if (UI.GetValue("Script items", "viewmodel in scope")) {
  if (!Entity.IsAlive(local) || !World.GetServerString()) {
  Convar.SetFloat("r_drawvgui", 1);
  Convar.SetInt("fov_cs_debug", 0);
  }
  if (scoped) {
  Convar.SetFloat("r_drawvgui", 0);
  if (!UI.IsHotkeyActive("Visual", "WORLD", "View", "Thirdperson")) {
  Cheat.ExecuteCommand("fov_cs_debug 90");
  }
  } else {
  Convar.SetFloat("r_drawvgui", 1);
  Convar.SetInt("fov_cs_debug", 0);
  }    
  }
}

function loload() {
	Cheat.ExecuteCommand("fov_cs_debug 0");
}

Cheat.RegisterCallback("Unload", "loload")

if (!String.format) {
    String.format = function(format) {
        var args = Array.prototype.slice.call(arguments, 1)
        return format.replace(/{(\d+)}/g, function(match, number) { 
            return typeof args[number] != "undefined" ? args[number] : match
        })
    }
}

var easing = {
    lerp: function(a, b, percentage) {
        return a + (b - a) * percentage
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

var get_bar_color = function() {
    var color = menu.GetColor("Global color")

    var palette = menu.GetValue("Palette")

    if (palette != 0) {
        var rgb_split_ratio = menu.GetValue("Fade split ratio") / 100

        var h = palette == 2 ?
            Globals.Realtime() * (menu.GetValue("Fade frequency") / 100) :
            menu.GetValue("Fade offset") / 1000

        color = hsv_to_rgb(h, 1, 1)
        color = [
            color.r * rgb_split_ratio, 
            color.g * rgb_split_ratio, 
            color.b * rgb_split_ratio
        ]
    }

    return color
}

var anti_aimbot = {
    get_desync: function() {
        var RealYaw = Local.GetRealYaw();
        var FakeYaw = Local.GetFakeYaw();
        var delta = Math.min(Math.abs(RealYaw - FakeYaw) / 2, 58).toFixed(1);

        return delta
    }
}

var mouse_on_object = function(x, y, length, height) {
    var cursor = Input.GetCursorPosition()
    if (cursor[0] > x && cursor[0] < x + length && cursor[1] > y && cursor[1] < y + height)
        return true
    return false
}

Render.ShadowStringCustom = function(x, y, id, text, color, font) {
    Render.StringCustom(x + 1, y + 1, id, text, [0, 0, 0, (color[3] / 255) * 255], font)
    Render.StringCustom(x, y, id, text, color, font)
}

menu.SliderInt("hotkey_x", 0, 0, Global.GetScreenSize()[0])
menu.SliderInt("hotkey_y", 0, 0, Global.GetScreenSize()[1])
menu.SetVisible("hotkey_x", false)
menu.SetVisible("hotkey_y", false)

var fonts = function(size, h) {
    return {
        small: Render.AddFont("Small Fonts", size == undefined ? 5 : size, h == undefined ? 400 : h)  
    }
}


var ms_classes = {
    position: {
        offset: 0,

        g_paint_handler: function() {
            ms_classes.position.offset = 0
        }
    },
keybinds: {
    binds_list: [
        ["Resolver  override", ["Rage", "General", "Resolver override"], "Toggle", 0],
        ["Slow  motion", ["Anti-Aim", "Extra", "Slow walk"], "Toggle", 0],
        ["Force  body  aim", ["Rage", "General", "Force body aim"], "Toggle", 0],
        ["Force  safe  point", ["Rage", "General", "Force safe point"], "Toggle", 0],
        ["Auto  peek", ["Misc", "Movement", "Auto peek"], "Toggle", 0],
        ["Jump  at  edge", ["Misc", "Movement", "Edge jump"], "Toggle", 0],
        ["Duck  peek  assist", ["Anti-Aim", "Extra", "Fake duck"], "Toggle", 0],
        ["On-shot  anti-aim", ["Rage", "Exploits", "Hide shots"], "Toggle", 0],
        ["Double  tap", ["Rage", "Exploits", "Doubletap"], "Toggle", 0],
        ["Damage  override", ["Script items", "damage override"],"Toggle", 0]
    ],

kbalpha: 0,
latest_item_width: 0,
item_width: 0,
kb: new Array,
kbh: new Array,
width: 0,
x_off: 0,
y_off: 0,
stored: false,
drag: new Array(0, 0, 0),

state: function(i) {
    switch (i) {
        case "Hold":
            return "[holding]";
            break;
        case "Toggle":
            return "[toggled]";
            break;
        case "Always":
            return "[enabled]";
            break;
        case "[~]":
            return "[~]";
            break;
    }
},

namekb: function(i) {
    switch (i) {
        case "Hide shots":
            return "On  shot  anti-aim";
            break;
        case "Auto peek":
            return "Quick  peek  assist";
            break;
        case "Fake duck":
            return "Duck  peek  assist";
            break;
        case "Slow walk":
            return "Slow  motion";
            break;
        case "Edge jump":
            return "Jump  at  edge";
            break;
        case "Force safe point":
            return "Safe  point";
            break;
        case "damage override":
            return "Damage  override";
            break;
        default:
            return i;
            break;
    }           
},

g_paint_handler: function() {
    if (!menu.DropdownValue(menu.GetValue("visual tab"), 3)) 
        return

    var font = fonts().small

    var x = menu.GetValue("hotkey_x")
    var y = menu.GetValue("hotkey_y")

    for (i = 0; i < ms_classes.keybinds.binds_list.length; i++) {
        if (UI.IsHotkeyActive.apply(null, ms_classes.keybinds.binds_list[i][1])) {
            if (ms_classes.keybinds.kb.indexOf(ms_classes.keybinds.namekb(ms_classes.keybinds.binds_list[i][0])) == -1) {
                ms_classes.keybinds.kb.push(ms_classes.keybinds.namekb(ms_classes.keybinds.binds_list[i][0]))
                ms_classes.keybinds.kbh.push([ms_classes.keybinds.binds_list[i][2], ms_classes.keybinds.binds_list[i][3], ms_classes.keybinds.binds_list[i][1]])
            }
        }
    }

    var fr = 8 * 255 * Globals.Frametime();
    var color = get_bar_color()
    if (UI.IsMenuOpen() || ms_classes.keybinds.kb.length > 0) {
        if (ms_classes.keybinds.kbalpha <= 1) {
            ms_classes.keybinds.kbalpha = easing.lerp(ms_classes.keybinds.kbalpha, 1, Globals.Frametime() * 3);
        } else {
            ms_classes.keybinds.kbalpha = 1;
        }
    } else {
        if (ms_classes.keybinds.kbalpha >= 0) {
            ms_classes.keybinds.kbalpha = easing.lerp(ms_classes.keybinds.kbalpha, 0, Globals.Frametime() * 3);
        } else {
            ms_classes.keybinds.kbalpha = 0;
        }
    }

    if (ms_classes.keybinds.kb.length < 1) {
        ms_classes.keybinds.item_width = 0
    }

    for (i = 0; i < ms_classes.keybinds.kb.length; i++) {
        if (Render.TextSizeCustom(ms_classes.keybinds.kb[i], font)[0] > ms_classes.keybinds.latest_item_width) {
            ms_classes.keybinds.latest_item_width = Render.TextSizeCustom(ms_classes.keybinds.kb[i], font)[0]
            ms_classes.keybinds.item_width = ms_classes.keybinds.latest_item_width
        }
    }
    ms_classes.keybinds.width = easing.lerp(ms_classes.keybinds.width, ms_classes.keybinds.item_width + 80, Globals.Frametime() * 3);

    if (ui_get_value("Script items", "glow style") == 1){
        Render.FadedCircle( x, y + 10, 12, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50 * ms_classes.keybinds.kbalpha]);
        Render.FadedCircle(x - 2 + ms_classes.keybinds.width, y + 10, 12, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50 * ms_classes.keybinds.kbalpha]);
    }

    Render.FilledRect(x, y + 2, ms_classes.keybinds.width, 18, [17, 17, 17, (255 * ms_classes.keybinds.kbalpha) * (cfg.visuals.inds.accent[3] / 255)]);

    Render.FilledRect(x, y + 4, 2, 14, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255 * ms_classes.keybinds.kbalpha])
    Render.FilledRect(x - 2 + ms_classes.keybinds.width, y + 4, 2, 14, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 255 * ms_classes.keybinds.kbalpha])

    render_util.string_outline(x + ms_classes.keybinds.width / 2, y + 6, 1, "KEYBINDS", [255, 255, 255, 255 * ms_classes.keybinds.kbalpha], font);
    if (ui_get_value("Script items", "glow style") == 2){
        Render.FadedCircle( x, y + 10, 15, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50 * ms_classes.keybinds.kbalpha]);
        Render.FadedCircle(x - 2 + ms_classes.keybinds.width, y + 10, 15, [cfg.visuals.inds.accent[0], cfg.visuals.inds.accent[1], cfg.visuals.inds.accent[2], 50 * ms_classes.keybinds.kbalpha]);
    }

    var sy = y + 23

    for (i = 0; i < ms_classes.keybinds.binds_list.length; i++) {
        if (UI.IsHotkeyActive.apply(null, ms_classes.keybinds.binds_list[i][1])) {
            ms_classes.keybinds.binds_list[i][3] = easing.lerp(ms_classes.keybinds.binds_list[i][3], 1, Globals.Frametime() * 12)
        } else {
            ms_classes.keybinds.binds_list[i][3] = easing.lerp(ms_classes.keybinds.binds_list[i][3], 0, Globals.Frametime() * 12)

            ms_classes.keybinds.kb.splice(i)
            ms_classes.keybinds.kbh.splice(i)
            ms_classes.keybinds.latest_item_width = 0
        }

        render_util.string_outline(x - 4 + 5, sy, 0, ms_classes.keybinds.namekb(ms_classes.keybinds.binds_list[i][0]).toUpperCase(), [255, 255, 255, (255 * ms_classes.keybinds.kbalpha) * ms_classes.keybinds.binds_list[i][3]], font);
        render_util.string_outline(x + ms_classes.keybinds.width - 3 - Render.TextSizeCustom(ms_classes.keybinds.state(ms_classes.keybinds.binds_list[i][2]), font)[0] - 6, sy, 0, ms_classes.keybinds.state(ms_classes.keybinds.binds_list[i][2]).toUpperCase(), [255, 255, 255, (255 * ms_classes.keybinds.kbalpha) * ms_classes.keybinds.binds_list[i][3]], font);
        sy += 15 * ms_classes.keybinds.binds_list[i][3]
    }

    var cursor = Input.GetCursorPosition();
    if(mouse_on_object(x, y, ms_classes.keybinds.width, 20)){
        if ((Input.IsKeyPressed(0x01)) && (ms_classes.keybinds.drag[0] == 0)) {
            ms_classes.keybinds.drag[0] = 1;
            ms_classes.keybinds.drag[1] = x - cursor[0];
            ms_classes.keybinds.drag[2] = y - cursor[1];
        }
    }
    if (!Input.IsKeyPressed(0x01)) ms_classes.keybinds.drag[0] = 0;
    if (ms_classes.keybinds.drag[0] == 1 && UI.IsMenuOpen()) {
        menu.SetValue("hotkey_x", cursor[0] + ms_classes.keybinds.drag[1]);
        menu.SetValue("hotkey_y", cursor[1] + ms_classes.keybinds.drag[2]);
    }
}
}
}

Cheat.RegisterCallback("Draw", "ms_classes.position.g_paint_handler")
Cheat.RegisterCallback("Draw", "ms_classes.keybinds.g_paint_handler")


var add_y = 0

function calc_dist(a, b) {
    x = a[0] - b[0];
    y = a[1] - b[1];
    z = a[2] - b[2];
    return Math.sqrt(x * x + y * y + z * z);
}
// from chicken aimbot
function normalize_yaw(angle) {
    angle = (angle % 360 + 360) % 360;
    return angle > 180 ? angle - 360 : angle;
}
function subtract(a,b){
    x = a[0] - b[0];
    y = a[1] - b[1];
    z = a[2] - b[2];
    var vec = [x,y,z];
    return(vec)
}
function VectorAngles(forward)
{
    var angles;
    var tmp, yaw, pitch;
   
    if (forward[1] == 0 && forward[0] == 0)
    {
        yaw = 0;
        if (forward[2] > 0)
            pitch = 270;
        else
            pitch = 90;
    }
    else
    {
        yaw = (Math.atan2(forward[1], forward[0]) * 180 / Math.PI);
        if (yaw < 0)
            yaw += 360;
        tmp = Math.sqrt (forward[0]*forward[0] + forward[1]*forward[1]);
        pitch = (Math.atan2(-forward[2], tmp) * 180 / Math.PI);
        if (pitch < 0)
            pitch += 360;
    }
   
    x = pitch;
    y = yaw;
    z = 0;
    angles = [x,y,z];
   
    return angles;
}
function can_shoot(Player){
    var index = Entity.GetWeapon(Player)
    var classid = Entity.GetClassID(index);
   
    var weapon =  classid == 107 || classid == 108 || classid == 96 || classid == 99 || classid ==112 || classid == 155 || classid == 47;//checking if the selected weapon is knife or nade
    var clip = Entity.GetProp(index, "DT_BaseCombatWeapon", "m_iClip1");
    var getbuttons = Entity.GetProp(index,'CBasePlayer', 'm_fFlags' );
    if(weapon || clip == 0 || getbuttons & 1 << 1 )//check if player is jumping or as an empty mag // UserCMD.GetButtons() & (1 << 1)
        return false;
    return true;
}
// end
// vector +
va = function(a, b){
    return [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
}
// from oof
function calculate_yaw(src, to) {
    var delta = [src[0] - to[0], src[1] - to[1]];
    var yaw = Math.atan(delta[1]/delta[0]);
    yaw = normalize_yaw(yaw * 180 / Math.PI);
    if (delta[0] >= 0)
        yaw = normalize_yaw(yaw + 180);
    return yaw;
}
var a, d, c;
// hotkey
var shot = false;

function check(){
    // enenies arr
    var e = Entity.GetEnemies();
    // filter as only dormant, alive and hittable enemies
    var d = e.filter(function(e){
        return Entity.IsDormant(e) && Entity.IsAlive(e) && Trace.Bullet(Entity.GetLocalPlayer(), e, Entity.GetEyePosition(Entity.GetLocalPlayer()), va(Entity.GetRenderOrigin(e), [0, 0, 45]))[1] > 1;
    });
    // sort hittable by damage
    var c = d.sort(function(a, b){
        return Trace.Bullet(Entity.GetLocalPlayer(), a, Entity.GetEyePosition(Entity.GetLocalPlayer()), va(Entity.GetRenderOrigin(a), [0, 0, 45]))[1] - Trace.Bullet(Entity.GetLocalPlayer(), b, Entity.GetEyePosition(Entity.GetLocalPlayer()), va(Entity.GetRenderOrigin(b), [0, 0, 45]))[1];
    })[0];
    // if no enemies return
    if(!c) {
        return;
    }
    var weapon_index = Entity.GetWeapon(Entity.GetLocalPlayer());
    var m_flNextPrimaryAttack = Entity.GetProp(weapon_index,"DT_BaseCombatWeapon","m_flNextPrimaryAttack"); //gets time until next attack
    var viewangle = VectorAngles(subtract(va(Entity.GetRenderOrigin(c), [0, 0, 45]),Entity.GetEyePosition(Entity.GetLocalPlayer())));
    if(!can_shoot(Entity.GetLocalPlayer()))//checks if you can shoot
    {
        return;
    }

    Cheat.Print("active: " + UI.IsHotkeyActive("Script Items", "dormant aimbot") + " value: " + UI.GetValue("dormant aimbot") + "\n")
    if(UI.IsHotkeyActive("Script Items", "dormant aimbot")){ // UI.GetValue("Dormant Aimbot") // ["Rage", "General", "General", "Key assignment",
        Cheat.Print("can_shoot YES\n");
        if( Globals.Curtime() - m_flNextPrimaryAttack > 0.1){
        //UserCMD.SetViewAngles(viewangle, true)
        UserCMD.SetAngles(viewangle);
        //UserCMD.SetButtons((1 << 0) | UserCMD.GetButtons())
        var getbuttons = Entity.GetProp(Entity.GetLocalPlayer(),'CBasePlayer', 'm_fFlags');
        Cheat.ExecuteCommand("+attack");
        shot = true;
   
     
        dmg = Trace.Bullet(Entity.GetLocalPlayer(), c, Entity.GetEyePosition(Entity.GetLocalPlayer()), va(Entity.GetRenderOrigin(c), [0, 0, 45]))[1];
        // log shot
        }
    }
}
function wrap() {
    try {
        check()
    } catch (e) {
    }
}
Cheat.RegisterCallback("CreateMove", "wrap");

function shoot() {
    if(shot) { // don't care who shot
        Cheat.ExecuteCommand("-attack");
        shot = false
    }
}

var lasttime = 0;
function onRender( )
{
    var tag = UI.GetValue( "Script Items", "clantag" );
    var speed = 2;
    var time = parseInt((Globals.Curtime() * speed))
    if (time != lasttime)
    {
        if(tag)
            {
            switch((time) % 33)
            {
                case 1: { Local.SetClanTag(""); break; }
                case 2: { Local.SetClanTag("a"); break; }
                case 3: { Local.SetClanTag("an"); break; }
                case 4: { Local.SetClanTag("ant"); break; }
                case 5: { Local.SetClanTag("anta"); break; }
                case 6: { Local.SetClanTag("antar"); break; }
                case 7: { Local.SetClanTag("antarc"); break; }
                case 8: { Local.SetClanTag("antarct"); break; }
				case 9: { Local.SetClanTag("antarcti"); break; }
                case 10:{ Local.SetClanTag("antarctic"); break; }
                case 11:{ Local.SetClanTag("antarctica"); break; }
                case 12:{ Local.SetClanTag("antarctica. "); break; }
                case 13:{ Local.SetClanTag("antarctica.l "); break; }
                case 14:{ Local.SetClanTag("antarctica.li "); break; }
                case 15:{ Local.SetClanTag("antarctica.liv "); break; }
				case 16:{ Local.SetClanTag("antarctica.live "); break; }
                case 17:{ Local.SetClanTag("antarctica.live"); break; }
                case 18:{ Local.SetClanTag("antarctica.liv"); break; }
                case 19:{ Local.SetClanTag("antarctica.li"); break; }
                case 20:{ Local.SetClanTag("antarctica.l"); break; }
				case 21:{ Local.SetClanTag("antarctica."); break; }
				case 22:{ Local.SetClanTag("antarctica"); break; }
                case 23:{ Local.SetClanTag("antarctica"); break; }
                case 24:{ Local.SetClanTag("antarctic"); break; }
                case 25:{ Local.SetClanTag("antarcti"); break; }
                case 26:{ Local.SetClanTag("antarct"); break; }
				case 27:{ Local.SetClanTag("antarc"); break; }
                case 28:{ Local.SetClanTag("antar"); break; }
                case 29:{ Local.SetClanTag("anta"); break; }
                case 30:{ Local.SetClanTag("ant"); break; }
                case 31:{ Local.SetClanTag("an"); break; }
                case 32:{ Local.SetClanTag("a"); break; }
                case 33:{ Local.SetClanTag(""); break; }         
            }
        }
	}
    lasttime = time;
}

var color_mod = function(perc){var r = 124*2 - 124 * perc; var g = 195 * perc; var b = 13;return [r, g, b];}
if (!String.prototype.format) {String.prototype.format = function () {var args = arguments; return this.replace(/{(\d+)}/g, function (match, number) {return typeof args[number] != 'undefined' ? args[number] : match;});};}

var master_switch = UI.AddCheckbox("slowed down")

var a_width = 0;
var penis = 0;
var sloweddown = function() {
	var me = Entity.GetLocalPlayer()
	var modifier = Entity.GetProp(me, "CCSPlayer", "m_flVelocityModifier")
	if (modifier == 1) return;
	if (Entity.IsAlive(me) && ui_get_value("Script items", "slowed down") || UI.IsMenuOpen()){

	var font = Render.AddFont("Small Fonts", 5, 400);
	var second_font = Render.AddFont("Verdana", 12, 500);

    var color = color_mod(modifier);
    var alpha = Math.abs(Globals.Curtime()*4 % 2 - 1);

    var text = ("slowed down {0}%").format(Math.floor(modifier*100));
    var text_width = 90;
    a_width = lerp(a_width, Math.floor((text_width - 2) * modifier), Globals.Frametime() * 3);

    var screen = Render.GetScreenSize()
    var x = screen[0]/2 - text_width + 37; 
	var y = screen[1]/2 - 200;

        //render_util.string_outlisafecolor(x - 16, y - 6, 0, "!", [16, 16, 16, 165], second_font)
        render_util.string_outline(x + 8, y - 10, 0, text.toUpperCase(), [255, 255, 255, 255 - a_width], font)
        render_filled_rect(x + 9, y + 4, text_width - 2, 10, [22, 22, 22, 200 - a_width])
        render_rect(x + 9, y + 4, text_width - 2, 10, [22, 22, 22, 255 - a_width])    
        render_gradient_rect(x + 10, y + 5, a_width, 8, 2, [color[0], color[1], color[2], 255 - a_width], [color[0], color[1], color[2], 0])
	}
};

Cheat.RegisterCallback("Draw", "sloweddown");

ui_add_label("            "); 
ui_add_label("> feel the <");  
ui_add_label(" antarctica ");  
ui_add_label("<    vt    >");  
ui_add_label("            "); 

Cheat.RegisterCallback("Draw", "onRender");
Cheat.RegisterCallback("weapon_fire", "shoot");
Cheat.RegisterCallback("Draw", "skeet")

Global.RegisterCallback("Draw", "keybinds");
Global.RegisterCallback("Draw", "CHE");

Global.RegisterCallback("weapon_fire", "weapon_fire");
Global.RegisterCallback("player_hurt", "player_hurt");
Global.RegisterCallback("round_prestart", "round_prestart");
Cheat.RegisterCallback("CreateMove", "fast_switch");
Global.RegisterCallback("Draw", "main");
//cheat_register_callback("CreateMove", "can_use_legit_aa")

cheat_register_callback("CreateMove", "on_draw")

cheat_register_callback('Draw', 'waterskeet')