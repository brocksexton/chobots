use kavalok;

select id into @shopId from Shop where name = 'futureShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card14_valentine', '', 1000, @shopId, 1, 1, 1);

