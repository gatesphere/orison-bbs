// orison-bbs
// login module

ReloadModulesModule := Module clone do(
  name := "reloadmodules"
  description := "Reloads all the modules."
  
  process := method(aSocket, aSession,
    sock := SocketHelper with(aSocket)
    sock write(ANSIHelper cls)
    sock write(ANSIHelper cursor_set(0,0))
    sock empty
    user := aSession user
    if(user sysop not,
      sock writeln("You're not authorized to do that.")
      sock writeln("Please press <enter> to return to the menu.")
      sock readln
      ,
      aSession server loadModules
      sock writeln("Modules reloaded.  Check the log for info.")
      sock writeln("Press <enter> to return to the menu.")
      sock readln
    )
    aSession setModule("menu")
  )
)

server addModule(ReloadModulesModule)
