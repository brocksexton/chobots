insert ignore into Quest (name, enabled) values
  ('questHoover', 0);

select id into @shopId from Shop where name = 'emptyShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'Cleaner_pylesos', 'M', 0, @shopId, 0, 0, 0, null)
, ('C', 'Cleaner_kaska', 'H', 0, @shopId, 0, 0, 0, null)
, ('C', 'Cleaner_shoes', 'BX', 0, @shopId, 0, 0, 0, null)
;