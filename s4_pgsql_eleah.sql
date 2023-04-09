CREATE OR REPLACE FUNCTION add_location(
  IN country_name varchar(50),
  IN city_name varchar(50)
) RETURNS VOID AS $$
BEGIN
  INSERT INTO location (country_name, city_name)
  VALUES (country_name, city_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_location(
  IN location_id INTEGER,
  IN country_name varchar(50),
  IN city_name varchar(50)
) AS $$
BEGIN
  UPDATE location
  SET country_name = country_name,
      city_name = city_name
  WHERE location_id = location_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_person(
  IN person_name varchar(50),
  IN location_id INTEGER
) RETURNS VOID AS $$
BEGIN
  INSERT INTO people (person_name, location_id)
  VALUES (person_name, location_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_person(
  IN person_id INTEGER,
  IN person_name varchar(50),
  IN location_id INTEGER
) AS $$
BEGIN
  UPDATE people
  SET person_name = person_name,
      location_id = location_id
  WHERE person_id = person_id;
END;
$$ LANGUAGE plpgsql;
