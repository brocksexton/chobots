use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Rain Magic', 12.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_buben'), 1),
      (now(), 'Lightning Magic!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_lightning'), 1),
      (now(), 'Snow Magic!', 12.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_snow'), 1),
      (now(), 'Rainbow Magic!', 15.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_rainbow'), 1);
	
use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Rudolph', 4.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where id=572), 1),
      (now(), 'Santa', 14.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where id=576), 1),
      (now(), 'Snowman', 9.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where id=578), 1)
      ;
	
