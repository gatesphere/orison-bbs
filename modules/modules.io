// orison-bbs
// module loader

Module := Object clone do(
  
)


list(
  "login.io",
  "newuser.io",
  "menu.io"
) foreach(m, doFile("modules/#{m}" interpolate))
