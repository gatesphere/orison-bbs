// orison-bbs
// login module

LoginModule := Module clone do(
  process := method(aSocket, aServer, aSession,
    welcome := """
Welcome to orison-bbs!
Please log in.  Enter NEW to register.

Username: """
     if(aSocket open, 
       aSocket write(welcome)
       uname := aSocket readBuffer asString
       aSocket readBuffer empty
       aSocket write("Password: ")
       password := aSocket readBuffer asString
       aSocket write("\n\n You entered #{uname} #{password}" interpolate)
     )
  )
)

server modules atPut("login", LoginModule)
