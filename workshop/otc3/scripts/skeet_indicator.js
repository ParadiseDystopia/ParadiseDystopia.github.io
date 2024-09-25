

function render_arc(x, y, _0x42b4x6, _0x42b4x7, _0x42b4x8, _0x42b4x9, _0x42b4xa, _0x42b4xb) {
    while (360 % _0x42b4xa != 0) {
        _0x42b4xa++
    };
    _0x42b4xa = 360 / _0x42b4xa;
    for (var _0x42b4xc = _0x42b4x8; _0x42b4xc < _0x42b4x8 + _0x42b4x9; _0x42b4xc = _0x42b4xc + _0x42b4xa) {
        var _0x42b4xd = _0x42b4xc * Math['PI'] / 180;
        var _0x42b4xe = (_0x42b4xc + _0x42b4xa) * Math['PI'] / 180;
        var _0x42b4xf = Math['cos'](_0x42b4xd);
        var _0x42b4x10 = Math['sin'](_0x42b4xd);
        var _0x42b4x11 = Math['cos'](_0x42b4xe);
        var _0x42b4x12 = Math['sin'](_0x42b4xe);
        var _0x42b4x13 = x + _0x42b4xf * _0x42b4x6;
        var _0x42b4x14 = y + _0x42b4x10 * _0x42b4x6;
        var _0x42b4x15 = x + _0x42b4x11 * _0x42b4x6;
        var _0x42b4x16 = y + _0x42b4x12 * _0x42b4x6;
        var _0x42b4x17 = x + _0x42b4xf * _0x42b4x7;
        var _0x42b4x18 = y + _0x42b4x10 * _0x42b4x7;
        var _0x42b4x19 = x + _0x42b4x11 * _0x42b4x7;
        var _0x42b4x1a = y + _0x42b4x12 * _0x42b4x7;
        Render.Polygon([
            [_0x42b4x13, _0x42b4x14],
            [_0x42b4x15, _0x42b4x16],
            [_0x42b4x17, _0x42b4x18]
        ], _0x42b4xb);
        Render.Polygon([
            [_0x42b4x17, _0x42b4x18],
            [_0x42b4x15, _0x42b4x16],
            [_0x42b4x19, _0x42b4x1a]
        ], _0x42b4xb)
    }
}
Render['GradientSkeet'] = function (x, y, _0x42b4x1b, _0x42b4x1c, _0x42b4x1d, _0x42b4x1e, _0x42b4x1f) {
    Render.GradientRect(x, y, _0x42b4x1b / 4, _0x42b4x1c, _0x42b4x1d, _0x42b4x1f, _0x42b4x1e);
    Render.GradientRect(x + (_0x42b4x1b / 4), y, _0x42b4x1b / 4, _0x42b4x1c, _0x42b4x1d, _0x42b4x1e, _0x42b4x1f)
};

function calcDist(_0x42b4x21, _0x42b4x22) {
    var _0x42b4x23 = _0x42b4x21[0];
    var _0x42b4x24 = _0x42b4x21[1];
    var _0x42b4x25 = _0x42b4x21[2];
    var _0x42b4x26 = _0x42b4x22[0];
    var _0x42b4x27 = _0x42b4x22[1];
    var _0x42b4x28 = _0x42b4x22[2];
    var _0x42b4x29 = _0x42b4x23 - _0x42b4x26;
    var _0x42b4x2a = _0x42b4x24 - _0x42b4x27;
    var _0x42b4x2b = _0x42b4x25 - _0x42b4x28;
    return Math['sqrt'](_0x42b4x29 * _0x42b4x29 + _0x42b4x2a * _0x42b4x2a + _0x42b4x2b * _0x42b4x2b)
}
var x = Render.GetScreenSize()[0] / 115;
var y = Render.GetScreenSize()[1] / 1.13;

function getSite(_0x42b4x2d) {
    bombsite = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_nBombSite');
    if (bombsite == 0) {
        return 'A - '
    } else {
        return 'B - '
    }
}
function getVelocity(_0x42b4x2f) {
    players = Entity.GetPlayers();
    for (i = 0; i < players['length']; i++) {;
    }; {
        var _0x42b4x30 = Entity.GetProp(_0x42b4x2f, 'CBasePlayer', 'm_vecVelocity[0]');
        var _0x42b4x31 = Math['sqrt'](_0x42b4x30[0] * _0x42b4x30[0] + _0x42b4x30[1] * _0x42b4x30[1])
    }
    return _0x42b4x31
}
Render['Arc'] = function (x, y, _0x42b4x32, _0x42b4x33, _0x42b4x34, _0x42b4x35, _0x42b4x1e) {
    for (var _0x42b4xc = _0x42b4x34; _0x42b4xc < _0x42b4x34 + _0x42b4x35; _0x42b4xc++) {
        const _0x42b4xd = _0x42b4xc * Math['PI'] / 180;
        Render.Line(x + Math['cos'](_0x42b4xd) * _0x42b4x32, y + Math['sin'](_0x42b4xd) * _0x42b4x32, x + Math['cos'](_0x42b4xd) * _0x42b4x33, y + Math['sin'](_0x42b4xd) * _0x42b4x33, _0x42b4x1e)
    }
};
var planting = false;
var fill = 0;
var isbomb = 0;
var cur1 = Globals.Curtime();
var bombsiteonplant = '';
var on_plant_time;

function bomb_exploded() {
    isbomb = 0;
    on_plant_time = 0;
    fill = 0;
    planting = false
}
function abs2() {
    on_plant_time = Globals.Curtime();
    bombsite = Event.GetInt('site');
    if (bombsite % 2 == 1) {
        bombsiteonplant = 'Bombsite B'
    } else {
        bombsiteonplant = 'Bombsite A'
    };
    isbomb = 35;
    planting = true
}
function abs1() {
    isbomb = 0;
    on_plant_time = 0;
    fill = 0;
    planting = false
}
function abs3() {
    isbomb = 0;
    on_plant_time = 0;
    fill = 0;
    planting = false
}
function on_round_start() {
    on_plant_time = 0;
    fill = 0;
    planting = false;
    isbomb = 0
}
function bomb_planted() {
    on_plant_time = 0;
    isbomb = 70;
    fill = 0;
    planting = false
}
var bombtick = false;
var screen_size = Global.GetScreenSize();
UI.AddCheckbox('Under Crosshair');
UI.AddHotkey('Left Hotkey');
UI.AddHotkey('Right Hotkey');
UI.AddHotkey('Backwards Hotkey');
UI.AddHotkey('Forward Hotkey');
UI.AddColorPicker('Arrows color');
UI.AddColorPicker('Selected arrow color');
var pingiunas = UI.AddHotkey('Ping spike');
var isLeftActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Left Hotkey');
var isRightActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Right Hotkey');
var isBackwardsActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Backwards Hotkey');
var isForwardActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Forward Hotkey');
var isInverted;
var drawLeft = 0;
drawHideReal = 1;
var drawRight = 0,
    drawBack = 0;
var leftWasPressed = false;
var rightWasPressed = false;
var backWasPressed = false;
var upWasPressed = false;

function HSVtoRGB(_0x42b4x1c, _0x42b4x34, _0x42b4x52) {
    var _0x42b4x53, _0x42b4x54, _0x42b4x55, _0x42b4xc, _0x42b4x56, _0x42b4x57, _0x42b4x58, _0x42b4x59;
    _0x42b4xc = Math['floor'](_0x42b4x1c * 6);
    _0x42b4x56 = _0x42b4x1c * 6 - _0x42b4xc;
    _0x42b4x57 = _0x42b4x52 * (1 - _0x42b4x34);
    _0x42b4x58 = _0x42b4x52 * (1 - _0x42b4x56 * _0x42b4x34);
    _0x42b4x59 = _0x42b4x52 * (1 - (1 - _0x42b4x56) * _0x42b4x34);
    switch (_0x42b4xc % 4) {
    case 0:
        _0x42b4x53 = _0x42b4x52,
        _0x42b4x54 = _0x42b4x59,
        _0x42b4x55 = _0x42b4x57;
        break;
    case 1:
        _0x42b4x53 = _0x42b4x58,
        _0x42b4x54 = _0x42b4x52,
        _0x42b4x55 = _0x42b4x57;
        break;
    case 2:
        _0x42b4x53 = _0x42b4x57,
        _0x42b4x54 = _0x42b4x52,
        _0x42b4x55 = _0x42b4x59;
        break;
    case 3:
        _0x42b4x53 = _0x42b4x57,
        _0x42b4x54 = _0x42b4x58,
        _0x42b4x55 = _0x42b4x52;
        break;
    case 4:
        _0x42b4x53 = _0x42b4x59,
        _0x42b4x54 = _0x42b4x57,
        _0x42b4x55 = _0x42b4x52;
        break;
    case 5:
        _0x42b4x53 = _0x42b4x52,
        _0x42b4x54 = _0x42b4x57,
        _0x42b4x55 = _0x42b4x58;
        break
    };
    return {
        r: Math['round'](_0x42b4x53 * 255),
        g: Math['round'](_0x42b4x54 * 255),
        b: Math['round'](_0x42b4x55 * 255)
    }
}
var screen_size = Global.GetScreenSize();
var other_weapons = ['knife', 'knife_t', 'knife_karambit', 'knife_m9_bayonet', 'knife_survival_bowie', 'knife_butterfly', 'knife_flip', 'knife_push', 'knife_tactical', 'knife_falchion', 'knife_gut', 'knife_ursus', 'knife_gypsy_jackknife', 'knife_stiletto', 'knife_widowmaker', 'knife_css', 'knife_cord', 'knife_canis', 'knife_outdoor', 'knife_skeleton', 'bayonet', 'hegrenade', 'smokegrenade', 'molotov', 'incgrenade', 'flashbang', 'decoy', 'taser'];

function is_gun(_0x42b4x5c) {
    for (var _0x42b4xc = 0; _0x42b4xc < other_weapons['length']; _0x42b4xc++) {
        if (_0x42b4x5c == 'weapon_' + other_weapons[_0x42b4xc]) {
            return false
        }
    };
    return true
}
function drawString() {
    arrows_color = UI.GetColor('Misc', 'JAVASCRIPT', 'Script items', 'Arrows color');
    s_arrows_color = UI.GetColor('Misc', 'JAVASCRIPT', 'Script items', 'Selected arrow color');
    crack_font = Render.AddFont('Verdana', 8, 100);
    arrows_red = arrows_color[0];
    arrows_green = arrows_color[1];
    arrows_blue = arrows_color[2];
    arrows_alpha = arrows_color[3];
    selected_red = s_arrows_color[0];
    selected_green = s_arrows_color[1];
    selected_blue = s_arrows_color[2];
    selected_alpha = Math['sin'](Math['abs'](-Math['PI'] + (Globals.Curtime() * (1 / 0.75)) % (Math['PI'] * 2))) * 255;
    isInverted = UI.IsHotkeyActive('Anti-Aim', 'Inverter');
    fonts = Render.AddFont('Arrows', 49, 400);
    font1 = Render.AddFont('Verdana', 10, 100);
    localplayer_index = Entity.GetLocalPlayer();
    localplayer_alive = Entity.IsAlive(localplayer_index);
    g_Local = Entity.GetLocalPlayer();
    g_Local_weapon = Entity.GetWeapon(g_Local);
    weapon_name = Entity.GetName(g_Local_weapon);
    g_Local_classname = Entity.GetClassName(g_Local_weapon);
    isFD = UI.IsHotkeyActive('Anti-Aim', 'Extra', 'Fake duck');
    isDoubletap = UI.IsHotkeyActive('Rage', 'Exploits', 'Doubletap');
    DT = 'DT ';
    add_y = 0;
    if (localplayer_alive == true) {
        if (!UI.GetValue('Script items', 'Under Crosshair')) {
            return
        };
        if ((g_Local_classname == 'CKnife' || g_Local_classname == 'CWeaponSSG08' || g_Local_classname == 'CWeaponAWP' || weapon_name == 'r8 revolver' || g_Local_classname == 'CHEGrenade' || g_Local_classname == 'CMolotovGrenade' || g_Local_classname == 'CIncendiaryGrenade' || g_Local_classname == 'CFlashbang' || g_Local_classname == 'CSmokeGrenade' || g_Local_classname == 'CDecoyGrenade' || g_Local_classname == 'CWeaponTaser' || g_Local_classname == 'CC4')) {
            if (isFD) {
                DT = DT + '(fakeduck)'
            } else {
                DT = DT + '(active weapon)'
            };
            is_DT = false
        } else {
            DT = isFD ? 'DT (fakeduck)' : 'DT ';
            is_DT = !isFD & isDoubletap
        };
        delta = (Exploit.GetCharge() * 60);
        UI.SetValue('Rage', 'Exploits', 'Doubletap', is_DT);
        var _0x42b4x5e;
        if (isDoubletap) {
            _0x42b4x5e = 12;
            if (is_DT) {
                Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 26 : Render.GetScreenSize()[1] / 2 + 14, 0, DT, Exploit.GetCharge() == 1 ? [0, 0, 0, 255] : [0, 0, 0, selected_alpha], crack_font);
                Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 25 : Render.GetScreenSize()[1] / 2 + 13, 0, DT, Exploit.GetCharge() == 1 ? [0, 255, 0, 255] : [255, 0, 0, selected_alpha], crack_font)
            } else {
                Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 26 : Render.GetScreenSize()[1] / 2 + 14, 0, DT, [0, 0, 0, selected_alpha], crack_font);
                Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 25 : Render.GetScreenSize()[1] / 2 + 13, 0, DT, [255, 0, 0, selected_alpha], crack_font)
            }
        } else {
            _0x42b4x5e = 0
        };
        if (drawHideReal) {
            Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, Render.GetScreenSize()[1] / 2 + 14, 0, 'DYNAMIC', [0, 0, 0, 255], crack_font);
            Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, Render.GetScreenSize()[1] / 2 + 13, 0, 'DYNAMIC', [135, 147, 255, 255], crack_font)
        };
        if (is_gun(weapon_name)) {
            Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 26 + _0x42b4x5e : Render.GetScreenSize()[1] / 2 + 14 + _0x42b4x5e, 0, 'PREDICTION', [0, 0, 0, 255], crack_font);
            Render.StringCustom(Render.GetScreenSize()[0] / 2 - 23, drawHideReal ? Render.GetScreenSize()[1] / 2 + 25 + _0x42b4x5e : Render.GetScreenSize()[1] / 2 + 13 + _0x42b4x5e, 0, 'PREDICTION', [132, 0, 255, 255], crack_font)
        };
        Render.StringCustom(screen_size[0] / 2 - 40, screen_size[1] / 2 - 15 + 1, 1, '<', [0, 0, 0, arrows_alpha], Render.AddFont('Verdana', 15, 900));
        Render.StringCustom(screen_size[0] / 2 + 45, screen_size[1] / 2 - 15 + 1, 1, '>', [0, 0, 0, arrows_alpha], Render.AddFont('Verdana', 15, 900));
        Render.StringCustom(screen_size[0] / 2 - 40, screen_size[1] / 2 - 15, 1, '<', arrows_color, Render.AddFont('Verdana', 15, 900));
        Render.StringCustom(screen_size[0] / 2 + 45, screen_size[1] / 2 - 15, 1, '>', arrows_color, Render.AddFont('Verdana', 15, 900));
        Render.StringCustom(screen_size[0] / 2 - 40, screen_size[1] / 2 - 15, 1, '<', drawLeft ? [selected_red, selected_green, selected_blue, 255] : arrows_color, Render.AddFont('Verdana', 15, 900));
        Render.StringCustom(screen_size[0] / 2 + 45, screen_size[1] / 2 - 15, 1, '>', drawRight ? [selected_red, selected_green, selected_blue, 255] : arrows_color, Render.AddFont('Verdana', 15, 900))
    }
}
var Inair = function () {
    if (Entity.GetProp(Entity.GetLocalPlayer(), 'CBasePlayer', 'm_hGroundEntity')) {
        return true
    } else {
        return false
    }
};

function weapon_fire1() {
    shotsfired++
}
var misses = 0;
var shotsfired = 0;
var shotshurt = 0;

function player_hurt() {
    if (Entity.GetEntityFromUserID(Event.GetInt('attacker')) == Entity.GetLocalPlayer()) {
        shotshurt++
    }
}
Global.RegisterCallback('ragebot_fire', 'weapon_fire1');
Cheat.RegisterCallback('player_hurt', 'player_hurt');

function drawindicators() {
    lp = Entity.GetLocalPlayer();
    velocity = Math['round'](getVelocity(lp)).toString();
    var _0x42b4x66, _0x42b4x67, _0x42b4x68, _0x42b4x69, _0x42b4x6a, _0x42b4x6b, _0x42b4x6c;
    font = Render.AddFont('Calibri', 18, 900);
    var _0x42b4x6c = Render.AddFont('Tahoma', 10, 100);
    fake = Math['abs'](Local.GetFakeYaw());
    real = Math['abs'](Local.GetRealYaw());
    if (fake > real) {
        delta = (fake - real) / 2
    } else {
        delta = (real - fake) / 2
    };
    if (drawHideReal) {
        _0x42b4x68 = 35
    } else {
        _0x42b4x68 = 0
    };
    if (UI.IsHotkeyActive('Script items', 'override damage key')) {
        _0x42b4x67 = 35
    } else {
        _0x42b4x67 = 0
    };
    if (UI.IsHotkeyActive('Rage', 'Exploits', 'Doubletap')) {
        _0x42b4x69 = 35
    } else {
        _0x42b4x69 = 0
    };
    if (Inair() & velocity > 250) {
        _0x42b4x6b = 35
    } else {
        _0x42b4x6b = 0
    };
    if (UI.IsHotkeyActive('Rage', 'General', 'Force safe point')) {
        _0x42b4x66 = 35
    } else {
        _0x42b4x66 = 0
    };
    if (UI.IsHotkeyActive('Rage', 'Exploits', 'Hide shots')) {
        _0x42b4x6a = 35
    } else {
        _0x42b4x6a = 0
    };
	if (UI.IsHotkeyActive('Misc', 'General', 'Auto peek')) {
		_0x42b4x6c = 35
	} else {
		_0x42b4x6c = 0
	};
    if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        if (UI.IsHotkeyActive('Rage', 'Exploits', 'Doubletap')) {
            Render.GradientSkeet(7, y - 350 + 70 - _0x42b4x66 - _0x42b4x6b - isbomb, 50, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 70 - _0x42b4x66 - _0x42b4x6b - isbomb, 0, 'DT', [17, 17, 17, 255], font);
            if (Exploit.GetCharge() == 1) {
                Render.StringCustom(x, y - 350 + 70 - _0x42b4x66 - _0x42b4x6b - isbomb, 0, 'DT', [255, 255, 255, 255], font)
            } else {
                Render.StringCustom(x, y - 350 + 70 - _0x42b4x66 - _0x42b4x6b - isbomb, 0, 'DT', [255, 0, 0, 255], font)
            }
        };
        if (UI.IsHotkeyActive('Anti-Aim', 'Extra', 'Fake duck')) {
            Render.GradientSkeet(7, y - 350 + 70 - _0x42b4x66 - _0x42b4x69 - _0x42b4x6b - isbomb, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 70 - _0x42b4x66 - _0x42b4x69 - _0x42b4x6b - isbomb, 0, 'DUCK', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 70 - _0x42b4x66 - _0x42b4x69 - _0x42b4x6b - isbomb, 0, 'DUCK', [255, 255, 255, 255], font)
        };
        if (UI.IsHotkeyActive('Rage', 'General', 'Force safe point')) {
            Render.GradientSkeet(7, y - 350 + 70 - _0x42b4x6b, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 70 - _0x42b4x6b, 0, 'SAFE', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 70 - _0x42b4x6b, 0, 'SAFE', [132, 195, 16, 255], font)
        };
        if (velocity > 295) {
            color1 = 132;
            color2 = 195;
            color3 = 16
        } else {
            color1 = 255;
            color2 = 0;
            color3 = 0
        };
        if (Inair() & velocity > 250) {
            Render.GradientSkeet(7, y - 350 + 70, 50, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 70, 0, 'LC', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 70, 0, 'LC', [color1, color2, color3, 255], font)
        };
        if (UI.IsHotkeyActive('Script items', 'override damage key')) {
            Render.GradientSkeet(7, y - 350 + 105 + _0x42b4x6a, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 105 + _0x42b4x6a, 0, 'DMG', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 105 + _0x42b4x6a, 0, 'DMG', [255, 255, 255, 255], font)
        };
        if (drawHideReal) {
            Render.GradientSkeet(7, y - 350 + 105 + _0x42b4x6a + _0x42b4x67, 50, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 105 + _0x42b4x6a + _0x42b4x67, 0, 'DA', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 105 + _0x42b4x6a + _0x42b4x67, 0, 'DA', [132, 195, 16, 255], font)
        };
        if (UI.IsHotkeyActive('Rage', 'Exploits', 'Hide shots')) {
            Render.GradientSkeet(7, y - 350 + 105, 170, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 105, 0, 'ONSHOT', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 105, 0, 'ONSHOT', [132, 195, 16, 255], font)
        };
        if (UI.IsHotkeyActive('Misc', 'General', 'Auto peek')) {
            Render.GradientSkeet(7, y - 350 + 105 + _0x42b4x6a + _0x42b4x67 + _0x42b4x68, 75, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y + 1 - 350 + 105 + _0x42b4x6a + _0x42b4x67 + _0x42b4x68, 0, 'PEEK', [17, 17, 17, 255], font);
            Render.StringCustom(x, y - 350 + 105 + _0x42b4x6a + _0x42b4x67 + _0x42b4x68, 0, 'PEEK', [255, 255, 255, 255], font)
        };
    };
    fill = 3.3 - (3.3 + on_plant_time - Globals.Curtime());
    if (fill > 3.3) {
        fill = 3.3
    };
    if (planting) {
        Render.GradientSkeet(7, y - 350 + 70 + 1 - _0x42b4x66 - _0x42b4x6b, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
        Render.StringCustom(x, y + 1 - 350 + 70 - _0x42b4x66 - _0x42b4x6b, 0, bombsiteonplant, [0, 0, 0, 255], font);
        Render.StringCustom(x, y - 350 + 70 - _0x42b4x66 - _0x42b4x6b, 0, bombsiteonplant, [210, 216, 112, 255], font);
        Render.Arc(x + 135, y - 350 + 85 - _0x42b4x66 - _0x42b4x6b, 11, 7, 0, 360, [17, 17, 17, 255]);
        Render.Arc(x + 135, y - 350 + 85 - _0x42b4x66 - _0x42b4x6b, 10, 8, 0, (fill / 3.3) * 360, [255, 255, 255, 255])
    };
    local = Entity.GetLocalPlayer();
    var _0x42b4x2d = Entity.GetEntitiesByClassID(128)[0];
    if (_0x42b4x2d == undefined) {
        return
    };
    var _0x42b4x6d = Entity.GetRenderOrigin(_0x42b4x2d);
    var _0x42b4x6e;
    _0x42b4x6e = Entity.GetRenderOrigin(local);
    var _0x42b4x6f = calcDist(_0x42b4x6d, _0x42b4x6e);
    var _0x42b4x70 = false;
    var _0x42b4x71;
    var _0x42b4x72 = Entity.GetProp(local, 'CCSPlayerResource', 'm_iArmor');
    var _0x42b4x73 = Entity.GetProp(local, 'CBasePlayer', 'm_iHealth');
    var _0x42b4x74 = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_bBombTicking');
    var _0x42b4x75 = (Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_flC4Blow') - Globals.Curtime());
    var _0x42b4x76 = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_flTimerLength');
    var _0x42b4x77 = (((Render.GetScreenSize()[1] - 50) / _0x42b4x76) * (_0x42b4x75));
    var _0x42b4x78 = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_flDefuseLength');
    var _0x42b4x79 = (Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_flDefuseCountDown') - Globals.Curtime());
    var _0x42b4x7a = (((Render.GetScreenSize()[1] - 50) / _0x42b4x78) * (_0x42b4x79));
    var _0x42b4x7b = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_hBombDefuser');
    var _0x42b4x7c = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_bBombDefused');
    const _0x42b4x7d = 450.7;
    const _0x42b4x55 = 75.68;
    const _0x42b4x7e = 789.2;
    const _0x42b4x35 = (_0x42b4x6f - _0x42b4x55) / _0x42b4x7e;
    var _0x42b4x7f = _0x42b4x7d * Math['exp'](-_0x42b4x35 * _0x42b4x35);
    if (_0x42b4x72 > 0) {
        var _0x42b4x80 = _0x42b4x7f * 0.5;
        var _0x42b4x81 = (_0x42b4x7f - _0x42b4x80) * 0.5;
        if (_0x42b4x81 > _0x42b4x72) {
            _0x42b4x72 = _0x42b4x72 * (1 / 0.5);
            _0x42b4x80 = _0x42b4x7f - _0x42b4x81
        };
        _0x42b4x7f = _0x42b4x80
    };
    _0x42b4x71 = Math['ceil'](_0x42b4x7f);
    if (_0x42b4x71 >= _0x42b4x73) {
        _0x42b4x70 = true
    } else {
        _0x42b4x70 = false
    };
    _0x42b4x75 = parseFloat(_0x42b4x75['toPrecision'](3));
    timer2 = parseFloat(_0x42b4x75['toPrecision'](2));
    timer3 = parseFloat(_0x42b4x75['toPrecision'](1));
    if (!_0x42b4x74) {
        return
    };
    if (_0x42b4x7c) {
        return
    };
    if (_0x42b4x75 >= 1) {
        Render.GradientSkeet(7, y - 350 + 70 + 1 - _0x42b4x66 - _0x42b4x6b, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
        Render.StringCustom(x, y - 350 + 70 + 1 - _0x42b4x66 - _0x42b4x6b, 0, getSite(_0x42b4x2d) + _0x42b4x75['toFixed'](1) + 's', [0, 0, 0, 255], font);
        Render.StringCustom(x, y - 350 + 70 - _0x42b4x66 - _0x42b4x6b, 0, getSite(_0x42b4x2d) + _0x42b4x75['toFixed'](1) + 's', [255, 255, 255, 255], font)
    };
    if (_0x42b4x7b > 0) {
        if (_0x42b4x75 > _0x42b4x78 && _0x42b4x75 >= 0.1) {
            Render.FilledRect(0, 0, 10, 1080, [25, 25, 25, 120]);
            Render.FilledRect(0, 1080 - _0x42b4x7a, 10, 1080, [58, 191, 54, 120]);
            Render.Rect(0, 0, 10, 1080, [25, 25, 25, 120])
        } else {
            Render.FilledRect(0, 0, 10, 1080, [25, 25, 25, 120]);
            Render.FilledRect(0, 1080 - _0x42b4x7a, 10, 1080, [252, 18, 19, 120]);
            Render.Rect(0, 0, 10, 1080, [25, 25, 25, 120])
        }
    };
    if (_0x42b4x70) {
        Render.GradientSkeet(7, y - 315 + 1 - _0x42b4x66 - _0x42b4x6b, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
        Render.StringCustom(x, y - 315 + 1 - _0x42b4x66 - _0x42b4x6b, 0, 'FATAL', [0, 0, 0, 255], font);
        Render.StringCustom(x, y - 315 - _0x42b4x66 - _0x42b4x6b, 0, 'FATAL', [255, 0, 0, 255], font)
    } else {
        if (_0x42b4x7f > 0.5) {
            Render.GradientSkeet(7, y - 315 + 1 - _0x42b4x66 - _0x42b4x6b, 100, 30, 1, [0, 0, 0, 55], [0, 0, 0, 0]);
            Render.StringCustom(x, y - 315 + 1 - _0x42b4x66 - _0x42b4x6b, 0, '-' + _0x42b4x71 + 'HP', [0, 0, 0, 255], font);
            Render.StringCustom(x, y - 315 - _0x42b4x66 - _0x42b4x6b, 0, '-' + _0x42b4x71 + 'HP', [210, 216, 112, 255], font)
        }
    }
}
var oldTick = 0;
var lastPressed = 0;
var isHideRealActive = false;

function onCreateMove() {
    if (UI.IsHotkeyActive('Script items', 'Ping spike')) {
        UI.SetValue('Misc', 'GENERAL', 'Miscellaneous', 'Extended backtracking', 1)
    } else {
        UI.SetValue('Misc', 'GENERAL', 'Miscellaneous', 'Extended backtracking', 0)
    };
    misses = shotsfired - shotshurt;
    isLeftActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Left Hotkey');
    isRightActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Right Hotkey');
    isBackwardsActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Backwards Hotkey');
    isForwardActive = UI.IsHotkeyActive('Misc', 'JAVASCRIPT', 'Script items', 'Forward Hotkey');
    if (isLeftActive && leftWasPressed == false) {
        lastPressed = Global.Tickcount();
        isHideRealActive = false;
        leftWasPressed = true;
        backWasPressed = false;
        rightWasPressed = false;
        upWasPressed = false;
        drawLeft = 1;
        drawBack = 0;
        drawRight = 0;
        drawHideReal = 0;
        UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', -90);
        UI.SetValue('Anti-Aim', 'Fake angles', 'Hide real angle', false)
    } else {
        if (isLeftActive && leftWasPressed == true && Global.Tickcount() > lastPressed + 16) {
            isHideRealActive = true;
            oldTick = Global.Tickcount();
            drawHideReal = 1
        }
    };
    if (isRightActive && rightWasPressed == false) {
        lastPressed = Global.Tickcount();
        isHideRealActive = false;
        backWasPressed = false;
        leftWasPressed = false;
        rightWasPressed = true;
        upWasPressed = false;
        drawLeft = 0;
        drawBack = 0;
        drawRight = 1;
        drawHideReal = 0;
        UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', 90);
        UI.SetValue('Anti-Aim', 'Fake angles', 'Hide real angle', false)
    } else {
        if (isRightActive && rightWasPressed == true && Global.Tickcount() > lastPressed + 16) {
            isHideRealActive = true;
            oldTick = Global.Tickcount();
            drawHideReal = 1
        }
    };
    if (isBackwardsActive && backWasPressed == false && Global.Tickcount() > lastPressed + 16) {
        lastPressed = Global.Tickcount();
        isHideRealActive = false;
        backWasPressed = true;
        rightWasPressed = false;
        leftWasPressed = false;
        upWasPressed = false;
        drawLeft = 0;
        drawHideReal = 0;
        drawBack = 1;
        drawRight = 0;
        UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', 0);
        UI.SetValue('Anti-Aim', 'Fake angles', 'Hide real angle', false)
    } else {
        if (isBackwardsActive && backWasPressed == true && Global.Tickcount() > lastPressed + 16) {
            isHideRealActive = true;
            oldTick = Global.Tickcount();
            drawHideReal = 1
        }
    };
    if (isForwardActive && upWasPressed == false && Global.Tickcount() > lastPressed + 16) {
        lastPressed = Global.Tickcount();
        isHideRealActive = false;
        backWasPressed = false;
        rightWasPressed = false;
        drawHideReal = 0;
        leftWasPressed = false;
        upWasPressed = true;
        drawLeft = 0;
        drawBack = 0;
        drawRight = 0;
        UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', 180);
        UI.SetValue('Anti-Aim', 'Fake angles', 'Hide real angle', false)
    };
    if (isHideRealActive) {
        if (Global.Tickcount() > oldTick + 16) {
            backWasPressed = false;
            rightWasPressed = false;
            leftWasPressed = false;
            upWasPressed = false;
            oldTick = Global.Tickcount();
            drawHideReal = 1
        };
        drawLeft = 0;
        drawBack = 0;
        drawRight = 0;
        UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', 0);
        UI.SetValue('Anti-Aim', 'Fake angles', 'Hide real angle', true)
    };
}
function player_connect() {
    lastPressed = Global.Tickcount();
    oldTick = Global.Tickcount();
    on_plant_time = 0;
    fill = 0;
    planting = false;
    var _0x42b4x2d = Entity.GetEntitiesByClassID(128)[0];
    if (_0x42b4x2d == undefined) {
        return
    };
    var _0x42b4x74 = Entity.GetProp(_0x42b4x2d, 'CPlantedC4', 'm_bBombTicking');
    if (_0x42b4x74) {
        isbomb = 70
    } else {
        isbomb = 0
    }
}
Global.RegisterCallback('Draw', 'drawString');
Global.RegisterCallback('CreateMove', 'onCreateMove');
Global.RegisterCallback('player_connect_full', 'player_connect');
Global.RegisterCallback('Draw', 'drawindicators');
Cheat.RegisterCallback('bomb_beginplant', 'abs2');
Cheat.RegisterCallback('bomb_abortplant', 'abs1');
Cheat.RegisterCallback('bomb_defused', 'abs3');
Cheat.RegisterCallback('round_start', 'on_round_start');
Cheat.RegisterCallback('bomb_planted', 'bomb_planted');
Cheat.RegisterCallback('bomb_exploded', 'bomb_exploded')