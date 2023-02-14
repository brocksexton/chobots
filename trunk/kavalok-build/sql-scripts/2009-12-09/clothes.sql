-- Pattern: /(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/g
-- Replace: ('C', '$1', '$2', $3, @$4, $5, $6, $7, ''),

use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';
select id into @itemOfTheMonth from Shop where name = 'itemOfTheMonth';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'flag_robots', '#', 0, @emptyShop, 0, 0, 0, ''),
('C', 'robo_jacket', 'M', 0, @emptyShop, 0, 0, 0, '');
