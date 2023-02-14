use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Anzug des Schiffs UFO!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='ufo_1'), 1);
