

UI.AddCheckbox("Watermark"), UI.AddColorPicker("Watermark color")
function waterskeet() {
    if (!UI.GetValue("MISC", "JAVASCRIPT", "Script Items", "Watermark")) return;
    var x = Global.GetScreenSize()[0] - 2;
    var today = new Date();
    const usernamea = Cheat.GetUsername();
    color = UI.GetColor("Misc", "JAVASCRIPT", "Script items", "Watermark color");
    var hours1 = today.getHours();
    var minutes1 = today.getMinutes();
    var seconds1 = today.getSeconds();
    var hours = hours1 <= 9 ? "0" + today.getHours() + ":" : today.getHours() + ":";
    var minutes = minutes1 <= 9 ? "0" + today.getMinutes() + ":" : today.getMinutes() + ":";
    var seconds = seconds1 <= 9 ? "0" + today.getSeconds() : today.getSeconds();
    var ping = Math.floor(Global.Latency() * 1000 / 1.5);
    var font = Render.AddFont("Verdana", 7, 400);
    var text = "gamesense [alpha] | " + usernamea + " | delay: " + ping + "| " + hours + minutes + seconds;
    var w = Render.TextSizeCustom(text, font)[0] + 8;
    x = x - w - 3;
    Render.GradientRect( x , 10, w / 2, 2, 1, [ 59, 175, 222, 255 ], [ 202, 70, 205, 255 ]);
    Render.FilledRect(x, 12, w, 16, [ 35, 35, 35, color[3] ]);
    Render.GradientRect( x + w / 2 , 10, w / 2, 2, 1, [ 202, 70, 205, 255 ], [ 201, 227, 58, 255 ]);
    Render.StringCustom( x + 4, 14, 0, text, [ 255, 255, 255, 255 ], font ); }
Cheat.RegisterCallback('Draw', 'waterskeet')

