update RobotType set useCount=1 where name='energyRepair1';
update RobotType set useCount=1 where name='energyRepair2';
update RobotType set useCount=1, price=500 where name='lighting';

update RobotItem set remains=1 where type_id in (select id from RobotType where name='energyRepair1');
update RobotItem set remains=1 where type_id in (select id from RobotType where name='energyRepair2');
update RobotItem set remains=1 where type_id in (select id from RobotType where name='lighting');

insert into RobotType (name,	info,	level,	catalog,	placement,	price,
  hasColor,	premium,	attack,	defence,	 accuracy,	mobility, 	lifeTime,	useCount,	energy,	robotName,	percent)
values
('attackPlus2', '', 1, 'robotItems', 'A', 0, FALSE, FALSE, 4, 0, 0, 0, 14, -1, 0, '*', 0);

insert into RobotSKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, robotType_id)
values(now(), 'Rush Attack', 7.99, 1, 'USD','usdSign', 'usd', 'usdCents', now(), null, false, (select id from RobotType where name='attackPlus2'));

insert into RobotSKU(created, name,  price, currency, currencyCode, currencySign, currencyText, currencyCentsText, startDate, endDate, specialOffer, robotType_id)
values(now(), 'Schnellangriff', 7.99, 2, 'EUR','euroSign', 'euro', 'euroCents', now(), null, false, (select id from RobotType where name='attackPlus2'));

