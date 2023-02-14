use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Xmas Hat!', 9.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, 591, 1);
