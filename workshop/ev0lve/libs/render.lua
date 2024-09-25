local _render = { }
for i, v in pairs(render) do
  _render[i] = v
end
render = render
local screen_w, screen_h = _render.get_screen_size()
render.width = 2560
render.height = 1440
local dpi = screen_h / render.height
render.set_standard_resolution = function(width, height)
  render.width = width
  render.height = height
  dpi = screen_h / height
end
render.get_render_size = function()
  return render.width, render.height
end
render.rect = function(x1, y1, x2, y2, ...)
  return _render.rect(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.rect_filled = function(x1, y1, x2, y2, ...)
  return _render.rect_filled(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.rect_filled_multicolor = function(x1, y1, x2, y2, ...)
  return _render.rect_filled_multicolor(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.rect_filled_rounded = function(x1, y1, x2, y2, color, rounding, ...)
  return _render.rect_filled_rounded(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, color, rounding * dpi, ...)
end
render.circle = function(x, y, radius, color, thickness, segments, ...)
  return _render.circle(x * dpi, y * dpi, radius * dpi, color, thickness * dpi, segments * dpi, ...)
end
render.circle_filled = function(x, y, radius, color, segments, ...)
  return _render.circle_filled(x * dpi, y * dpi, radius * dpi, color, segments * dpi, ...)
end
render.line = function(x1, y1, x2, y2, ...)
  return _render.line(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.line_multicolor = function(x1, y1, x2, y2, ...)
  return _render.line_multicolor(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.triangle = function(x1, y1, x2, y2, x3, y3, ...)
  return _render.triangle(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, x3 * dpi, y3 * dpi, ...)
end
render.triangle_filled = function(x1, y1, x2, y2, x3, y3, ...)
  return _render.triangle_filled(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, x3 * dpi, y3 * dpi, ...)
end
render.triangle_filled_multicolor = function(x1, y1, x2, y2, x3, y3, ...)
  return _render.triangle_filled_multicolor(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, x3 * dpi, y3 * dpi, ...)
end
render.text = function(font, x, y, ...)
  return _render.text(font, x * dpi, y * dpi, ...)
end
render.create_font = function(font_path, size, ...)
  return _render.create_font(font_path, size * dpi, ...)
end
render.create_font_gdi = function(name, size, ...)
  return _render.create_font_gdi(name, size * dpi, ...)
end
render.get_text_size = function(...)
  local w, h = _render.get_text_size(...)
  return w / dpi, h / dpi
end
render.push_clip_rect = function(x1, y1, x2, y2, ...)
  return _render.push_clip_rect(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi, ...)
end
render.push_uv = function(x1, y1, x2, y2)
  return _render.push_uv(x1 * dpi, y1 * dpi, x2 * dpi, y2 * dpi)
end
