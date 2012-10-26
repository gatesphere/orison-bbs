// orison-bbs
// module loader

Module := Object clone do(
  name ::= nil
  description ::= nil
  db_init ::= nil

  not_yet_implemented := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock writeln("This feature has not yet been implemented.")
    sock writeln("Press <ENTER> to continue.")
    sock readln
  )
)

list(
  // user modules
  "login.io",
  "logout.io",
  "newuser.io",
  "menu.io",
  // sysop modules
  "reloadmodules.io",
  "servershutdown.io",
  "manageusers.io"
) foreach(m, doFile("modules/#{m}" interpolate))
