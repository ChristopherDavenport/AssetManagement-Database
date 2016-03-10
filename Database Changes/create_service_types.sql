CREATE TABLE service_types
(
  service_type_pk    varchar(20)   not null,
  service_type_desc  varchar(120)  not null,
  status_ck          varchar(1)    not null,
  status_date        date           not null,
  service_notes      varchar(2000),
  activity_date      date           not null,
  user_id            varchar(30)   not null
);

ALTER TABLE service_types
    ADD CONSTRAINT pk_service_types
PRIMARY KEY(service_type_pk);

ALTER TABLE service_types ADD CONSTRAINT ck_service_types_status check(status_ck in ('A' , 'I'));

CREATE FUNCTION tiu_service_types() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_date;
  new.user_id       := user;
  new.service_type_pk     := upper(new.service_type_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_service_types BEFORE INSERT OR UPDATE ON service_types
 FOR EACH ROW EXECUTE PROCEDURE tiu_service_types();