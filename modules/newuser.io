// orison-bbs
// newuser module

NewUserModule := Module clone do(
  name := "newuser"
  description := "Allows users to register."
  
  process := method(aSocket, aSession,
    sock := SocketHelper with(aSocket)
    sock write("not yet implemented.")
    aSession server closeSocket(aSocket)
  )
)

server addModule(NewUserModule)

