use kavalok;

select id into @shopId from Shop where name = 'emptyShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
 ('C', 'wellgames',	'M',	1000,	@shopId,	0,	0,	0)
,('C', 'chrisdog',	'M',	1000,	@shopId,	0,	0,	1)
,('C', 'flag_mimo_logo',	'&',	1000,	@shopId,	1,	0,	0)
,('C', 'futbolka_mimo',	'M',	1000,	@shopId,	0,	0,	0);

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
 ('C', 'zorro',	'MLBNHF',	1350,	@shopId,	0,	1,	1)
,('C', 'papuas',	'MLBNHF',	1200,	@shopId,	0,	1,	1)
,('C', 'eskimos',	'MLBNHF',	1250,	@shopId,	0,	1,	1)
,('C', 'dress_5',	'M',	800,	@shopId,	1,	1,	1)
,('C', 'english_guardian',	'MLBNHF',	800,	@shopId,	0,	1,	1)
,('C', 'hat_paper',	'H',	800,	@shopId,	0,	1,	1)
,('C', 'kostium_8',	'M',	800,	@shopId,	1,	1,	1)
,('C', 'peruka_10',	'H',	800,	@shopId,	1,	1,	1)
,('C', 'peruka_11',	'H',	800,	@shopId,	1,	1,	1)
,('C', 'sansey',	'MLBNHF',	800,	@shopId,	0,	1,	1)
,('C', 'video_camera',	'I',	800,	@shopId,	0,	1,	1)
,('C', 'banana',	'M',	800,	@shopId,	0,	1,	1)
,('C', 'basketbollist',	'MLBN',	800,	@shopId,	1,	1,	1)
,('C', 'corn',	'M',	800,	@shopId,	0,	1,	1)
,('C', 'flag_chobots',	'&',	800,	@shopId,	1,	1,	1)
,('C', 'ice_wings',	'N',	800,	@shopId,	0,	1,	1)
,('C', 'mask_alien',	'F',	800,	@shopId,	0,	1,	1)
,('C', 'Niceplayer',	'M',	800,	@shopId,	0,	1,	1)
,('C', 'strawberries',	'M',	800,	@shopId,	0,	1,	1);
