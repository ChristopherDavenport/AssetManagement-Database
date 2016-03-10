CREATE TABLE note_types
 (note_type_pk      varchar(12)   not null,
 note_type_desc     varchar(120)  not null,
 status_ck          varchar(1)    not null,
 status_date        date           not null,
 activity_date      date           not null,
 user_id            varchar(30)   not null
);

ALTER TABLE note_types ADD CONSTRAINT pk_note_types PRIMARY KEY(note_type_pk)

ALTER TABLE note_types ADD CONSTRAINT ck_note_types_status CHECK (status_ck in ('A', 'I'));

CREATE FUNCTION tiu_note_types() RETURNS TRIGGER AS $$
 BEGIN
  new.activity_date := current_date;
  new.user_id       := user;
  new.note_type_pk     := upper(new.note_type_pk);
  new.status_ck     := upper(coalesce(new.status_ck, 'A'));
  IF (old.status_ck <> new.status_ck) || old.status_ck IS NULL THEN
   new.status_date  := current_date;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_note_types BEFORE INSERT OR UPDATE ON note_types
 FOR EACH ROW EXECUTE PROCEDURE tiu_note_types();