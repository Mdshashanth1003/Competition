CREATE DATABASE IF NOT EXISTS sport_radar_db;
USE sport_radar_db;
-- Table 1: Categories
-- ------------------------------
CREATE TABLE IF NOT EXISTS Categories (
    category_id VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);
CREATE TABLE Competitions (
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(100) NOT NULL,
    parent_id VARCHAR(50),
    type VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    category_id VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Complexes (
    complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100) NOT NULL
);
CREATE TABLE Complexes (
    complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100) NOT NULL
);

CREATE TABLE Venues (
    venue_id VARCHAR(50) PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    complex_id VARCHAR(50),
    FOREIGN KEY (complex_id) REFERENCES Complexes(complex_id)
);
CREATE TABLE Competitors (
    competitor_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    abbreviation VARCHAR(10) NOT NULL
);

CREATE TABLE Competitor_Rankings (
    rank_id INT AUTO_INCREMENT PRIMARY KEY,
    `rank` INT NOT NULL,
    movement INT NOT NULL,
    points INT NOT NULL,
    competitions_played INT NOT NULL,
    competitor_id VARCHAR(50),
    FOREIGN KEY (competitor_id) REFERENCES Competitors(competitor_id)
);


-- COMPETITIONS & CATEGORIES QUERIES
#List all competitions along with their category name

SELECT competitions.competition_name, categories.category_name
FROM competitions
JOIN categories ON competitions.category_id = categories.category_id;

#Count the number of competitions in each category

SELECT categories.category_name, COUNT(*) AS competition_count
FROM competitions
JOIN categories ON competitions.category_id = categories.category_id
GROUP BY categories.category_name;

#Find all competitions of type 'doubles'
SELECT competition_name FROM competitions WHERE type = 'doubles';

#Get competitions that belong to a specific category (e.g., 'ITF Men')

SELECT competition_name
FROM competitions
JOIN categories ON competitions.category_id = categories.category_id
WHERE categories.category_name = 'ITF Men';

#Identify parent competitions and their sub-competitions

SELECT parent.competition_name AS parent_competition, child.competition_name AS sub_competition
FROM competitions AS child
JOIN competitions AS parent ON child.parent_id = parent.competition_id;

#Analyze the distribution of competition types by category

SELECT categories.category_name, competitions.type, COUNT(*) AS total
FROM competitions
JOIN categories ON competitions.category_id = categories.category_id
GROUP BY categories.category_name, competitions.type;

#List all competitions with no parent (top-level competitions)
SELECT competition_name FROM competitions WHERE parent_id IS NULL;

#List all venues along with their associated complex name
SELECT venues.venue_name, complexes.complex_name
FROM venues
JOIN complexes ON venues.complex_id = complexes.complex_id;

#Count the number of venues in each complex
SELECT complexes.complex_name, COUNT(*) AS venue_count
FROM venues
JOIN complexes ON venues.complex_id = complexes.complex_id
GROUP BY complexes.complex_name;

#Get details of venues in a specific country (e.g., 'Chile')
SELECT * FROM venues WHERE country_name = 'Chile';

#Identify all venues and their timezones
SELECT venue_name, timezone FROM venues;

#Find complexes that have more than one venue
SELECT complexes.complex_name
FROM venues
JOIN complexes ON venues.complex_id = complexes.complex_id
GROUP BY complexes.complex_name
HAVING COUNT(*) > 1;

#List venues grouped by country
SELECT country_name, COUNT(*) AS venue_count
FROM venues
GROUP BY country_name;

#Find all venues for a specific complex (e.g., 'Nacional')
SELECT venue_name
FROM venues
JOIN complexes ON venues.complex_id = complexes.complex_id
WHERE complexes.complex_name = 'Nacional';
