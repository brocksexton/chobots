use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'paa', 'MLBNF', 1000, @futureShop, 0, 0, 0, ''),
('C', 'futbolka_jessie', 'M', 1000, @futureShop, 0, 0, 0, ''),
('C', 'turkey_suit', 'MLBNF', 1000, @futureShop, 0, 0, 0, '');
