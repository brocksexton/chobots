insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Bubble Costume!', 14.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='bubble'), 1),
      (now(), 'Bear Costume!', 9.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='white_bear'), 1),
      (now(), 'Hypnotic!', 9.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='hypnotic'), 1),
      (now(), 'Indian Hair!', 4.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='peruka_indian'), 1)
      ;
