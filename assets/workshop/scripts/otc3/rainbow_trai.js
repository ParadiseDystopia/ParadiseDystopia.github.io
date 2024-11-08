

var pos = []
function hsv2rgb(h,s,v){
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
    return [
        Math.round(r * 255),
        Math.round(g * 255),
        Math.round(b * 255),
        255
    ]
}
UI.AddLabel("-----------------------------------")
UI.AddSliderInt("Length", 0, 1000)
UI.AddLabel("-----------------------------------");
function cm(){
    var local = Entity.GetLocalPlayer()
    pos.unshift(Entity.GetRenderOrigin(local))
    var length = UI.GetValue("Misc", "JAVASCRIPT", "Script items", "Length")
    if(pos.length > length)
    {
        pos.pop()
    }
}
function draw(){
    var local = Entity.GetLocalPlayer()
    if(!Entity.IsAlive(local))
        return
    var first = true

    var last = []
    if(pos.length < 1)
        return
    for(i in pos)
    {
        var w2s = Render.WorldToScreen(pos[i])
        if(!first)
        {
            //Cheat.Print([w2s,last] + "\n")
            Render.Line(w2s[0],w2s[1],last[0],last[1],hsv2rgb((Globals.Realtime() + (i/200)) % 1, 1, 1))
          
        }
        first = false
        last = w2s
    }
}
function reset(){
    pos = []
}
Cheat.RegisterCallback("round_start", "reset")
Cheat.RegisterCallback("Draw", "draw")
Cheat.RegisterCallback("CreateMove", "cm")

