use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'wings_bat',	'&',	10000,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25'),
 ('C', 'wings_dracon',	'&',	10000,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25'),
 ('C', 'wings_griffon',	'&',	10000,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25');


