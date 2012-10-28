// orison-bbs
// login module

LoginModule := Module clone do(
  name := "login"
  description := "Allows logging into the system."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock writeansi(WELCOME_BANNER)
    sock writeln("Welcome.  Please log in below.  Use NEW to register.")
    sock write("Username: ")
    username := sock readln asMutable strip
    if(username asLowercase == "new",
      aSession setModule("newuser")
      return
      ,
      sock write("Password: ")
      password := sock readln asMutable strip
      self validate(username, password, aSession)
    )
  )

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
