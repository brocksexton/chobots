select id into @shopId from Shop where name = 'air';
insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'air_board1', 'X', 6000, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=6;height=10')
,('C', 'air_board2', 'X', 7500, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=6;height=10')
,('C', 'air_board3', 'X', 6300, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=7;height=10')
,('C', 'air_board4', 'X', 5500, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=5;height=10')
,('C', 'air_board5', 'X', 5400, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=5;height=10')
,('C', 'air_board6', 'X', 7800, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=7;height=10')
,('C', 'air_board7', 'X', 8000, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=9;height=10')
,('C', 'air_board8', 'X', 7500, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=7;height=10')
,('C', 'air_board9', 'X', 8000, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=8;height=10')
,('C', 'air_board10', 'X', 7500, @shopId, 1, 1, 0, 'command=StuffCharModifier;modifier=BoardModifier;speed=7;height=10');
