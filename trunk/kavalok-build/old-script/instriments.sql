insert ignore into Shop (name) values ('musicShop');
select id into @shopId from Shop where name = 'musicShop';

insert into StuffType (type, fileName, placement, price, shop_id, hasColor, premium, giftable, info)
values
 ('C', 'instrument_drum', 'I', 99, @shopId, 1, 0, 0, 'command=MusicInstrument;name=drum')
,('C', 'instrument_guitar_classic', 'I', 99, @shopId, 1, 0, 0, 'command=MusicInstrument;name=pista')
,('C', 'instrument_guitar_rock', 'I', 99, @shopId, 1, 0, 0, 'command=MusicInstrument;name=solo')
,('C', 'instrument_sax', 'I', 99, @shopId, 1, 0, 0, 'command=MusicInstrument;name=sax')
,('C', 'instrument_vinyl', 'I', 99, @shopId, 1, 0, 0, 'command=MusicInstrument;name=hiphop');
