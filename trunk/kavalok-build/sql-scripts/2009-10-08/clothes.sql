use kavalok;

select id into @shopId from Shop where name = 'futureShop';
-- select id into @shopId from Shop where name = 'magicShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'pumpkin_mask',	'F',	  350,	@shopId,	0,	0,	0, '')
,('C', 'pumpkin_head',	'MBNF',	1000,	@shopId,	0,	1,	0, '')
,('C', 'witch',	        'MBNH',	1000,	@shopId,	0,	1,	0, '')
,('C', 'umbrella',    	'&',	  600,	@shopId,	0,	1,	0, '')
,('C', 'futbolka_pie',	'M',	  550,	@shopId,	1,	0,	0, '')
,('C', 'vampire',		    'HF', 	600,	@shopId,	0,	1,	0, '')
,('C', 'plasch_vampire','M',	  800,	@shopId,	0,	1,	0, '');

