#!/usr/bin/env io

#
# orison-bbs
# server code
#
# PeckJ 20121008
#

port := System args at(1) asNumber
if(port == nil, port = 23)

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

server := Server clone setPort(port)
server handleSocket := method(aSocket,
  ServerLogic clone @process(aSocket, self)
)

server start
