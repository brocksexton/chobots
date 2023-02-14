use kavalok;

-- select id into @shopId from Shop where name = 'futureShop';
select id into @shopId from Shop where name = 'cardsShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card4', '', 1000, @shopId, 1, 0, 1)
,('B', 'card5', '', 1000, @shopId, 1, 0, 1)
,('B', 'card6', '', 1000, @shopId, 1, 0, 1)
,('B', 'card7', '', 1000, @shopId, 1, 0, 1);

