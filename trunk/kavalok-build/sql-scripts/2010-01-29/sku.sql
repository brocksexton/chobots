insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'UFO Ship Suit!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='ufo_1'), 1)
      
      ;
