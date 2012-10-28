// orison-bbs
// newuser module

NewUserModule := Module clone do(
  name := "newuser"
  description := "Allows users to register."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock writeln("Please provide the information requested to register.")
    
    // username
    sock write("Username: ")
    username := sock readln asMutable strip
    while(self check_username(username, aSession server) not,
      sock writeln("  That username is either already in use, or invalid.")
      sock write("Username: ")
      username := sock readln asMutable strip
    )
    
    // password
    sock write("Password: ")
    password := sock readln asMutable strip
    while(self check_password(password) not,
      sock writeln("  That password is invalid.")
      sock write("Password: ")
      password := sock readln asMutable strip
    )
    
    // email
    sock write("Email address: ")
    email := sock readln asMutable strip
    while(self check_email(email) not,
      sock writeln("  That email address is invalid.")
      sock write("email: ")
      email := sock readln asMutable strip
    )
    
    // real name
    sock write("Real name: ")
    realname := sock readln asMutable strip
    while(self check_realname(realname) not,
      sock writeln("  That real name is invalid.")
      sock write("Real name: ")
      realname := sock readln asMutable strip
    )
    
    // create user
    self save_user(username, password, email, realname, aSession server)
    sock writeln("")
    sock writeln("Your new user has been created.")
    sock writeln("You will only have GUEST priveleges until your account is activated.")
    sock writeln("To activate your account, send an email to #{SYSOP_EMAIL} from" interpolate)
    sock writeln("the address you used here.")
    sock writeln("Press <ENTER> to continue.")
    sock readln
    aSession setModule("login")
  )
  
  check_username := method(username, server,
    if(username size == 0, return false)
    query := "SELECT * FROM Users WHERE username=':un'"
    values := Map with(":un", username)
    val := server dbExec(query, values)
    if(val == nil or val size > 0, return false)
    true
  )
  
  check_password := method(password,
    password size > 3
  )
  
  check_email := method(email,
    email containsSeq("@") and email containsSeq(".")
  )
  
  check_realname := method(realname,
    realname size > 0
  )
  
  save_user := method(username, password, email, realname, aServer,
    u := User clone
    u setUsername(username) setEmail(email) setRealname(realname)
    u setHashed_password(u hash_password(password))
    u create(aServer)
  )
  
  db_init := "CREATE TABLE Users (id integer primary key autoincrement, username text, password text, email text, realname text, activated integer, sysop integer)"
)

server addModule(NewUserModule)

