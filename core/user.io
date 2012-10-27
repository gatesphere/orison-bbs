// orison-bbs
// user

User := Object clone do(
  username ::= nil
  hashed_password ::= nil
  realname ::= nil
  email ::= nil
  activated ::= false
  sysop ::= false
  logged_in ::= false
  
  hash_password := method(password,
    digest := MD5 clone
    digest appendSeq(password)
    digest md5String
  )
  
  create := method(server,
    db := server database
    query := "INSERT INTO Users ('username', 'password', 'realname', 'email', 'activated', 'sysop') VALUES ('#{self username}', '#{self hashed_password}', '#{self realname}', '#{self email}', 0, 0)" interpolate
    db exec(query)
  )
  
  has_password := method(password,
    p := self hash_password(password)
    if(p == self hashed_password, return true, return false) 
  )

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
  
  update_info := method(server, uname, rname, em,
    query := "UPDATE Users SET username='#{uname}',realname='#{rname}',email='#{em}' WHERE username='#{self username}'" interpolate
    server database exec(query)
  )
  
  update_password := method(server, pw,
    query := "UPDATE Users SET password='#{self hash_password(pw)}' WHERE username='#{self username}'" interpolate
    server database exec(query)
  )
)
