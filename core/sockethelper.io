// orison-bbs
// socket helper

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
