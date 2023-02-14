use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), (select name from StuffType where fileName='bubble'), 10.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='bubble'), 1),
      
      (now(), (select name from StuffType where fileName='white_bear'), 6.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false,  (select id from StuffType where fileName='white_bear'), 1),

      (now(), (select name from StuffType where fileName='hypnotic'), 6.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='hypnotic'), 1),

      (now(), (select name from StuffType where fileName='peruka_indian'), 3.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='peruka_indian'), 1)

;


