-----------------------------
/* Jesus Hilario Hernandez */
/* Lab No. 2               */
/* June 18, 2017           */
-----------------------------



--1. Create movies table. Data types decided.
CREATE TABLE movies
(
  MovieID     INT           NOT NULL AUTO_INCREMENT,
  MovieName   VARCHAR(225)  NOT NULL,
  Category    VARCHAR(10)   NOT NULL,
  Minutes     INT(3)        NOT NULL,
  Year        CHAR(4)       NOT NULL,
  Main_Actor  VARCHAR(225)  NOT NULL,
  Rating      VARCHAR(4)    NOT NULL,
  PRIMARY KEY (MovieID)
);

--2. Full movies table with following information.
INSERT INTO movies
VALUES
(DEFAULT, 'The Shawshank Redemption'        , 'Drama'   , 142   , '1994', 'Tim Robbins'         , '9.2'),
(DEFAULT, 'The Godfather'                   , 'Drama'   , 175   , '1972', 'Marlon Brando'       , '9.2'),
(DEFAULT, 'Pulp Fiction'                    , 'Thriller', 154   , '1994', 'John Travolta'       , '8.9'),
(DEFAULT, 'Schindler\'s List'               , 'Drama'   , 195   , '1993', 'Liam Neeson'         , '8.9'),
(DEFAULT, '12 Angry Men'                    , 'Drama'   , 96    , '1957', 'Martin Balsam'       , '8.9'),
(DEFAULT, 'One Flew Over the Cuckoo\'s Nest', 'Drama'   , 133   , '1975', 'Jack Nicholson'      , '8.8'),
(DEFAULT, 'The Dark Knight'                 , 'Action'  , 152   , '2008', 'Christian Bale'      , '8.8'),
(DEFAULT, 'The Lord of the Rings: The Return of the King', 'Action', 201, '2003', 'Elijah Wood' , '8.8'),
(DEFAULT, 'Star Wars'                       , 'Action'  , 121   , '1977', 'Mark Hamill'         , '8.8'),
(DEFAULT, 'Casablanca'                      , 'Drama'   , 102   , '1942', 'Humphrey Bogart'     , '8.8');

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

--8. Change the rating for Lord of the Rings to 5.0.
