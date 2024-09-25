
local renderer = {}

    function math.lerp(a, b, percentage)
        return a + (b - a) * percentage
    end

    function lerpColor(color1, color2, t)
        local r = math.lerp(color1.r, color2.r, t)
        local g = math.lerp(color1.g, color2.g, t)
        local b = math.lerp(color1.b, color2.b, t)
        local a = math.lerp(color1.a, color2.a, t)

        return render.color(r, g, b, a)
    end

    function gradientColor(color1, color2, t)
        return lerpColor(color1, color2, t)
    end

    function renderer.multi_colortext(text, x, y, font, alphamod)
        local textp = 0

        for _, value in pairs(text) do

            if alphamod then
                value.color.a = alphamod
            end

            render.text(font, x + textp, y, value.text, value.color)
            textp = textp + render.get_text_size(font, value.text)
        end
    end

    function renderer.multi_colortext_width(tbl, font)
            if tbl == nil then return 0 end
            local totalWidth = 0

            for _, value in pairs(tbl) do
                totalWidth = totalWidth + render.get_text_size(font, value.text)
            end

            return totalWidth
    end

    function renderer.enchantet_text(speed, text, font, x, y, baseColor, glowColor)
            if text == nil then
                return
            end

            local chars_x = 0
            local len = #text

            for i = 1, len do
                local char = string.sub(text, i, i)
                local charWidth = render.get_text_size(font, char)

                local timeOffset = (global_vars.realtime - i * 0.1) * speed
                local colorGlowing = gradientColor(baseColor, glowColor, math.abs(math.sin(timeOffset)))

                render.text(font, x + chars_x, y, char, colorGlowing)

                chars_x = chars_x + charWidth
            end
    end

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

    function renderer.progress_circle(pos, radius_1, radius_2, direction, progress, color)
        local i = direction
        local x,y = pos.x, pos.y
        while i < direction + progress do
            i = i + 1
            
            local m_rad = i * math.pi / 180
            render.line(x + math.cos( m_rad ) * radius_1, y + math.sin( m_rad ) * radius_1, x + math.cos( m_rad ) * radius_2, y + math.sin( m_rad ) * radius_2 , color)
        end
    end

    -- function arc(pos, radius_1, radius_2, direction, deagres, color)
    --     local i = direction
    --     local x,y = pos.x, pos.y
    --     while i < direction + deagres do
    --         i = i + 1
            
    --         local m_rad = i * math.pi / 180
    --         render.line(x + math.cos( m_rad ) * radius_1, y + math.sin( m_rad ) * radius_1, x + math.cos( m_rad ) * radius_2, y + math.sin( m_rad ) * radius_2 , color)
    --     end
    -- end

return renderer
