-- program: v_asset_agreements.sql
-- purpose: view for ITS asset agreements
--

create or replace view v_asset_agreements
(ASSET_TAG,
 TAG_TYPE,
 ASSET_DESCRIPTION,
 ASSET_STATUS,
 ASSET_STATUS_DATE,
 SERIAL_NUMBER,
 PRODUCT_ID,
 ASSET_GROUP,
 ASSET_GROUP_DESCRIPTION,
 ASSET_TYPE,
 ASSET_TYPE_DESCRIPTION,
 MODEL_NUMBER,
 MANUFACTURER,
 MANUFACTURER_DESCRIPTION,
 VENDOR,
 VENDOR_DESCRIPTION,
 ASSET_OWNER,
 STAFF_USERID,
 BUILDING,
 LOCATION,
 AGREEMENT,
 SERVICE_TYPE,
 SERVICE_TYPE_DESC,
 AGREEMMENT_STATUS,
 AGREEMENT_STATUS_DATE,
 AGREEMENT_START_DATE,
 AGREEMENT_END_DATE,
 AGREEMENT_AMOUNT,
 AGREEMENT_NOTES
)
as
select ASSET_TAG_PK,
       TAG_TYPE_PK_CK,
       ASSET_DESC,
       am.STATUS_CK,
       am.STATUS_DATE,
       SERIAL_NUMBER_U,
       PRODUCT_ID,
       ASSET_GROUP_FK,
       ASSET_GROUP_DESC,
       ASSET_TYPE_FK,
       ASSET_TYPE_DESC,
       MODEL_NUMBER,
       MANUFACTURER_FK,
       MANUFACTURER_DESC,
       VENDOR_FK,
       VENDOR_DESC,
       ASSET_OWNER_FK,
       STAFF_USERID,
       BUILDING_FK,
       LOCATION,        
       AGREEMENT_PK_FK,
       SERVICE_TYPE_FK,
       SERVICE_TYPE_DESC,
       aa.STATUS_CK,
       aa.STATUS_DATE,
       AGREEMENT_START_DATE,
       AGREEMENT_END_DATE,
       AGREEMENT_AMOUNT,
       AGREEMENT_NOTES       
from   asset_master am
          inner join asset_types
             inner join asset_groups
                on  ASSET_GROUP_FK = ASSET_GROUP_PK
             on  ASSET_TYPE_FK = ASSET_TYPE_PK 
          left outer join manufacturers
             on  MANUFACTURER_FK = MANUFACTURER_PK
          left outer join vendors
             on  VENDOR_FK = VENDOR_PK
          left outer join asset_agreements aa
             inner join service_types
                on  SERVICE_TYPE_FK = SERVICE_TYPE_PK
             on  asset_tag_pk   = asset_tag_pk_fk
             and tag_type_pk_ck = tag_type_pk_fk
;
