-- Program: create_dhcp_ranges.sql
-- Purpose: create asset dhcp range table.
--

create table dhcp_ranges
(ip1                   smallint      not null,
 ip2                   smallint      not null,
 ip3                   smallint      not null,
 ip4_start             smallint      not null,
 ip4_end               smallint      not null,
 activity_date         date           not null,
 user_id               varchar(30)   not null
);

create function tiu_dhcp_ranges() returns trigger as $$
  BEGIN
    new.activity_date := current_date;
    new.user_id := user;
  END;
  $$ LANGUAGE plpgsql;


create trigger tiu_dhcp_ranges before insert or update on dhcp_ranges
  for each row EXECUTE PROCEDURE tiu_dhcp_ranges();


