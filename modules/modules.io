// orison-bbs
// module loader

// this is the Module proto
// modules must clone this proto
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

// this bit loads all the modules
list(
  // user modules
  "login.io",
  "logout.io",
  "newuser.io",
  "menu.io",
  // sysop modules
  "reloadmodules.io",
  "servershutdown.io",
  "manageconferences.io",
  "manageusers.io"
) foreach(m, doFile("modules/#{m}" interpolate))
