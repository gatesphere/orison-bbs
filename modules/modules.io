// orison-bbs
// module loader

Module := Object clone do(
  name ::= nil
  description ::= nil
)

list(
  "login.io",
  "newuser.io",
  "menu.io"
) foreach(m, doFile("modules/#{m}" interpolate))
