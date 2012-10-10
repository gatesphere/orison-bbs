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
  
  empty := method(
    if(self socket isOpen,
      self socket readBuffer empty
    )
  )
  
  readln := method(
    if(self socket isOpen,
      self socket readBuffer empty
      val := self socket readUntilSeq("\n")
      self socket readBuffer empty
      val
    )
  )
)
