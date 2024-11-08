UI.AddCheckbox("Team based model")
UI.AddDropdown("CT Model", ["None", "ctm_sas_variantf", "tm_pirate", "tm_balkan_variantk", "tm_balkan_variantl", "ctm_swat_variante", "ctm_swat_variantf", "tm_professional_varf", "tm_professional_varf2", "tm_anarchist_variantc", "tm_professional_varf4", "tm_professional_varh", "tm_balkan_variantb", "tm_professional_varj", "tm_balkan_variantd", "tm_balkan_variante", "ctm_swat_varianth", "tm_jumpsuit_variantb", "tm_jumpsuit_variantc", "tm_phoenix_varianti", "ctm_st6_variantj", "tm_professional_vari", "tm_professional_varg"])
UI.AddDropdown("T Model", ["None", "ctm_sas_variantf", "tm_pirate", "tm_balkan_variantk", "tm_balkan_variantl", "ctm_swat_variante", "ctm_swat_variantf", "tm_professional_varf", "tm_professional_varf2", "tm_anarchist_variantc", "tm_professional_varf4", "tm_professional_varh", "tm_balkan_variantb", "tm_professional_varj", "tm_balkan_variantd", "tm_balkan_variante", "ctm_swat_varianth", "tm_jumpsuit_variantb", "tm_jumpsuit_variantc", "tm_phoenix_varianti", "ctm_st6_variantj", "tm_professional_vari", "tm_professional_varg"])

var ctm_sas_variantf = "'TwoTimes' McCoy";
var tm_pirate = "Seal Team 6 Soldier";
var tm_balkan_variantk = "Buckshot";
var tm_balkan_variantl = "Lt. Commander Ricksaw";
var ctm_swat_variante = "Dragomir";
var ctm_swat_variantf = "Rezan The Ready";
var tm_professional_varf = "Maximus";
var tm_professional_varf2 = "Blackwolf";
var tm_anarchist_variantc = "The Doctor' Romanov";
var tm_professional_varf4 = "B Squadron Officer";
var tm_professional_varh = "3rd Commando Company";
var tm_balkan_variantb = "Special Agent Ava";
var tm_professional_varj = "Operator";
var tm_balkan_variantd = "Markus Delrow";
var tm_balkan_variante = "Michael Syfers";
var ctm_swat_varianth = "Enforcer";
var tm_jumpsuit_variantb = "Slingshot";
var tm_jumpsuit_variantc = "Soldier";
var tm_phoenix_varianti = "The Elite Mr. Muhlik";
var ctm_st6_variantj = "Ground Rebel";
var tm_professional_vari  = "Osiris";
var tm_professional_varg = "Prof. Shahmat";






function onFSN(){
    if(Cheat.FrameStage() != 2)
        return
    var team = Entity.GetProp(Entity.GetLocalPlayer(),"DT_BaseEntity", "m_iTeamNum")
    if(!UI.GetValue("Script Items", "Team based model")){
        UI.SetEnabled("Script Items", "CT Model", false)
        UI.SetEnabled("Script Items", "T Model", false)
        return;
    }
    UI.SetEnabled("Script Items", "T Model", true)
    UI.SetEnabled("Script Items", "CT Model", true)
    if(team == 2){ // T
        UI.SetValue("Misc", "SKINS", "Player", "Player model", UI.GetValue("Script Items", "T Model"))
    }
    else if(team == 3){ // CT
        UI.SetValue("Misc", "SKINS", "Player", "Player model", UI.GetValue("Script Items", "CT Model"))
    }
}
Cheat.RegisterCallback("FrameStageNotify","onFSN")