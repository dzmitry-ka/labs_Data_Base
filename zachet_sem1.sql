create database zachet_sem1;
use zachet_sem1;
# 2. Реализуйте в bankDB транзакцию для перевода между различными банками. Учитывайте различную комиссию между разными банками. Использовать механизм контрольных точек

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

CREATE TABLE banks(
bank_id INT PRIMARY KEY,
bank_name VARCHAR(50)
);

INSERT INTO banks VALUES (1,'belarusbank'),(2,'belagroprombank'),(3,'belgazprombank'),(4,'sberbank');
SELECT *FROM banks;

drop table acount;

CREATE TABLE acount(
acc_owner INT,
acc_type ENUM('current','credit','deposit','budjet','calculated'),
acc_bank INT,
acc_balance DOUBLE,
acc_number VARCHAR(50),
acc_start_date DATETIME,
PRIMARY KEY (acc_owner,acc_number),
CONSTRAINT cn1 FOREIGN KEY (acc_owner) REFERENCES person(person_id),
CONSTRAINT cn2 FOREIGN KEY (acc_bank) REFERENCES banks(bank_id)
);

INSERT INTO acount 
VALUES
(1,'current',1,800.0,'9475 3943 2954 2344','2015-05-15'),
(2,'credit',2,500.0, '1943 5049 1234 0043','2018-12-08'),
(3,'budjet',3,1550.0,'2535 2546 1254 2646','2020-09-01'),
(4,'current',4,100.50,'1111 2222 3333 4444','2020-08-20'),
(5,'current',1,560.25,'6279 0212 3242 1515','2019-11-25'),
(6,'credit',2,2000.0,'5555 6666 7777 8888','2020-04-10');

SELECT * FROM acount;
drop table acount;

CREATE TABLE operations
(
op_id INT PRIMARY KEY,
op_type ENUM('payment','transaktion','withdraw')
);

INSERT INTO operations VALUES
(1,'payment'), (2,'transaktion'), (3,'transaktion');

SELECT * FROM operations;

CREATE TABLE appointment(
app_id INT PRIMARY KEY AUTO_INCREMENT,
app_op INT,
app_sender VARCHAR(50),
app_recipient VARCHAR(50),
app_time DATETIME,
app_value DOUBLE,
CONSTRAINT cn3 FOREIGN KEY (app_op) REFERENCES operations(op_id)
);

drop table appointment;
CREATE TABLE banks_procent(
bp_bank_id1 INT,
bp_bank_id2 INT,
bp_procent FLOAT,
CONSTRAINT cn5 FOREIGN KEY (bp_bank_id1) REFERENCES bank(bank_id),
CONSTRAINT cn6 FOREIGN KEY (bp_bank_id2) REFERENCES bank(bank_id)
);
INSERT INTO banks_procent VALUES (1,1,0),(1,2,2),(1,3,3),(1,4,4),
(2,1,2),(2,2,0),(2,3,3),(2,4,4),
(3,1,3),(3,2,2),(3,3,0),(3,4,4),
(4,1,4),(4,2,2),(4,3,3),(4,4,0);

drop table appointment;
# 1.1

drop procedure transaktion;

DELIMITER \\
CREATE PROCEDURE transaktion (in sender varchar(50), in recipient varchar(50), in summ double)
BEGIN
	DECLARE bank2 INT;
    DECLARE bankProcent FLOAT;
	IF summ<0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	SELECT bp_bank_id2 INTO bank2 FROM banks_procent INNER JOIN acount ON  acount.acc_bank = bp_bank_id2 
    WHERE acount.acc_number = recipient LIMIT 1;
    SELECT bp_procent INTO bankProcent FROM banks_procent INNER JOIN acount ON bp_bank_id1 = acount.acc_bank 
    WHERE acount.acc_number = sender AND banks_procent.bp_bank_id2 = bank2;
	START TRANSACTION;
	UPDATE acount 
	SET acc_balance= acc_balance - summ - bankProcent*summ/100
	WHERE acc_number = sender AND acc_balance - summ - bankProcent*summ/100 >0;
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


# 2. Реализуйте в bankDB транзакцию для перевода между различными банками. 
# Учитывайте различную комиссию между разными банками. Использовать механизм контрольных точек



DELIMITER \\
CREATE PROCEDURE transaktionBankomatPlus (in sender VARCHAR(50), recipient varchar(50), summ DOUBLE)
BEGIN
	DECLARE bank2 INT;
    DECLARE bankProcent FLOAT;
    SET bank2 = (SELECT bp_bank_id2 FROM banks_procent INNER JOIN acount ON bp_bank_id2 = acount.acc_bank 
    WHERE acount.acc_number = recipient);
    SET bankProcent = (SELECT bp_procent FROM banks_procent INNER JOIN acount ON bp_bank_id1 = acount.acc_bank 
    WHERE acount.acc_number = sender AND banks_procent.bp_bank_id2 = bank2);
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
