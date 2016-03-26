CREATE TABLE printers
( id               BIGINT                       not null,
  printer_pk       varchar(20)                  not null,
  printer_desc     varchar(120)                 not null,
  pages_per_min    SMALLINT,
  charge_back      DECIMAL(7,2)                 not null,

  status_ck        varchar(1)                   not null,
  status_date      TIMESTAMP with time zone     not null,
  activity_user   varchar(30)                   not null,
  activity_date    TIMESTAMP with time zone     not null,
  created_user    varchar(30)                   not null,
  created_date    varchar(30)                   not null
);

ALTER TABLE printers ADD CONSTRAINT id_printers PRIMARY KEY (id);

CREATE UNIQUE INDEX pk_printers ON printers (printer_pk);

ALTER TABLE printers ADD CONSTRAINT ck_printers_status CHECK (status_ck in ('A', 'I'));

CREATE FUNCTION tiu_printers() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_timestamp;
  new.activity_user := user;
  new.printer_pk    := upper(new.printer_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE FUNCTION ti_printers() RETURNS TRIGGER AS $$
  BEGIN
    new.created_date := current_timestamp;
    new.created_user := user;
  END;
  $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_printers BEFORE INSERT OR UPDATE ON printers
 FOR EACH ROW EXECUTE PROCEDURE tiu_printers();

CREATE TRIGGER ti_printers BEFORE INSERT ON printers
  FOR EACH ROW EXECUTE PROCEDURE ti_printers();