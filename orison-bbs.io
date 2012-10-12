#!/usr/bin/env io

// orison-bbs
// loader

// server config
DATABASE_FILE := "orison-bbs.sqlite3"
DATABASE_DEBUG := true
SERVER_PORT := 23
SERVER_LOGGING := true
SERVER_LOGFILE := "orison-bbs.log"
WELCOME_BANNER := "welcomebanner.test.ansi"
SYSOP_EMAIL := "sysop@suspended-chord.info"

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
