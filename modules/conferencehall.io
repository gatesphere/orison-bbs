// orison-bbs
// conference hall module

// this module allows someone to create a new account
ConferenceHallModule := Module clone do(
  name := "conferencehall"
  description := "A discussion place"
  
  process := method(aSession,
    self not_yet_implemented(aSession)
    aSession setModule("menu")
  )
)

server addModule(ConferenceHallModule)

