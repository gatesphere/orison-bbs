// orison-bbs
// login module

// this module is the entry point for the system
// this allows users to log in, or create a new user
LoginModule := Module clone do(
  name := "login"
  description := "Allows logging into the system."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock writeansi(WELCOME_BANNER)
    sock writeln("Welcome.  Please log in below.  Use NEW to register.")
    sock write("Username: ")
    username := sock readln
    if(username asLowercase == "new",
      aSession setModule("newuser")
      return
      ,
      sock write("Password: ")
      password := sock readpassword
      self validate(username, password, aSession)
    )
  )

  // validates whether a valid username/password combination was provided
  validate := method(username, password, aSession,
    query := "SELECT * FROM Users WHERE username=':un' LIMIT 1"
    values := Map with(":un", username)
    res := aSession server dbExec(query, values) at(0)
    if(res == nil, return false)
    u := User from_row(res)
    if(u has_password(password),
      u setLogged_in(true) 
      aSession setUser(u)
      aSession setModule("menu")
      ,
      return false
    )
  )
)

server addModule(LoginModule)
