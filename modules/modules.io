// orison-bbs
// module loader

list(
  "login.io",
  "newuser.io",
  "menu.io"
) foreach(m, doFile("modules/#{m}" interpolate))
