// orison-bbs
// newuser module

NewUserModule := Module clone do(
  name := "newuser"
  description := "Allows users to register."
  
  process := method(aSocket, aSession,
    sock := SocketHelper with(aSocket)
    sock writeln("Please provide the information requested to register.")
    
    // username
    sock write("Username: ")
    username := sock readln
    while(self check_username(username) not,
      sock writeln("That username is either already in use, or invalid.")
      sock write("Username: ")
      username := sock readln
    )
    
    // password
    sock write("Password: ")
    password := sock readln
    while(self check_password(password) not,
      sock writeln("That password is invalid.")
      sock write("Password: ")
      password := sock readln
    )
    
    // email
    sock write("Email address: ")
    email := sock readln
    while(self check_email(email) not,
      sock writeln("That email address is invalid.")
      sock write("email: ")
      email := sock readln
    )
    
    // real name
    sock write("Real name: ")
    realname := sock readln
    while(self check_realname(realname) not,
      sock writeln("That real name is invalid.")
      sock write("Real name: ")
      realname := sock readln
    )
    
    // create user
    self save_user(username, password, email, realname, aSession server)
    sock writeln("Your new user has been created.")
    sock writeln("You will only have GUEST priveleges until your account is activated.")
    sock writeln("To activate your account, send an email to #{SYSOP_EMAIL} from the address you used here." interpolate)
    sock writeln("Press <ENTER> to continue...")
    aSession setModule("login")
  )
  
  check_username := method(username,
    
  )
  
  check_password := method(password,
    
  )
  
  save_user := method(username, password, email, realname, aServer,
    u := User clone
    u setUsername(username) setEmail(email) setRealname
    u setHashed_password(u hash_password(password))
    u create(aServer)
  )
  
  db_init := "CREATE TABLE Users (username, password, email, realname, activated, sysop, logged_in)"
)

server addModule(NewUserModule)

