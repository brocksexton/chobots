insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Spider Mask!', 4.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='mask_spider'), 1),
      (now(), 'Eagle Mask!', 14.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='mask_eagle'), 1),
      (now(), 'Shark Mask!', 9.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='mask_shark'), 1)
      ;
