// orison-bbs
// core loader

// this loads the core functionality of the server
list(
  "ansi.io",
  "sockethelper.io",
  "user.io",
  "serversession.io",
  "server.io"
) foreach(m, doFile("core/#{m}" interpolate))
