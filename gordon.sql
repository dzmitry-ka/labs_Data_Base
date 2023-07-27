CREATE DATABASE gordon;
USE gordon;

############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################
select * from administration;
CREATE TABLE guests(
guest_id INT PRIMARY KEY,
guest_surname VARCHAR(50) NOT NULL,
guest_name VARCHAR(50) NOT NULL,
guest_birthdate DATE NOT NULL,
guest_alive BOOL,
guest_blacklist BOOL
);
INSERT INTO guests VALUES (1,'Surkis','Igor','1958-11-28',1,0),(2,'Komarovskiy','Evgeniy','1960-10-15',1,0),
	(3,'Kernes','Gennadiy','1959-06-27',0,0),(4,'Solovyev','Vladimir','1963-10-20',1,1),(5,'Pahmutova','Aleksandra','1929-11-09',1,0);
select * from guests;
select * from programms;
select * from ads; 
select * from companies;
select * from contracts;


CREATE TABLE contracts(
contract_id INT PRIMARY KEY NOT NULL,
contract_position VARCHAR(50) NOT NULL,
contract_salary FLOAT NOT NULL,
contract_start_date DATE NOT NULL,
contract_end_date DATE
);


alter table contracts modify contract_salary double NOT NULL DEFAULT 0;
alter table contracts modify contract_start_date datetime NOT NULL DEFAULT current_timestamp();
alter table contracts modify contract_end_date datetime;
select * from contracts;
INSERT INTO contracts(contract_id,contract_position,contract_salary,contract_start_date,contract_end_date) 
	VALUES (1,'operator',456.97,'2009-10-02','2019-10-02'),(2,'producer',1000,'2015-02-01','2020-08-13'),
	(3,'make-up artist', 977.22, '2020-04-15', NULL), (4,'wife',1001.99,'1994-08-30', NULL),
	(5,'hairdresser',10000,'2000-01-01',NULL);

select * from contracts;
DELIMITER //
CREATE TRIGGER upd_cont_salary BEFORE UPDATE ON contracts
       FOR EACH ROW
       BEGIN
           IF NEW.contract_salary < 0 OR (SELECT DATEDIFF(NEW.contract_end_date, NEW.contract_start_date)) < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input datas in contracts';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_cont_salary BEFORE INSERT ON contracts
       FOR EACH ROW
       BEGIN
           IF NEW.contract_salary < 0 OR (SELECT DATEDIFF(NEW.contract_end_date, NEW.contract_start_date)) < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input datas in contracts';
           END IF;
       END//
DELIMITER ;
CREATE TABLE administration(
admin_id INT PRIMARY KEY NOT NULL,
admin_surname VARCHAR(50) NOT NULL,
admin_name VARCHAR(50) NOT NULL,
admin_birthdate DATE NOT NULL,
admin_bans TINYINT UNSIGNED DEFAULT 0,
CONSTRAINT cn1 FOREIGN KEY (admin_id) REFERENCES contracts(contract_id)
);
INSERT INTO administration VALUES (1,'Brezhnev','Leonid','1906-12-19',1),(2,'Kiselev','Dmitriy','1954-04-26',2),
	(3,'Obama','Barack','1961-08-04',0),(4,'Batsman','Alesia','1984-10-03',0),(5,'Dud','Yuri','1986-10-11',0);
CREATE TABLE programms(
programm_id INT PRIMARY KEY AUTO_INCREMENT,
ref_guest_id INT NOT NULL,
programm_date DATE NOT NULL,
programm_duration TIME,
programm_type ENUM('sports', 'politics','musicians','businessmans') NOT NULL, 
CONSTRAINT cn2 FOREIGN KEY (ref_guest_id) REFERENCES guests(guest_id)
);
alter table programms drop foreign key cn2;
alter table programms add constraint cn2 FOREIGN KEY (ref_guest_id) 
REFERENCES guests(guest_id) on delete cascade;
INSERT INTO programms(ref_guest_id,programm_date,programm_duration,programm_type)
	VALUES (1,NOW(),'02:30:10','sports');
INSERT INTO programms(ref_guest_id,programm_date,programm_duration,programm_type)
	VALUES (2,'2020-09-04','01:12:08','businessmans'),
    (3,'2013-11-02','01:42:00','politics'),(5,'2012-02-14','00:56:32','musicians');    
select * from programms;
DELIMITER //
CREATE TRIGGER upd_guest_id BEFORE UPDATE ON programms
       FOR EACH ROW
       BEGIN
           IF NEW.ref_guest_id < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input of guest id';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_guest_id BEFORE INSERT ON programms
       FOR EACH ROW
       BEGIN
           IF NEW.ref_guest_id < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input of guest id';
           END IF;
       END//
DELIMITER ;
CREATE TABLE companies(
company_id INT PRIMARY KEY NOT NULL,
company_name VARCHAR(50) NOT NULL,
company_type VARCHAR(50) NOT NULL,
company_budget FLOAT NOT NULL,
company_country VARCHAR(3) NOT NULL
);
alter table companies modify company_name VARCHAR(50) NOT NULL DEFAULT 'unknown';
alter table companies modify company_type VARCHAR(50) NOT NULL DEFAULT 'unknown';
ALTER TABLE companies MODIFY company_budget DOUBLE NOT NULL DEFAULT 0;
alter table companies modify company_country VARCHAR(50) NOT NULL DEFAULT ' ';

INSERT INTO companies VALUES (1,'Privatbank','bank',1000000000000,'UKR'),
	(2,'Doloy Gemorroy','medicine',2434352.54,'UKR'), (3,'Khodor Time', 'politics',10000000, 'RUS'),
    (4, "israel's masons", 'religion',150,'ISR'),(5,'Roshen','sweets',432423401,'UKR');
select * from companies;
DELIMITER //
CREATE TRIGGER ins_comp BEFORE INSERT ON companies
       FOR EACH ROW
       BEGIN
           IF NEW.company_budget < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input of guest id';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER upd_comp BEFORE UPDATE ON companies
       FOR EACH ROW
       BEGIN
           IF NEW.company_budget < 0 THEN
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Not enough money in company!';
           END IF;
       END//
DELIMITER ;
select * from companies;
show triggers;
CREATE TABLE finances(
finance_id ENUM("1") PRIMARY KEY NOT NULL,
finance_bill DOUBLE NOT NULL DEFAULT 0,
finance_lastupdatePlus DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
finance_plusupdate DOUBLE DEFAULT 0,
finance_lastupdateMinus DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
finance_minusupdate DOUBLE DEFAULT 0
);
select * from finances;
INSERT INTO finances(finance_id, finance_bill) VALUE (1, 100000);

DELIMITER //
CREATE TRIGGER upd_finances BEFORE UPDATE ON finances
       FOR EACH ROW
       BEGIN
           IF NEW.finance_bill < 0 OR NEW.finance_plusupdate < 0 
			OR NEW.finance_minusupdate < 0 THEN 
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct amount';
           END IF;
       END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER ins_finances BEFORE INSERT ON finances
       FOR EACH ROW
       BEGIN
           IF NEW.finance_bill < 0 OR NEW.finance_bill IS NULL 
			OR NEW.finance_plusupdate < 0 OR NEW.finance_minusupdate < 0 THEN 
               SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Please enter the correct amount';
           END IF;
       END//
DELIMITER ;
CREATE TABLE ads(
ads_id INT PRIMARY KEY AUTO_INCREMENT,
ref_company_id INT NOT NULL,
ref_programm_id INT NOT NULL,
ads_donat DOUBLE DEFAULT 0,
CONSTRAINT cn3 FOREIGN KEY (ref_company_id) REFERENCES companies(company_id),
CONSTRAINT cn4 FOREIGN KEY (ref_programm_id) REFERENCES programms(programm_id)
);
alter table ads drop foreign key cn4;
alter table ads add constraint cn4 FOREIGN KEY (ref_programm_id) 
REFERENCES programms(programm_id) on delete cascade;
alter table ads drop foreign key cn3;
alter table ads add constraint cn3 FOREIGN KEY (ref_company_id) 
REFERENCES companies(company_id) on delete cascade;

select * from companies;

show tables;

DELIMITER \\
CREATE PROCEDURE transaktion (IN sender VARCHAR(50), IN program INT, IN summ DOUBLE)
BEGIN
	DECLARE id INT;
	IF summ<0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'UNCORRECT SUM!';
	END IF;
	START TRANSACTION;
	UPDATE companies 
	SET company_budget = company_budget - summ 
	WHERE company_name = sender AND company_budget - summ >= 0;
	IF ROW_COUNT()>0 THEN
		UPDATE finances 
		SET finance_bill = finance_bill + summ,
			finances.finance_plusupdate = summ,
			finances.finance_lastupdatePlus = NOW()
		WHERE  finance_id = 1;
        IF ROW_COUNT()>0 THEN 
			SELECT company_id INTO id FROM companies
			WHERE company_name = sender;
        ELSE ROLLBACK;
		END IF;
		IF ROW_COUNT()>0 THEN 
			INSERT INTO ads 
			(ref_company_id, ref_programm_id, ads_donat)
			VALUES (id, program, summ);
			COMMIT;
		ELSE ROLLBACK;
		END IF;
	ELSE ROLLBACK;
	END IF;
END \\
DELIMITER ;


drop procedure transaktion;
select * from companies;
select * from ads;
select * from finances;
select * from programms;
update companies set company_budget = 10000000 where company_id = 1;

CALL transaktion('Privatbank', 1, 432);
CALL transaktion("Roshen", 3, 200);


CREATE INDEX indGuests ON guests(guest_surname);
EXPLAIN SELECT * FROM gordon.guests WHERE guest_surname ='Zgu%'; 

CREATE INDEX indAdmin ON administration(admin_name);
EXPLAIN SELECT * FROM gordon.administration WHERE admin_name ='Zgu%'; 

DELIMITER \\
CREATE FUNCTION avgMoney(id INT)
RETURNS DOUBLE
BEGIN
	DECLARE avg_money DOUBLE;
	SELECT AVG(ads_donat) INTO avg_money FROM ads
	WHERE ref_programm_id = id;
    RETURN avg_money;
END\\
DELIMITER ;

drop function avgMoney;

SELECT avgMoney(1);

DELIMITER \\
CREATE PROCEDURE plusBan(IN surn VARCHAR(50), IN nam VARCHAR(50))
BEGIN 
	DECLARE id INT;
    SELECT admin_id INTO id FROM administration
		WHERE admin_surname = surn AND admin_name = nam; 
	UPDATE administration 
    SET admin_bans = admin_bans + 1
	WHERE admin_surname = surn AND admin_name = nam AND admin_bans<=2;
    IF (SELECT admin_bans FROM administration 
    WHERE admin_surname = surn AND admin_name = nam) = 3 THEN 
    UPDATE contracts 
	SET contract_end_date = NOW() 
    WHERE contract_id = id AND contract_end_date IS NULL;
    END IF;
END \\
DELIMITER ;

select * from ADMINISTRATION;
drop procedure plusBan;
CALL plusBan('Obama','Barack');

SELECT * FROM contracts;
update ADMINISTRATION set admin_bans = 1 where admin_id = 3;




select * from companies;
select * from finances;
select * from ads;
select * from programms;

INSERT INTO programms(ref_guest_id,programm_date,programm_duration,programm_type)
	VALUES (3,'2013-11-02','01:42:00','politics');   
    
UPDATE ads SET ref_programm_id = 14 WHERE ads_id = 30;    
CALL transaktion("Roshen", 6, 100);
CALL transaktion("Privatbank", 6, 200);
CALL transaktion("Privatbank", 6, 50);
CALL transaktion("israel's masons", 6, 50);