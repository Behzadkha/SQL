connect to cs3db3;

CREATE TABLE Person(
   ID          INTEGER  NOT NULL PRIMARY KEY 
  ,FirstName   VARCHAR(20)
  ,LastName    VARCHAR(20)
  ,Sex         VARCHAR(10)
  ,Address     VARCHAR(50)
  ,DateOfBirth DATE
  ,Occupation  VARCHAR(50)
  ,City        VARCHAR(50)
);

create table Phone(
	ID integer NOT NULL,
	Number bigint NOT NULL,
	Type varchar(20),
	primary key (ID, Number),
	foreign key (ID) references Person (ID) on delete cascade
);

CREATE TABLE Passenger(
   PassengerID          INTEGER  NOT NULL PRIMARY KEY 
  ,FlyerStatus VARCHAR(10)
  ,foreign key (PassengerID) references Person (ID) on delete cascade
);

CREATE TABLE Pilot(
   PilotID        INTEGER  NOT NULL PRIMARY KEY 
  ,YearsOfService INTEGER
  ,Salary         INTEGER
  ,foreign key (PilotID) references Person (ID) on delete cascade
);

CREATE TABLE FlightAttendant(
   FAID           INTEGER  NOT NULL PRIMARY KEY 
  ,YearsOfService INTEGER
  ,Salary         INTEGER
  ,Rank           VARCHAR(10)
  ,foreign key (FAID) references Person (ID) on delete cascade
);

CREATE TABLE Airline(
   carrier VARCHAR(2) NOT NULL PRIMARY KEY
  ,name    VARCHAR(50)
);

CREATE TABLE Airplane(
   tailnum      VARCHAR(6) NOT NULL PRIMARY KEY
  ,year         INTEGER
  ,manufacturer VARCHAR(50)
  ,model        VARCHAR(50)
  ,seats        INTEGER
);

CREATE TABLE City(
   Name       VARCHAR(50) NOT NULL
  ,Country    VARCHAR(20) NOT NULL
  ,Population INTEGER  NOT NULL
  ,Area       NUMERIC(20,2) NOT NULL
  ,PRIMARY KEY(Name,Country)
);

CREATE TABLE Airport(
   Code VARCHAR(3) NOT NULL PRIMARY KEY
  ,Name VARCHAR(80) NOT NULL
  ,Lat  NUMERIC(15,8) NOT NULL
  ,Lon  NUMERIC(15,8) NOT NULL
);

CREATE TABLE AirportInCity(
   Code    VARCHAR(3) NOT NULL
  ,Name    VARCHAR(50) NOT NULL
  ,Country VARCHAR(20) NOT NULL
  ,PRIMARY KEY(Code,Name,Country)
  ,foreign key (Code) references Airport (Code) on delete cascade
  ,foreign key (Name, Country) references City (Name, Country) on delete cascade
);

CREATE TABLE Flight(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER  NOT NULL
  ,SchedArrTime INTEGER  NOT NULL
  ,SchedDepTime INTEGER  NOT NULL
  ,DepTime      INTEGER  NOT NULL
  ,ArrTime      INTEGER  NOT NULL
  ,Distance     INTEGER  NOT NULL
  ,PRIMARY KEY(Date,FlightNumber,SchedArrTime,SchedDepTime)
);

CREATE TABLE Class(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER  NOT NULL
  ,SchedArrTime INTEGER  NOT NULL
  ,SchedDepTime INTEGER  NOT NULL
  ,Class        VARCHAR(30) NOT NULL
  ,Type         VARCHAR(20) NOT NULL
  ,Fare         INTEGER  NOT NULL
  ,PRIMARY KEY(Date,FlightNumber,SchedArrTime,SchedDepTime,Class,Type)
  ,foreign key (Date, FlightNumber, SchedArrTime, SchedDepTime) references Flight (Date, FlightNumber, SchedArrTime, SchedDepTime) on delete cascade
);

CREATE TABLE Operate(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER  NOT NULL
  ,SchedArrTime INTEGER  NOT NULL
  ,SchedDepTime INTEGER  NOT NULL
  ,Carrier      VARCHAR(2) NOT NULL
  ,PRIMARY KEY(Date,FlightNumber,SchedArrTime,SchedDepTime,carrier)
  ,foreign key (Carrier) references Airline (Carrier) on delete cascade
  ,foreign key (Date, FlightNumber, SchedArrTime, SchedDepTime) references Flight (Date, FlightNumber, SchedArrTime, SchedDepTime) on delete cascade
);

CREATE TABLE Run(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER  NOT NULL
  ,SchedArrTime INTEGER  NOT NULL
  ,SchedDepTime INTEGER  NOT NULL
  ,Tailnum      VARCHAR(6) NOT NULL
  ,PRIMARY KEY(Date,FlightNumber,SchedArrTime,SchedDepTime,tailnum)
  ,foreign key (Tailnum) references Airplane (Tailnum) on delete cascade
  ,foreign key (Date, FlightNumber, SchedArrTime, SchedDepTime) references Flight (Date, FlightNumber, SchedArrTime, SchedDepTime) on delete cascade
);

CREATE TABLE Route(
   Origin VARCHAR(3) NOT NULL
  ,Dest   VARCHAR(3) NOT NULL
  ,PRIMARY KEY(Origin,Dest)
  ,foreign key (Origin) references Airport (Code) on delete cascade
  ,foreign key (Dest) references Airport (Code) on delete cascade
);

CREATE TABLE RouteServe(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER  NOT NULL
  ,SchedArrTime INTEGER  NOT NULL
  ,SchedDepTime INTEGER  NOT NULL
  ,Origin       VARCHAR(3) NOT NULL
  ,Dest         VARCHAR(3) NOT NULL
  ,PRIMARY KEY(Date,FlightNumber,SchedArrTime,SchedDepTime,Origin,Dest)
  ,foreign key (Date, FlightNumber, SchedArrTime, SchedDepTime) references Flight (Date, FlightNumber, SchedArrTime, SchedDepTime) on delete cascade
  ,foreign key (Origin, Dest) references Route (Origin, Dest) on delete cascade
);

CREATE TABLE AirlineOwnAirplane(
   Carrier VARCHAR(2) NOT NULL
  ,Tailnum VARCHAR(6) NOT NULL
  ,PRIMARY KEY(Carrier,Tailnum)
  ,foreign key (Carrier) references Airline (Carrier) on delete cascade
  ,foreign key (Tailnum) references Airplane (Tailnum) on delete cascade
);

CREATE TABLE Serve(
   FAID    INTEGER  NOT NULL
  ,Carrier VARCHAR(2) NOT NULL
  ,primary key (FAID, Carrier)
  ,foreign key (FAID) references FlightAttendant (FAID) on delete cascade
  ,foreign key (carrier) references Airline (carrier) on delete cascade
);

CREATE TABLE WorkFor(
   PilotID    INTEGER  NOT NULL
  ,Carrier VARCHAR(2) NOT NULL
  ,primary key (PilotID, Carrier)
  ,foreign key (PilotID) references Pilot (PilotID) on delete cascade
  ,foreign key (carrier) references Airline (carrier) on delete cascade
);

CREATE TABLE Take(
   Date         DATE  NOT NULL
  ,FlightNumber INTEGER NOT NULL
  ,SchedArrTime INTEGER NOT NULL
  ,SchedDepTime INTEGER NOT NULL
  ,PassengerID  INTEGER NOT NULL
  ,Type         VARCHAR(20) NOT NULL
  ,Class        VARCHAR(50) NOT NULL
  ,primary key (Date,FlightNumber,SchedArrTime,SchedDepTime,PassengerID)
  ,foreign key (Date, FlightNumber, SchedArrTime, SchedDepTime) references Flight (Date, FlightNumber, SchedArrTime, SchedDepTime) on delete cascade
  ,foreign key (PassengerID) references Passenger (PassengerID) on delete cascade
);

