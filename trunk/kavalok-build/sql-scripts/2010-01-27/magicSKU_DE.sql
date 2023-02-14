use kavalok;

insert into SKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, itemTypeId, type)
values(now(), 'Magie,die blauen Luftballsregen macht!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_blue'), 1),
      (now(), 'Magie,die roten Luftballsregen macht!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_red'), 1),
      (now(), 'Magie,die gelben Luftballsregen macht!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_air_ball_yellow'), 1),
      (now(), 'Magie, die SterneRegen macht!', 13.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from StuffType where fileName='magic_star'), 1);
	
