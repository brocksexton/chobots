use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Blue Balloon Rain Magic!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_blue'), 1),
      (now(), 'Red Balloon Rain Magic!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_red'), 1),
      (now(), 'Yellow Balloon Rain Magic!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_yellow'), 1),
      (now(), 'Star Rain Magic!', 19.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_star'), 1);
	

