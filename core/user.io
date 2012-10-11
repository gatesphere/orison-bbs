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
    query := "INSERT INTO Users ('username', 'password', 'realname', 'email', 'activated', 'sysop', 'logged_in') VALUES ('#{self username}', '#{self hashed_password}', '#{self realname}', '#{self email}', 'false', 'false', 'false')" interpolate
    server log("query = #{query}" interpolate)
    db exec(query)
  )
  
  has_password := method(password,
    p := self hash_password(password)
    //v := 
  )
)
