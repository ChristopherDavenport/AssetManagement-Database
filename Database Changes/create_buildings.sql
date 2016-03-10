CREATE TABLE buildings
(
  building_code           VARCHAR(6)    NOT NULL,
  building_desc           VARCHAR(30)   NOT NULL,
  activity_date           DATE          NOT NULL,
  user_id                 VARCHAR(30)
);

ALTER TABLE buildings ADD CONSTRAINT pk_buildings PRIMARY KEY (building_code);

CREATE FUNCTION tiu_buildings() RETURNS TRIGGER AS $$
  BEGIN
    new.activity_date := current_date;
    new.user_id       := user;
    new.building_code := upper(new.building_code);
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_buildings BEFORE INSERT OR UPDATE ON buildings
  FOR EACH ROW EXECUTE PROCEDURE tiu_buildings();
