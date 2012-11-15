// orison-bbs
// manage conferences module

// this is a sysop module
// it allows the sysop to change various aspects of conferences
ManageConferencesModule := Module clone do(
  name := "manageconferences"
  description := "Allows the sysop to manage conferences."
  
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
    sock writeln(" 3. Rename category")
    sock writeln(" 4. Create new conference")
    sock writeln(" 5. Delete conference")
    sock writeln(" 6. Rename conference")
    sock writeln(" 7. Delete post")
    sock writeln(" 8. Delete discussion")
    sock writeln(" 9. Return to main menu")
    sock write("Please enter your selection: ")
    choice := sock readln
    self processaction(aSession, choice)
  )
 
  // figure out what the user wanted to do
  processaction := method(aSession, choice,
    choice switch(
      "1", self newcategory(aSession),
      "2", self deletecategory(aSession),
      "3", self renamecategory(aSession),
      "4", self newconference(aSession),
      "5", self deleteconference(aSession),
      "6", self renameconference(aSession),
      "7", self deletepost(aSession),
      "8", self deletediscussion(aSession),
      "9", return,
      self menu(aSession)
    )
  )

  // ask for a category, grab that category from the db
  // return nil if it doesn't exist
  promptforcategory := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock write("Please enter category name: ")
    cname := sock readln
    values := Map with(":cn", cname)
    query := "SELECT * FROM Categories WHERE name=':cn' LIMIT 1"
    cate := aSession server dbExec(query, values)
    if(cate size == 0,
      list(cname, nil)
      ,
      list(cname, cate at(0))
    )
  )

  // ask for a conference, grab that conference from the db
  // return nil if it doesn't exist
  promptforconference := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock write("Please enter conference name: ")
    cname := sock readln
    values := Map with(":cn", cname)
    query := "SELECT * FROM Conferences WHERE name=':cn' LIMIT 1"
    conf := aSession server dbExec(query, values)
    if(conf size == 0,
      list(cname, nil)
      ,
      list(cname, conf at(0))
    )
  )
  
  // ask for a post, grab that post from the db
  // return nil if it doesn't exist
  promptforpost := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock write("Please enter post id: ")
    pid := sock readln
    values := Map with(":pid", pid)
    query := "SELECT * FROM Posts WHERE id=':pid' LIMIT 1"
    post := aSession server dbExec(query, values)
    if(post size == 0,
      list(pid, nil)
      ,
      list(pid, post at(0))
    )
  )

  // ask for a discussion, grab that discussion from the db
  // return nil if it doesn't exist
  promptfordiscussion := method(aSession,
    sock := aSession sockethelper
    sock clearscreen
    sock write("Please enter discussion id: ")
    did := sock readln
    values := Map with(":did", did)
    query := "SELECT * FROM Discussions WHERE id=':did' LIMIT 1"
    post := aSession server dbExec(query, values)
    if(post size == 0,
      list(did, nil)
      ,
      list(did, post at(0))
    )
  )
  
  // removes a conference and all children (discussions and posts)
  removeconference := method(aSession, row,
    query := "SELECT * FROM Discussions WHERE parent=':cid'"
    values := Map with(":cid", row at("id"))
    discussions := aSession server dbExec(query, values)
    discussions foreach(d, self removediscussion(aSession, d))
    query := "DELETE FROM Conferences WHERE id=':id'"
    values := Map with(":id", row at("id"))
    aSession server dbExec(query, values)  
  )
  
  // removes a discussion and all child posts
  removediscussion := method(aSession, row,
    query := "DELETE FROM Posts WHERE parent=':did'"
    values := Map with(":did", row at("id"))
    aSession server dbExec(query, values)
    query := "DELETE FROM Discussions WHERE id=':id'"
    values := Map with(":id", row at("id"))
    aSession server dbExec(query, values)
  )

  newcategory := method(aSession,
    sock := aSession sockethelper
    category := self promptforcategory(aSession)
    sock clearscreen
    if(category at(1) != nil,
      sock writeln("Category #{category at(0)} already exists." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Creating category...")
      query := "INSERT INTO Categories ('name') VALUES (':name')"
      values := Map with(":name", category at(0))
      aSession server dbExec(query, values)
      sock writeln("Category created.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  deletecategory := method(aSession,
    sock := aSession sockethelper
    category := self promptforcategory(aSession)
    sock clearscreen
    if(category at(1) == nil,
      sock writeln("Category #{category at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Deleting category...")
      query := "DELETE FROM Categories WHERE name=':name'"
      values := Map with(":name", category at(0))
      aSession server dbExec(query, values)
      
      sock writeln("Deleting children...")
      // conferences
      query := "SELECT FROM Conferences WHERE parent=':cid'"
      values := Map with(":cid", category at(0) at("id"))
      conferences := aSession server dbExec(query, values)
      conferences foreach(c, self removeconference(aSession, c))
      sock writeln("Category deleted.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )
  
  renamecategory := method(aSession,
    sock := aSession sockethelper
    category := self promptforcategory(aSession)
    sock clearscreen
    if(category at(1) == nil,
      sock writeln("Category #{category at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      n := ""
      loop(
        sock write("Please enter new category name: ")
        n = sock readln
        query := "SELECT * FROM Categories WHERE name=':name'"
        values := Map with(":name", n)
        cs := aSession server dbExec(query, values)
        if(cs size == 0,
          break
          ,
          sock println("That name is already in use.  Please try again.")
        )
      )
      query := "UPDATE Categories SET name=':name' WHERE id=':id'"
      values := Map with(":name", n, ":id", category at(0) at("id"))
      aSession server dbExec(query, values)
      sock writeln("Category renamed.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  newconference := method(aSession,
    sock := aSession sockethelper
    conference := self promptforconference(aSession)
    sock clearscreen
    if(conference at(1) != nil,
      sock writeln("Conference #{conference at(0)} already exists." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Creating conference...")
      query := "INSERT INTO Conferences ('name') VALUES (':name')"
      values := Map with(":name", conference at(0))
      aSession server dbExec(query, values)
      sock writeln("Conference created.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  deleteconference := method(aSession,
    sock := aSession sockethelper
    conference := self promptforconference(aSession)
    sock clearscreen
    if(conference at(1) == nil,
      sock writeln("Conference #{conference at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Deleting conference...")
      sock writeln("Deleting children...")
      self removeconference(aSession, conference at(1))
      sock writeln("Conference deleted.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  renameconference := method(aSession,
    sock := aSession sockethelper
    conference := self promptforconference(aSession)
    sock clearscreen
    if(conference at(1) == nil,
      sock writeln("Conference #{conference at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      n := ""
      loop(
        sock write("Please enter new conference name: ")
        n = sock readln
        query := "SELECT * FROM Conferences WHERE name=':name'"
        values := Map with(":name", n)
        cs := aSession server dbExec(query, values)
        if(cs size == 0,
          break
          ,
          sock println("That name is already in use.  Please try again.")
        )
      )
      query := "UPDATE Conferences SET name=':name' WHERE id=':id'"
      values := Map with(":name", n, ":id", category at(0) at("id"))
      aSession server dbExec(query, values)
      sock writeln("Conference renamed.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  deletepost := method(aSession,
    sock := aSession sockethelper
    post := self promptforpost(aSession)
    if(post at(1) == nil,
      sock writeln("Post with id #{post at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Deleting post...")
      query := "DELETE FROM Posts WHERE id=':pid'"
      values := Map with(":pid", post at(0))
      aSession server dbExec(query, values)
      sock writeln("Post deleted.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )

  deletediscussion := method(aSession,
    sock := aSession sockethelper
    discussion := self promptfordiscussion(aSession)
    if(discussion at(1) == nil,
      sock writeln("Discussion with id #{discussion at(0)} does not exist." interpolate)
      sock writeln("Press <ENTER> to continue.")
      sock readln
      ,
      sock writeln("Deleting discussion...")
      sock writeln("Deleting children...")
      self removediscussion(aSession, discussion at(1))
      sock writeln("Discussion deleted.")
      sock writeln("Press <ENTER> to continue.")
      sock readln
    )
    self menu(aSession)
  )
)

server addModule(ManageConferencesModule)
