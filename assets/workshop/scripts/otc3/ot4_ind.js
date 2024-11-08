/* Self-API */
const getmultidrop = function(value, index) { const mask = 1 << index; return value & mask ? true : false; }
const addlabel = function(name) { return UI.AddLabel(name); }
const addcheckbox = function(name) { return UI.AddCheckbox(name); }
const addhotkey = function(name) { return UI.AddHotkey(name); }
const addtextbox = function(name) { return UI.AddTextbox(name); }
const addcolorpicker = function(name) { return UI.AddColorPicker(name); }
const addsliderint = function(name, first, second) { return UI.AddSliderInt(name, first, second); }
const addsliderfloat = function(name, first, second) { return UI.AddSliderFloat(name, first, second); }
const adddropdown = function(name, list) { return UI.AddDropdown(name, list); }
const addmultidropdown = function(name, list) { return UI.AddMultiDropdown(name, list); }
const getvalue = function(name) { return UI.GetValue("Script items", name); }
const setvalue = function(name, value) { return UI.SetValue("Script items", name, value); }
const getstring = function(name) { return UI.GetString("Script items", name); }
const ishotkeyactive = function(name) { return UI.IsHotkeyActive(name); }
const setenabled = function(name, enabledvalue) { return UI.SetEnabled("Script items", name, enabledvalue); }
const getcolor = function(name) { return UI.GetColor("Script items", name); }
const setcolor = function(name, color) { return UI.SetColor("Script items", name, color); }
const visible_value = function(drop, drop_value, name) { if(getvalue(drop) == drop_value) { setenabled(name, 1) }else{ setenabled(name, 0)} }
const unvisible_value = function(drop, drop_value, name) { if(getvalue(drop) == drop_value) { setenabled(name, 0) }else{ setenabled(name, 1)} }
const visible_string = function(drop, drop_string, name) { if(getstring(drop) == drop_string) { setenabled(name, 1) }else{ setenabled(name, 0)} }
const unvisible_string = function(drop, drop_string, name) { if(getstring(drop) == drop_string) { setenabled(name, 0) }else{ setenabled(name, 1)} }

/* UI */
addlabel ("onetap v4 indicators")
addmultidropdown("onetap indicators", ["Watermark", "Custom nick","Keybindings", "options"])
addtextbox("Type username")
addmultidropdown("Keybindings: holding", ["Slow walk", "Fakeduck", "Auto peek", "Anti-Aim Inverter", "Safe point", "Body aim", "Doubletap", "Hide shots", "Damage override"])
addsliderint("", 0, 0)

/* Watermark */
function otwatermark() {
    /* Time (optionaly) */
    var today = new Date();
    var hours1 = today.getHours();
    var minutes1 = today.getMinutes();
    var seconds1 = today.getSeconds();
            
    var hours = hours1 <= 9 ? "0"+hours1+":" : hours1+":";
    var minutes = minutes1 <= 9 ? "0" + minutes1+":" : minutes1+":";
    var seconds = seconds1 <= 9 ? "0" + seconds1 : seconds1;

    /* Main variables */
    var custom_username = getstring("Type username")
    var ping = Math.round(Entity.GetProp(Entity.GetLocalPlayer(), "CPlayerResource", "m_iPing")).toString()
    var font = Render.AddFont("Verdana", 8, 400);
    var server_ip = World.GetServerString();
    var text = "onetap | "
    if(getmultidrop(getvalue("onetap indicators"), 1)) { text += custom_username }else{ text += Cheat.GetUsername() }
    if (server_ip != "") { text += " | " + server_ip + " | ping " + ping }
    var w = Render.TextSizeCustom(text, font)[0] + 20;
    var x = Global.GetScreenSize()[0];

    x = x - w - 10;
    if(getmultidrop(getvalue("onetap indicators"), 0)) {
    Render.GradientRect(x, 5, 400, 20, 500, [ 0, 0, 0, 0 ], [ 0, 0, 0, 255 ]);
    Render.StringCustom(x+20, 5 + 3, 0, text, [ 255, 255, 255, 255 ], font);
    }
}

/* HotkeyVariables */
var holded = "a"
var toogled = "f"

var slowwalk = holded
var fakeduck = holded
var autopeek = holded
var inverter = holded
var safepoint = holded
var bodyaim = holded
var doubletap = holded
var hideshots = holded
var damageoverride = holded

/* MultiDropdown */
function multidropdown() {
    if(getmultidrop(getvalue("onetap indicators"), 1)) { setenabled("Type username", true) }else{ setenabled("Type username", false) }
    if(getmultidrop(getvalue("onetap indicators"), 3)) { setenabled("Keybindings: holding", true) }else{ setenabled("Keybindings: holding", false) }
    if(getmultidrop(getvalue("Keybindings: holding"), 0)) { slowwalk = holded }else{ slowwalk = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 1)) { fakeduck = holded }else{ fakeduck = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 2)) { autopeek = holded }else{ autopeek = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 3)) { inverter = holded }else{ inverter = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 4)) { safepoint = holded }else{ safepoint = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 5)) { bodyaim = holded }else{ bodyaim = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 6)) { doubletap = holded }else{ doubletap = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 7)) { hideshots = holded }else{ hideshots = toogled }
    if(getmultidrop(getvalue("Keybindings: holding"), 8)) { damageoverride = holded }else{ damageoverride = toogled }
}

var y = Global.GetScreenSize()[1] / 2
function in_bounds(vec, x, y, x2, y2) { return (vec[0] > x) && (vec[1] > y) && (vec[0] < x2) && (vec[1] < y2) }
function otkeybindings() {
    if(getmultidrop(getvalue("onetap indicators"), 2)) {
        if(!World.GetServerString()) return;
        var font = Render.AddFont( "MuseoSansCyrl-500", 10, 100);
        const icon = Render.AddFont("untitled-font-1", 14, 10);
        Render.GradientRect(0, y, 200, 17, 500, [ 0, 0, 0, 200 ], [ 0, 0, 0, 0 ]);
        var h = [];
         if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Slow walk")) { h.push("Slow walk") }
         if (UI.IsHotkeyActive("Anti-Aim", "Extra", "Fake duck")) { h.push("Fake duck") }
         if (UI.IsHotkeyActive("Misc", "GENERAL", "Movement", "Auto peek")) { h.push("Auto peek") }
         if (UI.IsHotkeyActive("Anti-Aim", "Fake angles", "Inverter")) { h.push("AA inverter") }
         if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force safe point")) { h.push("Safe point") }
         if (UI.IsHotkeyActive("Rage", "GENERAL", "General", "Force body aim")) { h.push("Body aim") }
         if (UI.IsHotkeyActive("Rage", "Exploits", "Doubletap")) { h.push("Doubletap") }
         if (UI.IsHotkeyActive("Rage", "Exploits", "Hide shots")) { h.push("Hide shots") }
         if (UI.IsHotkeyActive("Misc", "JAVASCRIPT", "Script items", "Min Damage")) { h.push("Damage override") }
        if (h.length > 0) {
            for (i = 0; i < h.length; i++) {
                switch (h[i]) {
                    case 'Slow walk':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, slowwalk, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Fake duck':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, fakeduck, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Auto peek':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, autopeek, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'AA inverter':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, inverter, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Safe point':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, safepoint, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Body aim':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, bodyaim, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Doubletap':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, doubletap, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case 'Hide shots':
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, hideshots, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                    case "Damage override":
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [0, 0, 0, 180], font);
                        Render.StringCustom(5, y+22 +(i*20), 0, damageoverride, [245, 245, 245, 255], icon);
                        Render.StringCustom(35, y+24 +(i*20), 0, h[i], [255, 255, 255, 255], font);
                        break;
                }
            }
        }
    }
}

var spectators = [];
function getspectators(){
    var ents = Entity.GetPlayers();
    var local = Entity.GetLocalPlayer();
    var localtarget = Entity.GetProp(local,"DT_BasePlayer","m_hObserverTarget");
    if(!local)return;
    spectators = [];
    for(i = 0; i < ents.length;i++) {
        if(Entity.IsAlive(local)) {
            if(!ents[i] || Entity.IsAlive(ents[i]))continue;
            var observer = Entity.GetProp(ents[i],"DT_BasePlayer","m_hObserverTarget");
            if(!observer || observer == "m_hObserverTarget")continue;
            if(observer == local)spectators.push(Entity.GetName(ents[i]));
        }else{
            if(!ents[i] || Entity.IsAlive(ents[i]))continue;
            var observer = Entity.GetProp(ents[i],"DT_BasePlayer","m_hObserverTarget");
            if(!observer || observer == "m_hObserverTarget")continue;
            if(observer == localtarget)spectators.push(Entity.GetName(ents[i]));
        }
    }
}
function drawspectators(){
    if(getmultidrop(getvalue("onetap indicators"), 2)) {
        var font = Render.AddFont( "MuseoSansCyrl-500", 10, 100);
        var icon = Render.AddFont("untitled-font-1", 14, 10);
        for(i = 0; i < spectators.length; i++){
            var name = spectators[i];
            Render.StringCustom(5,(y-27)+(i*-20),0,"h", [245, 245, 245, 255], icon);
            Render.StringCustom(35,(y-25)+(i*-20),0,name,[255,255,255,255],font);
        }
    }
}

function onRoundStart(){
    spectators = [];
}

Global.RegisterCallback("Draw", "multidropdown")
Global.RegisterCallback("Draw", "otkeybindings")
Global.RegisterCallback("Draw","getspectators");
Global.RegisterCallback("Draw","drawspectators");
Global.RegisterCallback("round_start","onRoundStart");
Global.RegisterCallback("Draw", "otwatermark")