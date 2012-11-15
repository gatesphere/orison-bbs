CREATE TABLE IF NOT EXISTS Users (id integer primary key autoincrement, username text, password text, email text, realname text, activated integer, sysop integer); 
CREATE UNIQUE INDEX IF NOT EXISTS UserUsernames ON Users (username);
