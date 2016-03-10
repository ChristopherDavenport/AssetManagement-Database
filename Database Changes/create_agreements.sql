-- Program: create_agreements.sql
-- Purpose: create agreements table.
--

create table agreements
(agreement_pk         varchar(20)   not null,
 agreement_desc       varchar(120)  not null,
 agreement_type_ck    varchar(1)    not null,
 status_ck            varchar(1)    not null,
 status_date          date           not null,
 agreement_reference  varchar(100),
 license_type_ck      varchar(2),
 renewal_period       varchar(100),
 agreement_start_date date,
 agreement_end_date   date,
 vendor_fk            varchar(12),
 agreement_amount     decimal(13,2),
 notes                varchar(2000),
 activity_date        date           not null,
 user_id              varchar(30)   not null,
 service_type_fk      varchar(20)
);

alter table agreements add constraint pk_agreements primary key
(agreement_pk);

-- maintenance, software
alter table agreements add constraint ck_agreements_at check (agreement_type_ck in ('M','S'));

-- active, inactive
alter table agreements add constraint ck_agreements_status check (status_ck in ('A','I'));

-- concurrent, ipeds, named users, processor
alter table agreements add constraint ck_agreements_lt check (license_type_ck in ('C','I','NU','P'));

alter table agreements add constraint fk_agreements_vendor foreign key
(vendor_fk)
references
vendors (vendor_pk);

CREATE FUNCTION tiu_agreements() returns trigger as $$
BEGIN
   new.activity_date     := current_date;
   new.user_id           := user;
   new.agreement_pk      := upper(new.agreement_pk);
   new.status_ck         := upper(coalesce(new.status_ck,'A'));
   new.agreement_type_ck := upper(new.agreement_type_ck);
   new.license_type_ck   := upper(new.license_type_ck);
   new.vendor_fk         := upper(new.vendor_fk);
   new.service_type_fk   := upper(new.service_type_fk);

   if (old.status_ck <> new.status_ck) or
     old.status_ck is null then
      new.status_date := current_date;
   end if;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tiu_agreements BEFORE INSERT OR UPDATE ON agreements
  FOR EACH ROW EXECUTE PROCEDURE tiu_agreements();
