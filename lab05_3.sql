USE newStrikeMTW;


############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################
# 3.1
CREATE USER MTWdirector IDENTIFIED BY '1'; 
GRANT SELECT, INSERT, UPDATE, DELETE ON newStrikeMTW.contracts TO MTWdirector; 
GRANT SELECT, INSERT, UPDATE, DELETE ON newStrikeMTW.staff_MTW TO MTWdirector; 


CREATE USER policemans IDENTIFIED BY '2';
GRANT SELECT, INSERT, UPDATE, DELETE ON newStrikeMTW.* TO policemans;

CREATE USER goverments IDENTIFIED BY '3';
GRANT ALL ON newStrikeMTW.* TO goverments;

CREATE USER workers IDENTIFIED BY '4';
GRANT SELECT ON newStrikeMTW.protests TO workers;
GRANT SELECT ON newStrikeMTW.protest_press TO workers;

# 3.2
SELECT * FROM contracts;
SELECT * FROM staff_MTW;
SELECT * FROM detention;
SELECT * FROM staff_detention;

DELIMITER \\
CREATE PROCEDURE detentionFine (IN surn VARCHAR(50), fine INT)
BEGIN
	START TRANSACTION;
    UPDATE contracts
		INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id 
        INNER JOIN staff_detention ON staff_detention.ref_staff_id = staff_MTW.staff_id
		INNER JOIN detention ON detention.detention_id = staff_detention.ref_detention_id
			SET contracts.contract_salary = contracts.contract_salary - fine
        WHERE staff_MTW.staff_surname = surn AND fine<=contracts.contract_salary;
	IF ROW_COUNT()>0 THEN COMMIT;
    ELSE ROLLBACK;
    END IF;
END\\            
DELIMITER ;


DELIMITER \\
CREATE PROCEDURE detentionFine (IN surn CHAR(50), fine INT)
BEGIN
	START TRANSACTION;
    UPDATE contracts
		INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id 
        INNER JOIN staff_detention ON staff_detention.ref_staff_id = staff_MTW.staff_id
		INNER JOIN detention ON detention.detention_id = staff_detention.ref_detention_id
			SET contracts.contract_salary = contracts.contract_salary - fine
        WHERE CAST(AES_DECRYPT(staff_surname,'lab05_3')AS CHAR) = surn AND fine<=contracts.contract_salary;
	IF ROW_COUNT()>0 THEN COMMIT;
    ELSE ROLLBACK;
    END IF;
END\\            
DELIMITER ;


UPDATE contracts SET contract_salary = 1000 WHERE contract_id=1;
SELECT CAST(AES_DECRYPT(staff_surname,'lab05_3')AS CHAR),
CAST(AES_DECRYPT(staff_name,'lab05_4')AS CHAR)
FROM contracts
INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id ;

drop procedure detentionFine;
SELECT * FROM contracts;
SELECT * FROM staff_MTW;
SELECT * FROM detention;
SELECT * FROM staff_detention;

CREATE OR REPLACE VIEW worker
AS SELECT contracts.contract_id AS ID, CAST(AES_DECRYPT(staff_surname,'lab05_3')AS CHAR) AS Surname, 
CAST(AES_DECRYPT(staff_name,'lab05_4')AS CHAR) AS Name, contracts.contract_position AS Position, 
contracts.contract_salary AS Salary, contracts.contract_start_date, 
contracts.contract_end_date, staff_MTW.staff_protest AS Striker
FROM staff_MTW
INNER JOIN contracts ON contracts.contract_id = staff_MTW.staff_id;

SELECT * FROM worker;

CALL detentionFine('Дылевский', 4);


DELIMITER \\
CREATE PROCEDURE newContract (IN surn CHAR(50))
BEGIN
	START TRANSACTION;
    UPDATE contracts
		INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id 
			SET contracts.contract_salary = 1.03*contracts.contract_salary, 
				contracts.contract_start_date = NOW()
        WHERE CAST(AES_DECRYPT(staff_surname,'lab05_3')AS CHAR) = surn AND staff_MTW.staff_protest=0;
	IF ROW_COUNT()>0 THEN COMMIT;
    ELSE ROLLBACK;
    END IF;
END\\            
DELIMITER ;

select * from contracts INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id WHERE staff_surname=AES_ENCRYPT('Ябатько','lab05_3')  AND staff_MTW.staff_protest=0;

select * FROm staff_MTW ;

drop procedure newContract;

CALL newContract('Ябатько');



SELECT * FROM contracts;
SELECT * FROM staff_MTW;

SELECT * FROM worker;

SELECT * FROM Protests;

# 3.3

CREATE INDEX indProtest ON protests(protest_date);

SELECT * FROM protests WHERE protest_date = '2020-08-10';

CREATE FULLTEXT INDEX indGoveOpinion ON goverment_protests(goverment_protests_reaction) ;

SELECT * FROM goverment_protests WHERE MATCH(goverment_protests_reaction) AGAINST ('любимую');


# 3.4

ALTER TABLE staff_MTW MODIFY staff_surname VARBINARY(50);
ALTER TABLE staff_MTW MODIFY staff_name VARBINARY(50);


UPDATE staff_MTW SET staff_surname = AES_ENCRYPT(staff_surname,'lab05_3');
UPDATE staff_MTW SET staff_name = AES_ENCRYPT(staff_name,'lab05_4');

SELECT CAST(AES_DECRYPT(staff_surname,'lab05_3')AS CHAR),
CAST(AES_DECRYPT(staff_name,'lab05_4')AS CHAR)
FROM contracts
INNER JOIN staff_MTW ON staff_MTW.staff_id = contracts.contract_id ;

