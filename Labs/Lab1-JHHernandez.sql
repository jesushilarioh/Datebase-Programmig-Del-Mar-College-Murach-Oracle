
-----------------------------
/* Jesus Hilario Hernandez */
/* Lab No. 1               */
/* June 11, 2017           */
-----------------------------

--1
SELECT MovieName, Main_Actor
FROM FilmData;

--2
SELECT MovieName, Catergory, Main_Actor
FROM FilmData
WHERE MovieID = 3;

--3
SELECT MovieName
FROM FilmData
WHERE Rating > 8.8;

--4
SELECT MovieName, Minutes
FROM FilmData
WHERE Catergory = 'Drama';

--5
SELECT MovieName, Year, Main_Actor
FROM FilmData
WHERE Main_Actor NOT "Elijah Wood";

--6
INSERT INTO FilmData
  (MovieName, Category, Minutes, Year, Main_Actor, Rating)
VALUES
  ('Goodfellas', 'Drama', 146, 1990, 'Robert De Niro', '8.8');

--7
SELECT * FROM FilmData ORDER BY Category;

--8
SELECT MovieName, Catergory, Year
FROM FilmData
ORDER BY Year DESC;

--9
SELECT MovieName, Minutes
FROM FilmData
ORDER BY Minutes;

--10
SELECT MovieName, Year
FROM FilmData
WHERE Year > 1960 AND Year < 1995;
