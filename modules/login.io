// orison-bbs
// login module

LoginModule := Module clone do(
  name := "login"
  description := "Allows logging into the system."
  
  welcome := method(
    f := File openForReading(WELCOME_BANNER)
    b := f contents
    f close
    b
  )
  
  process := method(aSocket, aServer, aSession,
    sock := SocketHelper with(aSocket)
    // negotiation here
    sock write(ANSIHelper cls)
    sock write(ANSIHelper cursor_set(0,0))
    sock empty
    sock write(self welcome)
    sock writeln("Welcome.  Please log in below.  Use NEW to register.")
    sock write("Username: ")
    username := sock readln asMutable strip
    if(username asLowercase == "new",
      aSession setModule("newuser")
      return
      ,
      sock write("Password: ")
      password := sock readln asMutable strip
      sock writeln("\n\nYou entered: #{username} #{password}" interpolate)
    )
  )
)

server addModule(LoginModule)
