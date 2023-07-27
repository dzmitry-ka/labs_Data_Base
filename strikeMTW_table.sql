CREATE DATABASE strikeMTW;
USE strikeMTW;
CREATE TABLE staff_MTW(
staff_id INT PRIMARY KEY,
staff_surname VARCHAR(30) NOT NULL,
staff_name VARCHAR(30) NOT NULL,
staff_position VARCHAR(50) NOT NULL,
staff_date_start DATETIME NOT NULL,
staff_date_end DATETIME
); 
SELECT * FROM press;
ALTER TABLE staff_MTW
ADD COLUMN staff_sallary DOUBLE AFTER staff_position;
ALTER TABLE leadership_protest ADD COLUMN leadership_demand TINYTEXT;
ALTER TABLE detention ADD COLUMN detention_fine FLOAT;
ALTER TABLE press ADD COLUMN press_base YEAR;
ALTER TABLE protests CHANGE protest_type protest_type MEDIUMTEXT;    
ALTER TABLE rada_vision CHANGE rada_name rada_name CHAR(50);
CREATE TABLE collective_protest(
collective_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
collective_demand TEXT,
collective_date_start DATETIME NOT NULL,
collective_date_end DATETIME,
CONSTRAINT cn1 FOREIGN KEY (collective_id) REFERENCES staff_MTW(staff_id)
); 
CREATE TABLE leadership_protest(
leadership_id INT PRIMARY KEY,
leadership_position VARCHAR(50) NOT NULL,
leadership_date_start DATETIME NOT NULL,
leadership_date_end DATETIME,
CONSTRAINT cn2 FOREIGN KEY (leadership_id) REFERENCES staff_MTW(staff_id)
); 
CREATE TABLE rada_vision(
rada_id INT PRIMARY KEY,
rada_surname VARCHAR(30) NOT NULL,
rada_name VARCHAR(30) NOT NULL,
rada_composition ENUM('presidium', 'main') NOT NULL,
rada_position VARCHAR(50) NOT NULL,
rada_date_start TIMESTAMP(6) NOT NULL,
rada_date_end DATETIME,
rada_detention ENUM('+', '-') NOT NULL,
rada_conference DATETIME NOT NULL
); 
CREATE TABLE protests(
protest_date DATETIME PRIMARY KEY,
protest_number INT,
protest_type VARCHAR(50) NOT NULL,
protest_place VARCHAR(45),
protest_time TIME
);
CREATE TABLE press(
press_name VARCHAR(50) PRIMARY KEY NOT NULL,
press_correspondent VARCHAR(30) NOT NULL,
press_data DATETIME NOT NULL
);
CREATE TABLE detention(
detention_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
detention_codex ENUM('criminal', 'administrative') NOT NULL,
detention_part VARCHAR(8) NOT NULL,
detention_designed VARCHAR(30) NOT NULL,
detention_date_start TIMESTAMP(6) NOT NULL,
detention_date_end DATETIME
); 
select * from detention;
CREATE TABLE collective_detention(
ref_collective_id INT NOT NULL,
ref_detention_id INT NOT NULL,
CONSTRAINT cn3 FOREIGN KEY (ref_collective_id) REFERENCES collective_protest(collective_id),
CONSTRAINT cn4 FOREIGN KEY (ref_detention_id) REFERENCES detention(detention_id)
);
CREATE TABLE rada_detention(
ref_rada_id INT NOT NULL,
ref_detention_id INT NOT NULL,
CONSTRAINT cn5 FOREIGN KEY (ref_rada_id) REFERENCES rada_vision(rada_id),
CONSTRAINT cn6 FOREIGN KEY (ref_detention_id) REFERENCES detention(detention_id)
);
CREATE TABLE rada_collective(
ref_collective_id INT NOT NULL,
ref_rada_id INT NOT NULL,
CONSTRAINT cn7 FOREIGN KEY (ref_collective_id) REFERENCES collective_protest(collective_id),
CONSTRAINT cn8 FOREIGN KEY (ref_rada_id) REFERENCES rada_vision(rada_id)
);
CREATE TABLE rada_press(
ref_press_name VARCHAR(30) NOT NULL,
ref_rada_id INT NOT NULL,
rada_conference DATETIME,
press_correspondent VARCHAR(30),
CONSTRAINT cn9 FOREIGN KEY (ref_press_name) REFERENCES press(press_name),
CONSTRAINT cn10 FOREIGN KEY (ref_rada_id) REFERENCES rada_vision(rada_id)
);
CREATE TABLE protests_collective(
ref_collective_id INT NOT NULL,
ref_protest_date DATETIME NOT NULL,
CONSTRAINT cn12 FOREIGN KEY (ref_collective_id) REFERENCES collective_protest(collective_id),
CONSTRAINT cn13 FOREIGN KEY (ref_protest_date) REFERENCES protests(protest_date)
);

CREATE TABLE protest_press(
ref_press_name VARCHAR(30) NOT NULL,
ref_collective_id INT NOT NULL,
ref_protest_date DATETIME NOT NULL,
press_correspondent VARCHAR(30),
CONSTRAINT cn14 FOREIGN KEY (ref_press_name) REFERENCES press(press_name),
CONSTRAINT cn15 FOREIGN KEY (ref_collective_id) REFERENCES collective_protest(collective_id),
CONSTRAINT cn16 FOREIGN KEY (ref_protest_date) REFERENCES protests(protest_date)
);

INSERT INTO staff_MTW(staff_id,staff_surname,staff_name,staff_position,staff_date_start,staff_date_end)
	VALUES (123132,'Дылевский','Сергей','конструкторсчик','2009-10-2',NULL), (1111,'Пучков','Даниил','охранник','2015-02-01','2020-08-13'), 
			(99999,'Ябатька','Жэншчына','уборщица','1994-08-30',NULL), (424324,'Кушнеров','Александр','сборщик трактора','2020-04-15',NULL),
            (23233,'Карлович','Алексей','чертёжник','2019-09-01', NULL), (77777,'Путин','Вованыч', 'сортировка гаек','2000-01-01',NULL); 

INSERT INTO leadership_protest(leadership_id,leadership_position,leadership_date_start,leadership_date_end)
	VALUES (123132,'Руководитель','2020-8-10',NULL), (1111,'Заместитель руководителя','2020-08-10','2020-08-13');

    
INSERT INTO collective_protest(collective_id,collective_demand,collective_date_start, collective_date_end)
	VALUES (123132,'Отставка правительства и Лидки Гармошкиной','2020-08-10',NULL), (1111,'Честные выборы','2020-08-10','2020-08-13'), 
			 (424324,'Прекращение избиения граждан','2020-08-11',NULL),
            (23233,'Честные выборы и отставка правительства','2020-08-10', NULL), (77777,'Хочу новые лапти','2020-08-10','2020-08-10'); 

ALTER TABLE rada_vision DROP rada_conference;

INSERT INTO rada_vision(rada_id,rada_surname, rada_name, rada_composition, rada_position, rada_date_start, rada_date_end, rada_detention)
	VALUES (1,'Латушко','Павел','presidium','Руководитель','2020-08-12', NULL, '-'),
    (2,'Дылевский','Сергей','presidium','Руководитель стачкомов','2020-08-12', NULL, '+'),
    (3,'Колесникова','Мария','presidium','Заместитель руководителя','2020-08-12', NULL, '+'),
    (4,'Алексиевич','Светлана','presidium','Просветительница','2020-08-14', NULL, '-'),
    (5,'Пучков','Даниил','main','Представитель','2020-08-12', '2020-08-14', '+'),
    (6,'Кушнеров','Александр','main','Представитель','2020-08-14', NULL, '-');
    
    
INSERT INTO press(press_name,press_accreditation) VALUES ('Радыё Свабода','+'),('Наша Нiва','+'),
														('NEXTA','-'),('Russia Today','+');
												
INSERT INTO protests(protest_date, protest_number, protest_type, protest_place, protest_time) 
		VALUES ('2020-08-10',4000, 'Акция протеста','Внутренний двор', '12:00:00'), 
				('2020-08-11',6400, 'Акция протеста', 'Главный вход', '12:00:00'),
				('2020-08-12',1994, 'Итальянская забастовка', NULL, '4:00:00'), 
                ('2020-08-14',950, 'Забастовка', 'Внутри цехов', '8:30:00');
			
ALTER TABLE detention CHANGE detention_part detention_part VARCHAR(50) NOT NULL;

INSERT INTO detention(detention_codex, detention_part, detention_designed, detention_date_start, detention_date_end)
			VALUES ('criminal', '238.1, 240.2 ', 'Милевский', '2020-08-10', NULL), 
					('criminal', '235.3', 'Ягайло', '2020-08-10', NULL),
					('administrative', '23.35, 26.49', 'Придыбатько', '2020-08-14', '2020-08-17'), 
                    ('administrative', '31.2', 'Данцевич', '2020-08-16', NULL); 
INSERT INTO detention(detention_codex, detention_part, detention_designed, detention_date_end)
			VALUE ('administrative', '23.35, 26.49', 'Милевский', NULL);
select * from detention;                    
                   
INSERT INTO collective_detention (ref_collective_id, ref_detention_id) VALUES (23233, 1), (1111, 3);
INSERT INTO rada_detention (ref_rada_id, ref_detention_id) VALUES (2, 2), (3, 4);


INSERT INTO rada_press (ref_press_name, ref_rada_id, rada_conference,press_correspondent) VALUES 
					('Радыё Свабода', 1, '2020-08-10', 'Дерябин'), ('Russia Today', 3, '2020-08-10', 'Симоньян'), 
                    ('Наша Нiва', 4, '2020-08-11', 'Кулешевская');
                    

INSERT INTO rada_collective (ref_collective_id, ref_rada_id) VALUES (123132, 2), (424324, 6);


  
INSERT INTO protests_collective (ref_collective_id, ref_protest_date) VALUES (123132, '2020-08-10'), (424324, '2020-08-10'),
							(424324, '2020-08-11'), (424324, '2020-08-12'), (77777, '2020-08-14');
                 						

select * from protest_press;

INSERT INTO protest_press (ref_press_name, ref_collective_id, ref_protest_date,press_correspondent) VALUES 
					('Радыё Свабода', 23233, '2020-08-10', 'Дерябин'), ('Russia Today', 1111, '2020-08-10', 'Симоньян'), 
					('NEXTA', 123132, '2020-08-10', 'Симоньян'),
                    ('Наша Нiва', 1111, '2020-08-11', 'Кулешевская');
 ALTER TABLE detention CHANGE detention_date_start detention_date_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP;                  
                    
SHOW TABLES;                    