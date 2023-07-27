CREATE DATABASE kr2kirillo;
USE kr2kirillo;
#вариант 11
#В базе данных bankDB реализуйте транзакцию для перевода денежных средств с одного счёта
#на другой. Транзакция должна проходить только, если цифры в дате образуют арифметическую
#прогрессию. 
/*select min(lvl) from (
  select level lvl from dual connect by level<(select max(ID) from Test_table1) 
  minus
  select * from Test_table1
);*/

############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################

CREATE TABLE person
(
person_id INT PRIMARY KEY,
person_name VARCHAR(30),
person_surname VARCHAR(30),
person_adress VARCHAR(30),
person_status ENUM('vip','premium','prestig','classic'),
person_date  DATE
);
INSERT INTO person 
VALUES
(1,'Dzmitry','Kiryla','Nalibokskaya 8-44','vip','2012-08-12'),
(2,'Aleksey','Karlovich','Melezha 10-142','premium','2018-10-25'),
(3,'Anna','Yablonskaya','Nezavisimosti 4','prestig','2020-01-18'),
(4,'Arina','Logvinenko','Pushkina 28-368','classic','2015-03-02'),
(5,'Elena','Zrzazikova','Odoevskogo 18-28','classic','2016-12-08');

SELECT * FROM person;


CREATE TABLE acount
(
acc_owner INT,
acc_type ENUM('current','credit','deposit','budjet','calculated'),
acc_balance DOUBLE,
acc_number VARCHAR(50),
acc_start_date DATETIME,
PRIMARY KEY (acc_owner,acc_number),
CONSTRAINT cn1 FOREIGN KEY (acc_owner) REFERENCES person(person_id)
);

INSERT INTO acount 
VALUES
(1,'current',800.0,'9475 3943 2954 2344','2015-05-15'),
(2,'credit',500.0, '1943 5049 1234 0043','2018-12-08'),
(3,'budjet',1550.0,'2535 2546 1254 2646','2020-09-01'),
(4,'current',100.50,'1111 2222 3333 4444','2020-08-20'),
(5,'current',560.25,'6279 0212 3242 1515','2019-11-25'),
(6,'credit',2000.0,'5555 6666 7777 8888','2020-04-10'),
(7,'current',-25.5,'1234 5678 9012 3456','2020-12-10');

SELECT * FROM acount;


CREATE TABLE operations
(
op_id INT PRIMARY KEY,
op_type ENUM('payment','transaktion','withdraw')
);

INSERT INTO operations VALUES
(1,'payment'), (2,'transaktion'), (3,'transaktion');

SELECT * FROM operations;

CREATE TABLE appointment
(
app_id INT PRIMARY KEY AUTO_INCREMENT,
app_op INT,
app_sender VARCHAR(50),
app_recipient VARCHAR(50),
app_time DATETIME,
app_value DOUBLE,
CONSTRAINT cn2 FOREIGN KEY (app_op) REFERENCES operations(op_id)
);

# 1.1

DELIMITER \\
CREATE PROCEDURE transaktion (in sender varchar(50), in recipient varchar(50), in summ double)
BEGIN
	IF summ<0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	START TRANSACTION;
	UPDATE acount 
	SET acc_balance= acc_balance - summ 
	WHERE acc_number = sender AND acc_balance - summ >0;
	IF ROW_COUNT()>0 THEN
		UPDATE acount 
		SET acc_balance= acc_balance + summ 
		WHERE  acc_number = recipient;
		IF ROW_COUNT()>0 THEN 
			INSERT INTO appointment 
			(app_op, app_sender, app_recipient, app_time, app_value)
			VALUES
			(1,sender,recipient, NOW(),summ);
			COMMIT;
		ELSE ROLLBACK;
		END IF;
	ELSE ROLLBACK;
	END IF;
END \\
DELIMITER ;

CALL transaktion ('9475 3943 2954 2344', '1943 5049 1234 0043', 10);

SELECT * FROM appointment;

SELECT * FROM acount;


SELECT CAST((SELECT REPLACE(acc_number, ' ', '' ) FROM acount) AS UNSIGNED);


#Добавьте в mmf2020 проверочный триггер, который не допускает добавление имени и
#фамилии студента состоящих из только из цифр. Попытайтесь также отследить наличие хотя бы
#одной цифры. Также не позволяете добавлять пользователей, фамилии которых начинаются
#также, как и фамилии преподавателя.


CREATE TABLE studs
(
st_id INT PRIMARY KEY AUTO_INCREMENT,
st_gender ENUM('girl', 'boy') NOT NULL,
st_surname VARCHAR(30) NOT NULL, 
st_name VARCHAR(30) NOT NULL, 
st_birth DATE,
st_speciality ENUM('км', 'веб', 'пед', 'эконом', 
'конструктор', 'мобилки', 'проиводство', 'механики китай', 'механики'), 
st_form ENUM('бюджет', 'платка'), 
st_value FLOAT
);

SELECT * FROM studs; 



drop trigger checkOnNumbers;


delimiter \\
CREATE TRIGGER checkOnNumbers 
BEFORE INSERT ON studs
FOR EACH ROW
BEGIN

    DECLARE i,j INTEGER;
    SET i = 1;
    SET j = 1;
	
    myloop1: WHILE (i <= LENGTH(NEW.st_surname)) DO

        IF SUBSTRING(NEW.st_surname, i, 1) REGEXP '[0-9]' THEN
            SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect Surname value';
            LEAVE myloop1;        
        END IF;   

        SET i = i + 1;

    END WHILE; 
    
    myloop2: WHILE (j <= LENGTH(NEW.st_name)) DO

        IF SUBSTRING(NEW.st_name, j, 1) REGEXP '[0-9]' THEN
            SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect Name value';
            LEAVE myloop2;        
        END IF;   

        SET j = j + 1;

    END WHILE;

END\\
delimiter ;


INSERT INTO studs (st_gender, st_surname, st_name, st_birth, st_speciality, st_form, st_value)
VALUES
('boy', 'Кирил1ло', 'Дмитрий', '2001/11/01', 'км', 'платка', NULL), 
('girl', 'Яблонская', 'Анна', '2002/06/30', 'км', 'бюджет', 180),
 ('boy', 'Карлович', 'Алексей', '2002/08/26', 'км', 'бюджет', 160), 
('girl', 'Логвиненко', 'Арина', '2001/10/09', 'км', 'бюджет', 135), 
('boy', 'Букса', 'Егор', '2001/11/09', 'веб', 'бюджет', 1), 
('boy', 'Иванов', 'Иван', '2002/04/14', 'эконом', 'платка', NULL), 
('boy', 'Николаев', 'Николай', '2001/12/21', 'пед', 'платка', NULL), 
('girl', 'Сергеева', 'Дарья', '2001/07/02', 'конструктор', 'бюджет', 155);


INSERT INTO studs (st_gender, st_surname, st_name, st_birth, st_speciality, st_form, st_value)
VALUES
('boy', 'Кирилло', 'Дми2трий', '2001/11/01', 'км', 'платка', NULL), 
('girl', 'Яблонская', 'Анна', '2002/06/30', 'км', 'бюджет', 180),
 ('boy', 'Карлович', 'Алексей', '2002/08/26', 'км', 'бюджет', 160), 
('girl', 'Логвиненко', 'Арина', '2001/10/09', 'км', 'бюджет', 135), 
('boy', 'Букса', 'Егор', '2001/11/09', 'веб', 'бюджет', 1), 
('boy', 'Иванов', 'Иван', '2002/04/14', 'эконом', 'платка', NULL), 
('boy', 'Николаев', 'Николай', '2001/12/21', 'пед', 'платка', NULL), 
('girl', 'Сергеева', 'Дарья', '2001/07/02', 'конструктор', 'бюджет', 155);


INSERT INTO studs (st_gender, st_surname, st_name, st_birth, st_speciality, st_form, st_value)
VALUES
('boy', 'Кирилло', 'Дмитрий', '2001/11/01', 'км', 'платка', NULL), 
('girl', 'Яблонская', 'Анна', '2002/06/30', 'км', 'бюджет', 180),
 ('boy', 'Карлович', 'Алексей', '2002/08/26', 'км', 'бюджет', 160), 
('girl', 'Логвиненко', 'Арина', '2001/10/09', 'км', 'бюджет', 135), 
('boy', 'Букса', 'Егор', '2001/11/09', 'веб', 'бюджет', 1), 
('boy', 'Иванов', 'Иван', '2002/04/14', 'эконом', 'платка', NULL), 
('boy', 'Николаев', 'Николай', '2001/12/21', 'пед', 'платка', NULL), 
('girl', 'Сергеева', 'Дарья', '2001/07/02', 'конструктор', 'бюджет', 155);

SELECT * FROM studs;

CREATE TABLE subjects
(
sub_id INT PRIMARY KEY AUTO_INCREMENT, 
sub_name VARCHAR(50) NOT NULL, 
sub_teacher VARCHAR(30) NOT NULL, 
sub_hours INT
);


INSERT INTO subjects
(sub_name, sub_teacher, sub_hours)
VALUES
('бд', 'Кушнеров', 30), 
('км', 'Голубева', 25), 
('прога', 'Нагорный', 60), 
('геометрия', 'Базылев', 70),
('пса', 'Атрохов', 40), 
('матан', 'Бровка', 80);



delimiter \\
CREATE TRIGGER checkOnIdentity 
BEFORE INSERT ON studs
FOR EACH ROW
BEGIN

    DECLARE i,j INTEGER;
    SET i = 1;
    SET j = 1;
	
    myloop1: WHILE (i <= LENGTH(NEW.st_surname)) DO   #создаем цикл, который будет пробегать по каждой букве и на нахождение хотя бы одной цифры в имени или фамилииalter
														#если же мы встречаем цифру, то принудительно завершаем цикл и соответственно срабатывает триггер 
        IF SUBSTRING(NEW.st_surname, i, 1) REGEXP '[0-9]' THEN
            SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect Surname value';
            LEAVE myloop1;        
        END IF;   

        SET i = i + 1;

    END WHILE; 
    
    myloop2: WHILE (j <= LENGTH(NEW.st_name)) DO

        IF SUBSTRING(NEW.st_name, j, 1) REGEXP '[0-9]' THEN
            SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect Name value';
            LEAVE myloop2;        
        END IF;   

        SET j = j + 1;

    END WHILE;

END\\
delimiter ;

delimiter \\
CREATE TRIGGER checkOnIdentity 
BEFORE INSERT ON studs
FOR EACH ROW
BEGIN
	IF NEW.st_surname = (sub_teacher FROM subs)
    THEN SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect Name value';
END\\
delimiter ;
