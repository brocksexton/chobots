use kavalok;

select id into @shopId from Shop where name = 'futureShop';
-- select id into @shopId from Shop where name = 'magicShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'futbolka_no_lag',	'M',	1000,	@shopId,	0,	0,	0, '');
