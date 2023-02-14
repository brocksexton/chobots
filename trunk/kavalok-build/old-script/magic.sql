use kavalok;

select id into @shopId from Shop where name = 'citizenMagicShop';

insert into StuffType (type, fileName, price, shop_id, hasColor, premium, giftable)
values
 ('S', 'magicLantz', 1500, @shopId, 0, 1, 1);

