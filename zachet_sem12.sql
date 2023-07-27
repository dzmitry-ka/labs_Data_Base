create database zachet_sem12;
use zachet_sem12;


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



drop table semester_grades;
CREATE TABLE semester_grades(
ref_st_id INT, 
pair_date DATETIME, 
pair_attendance BOOL, 
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

SELECT * FROM semester_grades where pair_attendance = 1;
select * from deleteStudent;



CREATE TABLE deleteStudent(
ref_st_id INT,
ref_date DATE,
CONSTRAINT cn4 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);

############################################################################################
SET GLOBAL log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
SET foreign_key_checks=0;
############################################################################################

drop function quanPropusk;
delimiter //
create function quanPropusk(id int)
returns int
begin
  declare propuski int;
  select tb.c into propuski from (select COUNT(semester_grades.pair_attendance) as c, semester_grades.ref_st_id from semester_grades
	inner join studs on studs.st_id = semester_grades.ref_st_id
  WHERE  semester_grades.ref_st_id = id and semester_grades.pair_attendance = 1
    AND ((dayofweek(semester_grades.pair_date)-1) = 2 OR (dayofweek(semester_grades.pair_date)-1) = 4)
    GROUP BY semester_grades.ref_st_id) as tb;
  return propuski;
end//
delimiter ;

drop table deleteStudent;
select * from semester_grades where pair_attendance=1;
select * from deleteStudent;
select * from studs;

drop trigger checkPropusk;
DELIMITER \\
CREATE TRIGGER checkPropusk AFTER INSERT ON semester_grades
FOR EACH ROW
BEGIN
	DECLARE id,is_end INT;
	DECLARE propuski INT;
	DECLARE studcur CURSOR FOR SELECT new.ref_st_id;    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
    IF (SELECT ref_st_id FROM deleteStudent WHERE ref_st_id=new.ref_st_id) IS  NULL THEN
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
    END IF;
END\\
DELIMITER ;




CREATE TABLE exams(
exam_id INT PRIMARY KEY AUTO_INCREMENT,
ref_sub_id INT, 
ref_st_id INT, 
exam_date DATETIME, 
exam_mark INT, 
exam_tsession ENUM('зимняя','летняя'),
CONSTRAINT cn111 FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id), 
CONSTRAINT cn222 FOREIGN KEY (ref_st_id) REFERENCES studs(st_id)
);


CREATE TABLE subjects
(
sub_id INT PRIMARY KEY AUTO_INCREMENT, 
sub_name VARCHAR(50) NOT NULL, 
sub_teacher VARCHAR(30) NOT NULL, 
sub_hours INT
);



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
('6', '6', '2021/06/16', '10', 'летняя');


INSERT INTO subjects
(sub_name, sub_teacher, sub_hours)
VALUES
('бд', 'Кушнеров', 30), 
('км', 'Голубева', 25), 
('прога', 'Нагорный', 60), 
('геометрия', 'Базылев', 70),
('пса', 'Атрохов', 40), 
('матан', 'Бровка', 80);


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
