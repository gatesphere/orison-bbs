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
  
  db_init := "CREATE TABLE Users (username, password, email, realname, activated, sysop, logged_in)"
)

server addModule(NewUserModule)

