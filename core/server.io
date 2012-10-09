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
  if(SERVER_LOGGING, self logfile := File openForUpdating(SERVER_LOGFILE))
  
  handleSocket := method(aSocket,
    self log("Opening new socket, IP = #{aSocket address}")
    self open_sockets append(aSocket)
    ServerLogic clone @process(aSocket, self)
  )

  closeSocket := method(aSocket,
    self log("Closing socket, IP = #{aSocket address}")
    self open_sockets remove(aSocket)
    aSocket close
  )

  loadModules := method(
    log("Loading modules...")
    modules := list
    Lobby doFile("modules/modules.io")
    log("Modules loaded.")
  )
  
  initializeDatabase := method(
    log("Initializing database...")
    self database := SQLite3 clone setPath(DATABASE_FILE)
    self database open
    log("Database initialized.")
  )
  
  log := method(message,
    if(SERVER_LOGGING,
      self logfile writeln("#{Date now}: #{message}" interpolate)
    )
  )
  
  stop := method(
    log("Stop message recieved...")
    log("Closing all open sockets...")
    self open_sockets clone foreach(s,
      self closeSocket(s)
    )
    log("Closing the database...")
    self database close
    log("Server stopped.")
    self logfile close
    System exit
  )
)

System userInterruptHandler := method(
  writeln("Calling server stop.")
  server stop
)
