orison-bbs
==========

A BBS written in Io


Requirements
------------
  - Io
  - A unix-like server
  - sqlite3
  
Optional
--------
  - authbind
  
What this provides
------------------
  - A complete telnet bbs server, supporting ANSI and telnet control codes.
  - A system administration backend
  - A user management system
  - A conference management system
  - Logging of server events

Unique features of orison-bbs
-----------------------------
  - Written in Io
  - Modular architecture
  - Updatable (for the most part) without a server downtime
    - Live reloads of modules
  - "Guest" user status: read only

Configuration variables
-----------------------
The orison-bbs.io file has several configuration variables.  Their behavior
is described here:

Variable       | Default Value         | Purpose
---------------|-----------------------|--------
DATABASE_FILE  | "orison-bbs.sqlite3"  | The location of the SQLite3 database
DATABASE_DEBUG | false                 | Log the database queries?  (Useful for development)
SERVER_PORT    | 23                    | Port to bind to
SERVER_LOGGING | true                  | Enable logging?
SERVER_LOGFILE | "orison-bbs.log"      | The file to log to
WELCOME_BANNER | "welcomebanner.ansi"  | Banner printed on connection
SYSOP_EMAIL    | "example@example.com" | The sysop email address

How to run
----------
On a system with authbind:
    $ ./orison-bbs

On a system without authbind:
    # ./orison-bbs.io

How to extend
-------------
Create a new object that clones Module.  Implement a process(aSession) method.
Add the module to the MenuModule.  Add the module to the modules.io file.
Sign in as sysop.  Select the "Reload modules" option.

License
-------
This software is licensed under the [BSD license](https://github.com/gatesphere/orison-bbs/raw/master/license/license.txt).

