// orison-bbs
// ANSI helper

// This object provides some constants for ANSI control codes
ANSIHelper := Object clone do(
  esc := (0x1b asCharacter) .. (0x5b asCharacter)
  cls := esc .. "2J"
  cln := esc .. "K"
  
  cursor_set := method(line, column, esc .. line .. ";" .. column .. "H")
  cursor_up := method(lines, esc .. lines .. "A")
  cursor_down := method(lines, esc .. lines .. "B")
  cursor_forward := method(columns, esc .. columns .. "C")
  cursor_backward := method(columns, esc .. columns .. "D")
  cursor_save := esc .. "s"
  cursor_restore := esc .. "u"
  
  set_mode := method(mode, esc .. "=" .. mode .. "h")
  reset_mode := method(mode, esc, .. "=" .. mode .. "l")
  
  mode_40_25_mono_text := "0"
  mode_40_25_color_text := "1"
  mode_80_25_mono_text := "2"
  mode_80_25_color_text := "3"
  mode_320_200_4color_gfx := "4"
  mode_320_200_mono_gfx := "5"
  mode_640_200_mono_gfx := "6"
  mode_line_wrapping := "7"
  mode_320_200_color_gfx := "13"
  mode_640_200_16color_gfx := "14"
  mode_640_350_mono_gfx := "15"
  mode_640_350_16color_gfx := "16"
  mode_640_480_mono_gfx := "17"
  mode_640_480_16color_gfx := "18"
  mode_320_300_256color_gfx := "19"
  
  set_graphics_mode := method(gfx, esc .. gfx .. "m")
  
  sgr_reset := "0"
  sgr_bright := "1"
  sgr_faint := "2"
  sgr_italic_on := "3"
  sgr_underline_single := "4"
  sgr_blink_slow := "5"
  sgr_blink_rapid := "6"
  sgr_image_negative := "7"
  sgr_conceal := "8"
  sgr_strikethrough_on := "9"
  sgr_primary_font := "10"
  sgr_alternate_font := method(n, (n + 10) asString)
  sgr_fraktur := "20"
  sgr_bright_off := "21"
  sgr_normal_color := "22"
  sgr_italic_off := "23"
  sgr_underline_none := "24"
  sgr_blink_off := "25"
  sgr_image_positive := "27"
  sgr_reveal := "28"
  sgr_strikethrough_off := "29"
  sgr_fg_black := "30"
  sgr_fg_red := "31"
  sgr_fg_green := "32"
  sgr_fg_yellow := "33"
  sgr_fg_blue := "34"
  sgr_fg_magenta := "35"
  sgr_fg_cyan := "36"
  sgr_fg_white := "37"
  sgr_xterm_fg_color := "38"
  sgr_fg_default := "39"
  sgr_bg_black := "40"
  sgr_bg_red := "41"
  sgr_bg_green := "42"
  sgr_bg_yellow := "43"
  sgr_bg_blue := "44"
  sgr_bg_magenta := "45"
  sgr_bg_cyan := "46"
  sgr_bg_white := "47"
  sgr_xterm_bg_color := "48"
  sgr_bg_default := "49"
  sgr_framed_on := "51"
  sgr_encircled_on := "52"
  sgr_overlined_on := "53"
  sgr_framed_off := "54"
  sgr_overlined_off := "55"
)
