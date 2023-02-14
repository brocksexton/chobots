use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Die Magie des Regens!', 8.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_buben'), 1),
      (now(), 'Die Magie des Blitzes!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_lightning'), 1),
      (now(), 'Die Magie des Regenbogens!', 8.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_snow'), 1),
      (now(), 'die Magie des Schnees!', 10.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_rainbow'), 1);
	
