// orison-bbs
// server core

ServerLogic := Object clone do(
  process := method(aSocket, aServer,
    if(aSocket isOpen, aSocket write("Welcome to orison-bbs!\n"))
    while(aSocket isOpen,
      if(aSocket read,
        cmd := aSocket readBuffer asString
        aSocket readBuffer empty
      )
    ) 
  )
)

server := Server clone setPort(SERVER_PORT) do(
  modules := list
  database := nil
  open_sockets := list
  
  handleSocket := method(aSocket,
    self open_sockets append(aSocket)
    ServerLogic clone @process(aSocket, self)
  )

  closeSocket := method(aSocket,
    self open_sockets remove(aSocket)
    aSocket close
  )

  loadModules := method(
    modules := list
    Lobby doFile("modules/modules.io")
  )
  
  initializeDatabase := method(
    self database := SQLite3 clone setPath(DATABASE_FILE)
    self database open
  )
  
  stop := method(
    self open_sockets clone foreach(s,
      self closeSocket(s)
    )
    self database close
  )
)
