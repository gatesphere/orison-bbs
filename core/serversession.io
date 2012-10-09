// orison-bbs
// server session

ServerSession := Object clone do(
  user ::= nil
  current_module ::= nil
  
  init := method(
    self setUser(nil)
    self setCurrent_module(nil)
  )
  
  process := method(aSocket, aServer,
    self current_module := server modules at("login")
    while(aSocket isOpen,
      self current_module process(aSocket, aServer, self)
    )
    aServer closeSocket(aSocket) 
  )
)
