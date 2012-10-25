// orison-bbs
// server session

ServerSession := Object clone do(
  user ::= nil
  current_module ::= nil
  server ::= nil
  socket ::= nil
  sockethelper ::= nil
  
  init := method(
    self setUser(nil)
    self setCurrent_module(nil)
    self setServer(nil)
    self setSocket(nil)
    self setSockethelper(nil)
  )
  
  setModule := method(module,
    self setCurrent_module(self server modules at(module) clone)
  )
  
  process := method(aSocket, aServer,
    self server := aServer
    self socket := aSocket
    self sockethelper := SocketHelper with(aSocket)
    sock := SocketHelper with(aSocket)
    sock negotiate
    self setModule("login")
    
    while(aSocket isOpen,
      e := try(
        self current_module process(self)
      )
      e catch(Exception,
        writeln(e)
        aServer closeSocket(aSocket)
      )
    )
    aServer closeSocket(aSocket) 
  )
)
