use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), (select name from StuffType where id=575), 3.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, 575, 1),
      
      (now(), (select name from StuffType where id=581), 6.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false,  581, 1),

      (now(), (select name from StuffType where id=579), 10.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, 579, 1);
