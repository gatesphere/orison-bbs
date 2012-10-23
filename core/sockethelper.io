// orison-bbs
// socket helper

SocketHelper := Object clone do(
  socket ::= nil
  init := method(self setSocket(nil))
  with := method(aSocket, self clone setSocket(aSocket))
  
  // negotiation stuff
  iac := 255
  will := 251
  wont := 252
  do := 253
  dont := 245
  sb := 250
  se := 240
  is := 0
  send := 1
  nop := 241

  newline := "\r\n"
  
  write := method(message,
    if(self socket isOpen, self socket write(message))
  )

  writeln := method(message,
    self write("#{message}#{self newline}" interpolate)
  )
  
  writeansi := method(file,
    f := File openForReading(file)
    f foreachLine(l,
      self writeln(l)
    )
    f close
  )
  
  empty := method(
    if(self socket isOpen,
      self socket readBuffer empty
    )
  )
  
  readln := method(
    if(self socket isOpen,
      self empty
      val := self socket readUntilSeq(self newline)
      if(val not or val isError, return self readln, return val) // retry on timeouts
    )
  )
  
  negotiate := method(
    if(self socket isOpen,
      if(self socket read,
        self negotiateWrite(self socket readBuffer)
        self empty
      )
    )
  )
  
  // dumb server - reject any attempts to negotiate.
  negotiateWrite := method(commands,
    resp := list
    iac_rcvd := false
    will_rcvd := false
    wont_rcvd := false
    do_rcvd := false
    dont_rcvd := false
    sb_rcvd := false
    cmd_end := false
    commands foreach(c,
      if(sb_rcvd and c != self se, continue, sb_rcvd = false)
      if(c == self iac, iac_rcvd = true; continue)
      if(c == self will, will_rcvd = true; continue)
      if(c == self do, do_rcvd = true; continue)
      if(c == self wont, wont_rcvd = true; continue)
      if(c == self dont, dont_rcvd = true; continue)
      if(c == self sb, sb_rcvd = true; continue)
      if(iac_rcvd,
        if(will_rcvd,
          resp append(self iac) append(self dont) append(c)
          cmd_end = true
        )
        if(wont_rcvd, 
          resp append(self iac) append(self dont) append(c)
          cmd_end = true
        )
        if(do_rcvd, 
          resp append(self iac) append(self wont) append(c)
          cmd_end = true
        )
        if(dont_rcvd, 
          resp append(self iac) append(self wont) append(c)
          cmd_end = true
        )
        if(cmd_end,
          cmd_end = false
          iac_rcvd = false
          will_rcvd = false
          wont_rcvd = false
          do_rcvd = false
          dont_rcvd = false
          sb_rcvd = false
        )
      )
    )
    self write(resp map(asCharacter) join)
  )
)
