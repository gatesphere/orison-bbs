// orison-bbs
// login module

// this module provides the main menu of the system
// processes user input and moves off to other modules
MenuModule := Module clone do(
  name := "menu"
  description := "Allows interacting with the system."
  
  process := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    user := aSession user
    sock writeln("Welcome to orison-bbs, #{user username}." interpolate)
    if(user activated not, 
      sock writeln("Your account is not activated.  Guest access only.")
    )
    sock writeln("Please select an option.")
    sock writeln(" 1 - Enter the conference halls")
    sock writeln(" 2 - Read your mailbox")
    sock writeln(" 3 - Write a message to another user")
    sock writeln(" 4 - Edit your profile")
    sock writeln(" 5 - Ping the sysop")
    sock writeln(" 6 - Logout")
    if(user sysop,
      sock writeln("--- sysop menu ---")
      sock writeln("91 - Manage users")
      sock writeln("92 - Manage conferences")
      sock writeln("93 - Reload modules")
      sock writeln("94 - Shut down the service")
    )
    sock write("Please enter your selection: ")
    in = sock readln
    self select(in, aSession)
  )

  select := method(choice, aSession,
    choice switch(
      "1", aSession setModule("conferencehall"),
      "2", aSession setModule("mailbox"),
      "3", aSession setModule("privatemessage"),
      "4", aSession setModule("editaccount"),
      "5", aSession setModule("contactsysop"),
      "6", aSession setModule("logout"),
      "91", if(aSession user sysop, aSession setModule("manageusers"), return),
      "92", if(aSession user sysop, aSession setModule("manageconferences"), return),
      "93", if(aSession user sysop, aSession setModule("reloadmodules"), return),
      "94", if(aSession user sysop, aSession setModule("servershutdown"), return),
      return
    )
  )
)

server addModule(MenuModule)
