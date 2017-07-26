/* Jesus Hilario Hernandez */
/* Lab No. 2               */
/* June 18, 2017           */
-----------------------------



--1. Create movies table. Data types decided.
CREATE TABLE movies
(
  MovieID     NUMBER(6)     NOT NULL      PRIMARY KEY,
  MovieName   VARCHAR2(30)  NOT NULL,
  Category    VARCHAR2(10)  NOT NULL,
  Minutes     NUMBER(3)     NOT NULL,
  Year        CHAR(4)       NOT NULL,
  Main_Actor  VARCHAR2(30)  NOT NULL,
  Rating      VARCHAR2(4)   NOT NULL
);
--2. Full movies table with following information.
INSERT INTO movies
VALUES (
          1,
          'The Shawshank Redemption',
          'Drama',
          142,  --Minutes
          '1994',
          'Tim Robbins',
          '9.2'
        );

INSERT INTO movies
VALUES (
          2,
          'The Godfather',
          'Drama',
          175,  --Minutes
          '1972',
          'Marlon Brando',
          '9.2'
      );

INSERT INTO movies
VALUES (
          3,
          'Pulp Fiction' ,
          'Thriller',
          154,  --Minutes
          '1994',
          'John Travolta',
          '8.9'
      );

INSERT INTO movies
VALUES (
          4,
          'Schindler''s List',
          'Drama',
          195,  --Minutes
          '1993',
          'Liam Neeson',
          '8.9'
      );

INSERT INTO movies
VALUES (
          5,
          '12 Angry Men',
          'Drama',
          96, --Minutes
          '1957',
          'Martin Balsam',
          '8.9'
      );

INSERT INTO movies
VALUES (
          6,
          'One Flew Over the Cuckoo''s Nest',
          'Drama',
          133,  --Minutes
          '1975',
          'Jack Nicholson',
          '8.8'
      );

INSERT INTO movies
VALUES (
          7,
          'The Dark Knight',
          'Action',
          152,  --Minutes
          '2008',
          'Christian Bale',
          '8.8'
      );

INSERT INTO movies
VALUES (
          8,
          'The Lord of the Rings: The Return of the King',
          'Action',
          201,  --Minutes
          '2003',
          'Elijah Wood',
          '8.8'
      );

INSERT INTO movies
VALUES (
          9,
          'Star Wars',
          'Action',
          121,  --Minutes
          '1977',
          'Mark Hamill',
          '8.8'
      );

INSERT INTO movies
VALUES (
          10,
          'Casablanca',
          'Drama',
          102,  --Minutes
          '1942',
          'Humphrey Bogart',
          '8.8'
      );


--3. List the columns from table movies.
DESCRIBE movies;

--4. Show all contents of the table.
SELECT * FROM movies;

--5. Show the table contents in descending order by year.
SELECT * FROM movies ORDER BY year DESC;

--6. Show the table contents in order by category and rating.
SELECT * FROM movies ORDER BY category, rating;

--7. Show MovieName for movies with Lord in the title.
SELECT * FROM movies
WHERE MovieName LIKE '%Lord%';

--8. Change the rating for Lord of the Rings to 5.0
UPDATE movies
SET rating = '5.0'
WHERE MovieName = 'The Lord of the Rings: The Return of the King';

--9. Change the rating for Pulp Fiction to 9.5
UPDATE movies
SET rating = '9.5'
WHERE MovieName = 'Pulp Fiction';

-- 10. Show the table of contents in order by rating
SELECT *
FROM movies
ORDER BY rating;

--11. Delete the table and its contents
DROP TABLE movies;
