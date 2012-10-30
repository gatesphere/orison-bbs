// orison-bbs
// manage users module

// this is a sysop module
// it allows the sysop to change various aspects of users
ManageUsersModule := Module clone do(
  name := "manageusers"
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
    sock writeln("=== Manage Users: Main ===")
    sock writeln(" 1. View user info by username")
    sock writeln(" 2. Activate user by username")
    sock writeln(" 3. Deactivate user by username")
    sock writeln(" 4. Edit user info by username")
    sock writeln(" 5. Change user password")
    sock writeln(" 6. Return to main menu")
    sock write("Please enter your selection: ")
    choice := sock readln
    self processaction(aSession, choice)
  )
 
  // figure out what the user wanted to do
  processaction := method(aSession, choice,
    choice switch(
      "1", self viewuser(aSession),
      "2", self activateuser(aSession),
      "3", self deactivateuser(aSession),
      "4", self edituser(aSession),
      "5", self passworduser(aSession),
      "6", return,
      self menu(aSession)
    )
  )
 
  // ask for a username, grab that user from the db
  // return nil if it doesn't exist
  promptforuser := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock write("Please enter username: ")
    uname := sock readln
    values := Map with(":un", uname)
    query := "SELECT * FROM Users WHERE username=':un' LIMIT 1"
    user := aSession server dbExec(query, values)
    if(user size == 0,
      sock writeln("No users found with that username.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
      nil
      ,
      user = User from_row(user at(0))
      user
    )
  )

  // display a user's information
  viewuser := method(aSession,
    sock := aSession sockethelper
    user := self promptforuser(aSession)
    if(user == nil,
      self menu(aSession)
      ,
      sock clearscreen
      sock writeln("=== Manage Users: View User ===")
      sock writeln("Username: #{user username}" interpolate)
      sock writeln("Real name: #{user realname}" interpolate)
      sock writeln("Email: #{user email}" interpolate)
      sock writeln("Activated: #{user activated}" interpolate)
      sock writeln("Sysop: #{user sysop}" interpolate)
      sock writeln("Press <ENTER> to return to the previous menu.")
      sock readln
      self menu(aSession)
    )  
  )

  // activate a user
  activateuser := method(aSession,
    sock := aSession sockethelper
    user := self promptforuser(aSession)
    if(user == nil,
      self menu(aSession)
      ,
      query := "UPDATE Users SET activated='1' WHERE username=':un'"
      values := Map with(":un", user username)
      aSession server dbExec(query, values)
      sock clearscreen
      sock writeln("User #{user username} has been activated." interpolate)
      sock writeln("Press <ENTER> to return to the previous menu.")
      sock readln
      self menu(aSession)
    )
  )

  // deactivate a user
  deactivateuser := method(aSession,
    sock := aSession sockethelper
    user := self promptforuser(aSession)
    if(user == nil,
      self menu(aSession)
      ,
      query := "UPDATE Users SET activated='0' WHERE username=':un'"
      values := Map with(":un", user username)
      aSession server dbExec(query, values)
      sock clearscreen
      sock writeln("User #{user username} has been deactivated." interpolate)
      sock writeln("Press <ENTER> to return to the previous menu.")
      sock readln
      self menu(aSession)
    )
  )

  // edit a user's information
  edituser := method(aSession,
    sock := aSession sockethelper
    user := self promptforuser(aSession)
    if(user == nil,
      self menu(aSession)
      ,
      sock clearscreen
      sock writeln("=== Manage Users: Edit User ===")
      sock writeln("Username: #{user username}" interpolate)
      sock write("  Change username [y/N]? ")
      ans := sock readln
      username := user username
      realname := user realname
      email := user email
      if(ans == "y" or ans == "Y",
        sock write("New username: ")
        username = sock readln
      )
      sock writeln("Real name: #{user realname}" interpolate)
      sock write("  Change real name [y/N]? ")
      ans := sock readln
      if(ans == "y" or ans == "Y",
        sock write("New real name: ")
        realname = sock readln
      )
      sock writeln("Email: #{user email}" interpolate)
      sock write("  Change email? [y/N]? ")
      ans := sock readln
      if(ans == "y" or ans == "Y",
        sock write("New email: ")
        email = sock readln
      )
      user update_info(aSession server, username, realname, email)
      sock writeln("Press <ENTER> to return to the previous menu.")
      sock readln
      self menu(aSession)
    ) 
  )
  
  // change a user's password forcefully
  passworduser := method(aSession,
    sock := aSession sockethelper
    user := self promptforuser(aSession)
    if(user == nil,
      self menu(aSession)
      ,
      sock clearscreen
      sock write("Enter new password for user #{user username}: " interpolate)
      pw := sock readln
      user update_password(aSession server, pw)
      sock writeln("Press <ENTER> to return to the previous menu.")
      sock readln
      self menu(aSession)
    )
  )
)

server addModule(ManageUsersModule)
