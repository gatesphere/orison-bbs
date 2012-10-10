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
      val := self socket readUntilSeq("\n") strip
      //self socket readBuffer empty
      val
    )
  )
)
