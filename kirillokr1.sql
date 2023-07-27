CREATE DATABASE KR1Kirillo;
USE KR1Kirillo;
# Вариант 5 Instagram

# 1 задание
CREATE TABLE users(
	user_id INT PRIMARY KEY auto_increment,
    user_name VARCHAR(50) NOT NULL,
    user_registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE posts(
	post_id INT PRIMARY KEY auto_increment, #подразумевается кол-во всего постов в инсте от всех пользователей
	post_text VARCHAR(50),
    post_like INT,
    ref_user_id int,
    CONSTRAINT cn1 FOREIGN KEY (ref_user_id) REFERENCES users(user_id) 
);
CREATE table advertising(
	adv_id INT PRIMARY KEY auto_increment, #айди реклам. компании
    adv_name varchar(50),
    adv_goods varchar(50)
);
INSERT INTO users(user_name) values ('BigKush'),('dzmitry_ka'),('leomessi');
select * from users;
INSERT INTO posts(post_text,post_like,ref_user_id) values 
('привет', 60, 1),('пока', 30, 1),('шалом', 1000, 1),
('рпрпрапа', 40, 2),('папрпр', 50, 2),('шапап', 1020, 2),
('гомель', 100000, 1),('минск', 0, 1),('шчучыншчына', 40000, 1);
INSERT INTO posts(post_text,post_like,ref_user_id) values 
('гомель', 100000, 3),('крумкачы', 0, 3),('спутник', 2000, 3);
select * from posts;
INSERT INTO advertising(adv_name,adv_goods) values('vodkaBY','vodka'),
('Alivaria','beer'),('lays','crisps');
create table adv_users(
	ref_user_id int,
	ref_adv_id INT,
	CONSTRAINT cn2 FOREIGN KEY (ref_user_id) REFERENCES users(user_id),
	CONSTRAINT cn3 FOREIGN KEY (ref_adv_id) REFERENCES advertising(adv_id) 
);
insert into adv_users() values (1,1),(1,3),(3,2),(2,1),(3,3);
select* from adv_users;
select*from advertising;
# 2 задание
#обновление таблиц
ALTER TABLE users ADD COLUMN user_ban BOOL;
ALTER TABLE users ADD COLUMN user_strike MEDIUMINT;
UPDATE advertising SET adv_goods = 'pivasik' WHERE adv_id = 2;
ALTER TABLE advertising ADD COLUMN adv_money DOUBLE after adv_goods;
ALTER TABLE advertising MODIFY adv_name VARCHAR(100);
#представление 

delimiter \\
create procedure top_post()
begin
	declare i int default 1;
    while i<4 do
		SELECT ref_user_id, post_like from posts group by post_like 
		having ref_user_id = i order by post_like desc limit 0,5;
        UPDATE posts SET post_like = 1000 WHERE ref_user_id = i;
		set i = i+1;
	end while;
end\\
delimiter ;


call top_post();

drop procedure top_post;

#3 задание
delimiter \\
CREAtE trigger text_check before insert on posts
FOR EACH ROW
BEGIN
	IF NEW.post_text = 'козел' OR 'урод' OR 'дурак' THEN
		SELECT user_strike FROM users;
		UPDATE users SET new.user_strike = users.user_strike + 1 
        WHERE posts.ref_user_id = users.user_id;
	END IF; 
    IF new.user_strike = 3 then 
		SELECT user_ban FROM users;
		UPDATE users SET user_ban = 1 WHERE posts.ref_user_id = users.user_id;
	END IF;
END \\
delimiter ;