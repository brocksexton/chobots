use kavalok;

select id into @shopId from Shop where name = 'emptyShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
 ('C', 'brush', 'I', 1000, @shopId, 0, 0, 1);

