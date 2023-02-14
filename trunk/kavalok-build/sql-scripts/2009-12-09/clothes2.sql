-- Pattern: /(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/g
-- Replace: ('C', '$1', '$2', $3, @$4, $5, $6, $7, ''),

use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';
select id into @itemOfTheMonth from Shop where name = 'itemOfTheMonth';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'holiday_hat', 'H', 900, @futureShop, 0, 0, 0, ''),
('C', 'winter_hat1', 'H', 900, @futureShop, 1, 1, 0, ''),
('C', 'winter_hat2', 'H', 900, @futureShop, 1, 1, 0, ''),
('C', 'winter_hat3', 'H', 900, @futureShop, 1, 1, 0, ''),
('C', 'winter_hat4', 'H', 900, @futureShop, 0, 1, 0, ''),
('C', 'winter_phones', 'F', 900, @futureShop, 0, 1, 0, ''),
('C', 'xmas_hat', 'H', 900, @futureShop, 0, 0, 0, '');
