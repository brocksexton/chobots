drop procedure if exists updateStuff;
delimiter //
create procedure updateStuff (
	itemName varchar(255),
	shopName varchar(255),
	premium bit(1),
	hasColor bit(1),
	placement varchar(10),
	price int)
begin
	insert ignore into Shop (name) values (shopName);
	select id into @shopId from Shop where name = shopName;
	select id into @paidShopId from Shop where name = 'paidAaccessoriesShop';
	select id into @emptyShopId from Shop where name = 'emptyShop';

	update StuffType set
		shop_id = if(shop_id=@emptyShopId or shop_id=@paidShopId, shop_id, @shopId),
		placement = placement,
		hasColor = hasColor,
		price = price
	where fileName = itemName;

	select count(*) into @countExists from StuffType where fileName = itemName and shop_id <> @paidShopId;
	-- select @countExists;
	if @countExists = 0 then
    	insert into StuffType
			(shop_id, type, fileName, placement, hasColor, premium, giftable, price)
		values
			(@shopId, 'C', itemName, placement, hasColor, premium, not premium, price);
	end if;
end //

delimiter ;

-- call updateStuff('glasses_black',	'okuljary',	1,	1,	'F',	1200);
-- select * from StuffType where fileName='glasses_black';

call updateStuff('carrot', 'emptyShop', 1, 0, 'Z', 0);
call updateStuff('fire_wings', 'emptyShop', 1, 0, 'Z', 0);
call updateStuff('khaki', 'emptyShop', 1, 0, 'Z', 0);
call updateStuff('pirat', 'emptyShop', 1, 0, 'Z', 0);


call updateStuff('board',	'air',	1,	0,	'X',	1000);
call updateStuff('fly_air_complect',	'air',	1,	0,	'FLB',	8500);
call updateStuff('fly_air_glass',	'air',	1,	0,	'F',	4500);
call updateStuff('fly_air_poyas',	'air',	1,	0,	'L',	3500);
call updateStuff('fly_air_shoes',	'air',	0,	0,	'X',	5500);
call updateStuff('fly_fire_complect',	'air',	1,	0,	'FHB',	7500);
call updateStuff('fly_fire_kaska',	'air',	1,	0,	'H',	2000);
call updateStuff('fly_fire_ruka',	'air',	1,	0,	'M',	1500);
call updateStuff('fly_fire_shoes',	'air',	1,	0,	'X',	4500);
call updateStuff('fly_magnet_shoes',	'air',	1,	0,	'X',	4550);
call updateStuff('cheburashka',	'aksesuary',	0,	1,	'H',	500);
call updateStuff('glasses',	'okuljary',	0,	1,	'F',	1000);
call updateStuff('glasses_1',	'okuljary',	1,	1,	'F',	1000);
call updateStuff('glasses_big',	'okuljary',	1,	1,	'F',	1100);
call updateStuff('glasses_black',	'okuljary',	1,	1,	'F',	1200);
call updateStuff('glasses_heart',	'okuljary',	1,	1,	'F',	1000);
call updateStuff('glasses_nose',	'okuljary',	1,	1,	'F',	950);
call updateStuff('glasses_round',	'okuljary',	1,	0,	'F',	1000);
call updateStuff('glasses_stars',	'okuljary',	1,	1,	'F',	1100);
call updateStuff('glasses_techno',	'okuljary',	1,	1,	'F',	1250);
call updateStuff('hat',	'aksesuary',	0,	1,	'H',	900);
call updateStuff('head_bear',	'aksesuary',	0,	1,	'H',	800);
call updateStuff('headPhones',	'aksesuary',	0,	1,	'F',	1100);
call updateStuff('korona',	'aksesuary',	0,	1,	'H',	900);
call updateStuff('korona_brulik',	'aksesuary',	0,	0,	'H',	1000);
call updateStuff('kovpak',	'aksesuary',	0,	1,	'H',	700);
call updateStuff('kravatka',	'aksesuary',	0,	1,	'N',	900);
call updateStuff('lampochka',	'aksesuary',	1,	0,	'H',	1600);
call updateStuff('nimb',	'aksesuary',	1,	0,	'H',	1000);
call updateStuff('patrik_glass',	'aksesuary',	0,	0,	'F',	444);
call updateStuff('patrik_hat',	'aksesuary',	0,	0,	'H',	659);
call updateStuff('pypka',	'aksesuary',	0,	1,	'N',	600);
call updateStuff('vantus',	'aksesuary',	0,	1,	'H',	777);
call updateStuff('vinok',	'aksesuary',	0,	1,	'H',	500);
call updateStuff('wings',	'aksesuary',	1,	0,	'N',	2000);
call updateStuff('akademik',	'kostjumy',	1,	0,	'HM',	1000);
call updateStuff('akademik_blue',	'kostjumy',	1,	0,	'HM',	1000);
call updateStuff('akademik_red',	'kostjumy',	1,	0,	'HM',	1000);
call updateStuff('blue_hair_girl',	'kostjumy',	1,	1,	'HMLB',	1100);
call updateStuff('cheerleader_girl',	'kostjumy',	1,	1,	'HMLB',	1100);
call updateStuff('cinderella',	'kostjumy',	1,	1,	'BLMHFN',	1300);
call updateStuff('Cowboy',	'kostjumy',	1,	0,	'HMLN',	1500);
call updateStuff('Cowboy_blue',	'kostjumy',	1,	0,	'HMLN',	1500);
call updateStuff('Cowboy_red',	'kostjumy',	1,	0,	'HMLN',	1500);
call updateStuff('diver',	'kostjumy',	1,	1,	'BLMHFN',	1000);
call updateStuff('Faraonsha',	'kostjumy',	1,	0,	'HML',	850);
call updateStuff('Faraonsha_blue',	'kostjumy',	1,	0,	'HML',	850);
call updateStuff('freman',	'kostjumy',	1,	0,	'HMLB',	1250);
call updateStuff('freman_blue',	'kostjumy',	1,	0,	'HMLB',	1250);
call updateStuff('freman_red',	'kostjumy',	1,	0,	'HMLB',	1250);
call updateStuff('japanizegirl',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('japanizegirl_blue',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('japanizegirl_red',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('Jiday',	'kostjumy',	1,	0,	'HMLB',	1000);
call updateStuff('Jiday_blue',	'kostjumy',	1,	0,	'HMLB',	1000);
call updateStuff('Jiday_red',	'kostjumy',	1,	0,	'HMLB',	1000);
call updateStuff('kleo',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('kleo_blue',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('kleo_red',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('kostium_1',	'kostjumy',	0,	1,	'ML',	1300);
call updateStuff('kostium_2',	'kostjumy',	0,	1,	'ML',	1000);
call updateStuff('kostium_3',	'kostjumy',	0,	1,	'ML',	1500);
call updateStuff('kostium_4',	'kostjumy',	0,	1,	'ML',	1250);
call updateStuff('kostium_5',	'kostjumy',	0,	1,	'HML',	800);
call updateStuff('kostium_6',	'kostjumy',	0,	1,	'HML',	900);
call updateStuff('kostium_7',	'kostjumy',	0,	1,	'ML',	850);
call updateStuff('kostium_banti',	'kostjumy',	0,	1,	'ML',	1000);
call updateStuff('kostium_priajka',	'kostjumy',	0,	1,	'ML',	850);
call updateStuff('Ninja',	'kostjumy',	1,	0,	'HMLBN',	1750);
call updateStuff('Ninja_blue',	'kostjumy',	1,	0,	'HMLBN',	1750);
call updateStuff('Ninja_red',	'kostjumy',	1,	0,	'HMLBN',	1750);
call updateStuff('patrik_girl_complect',	'kostjumy',	0,	0,	'BMH',	800);
call updateStuff('patrik_suit1',	'kostjumy',	0,	0,	'BMH',	920);
call updateStuff('patrik_suit2',	'kostjumy',	0,	0,	'BMF',	777);
call updateStuff('policeman',	'kostjumy',	1,	0,	'HMLB',	1400);
call updateStuff('policeman_blue',	'kostjumy',	1,	0,	'HMLB',	1400);
call updateStuff('policeman_red',	'kostjumy',	1,	0,	'HMLB',	1400);
call updateStuff('red_hair_girl',	'kostjumy',	1,	1,	'HMLB',	1300);
call updateStuff('red_hat_girl',	'kostjumy',	1,	1,	'HMLB',	1000);
call updateStuff('roman',	'kostjumy',	1,	0,	'HMLB',	1000);
call updateStuff('Samoray',	'kostjumy',	1,	0,	'HMLB',	1200);
call updateStuff('Samoray_blue',	'kostjumy',	1,	0,	'HMLB',	1200);
call updateStuff('Samoray_red',	'kostjumy',	1,	0,	'HMLB',	1200);
call updateStuff('santehnik',	'kostjumy',	0,	1,	'ML',	700);
call updateStuff('Shahtar',	'kostjumy',	1,	0,	'HMB',	1000);
call updateStuff('Sleepy',	'kostjumy',	1,	1,	'BLMHFN',	950);
call updateStuff('sport_girl',	'kostjumy',	1,	1,	'HMLB',	1100);
call updateStuff('Studik',	'kostjumy',	1,	0,	'FMLB',	900);
call updateStuff('Studik_blue',	'kostjumy',	1,	0,	'FMLB',	900);
call updateStuff('Studik_red',	'kostjumy',	1,	0,	'FMLB',	900);
call updateStuff('ukr',	'kostjumy',	1,	0,	'HMLB',	1100);
call updateStuff('ukr_girl',	'kostjumy',	1,	0,	'HMLB',	1100);
call updateStuff('violet_hair_girl',	'kostjumy',	1,	1,	'HMLB',	950);
call updateStuff('waysarbi',	'kostjumy',	1,	1,	'HMB',	1600);
call updateStuff('wiking',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('wiking_blue',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('wiking_red',	'kostjumy',	1,	0,	'HMLB',	850);
call updateStuff('mask_begemot',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_begemot_blue',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_begemot_pink',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_cat',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_cat_blue',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_cat_yelow',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_elephant',	'maska ',	0,	0,	'FH',	800);
call updateStuff('mask_elephant_pink',	'maska ',	0,	0,	'FH',	800);
call updateStuff('mask_elephant_violet',	'maska ',	0,	0,	'FH',	800);
call updateStuff('mask_lion',	'maska ',	1,	0,	'FH',	850);
call updateStuff('mask_lion_gray',	'maska ',	1,	0,	'FH',	850);
call updateStuff('mask_panda',	'maska ',	0,	0,	'FH',	900);
call updateStuff('mask_pingvin',	'maska ',	1,	0,	'FH',	1000);
call updateStuff('mask_pingvin_blue',	'maska ',	1,	0,	'FH',	1000);
call updateStuff('mask_popugay',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_popugay_blue',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_popugay_yelow',	'maska ',	1,	0,	'FH',	700);
call updateStuff('mask_zaiaz',	'maska ',	1,	0,	'FH',	1100);
call updateStuff('mask_zaiaz_blue',	'maska ',	1,	0,	'FH',	1100);
call updateStuff('mask_zaiaz_pink',	'maska ',	1,	0,	'FH',	1100);
call updateStuff('mask_zebra',	'maska ',	1,	0,	'FH',	800);
call updateStuff('okuliari_Chopix',	'emptyShop',	0,	0,	'F',	0);
call updateStuff('shapka_SClaus',	'emptyShop',	0,	0,	'H',	0);
call updateStuff('sharphik_SClaus',	'emptyShop',	0,	0,	'N',	0);
call updateStuff('shkar_SClaus',	'emptyShop',	0,	0,	'B',	0);
call updateStuff('dreads',	'peruky',	0,	1,	'H',	700);
call updateStuff('hair',	'peruky',	0,	1,	'H',	1000);
call updateStuff('hair_5',	'peruky',	1,	1,	'H',	1200);
call updateStuff('hair_care',	'peruky',	1,	1,	'H',	900);
call updateStuff('hair_cheerleader',	'peruky',	1,	1,	'H',	800);
call updateStuff('hair_emo',	'peruky',	1,	1,	'H',	1200);
call updateStuff('hair_jedy',	'peruky',	1,	1,	'H',	700);
call updateStuff('hair_kosy',	'peruky',	1,	1,	'H',	800);
call updateStuff('patrik_peruka',	'peruky',	0,	0,	'H',	560);
call updateStuff('peruka',	'peruky',	0,	1,	'H',	600);
call updateStuff('peruka_1',	'peruky',	0,	1,	'H',	700);
call updateStuff('peruka_2',	'peruky',	0,	1,	'H',	780);
call updateStuff('peruka_3',	'peruky',	0,	1,	'H',	860);
call updateStuff('peruka_4',	'peruky',	0,	1,	'H',	890);
call updateStuff('peruka_80s',	'peruky',	1,	1,	'H',	1000);
call updateStuff('peruka_emo1',	'peruky',	1,	1,	'H',	1400);
call updateStuff('peruka_emo2',	'peruky',	1,	1,	'H',	1300);
call updateStuff('peruka_emo3',	'peruky',	1,	1,	'H',	1100);
call updateStuff('peruka_emo4',	'peruky',	1,	1,	'H',	1000);
call updateStuff('peruka_green_hat',	'peruky',	1,	1,	'H',	1000);
call updateStuff('peruka_jamaika',	'peruky',	1,	1,	'H',	1500);
call updateStuff('peruka_scarry',	'peruky',	1,	1,	'H',	1000);
call updateStuff('bant',	'secondHand',	0,	1,	'N',	600);
call updateStuff('bant_1',	'secondHand',	0,	1,	'N',	400);
call updateStuff('beads',	'secondHand',	0,	1,	'N',	400);
call updateStuff('jabo',	'secondHand',	0,	1,	'N',	400);
call updateStuff('klipsi',	'secondHand',	0,	1,	'F',	400);
call updateStuff('kofta',	'secondHand',	0,	1,	'M',	500);
call updateStuff('rubaha',	'secondHand',	0,	1,	'M',	400);
call updateStuff('shapka',	'secondHand',	0,	1,	'H',	300);
call updateStuff('topik',	'secondHand',	0,	1,	'M',	400);
call updateStuff('viji',	'secondHand',	0,	1,	'F',	300);
call updateStuff('boots',	'shkaryIShtanci',	0,	1,	'B',	600);
call updateStuff('kapci',	'shkaryIShtanci',	0,	1,	'B',	500);
call updateStuff('kedy',	'shkaryIShtanci',	0,	1,	'B',	600);
call updateStuff('pachka',	'shkaryIShtanci',	0,	1,	'L',	600);
call updateStuff('pants',	'shkaryIShtanci',	0,	1,	'L',	500);
call updateStuff('patrik_girl_shoes',	'shkaryIShtanci',	0,	0,	'B',	300);
call updateStuff('patrik_shoes',	'shkaryIShtanci',	0,	0,	'B',	555);
call updateStuff('patrik_shoes2',	'shkaryIShtanci',	0,	0,	'B',	320);
call updateStuff('pidtjazhki',	'shkaryIShtanci',	0,	1,	'L',	350);
call updateStuff('sarafan',	'shkaryIShtanci',	0,	1,	'LM',	750);
call updateStuff('shoes_camomile',	'shkaryIShtanci',	0,	1,	'B',	700);
call updateStuff('shoes_leaf',	'shkaryIShtanci',	0,	1,	'B',	800);
call updateStuff('shoes_vuha',	'shkaryIShtanci',	0,	1,	'B',	1000);
call updateStuff('shtani',	'shkaryIShtanci',	0,	1,	'L',	500);
call updateStuff('shtani_romashki',	'shkaryIShtanci',	1,	1,	'L',	750);
call updateStuff('pants1',	'shkaryIShtanci',	0,	1,	'L',	600);
call updateStuff('pants2',	'shkaryIShtanci',	1,	1,	'L',	800);
call updateStuff('pants3',	'shkaryIShtanci',	1,	1,	'L',	600);
call updateStuff('pants4',	'shkaryIShtanci',	1,	1,	'L',	700);
call updateStuff('pants5',	'shkaryIShtanci',	0,	1,	'L',	900);
call updateStuff('pants_square',	'shkaryIShtanci',	1,	1,	'L',	750);
call updateStuff('shoes_1',	'shkaryIShtanci',	1,	1,	'L',	1000);
call updateStuff('shoes_2',	'shkaryIShtanci',	1,	1,	'L',	800);
call updateStuff('shoes_drMartens',	'shkaryIShtanci',	1,	1,	'L',	1000);
call updateStuff('dress',	'sorochkyIKurtky',	0,	1,	'ML',	700);
call updateStuff('frak',	'sorochkyIKurtky',	0,	1,	'M',	800);
call updateStuff('futbolka_heard',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('futbolka_smyle',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('gerb_jacket',	'sorochkyIKurtky',	1,	1,	'M',	1100);
call updateStuff('kombi',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('kurtka',	'sorochkyIKurtky',	0,	1,	'M',	700);
call updateStuff('patrik_dress',	'sorochkyIKurtky',	0,	0,	'M',	650);
call updateStuff('patrik_jacket',	'sorochkyIKurtky',	0,	0,	'M',	777);
call updateStuff('patrik_shirt_boy',	'sorochkyIKurtky',	0,	0,	'M',	650);
call updateStuff('PG_boy_1',	'sorochkyIKurtky',	0,	0,	'M',	300);
call updateStuff('PG_boy_2',	'sorochkyIKurtky',	0,	0,	'M',	350);
call updateStuff('PG_girl_1',	'sorochkyIKurtky',	0,	0,	'M',	300);
call updateStuff('PG_girl_2',	'sorochkyIKurtky',	0,	0,	'M',	350);
call updateStuff('pidzhak',	'sorochkyIKurtky',	0,	1,	'M',	600);
call updateStuff('plasch',	'sorochkyIKurtky',	0,	1,	'M',	650);
call updateStuff('shirt_arrow',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_cup',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_dialog',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_oklyk',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_pet',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_phone',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_question',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('shirt_tunes',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('shirt_work',	'sorochkyIKurtky',	0,	1,	'M',	500);
call updateStuff('futbolka_emo1',	'sorochkyIKurtky',	1,	1,	'M',	650);
call updateStuff('futbolka_mickey_mouse',	'sorochkyIKurtky',	1,	1,	'M',	1000);
call updateStuff('jacket_1',	'sorochkyIKurtky',	1,	1,	'M',	1200);
call updateStuff('jacket_emo1',	'sorochkyIKurtky',	1,	1,	'M',	1400);
call updateStuff('kostum_sharfik',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('moon_jacket',	'sorochkyIKurtky',	1,	1,	'M',	1200);
call updateStuff('rubaha_hawai',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('svetr_zelenuy',	'sorochkyIKurtky',	1,	1,	'M',	1200);
call updateStuff('boots2',	'shkaryIShtanci',	1,	1,	'B',	800);
call updateStuff('dress_2',	'sorochkyIKurtky',	1,	1,	'M',	900);
call updateStuff('green_hat',	'peruky',	1,	1,	'H',	850);
call updateStuff('peruka_5',	'peruky',	1,	1,	'H',	750);
call updateStuff('peruka_emo5',	'peruky',	1,	1,	'H',	1200);

drop procedure if exists updateStuff;