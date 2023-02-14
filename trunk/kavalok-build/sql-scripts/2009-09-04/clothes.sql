use kavalok;

select id into @shopId from Shop where name = 'futureShop';
-- select id into @shopId from Shop where name = 'magicShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'golden_wings',	'&',	1000,	@shopId,	0,	1,	0, '')
,('C', 'flag',			'&',	1000,	@shopId,	1,	0,	0, '')
,('C', 'flag_agent',	'&',	1000,	@shopId,	1,	0,	0, '')
,('C', 'flag_heart',	'&',	1000,	@shopId,	1,	0,	0, '')
,('C', 'flag_smile',	'&',	1000,	@shopId,	1,	0,	0, '')
,('C', 'flag_sun',		'&',	1000,	@shopId,	1,	0,	0, '')
,('C', 'futbolka_999',	'M',	1000,	@shopId,	1,	0,	0, '')
,('C', 'jet_pack',		'&X',	5000,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25')
,('C', 'jet_pack2',		'&X',	6000,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25')
,('C', 'fiuchobot',		'MLBNHF', 750,	@shopId,	0,	1,	0, '');



