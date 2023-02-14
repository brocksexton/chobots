use kavalok;

select id into @shopId from Shop where name = 'futureShop';
-- select id into @shopId from Shop where name = 'cardsShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card8_halloween', '', 300, @shopId, 1, 0, 1);

