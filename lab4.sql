drop database if exists lab4;
create database lab4;
use lab4;

set global log_bin_trust_function_creators = 1 ;
SET SQL_SAFE_UPDATES = 0;
set foreign_key_checks=0;


drop table  studs;

create table studs
(
st_id int primary key auto_increment,
gender enum('girl', 'boy'),
st_name varchar(30), 
st_surname varchar(30), 
birth date,
st_speciality enum('км', 'веб', 'пед', 'эконом', 'конструктор', 'мобилки', 'проиводство', 'механики китай', 'механики'), 
st_form enum('бюджет', 'платка'), 
st_value float
);

select * from studs; #за каждый год в отдельную таблицу 

create table subjects
(
sub_id int primary key auto_increment, 
sub_name varchar(50), 
sub_teacher varchar(20), 
sub_hours int
);

create table exams
(
exam_id int primary key auto_increment,
ref_sub_id int, 
ref_st_id int, 
exam_date datetime, 
exam_mark int, 
constraint cn1 foreign key (ref_sub_id) references subjects(sub_id), 
constraint cn2 foreign key (ref_st_id) references studs(st_id)
);

select*from exams;

insert into studs
(gender, st_name, st_surname, birth, st_speciality, st_form, st_value)
values
('girl', 'Елена', 'Зразикова', '2002/02/07', 'км', 'бюджет', 155), 
('girl', 'Арина', 'Логвиненко', '2001/10/09', 'км', 'бюджет', 135), 
('girl', 'Светлана', 'Кирий', '2001/11/09', 'веб', 'бюджет', 155), 
('boy', 'Иван', 'Иванов', '2002/04/14', 'эконом', 'платка', 0), 
('boy', 'Николай', 'Николаев', '2001/12/21', 'пед', 'платка', 0), 
('boy', 'Сергей', 'Сергеев', '2001/07/02', 'конструктор', 'бюджет', 155);

select*from studs;




insert into subjects
(sub_name, sub_teacher, sub_hours)
values
('бд', 'Кушнеров', 30), 
('км', 'Василевич', 25), 
('прога', 'Политаев', 60), 
('геометрия', 'Базылев', 70),
('пса', 'Атрохов', 40), 
('матан', 'Бровка', 80);

alter table exams
add column tsession varchar(50);

insert into exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, tsession)
values
('1', '3', '2021/01/18', '3', 'winter');


alter table exams
drop column tsession;

/*insert into exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, tsession)
values
('1', '1', '2021/01/18', '8', 'winter'), 
('1', '2', '2021/01/18', '9', 'winter'), 
('1', '3', '2021/01/13', '10', 'winter'),
('2', '4', '2021/01/15', '4', 'winter'),
('2', '5', '2021/01/18', '2', 'winter'),
('2', '4', '2021/01/28', '8', 'winter'),
('3', '1', '2021/01/12', '8', 'winter'),
('3', '2', '2021/01/12', '6', 'winter'),
('3', '5', '2021/01/17', '3', 'winter'),
('3', '6', '2021/01/19', '2', 'winter'),
('4', '3', '2021/01/02', '5', 'winter'),
('4', '4', '2021/01/04', '10', 'winter'),
('4', '5', '2021/01/04', '9', 'winter'),
('4', '6', '2021/01/02', '9', 'winter'),
('5', '1', '2021/01/02', '10', 'winter'),
('5', '2', '2021/01/02', '5', 'winter'),
('5', '6', '2021/01/08', '8', 'winter'),
('6', '1', '2021/01/10', '6', 'winter'),
('6', '2', '2021/01/10', '9', 'winter'),
('6', '6', '2021/01/16', '5', 'winter');#зимняя

insert into exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, tsession)
values
('1', '1', '2021/06/18', '6', 'summer'), 
('1', '2', '2021/06/18', '3', 'summer'), 
('1', '3', '2021/06/13', '7', 'summer'),
('2', '4', '2021/06/15', '5', 'summer'),
('2', '5', '2021/06/18', '9', 'summer'),
('2', '4', '2021/06/28', '10', 'summer'),
('3', '1', '2021/06/12', '4', 'summer'),
('3', '2', '2021/06/12', '7', 'summer'),
('3', '5', '2021/06/17', '5', 'summer'),
('3', '6', '2021/06/19', '9', 'summer'),
('4', '3', '2021/06/02', '4', 'summer'),
('4', '4', '2021/06/04', '7', 'summer'),
('4', '5', '2021/06/04', '5', 'summer'),
('4', '6', '2021/06/02', '7', 'summer'),
('5', '1', '2021/06/02', '5', 'summer'),
('5', '2', '2021/06/02', '8', 'summer'),
('5', '6', '2021/06/08', '9', 'summer'),
('6', '1', '2021/06/10', '5', 'summer'),
('6', '2', '2021/06/10', '7', 'summer'),
('6', '6', '2021/06/16', '10', 'summer'); #летняя */


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



select * from studs;
select * from subjects;
select * from exams;

#Хранение информации о всех оценках студента в семестре.
#Хранение информации о посещаемости студента на каждом занятии. заменить на 0 1 не доаускает отметку на паре если его там не было

create table semester_grades
(
ref_st_id int, 
ref_sub_id int,
pair_date datetime, 
pair_attendance enum('1', '0'), 
pair_mark int, 
constraint cn111  foreign key (ref_st_id) references studs(st_id), 
constraint cn222 foreign key (ref_sub_id) references subjects(sub_id));

select * from semester_grades;


insert into semester_grades
(ref_st_id, ref_sub_id, pair_date, pair_attendance, pair_mark)
values
(1, 2, '2020/10/08', '0', 4),
(1, 2, '2020/10/09', '0', 4),
(1, 2, '2020/10/010', '0', 4),
(1, 2, '2020/10/11', '0', 4);

insert into semester_grades
(ref_st_id, ref_sub_id, pair_date, pair_attendance, pair_mark)
values
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

select * from semester_grades;

update semester_grades
set pair_mark = null
where pair_attendance = '0';

drop trigger check_mark;

DELIMITER //
create trigger check_mark before insert on semester_grades
for each row
begin
if  new.pair_attendance = '0' and new.pair_mark is not null
	then 
    signal sqlstate '45000'
	set message_text = 'Student was not present at class, he can t have a mark!';
end if;
end//
DELIMITER ;

insert into semester_grades
(ref_st_id, ref_sub_id, pair_date, pair_attendance, pair_mark)
values
(10, 1, '2020/11/08', '0', null);

select*from semester_grades;

# Хранение информации об общественной нагрузке и активности студента.

create table activity (
ref_st_id int primary key,
work_hours int,
event_hours int,
constraint cn111q foreign key (ref_st_id) references studs(st_id)
);
insert into activity
values
(1,4,6),
(2,3,6),
(3,2,6),
(4,7,10),
(5,3,14),
(6,6,15);

select * from activity;

#индекс который начисляется студенту за активность

alter table activity
add column activity_index int;

update activity
set activity_index = 2
where work_hours + event_hours >= 10;


update activity
set activity_index = 1
where work_hours + event_hours > 7 and work_hours + event_hours < 10;

update activity
set activity_index = 0
where work_hours + event_hours <= 7;




#Хранение информации о здоровье студента.

drop table if exists health;
create table health
(
st_id int,
health enum('+', '-'), 
constraint cn333 foreign key (st_id) references studs(st_id)
);

insert into health
(st_id, health)
values
(1, '+'), 
(2, '-'), 
(3, '+'), 
(4, '-'), 
(5, '+'),  
(6, '-');

select * from health;

#опции удаления и обновления связанных данных

alter table semester_grades
drop foreign key cn111;

alter table semester_grades
add constraint cn111 foreign key (ref_st_id)
references studs(st_id) on delete cascade;

delete from studs
where st_id = 3;

select * from studs;

#3.1. Процедура для повышения всех стипендий на некоторое количество процентов.

delimiter //
create procedure scholarship_increase()
begin 
  select st_value*1.5 from studs;
end //
delimiter ;

call scholarship_increase();

drop procedure scholarship_increase_2;

delimiter //
create procedure scholarship_increase_2(n int)
begin 
 update studs
 set st_value = st_value + st_value*(n/100);
end //
delimiter ;

call scholarship_increase_2(5);

select * from studs;

#3.2. Функция, вычисляющая среднюю оценку на экзамене у определённого преподавателя.

drop function mark_teacher;

set global log_bin_trust_function_creators = 1 ;

delimiter //
create function mark_teacher(teacher varchar(50))
returns float
begin
	declare avg_mark float;
	select avg(exam_mark) into avg_mark from exams, subjects
	where sub_id=ref_sub_id and subjects.sub_teacher=teacher;
	return avg_mark;
end//
delimiter ;

select mark_teacher('Кушнеров') as 'Средний балл';

#3.3. Процедура для начисления надбавок общественно активным студентам. Критерий начисления надбавок, должен быть привязан к некоторому числовому параметру.

drop procedure bonuses;

delimiter //
create procedure bonuses(amount float)
begin 
	declare id,h1,h2 int;
	declare is_end int default 0;
	declare studcur cursor for select ref_st_id, event_hours, work_hours from activity;    
	declare continue handler for not found set is_end=1;
    open studcur;
    curs: loop
		fetch studcur into id,h1,h2;
        if is_end then
			leave curs;
		end if;
        if h1 + h2 > 15 then
			update studs
            set st_value = st_value + amount
            where st_id = id;
		end if;
	end loop curs;
    close studcur;
select * from studs;
end//
delimiter ;

select * from activity;

call bonuses(15);

#3.4. Процедуры для вывода топ-5 самых успешных студентов факультета, топ-5 «двоечников», топ-5 самых активных. Результаты курсором записать в новые таблицы.

drop table top_best;
drop table top_worst;
drop table top_active;

create table top_best (
st_surname varchar(30),
st_avgmark float
);
 
create table top_worst (
st_surname varchar(30),
st_avgmark float
);

create table top_active (
st_surname varchar(30),
st_hours float
);

drop procedure cursortop5;


DELIMITER //
create procedure cursortop5()
begin 
	declare successful, unsuccessful, proactive varchar(30);
    declare avgmark1, avgmark2, hourr float;
	declare is_end int default 0;

	declare success cursor for 
         select  studs.st_surname as surname, marks.avgmark as s 
          from
			(
              select exams.ref_st_id as id, avg(exam_mark) as avgmark 
              from exams 
              group by exams.ref_st_id
			) as marks
		      inner join studs
			  on studs.st_id = marks.id
              order by s desc
              limit 5;
	
    	declare unsuccess cursor for 
         select  studs.st_surname as surname, marks.avgmark as s 
          from
			(
              select exams.ref_st_id as id, avg(exam_mark) as avgmark 
              from exams 
              group by exams.ref_st_id
			) as marks
		      inner join studs
			  on studs.st_id = marks.id
              order by s 
              limit 5;
		
        declare proactive cursor for 
         select  studs.st_surname as surname, avghour.avghour as avghourr 
          from
			(
              select activity.ref_st_id as id, avg(event_hours) as avghour
              from activity 
              group by activity.ref_st_id
			) as avghour
		      inner join studs
			  on studs.st_id = avghour.id
              order by avghourr 
              limit 5;
        
 
	declare continue handler for not found set is_end=1;
	
    open success;
	open unsuccess;
    open proactive;
    curs: loop
		fetch success into successful, avgmark1;
        fetch unsuccess into unsuccessful, avgmark2;
        fetch proactive into proactive, hourr;
        if is_end then
			leave curs;
		end if;
        insert into top_best values(successful, avgmark1);
        insert into top_worst values(unsuccessful, avgmark2);
        insert into top_active values(proactive, hourr);
	end loop curs;
    
	close success;
	close unsuccess;
    close proactive;
    
	select*from top_best;
	select*from top_worst;
	select*from top_active;

end //
DELIMITER ;
    
call cursortop5();

#3.5. Процедура для отчисления проблемных студентов. Подумайте о проверке условий отчисления.

create table dismissal_table
select ban.id, studs.st_name, studs.st_surname, ban.count_mark
from studs,
(
select studs.st_id as id, count(exam_mark) as count_mark
from exams
inner join studs
on studs.st_id = ref_st_id
where exam_mark < 4 
group by studs.st_id
having count_mark >= 1
) as  ban
where ban.id=studs.st_id;

select*from dismissal_table;

drop procedure if exists dismissal;

delimiter //
create procedure dismissal()
begin
    delete from  exams
    where exams.ref_st_id in (select id from dismissal_table);

   delete from   activity
   where activity.ref_st_id in (select id from dismissal_table);
    
   delete from  studs
   where studs.st_id in (select id from dismissal_table);

   delete from  health
   where health.st_id in (select id from dismissal_table);
   
   delete from  semester_grades
   where semester_grades.ref_st_id in (select id from dismissal_table);

select*from studs;
select*from semester_grades;
select*from health;
select*from activity;
select*from exams;

  end //
 delimiter ;
 
call diнаsmissal();

#!!! ДОДЕЛАТЬ 3.6. Функция вычисляющую самую популярную оценку на факультете (в группе).

DELIMITER //
create function popular_mark(groupp varchar(50))
returns int
begin
	declare most_popular, count_mark int;
    
	select pair_mark, COUNT(pair_mark) as amount into most_popular, count_mark
	from semester_grades
    inner join studs
    on studs.st_id = semester_grades.ref_st_id
    where studs.st_speciality = groupp
	group by pair_mark
	order by amount desc
	limit 1;
    
    return most_popular;
end//
DELIMITER ;

    select*from studs;

select popular_mark('эконом');



#3.7. Процедура для вычисления процента пропущенных занятий для студентов определённой группы.

 drop procedure if exists procpass;

 delimiter //
 create procedure procpass ( in group_st varchar(50))
 begin

select skip_pair.name, skip_pair.surname, (attendance_skip / attendance * 100)
from 
(
select st_name as name, st_surname as surname, count(pair_attendance) as attendance_skip from semester_grades
inner join studs
on semester_grades.ref_st_id = studs.st_id
where pair_attendance = '-' and st_speciality = group_st
group by name, surname
) as skip_pair
inner join
(
select st_name as name, st_surname as surname, count(pair_attendance) as attendance from semester_grades
inner join studs
on semester_grades.ref_st_id = studs.st_id
where  st_speciality = group_st
group by name, surname
) as all_pair
on skip_pair.name = all_pair.name;

 end // 
 delimiter ;

call procpass('км');

#3.8. Процедура для вычисления самых лояльных и предвзятых преподавателей на факультете

alter table subjects
add column IsLoyal enum('yes', 'no');
 
alter table subjects
add column  loyalty_index int;
 

drop procedure loyal_and_biased;

 delimiter //
 create procedure loyal_and_biased ()
 begin
 
select bla.teach, bla.avg_mark from
( select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark
from ( select sub_teacher as teacher, exam_mark as mark_exam
from exams inner join subjects on exams.ref_sub_id = subjects.sub_id
) as all_mark
group by teacher ) as bla where bla.avg_mark  <= 7;

select bla.teach, bla.avg_mark 
from ( select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark
from ( select sub_teacher as teacher, exam_mark as mark_exam from exams
inner join subjects on exams.ref_sub_id = subjects.sub_id ) as all_mark
group by teacher ) as bla where bla.avg_mark  > 7;


update  subjects set IsLoyal = 'no' where sub_teacher in (
select bla.teach from (
select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark from
(
select sub_teacher as teacher, exam_mark as mark_exam from exams
inner join subjects on exams.ref_sub_id = subjects.sub_id ) as all_mark
group by teacher ) as bla where bla.avg_mark  <= 7);

update  subjects set loyalty_index = -1 where sub_teacher in ( select bla.teach from
( select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark from
( select sub_teacher as teacher, exam_mark as mark_exam from exams inner join subjects on exams.ref_sub_id = subjects.sub_id ) as all_mark
group by teacher ) as bla
where bla.avg_mark  <= 7 );


update  subjects set IsLoyal = 'yes' where sub_teacher in ( select bla.teach from 
( select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark from
( select sub_teacher as teacher, exam_mark as mark_exam from exams inner join subjects on exams.ref_sub_id = subjects.sub_id ) as all_mark
group by teacher ) as bla where bla.avg_mark  > 7);


update  subjects set loyalty_index = 3 where sub_teacher in ( select bla.teach
from ( select all_mark.teacher as teach, avg(all_mark.mark_exam) as avg_mark from
( select sub_teacher as teacher, exam_mark as mark_exam from exams inner join subjects on exams.ref_sub_id = subjects.sub_id
) as all_mark
group by teacher ) as bla where bla.avg_mark  > 7 );


 end // 
 delimiter ;
 
 call loyal_and_biased();
 
 select*from subjects;
 


/* 3.9. Процедура для выдачи бонусов студентам. Принимаю на вход некоторый период времени
начисляет надбавку к стипендии студентам, родившимся в этот период. Чем старше
студент, тем больше надбавка */

drop procedure bonus;

delimiter //
create procedure bonus(date1 date, date2 date, plus int )
begin 
 update studs
 set st_value = st_value + plus*(to_days(current_date) - to_days(birth))/2000
 where birth > date1 and birth < date2;
end //
delimiter ;

call bonus('2002/02/05', '2002/04/26', 4);

select * from studs;

/*3.10. Модифицируйте функцию из 3.9 таким образом, чтобы студентам, родившимся в
определённый день недели надбавка выдавалась в трёхкратном размере.*/

drop procedure bonus_update;

delimiter //
create procedure bonus_update(date1 date, date2 date, date3 date, plus int)
begin 
 update studs
 set st_value = st_value + plus*(to_days(current_date) - to_days(birth))/2000
 where birth > date1 and birth < date2;

 update studs
 set st_value = st_value + 2*plus*(to_days(current_date) - to_days(birth))/2000
 where birth > date1 and birth < date2 and birth = date3;
end //
delimiter ;

call bonus_update('2002/02/05', '2002/04/26', '2002/02/07', 5);

select * from studs;

/*3.11. Процедура для вывода, ожидаемой оценки для студента на предстоящем экзамене. Ожидаемая оценка прогнозируется исходя из лояльности преподавателя, успешности
студента и любых других параметров по вашему желанию.*/

    drop procedure prediction;
    
delimiter //
create procedure prediction(in student_id int, in exam varchar(30))
begin
select studs.st_name, studs.st_surname, (attendance_table.main + loyalty.ndex + activitys.ndex) as prediction from studs,
(
select subjects.sub_name as sub, (attendance_skip / attendance * 100 / 10/ 2) as main
from 
(
select ref_sub_id, st_name as name, st_surname as surname, count(pair_attendance) as attendance_skip from semester_grades
inner join studs on semester_grades.ref_st_id = studs.st_id where pair_attendance = '+' and st_id = student_id
group by ref_sub_id, name, surname ) as skip_pair
inner join
( select ref_sub_id, st_name as name, st_surname as surname, count(pair_attendance) as attendance from semester_grades
inner join studs on semester_grades.ref_st_id = studs.st_id where  st_id = student_id
group by ref_sub_id, name, surname ) as all_pair
on skip_pair.name = all_pair.name, subjects
where all_pair.ref_sub_id = subjects.sub_id  and subjects.sub_name=exam group by sub, main  ) as attendance_table,
    (
       select sub_name, loyalty_index as ndex from subjects inner join exams on exams.ref_sub_id = subjects.sub_id   where sub_name = exam group by sub_name, ndex
    ) as loyalty,
    (
    select st_name, st_surname, activity_index as ndex from activity inner join studs on studs.st_id =  activity.ref_st_id where st_id = student_id
    ) as activitys
    where studs.st_id = student_id;
    
end//
delimiter ;

call prediction(1, 'прога');


select*from studs;

#4.1. Триггер для автоматического изменения размера стипендии в зависимости от успеваемости.

drop trigger scholarship;

 delimiter //
create trigger scholarship after insert on exams
for each row
begin
	update studs,
    (
		select st_id, st_name, st_surname, avg(exams.exam_mark) as avg_mark
        from exams
        inner join studs
        on studs.st_id  = exams.ref_st_id
        group by st_id, st_name, st_surname
    ) as avgm
    set studs.st_value = case
    when avgm.avg_mark >= 9 then 170
    when avgm.avg_mark >= 8 and avgm.avg_mark < 9 then 150
    when avgm.avg_mark >= 7 and avgm.avg_mark < 8 then 130
    else 100
	end
    where avgm.st_id = studs.st_id;
end//
delimiter ;


select st_name, st_surname, avg(exams.exam_mark) as avg_mark
from exams
inner join studs
on studs.st_id  = exams.ref_st_id
group by st_name, st_surname;


select*from studs;

#4.2. Триггер для автоматического снижения оплаты при успешной успеваемости.

alter table studs
add column price int;

update studs
set price = 2000
where st_form = 'платка';

select * from studs;

 delimiter //
create trigger payment after insert on exams
for each row
begin
	update studs,
    (
		select st_id, st_name, st_surname, avg(exams.exam_mark) as avg_mark
        from exams
        inner join studs
        on studs.st_id  = exams.ref_st_id
        group by st_id, st_name, st_surname
    ) as avgm
    set studs.price = case
    when avgm.avg_mark >= 9 then price-300 
    when avgm.avg_mark >= 8 and avgm.avg_mark < 9 then price-200 
    when avgm.avg_mark >= 7 and avgm.avg_mark < 8 then price-100 
    
	end
    where avgm.st_id = studs.st_id;
end//
delimiter ;

select*from studs;



#4.3. Проверочные триггеры для таблицы со студентами и предметами. На ваш вкус. Их можно придумать 100.

alter table studs
add column military_department enum('yes', 'no');

select*from studs;
drop trigger military_department;

delimiter //
create trigger military_department before insert on studs
for each row
begin
	case new.gender
      when 'boy' then
        set new.military_department = 'yes';
	  when 'girl' then 
        set new.military_department = 'no';
	end case;

end//
delimiter ;

alter table studs
add column group_number int;


delimiter //
create trigger group_number before insert on studs
for each row
begin
	case new.st_speciality
      when 'производство' then
        set new.group_number = 1;
	  when 'веб' then 
        set new.group_number = 2;
	  when 'педы' then
        set new.group_number = 3;
	  when 'конкструкторы' then 
        set new.group_number = 4;
	  when 'км' then
        set new.group_number = 5;
	  when 'экономы' then 
        set new.group_number = 6;
	  when 'механики' then
        set new.group_number = 7;
	  when 'механики китай' then 
        set new.group_number = 8;
	  when 'мобилки' then
        set new.group_number = 9;
        
	end case;

end//
delimiter ;

drop trigger tsession;


drop trigger tsession;

alter table exams
add column tssession varchar(50);

create table test (
	test bool
);

insert into test
	(test)
		values
	(0);

delimiter //
create trigger tsession after update on test
for each row
begin
    update exams,
    ( select exam_id as id, month(exam_date) as num from exams
    ) as monthh
    set exams.tssession = case
    when monthh.num = 6 then 'summer'
    else 'winter'
	end
    where monthh.id = exams.exam_id ;
    
end//
delimiter ;


update test
set test = 1;


select exam_id as id, month(exam_date) as num from exams;

select*from studs;


insert into studs
(gender, st_name, st_surname, birth, st_speciality, st_form, st_value)
values
('boy', 'Тимур', 'Чурко', '2001/08/30', 'мобилки', 'бюджет', 155);

insert into studs
(gender, st_name, st_surname, birth, st_speciality, st_form, st_value)
values
('girl', 'Катя', 'Лабун', '2001/10/23', 'веб', 'бюджет', 100);


#4.4. Триггер для автоматического перевода cтудента на следующий курс при успешной сессии.

select*from exams;


alter table studs
add column course int;

update studs
set course = 1;


drop trigger plus_one_year;

 delimiter //
create trigger plus_one_year after update on test
for each row
begin
	update studs,
    (
	select studs.st_id as stupid, exams.exam_mark from studs
	inner join exams
	on studs.st_id = exams.ref_st_id
	where exams.exam_mark >=  4
    ) as marks,
    ( select ref_st_id as id, tssession from exams where tssession = 'summer') as typee
    set studs.course = studs.course + 1
    where studs.st_id = marks.stupid
	and studs.course < 4 
    and studs.st_id = typee.id;
end//
delimiter ;

update test
set test = 1;

select*from studs;
        
#4.5. Триггер помечающий потенциально проблемных студентов специальным модификатором.



select*from studs;

alter table studs
add column ok enum('problem', 'ok');

update studs
set studs.ok = 'ok';

drop trigger problem_students;

DELIMITER //
create trigger problem_students after update on test
for each row
begin

	update studs
		set studs.ok = 'ok';
        
	update studs,
    (
       select skip_pair.st_id as id
      from 
      (
      select st_id, st_name as name, st_surname as surname, count(pair_attendance) as attendance_skip from semester_grades
      inner join studs
      on semester_grades.ref_st_id = studs.st_id
      where pair_attendance = '-' 
      group by st_id, name, surname
	  ) as skip_pair
	  inner join
      (
      select st_name as name, st_surname as surname, count(pair_attendance) as attendance from semester_grades
      inner join studs
      on semester_grades.ref_st_id = studs.st_id
      group by name, surname
      ) as all_pair
      on skip_pair.name = all_pair.name
      where (attendance_skip / attendance * 100)  > 50
    ) as pair_attendance,
    (
		select health.st_id as id
        from health
        where health.health = "-"
    ) as health
    set studs.ok = 'problem'
    where studs.st_id = pair_attendance.id
    or studs.st_id = health.id;
    
end//
DELIMITER ;


update test
set test = 1;

select * from studs;

#4.6. Триггер, не допускающий перевода на следующий курс студента с проблемами по линии здоровья.


drop trigger admission;

DELIMITER //
create trigger admission after update on test
for each row
begin
	update studs,
    (
		select health.st_id as id
        from health
        where health.health = "-"
    ) as t
    set studs.course = studs.course
    where studs.st_id = t.id;
end//
DELIMITER ;

update test
set test = 1;

select*from studs;

insert into studs
(gender, st_name, st_surname, birth, st_speciality, st_form, st_value, course)
values
('girl', 'Алина', 'Алиновна', '2001/01/07', 'механики', 'платка', null, 2 );