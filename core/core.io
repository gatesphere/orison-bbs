// orison-bbs
// core loader

list(
  "ansi.io",
  "sockethelper.io",
  "user.io",
  "serversession.io",
  "server.io"
) foreach(m, doFile("core/#{m}" interpolate))
