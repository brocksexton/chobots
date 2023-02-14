-- create table temp2 (money bigint, user_id int);

-- insert into temp2 (money, user_id) select sum(money) as money, user_id from temp group by user_id;

-- select sum(money), user_id from MoneyStatistics m
-- 	where reason='sss'
-- 	group by user_id

-- create table temp3 (money bigint, user_id int, gameChar_id int, login varchar(30));

-- insert into temp3
-- select t.money, t.user_id, u.gameChar_id, u.login
-- 	from temp2 t left join User u on t.user_id = u.id;

-- select (select SUM(money) from temp3), (select sum(money) from GameChar);
-- update GameChar, temp3
-- 	set GameChar.money = GameChar.money - temp3.money
-- 	where GameChar.id = temp3.gameChar_id;
-- update GameChar set money = 0 where money < 0;
-- select * from temp3 into dumpfile 'd:/temp3.sql';

select * from temp3 where login='animeangel';

