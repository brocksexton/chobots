use kavalok;

insert into SKU(created, name, bugsBonus, price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), '50000 Bugs',  50000,   7.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='coins1'), 1),
      (now(), '100000 Bugs', 100000, 12.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='coins2'), 1),
      (now(), '300000 Bugs',  300000, 29.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='coins3'), 1);