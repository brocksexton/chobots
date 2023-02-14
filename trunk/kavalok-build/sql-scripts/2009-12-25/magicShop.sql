-- Pattern: /(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/g
-- Replace: ('C', '$1', '$2', $3, @$4, $5, $6, $7, ''),

use kavalok;
insert ignore into Shop (name) values ('magicPayedShop');

select id into @futureShop from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'magic_buben', 'FHI', 0, @futureShop, 0, 1, 0, 'command=MagicItem;name=rain_new'),
('C', 'magic_lightning', 'HI', 0, @futureShop, 0, 1, 0, 'command=MagicItem;name=lightning'),
('C', 'magic_snow', 'HI', 0, @futureShop, 0, 1, 0, 'command=MagicItem;name=snowfall'),
('C', 'magic_rainbow', '&I', 0, @futureShop, 0, 1, 0, 'command=MagicItem;name=rainbow');