// orison-bbs
// login module

MenuModule := Module clone do(
  name := "menu"
  description := "Allows interacting with the system."
  
  process := method(aSocket, aSession,
    sock := SocketHelper with(aSocket)
    sock write(ANSIHelper cls)
    sock write(ANSIHelper cursor_set(0,0))
    sock empty
    user := aSession user
    sock writeln("Welcome.")
    sock writeln("You are #{user username}." interpolate)
    aSession server closeSocket(aSocket)
  )

)

server addModule(MenuModule)
