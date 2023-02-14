use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'mask_shark',	'F',	10000,	@shopId,	0,	1,	0, null),
 ('C', 'mask_spider',	'F',	10000,	@shopId,	0,	1,	0, null),
 ('C', 'mask_eagle',	'F',	10000,	@shopId,	0,	1,	0, null),
 ('C', 'mask_alien_2',	'F',	1000,	@shopId,	0,	1,	0, null),
 ('C', 'mask_alien_3',	'F',	1000,	@shopId,	0,	1,	0, null);


