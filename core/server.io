// orison-bbs
// server core

server := Server clone setPort(SERVER_PORT) do(
  modules := Map clone
  database := nil
  open_sockets := list
  logfile := nil
  
  handleSocket := method(aSocket,
    self log("Opening new socket, IP = #{aSocket address}" interpolate)
    self open_sockets append(aSocket)
    ServerSession clone @process(aSocket, self)
  )

  closeSocket := method(aSocket,
    self log("Closing socket, IP = #{aSocket address}" interpolate)
    self open_sockets remove(aSocket)
    aSocket close
  )

  loadModules := method(
    log("Loading modules...")
    modules := Map clone
    Lobby doFile("modules/modules.io")
    log("Modules loaded.")
  )
  
  initializeDatabase := method(
    log("Initializing database...")
    self database := SQLite3 clone setPath(DATABASE_FILE)
    self database open
    log("Database initialized.")
  )
  
  startLogging := method(
    if(SERVER_LOGGING,
      File with(SERVER_LOGFILE) remove
      self logfile := File clone openForAppending(SERVER_LOGFILE)
    )
  )
  
  log := method(message,
    if(SERVER_LOGGING,
      self logfile write("#{Date now}: #{message}\n" interpolate)
    )
  )
  
  start := method(
    log("Server starting up...  Listening on port #{self port}" interpolate)
    resend
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
