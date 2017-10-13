-- Example commands for (re) creating the STUDENT-COURSE database.
-- NOTE: "insert" commands should be modified to create appropriate
-- test data.

connect to cs348

drop table course
create table course ( \
    cnum        varchar(5) not null, \
    cname       varchar(40) not null, \
    primary key (cnum) )

insert into course values ('CS448', 'Introduction to Databases')

drop table professor
create table professor ( \
    pnum        integer not null, \
    pname       varchar(20) not null, \
    office      varchar(10) not null, \
    dept        varchar(30) not null, \
    primary key (pnum) )

insert into professor values (1, 'Weddell, Grant', 'DC3346', 'CS')
insert into professor values (2, 'Ilyas, Ihab', 'DC3348', 'CO')

drop table student
create table student ( \
    snum        integer not null, \
    sname       varchar(20) not null, \
    year        integer not null, \
    primary key (snum) )

insert into student values (1, 'Jones, Fred', 4)

drop table class
create table class ( \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    pnum        integer not null, \
    primary key (cnum, term, section), \
    foreign key (cnum) references course (cnum), \
    foreign key (pnum) references professor (pnum) )

insert into class values ('CS448', 'S2006', 1, 1)
insert into class values ('CS448', 'S2006', 2, 1)

drop table enrollment
create table enrollment ( \
    snum        integer not null, \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    primary key (snum, cnum, term, section), \
    foreign key (snum) references student (snum), \
    foreign key (cnum, term, section) references class (cnum, term, section) )

insert into enrollment values (1, 'CS448', 'S2006', 2)

drop table mark
create table mark ( \
    snum        integer not null, \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    grade       integer not null, \
    primary key (snum, cnum, term, section), \
    foreign key (snum, cnum, term, section) \
    references enrollment (snum, cnum, term, section) )

drop table schedule
create table schedule ( \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    day         varchar(10) not null, \
    time        varchar(5) not null, \
    room        varchar(10) not null, \
    primary key (cnum, term, section, day, time), \
    foreign key (cnum, term, section) \
    references class (cnum, term, section) )

insert into schedule values ('CS448', 'S2006', 1, 'Monday', '09:30', 'MC4063')
insert into schedule values ('CS448', 'S2006', 1, 'Wednesday', '09:30', 'MC4063')
insert into schedule values ('CS448', 'S2006', 1, 'Friday', '09:30', 'MC4063')
insert into schedule values ('CS448', 'S2006', 2, 'Monday', '11:30', 'MC4058')
insert into schedule values ('CS448', 'S2006', 2, 'Wednesday', '11:30', 'MC4058')
insert into schedule values ('CS448', 'S2006', 2, 'Friday', '11:30', 'MC4058')

commit work
