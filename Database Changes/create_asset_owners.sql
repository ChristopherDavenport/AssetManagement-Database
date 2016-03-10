-- Program: create_asset_owners.sql
-- Purpose: create asset_owners table.
--

create table asset_owners
(asset_owner_pk        varchar(12)   not null,
 asset_owner_desc      varchar(120)  not null,
 status_ck             varchar(1)    not null,
 status_date           date           not null,
 orgn_code             varchar(6),
 activity_date         date           not null,
 user_id               varchar(30)   not null,
 asset_owner_group_fk  varchar(12)
);

alter table asset_owners add constraint pk_asset_owners primary key
(asset_owner_pk);

alter table asset_owners add constraint ck_asset_owners_status check (status_ck in ('A','I'));

alter table asset_owners add constraint fk_asset_owner_asset_owner_group FOREIGN KEY
 (asset_owner_group_fk)
 REFERENCES
 asset_owner_groups(asset_owner_group_pk);

CREATE FUNCTION tiu_asset_owners() RETURNS TRIGGER AS $$
begin
   new.activity_date        := current_date;
   new.user_id              := user;
   new.asset_owner_pk       := upper(new.asset_owner_pk);
   new.status_ck            := upper(coalesce(new.status_ck,'A'));
   new.orgn_code            := upper(new.orgn_code);
   new.asset_owner_group_fk := upper(new.asset_owner_group_fk);

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_owners BEFORE INSERT OR UPDATE ON asset_owners
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_owners();

