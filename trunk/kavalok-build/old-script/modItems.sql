use kavalok;
select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'bones',	'MLBNHF',	2500, @shopId,	0,	1,	1, null)
,('C', 'butterfly',	'M',	500, @shopId,	1,	1,	1, null)
,('C', 'china_dragon_mask',	'H',	500, @shopId,	0,	1,	0, null)
,('C', 'cook',	'MH',	500, @shopId,	0,	1,	1, null)
,('C', 'hat_china',	'H',	500, @shopId,	0,	0,	1, null)
,('C', 'hat_indian',	'H',	500, @shopId,	1,	0,	1, null)
,('C', 'hat_turkish',	'H',	500, @shopId,	0,	0,	1, null)
,('C', 'kostum_indian_boy',	'MLB',	500, @shopId,	0,	1,	1, null)
,('C', 'kostum_indian_girl',	'M',	500, @shopId,	0,	1,	1, null)
,('C', 'peruka_indian',	'H',	500, @shopId,	0,	1,	1, null);
