CREATE DATABASE LAB02;
USE LAB02;
create table students(
    card_ID mediumint primary key not null,
    first_name varchar(10),
    last_name varchar(20),
    age tinyint,
    sex enum('male', 'female'),
    birthdate date,
    education_form enum('budget','paid'),
    scholarship float,
    tuition_year float,
    average_grade decimal(2,1)
);
SHOW TABLES;
insert into students values
(1922113, 'Katya', 'Belskaya',18, 'female','2002-01-25', 'budget', 171.64, null, 9.6),
(1922117, 'Nastya', 'Savchenko',18, 'female','2002-08-29','budget', 171.64, null, 8.7),
(7657771, 'Lev', 'Taborov',19, 'male','2001-10-02','budget', 155.64, null, 8.3),
(2377678, 'Arina', 'Logvinenko',18, 'female','2001-10-09','budget', 155.64, null, 7.8),
(1922174, 'Aleksei', 'Karlovich',18, 'male','2020-08-26','budget', 155.64, null, 7.8),
(1927720, 'Elena', 'Zrazikova',18, 'female','2001-02-07','budget', 155.64, null, 7.6),
(1922287, 'Egor', 'Buksa',18, 'male','2001-04-13','paid', null, 2000, 6.4),
(1922285, 'Dzmitry', 'Kiryla', 18, 'male', '2001-11-01', 'paid',null, null,8.2);
select * from students;
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE students change scholarship scholarship double;
ALTER TABLE students change average_grade average_grade decimal(3,1) after scholarship;
ALTER TABLE students change scholarship scholarship float;
ALTER TABLE students change tuition_year tuitionYear float;

################################################################################### 
#в один запрос апдэйт
UPDATE students SET
	scholarship = scholarship*1.1,
	tuitionYear = tuitionYear*1.2
WHERE card_ID > 0;


UPDATE students
SET scholarship = CASE 
			WHEN length(last_name)-length(replace(replace(replace(replace(replace(
		lower(last_name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) > 
			length(replace(replace(replace(replace(replace(
		lower(last_name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) THEN scholarship*1.2
            WHEN card_ID > 0 THEN scholarship*1.1 AND tuitionYear = tuitionYear*1.2
			END;

select * from students;

UPDATE students SET scholarship = 100  WHERE card_ID > 0;
UPDATE students SET tuitionYear = tuitionYear*1.15  WHERE card_ID > 0; 

UPDATE students SET scholarship = scholarship*1.1  WHERE card_ID > 0;
UPDATE students SET scholarship = scholarship*1.2 where 
	length(last_name)-length(replace(replace(replace(replace(replace(
		lower(last_name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) > 
			length(replace(replace(replace(replace(replace(
		lower(last_name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', ''));  
        
insert into students value
(1922100, 'Katya', 'BIBOO',18, 'female','2002-01-25', 'budget', 100, null, 9.6);


 
UPDATE students SET scholarship = scholarship*1.2 WHERE 
LENGTH(REPLACE(CAST(card_ID AS CHAR),'7', ''))>LENGTH(
REPLACE(REPLACE(REPLACE(CAST(card_ID AS CHAR),'3', ''),'6',''),'9',''));

################################################################################### 
#комбинации для айди студ карты 
#12345678

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER \\
#DROP PROCEDURE IF EXISTS multiplicity;
CREATE FUNCTION multiplicity(id INT)
RETURNS BOOL
BEGIN
	DECLARE i, j, valueID1, valueID2 INT;
    DECLARE count3, count7 INT DEFAULT 0;
    DECLARE stringID VARCHAR(15);
    SET valueID1 = id;
    SET i = (SELECT length(CAST(id AS CHAR(15))));
    WHILE i != 0 DO
		SET valueID2 = valueID1;
		SET j = (SELECT length(CAST(valueID2 AS CHAR(15))));
		WHILE j != 0 DO
            IF (valueID2 % 3) = 0 THEN SET count3 = count3 + 1;
            END IF;
            IF (valueID2 % 7) = 0 THEN SET count7 = count7 + 1;
			END IF;
            SET valueID2 = valueID2/10;
			SET j = j-1;
		END WHILE;
        SET valueID1 = (SELECT RIGHT(id,i));
        SET i = i-1;
	END WHILE;
    IF count3 > count7 THEN RETURN 1;
    ELSE RETURN 0;
    END IF;
END \\
DELIMITER ;

SELECT multiplicity(77);
SELECT multiplicity(card_ID) FROM students;
DROP FUNCTION multiplicity;
UPDATE students SET scholarship = scholarship*1.2 WHERE 
1 = (SELECT multiplicity(card_ID) FROM students);
SELECT * FROM students;
UPDATE students SET scholarship = scholarship*1.2 WHERE 
1 = (SELECT multiplicity(card_ID) FROM students);
SELECT * FROM students;
UPDATE students SET scholarship = scholarship*1.2 WHERE 
1 = (SELECT multiplicity(card_ID));
SELECT * FROM students;


create table tests(
value1 int,
value2 int,
value3 VARCHAR(30) AS (CONCAT(value1,'*',value2))
);
INSERT INTO tests(value1) value (1234);
DROP TABLE tests;

DELIMITER \\
#DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test111()
BEGIN
	DECLARE Val1, Val2, ValId, someText INT;
   #DECLARE someText VARCHAR(20);
    SELECT value1 INTO ValId FROM tests;
	SET Val1 = 1;
	WHILE Val1 <= 2 DO
			SET Val2 = 1;
			WHILE Val2 <= 2 DO
				SET someText = (SELECT Length(CAST(ValId AS CHAR(20))));
				INSERT INTO tests(value2) VALUES (someText);
				SET Val2 = Val2 + 1;
			END WHILE;
		SET Val1 = Val1 + 1;
	END WHILE;
END \\
DELIMITER ;


DELIMITER \\
#DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test()
BEGIN
	DECLARE Val1, Val2 INT; 
	SET Val1 = 1;
	WHILE Val1 <= 2 DO
			SET Val2 = 1;
			WHILE Val2 <= 10 DO
					INSERT INTO tests(value1,value2) VALUES (Val1,Val2);
                    SET Val2 = Val2 + 1;
			END WHILE;
		SET Val1 = Val1 + 1;
	END WHILE;
END \\
DELIMITER ;
 
 CALL test();
 DROP procedure test;
 SELECT * FROM tests;
 

CREATE TABLE male(
	card_ID mediumint primary key not null,
    first_name varchar(10),
    last_name varchar(20),
    age tinyint,
    birthdate date,
    education_form enum('budget','paid'),
    scholarship float,
    tuitionYear float,
    average_grade decimal(2,1)
);
select *from female;
CREATE TABLE female(
	card_ID mediumint primary key not null,
    first_name varchar(10),
    last_name varchar(20),
    age tinyint,
    birthdate date,
    education_form enum('budget','paid'),
    scholarship float,
    tuitionYear float,
    average_grade decimal(2,1)
);
INSERT INTO male SELECT card_ID,first_name,last_name,
		age,birthdate,education_form,scholarship,tuitionYear,average_grade 
	FROM students WHERE sex='male';
INSERT INTO female SELECT card_ID,first_name,last_name,
		age,birthdate,education_form,scholarship,tuitionYear,average_grade 
	FROM students WHERE sex='female';
    
show tables;

USE newStrikeMTW;
select* from staff_MTW;
UPDATE staff_MTW
SET staff_protest_date_start = CASE
WHEN DAYNAME(staff_protest_date_start) = 'Monday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 3 DAY)
WHEN DAYNAME(staff_protest_date_start) = 'Tuesday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 2 DAY)
WHEN DAYNAME(staff_protest_date_start) = 'Wednesday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 1 DAY)
WHEN DAYNAME(staff_protest_date_start) = 'Friday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 6 DAY)
WHEN DAYNAME(staff_protest_date_start) = 'Saturday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 5 DAY)
WHEN DAYNAME(staff_protest_date_start) = 'Sunday' 
THEN DATE_ADD(staff_protest_date_start, INTERVAL 4 DAY)
ELSE staff_protest_date_start
END 
WHERE staff_id = 1;
select* from leadership_protest;
UPDATE detention SET detention_designed='Малевич' WHERE detention_id = 8;
UPDATE detention SET detention_fine=detention_fine-8 WHERE detention_id = 7;
select * from detention;
UPDATE goverment_protests SET goverment_protests_reaction ='А любимую не отдают!' 
WHERE ref_goverment_id=1 
AND ref_protest_date='2020-08-11';
UPDATE leadership_protest SET leadership_date_end='2020-08-14';

################################################################################### 
# апдэйт с джоином
UPDATE staff_MTW
INNER JOIN leadership_protest ON leadership_protest.leadership_id = staff_MTW.staff_id
SET leadership_protest.leadership_date_start = CURRENT_DATE(),
	staff_MTW.staff_protest = 1
WHERE staff_MTW.staff_id>0;

select* from leadership_protest;
select* from staff_MTW;

UPDATE goverment
LEFT JOIN goverment_protests ON goverment_protests.ref_goverment_id= goverment.goverment_id
SET goverment_protests.goverment_protests_reaction = 'Прынесице нам чаю з малинавым варэннем'
WHERE goverment_protests.ref_protest_date='2020-08-12';

UPDATE press
RIGHT JOIN protest_press ON protest_press.ref_press_name = press.press_name
SET protest_press.press_correspondent = 'Азарёнок';

select* from leadership_protest;
select* from staff_MTW;
select* from goverment_protests;
select* from protest_press;
#2

USE LAB02;
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE unnormalized21(
	author_1 VARCHAR(50),
    author_2 VARCHAR(50),
    title VARCHAR(30),
    ISBN int,
    price DOUBLE,
    customer_name VARCHAR(50),
    customer_address VARCHAR(200),
    purchase_date DATE
);
drop table unnormalized21;
select * from unnormalized21;
INSERT INTO unnormalized21 VALUES('David Sklar','Adam Trachetenberg','PHP Cookbook',
0596101015,44.99,'Emma Brown','1565 Rainbow Road, Los Angeles, CA 90014', '2009-03-03'),
('Danny Goodman',null,'Dynamic HTML',
0596527403,59.99,'Darren Ryder','4758 Emily Drive, Richmond, VA 23219', '2008-12-19'),
('Hugh E.Williams','David Lane','PHP and MYSQL',0596005436,44.95,
'Earl B.Thruston','862 Gregory Lane, Frankfort, KY 40601', '2009-06-22'),
('David Sklar','Adam Trachetenberg','PHP Cookbook',0596101015,44.99,
'Darren Ryder','4758 Emily Drive, Richmond, VA 23219', '2008-12-19'),
('Rasmus Lerdorf','Kevin Tatroe & Peter MacIntyre','Programming PHP',0596006815,
39.99,'David Miller','3647 Cedar Lane, Waltham, MA 02154', '2009-01-16');

CREATE TABLE authors(
	author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(50)
);
ALTER TABLE unnormalized21 ADD COLUMN author_3 VARCHAR(50) AFTER author_2;
UPDATE unnormalized21 SET author_3 = SUBSTRING_INDEX(author_2,'&',1) WHERE author_2 LIKE '%&%';
UPDATE unnormalized21 SET author_2 =(RIGHT(author_2, LENGTH(author_2) - LENGTH(author_3)-2))
where author_2 like '%&%';
UPDATE unnormalized21 SET author_3 = TRIM(author_3);
UPDATE unnormalized21 SET author_2 = TRIM(author_2);
USE lab02;
INSERT INTO authors(author_name) SELECT DISTINCT author_1 
FROM unnormalized21 WHERE author_1 IS NOT NULL;
INSERT INTO authors(author_name) SELECT DISTINCT author_2 
FROM unnormalized21 WHERE author_2 IS NOT NULL;
INSERT INTO authors(author_name) SELECT DISTINCT author_3 
FROM unnormalized21 WHERE author_3 IS NOT NULL;
select* from books;
select distinct author_1,author_2,author_3,ISBN from authors, books;
select * from authors;
select* from author_book;
select* from customers;
CREATE TABLE books(
	book_ISBN INT PRIMARY KEY,
    book_title VARCHAR(30),
    book_price DOUBLE
);
INSERT INTO books(book_ISBN,book_title,book_price) SELECT 
DISTINCT ISBN, title, price from unnormalized21;

CREATE TABLE author_book(
	ref_author_id INT,
    ref_book_ISBN INT,
    CONSTRAINT cn1 FOREIGN KEY (ref_author_id) REFERENCES authors(author_id),
    CONSTRAINT cn2 FOREIGN KEY (ref_book_ISBN) REFERENCES books(book_ISBN)
);
select distinct author_1,author_2,author_3,ISBN,author_name from authors, books,unnormalized21;

CREATE TABLE author_book_new(
	ref_author_id INT,
    ref_book_ISBN INT,
    CONSTRAINT cn111 FOREIGN KEY (ref_author_id) REFERENCES authors(author_id),
    CONSTRAINT cn222 FOREIGN KEY (ref_book_ISBN) REFERENCES books(book_ISBN)
);
UPDATE author_book, unnormalized21  
INNER JOIN authors ON authors.author_name = unnormalized21.author_1
INNER JOIN books ON unnormalized21.ISBN = books.book_ISBN 
SET author_book.ref_author_id = authors.author_id,
	author_book.ref_book_ISBN = unnormalized21.ISBN;


###################################################################################    
#инсерт с джоином 
INSERT INTO author_book_new SELECT DISTINCT authors.author_id, ISBN FROM unnormalized21 
INNER JOIN authors ON authors.author_name = unnormalized21.author_1;
INSERT INTO author_book_new SELECT DISTINCT authors.author_id, ISBN FROM unnormalized21 
INNER JOIN authors ON authors.author_name = unnormalized21.author_2;
INSERT INTO author_book_new SELECT DISTINCT authors.author_id, ISBN FROM unnormalized21 
INNER JOIN authors ON authors.author_name = unnormalized21.author_3;

select* from author_book_new;
select * from authors;
select * from unnormalized21;



INSERT INTO author_book() VALUES (1,596101015),(2,596527403),(3,596005436),
(4,596006815),(8,596101015),(9,596005436),(10,596006815),(11,596006815);
select* from author_book;
select* from unnormalized21;
select* from books;
select* from authors,author_book;
select* from author_book;
select* from customers;

CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    customer_address VARCHAR(200)
);
INSERT INTO customers(customer_name, customer_address)
SELECT DISTINCT customer_name, customer_address FROM unnormalized21;

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    order_check DOUBLE,
    ref_customer_id INT,
    ref_book_ISBN INT,
    CONSTRAINT cn3 FOREIGN KEY (ref_customer_id) REFERENCES customers(customer_id),
    CONSTRAINT cn4 FOREIGN KEY (ref_book_ISBN) REFERENCES books(book_ISBN)
);
select * from books;
select * from unnormalized21;
select * from authors;
select * from author_book;
select * from customers;
select * from orders;


CREATE TABLE unnormalized22(
	emp_id MEDIUMINT PRIMARY KEY,
    first_name VARCHAR(10),
	last_name VARCHAR(10),
    childrens_names VARCHAR(50),
    childrens_birthdates VARCHAR(50)
);
select * from unnormalized22;
INSERT INTO unnormalized22 VALUES (1001, 'Jane', 'Doe', 'Mary, Sam', '01/01/92, 05/15/94'),
(1002, 'John', 'Doe', 'Mary, Sam', '01/01/92, 05/15/94'),
(1003, 'Jane', 'Smith', 'John, Pat, Lee, Mary', '10/05/94, 10/12/90, 06/06/96, 08/21/94'),
(1004, 'John', 'Smith', 'Michael', '07/04/96'), 
(1005, 'Jane', 'Jones', 'Edward, Martha', '10/21/95, 10/15/89');

CREATE TABLE parents(
	emp_id MEDIUMINT PRIMARY KEY,
    first_name VARCHAR(10),
	last_name VARCHAR(10)
);
INSERT INTO parents() SELECT emp_id, first_name, last_name from unnormalized22;
select * from children;
select * from parents;
CREATE TABLE children(
	child_id INT PRIMARY KEY AUTO_INCREMENT,
    child_name VARCHAR(30),
    child_birthday DATE
);
ALTER TABLE unnormalized22 ADD COLUMN childrens_names1 VARCHAR(10) AFTER childrens_names;
ALTER TABLE unnormalized22 ADD COLUMN childrens_names2 VARCHAR(10) AFTER childrens_names1;
ALTER TABLE unnormalized22 ADD COLUMN childrens_names3 VARCHAR(10) AFTER childrens_names2;
ALTER TABLE unnormalized22 ADD COLUMN childrens_birthdates1 VARCHAR(10) AFTER childrens_birthdates;
ALTER TABLE unnormalized22 ADD COLUMN childrens_birthdates2 VARCHAR(10) AFTER childrens_birthdates1;
ALTER TABLE unnormalized22 ADD COLUMN childrens_birthdates3 VARCHAR(10) AFTER childrens_birthdates2;
UPDATE unnormalized22 SET childrens_names1 = SUBSTRING_INDEX(childrens_names,',',1) 
WHERE childrens_names LIKE '%,%';
UPDATE unnormalized22 SET childrens_names = TRIM(RIGHT(childrens_names, 
LENGTH(childrens_names)-LENGTH(SUBSTRING_INDEX(childrens_names,',',1))-2))
WHERE childrens_names LIKE '%,%';
UPDATE unnormalized22 SET childrens_names2 = SUBSTRING_INDEX(childrens_names,',',1) 
WHERE childrens_names LIKE '%,%';
UPDATE unnormalized22 SET childrens_names = TRIM(RIGHT(childrens_names, 
LENGTH(childrens_names)-LENGTH(SUBSTRING_INDEX(childrens_names,',',1))-2))
WHERE childrens_names LIKE '%,%';
UPDATE unnormalized22 SET childrens_names3 = SUBSTRING_INDEX(childrens_names,',',1) 
WHERE childrens_names LIKE '%,%';
UPDATE unnormalized22 SET childrens_names = TRIM(RIGHT(childrens_names, 
LENGTH(childrens_names)-LENGTH(SUBSTRING_INDEX(childrens_names,',',1))-2))
WHERE childrens_names LIKE '%,%';

UPDATE unnormalized22 SET childrens_birthdates1 = SUBSTRING_INDEX(childrens_birthdates,',',1) 
WHERE childrens_birthdates LIKE '%,%';
UPDATE unnormalized22 SET childrens_birthdates = TRIM(RIGHT(childrens_birthdates, 
LENGTH(childrens_birthdates)-LENGTH(SUBSTRING_INDEX(childrens_birthdates,',',1))-2))
WHERE childrens_birthdates LIKE '%,%';
UPDATE unnormalized22 SET childrens_birthdates2 = SUBSTRING_INDEX(childrens_birthdates,',',1) 
WHERE childrens_birthdates LIKE '%,%';
UPDATE unnormalized22 SET childrens_birthdates = TRIM(RIGHT(childrens_birthdates, 
LENGTH(childrens_birthdates)-LENGTH(SUBSTRING_INDEX(childrens_birthdates,',',1))-2))
WHERE childrens_birthdates LIKE '%,%';
UPDATE unnormalized22 SET childrens_birthdates3 = SUBSTRING_INDEX(childrens_birthdates,',',1) 
WHERE childrens_birthdates LIKE '%,%';
UPDATE unnormalized22 SET childrens_birthdates = TRIM(RIGHT(childrens_birthdates, 
LENGTH(childrens_birthdates)-LENGTH(SUBSTRING_INDEX(childrens_birthdates,',',1))-2))
WHERE childrens_birthdates LIKE '%,%';

INSERT INTO authors(author_name) SELECT DISTINCT author_1 
FROM unnormalized21 WHERE author_1 IS NOT NULL;

UPDATE unnormalized22 SET childrens_birthdates3 = 
CONCAT(SUBSTRING(childrens_birthdates3, 1, 6),'19',SUBSTRING(childrens_birthdates3, 7, 2));
UPDATE unnormalized22 SET childrens_birthdates = 
CONCAT(SUBSTRING(childrens_birthdates, 7, 4),'/',SUBSTRING(childrens_birthdates, 1, 5));
UPDATE unnormalized22 SET childrens_birthdates1 = 
CONCAT(SUBSTRING(childrens_birthdates1, 7, 4),'/',SUBSTRING(childrens_birthdates1, 1, 5));
UPDATE unnormalized22 SET childrens_birthdates2 = 
CONCAT(SUBSTRING(childrens_birthdates2, 7, 4),'/',SUBSTRING(childrens_birthdates2, 1, 5));
UPDATE unnormalized22 SET childrens_birthdates3 = 
CONCAT(SUBSTRING(childrens_birthdates3, 7, 4),'/',SUBSTRING(childrens_birthdates3, 1, 5));

INSERT INTO children(child_name) SELECT DISTINCT childrens_names FROM unnormalized22;

DELETE FROM children where child_id = 11;

select* from unnormalized22;
select* from children;
select* from parents;

INSERT INTO children(child_name) SELECT DISTINCT CAST(childrens_birthdates AS DATE) FROM unnormalized22;



UPDATE unnormalized22 SET child_birthday = CAST('2017-08-25' AS DATE);

UPDATE children SET child_birthday = CAST((SELECT DISTINCT childrens_birthdates 
FROM unnormalized22) AS DATE);
# CONVERT(DATE, childrens_birthdates) FROM unnormalized22;

ALTER TABLE unnormalized22 ADD COLUMN children_id mediumint AFTER last_name;

ALTER TABLE unnormalized22 DROP COLUMN children_id;

DELIMITER \\
CREATE PROCEDURE children_idInsert()
BEGIN
	DECLARE i SMALLINT DEFAULT 1;
    WHILE i<6 DO
		UPDATE unnormalized22 SET children_id=i WHERE emp_id = 1000 + i;
		SET i = i+1; 
	END WHILE;
END \\
DELIMITER ;

CALL children_idInsert();
DROP procedure children_idInsert;

DELIMITER \\
CREATE TRIGGER children_check BEFORE INSERT ON children
FOR EACH ROW
BEGIN
	IF NEW.child_name = NULL THEN SET NEW.child_id = NULL;
	END IF;
END\\
DELIMITER ;
INSERT INTO children(child_name) SELECT DISTINCT childrens_names1 FROM unnormalized22;
INSERT INTO children(child_name) SELECT DISTINCT childrens_names2 FROM unnormalized22;
INSERT INTO children(child_name) SELECT DISTINCT childrens_names3 FROM unnormalized22;

select * FROM children;

UPDATE children c INNER JOIN (SELECT DISTINCT childrens_names, childrens_birthdates FROM unnormalized22) AS u ON c.child_name = u.childrens_names SET c.child_birthday =  
        str_to_date(u.childrens_birthdates, '%Y/%m/%d');
UPDATE children c INNER JOIN (SELECT DISTINCT childrens_names1, childrens_birthdates1 FROM unnormalized22) AS u ON c.child_name = u.childrens_names1 SET c.child_birthday =  
        str_to_date(u.childrens_birthdates1, '%Y/%m/%d');
UPDATE children c INNER JOIN (SELECT DISTINCT childrens_names2, childrens_birthdates2 FROM unnormalized22) AS u ON c.child_name = u.childrens_names2 SET c.child_birthday =  
        str_to_date(u.childrens_birthdates2, '%Y/%m/%d');
UPDATE children c INNER JOIN (SELECT DISTINCT childrens_names3, childrens_birthdates3 FROM unnormalized22) AS u ON c.child_name = u.childrens_names3 SET c.child_birthday =  
        str_to_date(u.childrens_birthdates3, '%Y/%m/%d');        

DELIMITER \\
CREATE PROCEDURE childrenDate()
BEGIN
	DECLARE i SMALLINT DEFAULT 1;
    WHILE i<6 DO
		UPDATE children c, (SELECT DISTINCT * FROM unnormalized22) AS u SET c.child_birthday =  
        str_to_date(u.childrens_birthdates, '%Y/%m/%d') 
        WHERE u.emp_id = 1000 + i;
		SET i = i+1; 
	END WHILE;
END \\
DELIMITER ;

DROP procedure childrenDate;
CALL childrenDate();

select * from parents;
select * from children;
select * from unnormalized22;

#3

USE LAB02;
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE unnormalized31(
	title VARCHAR(30),
    star VARCHAR(30),
    producer VARCHAR(30)
);

INSERT INTO unnormalized31 VALUES ('Great Film', 'Lovely Lady','Money Bags'),
('Great Film', 'Handsome Man','Money Bags'),
('Great Film', 'Lovely Lady','Helen Pursestrings'),
('Great Film', 'Handsome Man','Helen Pursestrings'),
('Boring Movie', 'Lovely Lady','Helen Pursestrings'),
('Boring Movie', 'Precocious','Helen Pursestrings');

CREATE TABLE stars(
	title VARCHAR(30),
    star VARCHAR(30)
);

INSERT INTO stars() SELECT DISTINCT title, star FROM unnormalized31;
select* from stars;

CREATE TABLE producers(
	title VARCHAR(30),
    producer VARCHAR(30)
);

INSERT INTO producers() SELECT DISTINCT title, producer FROM unnormalized31;
select* from producers;

CREATE TABLE unnormalized32(
	last_name VARCHAR(1),
    course VARCHAR(30),
    book VARCHAR(30)
);

INSERT INTO unnormalized32 VALUES ('А','Информатика','Информатика'),
('А','Сети ЭВМ','Информатика'), ('А','Информатика','Сети ЭВМ'),
('А','Сети ЭВМ','Сети ЭВМ'),('В','Программирование','Программирование'),
('В','Программирование','Теория алгоритмов');

CREATE TABLE courses(
	last_name VARCHAR(1),
    course VARCHAR(30)
);
SELECT * FROM courses;
INSERT INTO courses() SELECT DISTINCT last_name, course FROM unnormalized32;
select* from courses;

CREATE TABLE literature(
	last_name VARCHAR(1),
    book VARCHAR(30)
);

INSERT INTO literature() SELECT DISTINCT last_name, book FROM unnormalized32;
select* from literature;

CREATE TABLE unnormalized33(
	court_id SMALLINT,
    time_start TIME,
    time_finish TIME,
    rate VARCHAR(30)
);

INSERT INTO unnormalized33 VALUES (1,'09:30','10:30','Бережливый'),
(1,'11:00','12:00','Бережливый'),(1,'14:00','15:30','Стандарт'),
(2,'10:00','11:30','Премиум-В'),(2,'11:30','13:30','Премиум-В'),(2,'15:00','16:30','Премиум А');

CREATE TABLE courtRate(
	court_id SMALLINT,
    rate VARCHAR(30)
);

INSERT INTO courtRate() SELECT DISTINCT court_id, rate FROM unnormalized33;
select* from courtRate;

CREATE TABLE rateTime(
	rate VARCHAR(30),
    time_start TIME,
    time_finish TIME
);

INSERT INTO rateTime() SELECT DISTINCT rate, time_start, time_finish FROM unnormalized33;
select* from rateTime;


CREATE TABLE unnormalized34(
	product_name VARCHAR(40),
    supplier_name VARCHAR(30),
    pack_size_oz SMALLINT
);

INSERT INTO unnormalized34 VALUES ('Chai','Exotic Liquids',16),
('Chai','Exotic Liquids',12),('Chai','Exotic Liquids',8),
("Chef Anton's Seasoning",'New Orleans',16),("Chef Anton's Seasoning",'New Orleans',12),
("Chef Anton's Seasoning",'New Orleans',8),("Pavlova",'Pavlova LTD',16), 
("Pavlova",'Pavlova LTD',12),("Pavlova",'Pavlova LTD',8);

create table suppliers(
	product_name VARCHAR(40),
    supplier_name VARCHAR(30)
);

INSERT INTO suppliers() SELECT DISTINCT product_name, supplier_name FROM unnormalized34;
select* from suppliers;

CREATE TABLE packsizes(
	product_name VARCHAR(25),
    pack_size_oz SMALLINT
);

INSERT INTO packsizes() SELECT DISTINCT product_name, pack_size_oz FROM unnormalized34;
select* from packsizes;