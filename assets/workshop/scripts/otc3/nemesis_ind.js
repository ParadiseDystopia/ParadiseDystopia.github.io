UI.AddMultiDropdown("Nemesis indicators", ["Keybinds", "Info indicators", "Manual arrows"]);
UI.AddMultiDropdown("Show info indicators", ["Fake yaw", "Fakelag", "Exploits", "Inaccuracy", "Stand height"]);
UI.AddMultiDropdown("Show in keybinds", ["Thirdperson", "Hide shots", "Double tap", "Body aim", "Safe point", "Inverter", "Fake duck", "Slow walk", "Auto peek", "Edge jump"]);
UI.AddMultiDropdown('"HOLDING" in state bind', ["Thirdperson", "Hide shots", "Double tap", "Body aim", "Safe point", "Inverter", "Fake duck", "Slow walk", "Auto peek", "Edge jump"]);
UI.AddColorPicker("Indicators color");
UI.AddColorPicker("Active manual color");
UI.AddHotkey("Left direction");
UI.AddHotkey("Back direction"); 
UI.AddHotkey("Right direction");
UI.AddSliderInt("keybinds_x", 0, Global.GetScreenSize()[0]);
UI.AddSliderInt("keybinds_y", 0, Global.GetScreenSize()[1]);
UI.AddSliderInt("indicator_x", 0, Global.GetScreenSize()[0]);
UI.AddSliderInt("indicator_y", 0, Global.GetScreenSize()[1]);

const OutlineText = function(x, y, atline, text, color, font) {
	Render.StringCustom(x - 1, y, atline, text, [0, 0, 0, 255], font);
	Render.StringCustom(x + 1, y, atline, text, [0, 0, 0, 255], font);
	Render.StringCustom(x, y - 1, atline, text, [0, 0, 0, 255], font);
	Render.StringCustom(x, y + 1, atline, text, [0, 0, 0, 255], font);
	Render.StringCustom(x, y, atline, text, color, font);
};

var draggable = [[0, 0, 0], [0, 0, 0]];
var screen = Global.GetScreenSize();
LPx = [(screen[0] /2) - 55, (screen[1] /2) + 8]; LPy = [(screen[0] /2) - 55, (screen[1] /2) - 8]; LPz = [(screen[0] /2) - 70, (screen[1] /2)];
RPx = [(screen[0] /2) + 55, (screen[1] /2) + 8]; RPy = [(screen[0] /2) + 55, (screen[1] /2) - 8]; RPz = [(screen[0] /2) + 70, (screen[1] /2)];

const Indicators = function() {
	var fonts = {smallfonts: Render.AddFont("Small fonts", 5, 400)};
	var c = UI.GetColor("Script items", "Indicators color");
	var add_y = 0; 
	var underheight = 2;
	const DrawMenu = function() {
		UI.SetEnabled("Show info indicators", UI.GetValue("Nemesis indicators") & 1 << 1);
		UI.SetEnabled("Show in keybinds", UI.GetValue("Nemesis indicators") & 1 << 0);
		UI.SetEnabled('"HOLDING" in state bind', UI.GetValue("Nemesis indicators") & 1 << 0);
		UI.SetEnabled("Indicators color", (UI.GetValue("Nemesis indicators") & 1 << 0) || UI.GetValue("Nemesis indicators") & 1 << 1);
		UI.SetEnabled("Active manual color", UI.GetValue("Nemesis indicators") & 1 << 2);
		UI.SetEnabled("Left direction", UI.GetValue("Nemesis indicators") & 1 << 2);
		UI.SetEnabled("Back direction", UI.GetValue("Nemesis indicators") & 1 << 2); 
		UI.SetEnabled("Right direction", UI.GetValue("Nemesis indicators") & 1 << 2);
		UI.SetEnabled("keybinds_x", false);
		UI.SetEnabled("keybinds_y", false);
		UI.SetEnabled("indicator_x", false);
		UI.SetEnabled("indicator_y", false);
	};
	const ManualArrows = function() {
		if (UI.GetValue("Nemesis indicators") & 1 << 2) {
			var clr = UI.GetColor("Script items", "Active manual color");
			Render.Polygon([RPy, RPz, RPx], UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset") == 90 ? [clr[0], clr[1], clr[2], 255] : [255, 255, 255, 100]);
			Render.Polygon([LPx, LPz, LPy], UI.GetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset") == -90 ? [clr[0], clr[1], clr[2], 255] : [255, 255, 255, 100]);
		}
	}
	//Indicator
	const Indicator = function() {
		if (UI.GetValue("Nemesis indicators") & 1 << 1) {
			var width = 170, height = 15, indcount = [];
			var pos = {x: UI.GetValue("indicator_x"), y: UI.GetValue("indicator_y")}
			var delta = Math.min(Math.abs(Local.GetRealYaw() -  Local.GetFakeYaw()) / 2, 60).toFixed(1);
			
			if (UI.GetValue("Show info indicators") & 1 << 0) underheight = underheight + 13;
			
			Render.FilledRect(pos.x, pos.y, width, height, [18, 18, 18, 255]);
			Render.FilledRect(pos.x, pos.y + 1, width, 1, [c[0], c[1], c[2], 255]);
			OutlineText(pos.x + (width / 2) - Render.TextSizeCustom("INDICATORS", fonts.smallfonts)[0] / 2, pos.y + (height / 2) - Render.TextSizeCustom("INDICATORS", fonts.smallfonts)[1] / 2 + 1, 0, "INDICATORS", [255, 255, 255, 255], fonts.smallfonts);
			
			var timetoticks = function(a){ return Math.floor(0.5 + a / Globals.TickInterval()) };
			fakelag = timetoticks(Globals.Curtime() - Entity.GetProp(Entity.GetLocalPlayer(), "DT_CSPlayer", "m_flSimulationTime")) + 1;
			if(fakelag < 0) fakelag = 0; if(fakelag > 16) fakelag = 16;
			
			var infos = [
				["FAKE  YAW", 0, (delta / 60) * 100, true],
				["FAKE LAG", 1, (fakelag / 16) * 100, true],
				["EXPLOITS", 2, Exploit.GetCharge() * 100, true],
				["INACCURACY", 3, 100 - (Local.GetInaccuracy() * 100), Local.GetInaccuracy()],
				["STAND HEIGHT", 4, 100 - (Entity.GetProp(Entity.GetLocalPlayer(), "CBasePlayer", "m_flDuckAmount") * 100), true],
			];
			
			for (var p in infos) {if (UI.GetValue("Show info indicators") & 1 << infos[p][1]) indcount.push(p)};
			
			Render.FilledRect(pos.x, pos.y + height, width, (indcount.length * 13) + 3, [35, 35, 35, 200]);
			Render.Rect(pos.x, pos.y, width, height + (indcount.length * 13) + 3, [0, 0, 0, 200]);
			
			for (var i in infos) {
				var name = infos[i][0], value = infos[i][1], widthbar = infos[i][2], inaccuracy = infos[i][3];
				
				if (UI.GetValue("Show info indicators") & 1 << value) {
					OutlineText(pos.x + 3, pos.y + height + 3 + add_y, 0, name, [255, 255, 255, 255], fonts.smallfonts); 
					Render.FilledRect(pos.x + width - 100 - 3, pos.y + height + 4 + add_y, 100, 7, [15, 15, 15, 200])
					if (inaccuracy)
					Render.GradientRect(pos.x + width - 100 - 3, pos.y + height + 4 + add_y, widthbar, 7, 1, [c[0], c[1], c[2], 170], [c[0], c[1], c[2], 255])
					add_y = add_y + 13;
					underheight = underheight + 1				}
			};
			
			var dragheigth = height + (indcount.length * 13) + 3
			var cursor = Global.GetCursorPosition();
			if ((cursor[0] >= pos.x) && (cursor[0] <= pos.x + width) && (cursor[1] >= pos.y) && (cursor[1] <= pos.y + dragheigth)) {
			if ((Global.IsKeyPressed(0x01)) && (draggable[1][0] == 0)) { draggable[1][0] = 1; draggable[1][1] = pos.x - cursor[0]; draggable[1][2] = pos.y - cursor[1]; }
			} if (!Global.IsKeyPressed(0x01)) draggable[1][0] = 0;
			if (draggable[1][0] == 1 && UI.IsMenuOpen()) {
				UI.SetValue("Script items", "indicator" + "_x", cursor[0] + draggable[1][1]);
				UI.SetValue("Script items", "indicator" + "_y", cursor[1] + draggable[1][2]);
			}
		}
	};
	//Keybinds
	const Keybinds = function() {
		if (UI.GetValue("Nemesis indicators") & 1 << 0) {
			var width = 170, height = 15, keyheight = 0, keycount = [];
			var pos = {x: UI.GetValue("keybinds_x"), y: UI.GetValue("keybinds_y")}

			var info = [
			["THIRDPERSON", ["Visuals", "WORLD", "View", "Thirdperson"], true, "TOGGLED"],
			["HIDE SHOTS", ["Rage", "Exploits", "Hide shots"], true, "TOGGLED"],
			["DOUBLE TAP", ["Rage", "Exploits", "Doubletap"], true, "TOGGLED"],
			["BODY AIM", ["Rage", "General", "Force body aim"], true, "TOGGLED"],
			["SAFE POINT", ["Rage", "General", "Force safe point"], true, "TOGGLED"],
			["INVERTER", ["Anti-Aim", "Fake angles", "Inverter"], true, "TOGGLED"],
			["FAKE DUCK", ["Anti-Aim", "Extra", "Fake duck"], true, "TOGGLED"],
			["SLOW WALK", ["Anti-Aim", "Extra", "Slow walk"], true, "TOGGLED"],
			["AUTO PEEK", ["Misc", "Movement", "Auto peek"], true, "TOGGLED"],
			["EDGE JUMP", ["Misc", "Movement", "Edge jump"], true, "TOGGLED"],
			];

			for (var i in info) { 
				info[i][2] = UI.GetValue("Show in keybinds") & 1 << i ? true : false
				if (UI.IsHotkeyActive.apply(null, info[i][1]) && info[i][2]) keycount.push(i) 
			}	

			keyheight = 12 * keycount.length + 3

			Render.FilledRect(pos.x, pos.y, width, height, [18, 18, 18, 255]);
			Render.FilledRect(pos.x, pos.y + height, width, keyheight, [35, 35, 35, 200]);
			Render.FilledRect(pos.x, pos.y + 1, width, 1, [c[0], c[1], c[2], 255]);
			Render.Rect(pos.x, pos.y, width, height + keyheight, [0, 0, 0, 200]);
			OutlineText(pos.x + (width / 2) - Render.TextSizeCustom("KEYBINDS", fonts.smallfonts)[0] / 2, pos.y + (height / 2) - Render.TextSizeCustom("KEYBINDS", fonts.smallfonts)[1] / 2 + 1, 0, "KEYBINDS", [255, 255, 255, 255], fonts.smallfonts);

			for (var i in keycount) {
				b = keycount[i]
				info[b][3] = UI.GetValue('"HOLDING" in state bind') & 1 << b ? "HOLDING" : "TOGGLED";
				OutlineText(pos.x + 3, pos.y + 3 + height + (12 * i), 0, info[b][0], [255, 255, 255, 255], fonts.smallfonts);
				OutlineText(pos.x + width - Render.TextSizeCustom(info[b][3], fonts.smallfonts)[0] - 4, pos.y + 3 + height + (12 * i), 0, info[b][3], [255, 255, 255, 255], fonts.smallfonts);
			}
			
			var dragheigth = height + keyheight
			var cursor = Global.GetCursorPosition();
			if ((cursor[0] >= pos.x) && (cursor[0] <= pos.x + width) && (cursor[1] >= pos.y) && (cursor[1] <= pos.y + dragheigth)) {
			if ((Global.IsKeyPressed(0x01)) && (draggable[0][0] == 0)) { draggable[0][0] = 1; draggable[0][1] = pos.x - cursor[0]; draggable[0][2] = pos.y - cursor[1]; }
			} if (!Global.IsKeyPressed(0x01)) draggable[0][0] = 0;
			if (draggable[0][0] == 1 && UI.IsMenuOpen()) {
				UI.SetValue("Script items", "keybinds" + "_x", cursor[0] + draggable[0][1]);
				UI.SetValue("Script items", "keybinds" + "_y", cursor[1] + draggable[0][2]);
			}
		}
	}
	DrawMenu();
	ManualArrows();
	Indicator();
	Keybinds();
};

var manuals = [
[["Script items", "Left direction"], -90, false, [true, false, false]],
[["Script items", "Back direction"], 0, false, [false, true, false]],
[["Script items", "Right direction"], 90, false, [false, false, true]],
[0, 0, true],
];

const ManualAntiAim = function() {
	if (UI.GetValue("Nemesis indicators") & 1 << 2) {
		for (var i = 0; i < manuals.length - 1; i++) {
			if (UI.IsHotkeyActive.apply(null, manuals[i][0]) && !manuals[i][2]) {
				manuals[3][2] = false; manuals[3][0] = Global.Tickcount();
				UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", manuals[i][1]);
				UI.SetValue("Anti-Aim", "Rage Anti-Aim", "At targets", false);
				for (var z = 0; z < manuals.length -1; z++) { manuals[z][2] = manuals[z][3][i] }
			} else if (UI.IsHotkeyActive.apply(null, manuals[i][0]) && manuals[i][2] && Global.Tickcount() > manuals[3][0] + 12) {
				manuals[3][1] = Global.Tickcount();
				manuals[3][2] = true;
			}
			if (manuals[3][2]) {
				if (Global.Tickcount() > manuals[3][1] + 1){
					manuals[3][1] = Global.Tickcount(); for (var p = 0; p < 3; p++) { manuals[p][2] = false }
				}
				UI.SetValue("Anti-Aim", "Rage Anti-Aim", "Yaw offset", -6);
				UI.SetValue("Anti-Aim", "Rage Anti-Aim", "At targets", true);
			}
		}
	}
};

Cheat.RegisterCallback("Draw", "Indicators");
Cheat.RegisterCallback("CreateMove", "ManualAntiAim");