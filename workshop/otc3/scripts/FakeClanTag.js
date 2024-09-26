
var lasttime = 0;
var customtext = 0;
function time_to_ticks(time) {
	var timer = time / Globals.TickInterval() + .5;
	return timer;
}
var old_text_anim = 0;
function anim(texta, indices) {
	if(!World.GetServerString()) return;
	if(UI.GetValue("MISC", "JAVASCRIPT", "Script items", "elleqt tag"))
	{
		text_anim = "               " + texta + "                      ";
	}
	else
	{ 
		text_anim = "  ";
	}
	tickinterval = Globals.TickInterval();
	tickcount = Globals.Tickcount() + time_to_ticks(Local.Latency());
	ddd = tickcount / time_to_ticks(0.3);
	ddd = ddd % indices.length;
	ddd = indices[parseInt(ddd)]+1;
	text_anim = text_anim.slice(ddd, ddd+15);
	if(text_anim != old_text_anim)
	{
		Local.SetClanTag(text_anim);
	}
	old_text_anim = text_anim;
}

function clantag() {
	var clantag = UI.GetValue("MISC", "JAVASCRIPT", "Script items", "elleqt tag");
	if(clantag == 1)
	{
		customtext = "gamesense";
	}
	if(clantag == 2)
	{
		customtext = "onetap.su";
	}
	if(clantag == 3)
	{
		customtext = "nanosense";
	}
	if(clantag == 4)
	{
		customtext = "$ phack $";
	}
	if(clantag == 5)
	{
		customtext = "eexomi.host";
	}
	if(clantag == 6)
	{
		customtext = "memesense";
	}
	if(clantag == 7)
	{
		customtext = "katanaware";
	}
	if(clantag == 8)
	{
		customtext = Cheat.GetUsername();
	}
	if(clantag == 9)
	{
		customtext = "nerox.su";
	}
	if(clantag == 10)
	{
		customtext = "TrapSync";
	}
	anim(customtext, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,23])
}
UI.AddDropdown( "elleqt tag", [ "off", "gamesense", "onetap.su", "nanosense", "phack", "eexomi.host", "memesense", "katanaware", Cheat.GetUsername(), "nerox.su", "TrapSync" ] );
Cheat.RegisterCallback("Draw", "clantag");