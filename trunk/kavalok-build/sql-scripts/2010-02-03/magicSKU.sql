use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Heart Animation Magic!', 12.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from StuffType where fileName='magic_heart'), 1);
	
