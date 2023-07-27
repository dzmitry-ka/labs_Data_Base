CREATE DATABASE LAB05_4_5;
USE LAB05_4_5;

CREATE TABLE morgensternQuotes(
morg_quotes TEXT
);

# 4.1

INSERT INTO morgensternQuotes VALUES
('Я не хочу. А на *** надо?'),
('Бывало, я сидел на наркотиках, ***ец, торчал жестко, как в не себя ***рил.'),
('В один момент я понимаю, что эти две девочки берут мои руки и начинают сосать мне пальцы'),
('Соси мою жопу, эй!'),
('Я ножку вчера на концерте натер и больно ходить.'),
('Я так много врал, что забыл где правда.'),
('Женщина – это человек. Феминистка – это уже другое дело'),
('Мои фанатки клево целуются. Мы спрашиваем паспорт на сцене перед тем, как поцеловаться'),
('Э-э-эй, Primero c огромным хером. У меня проблема - Lambo или Ferra?'),
('Я — молодой босс, ты — тупо мышь (мышь)'),
('Эй, цепь на мне, сыпь лавэ.Сотка тыщ на bag LV'),
('Сотни сук хотят ко мне'),
('Делать деньги, блять, вот так '),
('Эй, посмотри. Два мульта на мне — часы. Три на шее, семь под жопой.Мне чуть больше двадцати.Посмотри, посмотри.Два мульта на мне — часы.Три на шее, семь под жопой. Мне чуть больше двадцати'),
('I am busy, мне похуй на кризис, я в нём вырос (уа-уа-уа)'),
('Этот фит убьёт быстрей, чем ко-ро-на-ви-рус'),
('Эти цепи на мне, эту суку так манит'),
('Заберу всё, будто бы я татарин'),
('Ныне мою жопу возит новый Мерин'),
('Я блогер: подпишись на канал '),
('Эй, у тебя горит, парень, не ори'),
('То, что мы называем жизнью, – обычно всего ЛИШЬ список дел на сегодня'),
('Жизнь большинства людей не столько сложна, сколько запутанна'),
('Измени свои мысли, и ты изменишь свой мир '),
('Иногда неправильные решения приводят нас в правильные места '),
('Быть хорошим не достаточно. Ты должен быть великим'),
('Жизнь как езда на велосипеде. Чтобы сохранить равновесие, вы должны продолжать двигаться'),
('Те, кто осознает свою глупость, не настоящие дураки'),
('Жизнь слишком важна, чтобы воспринимать ее серьезно'),
('Это всегда выглядит невозможным, пока не сделаешь'),
('Держите свои глаза на звездах, а ноги на земле'),
('Лучше быть львом в течение дня, чем овцой всю жизнь'),
('Умение жить – самая редкая вещь в мире. Большинство людей просто существует '),
('Да, сука, новый автомат'),
('Всё красиво, когда у папы ксива'),
('Бабки, связи, тёлки, корпоративы'),
('Много людей живет не живя, но только собираясь жить'),
('Папа да АК — то, как мы валим на битах'),
('Я гоню быстро, не подъедешь близко'),
('Капитаны любят бабки'),
('Моя жизнь – мое сообщение '),
('Не как долго, а как хорошо вы жили – это главное'),
('Я люблю тех, кто может улыбаться в беде '),
('Жизнь – это искусство '),
('Будьте счастливы в этот момент. Этот момент – и есть ваша жизнь'),
('Жизнь – это то, что происходит, когда вы заняты составлением других планов'),
('Пусть уж меня ненавидят за то, что я есть, чем любят за то, чем я не являюсь'),
('Очень мало нужно для счастливой жизни; все находится внутри вас, в вашем образе мышления'),
('Лучше быть ненавидимым за то, что ты есть, чем быть любимым за то, кем ты не являешься'),
('Ты любишь жизнь? Тогда не теряйте время, потому что это то, из чего состоит жизнь'),
('Вы получаете от жизни то, о чем находите мужество спросить');


# 4.2

SELECT * FROM morgensternQuotes WHERE morg_quotes LIKE 'Бабки%' ;

CREATE FULLTEXT INDEX indMorgensternQuotes ON morgensternQuotes(morg_quotes);

ALTER TABLE morgensternQuotes DROP INDEX indMorgensternQuotes;

SELECT * FROM morgensternQuotes WHERE MATCH(morg_quotes) AGAINST ('кризис');

SELECT * FROM morgensternQuotes WHERE MATCH(morg_quotes) AGAINST ('Делать деньги' IN BOOLEAN MODE);

SELECT * FROM morgensternQuotes WHERE MATCH(morg_quotes) AGAINST ('жизнь -это' IN BOOLEAN MODE);

# 4.3
SELECT morg_quotes, MATCH(morg_quotes) AGAINST('блогер')
FROM morgensternQuotes
WHERE MATCH(morg_quotes) AGAINST ('блогер');

SELECT morg_quotes, MATCH(morg_quotes) AGAINST('Папа')
FROM morgensternQuotes
WHERE MATCH(morg_quotes) AGAINST ('Папа');

#Эта величина зависит прежде всего от количества слов в поле quo_text, того насколько близко данное слово встречается к началу текста, 
#отношения количества встретившихся слов к количеству всех слов в поле и др

#natural language mode with query expansion - ищем релевантные строки, затем слова из этих строк добавляются к исходному слову
# и проводится поиск снова

SELECT * FROM morgensternQuotes
WHERE MATCH (morg_quotes)
AGAINST ('блогер' IN NATURAL LANGUAGE MODE WITH QUERY Expansion);

#5
#оба движка поддерживают полнотекстный поиск (в InnoDB с MySQL 5.6.4)
#a.1
CREATE TABLE testMyISAM(
	test_id INT PRIMARY KEY AUTO_INCREMENT,
    test_text VARCHAR(500)
)ENGINE=MyISAM;

#insert быстрее в myisam
INSERT testMyISAM(test_text) VALUES
('Пусть уж меня ненавидят за то, что я есть, чем любят за то, чем я не являюсь'),
('Очень мало нужно для счастливой жизни; все находится внутри вас, в вашем образе мышления'),
('Лучше быть ненавидимым за то, что ты есть, чем быть любимым за то, кем ты не являешься'),
('Ты любишь жизнь? Тогда не теряйте время, потому что это то, из чего состоит жизнь'),
('Вы получаете от жизни то, о чем находите мужество спросить');

CREATE FULLTEXT INDEX indTest ON testMyISAM(test_text);

#селект работает быстрее в myisam
SELECT * FROM testMyISAM WHERE MATCH (test_text) AGAINST ('любишь' IN BOOLEAN MODE);


CREATE TABLE testInnoDB(
	test_id INT PRIMARY KEY AUTO_INCREMENT,
    test_text VARCHAR(500)
)ENGINE=InnoDB;

INSERT INTO testInnoDB(test_text) VALUES
('Пусть уж меня ненавидят за то, что я есть, чем любят за то, чем я не являюсь'),
('Очень мало нужно для счастливой жизни; все находится внутри вас, в вашем образе мышления'),
('Лучше быть ненавидимым за то, что ты есть, чем быть любимым за то, кем ты не являешься'),
('Ты любишь жизнь? Тогда не теряйте время, потому что это то, из чего состоит жизнь'),
('Вы получаете от жизни то, о чем находите мужество спросить');

CREATE FULLTEXT INDEX indTest1 ON testInnoDB(test_text);

SELECT * FROM testInnoDB WHERE MATCH(test_text) AGAINST ('любишь' IN BOOLEAN MODE);


#myISAM не поддерживает транзакции и выдаёт предупреждение, не может сделать rollback

CREATE TABLE test1(
  i INT
)ENGINE = MyISAM;

DELIMITER \\
CREATE PROCEDURE proc1()
BEGIN
  START TRANSACTION;
  INSERT INTO test1 VALUE(1);
  ROLLBACK;
END\\
DELIMITER ;

CALL proc1();

SHOW WARNINGS;

SELECT * FROM test1;

DROP TABLE test2;


CREATE TABLE test2(
  i INT
)ENGINE = InnoDB;

DELIMITER \\
CREATE PROCEDURE proc2()
BEGIN
  START TRANSACTION;
  INSERT INTO test2 VALUE(1);
  ROLLBACK;
END\\
DELIMITER ;


CALL proc2();

SHOW WARNINGS;

SELECT * FROM test2;

drop procedure proc2;

DROP TABLES t1,t2,total;
CREATE TABLE t1 (a INT AUTO_INCREMENT PRIMARY KEY, message CHAR(20)) ENGINE=MyISAM;
CREATE TABLE t2 (a INT AUTO_INCREMENT PRIMARY KEY, message CHAR(20)) ENGINE=MyISAM;
INSERT INTO t1 (message) VALUES ("Testing"),("table"),("t1");
INSERT INTO t2 (message) VALUES ("Testing"),("table"),("t2");
CREATE TABLE total(
a INT NOT NULL, 
message CHAR(20), KEY(a)
) ENGINE=MERGE UNION=(t1,t2) INSERT_METHOD=LAST;
SELECT * FROM total;

