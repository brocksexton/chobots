use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'futbolka_1year',	'M',	1000,	@shopId,	1,	0,	0, '');
