// orison-bbs
// socket helper

// this object wraps a raw socket, allowing for easier reads and writes
// as well as implementing telnet negotiation
SocketHelper := Object clone do(
  socket ::= nil
  init := method(self setSocket(nil))
  with := method(aSocket, self clone setSocket(aSocket))
  has_negotiated := false
  
  // negotiation stuff
  iac := 255
  will := 251
  wont := 252
  do := 253
  dont := 254
  sb := 250
  se := 240
  is := 0
  send := 1
  nop := 241
  
  // echo
  echo := 1

  // newline
  newline := "\r\n"
  
  // write a message without a newline
  write := method(message,
    if(self socket isOpen, self socket write(message))
  )

  // write a message with a newline
  writeln := method(message,
    self write("#{message}#{self newline}" interpolate)
  )
  
  // write an ansi file to the socket
  writeansi := method(file,
    f := File openForReading(file)
    f foreachLine(l,
      self writeln(l)
    )
    f close
  )
  
  // empty the socket's readBuffer
  empty := method(
    if(self socket isOpen,
      self socket readBuffer empty
    )
  )

  // read a line from the socket
  readln := method(stripnegotiate,
    if(self socket isOpen,
      val := self socket readUntilSeq(self newline)
      if(val not or val isError, 
        return self readln // retry on timeouts
        , 
        if(val at(0) == self iac, val := self negotiate(val, stripnegotiate))
        return val
      ) 
    )
  )
  
  // read a password hopefully silently (tell the client to stop echoing)
  readpassword := method(
    if(self socket isOpen,
      if(self has_negotiated, self write(list(self iac, self will, self echo) map(asCharacter) join))
      v := self readln
      if(self has_negotiated, self writeln(list(self iac, self wont, self echo) map(asCharacter) join))
      v
    )
  )
  
  // perform negotiation
  negotiate := method(val,
    self has_negotiated = true
    self negotiateWrite(val)
  )
  
  // dumb server - reject any attempts to negotiate.
  negotiateWrite := method(commands, strip,
    resp := list
    iac_rcvd := false
    will_rcvd := false
    wont_rcvd := false
    do_rcvd := false
    dont_rcvd := false
    sb_rcvd := false
    cmd_end := false
    end_of_commands := 0
    commands foreach(i, c,
      if(sb_rcvd and c != self se, continue, sb_rcvd = false)
      if(c == self iac, iac_rcvd = true; continue)
      if(c == self will, will_rcvd = true; continue)
      if(c == self do, do_rcvd = true; continue)
      if(c == self wont, wont_rcvd = true; continue)
      if(c == self dont, dont_rcvd = true; continue)
      if(c == self sb, sb_rcvd = true; continue)
      if(iac_rcvd not, end_of_commands = i; break) 
      if(iac_rcvd,
        if(will_rcvd,
          //writeln("IAC WILL ", c)
          //writeln("reply: IAC DONT ", c)
          resp append(self iac) append(self dont) append(c)
          cmd_end = true
        )
        if(wont_rcvd, 
          //writeln("IAC WONT ", c)
          //writeln("reply: IAC DONT ", c)
          resp append(self iac) append(self dont) append(c)
          cmd_end = true
        )
        if(do_rcvd, 
          //writeln("IAC DO ", c)
          //writeln("reply: IAC WONT ", c)
          resp append(self iac) append(self wont) append(c)
          cmd_end = true
        )
        if(dont_rcvd, 
          //writeln("IAC DONT ", c)
          //writeln("reply: IAC WONT ", c)
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
    if(strip not, self write(resp map(asCharacter) join))
    val := commands exSlice(end_of_commands)
    //writeln("val = ", val)
    val
  )
  
  // clear the screen and move the cursor to (0,0)
  clearscreen := method(
    self write(ANSIHelper cls)
    self write(ANSIHelper cursor_set(0, 0))
  )
)
