CREATE DATABASE example_db;

CREATE TABLE location (
  location_id SERIAL PRIMARY KEY,
  country_name varchar(50) NOT NULL,
  city_name varchar(50) NOT NULL
);

CREATE TABLE people (
  person_id SERIAL PRIMARY KEY,
  person_name varchar(50) NOT NULL,
  location_id INTEGER NOT NULL,
  FOREIGN KEY (location_id) REFERENCES location (location_id)
);

BEGIN;
INSERT INTO location (country_name, city_name) VALUES
  ('Russia', 'Moscow'),
  ('USA', 'New York'),
  ('Moldova', 'Chisinau'), 
  ('France', 'Paris');

INSERT INTO people (person_name, location_id) VALUES
  ('Ivan Ivanov', 1),
  ('John Smith', 2),
  ('Лях Екатерина', 3), 
  ('Jean Dupont', 4);
COMMIT;

