use kavalok;

select id into @emptyShop from Shop where name = 'emptyShop';
select id into @futureShop from Shop where name = 'futureShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'flag_StGeorges', '#', 10, @emptyShop, 0, 0, 1, ''),
('C', 'flag_deutsche', '#', 10, @emptyShop, 0, 0, 1, ''),
('C', 'candy', '&', 800, @futureShop, 0, 0, 1, ''),
('C', 'cavegirl', 'MBH', 800, @futureShop, 0, 1, 1, ''),
('C', 'caveman', 'MBH', 800, @futureShop, 0, 1, 1, ''),
('C', 'dress_6', 'M', 800, @futureShop, 1, 1, 1, ''),
('C', 'fairy', 'MBHL&', 800, @futureShop, 0, 1, 1, ''),
('C', 'ice_cream', '&', 800, @futureShop, 0, 1, 1, ''),
('C', 'peruka_12', 'H', 800, @futureShop, 1, 1, 1, ''),
('C', 'peruka_13', 'H', 800, @futureShop, 1, 1, 1, ''),
('C', 'suit_for_fly', 'MBFL', 800, @futureShop, 1, 1, 1, ''),
('C', 'terrapin', 'M', 800, @futureShop, 1, 1, 1, ''),
('C', 'futbolka_s', 'M', 10, @emptyShop, 0, 0, 1, '');
