use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'face_boy_1',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'face_boy_2',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'face_boy_3',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'face_doll_4',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'face_doll_5',	 'FH',		0,	@shopId,	0,	0,	0, null),
 ('C', 'face_doll_6',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'face_doll_7',	 'FH',		0,	@shopId,	1,	0,	0, null),
 ('C', 'magic_speed',	 'M',		0,	@shopId,	0,	0,	0, null),
 ('C', 'dress_7_reg',	 'MN',		0,	@shopId,	0,	0,	0, null);