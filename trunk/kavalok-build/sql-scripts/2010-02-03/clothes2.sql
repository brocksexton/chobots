use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('S', 'magicbubbleheart',    null,          0,      @shopId,        0,     0,      0, null);
