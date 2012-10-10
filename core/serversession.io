// orison-bbs
// server session

ServerSession := Object clone do(
  user ::= nil
  current_module ::= nil
  server ::= nil
  
  init := method(
    self setUser(nil)
    self setCurrent_module(nil)
    self setServer(nil)
  )
  
  setModule := method(module,
    self setCurrent_module(self server modules at(module) clone)
  )
  
  process := method(aSocket, aServer,
    self server := aServer
    self setModule("login")
    while(aSocket isOpen,
      self current_module process(aSocket, aServer, self)
    )
    aServer closeSocket(aSocket) 
  )
)
