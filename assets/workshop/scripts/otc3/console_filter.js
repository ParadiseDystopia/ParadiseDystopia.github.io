UI.AddCheckbox("Console filter")

function consolefilter() {
    if (UI.GetValue("Script items", "Console filter")) {
        Cheat.ExecuteCommand("con_filter_enable 1 ");
        Cheat.ExecuteCommand("con_filter_text  out hajksddsnkjcakhkjash");
        Cheat.ExecuteCommand("con_filter_text  hjkasdhjadskdhasjkasd 1");
    }
}

Cheat.RegisterCallback("Draw", "consolefilter")


//Я мог использовать Convar.SetString и Convar.SetInt но мне так похуй

/*
con_filter_enable 1 
con_filter_text  out hajksddsnkjcakhkjash
con_filter_text  hjkasdhjadskdhasjkasd 1
*/