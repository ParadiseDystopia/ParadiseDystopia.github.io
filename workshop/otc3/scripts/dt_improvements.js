UI.AddMultiDropdown("Doubletap improvements", ["Recharge", "Two shot", "Prefer baim", "Prefer safepoint"])

//Doubletap improvements function
var can_shot = [];
function DT_improvements(){
    //Doubletap recharge function
    if(UI.GetDropdownvalue(UI.GetValue('Script items', 'Doubletap improvements'), 0)) {
        var me = Entity.GetLocalPlayer();
        var wpn = Entity.GetWeapon(me);
        var tickbase = Entity.GetProp(me, "CCSPlayer", "m_nTickBase");
        var curtime = Globals.TickInterval() * (tickbase-14)
        if (me == null || wpn == null || curtime < Entity.GetProp(me, "CCSPlayer", "m_flNextAttack") || curtime < Entity.GetProp(wpn, "CBaseCombatWeapon", "m_flNextPrimaryAttack")) can_shot = false
        else can_shot == true;

        var is_charged = Exploit.GetCharge()
        Exploit[(is_charged != 1 ? "Enable" : "Disable") + "Recharge"]()
        if (can_shot == true && is_charged != 1) {
            Exploit.DisableRecharge();
            Exploit.Recharge()
        }
    }
    else {
        Exploit.EnableRecharge();
    }
    //Two shot
    if (UI.GetDropdownvalue(UI.GetValue('Script items', 'Doubletap improvements'), 1) && UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && !UI.IsHotkeyActive('Script items', 'Damage override key')) {
        var weapon_name = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()))
        var enemyhp = Entity.GetProp(Ragebot.GetTarget(), "CPlayerResource", "m_iHealth");
        if (weapon_name == "g3sg1" || weapon_name == "scar 20") {
            Ragebot.ForceTargetMinimumDamage(Ragebot.GetTarget(), enemyhp/2)
        }
    }
    //Prefer baim on DT function
	if(UI.GetDropdownvalue(UI.GetValue('Script items', 'Doubletap improvements'), 2)) {
	    if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && UI.GetValue("Rage", "GENERAL", "Exploits", "Doubletap") && Exploit.GetCharge() === 1) UI.SetValue("Rage", "AUTO", "Accuracy", "Prefer body aim", 1);
    	else UI.SetValue("Rage", "AUTOSNIPER", "Accuracy", "Prefer body aim", 0);
    }
    //Prefer safepoint on DT function
    if(!UI.GetDropdownvalue(UI.GetValue('Script items', 'Doubletap improvements'), 3)) {
     	if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && UI.GetValue("Rage", "GENERAL", "Exploits", "Doubletap")) return;
	    enemies = Entity.GetEnemies();
        for (i = 0; i < enemies.length; i++) {
            if (!Entity.IsValid(enemies[i])) continue;
            if (!Entity.IsAlive(enemies[i])) continue;
            Ragebot.ForceTargetSafety(enemies[i]);
        }
    }
    
}

Cheat.RegisterCallback("CreateMove", "DT_improvements")

function doubletap_recharge_unload() {
    Exploit.EnableRecharge();
}

Cheat.RegisterCallback("Unload", "doubletap_recharge_unload");



UI.GetDropdownvalue = function(value, index) {
    var mask = 1 << index;
    return value & mask ? true : false;
}