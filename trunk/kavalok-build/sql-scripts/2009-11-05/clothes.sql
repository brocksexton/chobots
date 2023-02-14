use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'firework', '&', 900, @futureShop, 0, 0, 1, ''),
('C', 'tnt', '&', 900, @futureShop, 0, 1, 1, '');
