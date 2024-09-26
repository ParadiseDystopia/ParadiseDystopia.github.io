Cheat.PrintColor([173, 209, 15, 255],"                                          " + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                          " + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                          " + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                          " + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                                                       Dr"); Cheat.PrintColor([255, 255, 255, 255],"a"); Cheat.PrintColor([173, 209, 15, 255],"in"); Cheat.PrintColor([255, 255, 255, 255],".js" + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                                       Welcome back, " + Cheat.GetUsername() + "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                                           Latest Script Version: 05.09.21"+ "\n");
Cheat.PrintColor([173, 209, 15, 255],"                                          " + "\n");

function tab() {
    var menusetup = UI.GetValue("   Drain.js | Select Tab"), rm = UI.GetValue("Rage & AA menu"), vm = UI.GetValue("Visual menu"), mm = UI.GetValue("Misc menu");

    rage = (menusetup == 0 && rm == 0); antiaim = (menusetup == 0 && rm == 1);
    visual = (menusetup == 1 && vm == 0); colors = (menusetup == 1 && vm == 1); changers = (menusetup == 1 && vm == 2);
    helpers = (menusetup == 2 && mm == 0); hotkeys = (menusetup == 2 && mm == 1); other = (menusetup == 2 && mm == 2);

    const mindmgs = UI.GetValue("Minimum damage");
	const hitairc = UI.GetValue("R8 & Scout HC in Air");
    const legitaa = UI.GetValue("Legit AA");
    const indscrn = UI.GetValue("Indicators on screen");
    const indstyle = UI.GetValue("Indicators line style");
    const safecond = UI.GetValue("Safe-points Conditions")
    const safe = UI.GetValue("Select Conditions");
    const CustomAA = UI.GetValue("Custom Anti-Aims");

    // Rage & AA
    UI.SetEnabled("Rage & AA menu", menusetup == 0);
    UI.SetEnabled("Safe-points on weapon", rage && safecond == true && safe << -1)
    UI.SetEnabled("Minimum damage", rage);
    UI.SetEnabled("Safe-points Conditions", rage);
    UI.SetEnabled("Select Conditions", rage && safecond)
    UI.SetEnabled("R8 & Scout HC in Air", rage);
    UI.SetEnabled("R8 hitchance", rage && hitairc == true);
	UI.SetEnabled("Scout hitchance", rage && hitairc == true);
    UI.SetEnabled("Minimum damage value", rage && mindmgs == true);
    UI.SetEnabled("Freestanding on DT Peek", antiaim);
    UI.SetEnabled("Pitch 0 on land", antiaim);
    UI.SetEnabled("Switch desync on shot", antiaim);
    UI.SetEnabled("Legit AA", antiaim);
    UI.SetEnabled("Custom Anti-Aims", antiaim);
    UI.SetEnabled("Randomize Jitter", antiaim && CustomAA == true);
    UI.SetEnabled("Randomize Fake-lags", antiaim && CustomAA == true);

    UI.SetEnabled("Randomize Fake-Lag", antiaim && CustomAA == true);
    UI.SetEnabled("Stable Auto-Inverter", antiaim && CustomAA == true);
    // Visual
    UI.SetEnabled("Visual menu", menusetup == 1);
    UI.SetEnabled("Indicators on screen", visual);
    UI.SetEnabled("Indicators line style", visual && indscrn);
    UI.SetEnabled("Main color", colors);
    UI.SetEnabled("Background color", colors && indscrn << 0);
    UI.SetEnabled("Color line", colors && indscrn && indstyle << 0 && indstyle << 1 && indstyle << 2);
    UI.SetEnabled("Font weight", changers && indscrn << 1);
    UI.SetEnabled("Line weight", changers && indscrn << 1);
    UI.SetEnabled("Indicators", visual && indscrn >> 2);
    UI.SetEnabled("Custom Username in Watermark", changers && indscrn >> 1);
    //Misc
    UI.SetEnabled("Misc menu", menusetup == 2);
	UI.SetEnabled("Autostrafe Improves", helpers);
    UI.SetEnabled("Minimum damage key", hotkeys && mindmgs == true);
    UI.SetEnabled("Legit AA key", hotkeys && legitaa == true);
    UI.SetEnabled("Console filter", helpers);
    //Disable
    UI.SetEnabled("Hotkeys_x", false);
    UI.SetEnabled("Hotkeys_y", false);
}
Cheat.RegisterCallback("Draw", "tab")

UI.AddDropdown("   Drain.js | Select Tab", ["Rage & AA", "Visual", "Misc"]);
// Rage & AA
UI.AddDropdown("Rage & AA menu", ["Rage", "Anti-Aim"]);
UI.AddCheckbox("Safe-points Conditions");
UI.AddMultiDropdown("Select Conditions", ["If Weapon"]);
UI.AddMultiDropdown("Safe-points on weapon", ["AWP", "Auto-snipers", "R8-Deagle", "Pistols", "SSG08"])
UI.AddCheckbox("Minimum damage");
UI.AddCheckbox("R8 & Scout HC in Air");
UI.AddSliderInt("R8 hitchance", 1, 100);
UI.AddSliderInt("Scout hitchance", 1, 100);
UI.AddSliderInt("Minimum damage value", 0, 110);
UI.AddCheckbox("Custom Anti-Aims");
UI.AddCheckbox("Randomize Jitter");
UI.AddCheckbox("Randomize Fake-lags");
UI.AddCheckbox("Stable Auto-Inverter");
UI.AddCheckbox("Freestanding on DT Peek");
UI.AddCheckbox("Switch desync on shot");
UI.AddCheckbox("Legit AA");
// Visual
UI.AddDropdown("Visual menu", ["Main", "Colors", "Settings"]);
UI.AddMultiDropdown("Indicators on screen", ["Keybindings", "Watermark", "Indicators"])
UI.AddDropdown("Indicators", ["None", "Drain.js", "Acatel", "Ideal Yaw", "Ethernal[NL]", "Teamskeet[NL]"])
UI.AddDropdown("Indicators line style", ["Solid", "Fade", "Reversed Fade", "Gradient", "Chroma"])
UI.AddSliderInt("Line weight", 0, 4);
UI.AddSliderInt("Font weight", 400, 600);
UI.AddColorPicker("Main color");
UI.AddTextbox("Custom Username in Watermark");
// Misc
UI.AddDropdown("Misc menu", ["Main", "Settings"]);
UI.AddCheckbox("Console filter")
UI.AddHotkey("Minimum damage key");
UI.AddHotkey("Legit AA key");
// Sets
UI.SetValue("Line weight", 1)
UI.SetValue("Font weight", 500)
var screen = Global.GetScreenSize();
var localplayer = Entity.GetLocalPlayer();
var shottimer = Global.Curtime();
var WeaponFire = false;
var time, delay, shotsfired;
var not_spam = { confilter: 0 };
var original_aa = true;

Render.Shadow = function(x, y, int, text, outline_color, font) {
    Render.StringCustom(x + 1, y + 1, int, text, outline_color, font);

    Render.StringCustom(x, y + 1, int, text, outline_color, font);

    Render.StringCustom(x + 1, y, int, text, outline_color, font);
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

 function RandomLimit(Min, Max) {
    Min = Math.ceil(Min);
    Max = Math.floor(Max);
    return Math.floor(Math.random() * (Min + Max - 1, 17))
}

function RandomJitter(Min, Max) {
    Min = Math.ceil(Min);
    Max = Math.floor(Max);
    return Math.floor(Math.random() * (Min + Max - 6, 27))
}

 const IsInAir = function(){
    if (Global.IsKeyPressed((0x20))){
   return true;
} else {
   return false;
  }
}

const IsDormant = function() {
    enemies = Entity.GetEnemies()
    for(var i in enemies)
        if(Entity.IsDormant(enemies[i])) {
            return true
        }
    return false
}

const IsCtrl = function(){
    if (Global.IsKeyPressed((0x11))){
   return true;
} else {
   return false;
   }
}

const getVelocity = function(index) {
	players = Entity.GetPlayers();
	for(i = 0; i < players.length; i++); {
		var velocity = Entity.GetProp(index, "CBasePlayer", "m_vecVelocity[0]");
		var speed = Math.sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]);
	}
	return speed;
}

function Clamp(v, min, max) {
    return Math.max(Math.min(v, max), min);
}

function in_bounds(vec, x, y, x2, y2) {
    return (vec[0] > x) && (vec[1] > y) && (vec[0] < x2) && (vec[1] < y2)
}

function getDropdownValue(value, index) {
	var mask = 1 << index;
	return value & mask ? true : false;
}

function HSVtoRGB(h, s, v) {

    var r, g, b, i, f, p, q, t;
    i = Math.floor(h * 6); f = h * 6 - i; p = v * (1 - s);
    q = v * (1 - f * s); t = v * (1 - (1 - f) * s);

    switch (i % 6) {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;

        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;

        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break; 

    } return {  
        r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255) 
    };
    }


const RandomFakeLag = function() {
    if(UI.GetValue("Script items", "Randomize Fake-lags")) {

    UI.SetValue("Anti-Aim", "Fake-Lag", "Limit", (RandomLimit(1, 17)));

    UI.SetValue("Anti-Aim", "Fake-Lag", "Jitter", (RandomJitter(1, 102)));

    UI.SetValue("Anti-Aim", "Fake-Lag", "Trigger limit", (RandomTriggerlimit(1, 11)));
    }
  }
Cheat.RegisterCallback("Draw", "RandomFakeLag")

const RandomJitters = function() {
    if(UI.GetValue("Script items", "Randomize Jitter")) {

    UI.SetValue("Rage Anti-Aim", "Jitter offset", (RandomJitter(6, 27)));
    }
  }
Cheat.RegisterCallback("Draw", "RandomJitters")

function xhz() {
    iShotsFired = Event.GetInt("userid"); iShotsFired_index = Entity.GetEntityFromUserID(iShotsFired);
    
    if(Entity.GetLocalPlayer() == iShotsFired_index) {
        if(shotsfired == 0)
        {   
            time = Globals.Curtime();
            delay = time+9;           
        }       
    }       
}

const AutoInverter = function() {
    if(UI.GetValue("Stable Auto-Inverter") == true) {
    curtime = Globals.Curtime();
    
    if (curtime <= delay) {   
        shotsfired = 1;
        UI.ToggleHotkey("Anti-Aim", "Fake angles", "Inverter");
    } else {
        UI.ToggleHotkey("Anti-Aim", "Fake angles", "Inverter");
        shotsfired = 0;
    }   
  }
 }
Cheat.RegisterCallback("weapon_fire", "xhz");
Cheat.RegisterCallback("Draw", "AutoInverter");

const safepointsconditions = function() {
    const getvalue = UI.GetValue("Safe-points Conditions");
    const safe = UI.GetValue("Select Conditions");
    const safeweapon = UI.GetValue("Safe-points on weapon");
    var weapon_name = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
    if(getvalue == true && safe << 0) {
        if (safeweapon >> 0 && weapon_name == "awp") {
            Ragebot.ForceHitboxSafety(0)
            Ragebot.ForceHitboxSafety(2)
            Ragebot.ForceHitboxSafety(3)
            Ragebot.ForceHitboxSafety(4)
            Ragebot.ForceHitboxSafety(5)
            Ragebot.ForceHitboxSafety(6)
            Ragebot.ForceHitboxSafety(7)
            Ragebot.ForceHitboxSafety(8)
            Ragebot.ForceHitboxSafety(9)
            Ragebot.ForceHitboxSafety(10)
            Ragebot.ForceHitboxSafety(11)
            Ragebot.ForceHitboxSafety(12)
        } else if (safeweapon >> 1 && weapon_name == "scar 20" || weapon_name == "g3sg1") {
            Ragebot.ForceHitboxSafety(0)
            Ragebot.ForceHitboxSafety(2)
            Ragebot.ForceHitboxSafety(3)
            Ragebot.ForceHitboxSafety(4)
            Ragebot.ForceHitboxSafety(5)
            Ragebot.ForceHitboxSafety(6)
            Ragebot.ForceHitboxSafety(7)
            Ragebot.ForceHitboxSafety(8)
            Ragebot.ForceHitboxSafety(9)
            Ragebot.ForceHitboxSafety(10)
            Ragebot.ForceHitboxSafety(11)
            Ragebot.ForceHitboxSafety(12)
        } else if (safeweapon >> 2 && weapon_name == "r8 revolver" || weapon_name == " 52>;L25@ r81" || weapon_name == "desert eagle") {
            Ragebot.ForceHitboxSafety(0)
            Ragebot.ForceHitboxSafety(2)
            Ragebot.ForceHitboxSafety(3)
            Ragebot.ForceHitboxSafety(4)
            Ragebot.ForceHitboxSafety(5)
            Ragebot.ForceHitboxSafety(6)
            Ragebot.ForceHitboxSafety(7)
            Ragebot.ForceHitboxSafety(8)
            Ragebot.ForceHitboxSafety(9)
            Ragebot.ForceHitboxSafety(10)
            Ragebot.ForceHitboxSafety(11)
            Ragebot.ForceHitboxSafety(12)
        } else if (safeweapon >> 3 && weapon_name == "usp s" || weapon_name == "glock 18" || weapon_name == "p2000" || weapon_name == "dual berettas" || weapon_name == "five seven" || weapon_name == "p250" || weapon_name == "tec 9") {
            Ragebot.ForceHitboxSafety(0)
            Ragebot.ForceHitboxSafety(2)
            Ragebot.ForceHitboxSafety(3)
            Ragebot.ForceHitboxSafety(4)
            Ragebot.ForceHitboxSafety(5)
            Ragebot.ForceHitboxSafety(6)
            Ragebot.ForceHitboxSafety(7)
            Ragebot.ForceHitboxSafety(8)
            Ragebot.ForceHitboxSafety(9)
            Ragebot.ForceHitboxSafety(10)
            Ragebot.ForceHitboxSafety(11)
            Ragebot.ForceHitboxSafety(12)
        } else if (safeweapon >> 4 && weapon_name == "ssg 08") {
            Ragebot.ForceHitboxSafety(0)
            Ragebot.ForceHitboxSafety(2)
            Ragebot.ForceHitboxSafety(3)
            Ragebot.ForceHitboxSafety(4)
            Ragebot.ForceHitboxSafety(5)
            Ragebot.ForceHitboxSafety(6)
            Ragebot.ForceHitboxSafety(7)
            Ragebot.ForceHitboxSafety(8)
            Ragebot.ForceHitboxSafety(9)
            Ragebot.ForceHitboxSafety(10)
            Ragebot.ForceHitboxSafety(11)
            Ragebot.ForceHitboxSafety(12)
        } else {

    }
 }
}
Cheat.RegisterCallback("CreateMove", "safepointsconditions");


const minimumdamage = function() {
    if(!UI.IsHotkeyActive("Script items", "Minimum damage key")) return;
    var enemies = Entity.GetEnemies();
    var weapon_name = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
    switch(weapon_name) {
        default: { damage = UI.GetValue("Minimum damage value") }; break
        case "r8 revolver": case " 52>;L25@ r8": { damage = UI.GetValue("Minimum damage value") }; break
        case "desert eagle": { damage = UI.GetValue("Minimum damage value") }; break
        case "ssg 08": { damage = UI.GetValue("Minimum damage value") }; break
        case "awp": { damage = UI.GetValue("Minimum damage value") }; break
        case "scar 20": case "g3sg1": { damage = UI.GetValue("Minimum damage value") }; break
    }
    for(i = 0; i < enemies.length; i++){
        if(Entity.IsValid(enemies[i]) && Entity.IsAlive(enemies[i]) && !Entity.IsDormant(enemies[i]))
        Ragebot.ForceTargetMinimumDamage(enemies[i], damage);
    }
}
Cheat.RegisterCallback("CreateMove", "minimumdamage")

const hithanceinair = function() {
    if (UI.GetValue("R8 & Scout HC in Air")) {
        var enemies = Entity.GetEnemies();
        var weapon_name = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
        for (i = 0; i < enemies.length; i++) {
            if(!Entity.IsValid(enemies[i]) && !Entity.IsAlive(enemies[i])) continue;
            if (Entity.GetProp(Entity.GetLocalPlayer(), "CBasePlayer", "m_hGroundEntity")) {
                if (weapon_name == "r8 revolver" || weapon_name == " 52>;L25@ r8")
                Ragebot.ForceTargetHitchance(enemies[i], UI.GetValue("Misc", "JAVASCRIPT", "Script items", "R8 hitchance"));
                if (weapon_name == "ssg 08")
                Ragebot.ForceTargetHitchance(enemies[i], UI.GetValue("Misc", "JAVASCRIPT", "Script items", "Scout hitchance"));				
            }
        }
    }
}
Cheat.RegisterCallback("CreateMove", "hithanceinair")

const freestandpeek = function (){
    const getvalue = UI.GetValue("Freestanding on DT Peek");
    if(getvalue && UI.IsHotkeyActive("Rage", "Doubletap") && UI.IsHotkeyActive("Misc", "Auto peek")) {
        UI.SetValue("Rage Anti-Aim", "Auto direction", true);
        } else {
        UI.SetValue("Rage Anti-Aim", "Auto direction", false);
        }
    }
Cheat.RegisterCallback("CreateMove", "freestandpeek")

function legit_aa() {
    if (UI.IsHotkeyActive("Script items", "Legit AA key")) {

        if (original_aa) {
            restrictions_cache = UI.GetValue("Misc", "PERFORMANCE & INFORMATION", "Information", "Restrictions");
            hiderealangle_cache = UI.GetValue("Anti-Aim", "Fake angles", "Hide real angle");
            yaw_offset_cache = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset");
            jitter_offset_cache = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Jitter offset");
            pitch_cache = UI.GetValue("Anti-Aim", "Extra", "Pitch");
            freestand_cache = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction");
            attargets_cache = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "At targets");
            autoinverter_cache = UI.GetValue("Stable Auto-Inverter")
            original_aa = false;}

        UI.SetValue("Misc", "PERFORMANCE & INFORMATION", "Information", "Restrictions", 0);
        UI.SetValue("Anti-Aim", "Fake angles", "Hide real angle", true);
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", 180);
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Jitter offset", 0);
        UI.SetValue("Anti-Aim", "Extra", "Pitch", 3);
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction", false);
        UI.SetValue("Anti-Aim", "Rage Anti-Aim", "At targets", false)
        UI.SetValue("Stable Auto-Inverter", false);
        AntiAim.SetOverride(1);
        AntiAim.SetRealOffset(UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter") ? -60 : 60);
        AntiAim.SetLBYOffset(UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter") ? 60 : -60);
        AntiAim.SetFakeOffset(0);
    } else {
        if (!original_aa) {
            UI.SetValue("Misc", "PERFORMANCE & INFORMATION", "Information", "Restrictions", restrictions_cache);
            UI.SetValue("Anti-Aim", "Fake angles", "Hide real angle", hiderealangle_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", yaw_offset_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Jitter offset", jitter_offset_cache);
            UI.SetValue("Anti-Aim", "Extra", "Pitch", pitch_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction", freestand_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "At targets", attargets_cache)
            UI.SetValue("Stable Auto-Inverter", autoinverter_cache);
            AntiAim.SetOverride(0);
            original_aa = true;
        }else if(!original_aa){
            UI.SetValue("Misc", "PERFORMANCE & INFORMATION", "Information", "Restrictions", restrictions_cache);
            UI.SetValue("Anti-Aim", "Fake angles", "Hide real angle", hiderealangle_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", yaw_offset_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Jitter offset", jitter_offset_cache);
            UI.SetValue("Anti-Aim", "Extra", "Pitch", pitch_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction", freestand_cache);
            UI.SetValue("Anti-Aim", "Rage Anti-Aim", "At targets", attargets_cache)
            AntiAim.SetOverride(0);
            original_aa = true;
        }else if (!(legitaa)){
            AntiAim.SetOverride(0);
        }
    }
}
Cheat.RegisterCallback("CreateMove", "legit_aa");

const switchOnShot = function() {
    if (UI.GetValue("Switch desync on shot")){
        if (WeaponFire && Global.Curtime() - shottimer > 0.55) {
            UI.ToggleHotkey("Anti-Aim", "Fake angles", "Inverter");
            shottimer = Global.Curtime();
            WeaponFire = false;
        }
    }
}
const RagebotFire = function() {
	if (!WeaponFire) WeaponFire = true;
}
Cheat.RegisterCallback("CreateMove", "switchOnShot")
Cheat.RegisterCallback("ragebot_fire", "RagebotFire");

const consolefilter = function(){
if (UI.GetValue("Console filter")){
    if (not_spam.confilter != 1){ 
        Convar.SetFloat("con_filter_enable", 1);
        Convar.SetString("con_filter_text", "IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
        not_spam.confilter = 1;
    }
} else {
    if (not_spam.confilter != 0){
        Convar.SetFloat("con_filter_enable", 0);
        Convar.SetString("con_filter_text", "")
        not_spam.confilter = 0; 
    }
  }
}
Cheat.RegisterCallback("Draw", "consolefilter")

const x1 = UI.AddSliderInt("Hotkeys_x", 0, Global.GetScreenSize()[0]);
const y1 = UI.AddSliderInt("Hotkeys_y", 0, Global.GetScreenSize()[1]);
var alpha = 0;
var maxwidth = 0;
var swalpha = 0;
var fdalpha = 0;
var apalpha = 0;
var aialpha = 0;
var spalpha = 0;
var ybalpha = 0;
var fbalpha = 0;
var dtalpha = 0;
var hsalpha = 0;
var doalpha = 0;
var textalpha = 0;
var h = new Array();

function main_hotkeys() {
    if(UI.GetValue("Indicators on screen") & 1 << 0){
        if (!World.GetServerString()) return;
        const x = UI.GetValue("Misc", "JAVASCRIPT", "Script items", "Hotkeys_x"),
            y = UI.GetValue("Misc", "JAVASCRIPT", "Script items", "Hotkeys_y");
        background = UI.GetColor("Script items", "Background color");
        maincolor = UI.GetColor("Script items", "Main color");
        lineweight = UI.GetValue("Line weight")
        IsLegitAA = UI.IsHotkeyActive("Legit AA key")
        IsATtargets = UI.GetValue("Rage Anti-Aim", "At targets")
        IsFreestanding = UI.GetValue("Rage Anti-Aim", "Auto direction")
        fontweight = UI.GetValue("Font weight")
        var colors = HSVtoRGB(Global.Realtime() * 0.2, 1, 1);
        var font = Render.AddFont("Verdana", 7, fontweight);
        var frames = 8 * Globals.Frametime();
        var width = 50;
        var maxwidth = 0;

        if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Slow walk")) {
            swalpha = Math.min(swalpha + frames, 1);
        } else {
            swalpha = swalpha - frames;
            if (swalpha < 0) swalpha = 0;
            if (swalpha == 0) {
                h.splice(h.indexOf("Slow walk"));
            }
        }

        if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Fake duck")) {
            fdalpha = Math.min(fdalpha + frames, 1);
        } else {
            fdalpha = fdalpha - frames;
            if (fdalpha < 0) fdalpha = 0;
            if (fdalpha == 0) {
                h.splice(h.indexOf("Fake duck"));
            }
        }

        if (UI.IsHotkeyActive("Misc", "GENERAL", "Movement", "Auto peek")) {
            apalpha = Math.min(apalpha + frames, 1);
        } else {
            apalpha = apalpha - frames;
            if (apalpha < 0) apalpha = 0;
            if (apalpha == 0) {
                h.splice(h.indexOf("Auto peek"));
            }
        }

        if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter")) {
            aialpha = Math.min(aialpha + frames, 1);
        } else {
            aialpha = aialpha - frames;
            if (aialpha < 0) aialpha = 0;
            if (aialpha == 0) {
                h.splice(h.indexOf("Inverter"));
            }
        }

        if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter")) {
            aialpha = Math.min(aialpha + frames, 1);
        } else {
            aialpha = aialpha - frames;
            if (aialpha < 0) aialpha = 0;
            if (aialpha == 0) {
                h.splice(h.indexOf("Inverter"));
            }
        }

        if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point")) {
            spalpha = Math.min(spalpha + frames, 1);
        } else {
            spalpha = spalpha - frames;
            if (spalpha < 0) spalpha = 0;
            if (spalpha == 0) {
                h.splice(h.indexOf("Safe points"));
            }
        }

        if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim")) {
            fbalpha = Math.min(fbalpha + frames, 1);
        } else {
            fbalpha = fbalpha - frames;
            if (fbalpha < 0) fbalpha = 0;
            if (fbalpha == 0) {
                h.splice(h.indexOf("Body aim"));
            }
        }

        if (UI.IsHotkeyActive("Rage", "Exploits", "Doubletap")) {
            dtalpha = Math.min(dtalpha + frames, 1);
        } else {
            dtalpha = dtalpha - frames;
            if (dtalpha < 0) dtalpha = 0;
            if (dtalpha == 0) {
                h.splice(h.indexOf("Double tap"));
            }
        }

        if (UI.IsHotkeyActive("Rage", "Exploits", "Hide shots")) {
            hsalpha = Math.min(hsalpha + frames, 1);
        } else {
            hsalpha = hsalpha - frames;
            if (hsalpha < 0) hsalpha = 0;
            if (hsalpha == 0) {
                h.splice(h.indexOf("Hide shots"));
            }
        }

        if (UI.IsHotkeyActive("Script items", "Minimum damage key")) {
            doalpha = Math.min(doalpha + frames, 1);
        } else {
            doalpha = doalpha - frames;
            if (doalpha < 0) doalpha = 0;
            if (doalpha == 0) {
                h.splice(h.indexOf("Minimum damage"));
            }
        }

        if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Slow walk")) {
            if (h.indexOf("Slow walk") == -1)
                h.push("Slow walk")
        }
        if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Fake duck")) {
            if (h.indexOf("Fake duck") == -1)
                h.push("Fake duck")
        }
        if (UI.IsHotkeyActive("Misc", "GENERAL", "Movement", "Auto peek")) {
            if (h.indexOf("Auto peek") == -1)
                h.push("Auto peek")
        }
        if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter")) {
            if (h.indexOf("Inverter") == -1)
                h.push("Inverter")
        }
        if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point")) {
            if (h.indexOf("Safe points") == -1)
                h.push("Safe points")
        }
        if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim")) {
            if (h.indexOf("Body aim") == -1)
                h.push("Body aim")
        }
        if (UI.IsHotkeyActive("Rage", "Exploits", "Doubletap")) {
            if (h.indexOf("Double tap") == -1)
                h.push("Double tap")
        }
        if (UI.IsHotkeyActive("Rage", "Exploits", "Hide shots")) {
            if (h.indexOf("Hide shots") == -1)
                h.push("Hide shots")
        }
        if (UI.IsHotkeyActive("Script items", "Minimum damage key")) {
            if (h.indexOf("Minimum damage") == -1)
                h.push("Minimum damage")
        }
        if (h.length > 0) {
            alpha = Math.min(alpha + frames, 1);
        } else {
            alpha = alpha - frames;
            if (alpha < 0) alpha = 0;
        }
        for (i = 0; i < h.length; i++) {
            if (Render.TextSizeCustom(h[i], font)[0] > maxwidth) {
                maxwidth = Render.TextSizeCustom(h[i], font)[0];
            }
        }
        if (maxwidth == 0) maxwidth = 50;
        width = width + maxwidth;
        if (alpha > 0) {
            if (UI.GetValue("Indicators line style") == 0) {
            Render.FilledRect(x, y + 5, width, lineweight, [maincolor[0], maincolor[1], maincolor[2], 255])
            }
            if (UI.GetValue("Indicators line style") == 1) {
            Render.GradientRect( x, y + 5, width / 2, lineweight, 1, [0, 0, 0, 55], [maincolor[0], maincolor[1], maincolor[2], 255]);
            Render.GradientRect( x + width / 2, y + 5, width / 2, lineweight, 1, [maincolor[0], maincolor[1], maincolor[2], 255], [0, 0, 0, 55]);
            }
            if (UI.GetValue("Indicators line style") == 2) {
            Render.GradientRect( x, y + 5, width / 2, lineweight, 1, [maincolor[0], maincolor[1], maincolor[2], 255], [0, 0, 0, 255]);
            Render.GradientRect( x + width / 2, y + 5, width / 2, lineweight, 1, [0, 0, 0, 255], [maincolor[0], maincolor[1], maincolor[2], 255]);
            }
            if (UI.GetValue("Indicators line style") == 3) {
            Render.GradientRect(x, y + 5, width / 2, lineweight, 1,  [55, 177, 218, alpha * 255], [203, 70, 205 , alpha * 255]);
            Render.GradientRect(x + width / 2, y + 5, width / 2, lineweight, 1, [203, 70, 205 , alpha * 255], [204, 210, 53, alpha * 255]);
            }
            if (UI.GetValue("Indicators line style") == 4) {
            Render.GradientRect(x, y + 5, width / 2, lineweight, 1, [colors.g, colors.b, colors.r, 255], [colors.r, colors.g, colors.b, 255]);
            Render.GradientRect(x + width / 2, y + 5, width / 2, lineweight, 1, [colors.r, colors.g, colors.b, 255], [colors.b, colors.r, colors.g, 255]);
            }
            Render.FilledRect(x, y + 6, width, 18, [0, 0, 0, alpha * 55]);
            Render.StringCustom(x + width / 2 - (Render.TextSizeCustom("keybinds", font)[0] / 2) + 2, y + 9, 0, "keybinds", [0, 0, 0, alpha * 255 / 1.3], font);
                Render.StringCustom(x + width / 2 - (Render.TextSizeCustom("keybinds", font)[0] / 2) + 1, y + 8, 0, "keybinds", [255, 255, 255, alpha * 255], font);
                for (i = 0; i < h.length; i++) {
                    switch (h[i]) {
                        case 'Slow walk':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(swalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, swalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, swalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, swalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, swalpha * 255], font);
                            break;
                        case 'Fake duck':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(fdalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, fdalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, fdalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, fdalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, fdalpha * 255], font);
                            break;
                        case 'Auto peek':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(apalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, apalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, apalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, apalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, apalpha * 255], font);
                            break;
                        case 'Inverter':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(aialpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, aialpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, aialpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, aialpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, aialpha * 255], font);
                            break;
                        case 'Safe points':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(spalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, spalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, spalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, spalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, spalpha * 255], font);
                            break;
                        case 'Body aim':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(fbalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, fbalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, fbalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, fbalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, fbalpha * 255], font);
                            break;
                        case 'Double tap':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(dtalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, dtalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, dtalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, dtalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, dtalpha * 255], font);
                            break;
                        case 'Hide shots':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(hsalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, hsalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, hsalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, hsalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, hsalpha * 255], font);
                            break;
                        case 'Minimum damage':
                            Render.FilledRect(x, y + 23 + 18 * i, width, 18, [17, 17, 17, Math.min(0, Math.min(doalpha * 255, 0))]);
                            Render.StringCustom(x + 3, y + 26 + 18 * i, 0, h[i], [0, 0, 0, doalpha * 255 / 1.3], font);
                            Render.StringCustom(x + 2, y + 26 + 18 * i, 0, h[i], [255, 255, 255, doalpha * 255], font);

                            Render.StringCustom(x - 3 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [0, 0, 0, doalpha * 255 / 1.3], font);
                            Render.StringCustom(x - 2 + width - Render.TextSizeCustom("[on]", font)[0], y + 26 + 18 * i, 0, "[on]", [255, 255, 255, doalpha * 255], font);
                            break;
                    }

                }
        }
        if (Global.IsKeyPressed(1) && UI.IsMenuOpen()) {
            const mouse_pos = Global.GetCursorPosition();
            if (in_bounds(mouse_pos, x, y, x + width, y + 30)) {
                UI.SetValue("Misc", "JAVASCRIPT", "Script items", "Hotkeys_x", mouse_pos[0] - width / 2);
                UI.SetValue("Misc", "JAVASCRIPT", "Script items", "Hotkeys_y", mouse_pos[1] - 20);
            }
        }
    }
}
Global.RegisterCallback("Draw", "main_hotkeys");

const draw = function() {
    if(UI.GetValue("Indicators on screen") & 1 << 1){
	if(!World.GetServerString())
		return;

	var today = new Date();
    var hours1 = today.getHours();
    var minutes1 = today.getMinutes();
	var seconds1 = today.getSeconds();
    var arc = 0;
	
    var hours = hours1 <= 9 ? "0"+hours1+":" : hours1+":";
    var minutes = minutes1 <= 9 ? "0" + minutes1+":" : minutes1+":";
	var seconds = seconds1 <= 9 ? "0" + seconds1 : seconds1;
	
	var server_tickrate = Globals.Tickrate().toString()
	var mstick = Math.round(Entity.GetProp(Entity.GetLocalPlayer(), "CPlayerResource", "m_iPing")).toString()

    background = UI.GetColor("Script items", "Background color");
    maincolor = UI.GetColor("Script items", "Main color");
    lineweight = UI.GetValue("Line weight")
    fontweight = UI.GetValue("Font weight")
    var colors = HSVtoRGB(Global.Realtime() * 0.2, 1, 1);
    var username = UI.GetString("Custom Username in Watermark") ? ""+UI.GetString("Custom Username in Watermark")+"" : Cheat.GetUsername();
    var font = Render.AddFont("Verdana", 7, fontweight);
    var RealYaw = Local.GetRealYaw();
    var FakeYaw = Local.GetFakeYaw();
    var delta = Math.min(Math.abs(RealYaw - FakeYaw) / 2, 60).toFixed(1);
    if (arc < delta / 60) (arc = arc += 0.025).toFixed(2);
    if (arc > delta / 60) (arc = arc -= 0.025).toFixed(2); if (arc[0] < 0.01) arc[0] = 0.00;

	var text = "Drain.js | " + username + " | delay: " + mstick + "ms | " + server_tickrate + "tick | " + hours + minutes + seconds;
	
	var w = Render.TextSizeCustom(text, font)[0] + 8;
	var x = Global.GetScreenSize()[0];
	x = x - w - 10;
    var y = 6;

    if (UI.GetValue("Indicators line style") == 0) {
        Render.FilledRect(x, y + 5, w, lineweight, [maincolor[0], maincolor[1], maincolor[2], 255])
        }
        if (UI.GetValue("Indicators line style") == 1) {
        Render.GradientRect( x, y + 5, w / 2, lineweight, 1, [0, 0, 0, 55], [maincolor[0], maincolor[1], maincolor[2], 255]);
        Render.GradientRect( x + w / 2, y + 5, w / 2, lineweight, 1, [maincolor[0], maincolor[1], maincolor[2], 255], [0, 0, 0, 55]);
        }
        if (UI.GetValue("Indicators line style") == 2) {
        Render.GradientRect( x, y + 5, w / 2, lineweight, 1, [maincolor[0], maincolor[1], maincolor[2], 255], [0, 0, 0, 255]);
        Render.GradientRect( x + w / 2, y + 5, w / 2, lineweight, 1, [0, 0, 0, 255], [maincolor[0], maincolor[1], maincolor[2], 255]);
        }
        if (UI.GetValue("Indicators line style") == 3) {
        Render.GradientRect(x, y + 5, w / 2, lineweight, 1,  [55, 177, 218, 255], [203, 70, 205 , 255]);
        Render.GradientRect(x + w / 2, y + 5, w / 2, lineweight, 1, [203, 70, 205 , 255], [204, 210, 53, 255]);
        }
        if (UI.GetValue("Indicators line style") == 4) {
        Render.GradientRect(x, y + 5, w / 2, lineweight, 1, [colors.g, colors.b, colors.r, 255], [colors.r, colors.g, colors.b, 255]);
        Render.GradientRect(x + w / 2, y + 5, w / 2, lineweight, 1, [colors.r, colors.g, colors.b, 255], [colors.b, colors.r, colors.g, 255]);
        }

        Render.FilledRect(x, 12, w, 18, [ 0, 0, 0, 55 ]);
        Render.Shadow(x+4, 10 + 4, 0, text, [ 0, 0, 0, 255 ], font);
        Render.StringCustom(x+4, 10 + 4, 0, text, [ 255, 255, 255, 255 ], font);
  }
}
Cheat.RegisterCallback("Draw", "draw");

const Acatel = function(){
    if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        if (UI.GetValue("Script items", "Indicators") == 2) {
   const font_smallfonts = Render.AddFont("Small Fonts", 5, 400);
   const IsLegitAA = UI.GetValue('Legit AA on E') && Input.IsKeyPressed(0x45);
   var screen_size = Global.GetScreenSize();
   var add_y = 0;
   IsFakeduck = UI.IsHotkeyActive("Extra", "Fake duck");
   IsMinimumdamage = UI.IsHotkeyActive("Misc", "JAVASCRIPT", "Script items", "Minimum damage on key");
   IsDoubleTap = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap");
   IsOSAA = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots");
   IsForceBaim = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim");
   IsForceSafepoints = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point");
   IsFreestanding = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction")
   IsInverter = UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter");
   IsHideshots = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots");
   IsAutopeek = UI.IsHotkeyActive("Misc", "Auto peek")
   IsChargedOrNo = Exploit.GetCharge() == 1 ? "CHARGED" : "UNCHARGED"
   IsChargedOrNoColor = Exploit.GetCharge() == 1 ? [173, 209, 15, 255] : [255, 30, 30, 255]
   FakeYaw = IsLegitAA ? "LEGIT AA" : IsInverter ? "R" : "L"
   add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "ACATEL", [255, 255, 255, 255], font_smallfonts);
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "FAKE YAW:", [166, 196, 212, 255], font_smallfonts);
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -39, screen_size[1] / 2 + add_y, 0, FakeYaw , [255, 255, 255, 255], font_smallfonts);}}
        if(IsHideshots) {
        add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "ONSHOT", [240, 158, 158, 255], font_smallfonts);}
        if(IsDoubleTap && IsAutopeek && IsFreestanding) {
        add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "IDEAL TICK:", [255, 255, 255, 255], font_smallfonts);
        Render.OutlineStringCustom(screen_size[0] / 2 - -42, screen_size[1] / 2 + add_y, 0, IsChargedOrNo, IsChargedOrNoColor, font_smallfonts);
        } else if(IsDoubleTap) {
        add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "DT", Exploit.GetCharge() == 1 ? [173, 209, 15, 255] : [255, 30, 30, 255] , font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "BAIM", IsForceBaim ? [255, 255, 255, 255] : [255, 255, 255, 155], font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -22, screen_size[1] / 2 + add_y, 0, "SP", IsForceSafepoints ? [255, 255, 255, 255] : [255, 255, 255 ,155], font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -34, screen_size[1] / 2 + add_y, 0, "FS", IsFreestanding ? [255, 255, 255, 255] : [255, 255, 255 ,155], font_smallfonts);}
    }
}
Cheat.RegisterCallback("Draw", "Acatel");

const DrainjsIndicators = function(){
    if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        if (UI.GetValue("Script items", "Indicators") == 1) {
    const font_smallfonts = Render.AddFont("Small Fonts", 5, 400);
    var add_y = 5;
    var screen_size = Global.GetScreenSize();
    IsLegitAA = UI.IsHotkeyActive('Legit AA key')
    Color = UI.GetColor("Script items", "Main color")
    IsFakeduck = UI.IsHotkeyActive("Extra", "Fake duck");
    IsMinimumdamage = UI.IsHotkeyActive("Misc", "JAVASCRIPT", "Script items", "Minimum damage key");
    IsDoubleTap = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap");
    IsOSAA = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots");
    IsForceBaim = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim");
    IsForceSafepoints = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point");
    IsFreestanding = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction")
    IsInverter = UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter");

    if(Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 21, screen_size[1] / 2 + 16, 0, "DRAIN", IsInverter ? [Color[0], Color[1], Color[2], 255] : [255, 255, 255, 255], font_smallfonts);
        Render.OutlineStringCustom(screen_size[0] / 2 - -2, screen_size[1] / 2 + 16, 0, "YAW", IsInverter ? [255, 255, 255, 255] : [Color[0], Color[1], Color[2], 255], font_smallfonts);
        if(IsFreestanding) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 28, screen_size[1] / 2 + add_y, 0, "FREESTANDING", [Color[0], Color[1], Color[2], 255], font_smallfonts);
    } else if (IsLegitAA) {
        add_y = add_y + 10
    Render.OutlineStringCustom(screen_size[0] / 2 - 16, screen_size[1] / 2 + add_y, 0, "LEGIT AA", [Color[0], Color[1], Color[2], 255], font_smallfonts);
        } else if (IsInAir()) {
            add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 16, screen_size[1] / 2 + add_y, 0, "AEROBIC", [Color[0], Color[1], Color[2], 255], font_smallfonts);
        } else if (IsDormant()) {
            add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 18, screen_size[1] / 2 + add_y, 0, "DORMANT", [Color[0], Color[1], Color[2], 255], font_smallfonts);
        } else if (IsCtrl()) {
            add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 22, screen_size[1] / 2 + add_y, 0, "CROUCHING", [Color[0], Color[1], Color[2], 255], font_smallfonts);
        } else {
            add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 13, screen_size[1] / 2 + add_y, 0, "STATIC", [Color[0], Color[1], Color[2], 255], font_smallfonts);
}
    if(IsOSAA) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 10, screen_size[1] / 2 + add_y, 0, "OSAA", Exploit.GetCharge() == 1 ? [Color[0], Color[1], Color[2], 255] : [255, 0, 0, 255] , font_smallfonts);
    }
    if(IsForceBaim) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 9, screen_size[1] / 2 + add_y, 0, "BODY", [Color[0], Color[1], Color[2], 255], font_smallfonts);
    }
    if(IsForceSafepoints) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 9, screen_size[1] / 2 + add_y, 0, "SAFE", [Color[0], Color[1], Color[2], 255], font_smallfonts);
    }
if(IsMinimumdamage) {
    add_y = add_y + 10
    Render.OutlineStringCustom(screen_size[0] / 2 - 9, screen_size[1] / 2 + add_y, 0, "DMG", [Color[0], Color[1], Color[2], 255], font_smallfonts);
}
    if(IsDoubleTap) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - 5, screen_size[1] / 2 + add_y, 0, "DT", Exploit.GetCharge() == 1 ? [Color[0], Color[1], Color[2], 255] : [255, 0, 0, 255] , font_smallfonts);
     }
    }
   }
  }
}
Cheat.RegisterCallback("Draw", "DrainjsIndicators");

const IdealYaw = function(){
    if (UI.GetValue("Script items", "Indicators") == 3) {
        lp = Entity.GetLocalPlayer();
        fs = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction")
        screen_size = Global.GetScreenSize();
        font = Render.AddFont("Tahoma", 8, 500);
        verdana = Render.AddFont("Verdana", 7, 500);
        velocity = Math.round(getVelocity(lp)).toString();
        var idealyawtext = fs ? "FAKE YAW" : "IDEAL YAW"
        var idealyawcolor = (velocity > 275) ? [255, 40, 40, 255] : fs ? [179, 159, 230, 255] : [220, 135, 49, 255]
        add_y = 15;
        if(Entity.IsAlive(Entity.GetLocalPlayer())){
        Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, idealyawtext, [0, 0, 0, 155], font);
        Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, idealyawtext, idealyawcolor, font);
            add_y = add_y + 10
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DYNAMIC", [0, 0, 0, 155], font);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DYNAMIC", [209, 159, 230, 255], font);
            if(velocity > 275) {
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + -25 + add_y, 0, "Jmekeria cu magnetu", [0, 0, 0, 155], verdana);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + -25 + add_y, 0, "Jmekeria cu magnetu", [255, 255, 255, 255], verdana);
            }
        if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots")) {
            add_y = add_y + 10
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "AA", [0, 0, 0, 155], font);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "AA", [176, 196, 222, 255], font);
        }
        if(UI.IsHotkeyActive("Misc", "JAVASCRIPT", "Script items", "Minimum damage on key")) {
            add_y = add_y + 10
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DMG", [0, 0, 0, 155], font);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DMG", [255, 255, 255, 255], font);
        }
        if(UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim")) {
            add_y = add_y + 10
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "BODY", [0, 0, 0, 155], font);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "BODY", [240, 248, 255, 255], font);
        }
        if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap")) {
            add_y = add_y + 10
            Render.Shadow(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DT", [0, 0, 0, 155], font);
            Render.StringCustom(screen_size[0] / 2 + 2, screen_size[1] / 2 + add_y, 0, "DT", Exploit.GetCharge() == 1 ? [154, 205, 50, 255] : [255, 0, 0, 255], font);
        }
    }
}
        }
Cheat.RegisterCallback("Draw", "IdealYaw")

const Eternalindicators = function(){
    if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        if (UI.GetValue("Script items", "Indicators") == 4) {
   const font_smallfonts = Render.AddFont("Small Fonts", 5, 400);
   const IsLegitAA = UI.GetValue('Legit AA on E') && Input.IsKeyPressed(0x45);
   var screen_size = Global.GetScreenSize();
   var add_y = 0;
   IsFakeduck = UI.IsHotkeyActive("Extra", "Fake duck");
   IsMinimumdamage = UI.IsHotkeyActive("Misc", "JAVASCRIPT", "Script items", "Minimum damage on key");
   Pulse = Math.sin(Math.abs(-3.14 + Globals.Curtime() * 1.333333333333333 % 6.28)) * 255;
   IsDoubleTap = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap");
   IsOSAA = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots");
   IsForceBaim = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim");
   IsForceSafepoints = UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point");
   IsFreestanding = UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Auto direction")
   IsInverter = UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter");
   IsHideshots = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Hide shots");
   IsAutopeek = UI.IsHotkeyActive("Misc", "Auto peek")
   IsChargedOrNo = Exploit.GetCharge() == 1 ? "CHARGED" : "UNCHARGED"
   real_yaw = Local.GetRealYaw();
   Color = UI.GetColor("Script items", "Main color")
   var ping = Math.round(Local.Latency() * 1000 - 16)
   fake_yaw = Local.GetFakeYaw();
   delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);
   IsChargedOrNoColor = Exploit.GetCharge() == 1 ? [173, 209, 15, 255] : [255, 30, 30, 255]
   FakeYaw = IsLegitAA ? "LEGIT AA" : IsInverter ? "R" : "L"
   var size = Render.GetScreenSize()
   if (Entity.IsAlive(Entity.GetLocalPlayer())) {
    Render.OutlineStringCustom(screen_size[0] / 2 - -40, screen_size[1] / 2 + -40, 0, ping + " MS", [Color[0], Color[1], Color[2], 255], font_smallfonts);}
   add_y = add_y + 8
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "ETERNAL", [255, 255, 255, 255], font_smallfonts);
        Render.OutlineStringCustom(screen_size[0] / 2 - -34, screen_size[1] / 2 + add_y, 0, "BETA", [Color[0], Color[1], Color[2], Pulse], font_smallfonts);
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "DYNAMIC    -" + delta + "", [Color[0], Color[1], Color[2], 255], font_smallfonts);
        Render.Circle( 1011.1, 558, 1, [ 255, 255, 255, 255 ] );}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "FAKE   YAW:", [106, 90, 205, 255], font_smallfonts);
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -45, screen_size[1] / 2 + add_y, 0, FakeYaw , [255, 255, 255, 255], font_smallfonts);}}
        if(IsHideshots) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "ONSHOT", [240, 158, 158, 255], font_smallfonts);}
        if(IsDoubleTap && IsAutopeek && IsFreestanding) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "IDEAL TICK:", [255, 255, 255, 255], font_smallfonts);
        Render.OutlineStringCustom(screen_size[0] / 2 - -42, screen_size[1] / 2 + add_y, 0, IsChargedOrNo, IsChargedOrNoColor, font_smallfonts);
        } else if(IsDoubleTap) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "DT", Exploit.GetCharge() == 1 ? [173, 209, 15, 255] : [255, 30, 30, 255] , font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "MD:   " + UI.GetValue("Minimum damage value"), [255, 255, 255, 255], font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 10
        Render.OutlineStringCustom(screen_size[0] / 2 - -1, screen_size[1] / 2 + add_y, 0, "BAIM", IsForceBaim ? [255, 255, 255, 255] : [255, 255, 255, 155], font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -22, screen_size[1] / 2 + add_y, 0, "SP", IsForceSafepoints ? [255, 255, 255, 255] : [255, 255, 255 ,155], font_smallfonts);}
        if (Entity.IsAlive(Entity.GetLocalPlayer())) {
        add_y = add_y + 0
        Render.OutlineStringCustom(screen_size[0] / 2 - -34, screen_size[1] / 2 + add_y, 0, "FS", IsFreestanding ? [255, 255, 255, 255] : [255, 255, 255 ,155], font_smallfonts);} 
   }
}
Cheat.RegisterCallback("Draw", "Eternalindicators");

const Teamskeetfornlindicators = function() {
    if(Entity.IsAlive(Entity.GetLocalPlayer())) {
    if (UI.GetValue("Script items", "Indicators") == 5) {
      x = Render.GetScreenSize()[0];
      y = Render.GetScreenSize()[1];
      font = Render.AddFont("Verdana", 7, 400);
      Color = UI.GetColor("Script items", "Main color")
      real_yaw = Local.GetRealYaw();
      fake_yaw = Local.GetFakeYaw();
      IsInverter = UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter");
      delta = Math.min(Math.abs(real_yaw - fake_yaw) / 2, 60).toFixed(0);
      Render.StringCustom(x / 2 + -18, y / 2 + 37, 1, "TEAM", IsInverter ? [Color[0], Color[1], Color[2], 255] : [255, 255, 255, 255], font);
      Render.StringCustom(x / 2 + 15, y / 2 + 37, 1, "SKEET", IsInverter ? [255, 255, 255, 255] : [Color[0], Color[1], Color[2], 255], font);
      Render.GradientRect(x / 2, y / 1.975 + 45, .983 * delta, 2.3, 1, [Color[0], Color[1], Color[2], 255], [Color[0], Color[1], Color[2], 0]);
      Render.GradientRect(x / 2 - .983 * delta + 1, y / 1.975 + 45, .983 * delta, 2.3, 1, [Color[0], Color[1], Color[2], 0], [Color[0], Color[1], Color[2], 255]);
    }
  }
}
Cheat.RegisterCallback("Draw", "Teamskeetfornlindicators");

