-- Example commands for (re) creating the BIBLIOGRAPHY database
-- NOTE: insert commands should be modified to create appropriate
-- test data

connect to cs348

drop table author
create table author ( \
    aid         integer not null, \
    name        char(22) not null, \
    url         char(42), \
    primary key (aid) )

insert into author (aid, name) values (1, 'Peter Bumbulis')
insert into author (aid, name, url) \
values (2, 'Ivan T. Bowman', 'http://db.uwaterloo.ca/~itbowman')
insert into author (aid, name, url) \
values (3, 'Sigmund Freud', 'en.wikipedia.org/wiki/Sigmund_Freud')
insert into author (aid, name) values (4, 'Voltaire')

drop table publication
create table publication ( \
    pubid       char(10) not null, \
    title       char(70) not null, \
    primary key (pubid) )

insert into publication (pubid, title) \
values ('SIGMOD02', 'Proc. ACM SIGMOD Conference on Management of Data')
insert into publication (pubid, title) \
values ('BB02', 'A Compact B-Tree')
insert into publication (pubid, title) \
values ('SF01', 'Constructions in Analysis')
insert into publication (pubid, title) \
values ('SF02', 'The Interpretation of Dreams')
insert into publication (pubid, title) \
values ('SF03', 'Neurosis and Psychosis')
insert into publication (pubid, title) \
values ('SF04', 'On Aphasia')
insert into publication (pubid, title) \
values ('SF05', 'On Psychotherapy')
insert into publication (pubid, title) \
values ('SF06', 'Moses and Monotheism')
insert into publication (pubid, title) \
values ('SF07', 'On Narcissism: an Introduction')
insert into publication (pubid, title) \
values ('SF08', 'The Unconscious')
insert into publication (pubid, title) \
values ('V01', 'Le Mondain')
insert into publication (pubid, title) \
values ('V02', 'Treatise on Tolerance')
insert into publication (pubid, title) \
values ('V03', 'Candide')
insert into publication (pubid, title) \
values ('PR01', 'The Most Fire Papers of PsyCon 07')
insert into publication (pubid, title) \
values ('J01', 'Pop Psych')
insert into publication (pubid, title) \
values ('J02', 'Pop Psych')
insert into publication (pubid, title) \
values ('J03', 'Crisp Rhymes for Philosophical Times')

drop table wrote
create table wrote ( \
    aid         integer not null, \
    pubid       char(10) not null, \
    aorder      integer not null, \
    primary key (aid, pubid), \
    foreign key (aid) references author (aid), \
    foreign key (pubid) references publication (pubid) )

insert into wrote (aid, pubid, aorder) values (1, 'BB02', 1)
insert into wrote (aid, pubid, aorder) values (2, 'BB02', 2)
insert into wrote (aid, pubid, aorder) values (3, 'SF01', 1)
insert into wrote (aid, pubid, aorder) values (3, 'SF02', 1)
insert into wrote (aid, pubid, aorder) values (4, 'SF02', 2)
insert into wrote (aid, pubid, aorder) values (4, 'SF03', 1)
insert into wrote (aid, pubid, aorder) values (3, 'SF03', 2)
insert into wrote (aid, pubid, aorder) values (3, 'SF04', 1)
insert into wrote (aid, pubid, aorder) values (3, 'SF05', 1)
insert into wrote (aid, pubid, aorder) values (3, 'SF06', 1)
insert into wrote (aid, pubid, aorder) values (4, 'SF06', 2)
insert into wrote (aid, pubid, aorder) values (3, 'SF07', 1)
insert into wrote (aid, pubid, aorder) values (4, 'SF08', 1)
insert into wrote (aid, pubid, aorder) values (3, 'SF08', 2)
insert into wrote (aid, pubid, aorder) values (4, 'V01', 1)
insert into wrote (aid, pubid, aorder) values (4, 'V02', 1)
insert into wrote (aid, pubid, aorder) values (4, 'V03', 1)

drop table proceedings
create table proceedings ( \
    pubid       char(10) not null, \
    year        integer not null, \
    primary key (pubid), \
    foreign key (pubid) references publication (pubid) )

insert into proceedings (pubid, year) values ('SIGMOD02', 2002)
insert into proceedings (pubid, year) values ('PR01', 1908)

drop table journal
create table journal ( \
    pubid       char(10) not null, \
    volume      integer not null, \
    number      integer not null, \
    year        integer not null, \
    primary key (pubid), \
    foreign key (pubid) references publication (pubid) )

insert into journal (pubid, volume, number, year) values ('J01', 15, 1, 1913)
insert into journal (pubid, volume, number, year) values ('J02', 18, 3, 1917)
insert into journal (pubid, volume, number, year) values ('J03', 3, 1, 1737)

drop table book
create table book ( \
    pubid       char(10) not null, \
    publisher   char(50) not null, \
    year        integer not null, \
    primary key (pubid), \
    foreign key (pubid) references publication (pubid) )

insert into book (pubid, publisher, year) values ('SF02', 'Random House', 1900)
insert into book (pubid, publisher, year) values ('SF04', 'Scholastic', 1891)
insert into book (pubid, publisher, year) values ('SF06', 'Scholastic', 1939)
insert into book (pubid, publisher, year) values ('SF07', 'Random House', 1914)
insert into book (pubid, publisher, year) values ('V02', 'Scholastic', 1914)
insert into book (pubid, publisher, year) values ('V03', 'Pearson', 1914)

drop table article
create table article ( \
    pubid       char(10) not null, \
    appearsin   char(10) not null, \
    startpage   integer not null, \
    endpage     integer not null, \
    primary key (pubid), \
    foreign key (pubid) references publication (pubid), \
    foreign key (appearsin) references publication (pubid) )

insert into article (pubid, appearsin, startpage, endpage) \
values ('BB02', 'SIGMOD02', 533, 541)
insert into article (pubid, appearsin, startpage, endpage) \
values ('SF01', 'PR01', 139, 147)
insert into article (pubid, appearsin, startpage, endpage) \
values ('SF03', 'J01', 342, 349)
insert into article (pubid, appearsin, startpage, endpage) \
values ('SF05', 'J01', 350, 361)
insert into article (pubid, appearsin, startpage, endpage) \
values ('SF08', 'J02', 67, 81)
insert into article (pubid, appearsin, startpage, endpage) \
values ('V01', 'J03', 43, 44)

commit work
