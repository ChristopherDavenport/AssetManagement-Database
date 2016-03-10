-- Program: create_asset_ips.sql
-- Purpose: create asset ips table.
--

create table asset_ips
(asset_tag_pk_fk         varchar(12)   not null,
 tag_type_pk_fk          varchar(2)    not null,
 seq_pk                  int         not null,
 mac_address_u           varchar(12),
 mac_address_notes       varchar(100),
 ip1_u                   SMALLINT,
 ip2_u                   SMALLINT,
 ip3_u                   SMALLINT,
 ip4_u                   SMALLINT,
 status_ck               varchar(1),
 status_date             date,
 ip_notes                varchar(100),
 activity_date           date           not null,
 user_id                 varchar(30)   not null
);

alter table asset_ips add constraint pk_asset_ips primary key
(asset_tag_pk_fk, tag_type_pk_fk, seq_pk);

alter table asset_ips add constraint fk_asset_ips_asset_tag foreign key
(asset_tag_pk_fk,tag_type_pk_fk)
references
asset_master (asset_tag_pk, tag_type_pk_ck);

--alter table asset_ips add constraint fk_asset_master_mac unique
--(mac_address_u);

--alter table asset_ips add constraint fk_asset_master_ip unique
--(ip1_u,ip2_u,ip3_u,ip4_u);

-- active, inactive,DHCP
alter table asset_ips add constraint ck_asset_ips_status check (status_ck in ('A','I','D',null));

CREATE FUNCTION tiu_asset_ips() RETURNS TRIGGER AS $$
  BEGIN 
    new.activity_date    := current_date;
   new.user_id          := user;
   new.asset_tag_pk_fk  := upper(new.asset_tag_pk_fk);
   new.tag_type_pk_fk   := upper(new.tag_type_pk_fk);
   new.status_ck        := upper(new.status_ck);
   new.mac_address_u    := upper(new.mac_address_u);

   if new.status_ck is null then
      new.status_date := null;
   elsif (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;

   if new.seq_pk is null then
      select coalesce(max(seq_pk),0) + 1
      into   new.seq_pk
      from   asset_ips
      where  asset_tag_pk_fk = new.asset_tag_pk_fk
      and    tag_type_pk_fk  = new.tag_type_pk_fk;
   end if;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_ips BEFORE INSERT OR UPDATE ON asset_ips
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_ips();


