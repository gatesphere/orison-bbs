// orison-bbs
// manage conferences module

// this is a sysop module
// it allows the sysop to change various aspects of conferences
ManageConferencesModule := Module clone do(
  name := "manageconferences"
  description := "Allows the sysop to manage users."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    user := aSession user
    if(user sysop not,
      sock writeln("You're not authorized to do that.")
      sock writeln("Please press <ENTER> to return to the menu.")
      sock readln
      ,
      self menu(aSession)
    )
    aSession setModule("menu")
  )

  // the main menu
  menu := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock writeln("=== Manage Conferences: Main ===")
    sock writeln(" 1. Create new category")
    sock writeln(" 2. Delete category")
    sock writeln(" 3. Create new conference")
    sock writeln(" 4. Delete conference")
    sock writeln(" 5. Delete post")
    sock writeln(" 6. Delete discussion")
    sock writeln(" 7. Return to main menu")
    sock write("Please enter your selection: ")
    choice := sock readln
    self processaction(aSession, choice)
  )
 
  // figure out what the user wanted to do
  processaction := method(aSession, choice,
    choice switch(
      "1", self newcategory(aSession),
      "2", self deletecategory(aSession),
      "3", self newconference(aSession),
      "4", self deleteconference(aSession),
      "5", self deletepost(aSession),
      "6", self deletediscussion(aSession),
      "7", return,
      self menu(aSession)
    )
  )

  newcategory := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )

  deletecategory := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )

  newconference := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )

  deleteconference := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )

  deletepost := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )

  deletediscussion := method(aSession,
    self not_yet_implemented(aSession)
    self menu(aSession)
  )
)

server addModule(ManageConferencesModule)
