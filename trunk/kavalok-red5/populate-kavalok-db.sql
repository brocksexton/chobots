insert into Admin (login, password)
values ('admin', 'chobot123')
, ('zebra', 'rHeGf')
, ('mod1', 'gehUF')
, ('mod2', 'ghEntYm')
, ('mod3', 'Nfgjr')
, ('mod4', 'nEujLev')
;

insert into BlockWord (word)
values ('fuck')
, ('shit')
, ('heil');

insert into Server (url, name)
values
('67.207.142.198/kavalok', 'Serv1')
, ('67.207.142.198/kavalok1', 'Serv2')
, ('192.168.0.26/kavalok', 'Serv3')
, ('192.168.0.26/kavalok1', 'Serv4')
, ('192.168.0.131/kavalok', 'Serv5')
, ('192.168.0.131/kavalok1', 'Serv6');

insert into MailServer (url, login, pass, port, available)
values 
("smtp-auth.no-ip.com", "chobots.com@noip-smtp", "MackMeB4b3", "3325", true)
, ("interspire.smtp.com", "y.l@chobots.com", "kavalok83", "25", true)
, ("kavalok.com", "chobots", "MackMeB4b3", "25", true);

insert into Shop (name)
values 
('accessoriesShop')
, ('magicShop')
, ('cafe')
;

insert into PaperMessage (title, content)
values
('Space race', 'race'),
('Garbage collector', 'garbageCollector')
;
insert into StuffType (name, type, placement, description, fileName, price, shop_id)
values 
  ('cloth0', 'C', 'T', 'Some triangle shit0', 'bant',		8, 1)
, ('cloth1', 'C', 'H', 'Some triangle shit0', 'dreads',		35, 1)
, ('cloth2', 'C', 'B', 'Some triangle shit0', 'frak',		48, 1)
, ('cloth3', 'C', 'H', 'Some triangle shit0', 'hair',		40, 1)
, ('cloth4', 'C', 'H', 'Some triangle shit0', 'headPhones', 30, 1)
, ('cloth5', 'C', 'L', 'Some triangle shit0', 'kapci',		25, 1)
, ('cloth6', 'C', 'L', 'Some triangle shit0', 'kedy',		20, 1)
, ('cloth7', 'C', 'B', 'Some triangle shit0', 'kombi',		38, 1)
, ('cloth8', 'C', 'H', 'Some triangle shit0', 'korona',		50, 1)
, ('cloth9', 'C', 'T', 'Some triangle shit0', 'kravatka',	12, 1)
, ('cloth11', 'C', 'B', 'Some triangle shit0', 'pants',		20, 1)
, ('cloth12', 'C', 'H', 'Some triangle shit0', 'peruka',	30, 1)
, ('cloth13', 'C', 'B', 'Some triangle shit0', 'pidtjazhki',45, 1)
, ('cloth14', 'C', 'B', 'Some triangle shit0', 'pidzhak',	48, 1)
, ('cloth15', 'C', 'B', 'Some triangle shit0', 'plasch',	25, 1)
, ('cloth16', 'C', 'T', 'Some triangle shit0', 'pypka',		15, 1)
, ('cloth17', 'C', 'B', 'Some triangle shit0', 'santehnik', 52, 1)
, ('cloth18', 'C', 'B', 'Some triangle shit0', 'sarafan',	36, 1)
, ('cloth19', 'C', 'H', 'Some triangle shit0', 'shapka',	28, 1)
, ('cloth21', 'C', 'H', 'Some triangle shit0', 'vantus',	28, 1)
, ('cloth22', 'C', 'H', 'Some triangle shit0', 'viji',		10, 1)
, ('magicSpeed',   'S', '', 'Some triangle shit0', 'magicSpeed',	10, 2)
, ('magicBottle',   'S', '', 'Some triangle shit0', 'magicBottle',	18, 2)
, ('magicBlur',   'S', '', 'Some triangle shit0', 'magicBlur',		90, 2)
, ('magicBubble',   'S', '', 'Some triangle shit0', 'magicBubble',	5, 2)
, ('magicBubbleBlue',   'S', '', 'Some triangle shit0', 'magicBubbleBlue',	5, 2)
, ('magicStar',   'S', '', 'Some triangle shit0', 'magicStar',		7, 2)
, ('magicBalls',   'S', '', 'Some triangle shit0', 'magicBalls',	6, 2)
, ('magicScale',   'S', '', 'Some triangle shit0', 'magicScale',	65, 2)
, ('cocktail0',   'E', '', 'Some triangle shit0', 'cocktail0',		10, 3)
, ('cocktail1',   'E', '', 'Some triangle shit0', 'cocktail1',		6, 3)
, ('cocktail2',   'E', '', 'Some triangle shit0', 'cocktail2',		8, 3)
, ('cocktail3',   'E', '', 'Some triangle shit0', 'cocktail3',		29, 3)
;

insert into Shop (name)
values 
('paidAaccessoriesShop');

insert into StuffType (name, type, placement, description, fileName, price, shop_id)
values 
  ('cloth37', 'C', '*', 'Some triangle shit0', 'akademik',		0, 4)
, ('cloth23',   'C', '*', 'Some triangle shit0', 'Cowboy',		0, 4)
, ('cloth24',   'C', '*', 'Some triangle shit0', 'Faraonsha',		0, 4)
, ('cloth25',   'C', '*', 'Some triangle shit0', 'freman',		0, 4)
, ('cloth26',   'C', '*', 'Some triangle shit0', 'japanizegirl',		0, 4)
, ('cloth27',   'C', '*', 'Some triangle shit0', 'Jiday',		0, 4)
, ('cloth28',   'C', '*', 'Some triangle shit0', 'kleo',		0, 4)
, ('cloth29',   'C', '*', 'Some triangle shit0', 'Ninja',		0, 4)
, ('cloth30',   'C', '*', 'Some triangle shit0', 'policeman',		0, 4)
, ('cloth31',   'C', '*', 'Some triangle shit0', 'Samoray',		0, 4)
, ('cloth32',   'C', '*', 'Some triangle shit0', 'Shahtar',		0, 4)
, ('cloth33',   'C', '*', 'Some triangle shit0', 'Studik',		0, 4)
, ('cloth34',   'C', '*', 'Some triangle shit0', 'ukr',		0, 4)
, ('cloth35',   'C', '*', 'Some triangle shit0', 'ukr_girl',		0, 4)
, ('cloth36',   'C', '*', 'Some triangle shit0', 'wiking',		0, 4)
;
