-- Program: create_asset_master.sql
-- Purpose: create asset master table
--


create table asset_master
(asset_tag_pk            varchar(12)   not null,
 tag_type_pk_ck          varchar(2)    not null,
 asset_desc              varchar(120),
 status_ck               varchar(1)    not null,
 status_date             date           not null,
 serial_number_u         varchar(30),
 asset_type_fk           varchar(12)   not null,
 model_number            varchar(60),
 manufacturer_fk         varchar(12),
 vendor_fk               varchar(12),
 purchase_order          varchar(30),
 purchase_date           date,
 invoice                 varchar(15),
 warranty_start_date     date,
 warranty_end_date       date,
 asset_owner_fk          varchar(12),
 staff_userid            varchar(12),
 building_fk             varchar(6),
 location                varchar(60),
 ip_type_ck              varchar(1),
 cpu_speed               varchar(20),
 memory                  varchar(20),
 alt_asset_tag           varchar(12),
 alt_tag_type_ck         varchar(2),
 activity_date           date           not null,
 user_id                 varchar(30)   not null,
 product_id              varchar(60),
 staff_member            varchar(60),
 processor_type          varchar(60),
 encrypted_ck            varchar(1)    not null,
 last_inv_verify         date
);

alter table asset_master add constraint pk_asset_master primary key
(asset_tag_pk, tag_type_pk_ck);

-- create index asset_master_sn_idx on asset_master
-- (serial_number_u)
-- tablespace development
-- storage (initial 256K next 256K);

alter table asset_master add constraint fk_asset_master_asset_type foreign key
(asset_type_fk)
references
asset_types (asset_type_pk);

alter table asset_master add constraint fk_asset_master_manufacturer foreign key
(manufacturer_fk)
references
manufacturers (manufacturer_pk);

alter table asset_master add constraint fk_asset_master_vendor foreign key
(vendor_fk)
references
vendors (vendor_pk);

alter table asset_master add constraint fk_asset_master_asset_owner foreign key
(asset_owner_fk)
references
asset_owners (asset_owner_pk);

alter table asset_master add constraint fk_asset_master_building foreign key
(building_fk)
references
buildings (building_code);

-- eckerd, print counts, other, Xerographics
alter table asset_master add constraint ck_asset_master_tag_type check (tag_type_pk_ck in ('E','PC','O','X'));
alter table asset_master add constraint ck_asset_master_alt_tag_type check (alt_tag_type_ck in ('E','PC','X',null));
-- active, inactive, missing, deleted
alter table asset_master add constraint ck_asset_master_status check (status_ck in ('A','I','M','D'));
-- static, dynamic
alter table asset_master add constraint ck_asset_master_ip_type_ck check (ip_type_ck in ('S','D',null));
-- yes,no
alter table asset_master add constraint ck_asset_master_encrypted_ck check (encrypted_ck in ('Y','N'));

CREATE FUNCTION tiu_asset_master() RETURNS TRIGGER AS $$
begin
   new.activity_date    := current_date;
   new.user_id          := user;
   new.tag_type_pk_ck   := upper(coalesce(new.tag_type_pk_ck,'E'));
   if new.tag_type_pk_ck = 'E' then
      new.asset_tag_pk := substr(lpad(upper(new.asset_tag_pk),12,'0'),8,5);
   else
      new.asset_tag_pk := upper(new.asset_tag_pk);
   end if;
   new.serial_number_u  := upper(new.serial_number_u);
   new.status_ck        := upper(coalesce(new.status_ck,'A'));
   new.asset_type_fk    := upper(new.asset_type_fk);
   new.manufacturer_fk  := upper(new.manufacturer_fk);
   new.vendor_fk        := upper(new.vendor_fk);
   new.asset_owner_fk   := upper(new.asset_owner_fk);
   new.building_fk      := upper(new.building_fk);
   new.staff_userid     := lower(new.staff_userid);
   new.alt_asset_tag    := upper(new.alt_asset_tag);
   new.alt_tag_type_ck  := upper(new.alt_tag_type_ck);
   new.encrypted_ck     := upper(coalesce(new.encrypted_ck,'N'));
   new.ip_type_ck       := upper(new.ip_type_ck);

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;

end;
$$ LANGUAGE plpgsql;

CREATE FUNCTION tu_asset_master() RETURNS TRIGGER AS $$
  begin
      insert into asset_history
      (asset_tag,
       asset_desc,
       status_ck,
       status_date,
       serial_number,
       asset_type_fk,
       model_number,
       product_id,
       manufacturer_fk,
       vendor_fk,
       purchase_order,
       purchase_date,
       invoice,
       warranty_start_date,
       warranty_end_date,
       asset_owner_fk,
       staff_userid,
       building_fk,
       location,
       ip_type_ck,
       cpu_speed,
       memory,
       alt_asset_tag,
       alt_tag_type_ck,
       activity_date,
       user_id,
       staff_member,
       processor_type,
       encrypted_ck
      )
      values
      (old.asset_tag_pk,
       old.asset_desc,
       old.status_ck,
       old.status_date,
       old.serial_number_u,
       old.asset_type_fk,
       old.model_number,
       old.product_id,
       old.manufacturer_fk,
       old.vendor_fk,
       old.purchase_order,
       old.purchase_date,
       old.invoice,
       old.warranty_start_date,
       old.warranty_end_date,
       old.asset_owner_fk,
       old.staff_userid,
       old.building_fk,
       old.location,
       old.ip_type_ck,
       old.cpu_speed,
       old.memory,
       old.alt_asset_tag,
       old.alt_tag_type_ck,
       old.activity_date,
       old.user_id,
       old.staff_member,
       old.processor_type,
       old.encrypted_ck
      );
  end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_master BEFORE INSERT OR UPDATE ON asset_master
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_master();

CREATE TRIGGER tu_asset_master BEFORE UPDATE ON asset_master
  FOR EACH ROW when (upper(new.tag_type_pk_ck) = 'E') EXECUTE PROCEDURE tu_asset_master();



