// orison-bbs
// ANSI helper

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
  
  set_graphics_mode := method(gfx, esc .. gfx .. "m")
)
