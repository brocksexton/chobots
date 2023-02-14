use kavalok;

insert into SKU(created, name, bugsBonus, price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values
      (now(), '50000 Blech',  50000,   5.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='coins1'), 1),
      (now(), '100000 Blech', 100000, 8.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='coins2'), 1),
      (now(), '300000 Blech', 300000,   19.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='coins3'), 1);