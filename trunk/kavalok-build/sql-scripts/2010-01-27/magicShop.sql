-- Pattern: /(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/g
-- Replace: ('C', '$1', '$2', $3, @$4, $5, $6, $7, ''),

use kavalok;

select id into @futureShop from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'magic_air_ball_blue', '&I', 0, @futureShop, 0, 1, 0, 'command=MagicStuffItemRain;fName=magicBubbleBlue;count=5'),
('C', 'magic_air_ball_red', '&I', 0, @futureShop, 0, 1, 0, 'command=MagicStuffItemRain;fName=magicBubble;count=5'),
('C', 'magic_air_ball_yellow', '&I', 0, @futureShop, 0, 1, 0, 'command=MagicStuffItemRain;fName=magicBubbleYellow;count=5'),
('C', 'magic_star', '&I', 0, @futureShop, 0, 1, 0, 'command=MagicStuffItemRain;fName=magicStar;count=5');