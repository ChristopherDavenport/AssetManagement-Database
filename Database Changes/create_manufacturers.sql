CREATE TABLE manufacturers
(manufacturer_pk       varchar(20)   not null,
 manufacturer_desc     varchar(120)  not null,
 status_ck             varchar(1)    not null,
 status_date           date           not null,
 activity_date         date           not null,
 user_id               varchar(30)   not null,
 notes                 varchar(4000)
);

ALTER TABLE manufacturers ADD CONSTRAINT pk_manufacturers PRIMARY KEY (manufacturer_pk);

ALTER TABLE manufacturers ADD CONSTRAINT ck_manufacturers_status CHECK (status_ck in ('A', 'I'));

CREATE FUNCTION tiu_manufacturers() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_date;
  new.user_id       := user;
  new.manufacturer_pk     := upper(new.manufacturer_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_manufacturers BEFORE INSERT OR UPDATE ON manufacturers
 FOR EACH ROW EXECUTE PROCEDURE tiu_manufacturers();
