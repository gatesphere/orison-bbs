CREATE TABLE IF NOT EXISTS Categories (id integer primary key autoincrement, name text); 
CREATE UNIQUE INDEX IF NOT EXISTS CategoryNames ON Categories (name); 

CREATE TABLE IF NOT EXISTS Conferences (id integer primary key autoincrement, name text, parent integer); 
CREATE INDEX IF NOT EXISTS ConferenceNames ON Conferences (name); 
CREATE INDEX IF NOT EXISTS ConferenceParents ON Conferences (parent); 

CREATE TABLE IF NOT EXISTS Discussions (id integer primary key autoincrement, name text, parent integer); 
CREATE INDEX IF NOT EXISTS DiscussionNames ON Discussions (name); 
CREATE INDEX IF NOT EXISTS DiscussionParents ON Discussions (parent); 

CREATE TABLE IF NOT EXISTS Posts (id integer primary key autoincrement, subject text, userid integer, content text, date integer, parent integer); 
CREATE INDEX IF NOT EXISTS PostUserids ON Posts (userid); 
CREATE INDEX IF NOT EXISTS PostParents ON Posts (parent); 
CREATE INDEX IF NOT EXISTS PostDates ON Posts (date);
