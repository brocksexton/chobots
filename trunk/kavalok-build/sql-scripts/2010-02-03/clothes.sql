use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'magic_hat',	 'H',		0,	@shopId,	0,	1,	0, null),
 ('C', 'magic_heart',    '&I',          0,      @shopId,        0,      1,      0, 'command=MagicItem;name=hearts'),
 ('C', 'nichos_suit',    'MHF',		0,	@shopId,	0,	1,	0, null),
 ('C', 'feather',	 'I',		0,	@shopId,	0,	1,	0, null),
 ('C', 'futbolka_house', 'M',		0,	@shopId,	1,	1,	0, null),
 ('C', 'dress_7',	 'MN',		0,	@shopId,	0,	1,	0, null),
 ('C', 'dress_8',	 'M',		0,	@shopId,	0,	1,	0, null),
 ('C', 'dress_9',	 'MN',		0,	@shopId,	0,	1,	0, null),
 ('C', 'hat_c',	         'H',		0,	@shopId,	1,	1,	0, null),
 ('C', 'hat_panamka',    'H',		0,	@shopId,	1,	1,	0, null),
 ('C', 'peruka_14',      'H',		0,	@shopId,	1,	1,	0, null),
 ('C', 'peruka_emo6',    'H',		0,	@shopId,	1,	1,	0, null),
 ('C', 'smoking',	 'MLBN',	0,	@shopId,	0,	1,	0, null);
