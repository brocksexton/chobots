select id into @shopId from Shop where name = 'emptyShop';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
('C', 'shirt_bgirl', 'M', 0, @shopId, 0, 1, 1, null)
,('C', 'shirt_ggirl', 'M', 0, @shopId, 0, 1, 1, null)
,('C', 'shirt_iou', 'M', 0, @shopId, 0, 1, 1, null)
,('C', 'shirt_love', 'M', 0, @shopId, 0, 1, 1, null)
,('C', 'shirt_peace', 'M', 0, @shopId, 0, 1, 1, null)
,('C', 'shirt_unity', 'M', 0, @shopId, 0, 1, 1, null)
;
	
