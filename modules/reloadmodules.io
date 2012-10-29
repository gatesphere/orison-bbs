// orison-bbs
// login module

// this is a sysop module
// this module reloads all modules
ReloadModulesModule := Module clone do(
  name := "reloadmodules"
  description := "Reloads all the modules."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    user := aSession user
    if(user sysop not,
      sock writeln("You're not authorized to do that.")
      sock writeln("Please press <ENTER> to return to the menu.")
      sock readln
      ,
      aSession server loadModules
      sock writeln("Modules reloaded.  Check the log for info.")
      sock writeln("Please press <ENTER> to return to the menu.")
      sock readln
    )
    aSession setModule("menu")
  )
)

server addModule(ReloadModulesModule)
