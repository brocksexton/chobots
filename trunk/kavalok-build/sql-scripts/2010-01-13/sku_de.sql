use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), (select name from StuffType where fileName='wings_bat'), 3.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='wings_bat'), 1),
      
      (now(), (select name from StuffType where fileName='wings_griffon'), 10.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false,  (select id from StuffType where fileName='wings_griffon'), 1),

      (now(), (select name from StuffType where fileName='wings_dracon'), 6.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='wings_dracon'), 1);
