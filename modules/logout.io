// orison-bbs
// logout module

// this module displays a goodbye message and logs out a user
LogoutModule := Module clone do(
  name := "logout"
  description := "Logs a user out of the system, displying a goodbye screen."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    user := aSession user
    sock writeln("Thanks for using orison-bbs!")
    aSession server close(aSession server socket)
  )
)

server addModule(LogoutModule)
