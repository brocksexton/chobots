use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'futbolka_deli',	 'M',		0,	@shopId,	0,	0,	0, null),
 ('C', 'futbolka_chobot','M',		0,	@shopId,	0,	0,	0, null),
 ('C', 'hypnotic',	 '#',		900,	@shopId,	0,	1,	0, null),
 ('C', 'sunflower',	 '&',		900,	@shopId,	0,	1,	0, null),
 ('C', 'windmill',	 '&',		900,	@shopId,	0,	1,	0, null),
 ('C', 'bubble',	 'MHLFB',	900,	@shopId,	0,	1,	0, null),
 ('C', 'flag_peace',	 '#',		900,	@shopId,	0,	1,	0, null),
 ('C', 'wings_dragonfly','&',		900,	@shopId,	0,	1,	0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25'),
 ('C', 'ufo_1',	 	 '&MLBNHF',	900,	@shopId,	0,	1,	0, null);

