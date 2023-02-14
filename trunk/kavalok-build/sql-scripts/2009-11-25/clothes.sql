use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';
select id into @itemOfTheMonth from Shop where name = 'itemOfTheMonth';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'deer', 'H', 450, @futureShop, 0, 0, 1, ''),
('C', 'deer_head', 'H', 0, @itemOfTheMonth, 0, 1, 0, ''),
('C', 'present_bag', '&', 500, @futureShop, 0, 0, 1, ''),
('C', 'present_box', '&', 500, @futureShop, 0, 1, 1, ''),
('C', 'present_sock', '&', 500, @futureShop, 0, 1, 1, ''),
('C', 'santa', 'MLBNHF', 0, @itemOfTheMonth, 0, 1, 0, ''),
('C', 'snowgirl', 'MLBNHF', 870, @futureShop, 0, 1, 1, ''),
('C', 'snowman', 'MLBNHF', 0, @itemOfTheMonth, 0, 1, 0, ''),
('C', 'xmas_tree', 'MLNHF', 900, @futureShop, 0, 1, 1, '');

