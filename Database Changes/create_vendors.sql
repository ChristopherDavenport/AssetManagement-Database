CREATE TABLE vendors
(
 vendor_pk        VARCHAR(12)  NOT NULL,
 vendor_desc      VARCHAR(120) NOT NULL,
 status_ck        VARCHAR(1)   NOT NULL,
 status_date      DATE         NOT NULL,
 banner_id        VARCHAR(9),
 notes            VARCHAR(2000),
 activity_date    DATE         NOT NULL,
 user_id          VARCHAR(30)  NOT NULL,
 customer_numbers VARCHAR(100)
);

ALTER TABLE vendors
    ADD CONSTRAINT pk_vendors
       PRIMARY KEY (vendor_pk);

ALTER TABLE vendors
    ADD CONSTRAINT ck_vendors_status
      CHECK (status_ck in ('A', 'I'));

CREATE FUNCTION tiu_vendors() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_date;
  new.user_id       := user;
  new.vendor_pk     := upper(new.vendor_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_vendors BEFORE INSERT OR UPDATE ON vendors
 FOR EACH ROW EXECUTE PROCEDURE tiu_vendors();