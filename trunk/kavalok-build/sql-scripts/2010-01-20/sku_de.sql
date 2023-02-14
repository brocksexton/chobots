use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), (select name from StuffType where fileName='mask_spider'), 3.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='mask_spider'), 1),
      
      (now(), (select name from StuffType where fileName='mask_eagle'), 10.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false,  (select id from StuffType where fileName='mask_eagle'), 1),

      (now(), (select name from StuffType where fileName='mask_shark'), 6.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='mask_shark'), 1);
