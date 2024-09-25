

const screen = Global.GetScreenSize();
var stored = false;
var x_offs = 0;
var y_offs = 0;

var info = [
   ["DOUBLE TAP", ["Rage", "Exploits", "Double tap"]],
   ["HIDE SHOT", ["Rage", "Exploits", "Hide shots"]],
   ["FAKE DUCK", ["Anti-Aim", "Extra", "Fake duck"]],
   ["BODY AIM", ["Rage", "General", "General", "Force body aim"]],
   ["SAFE POINT", ["Rage", "General", "General", "Force safe point"]]
]

const in_bounds = function(vec, x, y, x2, y2){
   return (vec[0] > x) && (vec[1] > y) && (vec[0] < x2) && (vec[1] < y2)
}

const Render_outlined = function(x, y, a, text, color, font){
   Render.StringCustom(x + 1, y, a, text, [0, 0, 0, 255], font );
   Render.StringCustom(x - 1, y, a, text, [0, 0, 0, 255], font );
   Render.StringCustom(x, y + 1, a, text, [0, 0, 0, 255], font );
   Render.StringCustom(x, y - 1, a, text, [0, 0, 0, 255], font );

   Render.StringCustom(x, y, a, text, color, font );
}

const keybinds = function(){
   var active_binds = [];
   const font = Render.AddFont("Small Fonts", 5, 100);
   const x = UI.GetValue("Script items", "keybinds_x"), y = UI.GetValue("Script items", "keybinds_y");

   for(var j in info){
      if(UI.IsHotkeyActive.apply(null, info[j][1])) active_binds.push(j);
   }

   Render.FilledRect(x, y, 200, 15, [10, 10, 10, 255]);
   Render.FilledRect(x, y + 15, 200, 19 + 19 * (active_binds.length - 1), [15, 15, 15, 240]);
   Render.GradientRect(x, y, 100, 1, 1, [55, 177, 218, 255], [203, 70, 205, 255]);
   Render.GradientRect(x + 100, y, 100, 1, 1, [203, 70, 205, 255], [204, 227, 53, 255]);
   Render_outlined(x + 100, y + 3, 1, "KEYBINDS", [255, 255, 255, 255], font);
   for (var i in active_binds){
      Render_outlined(x + 8, y + 20 + 16 * i, 0, info[active_binds[i]][0], [255, 255, 255, 255], font);
      Render_outlined(x + 168, y + 20 + 16 * i, 0, "ACTIVE", [150, 255, 0, 255], font);
   }

   if(UI.IsMenuOpen() && Input.IsKeyPressed(0x1)){
      const mouse_pos = Global.GetCursorPosition();
      if (in_bounds(mouse_pos, x, y, x + 200, y + 40)) {
         if(!stored){
            x_offs = mouse_pos[0] - x;
            y_offs = mouse_pos[1] - y;
            stored = true;
         }
         UI.SetValue("Script items", "keybinds_x", mouse_pos[0] - x_offs);
         UI.SetValue("Script items", "keybinds_y", mouse_pos[1] - y_offs);
      }
   } else if(stored) stored = false;
}

UI.AddSliderInt("keybinds_x", 0, screen[0]);
UI.AddSliderInt("keybinds_y", 0, screen[1]);
UI.SetEnabled("Script items", "keybinds_x", false);
UI.SetEnabled("Script items", "keybinds_y", false);

Cheat.RegisterCallback("Draw", "keybinds");

