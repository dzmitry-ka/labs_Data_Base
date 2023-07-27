CREATE DATABASE LAB05;
USE LAB05;
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

# 1.2
DELIMITER \\
CREATE PROCEDURE transaktionBankomatPlus (in sender VARCHAR(50), summ DOUBLE)
BEGIN
	IF summ<0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	IF (summ % 5) !=0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	START TRANSACTION;
    UPDATE acount
		SET acc_balance= acc_balance + summ 
	WHERE acc_number = sender AND summ >0;
    IF ROW_COUNT()>0 THEN
		INSERT INTO appointment 
		(app_op,app_sender, app_recipient, app_time, app_value)
		VALUES (3,'bankomat',sender,now(),summ);
		COMMIT;
	ELSE ROLLBACK;
	END IF;
END \\
DELIMITER ;

CALL transaktionBankomatPlus('9475 3943 2954 2344', 10);

SELECT * FROM appointment;

SELECT * FROM acount;

 
DELIMITER \\
CREATE PROCEDURE transaktionBankomatMinus (in sender VARCHAR(50), summ DOUBLE, isMoney BOOL)
BEGIN
	IF summ<0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
    IF isMoney=0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'NO MONEY IN BANKOMAT!';
	END IF;
    IF (summ % 5) !=0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	START TRANSACTION;
    UPDATE acount
		SET acc_balance= acc_balance - summ 
	WHERE acc_number = sender AND acc_balance>=summ;
    IF ROW_COUNT()>0 THEN
		INSERT INTO appointment 
		(app_op,app_sender, app_recipient, app_time, app_value)
		VALUES (2,sender,'bankomat',NOW(),summ);
		COMMIT;
	ELSE ROLLBACK;
	END IF;
END \\
DELIMITER ;

CALL transaktionBankomatMinus('6279 0212 3242 1515', 15, 1);
SELECT * FROM appointment;

SELECT * FROM acount;

# 1.3

DELIMITER \\
CREATE TRIGGER checking BEFORE UPDATE ON acount
FOR EACH ROW
BEGIN
	IF NEW.acc_balance<0 
		THEN 
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Uncorrect sell amount';
	END IF;
END \\
DELIMITER ;

# 1.4

CREATE TABLE dataShifr(
ref_person_id INT PRIMARY KEY,
ref_person_surname VARBINARY(50),
ref_person_name VARBINARY(50),
ref_person_adress VARBINARY(50),
ref_acc_balance VARBINARY(50),
ref_acc_number VARBINARY(50),
CONSTRAINT cn5 FOREIGN KEY (ref_person_id) REFERENCES person(person_id)
);

DROP TABLE dataShifr;
INSERT IGNORE INTO dataShifr SELECT 
person_id, person_surname,person_name, person_adress,acc_balance, acc_number 
FROM person,acount;


SELECT * FROM dataShifr;

UPDATE dataShifr SET ref_person_name = AES_ENCRYPT(ref_person_name,'lab05_1');
UPDATE dataShifr SET ref_person_surname = AES_ENCRYPT(ref_person_surname,'lab05_2');
UPDATE dataShifr SET ref_person_adress = AES_ENCRYPT(ref_person_adress,'lab05_3');
UPDATE dataShifr SET ref_acc_balance = AES_ENCRYPT(ref_acc_balance,'lab05_4');
UPDATE dataShifr SET ref_acc_number = AES_ENCRYPT(ref_acc_number,'lab05_5');

SELECT CAST(AES_DECRYPT(ref_person_surname,'lab05_2')AS CHAR),
CAST(AES_DECRYPT(ref_person_name,'lab05_1')AS CHAR),
CAST(AES_DECRYPT(ref_person_adress,'lab05_3')AS CHAR),
CAST(AES_DECRYPT(ref_acc_balance,'lab05_4')AS CHAR),
CAST(AES_DECRYPT(ref_acc_number,'lab05_5')AS CHAR)
FROM dataShifr;


# 1.5

CREATE OR REPLACE VIEW ac_owner 
(acc_owner,acc_number,acc_balance,app_op,op_type,app_time,app_value)
AS SELECT acc_owner,acc_number,acc_balance,app_op,app_time,app_value,op_type 
FROM acount,appointment,operations
WHERE acc_owner = 1
WITH CHECK OPTION;

CREATE OR REPLACE VIEW time_account AS
SELECT * FROM appointment
WHERE (app_sender='9475 3943 2954 2344' OR app_recipient='9475 3943 2954 2344')
AND (app_time BETWEEN '2019-12-19' AND '2020-12-31' )
WITH CHECK OPTION;


SELECT * FROM ac_owner;
SELECT * FROM time_account;


# 1.6

CREATE TABLE credits(
ref_person_id INT PRIMARY KEY,
cred_startdate DATE,
cred_period INT,
cred_sum DOUBLE,
cred_stavka DOUBLE,
CONSTRAINT cn3 FOREIGN KEY (ref_person_id) REFERENCES person(person_id)
);

INSERT INTO credits VALUES
(2,'2018-12-08',24,300000,10),
(6,'2020-04-10',12,500000,3);

SELECT * FROM credits;

# 1.7

create table credit(
cr_id INT primary key auto_increment,
ref_owner_id INT,
cr_amount double,
cr_repayed double default 0,
cr_start_date date,
cr_end_date date,
cr_procent double,
constraint cr_person_id foreign key(ref_owner_id) references person(person_id) on update cascade on delete cascade
);

select * from credit;
drop table credit;
insert into credit(ref_owner_id,cr_amount,cr_repayed,cr_start_date,cr_end_date,cr_procent)
values (1,1000,0,'2020-10-15','2021-10-15',3),(2,400,10,'2020-12-31','2022-10-15',10),(3,5000,0,'2020-01-01','2024-01-01',8);

drop table history;

create table history(
his_id INT primary key auto_increment,
ref_sender_number VARCHAR(50),
ref_recipient_number varchar(50),
his_time DATETIME,
his_amount FLOAT,
his_left FLOAT,
ref_op_id INT,
#constraint cn1111 foreign key (ref_sender_number) references acount(acc_number) on delete cascade on update cascade,
#constraint cn2222 foreign key (ref_recipient_number) references acount(acc_number) on delete cascade on update cascade,
constraint cn3333 foreign key (ref_op_id) references operations(op_id) on delete cascade on update cascade
);
select * from history;
DELIMITER //
create procedure repayment222(in owner int)
begin
	declare amountMonth, amountLeft, creditAmount, procent, repayed float;
    declare monthCount int;
    
    set monthCount = (select floor(datediff(cr_end_date,cr_start_date)/30) from credit where ref_owner_id = owner);
    set creditAmount = (select cr_amount from credit where ref_owner_id = owner);
    set amountLeft = creditAmount - (select cr_repayed from credit where ref_owner_id = owner);
	set procent = (select cr_procent from credit where ref_owner_id = owner);	
	
    set amountMonth = round(creditAmount/monthCount + amountLeft*procent/100/monthCount,2);
	
	if amountLeft > 0 then
		if amountMonth>amountLeft then
			set amountMonth=amountLeft;
		end if;

		start transaction;

		update acount
		set acc_balance=acc_balance-amountMonth
		where acc_owner=owner;
		if row_count()>0 then 
			update credit
			set cr_repayed=cr_repayed+amountMonth
			where ref_owner_id=owner;
			if row_count()>0 then
				insert into history
				(ref_sender_number, ref_recipient_number, his_time, his_amount, his_left, ref_op_id)
				values
				((select acc_number from acount where acc_owner=owner),NULL,now(),-amountMonth,
                (select acc_balance from acount where acc_owner=owner) - amountMonth,1);
				commit;
                
			else rollback;
			end if;
            
		else rollback;
		end if;
	
	end if;
end//
DELIMITER ;

drop procedure repayment222;
select * from credit;
select * from history;
call repayment222(2);

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
select * from acount;

delete from acount where acc_balance<0;
