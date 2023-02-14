use kavalok;

select id into @shopId from Shop where name = 'exchange';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable)
values
 ('M', 'coins3', '', 0, @shopId, 0, 0, 0), ('M', 'coins2', '', 0, @shopId, 0, 0, 0), ('M', 'coins1', '', 0, @shopId, 0, 0, 0);

