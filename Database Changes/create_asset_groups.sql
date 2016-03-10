-- Program: create_asset_groups.sql
-- Purpose: create asset types table.
--

create table asset_groups
(asset_group_pk     varchar(12)   not null,
 asset_group_desc   varchar(120)  not null,
 status_ck          varchar(1)    not null,
 status_date        date           not null,
 activity_date      date           not null,
 user_id            varchar(30)   not null,
 ip_rpt_ck          varchar(1)    not null
);

alter table asset_groups add constraint pk_asset_groups primary key
(asset_group_pk);

alter table asset_groups add constraint ck_asset_groups_status check (status_ck in ('A','I'));
alter table asset_groups add constraint ck_asset_groups_ip_rpt check (ip_rpt_ck in ('Y','N'));

CREATE FUNCTION tiu_asset_groups() RETURNS TRIGGER AS $$
begin
   new.activity_date   := current_date;
   new.user_id         := user;
   new.asset_group_pk  := upper(new.asset_group_pk);
   new.status_ck       := upper(coalesce(new.status_ck,'A'));
   new.ip_rpt_ck       := upper(new.ip_rpt_ck);
   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_groups BEFORE INSERT OR UPDATE ON asset_groups
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_groups();


