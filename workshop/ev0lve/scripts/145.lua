--region menu
    ---@item healthbar
        local healthbar_text = gui.label('healthbar_text', 'visuals.local.viewmodel', 'Healthbar -----------------------------------');
        local healthbar_text_color = gui.color_picker('healthbar_text_color', 'visuals.local.viewmodel', 'Text color', render.color(255,255,255,255));
        local healthbar_text2_color = gui.color_picker('healthbar_text2_color', 'visuals.local.viewmodel', 'Text2 color', render.color(255,255,255,255));
        local healthbar_bar_color = gui.color_picker('healthbar_bar_color', 'visuals.local.viewmodel', 'Bar color', render.color(255,255,255,255));
        local healthbar_bar_out_color = gui.color_picker('healthbar_bar_out_color', 'visuals.local.viewmodel', 'Bar outline color', render.color(255,255,255,255));
        local healthbar_bg_color = gui.color_picker('healthbar_bg_color', 'visuals.local.viewmodel', 'Bg color', render.color(18,18,18,100));
    ---@item armorbar
        local armorbar_text = gui.label('armorbar_text', 'visuals.local.viewmodel', 'Armorbar ------------------------------------');
        local armorbar_text_color = gui.color_picker('armorbar_text_color', 'visuals.local.viewmodel', 'Text color', render.color(255,255,255,255));
        local armorbar_text2_color = gui.color_picker('armorbar_text2_color', 'visuals.local.viewmodel', 'Text2 color', render.color(255,255,255,255));

        local armorbar_bar_color = gui.color_picker('armorbar_bar_color', 'visuals.local.viewmodel', 'Bar color', render.color(255,255,255,255));
        local armorbar_bar_out_color = gui.color_picker('armorbar_bar_out_color', 'visuals.local.viewmodel', 'Bar outline color', render.color(255,255,255,255));
        local armorbar_bg_color = gui.color_picker('armorbar_bg_color', 'visuals.local.viewmodel', 'Bg color', render.color(18,18,18,100));
    ---@item inventory
        local inventory_text = gui.label('inventory_text', 'visuals.local.viewmodel', 'Inventory -----------------------------------');
        local inventory_icon_active = gui.color_picker('inventory_icon_active', 'visuals.local.viewmodel', 'Weapon active', render.color(255,255,255,255));
        local inventory_icon_dormant = gui.color_picker('inventory_icon_dormant', 'visuals.local.viewmodel', 'Weapon dormant', render.color(255,255,255,140));
        local inventory_icon_not_inv = gui.color_picker('inventory_icon_not_inv', 'visuals.local.viewmodel', 'Weapon non inven.', render.color(255,255,255,100));
        local inventory_bullet_act = gui.color_picker('inventory_bullet_act', 'visuals.local.viewmodel', 'Bullet active', render.color(255,255,255,255));
        local inventory_bullet_rech = gui.color_picker('inventory_bullet_rech', 'visuals.local.viewmodel', 'Bullet charge', render.color(255,255,255,255));
        local inventory_kill_icon = gui.color_picker('inventory_kill_icon', 'visuals.local.viewmodel', 'Kill icon', render.color(255,255,255,255));
        local inventory_kill_counter = gui.color_picker('inventory_kill_counter', 'visuals.local.viewmodel', 'Kill counter', render.color(255,255,255,255));
        local inventory_bg_color = gui.color_picker('inventory_bg_color', 'visuals.local.viewmodel', 'Bg color', render.color(18,18,18,100));
    ---@item killfeed
        local killfeed_text = gui.label('killfeed_text', 'visuals.local.viewmodel', 'Killfeed ------------------------------------');
        local killfeed_attacker_color = gui.color_picker('killfeed_attacker_color', 'visuals.local.viewmodel', 'Attacker', render.color(255,255,255,255));
        local killfeed_weapon_color = gui.color_picker('killfeed_weapon_color', 'visuals.local.viewmodel', 'Weapon', render.color(255,255,255,255));
        local killfeed_hs_color = gui.color_picker('killfeed_hs_color', 'visuals.local.viewmodel', 'Headshot', render.color(255,255,255,255));
        local killfeed_attacked_color = gui.color_picker('killfeed_attacked_color', 'visuals.local.viewmodel', 'Attacked', render.color(255,255,255,255));
        local killfeed_bg_color = gui.color_picker('killfeed_bg_color', 'visuals.local.viewmodel', 'Bg color', render.color(18,18,18,100));
        -- local killfeed_bg_act_color = gui.color_picker('killfeed_bg_act_color', 'visuals.local.viewmodel', 'Bg active color', render.color(18,18,18,100));
    ---@item other
        local other_text = gui.label('other_text', 'visuals.local.viewmodel', 'Other ---------------------------------------');
        local other_counter_t_color = gui.color_picker('other_counter_t_color', 'visuals.local.viewmodel', 'Counter T', render.color(255,55,55,255));
        local other_counter_ct_color = gui.color_picker('other_counter_ct_color', 'visuals.local.viewmodel', 'Counter CT', render.color(102,186,255,255));
        local other_counter_bg = gui.color_picker('other_counter_bg', 'visuals.local.viewmodel', 'Counter bg color', render.color(18,18,18,100));
        local other_chat_text = gui.color_picker('other_chat_text', 'visuals.local.viewmodel', 'Chat text color', render.color(255,255,255,255));
        local other_chat_bg = gui.color_picker('other_chat_bg', 'visuals.local.viewmodel', 'Chat bg color', render.color(18,18,18,100));
        local other_crosshair_color = gui.color_picker('other_crosshair_color', 'visuals.local.viewmodel', 'Crosshair color', render.color(255,255,255,255));

--endregion

--region font
    local verdana_14 = render.create_font('ev0lve/scripts/hud/fonts/verdana.ttf', 14, render.font_flag_shadow);
    local verdana_20 = render.create_font('ev0lve/scripts/hud/fonts/verdana.ttf', 20, render.font_flag_shadow);
    local verdana_30 = render.create_font('ev0lve/scripts/hud/fonts/verdana.ttf', 30, render.font_flag_shadow);
    local verdana_12 = render.create_font('ev0lve/scripts/hud/fonts/verdana.ttf', 12, render.font_flag_shadow);
    local weapon_icon = render.create_font('ev0lve/scripts/hud/fonts/weapon_new.ttf', 28, render.font_flag_shadow);
    local icon_small = render.create_font('ev0lve/scripts/hud/fonts/weapon_new.ttf', 12, render.font_flag_shadow);
--endregion

--region icon
    local icon_ct = render.create_texture('ev0lve/scripts/hud/icons/ct.png')
    local icon_t = render.create_texture('ev0lve/scripts/hud/icons/t.png')
--endregion icon

--region array
    local renderer = {}
    local round_start_array = {}
    local counter = {ct_players = 0;t_players = 0;}
    local round_end_array = {}
    local chat_message_array = {}
    local killfeed_array = {}
    local animation = {data = {}}
--endregion

--region help
    
    local screen = {render.get_screen_size()}
    local x,y = screen[1], screen[2]

    local killed_enemy = 0
    local round_end = false

    function table.count(tbl)
        if tbl == nil then 
            return 0 
        end

        if #tbl == 0 then 
            local count = 0

            for data in pairs(tbl) do 
                count = count + 1 
            end

            return count 
        end
        return #tbl
    end

    function table.clear( tbl )
        for key in pairs( tbl ) do
        tbl[key] = nil
        end
    end

    function animation.lerp(start, end_pos, time)
        if (type(start) == "table") then
            local color_data = {0, 0, 0, 0}

            for i, color_key in ipairs({"r", "g", "b", "a"}) do
                color_data[i] = animation.lerp(start[color_key], end_pos[color_key], time)
            end

            return render.color(unpack(color_data))
        end

        return (end_pos - start) * (global_vars.frametime * time) + start
    end

    function animation.new(name, value, time)
        if (animation.data[name] == nil) then
            animation.data[name] = value
        end

        animation.data[name] = animation.lerp(animation.data[name], value, time)

        return animation.data[name]
    end

    ---@item renderer
        function renderer.rect_filled(pos, size, color1, round, round_flags)
            local start_x, start_y = pos.x, pos.y
            local end_x, end_y = start_x + size.x, start_y + size.y

            if (round ~= nil) then
                render.rect_filled_rounded(start_x, start_y, end_x, end_y, color1, round, round_flags or render.all)
                return
            end
        
            return render.rect_filled(start_x, start_y, end_x, end_y, color1)
        end

        function renderer.rect(pos, size, color1, round, thickness)
            local start_x, start_y = pos.x, pos.y
            local end_x, end_y = start_x + size.x, start_y + size.y
            if (thickness == nil) then
                thickness = 1 --render.all
            end

            if (round ~= nil) then
                render.rect_rounded(start_x, start_y, end_x, end_y, color1, round, render.all, thickness)
                return
            end
        
            return render.rect(start_x, start_y, end_x, end_y, color1, thickness)
        end

        function renderer.rect_filled_mulitcolor(pos, size, color1, color2, color3, color4)
            local start_x, start_y = pos.x, pos.y
            local end_x, end_y = start_x + size.x, start_y + size.y

            
            return render.rect_filled_multicolor(start_x, start_y, end_x, end_y, color1, color2, color3, color4)
        end

        function renderer.blur(pos, size, round, round_flags)
            local start_x, start_y = pos.x, pos.y
            local end_x, end_y = start_x + size.x, start_y + size.y

            if (round ~= nil) then
                render.blur(start_x, start_y, end_x, end_y, function()
                    render.rect_filled_rounded(start_x, start_y, end_x, end_y, render.color(255,255,255,255), round, round_flags or render.all);
                end);
                return
            end

            render.blur(start_x, start_y, end_x, end_y, function ()
                render.rect_filled(start_x, start_y, end_x, end_y, render.color(255,255,255,255));
            end);

            return
        end

--endregion

--region inventory
    ---@item inventory variables
        local max_value = 0
        local second_value = 0
        local mele_value = 0
        local taser_value = 0
        local inferno_value = 0
        local he_grenade_value = 0
        local smoke_grenade_value = 0
        local flash_grenade_value = 0
        local healthshot_value = 0
        local c4_value = 0
    ---@item weapon to icon
        function weapon_to_font(weapon_name, primary, secondary, mele, inferno, he_grenade, smoke_grenade, flashbang, taser, healthshot, other, decoy)
            local latter = "UNK"
            local name = "UNK"

            if (weapon_name == 'CWeaponSSG08') and primary then
                latter = '<';
                name = 'scout';
            elseif (weapon_name == 'CWeaponAWP') and primary then
                latter = '9';
                name = 'awp';
            elseif (weapon_name == 'CWeaponG3SG1') and primary then
                latter = ':';
                name = 'G3SG1';
            elseif (weapon_name == 'CWeaponSCAR20') and primary then
                latter = ';';
                name = 'Scar20';
            elseif (weapon_name == 'CWeaponMAC10') and primary then
                latter = ',';
                name = 'MAC10';
            elseif (weapon_name == 'CWeaponMP9') and primary then
                latter = '-';
                name = 'MP9';
            elseif (weapon_name == 'CWeaponMP7') and primary then
                latter = '0';
                name = 'MP7';
            elseif (weapon_name == 'CWeaponUMP45') and primary then
                latter = '/';
                name = 'UMP45';
            elseif (weapon_name == 'CWeaponBizon') and primary then
                latter = '.';
                name = 'BIZON';
            elseif (weapon_name == 'CWeaponP90') and primary then
                latter = '1';
                name = 'P90';
            elseif (weapon_name == 'CWeaponGalilAR') and primary then
                latter = '8';
                name = 'Galilar';
            elseif (weapon_name == 'CWeaponFamas') and primary then
                latter = '7';
                name = 'Famas';
            elseif (weapon_name == 'CAK47') and primary then
                latter = '4';
                name = 'ak47';
            elseif (weapon_name == 'CWeaponM4A1') and primary then
                latter = '3';
                name = 'm4a4';
            elseif (weapon_name == 'CWeaponSG556') and primary then
                latter = '5';
                name = 'sg556';
            elseif (weapon_name == 'CWeaponAug') and primary then
                latter = '6';
                name = 'aug';
            elseif (weapon_name == 'CWeaponNOVA') and primary then
                latter = '?';
                name = 'CWeaponNOVA';
            elseif (weapon_name == 'CWeaponXM1014') and primary then
                latter = 'A';
                name = 'CWeaponXM1014';
            elseif (weapon_name == 'CWeaponSawedoff') and primary then
                latter = '@';
                name = 'CWeaponSawedoff';
            elseif (weapon_name == 'CWeaponMag7') and primary then
                latter = 'B';
                name = 'CWeaponMag7';
            elseif (weapon_name == 'CWeaponM249') and primary then
                latter = '=';
                name = 'CWeaponM249';
            elseif (weapon_name == 'CWeaponNegev') and primary then
                latter = '>';
                name = 'CWeaponNegev';

            elseif (weapon_name == 'CWeaponGlock') and secondary then
                latter = '$';
                name = 'CWeaponGlock';
            elseif (weapon_name == 'CWeaponP250') and secondary then
                latter = '%';
                name = 'CWeaponP250';
            elseif (weapon_name == 'CWeaponFiveSeven') and secondary then
                latter = '#';
                name = 'CWeaponP250';
            elseif (weapon_name == 'CDEagle') and secondary then
                latter = '!';
                name = 'deagle'
            elseif (weapon_name == 'CWeaponElite') and secondary then
                latter = '"';
                name = 'CWeaponElite'
            elseif (weapon_name == 'CWeaponTec9') and secondary then
                latter = '&';
                name = 'CWeaponTec9'
            elseif (weapon_name == 'CWeaponHKP2000') and secondary then
                latter = '(';
                name = 'CWeaponHKP2000'
            elseif (weapon_name == 'CKnife') and mele then
                latter = 'R';
                name = 'knife'  
            elseif (weapon_name == 'CMolotovGrenade' or weapon_name == 'CIncendiaryGrenade') and inferno then
                latter = 'D';
                name = 'molotov'
            elseif (weapon_name == 'CHEGrenade') and he_grenade then
                latter = 'H';
                name = 'hegrenade'
            elseif (weapon_name == 'CSmokeGrenade') and smoke_grenade then
                latter = 'E';
                name = 'smoke'
            elseif (weapon_name == 'CFlashbang') and flashbang then
                latter = 'G';
                name = 'CFlashbang'
            elseif (weapon_name == 'CDecoyGrenade') and decoy then
                latter = 'F';
                name = 'CDecoyGrenade'
            elseif (weapon_name == 'CWeaponTaser') and taser then
                latter = '^';
                name = 'taser'
            elseif (weapon_name == 'CItem_Healthshot') and healthshot then
                latter = 'f';
                name = 'CItem_Healthshot'
            elseif (weapon_name == 'CC4') and other then
                latter = 'o';
                name = 'CC4'
            end

            return latter, name
        end
    ---@item inventory setup
        function invetory_setup()
            ---@item weapon variables
                if entities.get_entity(engine.get_local_player()) == nil then return end
                local player = entities.get_entity(engine.get_local_player())
                local current_weapon = entities.get_entity_from_handle(player:get_prop('m_hActiveWeapon'))
                local primary  = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", max_value))
                local secondary = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", second_value))
                local mele = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", mele_value))
                local taser = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", taser_value))
                local inferno = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", inferno_value))
                local he_grenade = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", he_grenade_value))
                local smoke_grenade = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", smoke_grenade_value))
                local flash_grenade = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", flash_grenade_value))
                local healthshot = entities.get_entity_from_handle(player:get_prop('m_hMyWeapons', healthshot_value))
                local c4 = entities.get_entity_from_handle(player:get_prop("m_hMyWeapons", c4_value))


                local primary_held = false
                local secondary_hold = false
                local mele_hold = false
                local taser_hold = false
                local inferno_hold = false
                local he_grenade_hold = false
                local smoke_grenade_hold = false
                local flash_grenade_hold = false
                local healthshot_hold = false
                local c4_hold = false

                if (primary == nil) then max_value = 0 end
                if (secondary == nil) then second_value = 0 end
                if (mele == nil) then mele_value = 0 end
                if (taser == nil) then taser_value = 0 end

                if (inferno == nil) then inferno_value = 0 end
                if (he_grenade == nil) then he_grenade_value = 0 end
                if (smoke_grenade == nil) then smoke_grenade_value = 0 end
                if (flash_grenade == nil) then flash_grenade_value = 0 end
                if (healthshot == nil) then healthshot_value = 0 end
                if (c4 == nil) then c4_value = 0 end

                local height = 0
                local secondary_ukn_animation = animation.new('secondary_ukn_animation', (latter_secondary == 'UNK') and height + 45 or height, 12)

            ---@item weapon render
                if entities.get_entity(engine.get_local_player()) == nil then return end
                local primaty_animation = animation.new('primaty_animation', (latter_primary ~= 'UNK') and 1 or 0, 5)
                local secondary_animation = animation.new('secondary_animation', (latter_secondary ~= 'UNK') and 1 or 0, 5)
                local icon_active = inventory_icon_active:get()
                local icon_dormant = inventory_icon_dormant:get()
                local icon_not_inv = inventory_icon_not_inv:get()
                local bullet_act = inventory_bullet_act:get()
                local bullet_rech = inventory_bullet_rech:get()
                local kill_icon = inventory_kill_icon:get()
                local kill_counter = inventory_kill_counter:get()
                local bg_color = inventory_bg_color:get()

            -- renderer.rect_filled(math.vec3(600,600), math.vec3(150, 40), icon_active)


                if (primary ~= nil) then
                    latter_primary = 'UNK'
                    if (weapon_to_font(primary:get_class(), true, false, false, false, false, false, false, false, false, false) ~= "UNK") then
                        latter_primary, name_primary = weapon_to_font(primary:get_class(), true, false, false, false, false, false, false, false, false, false)
                    else
                        max_value = max_value + 1   
                    end


                    local cp = primary:get_class()
                    if (latter_primary ~= 'UNK') then
                        render.set_alpha(primaty_animation);

                            renderer.blur(math.vec3(x - 150, y - 240 + secondary_ukn_animation), math.vec3(150, 40))
                            renderer.rect_filled(math.vec3(x - 150, y - 240 + secondary_ukn_animation), math.vec3(150, 40), bg_color)

                            local primary_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant
                            
                            render.text(weapon_icon, x - 110, y - 230 + secondary_ukn_animation, tostring(latter_primary), primary_color)

                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                                primary_held = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (secondary ~= nil) then
                    latter_secondary = 'UNK'
                    if (weapon_to_font(secondary:get_class(), false, true, false, false, false, false, false, false, false, false) ~= "UNK") then
                        latter_secondary, name_secondary = weapon_to_font(secondary:get_class(), false, true, false, false, false, false, false, false, false, false)
                    else
                        second_value = second_value + 1   
                    end


                    local cp = secondary:get_class()

                    if (latter_secondary ~= 'UNK') then
                        render.set_alpha(secondary_animation)
                            local secondary_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            renderer.blur(math.vec3(x - 150, y - 195), math.vec3(150, 40))
                            renderer.rect_filled(math.vec3(x - 150, y - 195), math.vec3(150, 40), bg_color)

                            render.text(weapon_icon, x - 110, y - 185, tostring(latter_secondary), secondary_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                                secondary_hold = true;
                            end
                        render.pop_alpha()
                    end
                end
                
                if (mele ~= nil) then
                    latter_mele = 'UNK'
                    if (weapon_to_font(mele:get_class(), false, false, true, false, false, false, false, false, false, false) ~= "UNK") then
                        latter_mele, name_mele = weapon_to_font(mele:get_class(), false, false, true, false, false, false, false, false, false, false)
                    else
                        mele_value = mele_value + 1   
                    end


                    local cp = mele:get_class()

                    if (latter_mele ~= 'UNK') then
                        local mele_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant


                        renderer.blur(math.vec3(x - 150, y - 150), math.vec3(150, 40))
                        renderer.rect_filled(math.vec3(x - 150, y - 150), math.vec3(150, 40), bg_color)

                        render.text(weapon_icon, x - 110, y - 140, tostring(latter_mele), mele_color)
                        if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                            mele_hold = true;
                        end
                    end
                end

            ---@item nade render
                if entities.get_entity(engine.get_local_player()) == nil then return end
                if not entities.get_entity(engine.get_local_player()):is_alive() then return end
                local inferno_animation = animation.new('inferno_animation', (latter_inferno ~= 'UNK') and 1 or 0, 5)
                local he_grenade_animation = animation.new('he_grenade_animation', (latter_he_grenade ~= 'UNK') and 1 or 0, 5)
                local smoke_animation = animation.new('smoke_animation', (latter_smoke_grenade ~= 'UNK') and 1 or 0, 5)
                local flash_animation = animation.new('flash_animation', (latter_flash_grenade ~= 'UNK') and 1 or 0, 5)
                local healthshot_animation = animation.new('healthshot_animation', (latter_healthshot ~= 'UNK') and 1 or 0, 5)
                local c4_animation = animation.new('c4_animation', (latter_c4 ~= 'UNK') and 1 or 0, 5)
                local taser_animation = animation.new('taser_animation', (latter_taser ~= 'UNK') and 1 or 0, 5)

                renderer.blur(math.vec3(x - 150, y - 105), math.vec3(150, 40))
                renderer.rect_filled(math.vec3(x - 150, y - 105), math.vec3(150, 40), bg_color)
                
                renderer.blur(math.vec3(x - 150, y - 60), math.vec3(150, 40))
                renderer.rect_filled(math.vec3(x - 150, y - 60), math.vec3(150, 40), bg_color)

                render.text(weapon_icon, x - 30, y - 95, tostring('D'), icon_not_inv) --molly
                render.text(weapon_icon, x - 60, y - 95, tostring('H'), icon_not_inv) --he
                render.text(weapon_icon, x - 85, y - 95, tostring('E'), icon_not_inv) --smoke
                render.text(weapon_icon, x - 120, y - 95, tostring('G'), icon_not_inv) --flash

                render.text(weapon_icon, x - 40, y - 52, tostring('f'), icon_not_inv)
                render.text(weapon_icon, x - 70, y - 50, tostring('o'), icon_not_inv)
                render.text(weapon_icon, x - 120, y - 50, tostring('^'), icon_not_inv)



                if (inferno ~= nil) then
                    latter_inferno = 'UNK'
                    if (weapon_to_font(inferno:get_class(), false, false, false, true, false, false, false, false, false, false, false) ~= "UNK") then
                        latter_inferno, name_inferno = weapon_to_font(inferno:get_class(), false, false, false, true, false, false, false, false, false, false, false)
                    else
                        inferno_value = inferno_value + 1   
                    end

                    local cp = inferno:get_class()
                    if (latter_inferno ~= 'UNK') then
                        render.set_alpha(inferno_animation)
                            local inferno_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 30, y - 95, tostring(latter_inferno), inferno_color)

                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                                inferno_hold = true;
                            end
                        render.pop_alpha()

                    end
                end

                if (he_grenade ~= nil) then
                    latter_he_grenade = 'UNK'
                    if (weapon_to_font(he_grenade:get_class(), false, false, false, false, true, false, false, false, false, false, false) ~= "UNK") then
                        latter_he_grenade, name_he_grenade = weapon_to_font(he_grenade:get_class(), false, false, false, false, true, false, false, false, false, false, false)
                    else
                        he_grenade_value = he_grenade_value + 1   
                    end


                    local cp = he_grenade:get_class()

                    if (latter_he_grenade ~= 'UNK') then
                        render.set_alpha(he_grenade_animation)
                            local he_grenade_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 60, y - 95, tostring(latter_he_grenade), he_grenade_color)

                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                                he_grenade_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (smoke_grenade ~= nil) then
                    latter_smoke_grenade = 'UNK'
                    if (weapon_to_font(smoke_grenade:get_class(), false, false, false, false, false, true, false, false, false, false, false) ~= "UNK") then
                        latter_smoke_grenade, name_smoke_grenade = weapon_to_font(smoke_grenade:get_class(), false, false, false, false, false, true, false, false, false, false, false)
                    else
                        smoke_grenade_value = smoke_grenade_value + 1   
                    end


                    local cp = smoke_grenade:get_class()

                    if (latter_smoke_grenade ~= 'UNK') then
                        render.set_alpha(smoke_animation)
                            local smoke_grenade_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 85, y - 95, tostring(latter_smoke_grenade), smoke_grenade_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then

                                smoke_grenade_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (flash_grenade ~= nil) then
                    latter_flash_grenade = 'UNK'
                    if (weapon_to_font(flash_grenade:get_class(), false, false, false, false, false, false, true, false, false, false, false) ~= "UNK") then
                        latter_flash_grenade, name_flash_grenade = weapon_to_font(flash_grenade:get_class(), false, false, false, false, false, false, true, false, false, false, false)
                    else
                        flash_grenade_value = flash_grenade_value + 1   
                    end


                    local cp = flash_grenade:get_class()

                    if (latter_flash_grenade ~= 'UNK') then
                        render.set_alpha(flash_animation)
                            local flash_grenade_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 115, y - 95, tostring(latter_flash_grenade), flash_grenade_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then

                                flash_grenade_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (healthshot ~= nil) then
                    latter_healthshot = 'UNK'
                    if (weapon_to_font(healthshot:get_class(), false, false, false, false, false, false, false, false, true, false, false) ~= "UNK") then
                        latter_healthshot, name_healthshot = weapon_to_font(healthshot:get_class(), false, false, false, false, false, false, false, false, true, false, false)
                    else
                        healthshot_value = healthshot_value + 1   
                    end


                    local cp = healthshot:get_class()

                    if (latter_healthshot ~= 'UNK') then
                        render.set_alpha(healthshot_animation)
                            local healthshot_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 40, y - 52, tostring(latter_healthshot), healthshot_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then

                                healthshot_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (c4 ~= nil) then
                    latter_c4 = 'UNK'
                    if (weapon_to_font(c4:get_class(), false, false, false, false, false, false, false, false, false, true, false) ~= "UNK") then
                        latter_c4, name_c4 = weapon_to_font(c4:get_class(), false, false, false, false, false, false, false, false, false, true, false)
                    else
                        c4_value = c4_value + 1   
                    end


                    local cp = c4:get_class()

                    if (latter_c4 ~= 'UNK') then
                        render.set_alpha(c4_animation)
                            local c4_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant

                            render.text(weapon_icon, x - 70, y - 50, tostring(latter_c4), c4_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then

                                c4_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

                if (taser ~= nil) then
                    latter_taser = 'UNK'
                    if (weapon_to_font(taser:get_class(), false, false, false, false, false, false, false, true, false, false) ~= "UNK") then
                        latter_taser, name_taser = weapon_to_font(taser:get_class(), false, false, false, false, false, false, false, true, false, false)
                    else
                        taser_value = taser_value + 1   
                    end


                    local cp = taser:get_class()

                    if (latter_taser ~= 'UNK') then
                        render.set_alpha(taser_animation)
                            local taser_color = (current_weapon ~= nil and cp == current_weapon:get_class()) and icon_active or icon_dormant
                            render.text(weapon_icon, x - 120, y - 50, tostring(latter_taser), taser_color)
                            if (current_weapon ~= nil and cp == current_weapon:get_class()) then
                                taser_hold = true;
                            end
                        render.pop_alpha()
                    end
                end

            ---@item ammo hud render
                if entities.get_entity(engine.get_local_player()) == nil then return end
                if not entities.get_entity(engine.get_local_player()):is_alive() then return end
                if current_weapon == nil then return end
                if (current_weapon:get_class() ~= nil) then
                    latter, name = weapon_to_font(current_weapon:get_class(), true, true, true, true, true, true, true, true, true, true, true)
                    local weapon_size = render.get_text_size(weapon_icon, latter)
                    local hour,minute = utils.get_time().hour, utils.get_time().min
                    local clip_text = (current_weapon:get_prop('m_iClip1') <= -1) and string.format("%02d", hour) or tostring(current_weapon:get_prop('m_iClip1'))
                    local primary_text = (current_weapon:get_prop('m_iClip1') <= -1) and string.format("%02d", minute) or tostring(current_weapon:get_prop('m_iPrimaryReserveAmmoCount'))  


                    renderer.blur(math.vec3(x / 2 - 55, y - 60), math.vec3(110, 40))
                    renderer.rect_filled(math.vec3(x / 2 - 55, y - 60), math.vec3(110, 40), bg_color)
                    render.text(weapon_icon, (x / 2 - weapon_size / 2 ), y - 50, tostring(latter), icon_active)

                    renderer.blur(math.vec3(x / 2 + 60, y - 60), math.vec3(40, 40))
                    renderer.rect_filled(math.vec3(x / 2 + 60, y - 60), math.vec3(40, 40), bg_color)
                    render.text(verdana_12, x / 2 + 75, y - 55, clip_text, bullet_act)
                    render.text(verdana_12, x / 2 + 75, y - 39, primary_text, bullet_rech)

                    
                    renderer.blur(math.vec3(x / 2 - 100, y - 60), math.vec3(40, 40))
                    renderer.rect_filled(math.vec3(x / 2 - 100, y - 60), math.vec3(40, 40), bg_color)

                    render.text(verdana_12, x / 2 - 85, y - 39, string.format("%02d", killed_enemy), kill_counter)
                    render.text(icon_small, x / 2 - 84, y - 53, 'h', kill_icon)
                end
            
        end

--endregion

--region hp and ap bar
    ---@item bar background
        function bars_background()

            local health_bg_color = healthbar_bg_color:get()
            local armor_bg_color = armorbar_bg_color:get()


            if entities.get_entity(engine.get_local_player()) == nil then return end
            if not entities.get_entity(engine.get_local_player()):is_alive() then return end
            renderer.blur(math.vec3(0, y - 60), math.vec3(185, 40))
            renderer.rect_filled(math.vec3(0, y - 60), math.vec3(185, 40), health_bg_color)

            renderer.blur(math.vec3(0, y - 105), math.vec3(185, 40))
            renderer.rect_filled(math.vec3(0, y - 105), math.vec3(185, 40), armor_bg_color)
        end
    ---@item bar
        function health_bar_setup()
            if entities.get_entity(engine.get_local_player()) == nil then return end
            if not entities.get_entity(engine.get_local_player()):is_alive() then return end
            local player = entities.get_entity(engine.get_local_player())

            local health_color = healthbar_text_color:get()
            local health_text_color = healthbar_text2_color:get()
            local health_bar_color = healthbar_bar_color:get()
            local health_bar_out_color = healthbar_bar_out_color:get()



            local health = player:get_prop('m_iHealth')
            if health > 100 then health = 100 end

            local animation_health_bar = animation.new('animation_health_bar', health, 8)
            local animation_health_nul = animation.new('animation_health_nul', health <= 0 and 0 or 1, 8)
            local bar_width = animation_health_bar
            local bar_height = 10
            renderer.rect(math.vec3(68, y - 47), math.vec3(104, bar_height + 4), health_bar_out_color)
            renderer.rect_filled(math.vec3(70, y - 45), math.vec3(bar_width, bar_height), health_bar_color)

            render.text(verdana_12, 10, y - 45, 'HP', health_text_color)
            render.text(verdana_20, 30, y - 50, tostring(health), health_color)
        end
        function armor_bar_setup()
            if entities.get_entity(engine.get_local_player()) == nil then return end
            if not entities.get_entity(engine.get_local_player()):is_alive() then return end
            local player = entities.get_entity(engine.get_local_player())

            local armorbar_color = armorbar_text_color:get()
            local armorbar_text_color = armorbar_text2_color:get()
            local armorbar_bar_color = armorbar_bar_color:get()
            local armorbar_bar_out_color = armorbar_bar_out_color:get()

            local armor = player:get_prop('m_ArmorValue')
            if armor > 100 then armor = 100 end

            local animation_armor_bar = animation.new('animation_armor_bar', armor, 8)
            local animation_armor_nul = animation.new('animation_armor_nul', armor <= 0 and 0 or 1, 8)
            local bar_width = animation_armor_bar
            local bar_height = 10

            renderer.rect(math.vec3(68, y - 92), math.vec3(104, bar_height + 4), armorbar_bar_out_color)
            renderer.rect_filled(math.vec3(70, y - 90), math.vec3(bar_width, bar_height), armorbar_bar_color)

            render.text(verdana_12, 10, y - 90, 'AP', armorbar_text_color)
            render.text(verdana_20, 30, y - 95, tostring(armor), armorbar_color)
        end

--endregion

--region game period render

    function game_period_setup()
        ---@item variables
            if entities.get_entity(engine.get_local_player()) == nil then return end
            local is_warmup_period = game_rules.is_warmup_period
            local is_paused = game_rules.is_paused
            local period_text = 'nil'
            if is_warmup_period then 
                period_text = 'WARMUP'
            elseif is_paused then
                period_text = 'PAUSED'
            end
            local period_text_size = render.get_text_size(verdana_20, period_text)
            local period_anim = animation.new('period_anim', (period_text ~= 'nil') and 1 or 0, 12)

            if period_text ~= 'nil' then 
                render.set_alpha(period_anim)
                    renderer.blur(math.vec3((x/2 - period_text_size / 2) - 5, 200), math.vec3(period_text_size + 10, 40))
                    renderer.rect_filled(math.vec3((x/2 - period_text_size / 2) - 5, 200), math.vec3(period_text_size + 10, 40), render.color(18,18,18,100))
                    render.text(verdana_20, (x/2 - period_text_size / 2), 210, period_text, render.color(255,255,255,255))
                render.pop_alpha()
            end

    end

--endregion

--region chat render
    function chat_setup()
        ---@item messaage render
            local height = 0
            if entities.get_entity(engine.get_local_player()) == nil then return end
                    
            local chat_text = other_chat_text:get()
            local chat_bg = other_chat_bg:get()

            for key, value in pairs(chat_message_array)do

                value.time = value.time - global_vars.frametime
                value.alpha = animation.lerp(value.alpha, value.time <= 0 and 0 or 1, 12)

                local text_size = render.get_text_size(verdana_14, value.author .. ' say: ' .. value.message)

                render.set_alpha(value.alpha)
                    renderer.blur(math.vec3(0, y - 140 + height), math.vec3(10 + text_size, 20))
                    renderer.rect_filled(math.vec3(0, y - 140 + height), math.vec3(10 + text_size, 20), chat_bg)
                    render.text(verdana_14, 5, y - 135 + height, value.author .. ' say: ' .. value.message, chat_text)
                render.pop_alpha()

                if (value.alpha < 0.01 or #chat_message_array > 25) then
                    table.remove(chat_message_array, key)
                end

                height = height - 23 * value.alpha 
            end
    end
--endregion

--region timer and player counter
    ---@item get bomb
        function bomb_tweeks()
            local bomb_has_been_planted = false
            local timer = ''
            local is_bomb_ticking  = ''
            local bombsite = ''
            local got_defused = ''
            local is_being_defused = ''
            local def_timer = ''
            local result = ''
            local bomb_site = ''
        
            entities.for_each(function(entity)

                if entity:get_class() == 'CPlantedC4' then
        
                    bomb_has_been_planted = true
                    timer = (entity:get_prop('m_flC4Blow') - global_vars.curtime)
                    is_bomb_ticking = entity:get_prop('m_bBombTicking') 
                    bombsite = entity:get_prop('m_nBombSite')
                    got_defused = entity:get_prop("m_bBombDefused")
                    is_being_defused = entity:get_prop("m_hBombDefuser")
                    def_timer = (entity:get_prop("m_flDefuseCountDown") - global_vars.curtime)
        
                    bomb_site = (bombsite == 0) and 'A' or 'B'
                    timer = (timer < 0) and 0 or math.floor(timer)
                    timer = (is_being_defused ~= -1) and math.floor(def_timer) or timer
                    timer = (got_defused) and 0 or timer
        
                    result = (is_being_defused ~= -1) and 'Defusing' or 'Ticking'
        
                    if timer == 0 then
                        if not got_defused then
                            result = 'Detonate'
                        else
                            result = 'Defused'
                        end
                    end

                end
            end)
        
        
            return bomb_site, timer, result
        end
    ---@item background
        function timer_and_player_counter_background()
            if entities.get_entity(engine.get_local_player()) == nil then return end
            local bomb_site, timer, result = bomb_tweeks()
            local alpha_bg = animation.new('alpha_player_bg', (bomb_site ~= '') and 1 or 0, 16)
            local counter_bg = other_counter_bg:get()

            render.set_alpha(alpha_bg)
                renderer.blur(math.vec3(x/2 - 55, 20), math.vec3(110, 40))
                renderer.rect_filled(math.vec3(x/2 - 55, 20), math.vec3(110, 40), counter_bg)
            render.pop_alpha()
        end

    ---@item player counter
        function player_counter_setup()
            ---@item get players team

                counter.t_players = 0
                counter.ct_players = 0

                entities.for_each_player(function(player)
                    if (player:get_prop('m_iTeamNum') == 2 and player:is_alive()) then
                        counter.t_players = counter.t_players + 1
                    end
                    if (player:get_prop('m_iTeamNum') == 3 and player:is_alive()) then
                        counter.ct_players = counter.ct_players + 1
                    end
                end);


            ---@item render
                if entities.get_entity(engine.get_local_player()) == nil then return end
                local bomb_site, timer, result = bomb_tweeks()
                local offset_x_plus = animation.new('offset_x_plus', (bomb_site ~= '') and x/2 + 60 or x/2 + 5, 12)
                local offset_x_minus = animation.new('offset_x_minus', (bomb_site ~= '') and x/2 - 100 or x/2 - 45, 12)
                local bomb_site_not_none_alpha = animation.new('bomb_site_not_none_alpha', (bomb_site ~= '') and 1 or 0, 12)

                local counter_t_color = other_counter_t_color:get()
                local counter_ct_color = other_counter_ct_color:get()
                local counter_bg = other_counter_bg:get()


                renderer.rect_filled(math.vec3(offset_x_plus, 19), math.vec3(40, 15), counter_t_color)
                renderer.blur(math.vec3(offset_x_plus, 20), math.vec3(40, 40))
                renderer.rect_filled(math.vec3(offset_x_plus, 20), math.vec3(40, 40), counter_bg)
                render.text(verdana_30, offset_x_plus + 6, 28, string.format("%02d", counter.t_players), render.color(255,255,255,255))
                
                renderer.rect_filled(math.vec3(offset_x_minus, 19), math.vec3(40, 15), counter_ct_color)
                renderer.blur(math.vec3(offset_x_minus, 20), math.vec3(40, 40))
                renderer.rect_filled(math.vec3(offset_x_minus, 20), math.vec3(40, 40), counter_bg)
                render.text(verdana_30, offset_x_minus + 6, 28, string.format("%02d", counter.ct_players), render.color(255,255,255,255))

                render.set_alpha(bomb_site_not_none_alpha)
                    if bomb_site ~= '' then
                        local result_color = (result == 'Ticking') and counter_t_color or counter_ct_color
                        render.text(verdana_30, x/2 - 30, 28, bomb_site, render.color(255,255,255,255))
                        render.text(verdana_30, x/2 + 10, 28, string.format("%02d", timer), result_color)
                    end
                render.pop_alpha()

        end
    ---@item round result
            function round_result_setup()
                local round_end_anim = animation.new('round_end_anim', round_end and 1 or 0, 12)

                local counter_t_color = other_counter_t_color:get()
                local counter_ct_color = other_counter_ct_color:get()
                local counter_bg = other_counter_bg:get()




                render.set_alpha(round_end_anim)
                    renderer.blur(math.vec3(x/2 - 150, 120), math.vec3(300, 60))
                    renderer.rect_filled(math.vec3(x/2 - 150, 120), math.vec3(300, 60), counter_bg)

                    for key, value in pairs(round_end_array)do
                        if (value.winner == 2) then
                            round_result_text = 'Terrorist win'
                            active_icon = icon_t
                        elseif (value.winner == 3) then
                            round_result_text = 'Counter-Terrorist win'
                            active_icon = icon_ct
                        end
                        if round_result_text == nil then return end
                        local round_result_text_size = render.get_text_size(verdana_20, round_result_text)

                        render.set_texture(active_icon);
                            renderer.rect_filled(math.vec3(x/2 - 140, 130), math.vec3(40, 40), render.color(255,255,255,255))
                        render.set_texture(nil);
                    
                        render.text(verdana_20, (x/2 - round_result_text_size / 2), 140, round_result_text, render.color(255,255,255,255))

                    end

                render.pop_alpha()

            end 
--endregion

--region killfeed
    ---@item killfeed get icon
        function killfeed_icon(weapon_text, weapon_icon)
            local weapon_icon = weapon_text
            if weapon_text == 'glock' then
                weapon_icon = '$'
            elseif weapon_text == 'cz75a' then
                weapon_icon = ')'
            elseif weapon_text == 'p250' then
                weapon_icon = '%'
            elseif weapon_text == 'fiveseven' then
                weapon_icon = '#'
            elseif weapon_text == 'deagle' then
                weapon_icon = '!'
            elseif weapon_text == 'revolver' then
                weapon_icon = '*'
            elseif weapon_text == 'elite' then
                weapon_icon = '"'
            elseif weapon_text == 'tec9' then
                weapon_icon = '&'
            elseif weapon_text == 'hkp2000' then
                weapon_icon = "'"
            elseif weapon_text == 'usp_silencer' then
                weapon_icon = '('
            elseif weapon_text == 'usp_silencer_off' then
                weapon_icon = '`'
            elseif weapon_text == 'mac10' then
                weapon_icon = ','
            elseif weapon_text == 'mp9' then
                weapon_icon = '-'
            elseif weapon_text == 'mp7' then
                weapon_icon = '0'
            elseif weapon_text == 'mp5sd' then
                weapon_icon = '+'
            elseif weapon_text == 'ump45' then
                weapon_icon = '/'
            elseif weapon_text == 'bizon' then
                weapon_icon = '.'
            elseif weapon_text == 'p90' then
                weapon_icon = '1'
            elseif weapon_text == 'galilar' then
                weapon_icon = '8'
            elseif weapon_text == 'famas' then
                weapon_icon = '7'
            elseif weapon_text == 'ak47' then
                weapon_icon = '4'
            elseif weapon_text == 'm4a1' then
                weapon_icon = '3'
            elseif weapon_text == 'm4a1_silencer' then
                weapon_icon = '2'
            elseif weapon_text == 'm4a1_silencer_off' then
                weapon_icon = '_'
            elseif weapon_text == 'sg556' then
                weapon_icon = '5'
            elseif weapon_text == 'aug' then
                weapon_icon = '6'
            elseif weapon_text == 'ssg08' then
                weapon_icon = '<'
            elseif weapon_text == 'awp' then
                weapon_icon = '9'
            elseif weapon_text == 'scar20' then
                weapon_icon = ';'
            elseif weapon_text == 'g3sg1' then
                weapon_icon = ':'
            elseif weapon_text == 'nova' then
                weapon_icon = '?'
            elseif weapon_text == 'xm1014' then
                weapon_icon = 'A'
            elseif weapon_text == 'sawedoff' then
                weapon_icon = '@'
            elseif weapon_text == 'mag7' then
                weapon_icon = 'B'
            elseif weapon_text == 'm249' then
                weapon_icon = '='
            elseif weapon_text == 'negev' then
                weapon_icon = '>'
            elseif weapon_text == 'hegrenade' then
                weapon_icon = 'e'
            elseif weapon_text == 'inferno' then
                weapon_icon = 'a'
            elseif weapon_text == 'bayonet' then
                weapon_icon = 'K'
            elseif weapon_text == 'knife_css' then
                weapon_icon = '['
            elseif weapon_text == 'knife_flip' then
                weapon_icon = 'O'
            elseif weapon_text == 'knife_gut' then
                weapon_icon = 'P'
            elseif weapon_text == 'knife_karambit' then
                weapon_icon = 'Q'
            elseif weapon_text == 'knife_m9_bayonet' then
                weapon_icon = 'R'
            elseif weapon_text == 'knife_tactical' then
                weapon_icon = 'S'
            elseif weapon_text == 'knife_falchion' then
                weapon_icon = 'N'
            elseif weapon_text == 'knife_survival_bowie' then
                weapon_icon = 'L'
            elseif weapon_text == 'knife_butterfly' then
                weapon_icon = 'M'
            elseif weapon_text == 'knife_push' then
                weapon_icon = 'T'
            elseif weapon_text == 'knife_cord' then
                weapon_icon = "\\"
            elseif weapon_text == 'knife_canis' then
                weapon_icon = ']'
            elseif weapon_text == 'knife_ursus' then
                weapon_icon = 'U'
            elseif weapon_text == 'knife_gypsy_jackknife' then
                weapon_icon = 'V'
            elseif weapon_text == 'knife_outdoor' then
                weapon_icon = 'W'
            elseif weapon_text == 'knife_stiletto' then
                weapon_icon = 'Y'
            elseif weapon_text == 'knife_widowmaker' then
                weapon_icon = 'Z'
            elseif weapon_text == 'knife_skeleton' then
                weapon_icon = 'X'
            elseif weapon_text == 'knife' then
                weapon_icon = 'R'
            else
                weapon_icon = 'j'
            end



            return weapon_icon
        end
---@item killfeed render
        function killfeed_setup()
            local height = 0
            for key, value in pairs(killfeed_array) do
            value.time = value.time - global_vars.frametime
            value.alpha = animation.lerp(value.alpha, value.time <= 0 and 0 or 1, 12)
                ---@item color
                    local attacker_color = killfeed_attacker_color:get()
                    local weapon_color = killfeed_weapon_color:get()
                    local hs_color = killfeed_hs_color:get()
                    local attacked_color = killfeed_attacked_color:get()
                    local bg_color = killfeed_bg_color:get()


                ---@item text size
                    local player = engine.get_local_player()
                    local attacker_id = engine.get_player_for_user_id(value.attacker)  
                    local attacked_id = engine.get_player_for_user_id(value.attacked)
                    local weapon_icon = killfeed_icon(value.weapon)
                    local weapon_size = render.get_text_size(icon_small, weapon_icon)
                    local attacked_size = render.get_text_size(verdana_12, value.attacked_name)
                    local attacker_size = render.get_text_size(verdana_12,value.attacker_name)
                    local headshot_size = value.headshot and render.get_text_size(icon_small, 'h') or 0

                ---@item render
                    render.set_alpha(value.alpha)
                        renderer.blur(math.vec3(x - 40 - attacked_size - headshot_size - weapon_size - attacker_size, 20 + height), math.vec3(40 + x + headshot_size + weapon_size + attacker_size, 22))
                        renderer.rect_filled(math.vec3(x - 40 - attacked_size - headshot_size - weapon_size - attacker_size, 20 + height), math.vec3(40 + x + headshot_size + weapon_size + attacker_size, 22), bg_color)

                        if value.headshot then
                            render.text(icon_small, x - 15 - attacked_size - headshot_size, 26 + height, 'h', hs_color)
                        end

                        render.text(verdana_12, x - 10 - attacked_size, 26 + height, value.attacked_name, attacked_color)
                        render.text(icon_small, x - 20 - attacked_size - headshot_size - weapon_size , 26 + height, weapon_icon, weapon_color)
                        render.text(verdana_12, x - 30 - attacked_size - headshot_size - weapon_size - attacker_size, 26 + height, value.attacker_name, attacker_color)
                    render.pop_alpha()
                ---@item remove
                    if (value.alpha < 0.01) then
                        table.remove(killfeed_array, key)
                    end
                    height = height + 24 * value.alpha
        end

        end
--endregion

--region crosshair
    function crosshair_setup()

            if entities.get_entity(engine.get_local_player()) == nil then return end
            local player = entities.get_entity(engine.get_local_player())
            local is_scoped = player:get_prop('m_bIsScoped')
            local r,g,b = other_crosshair_color:get().r, other_crosshair_color:get().g, other_crosshair_color:get().b


            local anim_sc_bottom_pos = animation.new('anim_sc_bottom_pos', is_scoped and math.vec3(x/2, y/2 + 3) or math.vec3(x/2, y/2 + 3), 12)
            local anim_sc_bottom_size = animation.new('anim_sc_bottom_size', is_scoped and math.vec3(1,60) or math.vec3(1,10), 12)
            local anim_sc_top_pos = animation.new('anim_sc_top_pos', is_scoped and math.vec3(x/2, y/2 - 62) or math.vec3(x/2, y/2 - 12), 12)
            local anim_sc_top_size = animation.new('anim_sc_top_size', is_scoped and math.vec3(1,60) or math.vec3(1,10), 12)
            local anim_sc_right_pos = animation.new('anim_sc_right_pos', is_scoped and math.vec3(x/2 - 62, y/2) or math.vec3(x/2 - 12, y/2), 12)
            local anim_sc_right_size = animation.new('anim_sc_right_size', is_scoped and math.vec3(60,1) or math.vec3(10,1), 12)
                
            local anim_sc_left_pos = animation.new('anim_sc_left_pos', is_scoped and math.vec3(x/2 + 3, y/2) or math.vec3(x/2 + 3, y/2), 12)
            local anim_sc_left_size = animation.new('anim_sc_left_size', is_scoped and math.vec3(60,1) or math.vec3(10,1), 12)
        
        
            ---@item render
        
                --bottom
                    renderer.rect_filled_mulitcolor(anim_sc_bottom_pos, anim_sc_bottom_size, 
                    render.color(r,g,b,0), render.color(r,g,b,0), render.color(r,g,b,255), render.color(r,g,b,255))
                --top
                    renderer.rect_filled_mulitcolor(anim_sc_top_pos, anim_sc_top_size, 
                    render.color(r,g,b,255), render.color(r,g,b,255), render.color(r,g,b,0), render.color(r,g,b,0))
                --right
                    renderer.rect_filled_mulitcolor(anim_sc_right_pos, anim_sc_right_size, 
                    render.color(r,g,b,255), render.color(r,g,b,0), render.color(r,g,b,0), render.color(r,g,b,255))
                --left
                    renderer.rect_filled_mulitcolor(anim_sc_left_pos, anim_sc_left_size, 
                    render.color(r,g,b,0), render.color(r,g,b,255), render.color(r,g,b,255), render.color(r,g,b,0))
        



    end
--endregion

--region callback
    function on_paint()
        invetory_setup()

        bars_background()
        health_bar_setup()
        armor_bar_setup()

        game_period_setup()
        timer_and_player_counter_background()
        player_counter_setup()
        round_result_setup()

        chat_setup()
        killfeed_setup()
        crosshair_setup()

        cvar.cl_drawhud:set_int(0)

        gui.get_combobox('visuals.other.removals.override_scope'):set('Default')
    end

    function on_player_death(player)

        local attacker = player:get_int('attacker')
        local attacked = player:get_int('userid')
        local headshot = player:get_bool('headshot')
        local weapon = player:get_string('weapon')

        local attacker_name = engine.get_player_info(engine.get_player_for_user_id(attacker)).name
        local attacked_name = engine.get_player_info(engine.get_player_for_user_id(attacked)).name


        table.insert(killfeed_array, 1 ,{
                attacker_name = attacker_name;
                attacked_name = attacked_name;
                attacker = attacker;
                attacked = attacked;
                headshot = headshot;
                weapon = weapon;
                time = 6;
                alpha = 0; 
        })

        if engine.get_player_for_user_id(attacker) == engine.get_local_player() and attacked ~= attacker then
            killed_enemy = killed_enemy + 1
        end

    end

    function on_round_start()
        killed_enemy = 0
        round_end = false
        table.clear(round_end_array)
    end

    function on_round_end(event)
        local winner = event:get_int('winner')
        round_end = true
        table.insert(round_end_array, 1, {winner = winner; round_end = round_end;})
    end

    function on_player_say(event)
        local message = event:get_string('text')
        local author_id = event:get_int('userid')
        local author_name = engine.get_player_info(engine.get_player_for_user_id(author_id)).name

        table.insert(chat_message_array, 1, {
            message = message;
            author = author_name;
            time = 6;
            alpha = 0;
        })
    end

    function on_shutdown()
        cvar.cl_drawhud:set_int(1)
    end
--endregion



