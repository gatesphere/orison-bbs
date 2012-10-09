#!/usr/bin/env io

// orison-bbs
// loader

// server config
DATABASE_FILE := "orison-bbs.sqlite3"
SERVER_PORT := 1234
SERVER_LOGGING := true
SERVER_LOGFILE := "orison-bbs.log"
WELCOME_BANNER := "welcomebanner.ans"

// bootstrap the server core
doFile("core/core.io")

// start logging if enabled
server startLogging

// initialize the database
server initializeDatabase

// load modules
server loadModules

// start server
server start
