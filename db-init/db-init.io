// orison-bbs
// database-init loader

// this loads the database initialization queries
list(
  "users.sql",
  "conferences.sql"
) foreach(m, 
  f := File openForReading("db-init/#{m}" interpolate)
  server dbExec(f contents)
  f close
)
