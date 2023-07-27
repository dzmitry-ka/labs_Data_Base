/*1.создать таблицу орифлэйм в отдельной и связь один ко многим в одной таблице 
2. переделать связи в стачкоме в форме снежинки, где главная будет состав протестующих
3. переделать 3д на ФИО с primary
4. переделать 3с на default datetime с датой и добавлением имени
*/
CREATE DATABASE bar;
USE bar;
CREATE TABLE products(
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(50) NOT NULL,
product_type ENUM("vodka","beer"),
product_quantity INT,
product_price FLOAT
); 
CREATE TABLE contracts(
contract_id INT ,
PRIMARY KEY (contract_id),
contract_start_date DATE NOT NULL,
contract_end_date DATE,
contract_salary FLOAT
); 
CREATE TABLE staff(
staff_id INT PRIMARY KEY NOT NULL,
staff_surname VARCHAR(30) NOT NULL,
staff_name VARCHAR(30) NOT NULL,
staff_position VARCHAR(5) NOT NULL,
staff_id_nickname VARCHAR(30) AS (CONCAT(staff_surname ,'_',staff_name , CONVERT(staff_id, CHAR), '_', staff_position)), 
FOREIGN KEY (staff_id) REFERENCES contracts(contract_id)
);
select*from staff;
CREATE TABLE test10(
test_date DATETIME DEFAULT CURRENT_TIMESTAMP,
test_surname VARCHAR(30) NOT NULL,
test_id_number VARCHAR(30) AS (CONCAT((SUBSTRING(test_surname,1,3)),(SUBSTRING((CAST(test_date AS CHAR)),1,4)),
(SUBSTRING((CAST(test_date AS CHAR)),6,2)),(SUBSTRING((CAST(test_date AS CHAR)),9,2)),
(SUBSTRING((CAST(test_date AS CHAR)),12,2)),(SUBSTRING((CAST(test_date AS CHAR)),15,2)),
(SUBSTRING((CAST(test_date AS CHAR)),18,2))))
);
select*from staff;
INSERT INTO test10 (test_surname) VALUE ('SASHA');
INSERT INTO test10 (test_surname) VALUE ('Nikita');

SELECT * FROM test10;
SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'test10' AND COLUMN_NAME = 'test_id_number';

CREATE TABLE sells(
sell_id INT PRIMARY KEY AUTO_INCREMENT,
sell_time DATETIME,
sell_amount FLOAT DEFAULT '0',
ref_staff_id INT,
CONSTRAINT cn2 FOREIGN KEY (ref_staff_id) REFERENCES staff(staff_id) 
); 
CREATE TABLE products_sells(
ref_sell_id INT(11),
ref_prod_id INT(11),
quantity INT(11),
CONSTRAINT cn3 FOREIGN KEY (ref_sell_id) REFERENCES staff(staff_id),
CONSTRAINT cn4 FOREIGN KEY (ref_prod_id) REFERENCES products(product_id)
);
INSERT INTO contracts (contract_id , contract_start_date ,contract_end_date ,contract_salary)
 VALUES (1,'2020-9-1','2020-9-1',100), (2,'2020-10-1','2025-10-1',500);  
INSERT INTO staff (staff_id , staff_name ,staff_surname ,staff_position)
 VALUES (1,'Dima','Kirillo','barm'), (2,'Matvey','Draevich','wait');  
INSERT INTO sells (sell_id , sell_time ,ref_staff_id)
 VALUE (1,'2020-9-1',1);  
 INSERT INTO sells (sell_id , sell_time ,ref_staff_id)
 VALUE (2,'2020-9-5',2); 
SELECT* FROM staff;
SHOW TABLES;
INSERT INTO products (product_name ,product_type ,product_quantity, product_price)
 VALUES ('Я прэзидэнт или хто','vodka', 20, 1.20), ('Алiварыя', 'beer', 8, 0.90);
INSERT INTO products_sells(ref_sell_id ,ref_prod_id, quantity)
 VALUES (1, 1, 8), (2, 2, 6);
 INSERT INTO contracts (contract_id , contract_start_date ,contract_end_date ,contract_salary)
 VALUES (3,'2020-9-1','2020-9-1',100), (4,'2020-10-1','2025-10-1',500); 
 INSERT INTO staff (staff_id , staff_name ,staff_surname ,staff_position)
 VALUES (3,'Alrx','Karlovich','bad'), (4,'Alexander','Kushnerov','hf');  

CREATE TABLE test(
test_id INT PRIMARY KEY NOT NULL DEFAULT (FLOOR((RAND() * (100000000 - 1)) + 1)),
test_name VARCHAR(30) NOT NULL,
test_id_number VARCHAR(12) AS (CONCAT('',CAST(test_id AS CHAR)))
);
DROP TABLE test;
INSERT INTO test (test_name) VALUE ('SASHA');
INSERT INTO test (test_name) VALUE ('Denis');

SELECT * FROM test;
SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'test' AND COLUMN_NAME = 'test_id_number';

CREATE TABLE cosmetic_names(
cosmetic_name VARCHAR(40) PRIMARY KEY NOT NULL,
cosmetic_price FLOAT NOT NULL,
cosmetic_develop VARCHAR(30)
);

CREATE TABLE oriflame_goods(
oriflame_id INT PRIMARY KEY NOT NULL,
oriflame_set INT,
CONSTRAINT cn123 FOREIGN KEY (oriflame_set) REFERENCES oriflame_goods(oriflame_id)
);
CREATE TABLE oriflame_names(
	oriflame_id INT PRIMARY KEY NOT NULL,
    oriflame_id_name INT,
    oriflame_name VARCHAR(40),
    oriflame_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT h1 FOREIGN KEY (oriflame_id_name) REFERENCES oriflame_names(oriflame_id)
);
INSERT INTO oriflame_names(oriflame_id,oriflame_name) VALUE (1,'Kirillo');
INSERT INTO oriflame_names(oriflame_id,oriflame_id_name,oriflame_name) VALUE (2,1,'Korbovksy');
SELECT *from oriflame_names;
CREATE TABLE cosmetic_oriflame(
ref_cosmetic_name VARCHAR(40) NOT NULL,
ref_cosmetic_id INT NOT NULL,
CONSTRAINT cn322 FOREIGN KEY (ref_cosmetic_name) REFERENCES cosmetic_names(cosmetic_name),
CONSTRAINT cn321 FOREIGN KEY (ref_cosmetic_id) REFERENCES oriflame_goods(oriflame_id)
);
INSERT INTO cosmetic_names(cosmetic_name,cosmetic_price) VALUES ('Алискино чудо' , 111),
								('Пальчики осла' , 231),('Грязи из болота', 231.23);
 INSERT INTO oriflame_goods(oriflame_id) VALUES (1),(2),(3);                             

SELECT * FROM oriflame_goods;
UPDATE oriflame_goods SET oriflame_set = oriflame_id WHERE oriflame_id != 0;
INSERT INTO oriflame_goods(oriflame_set) VALUE (1);
UPDATE oriflame_goods SET oriflame_set = 1 WHERE oriflame_id = 2;
UPDATE oriflame_goods SET oriflame_set = 1 WHERE oriflame_id = 3;
UPDATE oriflame_goods SET oriflame_set = 2 WHERE oriflame_id = 1;
INSERT INTO oriflame_goods (oriflame_id, oriflame_set) VALUE (12,3);
INSERT INTO cosmetic_oriflame() VALUES ('Алискино чудо', 1),('Грязи из болота',3),('Пальчики осла',2) ;


