use kavalok;

insert ignore into Shop (name) values ('cardsShop');
select id into @shopId from Shop where name = 'emptyShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'card1', '', 1000, @shopId, 1, 0, 1)
,('B', 'card2', '', 1000, @shopId, 1, 0, 1)
,('B', 'card3', '', 1000, @shopId, 1, 0, 1)
,('B', 'canab', '', 1000, @shopId, 1, 0, 1)
,('B', 'canab2', '', 1000, @shopId, 1, 0, 1);

select id into @shopId from Shop where name = 'cardsShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
('B', 'blank', '', 25, @shopId, 1, 0, 1);
