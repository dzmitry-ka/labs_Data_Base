CREATE DATABASE LAB04;
USE LAB04;
# 1 
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

CREATE TABLE subjects
(
sub_id INT PRIMARY KEY AUTO_INCREMENT, 
sub_name VARCHAR(50) NOT NULL, 
sub_teacher VARCHAR(30) NOT NULL, 
sub_hours INT
);
SELECT * FROM subjects; 

CREATE TABLE exams
(
exam_id INT PRIMARY KEY AUTO_INCREMENT,
ref_sub_id INT, 
ref_st_id INT, 
exam_date DATETIME, 
exam_mark INT, 
exam_tsession ENUM('зимняя','летняя'),
CONSTRAINT cn1 FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id), 
CONSTRAINT cn2 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);

SELECT * FROM exams;

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


INSERT INTO subjects
(sub_name, sub_teacher, sub_hours)
VALUES
('бд', 'Кушнеров', 30), 
('км', 'Голубева', 25), 
('прога', 'Нагорный', 60), 
('геометрия', 'Базылев', 70),
('пса', 'Атрохов', 40), 
('матан', 'Бровка', 80);


INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2021/01/18', '8', 'зимняя'), 
('1', '2', '2021/01/18', '9', 'зимняя'), 
('1', '3', '2021/01/13', '10', 'зимняя'),
('2', '4', '2021/01/15', '4', 'зимняя'),
('2', '5', '2021/01/18', '2', 'зимняя'),
('2', '4', '2021/01/28', '8', 'зимняя'),
('3', '1', '2021/01/12', '8', 'зимняя'),
('3', '2', '2021/01/12', '6', 'зимняя'),
('3', '5', '2021/01/17', '3', 'зимняя'),
('3', '6', '2021/01/19', '2', 'зимняя'),
('4', '3', '2021/01/02', '5', 'зимняя'),
('4', '4', '2021/01/04', '10', 'зимняя'),
('4', '5', '2021/01/04', '9', 'зимняя'),
('4', '6', '2021/01/02', '9', 'зимняя'),
('5', '1', '2021/01/02', '10', 'зимняя'),
('5', '2', '2021/01/02', '5', 'зимняя'),
('5', '6', '2021/01/08', '8', 'зимняя'),
('6', '1', '2021/01/10', '6', 'зимняя'),
('6', '2', '2021/01/10', '9', 'зимняя'),
('6', '6', '2021/01/16', '5', 'зимняя');#зимняя

INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2021/06/18', '6', 'летняя'), 
('1', '2', '2021/06/18', '3', 'летняя'), 
('1', '3', '2021/06/13', '7', 'летняя'),
('2', '4', '2021/06/15', '5', 'летняя'),
('2', '5', '2021/06/18', '9', 'летняя'),
('2', '4', '2021/06/28', '10', 'летняя'),
('3', '1', '2021/06/12', '4', 'летняя'),
('3', '2', '2021/06/12', '7', 'летняя'),
('3', '5', '2021/06/17', '5', 'летняя'),
('3', '6', '2021/06/19', '9', 'летняя'),
('4', '3', '2021/06/02', '4', 'летняя'),
('4', '4', '2021/06/04', '7', 'летняя'),
('4', '5', '2021/06/04', '5', 'летняя'),
('4', '6', '2021/06/02', '7', 'летняя'),
('5', '1', '2021/06/02', '5', 'летняя'),
('5', '2', '2021/06/02', '8', 'летняя'),
('5', '6', '2021/06/08', '9', 'летняя'),
('6', '1', '2021/06/10', '5', 'летняя'),
('6', '2', '2021/06/10', '7', 'летняя'),
('6', '6', '2021/06/16', '10', 'летняя'); #летняя 

/*
insert into exams
(ref_sub_id, ref_st_id, exam_date, exam_mark)
values
('1', '1', '2021/01/18', '8' ), 
('1', '2', '2021/01/18', '9' ), 
('1', '3', '2021/01/13', '10'),
('2', '4', '2021/01/15', '4'),
('2', '5', '2021/01/18', '2'),
('2', '4', '2021/01/28', '8'),
('3', '1', '2021/01/12', '8'),
('3', '2', '2021/01/12', '6'),
('3', '5', '2021/01/17', '3'),
('3', '6', '2021/01/19', '2'),
('4', '3', '2021/01/02', '5'),
('4', '4', '2021/01/04', '10'),
('4', '5', '2021/01/04', '9'),
('4', '6', '2021/01/02', '9'),
('5', '1', '2021/01/02', '10'),
('5', '2', '2021/01/02', '5'),
('5', '6', '2021/01/08', '8'),
('6', '1', '2021/01/10', '6'),
('6', '2', '2021/01/10', '9'),
('6', '6', '2021/01/16', '5');#зимняя

insert into exams
(ref_sub_id, ref_st_id, exam_date, exam_mark)
values
('1', '1', '2021/06/18', '6'), 
('1', '2', '2021/06/18', '3'), 
('1', '3', '2021/06/13', '7'),
('2', '4', '2021/06/15', '5'),
('2', '5', '2021/06/18', '9'),
('2', '4', '2021/06/28', '10'),
('3', '1', '2021/06/12', '4'),
('3', '2', '2021/06/12', '7'),
('3', '5', '2021/06/17', '5'),
('3', '6', '2021/06/19', '9'),
('4', '3', '2021/06/02', '4'),
('4', '4', '2021/06/04', '7'),
('4', '5', '2021/06/04', '5'),
('4', '6', '2021/06/02', '7'),
('5', '1', '2021/06/02', '5'),
('5', '2', '2021/06/02', '8'),
('5', '6', '2021/06/08', '9'),
('6', '1', '2021/06/10', '5'),
('6', '2', '2021/06/10', '7'),
('6', '6', '2021/06/16', '10'); #летняя 
*/

SELECT * FROM studs;
SELECT * FROM subjects;
SELECT * FROM exams;

#2.1

CREATE TABLE semester_grades
(
ref_st_id INT, 
ref_sub_id INT,
pair_date DATETIME, 
pair_attendance ENUM('0', '1'), 
pair_mark INT, 
CONSTRAINT cn3 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id), 
CONSTRAINT cn4 FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id)
);

SELECT * FROM semester_grades;


INSERT INTO semester_grades
(ref_st_id, ref_sub_id, pair_date, pair_attendance, pair_mark)
VALUES
(1, 2, '2020/10/08', '0', 4),
(1, 2, '2020/10/09', '0', 4),
(1, 2, '2020/10/010', '0', 4),
(1, 2, '2020/10/11', '0', 4);
SELECT * FROM semester_grades;
INSERT INTO semester_grades
(ref_st_id, ref_sub_id, pair_date, pair_attendance, pair_mark)
VALUES
(1, 1, '2020/10/08', '0', 9), 
(1, 2, '2020/10/08', '0', 9), 
(1, 5, '2020/10/08', '1', 8), 
(1, 2, '2020/10/08', '1', 6),
(2, 1, '2020/10/08', '0', 10),
(2, 2, '2020/10/08', '1', 5),
(2, 5, '2020/10/08', '0', 7),
(2, 2, '2020/10/08', '1', 4),
(3, 1, '2020/09/14', '1', 8),
(3, 5, '2020/09/14', '1', 3),
(3, 3, '2020/09/14', '0', 8),
(3, 6, '2020/09/14', '0', 9),
(4, 1, '2020/12/12', '0', 9),
(4, 4, '2020/12/12', '1', 10),
(4, 3, '2020/12/12', '1', 4),
(4, 6, '2020/12/12', '1', 5),
(5, 6, '2020/11/23', '1', 3),
(5, 1, '2020/11/23', '1', 6),
(5, 4, '2020/11/23', '0', 6),
(5, 2, '2020/11/23', '0', 8),
(6, 5, '2020/10/30', '1', 0),
(6, 6, '2020/10/30', '1', 10),
(6, 2, '2020/10/30', '0', 10),
(6, 4, '2020/10/30', '0', 4);

SELECT * FROM semester_grades;

#2.2 - 2.3

CREATE TABLE activity (
ref_st_id INT PRIMARY KEY,
work_hours INT,
event_hours INT,
CONSTRAINT cn5 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);
ALTER TABLE activity ADD COLUMN activity_index INT;

INSERT INTO activity(ref_st_id,work_hours,event_hours) 
VALUES
(1,4,6), (2,3,6), (3,2,6),
(4,7,10), (5,3,14), (6,6,15);

SELECT * FROM activity;

#2.4 

CREATE TABLE payment(
ref_st_id INT PRIMARY KEY,
pay_money FLOAT,
pay_dedline DATETIME,
pay_access BOOL,
CONSTRAINT cn7 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);
INSERT INTO payment(ref_st_id) SELECT 
DISTINCT st_id FROM studs
WHERE st_form = 'платка';

SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;

UPDATE payment SET
pay_money = 1000,
pay_dedline = '2020-12-31',
pay_access = 0;

UPDATE payment SET 
pay_access = 1,
pay_money = 0
WHERE ref_st_id = 1;

SELECT * FROM payment;
#2.5

CREATE TABLE health (
ref_st_id INT,
health_bool ENUM('+', '-'), 
CONSTRAINT cn6 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);
DROP table health;
INSERT INTO health VALUES
(1, '+'), (2, '-'), (3, '+'), 
(4, '-'), (5, '+'), (6, '-');

SELECT * FROM health;


#########################################################################################
CREATE TABLE health (
ref_st_id INT,
health_condition ENUM('excelent','good','average','bad'),
health_PE ENUM('basic','subbasic','SMG','LFK'),
health_zachet ENUM('+', '-'),
CONSTRAINT cn66666 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);

DELIMITER \\
CREATE TRIGGER studentHealth BEFORE INSERT ON health
FOR EACH ROW
BEGIN
	IF NEW.health_condition = 'excelent' THEN
		SET NEW.health_PE='basic';
	ELSEIF NEW.health_condition = 'good' THEN
		SET NEW.health_PE='subbasic';
	ELSEIF NEW.health_condition = 'average' THEN
		SET NEW.health_PE='SMG';
    ELSEIF NEW.health_condition = 'bad' THEN
		SET NEW.health_PE='LFK'; 
    END IF;    
	IF (NEW.health_condition = 'bad' AND NEW.health_PE='LFK') THEN
		SET NEW.health_zachet = '-';
	ELSE SET NEW.health_zachet = '+';
    END IF;
END\\
DELIMITER ;


INSERT INTO health(ref_st_id,health_condition) VALUES 
(1, 'excelent'), (2, 'good'), (3, 'average'), 
(6, 'good'), (7, 'excelent'), (8, 'bad');

SELECT * FROM health;
#делать детализацию по здоровью через триггер в таблице здоровье

#########################################################################################

#2.6
set foreign_key_checks=0;

ALTER TABLE semester_grades
DROP FOREIGN KEY cn3;

ALTER TABLE semester_grades
ADD CONSTRAINT cn3 FOREIGN KEY (ref_st_id)
REFERENCES studs(st_id) ON DELETE CASCADE;

DELETE FROM studs
WHERE st_id = 4;

SELECT * FROM studs;

############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################
#3.1
/*
DELIMITER \\
CREATE PROCEDURE scholarship_increase()
BEGIN 
  UPDATE studs SET 
  st_value = st_value*1.03 
  WHERE st_form = 'бюджет';
END \\
DELIMITER ;
DROP PROCEDURE scholarship_increase;
*/

DELIMITER \\
CREATE PROCEDURE scholarship_increase(IN pr INT)
BEGIN 
	UPDATE studs SET
	st_value = st_value + st_value*(pr/100);
END \\
DELIMITER ;

CALL scholarship_increase(3);

SELECT * FROM studs;

#3.2

DELIMITER \\
CREATE FUNCTION avgMark(teacher VARCHAR(30))
RETURNS DECIMAL(3,2)
BEGIN
	DECLARE avg_mark DECIMAL(3,2);
	SELECT AVG(exams.exam_mark) INTO avg_mark FROM exams
	INNER JOIN subjects ON
	subjects.sub_id = exams.ref_sub_id AND
	subjects.sub_teacher = teacher;
    RETURN avg_mark;
END\\
DELIMITER ;

SELECT avgMark('Кушнеров') AS avgValue;

#3.3

DELIMITER \\
CREATE PROCEDURE bonuses(IN bonus FLOAT)
BEGIN 
	DECLARE id , ev_h, wo_h INT;
	DECLARE is_end INT DEFAULT 0;
	DECLARE studcur CURSOR FOR SELECT ref_st_id, event_hours, work_hours FROM activity;    
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

SELECT * FROM activity;
SELECT * FROM studs;

CALL bonuses(1);

# 3.4

CREATE TABLE topBest (
top_surname varchar(30),
top_avgMark float
);
 
CREATE TABLE topWorst (
top_surname VARCHAR(30),
top_avgMark float
);

CREATE TABLE topActive (
top_surname varchar(30),
top_hours float
);

DELIMITER \\
CREATE PROCEDURE top5()
BEGIN 
	DECLARE best, worst, brsm VARCHAR(50);
    DECLARE avgMarkB, avgMarkW, hours DOUBLE;

	DECLARE bestCur CURSOR FOR 
	SELECT studs.st_surname, marks.avgmark
	FROM (SELECT exams.ref_st_id AS id, avg(exam_mark) AS avgMark 
		FROM exams 
        GROUP BY exams.ref_st_id) AS marks
	INNER JOIN studs ON studs.st_id = marks.id
	ORDER BY marks.avgMark DESC LIMIT 5;
	
	DECLARE worstCur CURSOR FOR 
	SELECT studs.st_surname, marks.avgmark
	FROM (SELECT exams.ref_st_id AS id, AVG(exams.exam_mark) AS avgMark 
		FROM exams 
        GROUP BY exams.ref_st_id) AS marks
	INNER JOIN studs ON studs.st_id = marks.id
	ORDER BY marks.avgMark LIMIT 5;
		
	DECLARE brsmCur CURSOR FOR 
	SELECT studs.st_surname, sumHours.sumTime 
    FROM (SELECT activity.ref_st_id AS id, 
		SUM(activity.event_hours + activity.work_hours) AS sumTime
         FROM activity 
         GROUP BY activity.ref_st_id) AS sumHours
		      INNER JOIN studs ON studs.st_id = sumHours.id
              ORDER BY sumHours.sumTime LIMIT 5;
        

    OPEN bestCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs1: LOOP
				FETCH bestCur INTO best, avgMarkB;
                IF is_end THEN
					LEAVE curs1;
				END IF;
                INSERT INTO topBest VALUES(best, avgMarkB);
            END LOOP curs1;
		END;
    CLOSE bestCur;
    
    OPEN worstCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs2: LOOP
				FETCH worstCur INTO worst, avgMarkW;
                IF is_end THEN
					LEAVE curs2;
				END IF;
                INSERT INTO topWorst VALUES(worst, avgMarkW);
            END LOOP curs2;
		END;
    CLOSE worstCur;
    
     OPEN brsmCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs3: LOOP
				FETCH brsmCur INTO brsm, hours;
                IF is_end THEN
					LEAVE curs3;
				END IF;
                INSERT INTO topActive VALUES(brsm, hours);
            END LOOP curs3;
		END;
    CLOSE brsmCur;
    
	SELECT * FROM topBest;
	SELECT * FROM topWorst;
	SELECT * FROM topActive;
    
END\\
DELIMITER ;
    
CALL top5();

#3.5

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

CALL goodBuy();

#3.6
DELIMITER \\
CREATE FUNCTION popularMark(place VARCHAR(30))
RETURNS INT
BEGIN
	DECLARE popular, quantity INT;
    SELECT pair_mark, COUNT(pair_mark) AS top 
    INTO popular, quantity
    FROM semester_grades
    INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id 
    WHERE studs.st_speciality = place
	GROUP BY pair_mark ORDER BY top DESC
	LIMIT 1;
    RETURN popular;
END\\
DELIMITER ;

SELECT popularMark('эконом');

SELECT * FROM studs;
SELECT * FROM semester_grades where ref_st_id=6;


#3.7
 
DELIMITER \\
CREATE PROCEDURE howLong(IN grouppa VARCHAR(30))
BEGIN
	WITH 
	skippedPair AS (SELECT semester_grades.ref_st_id AS id,
	COUNT(semester_grades.pair_attendance) AS skipped FROM semester_grades
	INNER JOIN studs ON semester_grades.ref_st_id = studs.st_id
	WHERE semester_grades.pair_attendance = '1' AND studs.st_speciality = grouppa
	GROUP BY semester_grades.ref_st_id),
    allPair AS (SELECT semester_grades.ref_st_id AS id, 
    COUNT(semester_grades.pair_attendance) AS attend 
    FROM semester_grades
	INNER JOIN studs
	ON semester_grades.ref_st_id = studs.st_id
	WHERE studs.st_speciality = grouppa
	GROUP BY semester_grades.ref_st_id)
    SELECT studs.st_surname AS Surname, studs.st_name AS Name, 
		skippedPair.skipped AS 'Skipped pairs', allPair.attend AS 'All pairs',
        ((skippedPair.skipped/allPair.attend)*100) AS 'Percentage of visited pairs'
        FROM skippedPair
        INNER JOIN allPair ON skippedPair.id = allPair.id
        INNER JOIN studs ON allPair.id = studs.st_id
        GROUP BY Surname;
END\\ 
DELIMITER ;    

CALL howLong('км');

DROP PROCEDURE howLong;

#3.8
DELIMITER \\
CREATE PROCEDURE loyality()
BEGIN
	CREATE TEMPORARY TABLE loyal 
		SELECT finally.teacher AS Top , finally.avgMark 
		FROM (SELECT allMark.sub_teacher AS teacher, AVG(allMark.exam_mark) AS avgMark
		FROM (SELECT sub_teacher, exam_mark FROM exams 
		INNER JOIN subjects ON exams.ref_sub_id = subjects.sub_id) AS allMark
		GROUP BY teacher) AS finally WHERE finally.avgMark BETWEEN 7 AND 10
        ORDER BY finally.avgMark DESC;
	SELECT * FROM loyal;
	DROP TEMPORARY TABLE loyal;
	CREATE TEMPORARY TABLE unloyal 
		SELECT finally.teacher AS Bad, finally.avgMark 
		FROM (SELECT allMark.sub_teacher AS teacher, AVG(allMark.exam_mark) AS avgMark
		FROM (SELECT sub_teacher, exam_mark FROM exams 
		INNER JOIN subjects ON exams.ref_sub_id = subjects.sub_id) AS allMark
		GROUP BY teacher) AS finally WHERE finally.avgMark < 7
        ORDER BY finally.avgMark DESC;
	SELECT * FROM unloyal;
	DROP TEMPORARY TABLE unloyal;
END\\
DELIMITER ;

CALL loyality();

DROP procedure loyality;

#3.9

DELIMITER \\
CREATE PROCEDURE bonusBirthday(IN date1 DATE, date2 DATE)
BEGIN
 UPDATE studs
 SET st_value = st_value + ((TO_DAYS(NOW()) - TO_DAYS(st_birth))/1000)
 WHERE st_birth BETWEEN date1 AND date2;
END\\
DELIMITER ;

CALL bonusBirthday('2002/06/06', '2002/09/01');

SELECT * FROM studs;

#3.10

DELIMITER \\
CREATE PROCEDURE megabonusBirthday(IN birthDate DATE)
BEGIN 
UPDATE studs
 SET st_value = st_value + 3*((TO_DAYS(NOW()) - TO_DAYS(st_birth))/1000)
 WHERE st_birth = birthDate;
END \\
DELIMITER ;

CALL megabonusBirthday('2001-07-02');

SELECT * FROM studs;

#3.11

DELIMITER \\
CREATE PROCEDURE prediction(IN student_id INT, exam varchar(30))
BEGIN
	SELECT studs.st_surname, studs.st_name, (attendanceTable.main + loyality.ndex) AS prediction FROM studs,
	(
	SELECT subjects.sub_name as sub, ((((attendanceNotSkip /attendance)*100)/ 10)/ 2) AS main
	FROM 
	(
	SELECT semester_grades.ref_sub_id AS id, COUNT(semester_grades.pair_attendance) AS attendanceNotSkip FROM semester_grades
	INNER JOIN studs ON semester_grades.ref_st_id = studs.st_id WHERE pair_attendance = 0 AND st_id = student_id
	GROUP BY ref_sub_id) AS skippedPair
	INNER JOIN
	(SELECT ref_sub_id AS id, st_name AS name, st_surname AS surname, COUNT(pair_attendance) AS attendance from semester_grades
	INNER JOIN studs ON semester_grades.ref_st_id = studs.st_id WHERE st_id = student_id
	GROUP BY ref_sub_id, name, surname ) AS allPair
	ON skippedPair.id = allPair.id, subjects
	WHERE allPair.id = subjects.sub_id  AND subjects.sub_name=exam GROUP BY sub, main) AS attendanceTable,
    (SELECT sub_name, loyalty_index AS ndex FROM subjects INNER JOIN exams ON exams.ref_sub_id = subjects.sub_id WHERE sub_name = exam GROUP BY sub_name, ndex
    ) AS loyality
    WHERE studs.st_id = student_id;
END \\
DELIMITER ;

CALL prediction(1, 'бд');


SELECT * FROM studs;
SELECT * FROM semester_grades;

#4.1
######################################################################################################
#зачет должен ставиться в ручную преподом 
# триггер, првоеряет, если сданы все зачеты, то умножается текущая отмектка на 0.4, а экзамен на 0.6 и итог

CREATE TABLE zachetList
    SELECT studs.st_id AS ID, studs.st_surname AS Surname, 
    studs.st_name AS Name, averange.avgMark ,good.goodMarks, bad.badMarks
	FROM studs, (SELECT studs.st_id AS id, COUNT(semester_grades.pair_mark) AS goodMarks
    FROM semester_grades INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id
	WHERE semester_grades.pair_mark >= 4 
	GROUP BY studs.st_id) AS good,
    (SELECT studs.st_id AS id, COUNT(semester_grades.pair_mark) AS badMarks
    FROM semester_grades INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id
	WHERE semester_grades.pair_mark < 4  
	GROUP BY studs.st_id) AS bad,
	(SELECT studs.st_id AS id, AVG(semester_grades.pair_mark) AS avgMark
    FROM semester_grades INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id
	GROUP BY id) AS averange
    WHERE bad.id = studs.st_id OR good.id = studs.st_id OR averange.id = studs.st_id
    GROUP BY studs.st_id ORDER BY studs.st_id;

ALTER TABLE zachetList ADD COLUMN zachet_or_no BOOL;
DROP TABLE zachetList;  
    
DELIMITER \\ 
CREATE PROCEDURE isZachet (IN surn VARCHAR(50), zach BOOL)
BEGIN
	IF (zach != 1 AND zach != 0) THEN 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Please enter the correct zachet value';
	END IF;
	UPDATE zachetList 
    INNER JOIN studs ON studs.st_id = zachetList.ID
		SET zachetList.zachet_or_no = zach
	WHERE studs.st_surname = surn;
END\\
DELIMITER ;     

DROP procedure isZachet;
CALL isZachet('Кирилло', 1);
CALL isZachet('Яблонская', 0);
CALL isZachet('Карлович', 1);
CALL isZachet('Иванов', 1);

SELECT * FROM semester_grades;
   
SELECT * FROM zachetList;

drop table zachet;


ALTER TABLE exams ADD COLUMN exam_quan TINYINT UNSIGNED;
UPDATE exams SET exam_quan = 0;


DELIMITER \\
CREATE TRIGGER giveMoney AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	UPDATE studs,
    (SELECT studs.st_id AS id, AVG(0.6*(NEW.exam_mark) + 0.4*zachetList.avgMark) AS avgMark
	FROM exams
	INNER JOIN studs ON studs.st_id  = NEW.ref_st_id
    INNER JOIN zachetList ON zachetList.ID  = studs.st_id
    WHERE zachetList.zachet_or_no = 1
    GROUP BY id
    ) AS average 
    SET studs.st_value = CASE
						WHEN average.avgMark > 8 THEN 200
						WHEN average.avgMark BETWEEN 6 AND 8 THEN 160
						when average.avgMark BETWEEN 5 AND 5.99 THEN 120
						ELSE 0
						END 
    WHERE studs.st_id = average.id AND studs.st_form = 'бюджет' AND NEW.exam_quan = 4;
END\\
DELIMITER ;
# процедура, првоеряет, если сданы все зачеты, то умножается текущая отмектка на 0.4, а экзамен на 0.6 и итог 4.1 и 4.2
SELECT * FROM studs;
UPDATE studs SET course = 1;
DROP TRIGGER GIVEMONEY;
SELECT * FROM EXAMS;
INSERT INTO exams(ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession,exam_quan)
VALUES ('1', '1', '2021/01/18', 8, 'зимняя', 4); 

DELIMITER \\
CREATE TRIGGER exQuan AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	 IF NEW.exam_quan <= 0 OR NEW.exam_quan IS NULL 
		OR NEW.exam_quan > 5 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Please enter the correct ex quantity';
	END IF;
END\\
DELIMITER ;
DROP TRIGGER exQuan;
#4.2

DELIMITER \\
CREATE TRIGGER hahaMoney AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	UPDATE payment,
    (SELECT studs.st_id AS id, AVG(0.6*(NEW.exam_mark) + 0.4*zachetList.avgMark) AS avgMark
	FROM exams
	INNER JOIN studs ON studs.st_id  = NEW.ref_st_id
    INNER JOIN zachetList ON zachetList.ID  = studs.st_id
    WHERE zachetList.zachet_or_no = 1
    GROUP BY id
    ) AS average 
    SET payment.pay_money = CASE 
				WHEN average.avgMark >= 9 THEN payment.pay_money - 0.03*payment.pay_money
				WHEN average.avgMark BETWEEN 8 AND 8.99 THEN payment.pay_money - 0.02*payment.pay_money
				END
    WHERE payment.ref_st_id = average.id
    AND (payment.pay_money IS NULL OR payment.pay_money=0) AND NEW.exam_quan = 4;
END \\
DELIMITER ;

DROP TRIGGER hahaMoney;
INSERT INTO exams(ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession,exam_quan)
VALUES ('1', '6', '2021/01/18', 8, 'зимняя', 4); 
SELECT * FROM payment;



######################################################################################################
#4.3

DELIMITER \\
CREATE TRIGGER correctMark BEFORE INSERT ON exams
       FOR EACH ROW
       BEGIN
			IF (NEW.exam_mark < 0 OR NEW.exam_mark > 10) THEN
				SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT = 'Uncorrect input of exam mark';
			END IF;
       END\\
DELIMITER ;

INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2021/01/18', '8', 'зимняя'), 
('1', '2', '2021/01/18', '20', 'зимняя'); 

DELIMITER \\
CREATE TRIGGER gender AFTER INSERT ON studs
       FOR EACH ROW
       BEGIN
			IF (NEW.st_gender = 'boy') THEN
				UPDATE studs SET st_value= st_value + 10;
			END IF;
       END\\
DELIMITER ;

ALTER TABLE subjects
ADD COLUMN additionTasks BOOL;

DELIMITER \\
CREATE TRIGGER teacherHours BEFORE UPDATE ON subjects
       FOR EACH ROW
       BEGIN
			IF (NEW.additionTasks = 0 AND OLD.sub_name = 'бд') THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'Hahaha bro, nice try dude';
			END IF;
       END\\
DELIMITER ;

UPDATE subjects SET additionTasks = 0 WHERE sub_name = 'бд';
SELECT * FROM subjects;  

#4.4

ALTER TABLE studs
ADD COLUMN course TINYINT UNSIGNED;

SELECT * FROM studs;  

UPDATE studs SET course = 1;

DELIMITER \\
CREATE TRIGGER nextCourse AFTER INSERT ON exams
FOR EACH ROW
	BEGIN
		UPDATE studs, (SELECT studs.st_id AS id, 
        exams.exam_mark FROM studs INNER JOIN exams
		ON studs.st_id = exams.ref_st_id
		WHERE exams.exam_mark >=  4
		) AS marks,
		(SELECT ref_st_id AS id, exam_tsession FROM exams WHERE exam_tsession = 'летняя') AS isSummer
		SET studs.course = studs.course + 1
		WHERE studs.st_id = marks.id
		AND (studs.course < 4 AND studs.st_id = isSummer.id);
 END\\
DELIMITER ;
INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2022/01/18', '8', 'летняя');
SELECT * FROM studs;

UPDATE studs SET st_value = NULL WHERE st_form = 'платка';  

#4.5
ALTER TABLE studs
ADD COLUMN problem BOOL;
UPDATE studs SET problem = 0;
SELECT * FROM studs;

DROP TRIGGER problemStud;
DELIMITER \\
CREATE TRIGGER problemStud BEFORE INSERT ON exams
FOR EACH ROW
	BEGIN
	UPDATE studs,
    (SELECT skippedPair.id AS id
	FROM (SELECT semester_grades.ref_st_id AS id,
	COUNT(semester_grades.pair_attendance) AS skipped FROM semester_grades
	INNER JOIN studs ON semester_grades.ref_st_id = studs.st_id
	WHERE semester_grades.pair_attendance = '1'
	GROUP BY semester_grades.ref_st_id) as skippedPair
	INNER JOIN (SELECT semester_grades.ref_st_id AS id, 
    COUNT(semester_grades.pair_attendance) AS attend 
    FROM semester_grades
	INNER JOIN studs
	ON semester_grades.ref_st_id = studs.st_id
	GROUP BY semester_grades.ref_st_id) AS allPair
	ON skippedPair.id = allPair.id
	WHERE ((skippedPair.skipped/allPair.attend)*100) > 55
    ) AS pairAttendance,
    (SELECT health.ref_st_id AS id
	FROM health
	WHERE health.health_zachet = "-") AS bad
    SET studs.problem = 1
    WHERE studs.st_id = pairAttendance.id OR studs.st_id = bad.id;
 END\\
DELIMITER ;
SELECT * FROM health;
drop trigger problemStud;
INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2022/01/18', '8', 'летняя');

SELECT * FROM studs;
#4.6
DROP TRIGGER stopCourse;
DELIMITER \\
CREATE TRIGGER stopCourse AFTER INSERT ON exams
FOR EACH ROW
	BEGIN
	UPDATE studs, (SELECT health.ref_st_id AS id
	FROM health
	WHERE health.health_zachet = "-") AS bad
    SET studs.course = studs.course
    WHERE studs.st_id = bad.id;
END\\
DELIMITER ;
DROP trigger stopCourse;
INSERT INTO exams (ref_sub_id, ref_st_id, exam_date, exam_mark, exam_tsession)
VALUES
('1', '1', '2021/02/18', '8', 'летняя'), 
('1', '6', '2021/02/18', '8', 'летняя');

SELECT * FROM health;
SELECT * FROM studs;

#5

CREATE TABLE zachet
    SELECT studs.st_id AS ref_st_id, studs.st_surname AS surname, 
    studs.st_name AS name, good.goodMarks, bad.badMarks, 
    (CASE WHEN good.goodMarks > bad.badMarks THEN 1 ELSE 0 END) AS zachet_mark
	FROM studs, (SELECT studs.st_id AS id, COUNT(semester_grades.pair_mark) AS goodMarks
    FROM semester_grades INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id
	WHERE semester_grades.pair_mark >= 4 
	GROUP BY studs.st_id) AS good,
    (SELECT studs.st_id AS id, COUNT(semester_grades.pair_mark) AS badMarks
    FROM semester_grades INNER JOIN studs ON studs.st_id = semester_grades.ref_st_id
	WHERE semester_grades.pair_mark < 4  
	GROUP BY studs.st_id) AS bad
    WHERE bad.id = studs.st_id OR good.id = studs.st_id
    GROUP BY studs.st_id ORDER BY studs.st_id;
    
SELECT * FROM zachet;
#зачет должен ставиться в ручную преподом 
drop table zachet;

DELIMITER \\
CREATE PROCEDURE examination()
BEGIN

	DECLARE Surn, Nam, desicion VARCHAR(50);
	DECLARE zachMark BOOL;
	DECLARE exMark TINYINT UNSIGNED;
	

	DECLARE zachetCur CURSOR FOR 
	SELECT zachet.surname, zachet.name, zachet.zachet_mark
    FROM zachet;
    
    DECLARE examCur CURSOR FOR
    SELECT studs.st_id, studs.st_surname, studs.st_name, ban.badMarks
	FROM studs, (SELECT studs.st_id AS id, COUNT(exams.exam_mark) AS badMarks
    FROM exams INNER JOIN studs ON studs.st_id = exams.ref_st_id
	WHERE exams.exam_mark < 4 
	GROUP BY studs.st_id
	HAVING badMarks > 1) AS ban;
    #WHERE ban.id = studs.st_id;
    CREATE TEMPORARY TABLE steps (
		id INT,
        surname VARCHAR(30),
        name VARCHAR(30),
        outcome VARCHAR(30)
    );
    
     OPEN zachetCur;
		BEGIN
        DECLARE is_end INT DEFAULT 0;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs1: LOOP
				FETCH zachetCur INTO Surn, Nam, zachMark;
                IF is_end THEN
					LEAVE curs1;
				END IF;
                IF zachMark = 1 THEN 
					INSERT INTO steps VALUES(Surn, Nam, 'zachet sdan!');
				ELSE INSERT INTO steps VALUES(Surn, Nam, 'zachet NE sdan!');
                END IF;    
            END LOOP curs1;
		END;
    CLOSE zachetCur; 
    
     OPEN examCur;
		BEGIN
        DECLARE is_end INT DEFAULT 0;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs2: LOOP
				FETCH examCur INTO Surn, Nam, exMark;
                IF is_end THEN
					LEAVE curs2;
				END IF;
                IF exMark = 0 THEN 
					INSERT INTO steps VALUES(Surn, Nam, 'examen sdan!');
				ELSEIF exMark BETWEEN 1 AND 2 THEN INSERT INTO steps VALUES(Surn, Nam, 'exameny NE sdany! Go to the perezdacha');
				ELSE INSERT INTO steps VALUES(Surn, Nam, 'exameny NE sdany! Otchislen');
                END IF;    
            END LOOP curs2;
		END;
    CLOSE examCur; 
    
    SELECT * FROM steps;
	DROP TEMPORARY TABLE steps;
END\\
DELIMITER ;

	DROP TEMPORARY TABLE steps;
DROP procedure examination;

CALL examination();






DELIMITER \\
CREATE PROCEDURE top5()
BEGIN 
	DECLARE best, worst, brsm VARCHAR(50);
    DECLARE avgMarkB, avgMarkW, hours DOUBLE;
    DECLARE is_end INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;

	DECLARE bestCur CURSOR FOR 
	SELECT studs.st_surname, marks.avgmark
	FROM (SELECT exams.ref_st_id AS id, avg(exam_mark) AS avgMark 
		FROM exams 
        GROUP BY exams.ref_st_id) AS marks
	INNER JOIN studs ON studs.st_id = marks.id
	ORDER BY marks.avgMark DESC LIMIT 5;
	
	DECLARE worstCur CURSOR FOR 
	SELECT studs.st_surname, marks.avgmark
	FROM (SELECT exams.ref_st_id AS id, AVG(exams.exam_mark) AS avgMark 
		FROM exams 
        GROUP BY exams.ref_st_id) AS marks
	INNER JOIN studs ON studs.st_id = marks.id
	ORDER BY marks.avgMark LIMIT 5;
		
	DECLARE brsmCur CURSOR FOR 
	SELECT studs.st_surname, sumHours.sumTime 
    FROM (SELECT activity.ref_st_id AS id, 
		SUM(activity.event_hours + activity.work_hours) AS sumTime
         FROM activity 
         GROUP BY activity.ref_st_id) AS sumHours
		      INNER JOIN studs ON studs.st_id = sumHours.id
              ORDER BY sumHours.sumTime LIMIT 5;
        

    OPEN bestCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs1: LOOP
				FETCH bestCur INTO best, avgMarkB;
                IF is_end THEN
					LEAVE curs1;
				END IF;
                INSERT INTO topBest VALUES(best, avgMarkB);
            END LOOP curs1;
		END;
    CLOSE bestCur;
    
    OPEN worstCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs2: LOOP
				FETCH worstCur INTO worst, avgMarkW;
                IF is_end THEN
					LEAVE curs2;
				END IF;
                INSERT INTO topWorst VALUES(worst, avgMarkW);
            END LOOP curs2;
		END;
    CLOSE worstCur;
    
     OPEN brsmCur;
		BEGIN
			DECLARE is_end INT DEFAULT 0;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
			curs3: LOOP
				FETCH brsmCur INTO brsm, hours;
                IF is_end THEN
					LEAVE curs3;
				END IF;
                INSERT INTO topActive VALUES(brsm, hours);
            END LOOP curs3;
		END;
    CLOSE brsmCur;
    
	SELECT * FROM topBest;
	SELECT * FROM topWorst;
	SELECT * FROM topActive;
    
END\\
DELIMITER ;

