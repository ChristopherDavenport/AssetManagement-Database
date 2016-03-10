-- Program: create_asset_notes.sql
-- Purpose: create asset notes table.
--

create table asset_notes
(asset_tag_pk_fk         varchar(12)    not null,
 tag_type_pk_fk          varchar(2)     not null,
 note_type_pk_fk         varchar(12)    not null,
 note_date_pk            date            not null,
 note_field              varchar(30),
 notes                   varchar(2000),
 activity_date           date            not null,
 user_id                 varchar(30)    not null
);

alter table asset_notes add constraint pk_asset_notes primary key
(asset_tag_pk_fk, tag_type_pk_fk, note_type_pk_fk, note_date_pk)
;

alter table asset_notes add constraint fk_asset_notes_asset_tag foreign key
(asset_tag_pk_fk,tag_type_pk_fk)
references
asset_master (asset_tag_pk, tag_type_pk_ck);

alter table asset_notes add constraint fk_asset_notes_type foreign key
(note_type_pk_fk)
references
note_types (note_type_pk);

CREATE FUNCTION tiu_asset_notes() RETURNS TRIGGER AS $$
  BEGIN
   new.activity_date    := current_date;
   new.user_id          := user;
   new.asset_tag_pk_fk  := upper(new.asset_tag_pk_fk);
   new.tag_type_pk_fk   := upper(new.tag_type_pk_fk);
   new.note_type_pk_fk  := upper(new.note_type_pk_fk);
   new.note_date_pk     := coalesce(new.note_date_pk,current_date);
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_notes BEFORE INSERT OR UPDATE ON asset_notes
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_notes();


