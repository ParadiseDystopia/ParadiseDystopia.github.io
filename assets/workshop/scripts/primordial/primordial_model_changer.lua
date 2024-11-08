local panorama = require("primordial/Panorama Library.248")
local cast = ffi.cast

ffi.cdef [[
    typedef void*(__thiscall* shell_execute_t)(void*, const char*, const char*); 
]] 

cp = ffi.typeof('void***')
vgui = memory.create_interface('vgui2.dll', 'VGUI_System010')
ivgui = cast(cp,vgui)
ShellExecuteA = cast("shell_execute_t", ivgui[0][3])


local player_models = {
	{"Arctic", "models/player/custom_player/eminem/css/t_arctic.mdl", false},
	{"Black Ballas", "models/player/custom_player/caleon1/ballas1/ballas1.mdl", false},
	{"kurumi Tokisaki", "models/player/custom_player/bbs_93x_net_2015/kuangsan/update_2015_11_05/kuangsan.mdl", false},
	{"Schoolgirl Miyu", "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl", false},
	{"Wu zi mu", "models/player/custom_player/eminem/gta_sa/wuzimu.mdl", false},
	{"Model 1", "models/player/custom_player/eminem/gta_sa/bmybar.mdl", false},
	{"Ballas", "models/player/custom_player/eminem/gta_sa/ballas1.mdl", false},
	{"Grove Street", "models/player/custom_player/eminem/gta_sa/fam1.mdl", false},
	{"Dangerzone A", "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl", false},
	{"Dangerzone B", "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl", false},
	{"Dangerzone C", "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl", false},
	{"Among Us", "models/player/custom_player/owston/amongus/white.mdl", false},
	{"Helga", "models/player/custom_player/kuristaja/cso2/helga/helga.mdl", false},
	{"Simon Ghost Riley", "models/player/custom_player/legacy/zombie_ghost.mdl", false},
	{"Jett", "models/player/custom_player/night_fighter/valorant/jett/jett.mdl", false},
	{"Hutao", "models/player/custom_player/toppiofficial/genshin/rework/hutao.mdl", false},
	{"Putin", "models/player/custom_player/night_fighter/putin/putin.mdl", false},
	{"Neco Arc", "models/player/custom_player/wcsnik/necoarc/necoarc.mdl", false},
	{"Nekopara", "models/player/custom_player/toppiofficial/nekopara/vanilla_f1.mdl", false},
	{"Maverick", "models/player/custom_player/hekut/maverick/maverick_hekut.mdl", false},
	{"Rem", "models/player/custom_player/maoling/re0/rem/rem.mdl", false},
	{"Ram", "models/player/custom_player/maoling/re0/ram/ram.mdl", false},
	{"Nier 2B", "models/player/custom_player/legacy/gxp/nier/2b/2b_v1.mdl", false},
	{"Cardigan", "models/player/custom_player/toppiofficial/arknight/cardigan.mdl", false},
	{"Umbrella Leet", "models/player/custom_player/kirby/umbrella_leet/umbrella_leet3.mdl", false},
	{"Shadow Company", "models/player/custom_player/voikanaa/mw2/shadowcompany.mdl", false},
	{"Admin FBI", "models/player/custom_player/kirby/kumlafbi/kumlafbi.mdl", false},
	{"Leon S.K", "models/player/custom_player/darnias/leon_fix.mdl", false},
	{"Thug Leet", "models/player/custom_player/kirby/leetkumla/leetkumla.mdl", false},
	{"Astolfo", "models/player/custom_player/legacy/gxp/anime/astolfo/astolfo_v1.mdl", false},
	{"DVA", "models/player/custom_player/killzonegaming/dva/dva.mdl", false},
	{"Wraith", "models/player/custom_player/napas/apex/wraith_def_final_v3.mdl", false},
	{"UMP45", "models/player/custom_player/toppiofficial/gf/ump45.mdl", false},
	{"Daffy Duck", "models/player/custom_player/pakcan/daffy_duck/daffy_duck.mdl", false},
	{"Donald Trump", "models/player/custom_player/kuristaja/trump/trump.mdl", false},
	{"G Man", "models/player/custom_player/napas/source2/gman.mdl", false},
	{"Ghost Face", "models/player/custom_player/kaesar/ghostface/ghostface.mdl", false},
	{"Goku", "models/player/custom_player/kodua/goku/goku.mdl", false},
	{"GTA Blood", "models/player/custom_player/z-piks.ru/gta_blood.mdl", false},
	{"GTA Crip", "models/player/custom_player/z-piks.ru/gta_crip.mdl", false},
	{"Kim Jong Un", "models/player/custom_player/kuristaja/kim_jong_un/kim.mdl", false},
	{"Kirito", "models/player/custom_player/bbs_93x_net_2018/kirito/kirito_black.mdl", false},
	{"Tommi GTAVC", "models/player/custom_player/nf/gta/tommi.mdl", false},
	{"Trevor GTAV", "models/player/gtav/trevor.mdl", false},

	
  
}

local cs_teams = {
	{"Counter-Terrorist", false},
	{"Terrorist", true}
}

local ent_list = memory.create_interface("client.dll", "VClientEntityList003")
local entity_list_raw = ffi.cast("void***",ent_list)
local get_client_entity = ffi.cast("void*(__thiscall*)(void*,int)",memory.get_vfunc(ent_list,3))
local model_info_interface = memory.create_interface("engine.dll","VModelInfoClient004")
local raw_model_info = ffi.cast("void***",model_info_interface)
local get_model_index = ffi.cast("int(__thiscall*)(void*, const char*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",raw_model_info)),2))
local set_model_index_t = ffi.typeof("void(__thiscall*)(void*,int)")
--reversed for no reason cuz ducarii n i thought modelindex no worky
local set_model_index = ffi.cast(set_model_index_t, memory.find_pattern("client.dll","55 8B EC 8B 45 08 56 8B F1 8B 0D ?? ?? ?? ??"))


local team_references, team_model_paths = {}, {}
local model_index_prev

for i = 1, #cs_teams do
    local teamname, is_t = unpack(cs_teams[i])

    team_model_paths[is_t] = {}
    local model_names = {}

    for j = 1, #player_models do
        local model_name, model_path = unpack(player_models[j])
        table.insert(model_names, model_name)
        table.insert(team_model_paths[is_t], model_path)
    end

    -- Discord invite function
    local function open_discord_invite()
        ShellExecuteA(ivgui, 'open', "https://discord.gg/rPW3FSApZR")
    end

    team_references[is_t] = {
        love_primordial_reference = menu.add_text("Custom Model Changer by Sxn1y", "For Primordial With Love <3"),
        warning_reference = menu.add_text("Custom Model Changer by Sxn1y", "Don't forget to disable CS:GO's agents"),
        discord_reference = menu.add_button("Custom Model Changer by Sxn1y", "Discord Invite", open_discord_invite),
        model_reference = menu.add_list("Custom Models", "Player Models", model_names, 20)
    }
    for _, v in pairs(team_references[is_t]) do
        v:set_visible(false)
    end
end

local function do_model_change()
    local local_player = entity_list.get_local_player()

    if local_player == nil or not local_player:is_alive() then
        return
    end

    local player_ptr = ffi.cast("void***", get_client_entity(entity_list_raw, local_player:get_index()))
    local set_model_idx = ffi.cast(set_model_index_t, memory.get_vfunc(tonumber(ffi.cast("unsigned int", player_ptr)), 75))

    if player_ptr == nil or set_model_idx == nil then
        return
    end

    local model_path, model_index
    local teamnum = local_player:get_prop("m_iTeamNum")
    local is_t = teamnum == 2

    for references_is_t, references in pairs(team_references) do
        references.love_primordial_reference:set_visible(references_is_t == is_t)
        references.discord_reference:set_visible(references_is_t == is_t)
        references.warning_reference:set_visible(references_is_t == is_t)
        if references_is_t == is_t then
            references.model_reference:set_visible(true)
            model_path = team_model_paths[is_t][tonumber(references.model_reference:get())]
        else
            references.model_reference:set_visible(false)
        end
    end

    if model_path ~= nil then
        model_index = get_model_index(raw_model_info, model_path)
        if model_index == -1 then
            model_index = nil
        end
    end

    if model_index == nil and model_path ~= nil then
        client.precache_model(model_path)
    end

    model_index_prev = model_index

    if model_index ~= nil then
        set_model_idx(player_ptr, model_index)
    end
end

callbacks.add(e_callbacks.NET_UPDATE, do_model_change)