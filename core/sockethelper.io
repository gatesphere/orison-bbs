// orison-bbs
// socket helper

SocketHelper := Object clone do(
  socket ::= nil
  init := method(self setSocket(nil))
  with := method(aSocket, self clone setSocket(aSocket))
  
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
      val := self socket readUntilSeq(0x0A asCharacter)
      self socket readBuffer empty
      val
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
  
  negotiateWrite := method(commands,
    resp := list
    iac_rcvd := false
    will_rcvd := false
    wont_rcvd := false
    do_rcvd := false
    dont_rcvd := false
    sb_rcvd := false
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
          iac_rcvd = false
          will_rcvd = false
          wont_rcvd = false
          do_rcvd = false
          dont_rcvd = false
          sb_rcvd = false
        )
        if(wont_rcvd, 
          resp append(self iac) append(self dont) append(c)
          iac_rcvd = false
          will_rcvd = false
          wont_rcvd = false
          do_rcvd = false
          dont_rcvd = false
          sb_rcvd = false
        )
        if(do_rcvd, 
          resp append(self iac) append(self wont) append(c)
          iac_rcvd = false
          will_rcvd = false
          wont_rcvd = false
          do_rcvd = false
          dont_rcvd = false
          sb_rcvd = false
        )
        if(dont_rcvd, 
          resp append(self iac) append(self wont) append(c)
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
