CREATE TABLE printers
(printer_pk       varchar(20)   not null,
 printer_desc     varchar(120)  not null,
 status_ck        varchar(1)    not null,
 status_date      date           not null,
 pages_per_min    SMALLINT,
 charge_back      DECIMAL(7,2)    not null,
 activity_date    date           not null,
 user_id          varchar(30)   not null
);

ALTER TABLE printers ADD CONSTRAINT pk_printers PRIMARY KEY (printer_pk);

ALTER TABLE printers ADD CONSTRAINT ck_printers_status CHECK (status_ck in ('A', 'I'));

CREATE FUNCTION tiu_printers() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_date;
  new.user_id       := user;
  new.printer_pk     := upper(new.printer_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_printers BEFORE INSERT OR UPDATE ON printers
 FOR EACH ROW EXECUTE PROCEDURE tiu_printers();