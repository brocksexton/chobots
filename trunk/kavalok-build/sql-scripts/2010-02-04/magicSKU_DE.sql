use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Magie,die Herz Luftballsregen macht!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magicbubbleheart'), 1);
	
