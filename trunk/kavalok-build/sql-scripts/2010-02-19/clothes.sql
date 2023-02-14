use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'face_doll_1',	 'F',		0,	@shopId,	1,	1,	1, null),
 ('C', 'face_doll_2',	 'F',		0,	@shopId,	1,	1,	1, null),
 ('C', 'face_doll_3',	 'F',		0,	@shopId,	1,	1,	1, null),
 ('C', 'jet_pack_3',     '&X',           0,      @shopId,        0,      1,      0, 'command=StuffCharModifier;modifier=FlyModifier;speed=6;height=25');
