use kavalok;

select id into @shopId from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card11_snow', '', 1000, @shopId, 1, 0, 1),
('B', 'card12_mountain', '', 1000, @shopId, 1, 0, 1);
