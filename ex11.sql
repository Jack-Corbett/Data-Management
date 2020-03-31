CREATE TABLE Reviews
( reviewID          integer,
  hotelID           integer,
  author            varchar(20),
  content           text,
  dateWritten       date,
  noReader          integer,
  noHelpful         integer,
  overallRating     tinyint,
  value             tinyint,
  rooms             tinyint,
  location          tinyint,
  cleanliness       tinyint,
  checkIn_frontDesk tinyint,
  service           tinyint,
  businessService   tinyint,
  PRIMARY KEY (reviewID AUTOINCREMENT),
  CONSTRAINT Reviews_Hotels_hotelID_fk
  FOREIGN KEY (hotelID) REFERENCES Hotels (hotelID));

CREATE TABLE Hotels
( hotelID       integer,
  overallRating tinyint,
  averagePrice  decimal,
  url           varchar(1000),
  PRIMARY KEY (hotelID));
