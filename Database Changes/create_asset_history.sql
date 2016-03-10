-- Program: create_asset_history.sql
-- Purpose: create asset history table
--

create table asset_history
(asset_tag               varchar(12)   not null,
 asset_desc              varchar(120),
 status_ck               varchar(1)    not null,
 status_date             date           not null,
 serial_number           varchar(30),
 asset_type_fk           varchar(12)   not null,
 model_number            varchar(60),
 product_id              varchar(60),
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
 mac_address             varchar(14),
 cpu_speed               varchar(20),
 memory                  varchar(20),
 alt_asset_tag           varchar(12),
 alt_tag_type_ck         varchar(2),
 activity_date           date           not null,
 user_id                 varchar(30)   not null,
 staff_member            varchar(60),
 processor_type          varchar(60),
 encrypted_ck            varchar(1)    not null,
 last_inv_verify         date
);

create index asset_history_index on asset_history 
(asset_tag);

alter table asset_history add constraint fk_asset_history_asset_type foreign key
(asset_type_fk)
references
asset_types (asset_type_pk);

alter table asset_history add constraint fk_asset_history_manufacturer foreign key
(manufacturer_fk)
references
manufacturers (manufacturer_pk);

alter table asset_history add constraint fk_asset_history_vendor foreign key
(vendor_fk)
references
vendors (vendor_pk);

alter table asset_history add constraint fk_asset_history_asset_owner foreign key
(asset_owner_fk)
references
asset_owners (asset_owner_pk);

alter table asset_history add constraint fk_asset_history_building foreign key
(building_fk)
references
buildings (building_code);

-- active, inactive, deleted
alter table asset_history add constraint ck_asset_history_status check (status_ck in ('A','I','D'));
-- static, dynamic
alter table asset_history add constraint ck_asset_history_ip_type_ck check (ip_type_ck in ('S','D',null));
-- yes,no
alter table asset_history add constraint ck_asset_history_encrypted_ck check (encrypted_ck in ('Y','N'));

