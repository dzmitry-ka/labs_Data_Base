CREATE DATABASE LAB06;
USE LAB06;
CREATE TABLE contracts(
contract_id INT PRIMARY KEY NOT NULL,
contract_position VARCHAR(50) NOT NULL,
contract_start_date DATE NOT NULL,
contract_end_date DATE,
contract_salary DOUBLE
); 
select * from contracts;
CREATE TABLE players(
player_id INT PRIMARY KEY NOT NULL,
player_surname VARCHAR(30) NOT NULL,
player_name VARCHAR(30) NOT NULL,
player_number SMALLINT NOT NULL,
FOREIGN KEY (player_id) REFERENCES contracts(contract_id)
);
CREATE TABLE coachs(
coach_id INT PRIMARY KEY NOT NULL,
coach_surname VARCHAR(30) NOT NULL,
coach_name VARCHAR(30) NOT NULL,
FOREIGN KEY (coach_id) REFERENCES contracts(contract_id)
);
CREATE TABLE leadership(
lead_id INT PRIMARY KEY NOT NULL,
lead_surname VARCHAR(30) NOT NULL,
lead_name VARCHAR(30) NOT NULL,
FOREIGN KEY (lead_id) REFERENCES contracts(contract_id)
);
CREATE TABLE administration(
admin_id INT PRIMARY KEY NOT NULL,
admin_surname VARCHAR(30) NOT NULL,
admin_name VARCHAR(30) NOT NULL,
FOREIGN KEY (admin_id) REFERENCES contracts(contract_id)
);
CREATE TABLE news(
news_id INT PRIMARY KEY AUTO_INCREMENT,
ref_admin_id INT NOT NULL,
news_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
news_text TEXT NOT NULL,
CONSTRAINT cn1 FOREIGN KEY (ref_admin_id) REFERENCES administration(admin_id)
);          
CREATE TABLE clubs(
club_id INT PRIMARY KEY NOT NULL,
club_name VARCHAR(30) NOT NULL,
club_country CHAR(3) NOT NULL DEFAULT ''
);
CREATE TABLE championship(
champ_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
champ_name VARCHAR(50) NOT NULL,
champ_country CHAR(3) NOT NULL DEFAULT ''
);
CREATE TABLE calendar(
cal_id INT PRIMARY KEY NOT NULL,
ref_champ_id SMALLINT NOT NULL,
ref_club_id1 INT NOT NULL,
cal_score1 TINYINT UNSIGNED,
cal_score2 TINYINT UNSIGNED,
ref_club_id2 INT NOT NULL,
cal_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT cn111 FOREIGN KEY (ref_champ_id) REFERENCES championship(champ_id),
CONSTRAINT cn2 FOREIGN KEY (ref_club_id1) REFERENCES clubs(club_id),
CONSTRAINT cn3 FOREIGN KEY (ref_club_id2) REFERENCES clubs(club_id)
);
DROP TABLE calendar;
INSERT INTO calendar(cal_id,ref_champ_id,ref_club_id1,ref_club_id2) 
VALUE (1,1,1,1);
SELECT * FROM calendar;

CREATE TABLE fans(
fan_id INT PRIMARY KEY AUTO_INCREMENT,
fan_surname VARCHAR(30) NOT NULL,
fan_name VARCHAR(30) NOT NULL
);
CREATE TABLE products(
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(50) NOT NULL,
product_type ENUM("t-shirt","scarf","flag"),
product_quantity INT,
product_price FLOAT
); 
CREATE TABLE sells(
sell_id INT PRIMARY KEY AUTO_INCREMENT,
sell_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
sell_amount FLOAT DEFAULT '0',
ref_admin_id INT NOT NULL,
CONSTRAINT cn6 FOREIGN KEY (ref_admin_id) REFERENCES administration(admin_id) 
); 
CREATE TABLE products_sells(
ref_sell_id INT,
ref_prod_id INT,
quantity INT,
CONSTRAINT cn7 FOREIGN KEY (ref_sell_id) REFERENCES sells(sell_id),
CONSTRAINT cn8 FOREIGN KEY (ref_prod_id) REFERENCES products(product_id)
);
CREATE TABLE sponsors(
spon_id INT PRIMARY KEY AUTO_INCREMENT,
spon_name VARCHAR(30) NOT NULL,
spon_type VARCHAR(30) 
);
CREATE TABLE finances(
finance_id ENUM("1") PRIMARY KEY NOT NULL,
finance_bill DOUBLE NOT NULL DEFAULT 0,
finance_lastupdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sponsors_finance(
ref_spon_id INT NOT NULL,
ref_finance_id ENUM("1") DEFAULT 1,
money DOUBLE NOT NULL,
CONSTRAINT cn9 FOREIGN KEY (ref_spon_id) REFERENCES sponsors(spon_id),
CONSTRAINT cn10 FOREIGN KEY (ref_finance_id) REFERENCES finances(finance_id)
);
DELIMITER //
CREATE TRIGGER upd_finances BEFORE UPDATE ON finances
       FOR EACH ROW
       BEGIN
           IF NEW.finance_bill < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct amount';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_finances BEFORE INSERT ON finances
       FOR EACH ROW
       BEGIN
           IF NEW.finance_bill < 0 OR NEW.finance_bill IS NULL THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct amount';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_fin_spon BEFORE INSERT ON sponsors_finance
       FOR EACH ROW
       BEGIN
           IF NEW.money < 0 OR NEW.money IS NULL THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct amount';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_pl_number BEFORE INSERT ON players
       FOR EACH ROW
       BEGIN
           IF NEW.player_number < 1 OR NEW.player_number > 99
           OR NEW.player_number IS NULL THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect number player';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER upd_pl_number BEFORE UPDATE ON players
       FOR EACH ROW
       BEGIN
           IF NEW.player_number < 1 OR NEW.player_number > 99
           OR NEW.player_number IS NULL THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect number player';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER upd_cont_salary BEFORE UPDATE ON contracts
       FOR EACH ROW
       BEGIN
           IF NEW.contract_salary < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect contract salary';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_cont_salary BEFORE INSERT ON contracts
       FOR EACH ROW
       BEGIN
           IF NEW.contract_salary < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect contract salary';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_prod BEFORE INSERT ON products
       FOR EACH ROW
       BEGIN
           IF NEW.product_quantity < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect product quantity';
			ELSEIF product_price < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect product price';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER upd_prod BEFORE UPDATE ON products
       FOR EACH ROW
       BEGIN
           IF NEW.product_quantity < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect product quantity';
			ELSEIF product_price < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect product price';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER upd_sell BEFORE UPDATE ON sells
       FOR EACH ROW
       BEGIN
           IF NEW.sell_amount  < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect sell amount';
           END IF;
       END//
DELIMITER ; 
DELIMITER //
CREATE TRIGGER ins_sell BEFORE INSERT ON sells
       FOR EACH ROW
       BEGIN
           IF NEW.sell_amount  < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect sell amount';
           END IF;
       END//
DELIMITER ; 
DELIMITER //
CREATE TRIGGER ins_cal BEFORE INSERT ON calendar
       FOR EACH ROW
       BEGIN
           IF (NEW.ref_club_id1 = NEW.ref_club_id2)
           OR NEW.ref_club_id1 IS NULL OR NEW.ref_club_id2 IS NULL
           THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct match calendar';
           END IF;
       END//
DELIMITER ;
SHOW triggers;
DROP trigger ins_cal;
DROP TABLE calendar;
SELECT * FROM calendar;
INSERT INTO finances(finance_bill) VALUE (-2);
INSERT INTO contracts VALUES (1,'player',now(),NULL,1000),(2,'player',now(),NULL,1000),
(3,'head coach',now(),NULL,2000),(4,'head',now(),NULL,7000),(5,'pr-manager',now(),NULL,500),
(6,'player',now(),NULL,1000),(7,'coach',now(),NULL,2000),(8,'volunteer',now(),NULL,200);
UPDATE contracts SET contract_end_date = '2021-12-31' WHERE contract_id = 2;
UPDATE contracts SET contract_end_date = '2021-04-12' WHERE contract_id = 8;  
INSERT INTO players VALUES (1,'Kozeka','Sergei',33),(2,'Lisakovich','Ruslan',2),
(6,'Zgurski','Petr',81);
INSERT INTO coachs VALUES (3,'Kuzminich','Sergei'),(7,'Khasenevich','Pavel');
INSERT INTO leadership VALUES (4,'Davidovich','Oleg');
INSERT INTO administration VALUES (5,'Rudakov','Vladislav'),(8,'Yuzhik','Sergei');
INSERT INTO news(ref_admin_id,news_text) VALUES(5,'Krumki proigrali Gomelyu'),
(8,'Snova pervaya liga :(');
INSERT INTO fans(fan_surname,fan_name) VALUES ('Kushnerov','Alexander'),
('Karlovich','Alex'), ('Bosyakov','Serega'),('Kursov','Valera');
INSERT INTO clubs VALUES (1,'Gomel','BLR'),(2,'Krumkachy','BLR'),
(3,'BATE','BLR'),(4,'Shachter','BLR');
INSERT INTO championship VALUES (1,'BHL','BLR'),(2,'Belarus Cup','BLR');
INSERT INTO finances VALUE (1,100000000,now());
INSERT INTO sponsors(spon_name,spon_type) VALUES ('Prestigio','Phones'),
('MVD','police'),('VTB','bank'),('Guziriev',NULL);
INSERT INTO sponsors(spon_name,spon_type) VALUES ('Canyon','Smartphones');
INSERT INTO products (product_name ,product_type ,product_quantity, product_price)
 VALUES ('Home jersey 2020', "t-shirt", 40, 90.90), ('Scarf black', "scarf", 60, 15.90),
('Flag white',"flag", 35, 5.90);
 INSERT INTO sells (ref_admin_id) VALUES (5),(8),(8),(5); 
INSERT INTO calendar(cal_id,ref_champ_id,ref_club_id1, cal_score1,cal_score2, ref_club_id2) 
VALUES (1,1,1,2,0,2),(2,1,2,1,5,3),(3,2,4,4,1,2),(4,1,2,1,3,2);

SELECT * FROM calendar;
SELECT * FROM contracts;
SELECT * FROM players;
SELECT * FROM coachs;
SELECT * FROM leadership;
SELECT * FROM administration;
SELECT * FROM clubs;
SELECT * FROM championship;
SELECT * FROM finances;
SELECT * FROM products;
SELECT * FROM sells;
SELECT * FROM fans;
#SELECT * FROM sponsors_finance;
SHOW TABLES;

############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################

DELIMITER \\
CREATE PROCEDURE products_increase(IN pr INT, prod VARCHAR(50))
BEGIN 
	UPDATE products SET
	product_price = product_price + product_price*(pr/100) WHERE product_type = prod;
END \\
DELIMITER ;

CALL products_increase(3, 'flag');

SELECT * FROM products;

DELIMITER \\
CREATE PROCEDURE dropPlayer(IN Surn VARCHAR(50), Nam VARCHAR(50))
BEGIN 
	DELETE FROM players
	WHERE player_surname = Surn AND player_name = Nam;
END \\
DELIMITER ;

CALL dropPlayer('Zgurski','Petr');
SELECT * FROM players;

INSERT INTO players(player_id,player_surname,player_name,player_number) VALUES (6,'Zgurski','Petr',81);


SELECT * FROM clubs;

SELECT * FROM table_result;
SELECT * FROM calendar;
SELECT * FROM championship;
SELECT * FROM clubs;


CREATE OR REPLACE VIEW calendar2020 (Matchday,Tournament,HomeTeam,HomeScore, AwayScore, AwayTeam)
AS (SELECT calendar.cal_date,championship.champ_name, temp1.club_name ,cal_score1,cal_score2,
temp2.club_name FROM calendar
INNER JOIN clubs temp1 ON temp1.club_id = calendar.ref_club_id1
INNER JOIN clubs temp2 ON temp2.club_id = calendar.ref_club_id2
INNER JOIN championship ON championship.champ_id = calendar.ref_champ_id
WHERE (EXTRACT(YEAR FROM calendar.cal_date)) = '2020');

DROP view calendar2020;
SELECT * FROM calendar2020;



CREATE OR REPLACE VIEW team2020 (Position, Surname, Name, Number)
AS SELECT contracts.contract_position, coachs.coach_surname, coachs.coach_name,
'NULL' AS Number
FROM contracts INNER JOIN coachs ON coachs.coach_id = contracts.contract_id
UNION 
SELECT contracts.contract_position, players.player_surname, players.player_name,
players.player_number FROM contracts 
INNER JOIN players ON players.player_id = contracts.contract_id
UNION
SELECT contracts.contract_position, leadership.lead_surname, leadership.lead_name,
'NULL' AS Number FROM contracts 
INNER JOIN leadership ON leadership.lead_id = contracts.contract_id;

SELECT * FROM team2020;
select * from finances;

select * from sponsors_finance;
DELIMITER \\
CREATE TRIGGER giveMoney AFTER INSERT ON sponsors_finance
FOR EACH ROW
BEGIN
	UPDATE finances 
    INNER JOIN sponsors_finance
    ON sponsors_finance.ref_finance_id = finances.finance_id
    SET 
		finances.finance_bill = finances.finance_bill + NEW.money,
		finances.finance_lastupdate = NOW()
	WHERE finances.finance_id = 1;
END\\            
DELIMITER ;

DROP TRIGGER giveMoney;

DELIMITER \\
CREATE FUNCTION howMany(spon VARCHAR(50))
RETURNS DOUBLE
BEGIN
	DECLARE amount DOUBLE;
	SELECT SUM(sponsors_finance.money) INTO amount FROM sponsors_finance
	INNER JOIN sponsors ON
	sponsors.spon_id = sponsors_finance.ref_spon_id AND
	sponsors.spon_name = spon;
    RETURN amount;
END\\
DELIMITER ;

SELECT howMany('Guziriev');

DELIMITER \\
CREATE FUNCTION howTeam(posit VARCHAR(50))
RETURNS SMALLINT
BEGIN
	DECLARE qua SMALLINT;
	SELECT COUNT(team2020.Surname) INTO qua FROM team2020
	WHERE team2020.Position = posit;
    RETURN qua;
END\\
DELIMITER ;

SELECT howTeam('player');

INSERT INTO sponsors_finance(ref_spon_id,money) VALUES (4,200),(3,150);

SELECT * FROM sponsors_finance;
SELECT * FROM finances;
SELECT * FROM sponsors;

SELECT * FROM products;
SELECT * FROM sells;
SELECT * FROM products_sells;

DELIMITER \\
CREATE PROCEDURE sellProduct(IN prod VARCHAR(50), quan INT, sell INT)
BEGIN
	START TRANSACTION;
	UPDATE products
		SET products.product_quantity = products.product_quantity - quan
	WHERE products.product_name = prod;
	IF ROW_COUNT()>0
		THEN
			UPDATE sells
				INNER JOIN products ON products.product_name = prod
				SET sells.sell_amount = sells.sell_amount + quan*products.product_price
				WHERE sells.sell_id = sell AND products.product_quantity >=0;
		IF ROW_COUNT()>0 
			THEN INSERT INTO products_sells SELECT sell,products.product_id,quan
				FROM products WHERE products.product_name = prod;
			COMMIT;
		ELSE ROLLBACK;
		END IF;
	ELSE ROLLBACK;
	END IF;
END\\            
DELIMITER ;

CALL sellProduct('Flag white', 3, 1);

DROP PROCEDURE sellProduct;

SELECT * FROM products;
SELECT * FROM sells;
SELECT * FROM products_sells;


SELECT * FROM news;

CREATE INDEX indPlayer ON players(player_surname,player_name);

EXPLAIN SELECT * FROM lab06.players WHERE player_surname ='Zgu%'; 

CREATE FULLTEXT INDEX indNews ON news(news_text);

SELECT news_text FROM news WHERE MATCH(news_text) AGAINST('liga');

CREATE USER director IDENTIFIED BY '1'; 
GRANT ALL ON lab06.* TO director; 

CREATE USER fan IDENTIFIED BY '2';
GRANT SELECT ON lab06.* TO fan;

CREATE USER headCoach IDENTIFIED BY '3'; 
GRANT SELECT, INSERT, UPDATE, DELETE ON lab06.players TO headCoach;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab06.coachs TO headCoach;



