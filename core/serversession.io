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
    sock := SocketHelper with(aSocket)
    sock negotiate
    self setModule("login")
    
    while(aSocket isOpen,
      e := try(
        self current_module process(aSocket, self)
      )
      e catch(Exception,
        aServer closeSocket(aSocket)
      )
    )
    aServer closeSocket(aSocket) 
  )
)
