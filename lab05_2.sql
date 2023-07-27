CREATE DATABASE LAB05_2;
USE LAB05_2;
############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################
CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR(50),
product_quantity INT,
product_price FLOAT
);
INSERT INTO products 
(product_id,product_name, product_quantity,product_price)
VALUES (1, 'Мороженое', 100, 1), (2,'Шоколадка', 200,1.5),
(3,'Чипсы', 300,2);

SELECT * FROM shops;
CREATE TABLE shops(
shop_id INT PRIMARY KEY, 
shop_adress VARCHAR(50)
);
INSERT INTO shops VALUES
(1, 'Притыцкого 156'), (2, 'Денисовкая 8'),  (3, 'Победителей 9');


CREATE TABLE staff(
staff_id INT PRIMARY KEY AUTO_INCREMENT,
staff_name VARCHAR(50),
ref_shop_id INT, 
CONSTRAINT cn1 FOREIGN KEY(ref_shop_id) REFERENCES shops(shop_id)
);

INSERT INTO staff(staff_name, ref_shop_id) VALUES
('Дмитрий', 1), ('Алексей', 1), ('Анна',2),('Елена',2), 
('Арина', 3), ('Тимур',3);

CREATE TABLE sells(
sell_id INT PRIMARY KEY AUTO_INCREMENT,
sell_time DATETIME DEFAULT CURRENT_TIMESTAMP,
sell_amount FLOAT DEFAULT '0',
ref_staff_id INT NOT NULL,
CONSTRAINT cn2 FOREIGN KEY (ref_staff_id) REFERENCES staff(staff_id) 
); 

INSERT INTO sells (ref_staff_id) VALUES
(1),(1),(2),(2),(3),(3);

CREATE TABLE products_sells(
ref_sell_id INT,
ref_prod_id INT,
quantity INT,
CONSTRAINT cn3 FOREIGN KEY (ref_sell_id) REFERENCES sells(sell_id),
CONSTRAINT cn4 FOREIGN KEY (ref_prod_id) REFERENCES products(product_id)
);

INSERT INTO products_sells VALUES (1,1,1),(2,2,1),(3,3,1),
(1,1,2),(2,2,2),(3,3,2);

SELECT * FROM products;
SELECT * FROM shops;
SELECT * FROM staff;
SELECT * FROM sells;
SELECT * FROM products_sells;

#2.1

DELIMITER \\
CREATE PROCEDURE sellProduct(IN prod VARCHAR(50), quan INT, sell INT)
BEGIN
	IF (quan OR sell) < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect quan or sell';
           END IF;
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


SELECT * FROM products;
SELECT * FROM sells;
SELECT * FROM products_sells;

CALL sellProduct('Чипсы', 3, 1);

#2.2

DELIMITER \\
CREATE TRIGGER quantityCheck AFTER INSERT ON products_sells
FOR EACH ROW
BEGIN
	UPDATE products
		SET products.product_quantity = products.product_quantity + 30
	WHERE products.product_quantity = 0;
END\\            
DELIMITER ;

#2.3

CREATE TABLE clients(
client_id INT PRIMARY KEY AUTO_INCREMENT,
client_surname VARCHAR(50),  
client_name VARCHAR(50), 
client_adress VARCHAR(50)
);
INSERT INTO clients(client_surname, client_name, client_adress)
VALUES
('Донвар','Полина', 'ул. Янки Мавра 10а'),
('Тарашкевич','Евгения',  'ул. Дунина-Марцинкевича 1/2'),
('Горбач','Виктор', 'ул. Притыцкого 42'),
('Пивень','Елизавета', 'ул. Петра Глебки 5');

CREATE TABLE clients_purchases(
pur_id INT PRIMARY KEY AUTO_INCREMENT,
ref_client_id INT,
ref_shop_id INT, 
ref_product_id INT,
pur_quantity INT,
pur_price FLOAT,
CONSTRAINT cn5 FOREIGN KEY(ref_client_id) REFERENCES clients(client_id), 
CONSTRAINT cn6 FOREIGN KEY(ref_shop_id) REFERENCES shop(shop_id),
CONSTRAINT cn7 FOREIGN KEY(ref_product_id) REFERENCES products(product_id)
);

INSERT INTO clients_purchases
(ref_client_id, ref_shop_id, ref_product_id, pur_quantity, pur_price)
VALUES
(1, 1, 1, 5, 36.12),
(2, 1, 2, 2, 74.82),
(3, 1, 3, 3, 14.19),
(2, 2, 2, 5, 16.15);

drop table bonus_card;

CREATE TABLE bonus_card(
bc_client_id INT PRIMARY KEY,
bc_card VARCHAR(50),
bc_bonus_now FLOAT DEFAULT 0,
bc_month_now TINYINT UNSIGNED,
bc_bonus_next FLOAT DEFAULT 0,
bc_month_next TINYINT UNSIGNED,
CONSTRAINT cn9 FOREIGN KEY(bc_client_id) REFERENCES clients(client_id)
);

INSERT INTO bonus_card (bc_client_id, bc_card)
VALUES (1, '145 643 675'),
(2, '243 465 354'),
(3, '345 234 134');

ALTER TABLE clients MODIFY client_surname VARBINARY(50);
ALTER TABLE clients MODIFY client_name VARBINARY(50);
ALTER TABLE clients MODIFY client_adress VARBINARY(50);

UPDATE clients SET client_surname = AES_ENCRYPT(client_surname,'lab05_1');
UPDATE clients SET client_name = AES_ENCRYPT(client_name,'lab05_2');
UPDATE clients SET client_adress = AES_ENCRYPT(client_adress,'lab05_3');

SELECT CAST(AES_DECRYPT(client_surname,'lab05_1')AS CHAR),
CAST(AES_DECRYPT(client_name,'lab05_2')AS CHAR),
CAST(AES_DECRYPT(client_adress,'lab05_3')AS CHAR)
FROM clients;

select * from clients_purchases;
alter table clients_purchases add column pur_date DATE;
UPDATE clients_purchases SEt pur_date = '2020-09-10';
#бонус как в грин сити 

drop trigger bonuses;

select * from bonus_card;

DELIMITER \\
CREATE TRIGGER bonuses AFTER INSERT ON clients_purchases
FOR EACH ROW
BEGIN
  IF NEW.pur_date >= (SELECT bonus_card.bc_month_next FROM bonus_card WHERE NEW.ref_client_id = bonus_card.bc_client_id) 
		THEN 
		UPDATE bonus_card
		INNER JOIN clients_purchases
		ON clients_purchases.ref_client_id = bonus_card.bc_client_id
		SET bonus_card.bc_bonus_now = bonus_card.bc_bonus_next,
			bonus_card.bc_bonus_next = 0
            WHERE bonus_card.bc_client_id = NEW.ref_client_id;
	END IF;	
	UPDATE bonus_card
    INNER JOIN clients_purchases
    ON clients_purchases.ref_client_id = bonus_card.bc_client_id
		SET bonus_card.bc_bonus_next = bonus_card.bc_bonus_next + 0.03*NEW.pur_price,
			bonus_card.bc_month_next = DATE_FORMAT(DATE_ADD(NEW.pur_date,INTERVAL 1 MONTH), '%Y-%m-01')
    WHERE bonus_card.bc_client_id = NEW.ref_client_id;
END\\
DELIMITER ;
select * from clients_purchases;

drop table bonus_card;
CREATE TABLE bonus_card(
bc_client_id INT PRIMARY KEY,
bc_card VARCHAR(50),
bc_bonus_now FLOAT DEFAULT 0,
bc_month_now DATE,
bc_bonus_next FLOAT DEFAULT 0,
bc_month_next DATE,
CONSTRAINT cn9 FOREIGN KEY(bc_client_id) REFERENCES clients(client_id)
);

DELIMITER \\
CREATE TRIGGER bonuses AFTER INSERT ON clients_purchases
FOR EACH ROW
BEGIN
	UPDATE bonus_card
    INNER JOIN clients_purchases
    ON clients_purchases.ref_client_id = bonus_card.bc_client_id
		SET bc_bonus = bc_bonus + 0.03*NEW.pur_price 
    WHERE bonus_card.bc_client_id = NEW.ref_client_id;
END\\
DELIMITER ;

select * from clients_purchases;

SELECT * FROM bonus_card;


INSERT INTO clients_purchases
(ref_client_id, ref_shop_id, ref_product_id, pur_quantity, pur_price,pur_date)
VALUES
(1, 1, 2, 2, 36.12,'2020-12-12'),
(2, 1, 1, 2, 74.82,'2020-12-12');