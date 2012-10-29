// orison-bbs
// user

// this object represents a user
// also provided are hooks to the database for creation and updates
User := Object clone do(
  username ::= nil
  hashed_password ::= nil
  realname ::= nil
  email ::= nil
  activated ::= false
  sysop ::= false
  logged_in ::= false
  
  // passwords are stored hashed
  hash_password := method(password,
    digest := MD5 clone
    digest appendSeq(password)
    digest md5String
  )
  
  // create a new user
  create := method(server,
    query := "INSERT INTO Users ('username', 'password', 'realname', 'email', 'activated', 'sysop') VALUES (':un', ':pw', ':rn', ':em', 0, 0)"
    values := Map with(":un", self username, ":pw", self hashed_password, ":rn", self realname, ":em", self email)
    server dbExec(query, values)
  )
  
  // check if the user has the given password
  has_password := method(password,
    p := self hash_password(password)
    if(p == self hashed_password, return true, return false) 
  )

  // create a user from a returned database row
  from_row := method(row,
    u := self clone
    u setUsername(row at("username"))
    u setHashed_password(row at("password"))
    u setRealname(row at("realname"))
    u setEmail(row at("email"))
    u setActivated(row at("activated") == "1")
    u setSysop(row at("sysop") == "1")
    u
  )
  
  // update username, realname, and email fields
  update_info := method(server, uname, rname, em,
    query := "UPDATE Users SET username=':un',realname=':rn',email=':em' WHERE username=':user'"
    values := Map with(":un", uname, ":em", em, ":rn", rname, ":user", self username)
    server dbExec(query, values)
  )
  
  // update hashed_password
  update_password := method(server, pw,
    query := "UPDATE Users SET password=':pw' WHERE username=':un'"
    values := Map with(":un", self username, ":pw", self hash_password(pw))
    server dbExec(query, values)
  )
)
