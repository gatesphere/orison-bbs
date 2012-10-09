// orison-bbs
// login module

LoginModule := Module clone do(
  process := method(aSocket, aServer, aSession,
    welcome := """
Welcome to orison-bbs!
Please log in.  Enter NEW to register.

Username: """
     if(aSocket isOpen, 
       aSocket write(welcome)
       if(aSocket read,
         uname := aSocket readBuffer asString
         aSocket readBuffer empty
       )
       aSocket write("Password: ")
       if(aSocket read,
         password := aSocket readBuffer asString
         aSocket readBuffer empty
       )
       aSocket write("\n\n You entered #{uname} #{password}" interpolate)
     )
  )
)

server modules atPut("login", LoginModule)
