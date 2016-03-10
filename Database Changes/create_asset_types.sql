-- Program: create_asset_types.sql
-- Purpose: create asset types table.
--


create table asset_types
(asset_type_pk      varchar(12)   not null,
 asset_type_desc    varchar(120)  not null,
 status_ck          varchar(1)    not null,
 status_date        date           not null,
 activity_date      date           not null,
 user_id            varchar(30)   not null,
 asset_group_fk     varchar(12)   not null
);

alter table asset_types add constraint pk_asset_types primary key
(asset_type_pk);

alter table asset_types add constraint fk_asset_types_asset_group foreign key
(asset_group_fk)
references
asset_groups (asset_group_pk);

alter table asset_types add constraint ck_asset_types_status check (status_ck in ('A','I'));

CREATE FUNCTION tiu_asset_types() RETURNS TRIGGER AS $$
begin
    new.activity_date   := current_date;
    new.user_id         := user;
    new.asset_type_pk   := upper(new.asset_type_pk);
    new.status_ck       := upper(coalesce(new.status_ck,'A'));
    new.asset_group_fk  := upper(new.asset_group_fk);

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_types BEFORE INSERT OR UPDATE ON asset_types
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_types();


