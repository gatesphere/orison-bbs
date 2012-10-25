// orison-bbs
// login module

ServerShutdownModule := Module clone do(
  name := "servershutdown"
  description := "Stops the server gracefully."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock write(ANSIHelper cls)
    sock write(ANSIHelper cursor_set(0,0))
    sock empty
    user := aSession user
    if(user sysop not,
      sock writeln("You're not authorized to do that.")
      sock writeln("Please press <enter> to return to the menu.")
      sock readln
      ,
      aSession server stop
    )
    aSession setModule("menu")
  )
)

server addModule(ServerShutdownModule)
