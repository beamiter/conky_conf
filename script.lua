-- This is a lua script for use in Conky.
require 'cairo'

local function drawTxt()
  font = "Mono"
  font_size = 12
  text = "bill yin"
  xpos, ypos = 100, 100
  r, g, b, a = 246 / 255, 155 / 255, 11 / 255, 0.7
  font_slant = CAIRO_FONT_STANT_NORMAL
  font_face = CAIRO_FONT_WEIGHT_NORMAL
  -------------------------------
  cairo_select_font_face(cr, font, font_slant, font_face)
  cairo_set_font_size(cr, font_size)
  cairo_set_source_rgba(cr, r, g, b, a)
  cairo_move_to(cr, xpos, ypos)
  cairo_show_text(cr, text)
  cairo_stroke(cr)
end

local function draw2()
  local cpu_perc = tonumber(conky_parse('${cpu}'))
  r, g, b, a = 1, 1, 1, 1
  line_width = 5
  line_cap = CAIRO_LINE_CAP_BUTT
  startx, starty = 100, 120
  endx, endy = startx + cpu_perc, starty
  --print(endx)
  ------------------------
  cairo_set_line_width(cr, line_width)
  cairo_set_line_cap(cr, line_cap)

  cairo_set_source_rgba(cr, r, g, b, a)
  cairo_move_to(cr, startx, starty)
  cairo_line_to(cr, endx, endy)
  cairo_stroke(cr)
end

local function drawHistory()
  local val = tonumber(conky_parse("${cpu}"))
  local updates = tonumber(conky_parse("${updates}"))
  if cpu_table == nil then
    cpu_table = {}
  end
  --print("---------")
  if cpu_table ~= nil then
    total_len = 10
    r, g, b, a = 1, 0.5, 0.5, 1
    width = 5
    cairo_set_source_rgba(cr, r, g, b, a)
    cairo_set_line_width(cr, width)
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT)
    blx, bly = 100, 200
    height = 100
    max_val = 100

    for i = 1, total_len do
      if cpu_table[i + 1] == nil then cpu_table[i + 1] = 0 end
      cpu_table[i] = cpu_table[i + 1]
      if i == total_len then cpu_table[i] = val end
      --print(cpu_table[i])
      bar_height = (cpu_table[i] / max_val) * height
      cairo_move_to(cr, blx + (width / 2) + (i - 1) * width, bly)
      cairo_rel_line_to(cr, 0, -bar_height)
      cairo_stroke(cr)
    end
  end

end

local function draw3()
  cairo_set_line_width (cr, 20)
  cairo_move_to (cr, 100, 100) -- Start point.
  cairo_line_to (cr, 200, 200) -- Diagonal line down.
  cairo_line_to (cr, 100, 200) -- Horizontal line.
  cairo_close_path (cr) -- Draws vertical line back to start.
  -- cairo_set_source_rgba (cr, 1, 1, 1, 1) -- White.
  cairo_fill_preserve (cr) -- Fills in the triangle in white.
  cairo_set_source_rgba (cr, 1, 0, 0, 1) -- Red.
  cairo_stroke (cr) -- Draws the triangle outline in red.
end

local function draw4()
  line_width = 5
  top_left_x, top_left_y = 20, 20
  rec_width, rec_height = 100, 50
  f_r, f_g, f_b, f_a = 1, 1, 1, 1
  l_r, l_g, l_b, l_a = 1, 0, 0, 1
  cairo_set_line_width(cr, line_width)
  cairo_rectangle(cr, top_left_x, top_left_y, rec_width, rec_height)
  cairo_set_source_rgba(cr, f_r, f_g, f_b, f_a)
  cairo_fill_preserve(cr)
  cairo_set_source_rgba(cr, l_r, l_g, l_b, l_a)
  cairo_set_line_cap(cr, CAIRO_LINE_JOIN_ROUND)
  cairo_stroke(cr)
end

local function drawClock()
  clock_radius = 60
  clock_centerx = 100
  clock_centery = 100
  clock_border_width = 2
  cbr, cbg, cbb, cba = 1, 1, 1, 1

  cairo_set_source_rgba(cr, cbr, cbg, cbb, cba)
  cairo_set_line_width(cr, clock_border_width)
  cairo_arc(cr, clock_centerx, clock_centery, clock_radius, 
            0, 2 * math.pi)
  cairo_stroke(cr)

  b_to_m = 5
  m_len = 10
  m_width = 3
  m_cap = CAIRO_LINE_CAP_ROUND
  mr, mg, mb, ma = 1, 1, 1, 1
  m_end_rad = clock_radius - b_to_m
  m_start_rad = m_end_rad - m_len

  for i = 1, 12 do
    radius = m_start_rad
    p = (math.pi / 180) * ((i - 1) * 30)
    x = radius * math.sin(p)
    y = radius * math.cos(p)
    cairo_move_to(cr, clock_centerx + x, clock_centery + y)

    radius = m_end_rad
    x = radius * math.sin(p)
    y = radius * math.cos(p)
    cairo_line_to(cr, clock_centerx + x, clock_centery + y)

    cairo_stroke(cr)
  end

  seconds = tonumber(os.date("%S"))
  minutes = tonumber(os.date("%M"))
  hours = tonumber(os.date("%I"))
  
  sh_len = 50
  sh_width = 1
  sh_cap = CAIRO_LINE_CAP_ROUND
  shr, shg, shb, sha = 1, 0, 0, 1

  sec_degs = seconds * 6
  radius = sh_len
  cairo_move_to(cr, clock_centerx, clock_centery)
  p = (math.pi / 180) * sec_degs
  x = radius * math.sin(p)
  y = -radius * math.cos(p)
  cairo_line_to(cr, clock_centerx + x, clock_centery + y)
  cairo_set_line_width(cr, sh_width)
  cairo_set_source_rgba(cr, shr, shg, shb, sha)
  cairo_set_line_cap(cr, sh_cap)
  cairo_stroke(cr)

  mh_len = 50
  mh_width = 1
  mh_cap = CAIRO_LINE_CAP_ROUND
  mhr, mhg, mhb, mha = 1, 1, 1, 1

  m_to_s = minutes * 60
  msecs = m_to_s + seconds
  msec_degs = msecs * 0.10
  radius = mh_len
  cairo_move_to(cr, clock_centerx, clock_centery)

  p = (math.pi / 180) * msec_degs
  x = radius * math.sin(p)
  y = -radius * math.cos(p)
  cairo_line_to(cr, clock_centerx + x, clock_centery + y)
  cairo_set_line_width(cr, mh_width)
  cairo_set_source_rgba(cr, mhr, mhg, mhb, mha)
  cairo_set_line_cap(cr, mh_cap)
  cairo_stroke(cr)

  hh_len = 30
  hh_width = 5
  hh_cap = CAIRO_LINE_CAP_ROUND
  hhr, hhg, hhb, hha = 1, 1, 1, 1

  h_to_s = hours * 3600
  hsecs = h_to_s + m_to_s + seconds
  hsec_degs = hsecs * (360 / 43200)

  radius = hh_len
  cairo_move_to(cr, clock_centerx, clock_centery)
  p = (math.pi / 180) * hsec_degs
  x = radius * math.sin(p)
  y = -radius * math.cos(p)
  cairo_line_to(cr, clock_centerx + x, clock_centery + y)
  cairo_set_line_width(cr, hh_width)
  cairo_set_source_rgba(cr, hhr, hhg, hhb, hha)
  cairo_set_line_cap(cr, hh_cap)
  cairo_stroke(cr)

end

local function drawCPUBar()
  bar_bottom_left_x, bar_bottom_left_y = 10, 200
  bar_width, bar_height = 20, 100

  bar_bg_r, bar_bg_g, bar_bg_b, bar_bg_a = 1, 0, 0, 1
  bar_in_r, bar_in_g, bar_in_b, bar_in_a = 1, 1, 1, 1

  cairo_set_source_rgba(cr, bar_bg_r, bar_bg_g, bar_bg_b, bar_bg_a)
  cairo_rectangle(cr, bar_bottom_left_x, bar_bottom_left_y, bar_width, -bar_height)
  cairo_fill(cr)

  local val = tonumber(conky_parse("${cpu}"))
  max_val = 100
  --val = max_val - val -- this is for test
  scale = bar_height / max_val
  indicator_height = scale * val
  alarm_val = 80
  ar, ag, ab, aa = 0, 1, 0, 1
  if val < alarm_val then
    cairo_set_source_rgba(cr, bar_in_r, bar_in_g, bar_in_b,bar_in_a)
  else 
    --print(val)
    cairo_set_source_rgba(cr, ar, ag, ab, aa)
  end
  cairo_rectangle(cr, bar_bottom_left_x, bar_bottom_left_y, bar_width, -indicator_height)
  cairo_fill(cr)

  bar_border = 1
  if bar_border == 1 then
    order_r, border_g, border_b, border_a = 0, 1, 1, 1
    border_width = 3
    border_bottom_left_x = bar_bottom_left_x - (border_width / 2)
    border_bottom_left_y = bar_bottom_left_y + (border_width / 2)
    brec_width = bar_width + border_width
    brec_height = bar_height + border_width
    cairo_set_source_rgba(cr, border_r, border_g, border_b, border_a)
    cairo_set_line_width(cr, border_width)
    cairo_rectangle(cr, border_bottom_left_x, border_bottom_left_y, brec_width, 
    -brec_height)
    cairo_stroke(cr)
  end
end

local function draw7()
  ring_center_x, ring_center_y, ring_radius, ring_width = 100, 100, 50, 10
  ring_bg_r,ring_bg_g, ring_bg_b, ring_bg_a = 1, 0, 0, 1
  ring_in_r,ring_in_g, ring_in_b, ring_in_a = 1, 1, 1, 1
  local val = tonumber(conky_parse("${cpu}"))
  --print(val)
  max_val = 100
  cairo_set_line_width(cr, ring_width)
  cairo_set_source_rgba(cr, ring_bg_r, ring_bg_g, ring_bg_b, ring_bg_a)
  cairo_arc(cr, ring_center_x, ring_center_y, ring_radius, 0, 2 * math.pi)
  cairo_stroke(cr)

  cairo_set_line_width(cr, ring_width)
  end_angle = val * (360 / max_val)
  cairo_set_source_rgba(cr, ring_in_r, ring_in_g, ring_in_b, ring_in_a)
  cairo_arc(cr, ring_center_x, ring_center_y, ring_radius, (-90) * (math.pi / 180),
  (end_angle - 90) * (math.pi / 180))
  cairo_stroke(cr)
end

function conky_main ()
  if conky_window == nil then
    return
  end
  local cs = cairo_xlib_surface_create (conky_window.display,
  conky_window.drawable,
  conky_window.visual,
  conky_window.width,
  conky_window.height)
  cr = cairo_create (cs)

  ------------------------------

  drawTxt()
  --draw2()
  -- draw3()
  --draw4()
  drawClock()
  drawCPUBar()
  --draw7()
  drawHistory()

  ------------------------------

  cairo_destroy (cr)
  cairo_surface_destroy (cs)
  cr = nil
end
