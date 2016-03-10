-- program: v_asset_ips.sql
-- purpose: view for ITS asset ips
--


create or replace view v_asset_ips
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
 STAFF_NAME,
 BUILDING,
 LOCATION,
 LAST_INVENTORIED,
 MAC_ADDRESS,
 MAC_ADDRESS_NOTES,
 IP_TYPE,
 IP,
 IP_SORT,
 IP1,
 IP2,
 IP3,
 IP4,
 IP_STATUS_CK,
 IP_STATUS_DATE,
 IP_NOTES
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
       STAFF_MEMBER,
       BUILDING_FK,
       LOCATION,
       LAST_INV_VERIFY,
       MAC_ADDRESS_U,
       MAC_ADDRESS_NOTES,
       IP_TYPE_CK,
       CASE WHEN (IP1_U::text || IP2_U::text || IP3_U::TEXT || IP4_U::TEXT) IS null THEN null ELSE IP1_U||'.'||IP2_U||'.'||IP3_U||'.'||IP4_U END,
       CASE WHEN (IP1_U::TEXT || IP2_U::TEXT || IP3_U::TEXT || IP4_U::TEXT) is null THEN null ELSE lpad(IP1_U::TEXT,3,'0')||'.'||lpad(IP2_U::TEXT,3,'0')||'.'||lpad(IP3_U::TEXT,3,'0')||'.'||lpad(IP4_U::TEXT,3,'0') END,
       IP1_U,
       IP2_U,
       IP3_U,
       IP4_U,
       ai.STATUS_CK,
       ai.STATUS_DATE,
       IP_NOTES
from   asset_master am
          inner join asset_types
             inner join asset_groups
                on  ASSET_GROUP_FK = ASSET_GROUP_PK
             on  ASSET_TYPE_FK = ASSET_TYPE_PK 
          left outer join manufacturers
             on  MANUFACTURER_FK = MANUFACTURER_PK
          left outer join vendors
             on  VENDOR_FK = VENDOR_PK
          left outer join asset_ips ai
             on  asset_tag_pk = asset_tag_pk_fk
             and tag_type_pk_ck = tag_type_pk_fk
where  IP_RPT_CK = 'Y'
;
