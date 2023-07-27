create database zachet_sem11;
use zachet_sem11;

#В БД mmf2018 реализуйте триггер, автоматически удаляющий студента, который уже прогулял более 50 вторников и четвергов.
# Все удалённые студенты курсором записываются в новую таблицу. 
#Подключитесь к консольному C# приложению. Через механизм классов-близнецов реализуйте возможность перевода студента на следующий курс при успешной сессии.

CREATE TABLE studs(
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




CREATE TABLE semester_grades(
ref_st_id INT, 
pair_date DATETIME, 
pair_attendance ENUM('0', '1'), 
CONSTRAINT cn3 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);

INSERT INTO semester_grades
(ref_st_id, pair_date, pair_attendance)
VALUES
(1, '2020/01/02', '1'),
(1, '2020/01/07', '1'),
(1, '2020/01/09', '1'),
(1, '2020/01/14', '1'),
(1,  '2020/01/16', '1'),
(1, '2020/01/21', '1'),
(1,  '2020/01/23', '1'),
(1,  '2020/01/28', '1'),
(1, '2020/01/30', '1'),
(1,  '2020/02/04', '1'),
(1,  '2020/02/06', '1'),
(1,  '2020/02/11', '1'),
(1,  '2020/02/13', '1'),
(1,  '2020/02/18', '1'),
(1,  '2020/02/20', '1'),
(1,  '2020/02/25', '1'),
(1,  '2020/02/27', '1'),
(1,  '2020/03/03', '1'),
(1,  '2020/03/03', '1'),
(1,  '2020/03/07', '1'),
(1,  '2020/03/10', '1'),
(1,  '2020/03/12', '1'),
(1, '2020/03/17', '1'),
(1,  '2020/03/19', '1'),
(1,  '2020/03/24', '1'),
(1,  '2020/03/26', '1'),
(1,  '2020/03/31', '1'),
(1,  '2020/04/02', '1'),
(1,  '2020/04/07', '1'),
(1,  '2020/04/09', '1'),
(1,  '2020/04/14', '1'),
(1,  '2020/04/16', '1'),
(1,  '2020/04/21', '1'),
(1,  '2020/04/23', '1'),
(1,  '2020/04/28', '1'),
(1, '2020/04/30', '1'),
(1,  '2020/05/05', '1'),
(1,  '2020/05/07', '1'),
(1,  '2020/05/12', '1'),
(1,  '2020/05/14', '1'),
(1,  '2020/05/19', '1'),
(1, '2020/05/21', '1'),
(1, '2020/05/26', '1'),
(1, '2020/05/28', '1'),
(1, '2020/06/02', '1'),
(1,  '2020/06/04', '1'),
(1,  '2020/06/09', '1'),
(1,  '2020/06/11', '1'),
(1,  '2020/06/16', '1'),
(1, '2020/06/18', '1'),
(1,  '2020/06/23', '1'),
(1,  '2020/06/25', '1'),
(1, '2020/06/30', '1');
INSERT INTO semester_grades
(ref_st_id, pair_date, pair_attendance)
VALUES
(1, '2020/10/08', '0'), 
(1,  '2020/10/08', '0'), 
(1,'2020/10/08', '1'), 
(1,'2020/10/08', '1'),
(2,  '2020/10/08', '0'),
(2,  '2020/10/08', '1'),
(2, '2020/10/08', '0'),
(2, '2020/10/08', '1'),
(3, '2020/09/14', '1'),
(3,  '2020/09/14', '1'),
(3,  '2020/09/14', '0'),
(3,  '2020/09/14', '0'),
(4,  '2020/12/12', '0'),
(4, '2020/12/12', '1'),
(4,  '2020/12/12', '1'),
(4, '2020/12/12', '1'),
(5, '2020/11/23', '1'),
(5,  '2020/11/23', '1'),
(5,  '2020/11/23', '0'),
(5,  '2020/11/23', '0'),
(6, '2020/10/30', '1'),
(6,  '2020/10/30', '1'),
(6,  '2020/10/30', '0'),
(6, '2020/10/30', '0');

SELECT * FROM semester_grades;


#В БД mmf2018 реализуйте триггер, автоматически удаляющий студента, который уже прогулял более 50 вторников и четвергов.
# Все удалённые студенты курсором записываются в новую таблицу. 
#Подключитесь к консольному C# приложению. Через механизм классов-близнецов реализуйте возможность 
#перевода студента на следующий курс при успешной сессии.

drop table deleteStudent;

select * from deleteStudent;

CREATE TABLE deleteStudent(
ref_st_id INT,
ref_date DATE,
CONSTRAINT cn4 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);

SELECT DAYOFWEEK('2020/12/26') -1;
############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################

ALTER TABLE studs ADD COLUMN st_propusk_quantity INT;
 update studs set st_propusk_quantity = 0;
 
DELIMITER \\
CREATE PROCEDURE quanPropusk(IN studentID INT)
BEGIN
	DECLARE propuski INT;
	SELECT COUNT(semester_grades.pair_attendance) INTO propuski
    FROM semester_grades WHERE semester_grades.pair_attendance = 1 
    AND semester_grades.ref_st_id = studentID
	GROUP BY studs.st_id;
    UPDATE studs SET st_propusk_quantity = propuski WHERE st_id= studentID;
END\\
DELIMITER ;

CALL quanPropusk((SELECT ref_st_id FROM semester_grades));

drop procedure quanPropusk;



drop function quanPropusk;

delimiter //
create function quanPropusk(id int)
returns int
begin
  declare propuski int;
  select tb.c into propuski from (select COUNT(semester_grades.pair_attendance) as c, semester_grades.ref_st_id from semester_grades
	inner join studs on studs.st_id = semester_grades.ref_st_id
  WHERE  semester_grades.ref_st_id = id and semester_grades.pair_attendance = 0
    AND ((dayofweek(semester_grades.pair_date)-1) = 2 OR (dayofweek(semester_grades.pair_date)-1) = 4)
    GROUP BY semester_grades.ref_st_id) as tb;
  return propuski;
end//
delimiter ;

drop function quanPropusk;

select * from semester_grades where pair_attendance=1;
select * from deleteStudent;
select * from studs;

UPDATE studs, 
(select semester_grades.ref_st_id as ref from semester_grades) as tb
set st_propusk_quantity = quanPropusk(tb.ref) WHERE tb.ref = st_id;

drop procedure quanPropusk;

DELIMITER \\
CREATE TRIGGER checkPropusk AFTER INSERT ON semester_grades
FOR EACH ROW
BEGIN
	DECLARE propuski INT;
    DECLARE studcur CURSOR FOR SELECT NEW.ref_st_id, NEW.ref_st_surname, NEW.ref_st_name, 
				NEW.ref_st_speciality, NEW.ref_st_form FROM deleteStudent;  
	
    
	DECLARE studcur CURSOR FOR SELECT NEW.ref_st_id, event_hours, work_hours FROM activity;    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
    OPEN studcur;
    curs: LOOP
			FETCH studcur INTO id ,ev_h , wo_h;
			IF is_end THEN
				LEAVE curs;
			END IF;
			IF ev_h + wo_h > 10 THEN
				UPDATE studs
				SET studs.st_value = studs.st_value + bonus
				WHERE studs.st_id = id;
			END IF;
		END LOOP curs;
    CLOSE studcur;
    
    
END\\
DELIMITER ;


DELIMITER \\
CREATE TRIGGER checkPropusk AFTER INSERT ON semester_grades
FOR EACH ROW
BEGIN
	DECLARE id,is_end INT;
	DECLARE propuski INT;
	DECLARE studcur CURSOR FOR SELECT new.ref_st_id;    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
	SET propuski = quanPropusk(NEW.ref_st_id);
    OPEN studcur;
    curs: LOOP
			FETCH studcur INTO id;
			IF is_end THEN
				LEAVE curs;
			END IF;
			IF propuski >= 50 THEN
				INSERT INTO deleteStudent VALUES (id,now());
			END IF;
		END LOOP curs;
    CLOSE studcur;
END\\
DELIMITER ;


CREATE TABLE studs(
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

DELIMITER \\
CREATE PROCEDURE bonuses(IN bonus FLOAT)
BEGIN 
	DECLARE id INT;
	DECLARE studcur CURSOR FOR SELECT new.ref_st_id;    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
    OPEN studcur;
    curs: LOOP
			FETCH studcur INTO id;
			IF is_end THEN
				LEAVE curs;
			END IF;
			IF ev_h + wo_h > 10 THEN
				UPDATE studs
				SET studs.st_value = studs.st_value + bonus
				WHERE studs.st_id = id;
			END IF;
		END LOOP curs;
    CLOSE studcur;
END\\
DELIMITER ;

DELIMITER \\
CREATE PROCEDURE goodBuy()
BEGIN
	CREATE TEMPORARY TABLE deletedStudents
    SELECT studs.st_id, studs.st_surname, studs.st_name, ban.badMarks
	FROM studs, (SELECT studs.st_id AS id, COUNT(exams.exam_mark) AS badMarks
    FROM exams INNER JOIN studs ON studs.st_id = exams.ref_st_id
	WHERE exams.exam_mark < 4 
	GROUP BY studs.st_id
	HAVING badMarks > 1) AS ban
    WHERE ban.id = studs.st_id;
    SELECT * FROM deletedStudents;
	DELETE FROM  studs
	WHERE studs.st_id = (SELECT deletedStudents.st_id FROM deletedStudents);
	DELETE FROM  exams
	WHERE exams.ref_st_id = (SELECT deletedStudents.st_id FROM deletedStudents);
	DELETE FROM health
	WHERE health.ref_st_id = (SELECT deletedStudents.st_id FROM deletedStudents);
	DELETE FROM payment
	WHERE payment.ref_st_id = (SELECT deletedStudents.st_id FROM deletedStudents);
	DELETE FROM activity
	WHERE activity.ref_st_id = (SELECT deletedStudents.st_id FROM deletedStudents);
    DROP TEMPORARY TABLE deletedStudents;
    SELECT * FROM studs;
END\\
DELIMITER ;