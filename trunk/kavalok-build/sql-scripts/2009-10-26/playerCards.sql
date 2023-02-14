use kavalok;

select id into @shopId from Shop where name = 'futureShop';
-- select id into @shopId from Shop where name = 'cardsShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card9_beach', '', 250,@shopId, 1, 0, 1),
('B', 'card10_stars', '', 250, @shopId, 1, 0, 1);

