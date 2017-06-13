CREATE TABLE movies
(
  MovieID     VARCHAR2(6)   NOT NULL      PRIMARY KEY,
  MovieName   VARCHAR2(30)  NOT NULL,
  Category    VARCHAR2(10)  NOT NULL,
  Minutes     NUMBER(3)     NOT NULL,
  Year        CHAR(4)       NOT NULL,
  Main_Actor  VARCHAR2(30)  NOT NULL,
  Rating      VARCHAR2(4)   NOT NULL
);
