// orison-bbs
// login module

LoginModule := Module clone do(
  welcome := method(
    f := File openForReading(WELCOME_BANNER)
    b := f contents
    f close
    b
  )
  
  process := method(aSocket, aServer, aSession,
    sock := SocketHelper with(aSocket)
    sock write(self welcome)
    sock writeln("Welcome.  Please log in below.  Use NEW to register.")
    sock write("Username: ")
    username := sock readln
    sock write("Password: ")
    password := sock readln
    sock writeln("\n\nYou entered: #{username} #{password}" interpolate)
  )
)

server modules atPut("login", LoginModule)
