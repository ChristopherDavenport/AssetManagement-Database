-- Program: create_asset_agreements.sql
-- Purpose: create asset agreements table.
--

create table asset_agreements
(asset_tag_pk_fk         varchar(12)   not null,
 tag_type_pk_fk          varchar(2)    not null,
 agreement_pk_fk         varchar(20)   not null,
 status_ck               varchar(1)    not null,
 status_date             date           not null,
 agreement_start_date    date,
 agreement_end_date      date,
 agreement_amount        decimal(13,2),
 agreement_notes         varchar(4000),
 activity_date           date           not null,
 user_id                 varchar(30)   not null,
 service_type_fk         varchar(20)
);

alter table asset_agreements add constraint pk_asset_agreements primary key
(asset_tag_pk_fk, tag_type_pk_fk, agreement_pk_fk)
;

alter table asset_agreements add constraint fk_asset_agreements_at foreign key
(asset_tag_pk_fk,tag_type_pk_fk)
references
asset_master (asset_tag_pk, tag_type_pk_ck);

alter table asset_agreements add constraint fk_asset_agreements_agreement foreign key
(agreement_pk_fk)
references
agreements (agreement_pk);

-- active, inactive
alter table asset_agreements add constraint ck_asset_agreements_status check (status_ck in ('A','I'));

CREATE FUNCTION tiu_asset_agreements() RETURNS TRIGGER AS $$
begin
   new.activity_date       := current_date;
   new.user_id             := user;
   new.asset_tag_pk_fk     := upper(new.asset_tag_pk_fk);
   new.tag_type_pk_fk      := upper(new.tag_type_pk_fk);
   new.agreement_pk_fk     := upper(new.agreement_pk_fk);
   new.status_ck         := upper(coalesce(new.status_ck,'A'));

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_asset_agreements BEFORE INSERT OR UPDATE ON asset_agreements
  FOR EACH ROW EXECUTE PROCEDURE tiu_asset_agreements();

