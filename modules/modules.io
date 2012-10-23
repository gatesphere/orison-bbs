// orison-bbs
// module loader

Module := Object clone do(
  name ::= nil
  description ::= nil
  db_init ::= nil
)

list(
  "login.io",
  "newuser.io",
  "menu.io",
  "reloadmodules.io",
  "servershutdown.io"
) foreach(m, doFile("modules/#{m}" interpolate))
