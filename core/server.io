// orison-bbs
// server core

// this object provides most of the server-side behavior
// including communicating with the database, accepting connections,
// and logging
server := Server clone setPort(SERVER_PORT) do(
  modules := Map clone
  database := nil
  open_sockets := list
  logfile := nil
  
  // when a connection comes in, send it off to a ServerSession for processing
  handleSocket := method(aSocket,
    self log("Opening new socket, IP = #{aSocket address}" interpolate)
    self open_sockets append(aSocket)
    ServerSession clone @process(aSocket, self)
  )

  // a session ended
  closeSocket := method(aSocket,
    self log("Closing socket, IP = #{aSocket address}" interpolate)
    self open_sockets remove(aSocket)
    aSocket close
  )

  // load functionality
  loadModules := method(
    log("Loading modules...")
    modules := Map clone
    Lobby doFile("modules/modules.io")
    log("Modules loaded.")
  )
  
  // register a module to the server, initializing the db if necessary
  addModule := method(module,
    self modules atPut(module name, module)
    log("Loaded module #{module name}" interpolate)
  )
  
  // create and open the db
  initializeDatabase := method(
    log("Initializing database...")
    self database := SQLite3 clone setPath(DATABASE_FILE)
    self database open
    if(DATABASE_DEBUG, self database debugOn)
    Lobby doFile("db-init/db-init.io")
    log("Database initialized.")
  )
  
  // create the logfile
  startLogging := method(
    if(SERVER_LOGGING,
      File with(SERVER_LOGFILE) remove
      self logfile := File clone openForAppending(SERVER_LOGFILE)
      self logfile close
    )
  )
  
  // log a message to the logfile
  log := method(message,
    if(SERVER_LOGGING,
      self logfile := File clone openForAppending(SERVER_LOGFILE)
      self logfile write("#{Date now}: #{message}\n" interpolate)
      self logfile close
    )
  )
  
  // start the server
  start := method(
    log("Server starting up...  Listening on port #{self port}" interpolate)
    resend
  )
  
  // stop the server gracefully
  // 1 - close open sockets
  // 2 - close the db
  // 3 - exit
  stop := method(
    log("Stop message recieved...")
    log("Closing all open sockets...")
    self open_sockets clone foreach(s,
      self closeSocket(s)
    )
    log("Closing the database...")
    self database close
    log("Server stopped.")
    System exit
  )
  
  // run a sanitized query on the db
  dbExec := method(query, values,
    if(values != nil,
      newvals := Map clone
      values foreach(k, v, newvals atPut(k, SQLite3 escapeString(v)))
      query = query asMutable replaceMap(newvals)
    )
    self database exec(query)
  )
)

// tie server stop to the System shutdown procedure
// ensures safe cleanups when server is killed
System userInterruptHandler := method(
  writeln("Calling server stop.")
  server stop
)
