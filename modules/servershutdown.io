// orison-bbs
// server shutdown module

// this is a sysop module
// it shuts the server down gracefully
ServerShutdownModule := Module clone do(
  name := "servershutdown"
  description := "Stops the server gracefully."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    user := aSession user
    if(user sysop not,
      sock writeln("You're not authorized to do that.")
      sock writeln("Please press <ENTER> to return to the menu.")
      sock readln
      ,
      aSession server stop
    )
    aSession setModule("menu")
  )
)

server addModule(ServerShutdownModule)
