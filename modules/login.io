// orison-bbs
// login module

LoginModule := Module clone do(
  process := method(aSocket, aServer, aSession,
    sock := SocketHelper with(aSocket)
    welcome := """
Welcome to orison-bbs!
Please log in.  Enter NEW to register.

Username: """
    sock write(welcome)
    username := sock readln
    sock write("Password: ")
    password := sock readln
    sock writeln("\n\nYou entered: #{username} #{password}" interpolate)
  )
)

server modules atPut("login", LoginModule)
