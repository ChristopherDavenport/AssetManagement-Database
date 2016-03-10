-- Program: create_asset_owner_groups.sql
-- Purpose: create asset_owner groups table.
--

create table asset_owner_groups
(asset_owner_group_pk   varchar(12)   not null,
 asset_owner_group_desc varchar(120)  not null,
 status_ck              varchar(1)    not null,
 status_date            date           not null,
 orgn_code              varchar(6),
 activity_date          date           not null,
 user_id                varchar(30)   not null
);

alter table asset_owner_groups add constraint pk_asset_owner_groups primary key
(asset_owner_group_pk);

alter table asset_owner_groups add constraint ck_asset_owner_groups_status check (status_ck in ('A','I'));

CREATE FUNCTION tiu_asset_owner_groups() RETURNS TRIGGER AS $$
  BEGIN
    new.activity_date         := current_date;
    new.user_id               := user;
    new.asset_owner_group_pk  := upper(new.asset_owner_group_pk);
    new.status_ck             := upper(coalesce(new.status_ck,'A'));
    new.orgn_code             := upper(new.orgn_code);

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
  END;
  $$ LANGUAGE plpgsql;

create trigger tiu_asset_owner_groups BEFORE INSERT OR UPDATE ON asset_owner_groups
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_owner_groups();

