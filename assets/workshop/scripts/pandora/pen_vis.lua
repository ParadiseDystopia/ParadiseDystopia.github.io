local screen_x, screen_y = render.get_screen()
local Calibri_Bold_20 = render.create_font("Calibri Bold", 20, 500,bit.bor(font_flags.dropshadow , font_flags.antialias , font_flags.outline));

callbacks.register("paint", function()
        if penetration.damage() > 0 then
render.rectangle_filled(screen_x/2 - 30, screen_y/2 - 30,  60, 30, color.new(0, 255, 0, 65))
            Calibri_Bold_20:text(screen_x/2 - 7, screen_y/2 - 25, color.new(255, 255, 255, 255), tostring(penetration.damage()))
      
        elseif penetration.damage() <= 0 then
render.rectangle_filled(screen_x/2 - 30, screen_y/2 - 30,  60, 30, color.new(255, 0, 0, 65)) 
            Calibri_Bold_20:text(screen_x/2 - 5, screen_y/2 - 25, color.new(255, 255, 255, 255), "0") 
    end
    
end)