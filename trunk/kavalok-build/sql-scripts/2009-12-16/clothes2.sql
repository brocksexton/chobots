-- Pattern: /(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/g
-- Replace: ('C', '$1', '$2', $3, @$4, $5, $6, $7, ''),

use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';
select id into @itemOfTheMonth from Shop where name = 'itemOfTheMonth';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'bell_hat', 'H', 900, @futureShop, 0, 1, 0, ''),
('C', 'elf', 'MLH', 10, @futureShop, 0, 0, 0, ''),
('C', 'walrus_mask', 'F', 900, @futureShop, 0, 1, 0, ''),
('C', 'white_bear', 'MLBF', 900, @futureShop, 0, 1, 0, ''),
('C', 'flag_robots_team', '#', 0, @emptyShop, 0, 0, 0, ''),
('C', 'robo_jacket_team', 'M', 0, @emptyShop, 0, 0, 0, '');
