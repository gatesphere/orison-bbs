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
  
  // the tables required for conference halls
  db_init := "CREATE TABLE IF NOT EXISTS Categories (id integer primary key autoincrement, name text); CREATE UNIQUE INDEX IF NOT EXISTS CategoryNames ON Categories (name); CREATE TABLE IF NOT EXISTS Conferences (id integer primary key autoincrement, name text, parent integer); CREATE UNIQUE INDEX IF NOT EXISTS ConferenceNames ON Conferences (name); CREATE INDEX IF NOT EXISTS ConferenceParents ON Conferences (parent); CREATE TABLE IF NOT EXISTS Discussions (id integer primary key autoincrement, name text, parent integer); CREATE UNIQUE INDEX IF NOT EXISTS DiscussionNames ON Discussions (name); CREATE INDEX IF NOT EXISTS DiscussionParents ON Discussions (parent); CREATE TABLE IF NOT EXISTS Posts (id integer primary key autoincrement, subject text, userid integer, content text, date integer); CREATE INDEX IF NOT EXISTS PostUserids ON Posts (userid); CREATE INDEX IF NOT EXISTS PostParents ON Posts (parent); CREATE INDEX IF NOT EXISTS PostDates ON Posts (date)"
)

server addModule(ConferenceHallModule)

