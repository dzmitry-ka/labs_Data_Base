CREATE DATABASE newStrikeMTW;
USE newStrikeMTW;
CREATE TABLE contracts(
contract_id INT PRIMARY KEY,
contract_position CHAR(50) NOT NULL,
contract_salary FLOAT NOT NULL,
contract_start_date DATE NOT NULL,
contract_end_date DATE
);
SELECT * FROM contracts;
CREATE TABLE staff_MTW(
staff_id INT PRIMARY KEY AUTO_INCREMENT,
staff_surname VARCHAR(30) NOT NULL,
staff_name VARCHAR(30) NOT NULL,
staff_protest BOOLEAN NOT NULL,
staff_protest_date_start DATETIME DEFAULT CURRENT_TIMESTAMP,
staff_protest_date_end DATE,
CONSTRAINT cn1 FOREIGN KEY (staff_id) REFERENCES contracts(contract_id)
);  
alter table staff_MTW add constraint cn1 foreign key (staff_id) REFERENCES contracts(contract_id);
select* from staff_MTW;
select* from leadership_protest;
CREATE TABLE leadership_protest(
leadership_id INT PRIMARY KEY,
leadership_position VARCHAR(50) NOT NULL,
leadership_date_start DATETIME DEFAULT CURRENT_TIMESTAMP,
leadership_date_end DATE,
CONSTRAINT cn2 FOREIGN KEY (leadership_id) REFERENCES staff_MTW(staff_id)
); 
SELECT * FROM staff_MTW;
SELECT * FROM leadership_protest;
CREATE TABLE protests(
protest_date DATE PRIMARY KEY,
protest_number MEDIUMINT UNSIGNED,
protest_type MEDIUMTEXT NOT NULL,
protest_place VARCHAR(45),
protest_demand TINYTEXT,
protest_time TIME
);
CREATE TABLE detention(
detention_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
detention_codex ENUM('criminal', 'administrative') NOT NULL,
detention_part VARCHAR(8) NOT NULL,
detention_designed VARCHAR(30) NOT NULL,
detention_fine DOUBLE,
detention_date_start TIMESTAMP(6) NOT NULL,
detention_date_end DATETIME
); 
CREATE TABLE press(
press_name VARCHAR(50) PRIMARY KEY NOT NULL,
press_type ENUM('TV', 'Internet','Newspaper','General') NOT NULL,
press_registration DATE NOT NULL,
press_base YEAR NOT NULL
);
ALTER TABLE press CHANGE press_registration press_registration_date DATE; 
ALTER TABLE press ADD COLUMN press_registration BOOLEAN AFTER press_type;
ALTER TABLE press CHANGE press_registration press_registration BOOLEAN NOT NULL; 
CREATE TABLE goverment(
goverment_id MEDIUMINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
goverment_surname VARCHAR(30) NOT NULL,
goverment_name VARCHAR(30) NOT NULL,
goverment_position VARCHAR(30) NOT NULL
);
CREATE TABLE staff_detention(
ref_staff_id INT NOT NULL,
ref_detention_id INT NOT NULL,
CONSTRAINT cn3 FOREIGN KEY (ref_staff_id) REFERENCES staff_MTW(staff_id),
CONSTRAINT cn4 FOREIGN KEY (ref_detention_id) REFERENCES detention(detention_id)
);
CREATE TABLE staff_protests(
ref_staff_id INT NOT NULL,
ref_protest_date DATE NOT NULL,
CONSTRAINT cn5 FOREIGN KEY (ref_staff_id) REFERENCES staff_MTW(staff_id),
CONSTRAINT cn6 FOREIGN KEY (ref_protest_date) REFERENCES protests(protest_date)
);
CREATE TABLE protest_press(
ref_press_name VARCHAR(50) NOT NULL,
ref_protest_date DATE NOT NULL,
press_correspondent VARCHAR(30),
CONSTRAINT cn7 FOREIGN KEY (ref_press_name) REFERENCES press(press_name),
CONSTRAINT cn8 FOREIGN KEY (ref_protest_date) REFERENCES protests(protest_date)
);
CREATE TABLE goverment_protests(
ref_goverment_id MEDIUMINT NOT NULL,
ref_protest_date DATE NOT NULL,
goverment_protests_reaction TEXT,
CONSTRAINT cn9 FOREIGN KEY (ref_goverment_id) REFERENCES goverment(goverment_id),
CONSTRAINT cn10 FOREIGN KEY (ref_protest_date) REFERENCES protests(protest_date)
);          
INSERT INTO contracts() VALUES (1,'уборщик',456.97,'2009-10-2', NULL),
								(2,'слесарь',1000,'2015-02-01','2020-08-13'),
								(3,'сборщик трактора', 977.22, '2020-04-15', NULL), 
                                (4,'чертёжник',1001.99,'1994-08-30', NULL),
                                (5,'сортировка гаек',10000,'2000-01-01',NULL);
select * from detention;                                
INSERT INTO staff_MTW(staff_surname,staff_name,staff_protest,staff_protest_date_start,staff_protest_date_end)
		VALUES ('Дылевский','Сергей',1,'2020-08-10',NULL), 
			('Яблонская','Анна',1,'2020-08-10','2020-08-13'), 
			('Ябатькo','Жэншчына',0,NULL,NULL), 
            ('Кушнеров','Александр',1,'2020-08-11',NULL),
            ('Карлович','Алексей',1,'2020-08-12', NULL);
INSERT INTO leadership_protest(leadership_id,leadership_position,leadership_date_start,leadership_date_end)
	VALUES (1,'Руководитель','2020-8-10',NULL), (2,'Заместитель руководителя','2020-08-10','2020-08-13');
            
INSERT INTO detention(detention_codex, detention_part, detention_designed, detention_fine, detention_date_start, detention_date_end)
			VALUES ('criminal', '238.1 ', 'Милевский', NULL, '2020-08-10', NULL), 
					('criminal', '235.3', 'Ягайло', NULL, '2020-08-10', NULL),
					('administrative', '23.35', 'Придыбатько', 2018.42, '2020-08-14', '2020-08-17'), 
                    ('administrative', '31.2', 'Данцевич', 923.68, '2020-08-16', NULL); 
INSERT INTO staff_detention(ref_staff_id, ref_detention_id) VALUES (1, 5), (5,6), (4, 7), (1,8);
INSERT INTO protests(protest_date, protest_number, protest_type, protest_place, protest_demand, protest_time) 
						VALUES ('2020-08-10', 4000, 'Акция протеста','Внутренний двор','Честные выборы','12:00:00'), 
								('2020-08-11',6400, 'Акция протеста', 'Главный вход','Прекращение избиения граждан','12:00:00'),
								('2020-08-12',1994, 'Итальянская забастовка', NULL,'Хочу новые лапти', '4:00:00'), 
								('2020-08-14',950, 'Белорусская забастовка', 'Внутри цехов', NULL, '8:30:00');               
INSERT INTO staff_protests (ref_staff_id, ref_protest_date) VALUES (1, '2020-08-10'), (2, '2020-08-10'),
							(2, '2020-08-11'), (5, '2020-08-12'), (4, '2020-08-14');
INSERT INTO press() VALUES ('Радыё Свабода','General', 1, '2014-02-26', '1949'),
							('Наша Нiва','Newspaper', 1, '2018-12-01', '1906'),
							('NEXTA','Internet', 0, NULL, '2018'),
							('Russia Today','TV', 1, '2020-06-10', '2004');           
INSERT INTO protest_press(ref_press_name, ref_protest_date, press_correspondent) VALUES 
					('Радыё Свабода', '2020-08-10', 'Дерябин'), ('Russia Today', '2020-08-10', 'Симоньян'), 
					('NEXTA','2020-08-10', 'Путило'),
                    ('Наша Нiва','2020-08-11', 'Кулешевская');           
INSERT INTO goverment(goverment_surname,goverment_name,goverment_position) VALUES ('Лукашенко','Александр','Президент'),
								('Качанова','Наталья','Председатель Совета Республик'),
                                ('Ермошина','Лидия','Председатель ЦИК'),
                                ('Латушко','Павел','Дипломат');               
INSERT INTO goverment_protests() VALUES (1,'2020-08-10', 'Это все овцы, наркоманы и проститутки'),
										(3,'2020-08-10', 'Сидите дома и варите борщи'),
                                        (4, '2020-08-10', 'Я с народом!'),
                                        (1,'2020-08-11', 'Это все американцы и чешские кукловоды!'),
                                        (2,'2020-08-11', '#ЗаБатьку'),
                                        (3,'2020-08-12', NULL),
                                        (4,'2020-08-14', 'Я вступаю в Координационный Совет!');
                    