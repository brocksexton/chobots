insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Beach Background!', 4.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='card9_beach'), 1),
      (now(), 'Mountain Background!', 4.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='card12_mountain'), 1) 	
      ;
