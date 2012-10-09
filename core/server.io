// orison-bbs
// server core


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

SocketHelper := Object clone do(
  socket ::= nil
  init := method(self setSocket(nil))
  with := method(aSocket, self clone setSocket(aSocket))
  
  write := method(message,
    if(self socket isOpen, self socket write(message))
  )

  writeln := method(message,
    self write("#{message}\n" interpolate)
  )
  
  readln := method(
    if(self socket isOpen,
      if(self socket read,
        val := self socket readBuffer asString asMutable strip
        self socket readBuffer empty
        val
      )
    )
  )
)

User := Object clone do(
  username ::= nil
  password ::= nil
  email ::= nil
  activated ::= false
  sysop ::= false
  logged_in ::= false
)

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
