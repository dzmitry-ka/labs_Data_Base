drop database laba5;
create database laba5;
use laba5;

set sql_safe_updates=0;
Set global log_bin_trust_function_creators =1 ;

create table operations 
(
op_id INT(11) primary key auto_increment,
op_type enum('transfer','withdrawal','replenishment') #перевод, снятие, пополнение
); 

create table person
(
person_id  int(11) primary key auto_increment,
person_name varchar(30),
person_surname varchar(30),
person_adress varchar(50),
person_status enum ('online','off'),
person_date date
);

create table accountt
(
    acc_type enum('1','2'),
    acc_balance double ,
    acc_number varchar(50) primary key ,
    acc_start_date datetime,
    acc_owner int(11) ,  
    constraint c3 foreign key(acc_owner) references person(person_id)
);

create table appointment 
(
   app_id INT(11) PRIMARY KEY AUTO_INCREMENT,
   app_op INT(11),
   app_sender varchar(50), #отправитель
   app_recipient varchar(50), #получатель
   app_time datetime,
   app_value double,
   app_contr_number double,
   constraint cn1 foreign key(app_op) references operations(op_id),
   constraint cn2 foreign key(app_sender) references accountt(acc_number) 
);

insert into person
(person_name , person_surname, person_adress, person_status, person_date )
values
('Елена ', 'Зразикова', 'Одоевского 18-3-28', 'online', '2020-12-13'),
('Арина ', 'Логвиненко', 'Пушкина 26-368', 'off', '2020-11-29'),
('Светлана ', 'Кирий', 'Пономаренко-54-13', 'off', '2020-12-10');

insert into operations
(op_type)
values
('transfer'), #перевод
('withdrawal'), #снятие
('replenishment'); #пополнение


insert into accountt
(acc_type, acc_balance,acc_number,acc_start_date, acc_owner)
values
('1', 1500,'9475 3943 2954 2344','2017-07-21', '1'),
('2', 2000, '1943 5049 1234 0043','2018-12-03', '2'),
('2', 1700, '2535 2546 1254 2646','2019-03-13', '3' );


select * from person;
select * from operations;
select * from accountt;
select * from appointment;

#1.1. Доработайте транзакцию для перевода денежных средств из примера 2. Выполните недостающие проверки. (можем уйти в минус или положить на счет отр сумму)

drop procedure if exists transfer; 
delimiter ;;
create procedure transfer (in sender varchar(50), in rec varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;

update accountt
set acc_balance=acc_balance-summ
where acc_number=sender and acc_balance>=summ
;
if row_count()>0
	then 
    update accountt
    set acc_balance=acc_balance+summ
	where acc_number=rec;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(1,sender,rec,now(),summ,rand(10));
		commit;
	else rollback;
	end if;

else rollback;

end if;

end ;;

delimiter ;

call transfer( '9475 3943 2954 2344', '1943 5049 1234 0043', -120);

select * from accountt;
select * from appointment;

select cast(aes_decrypt(app_sender, 'lab5') as char), cast(aes_decrypt(app_recipient, 'lab5') as char) from appointment; 

#1.2. Создайте аналогичные транзактные методы для пополнения счёта и снятия средств со счёта.

drop procedure replenishment;

delimiter ;;
create procedure replenishment(in person varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;


update accountt
set acc_balance=acc_balance+summ
where acc_number=person 
;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(3,person,person,now(),summ,rand(10));
		commit;
	else rollback;

end if;

end ;;

delimiter ;

call replenishment('2535 2546 1254 2646', 1500);

select * from accountt;
select * from appointment;

drop procedure withdrawal;

delimiter ;;
create procedure withdrawal(in person varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;


update accountt
set acc_balance=acc_balance-summ
where acc_number=person and acc_balance>=summ
;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(2,person,person,now(),summ,rand(10));
		commit;
	else rollback;

end if;

end ;;

delimiter ;

call withdrawal('2535 2546 1254 2646', 2900);


#1.3. Создайте аналогичный образ bankDB, в котором некоторые проверки из транзакций вынесены в триггеры.


drop procedure withdrawal2;

delimiter ;;
create procedure withdrawal2(in person varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;

update accountt
set acc_balance=acc_balance-summ
where acc_number=person
;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(2,person,person,now(),summ,rand(10));
		commit;
	else rollback;

end if;
    

end ;;

delimiter ;



drop trigger if exists checkout;
delimiter // 
create trigger checkout before update on accountt
for each row
begin
if new.acc_balance<0 
	then 
    signal sqlstate '45000'
	set message_text = 'there is not enough money!';
    
end if;

end//
delimiter ; 


select * from accountt;
select * from appointment;

call replenishment('2535 2546 1254 2646', 1500);

# ДОДЕЛАТЬ!!!!! 1.4. Основные данные счёта должны хранится в зашифрованном виде. Произведите шифрование. Переработайте основные транзакции под новую модель хранения данных.

alter table person
modify person_name varbinary(50);

alter table person
modify person_surname varbinary(50);

update person 
set person_name = aes_encrypt(person_name, 'laba5');

update person 
set person_surname = aes_encrypt(person_surname, 'laba5');

select * from person;

select cast(aes_decrypt(person_name, 'laba5') as char) from person;

select cast(aes_decrypt(person_surname, 'laba5') as char) from person;

alter table person
modify person_adress varbinary(50);

update person 
set person_adress=aes_encrypt(person_adress, 'laba5');

select * from  person; 

select cast(aes_decrypt(person_surname, 'laba5') as char), cast(aes_decrypt(person_name, 'laba5') as char),  cast(aes_decrypt(person_adress, 'laba5') as char) from  person; 

alter table appointment
drop foreign key cn2;



alter table accountt
modify acc_number varbinary(50);

alter table appointment
modify app_sender varbinary(50);

alter table appointment
modify app_recipient varbinary(50);



alter table appointment
add constraint cn2 foreign key (app_sender) references accountt(acc_number)  on update cascade;


update accountt 
set acc_number=aes_encrypt(acc_number, 'laba5');

update appointment 
set app_recipient=aes_encrypt(app_recipient, 'laba5');


select*from appointment;

select cast(aes_decrypt(app_sender, 'laba5') as char) from  appointment; 

 #перевод

drop procedure if exists transfe3;
delimiter ;;
create procedure transfe3(in sender varchar(50), in rec varchar(50), in summ float)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;

update accountt
set acc_balance=acc_balance-summ
where cast(aes_decrypt(acc_number, 'laba5') as char)=sender;
if row_count()>0
	then 
    update accountt
    set acc_balance=acc_balance+summ
	where cast(aes_decrypt(acc_number, 'laba5') as char) =rec ;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(1,aes_encrypt(sender, 'laba5'),aes_encrypt(rec, 'laba5'),now(),summ,rand(10));
		commit;
	else rollback;
	end if;

else rollback;

end if;

end ;;

delimiter ;

select*from accountt;

call transfe3( '2535 2546 1254 2646', '1943 5049 1234 0043', 800);

#пополнение 

delimiter ;;
create procedure replenishment2(in person varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;

update accountt
set acc_balance=acc_balance+summ
where cast(aes_decrypt(acc_number, 'laba5') as char)=person 
;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(3,aes_encrypt(person, 'laba5'),aes_encrypt(person, 'laba5'),now(),summ,rand(10));
		commit;
	else rollback;

end if;

end ;;

delimiter ;

call replenishment2( '2535 2546 1254 2646', 123);

select * from appointment;

#снятие


select*from accountt;

drop procedure withdrawal2_2;
delimiter ;;
create procedure withdrawal2_2(in person varchar(50), in summ double)
begin 

start transaction;

if summ<0 
	then 
    signal sqlstate '45000'
	set message_text = 'You cannot send a negative sum of money!';
end if;

update accountt
set acc_balance=acc_balance-summ
where  cast(aes_decrypt(acc_number, 'laba5') as char)=person
;
    if row_count()>0
		then 
		insert into appointment 
		(app_op, app_sender, app_recipient, app_time, app_value , app_contr_number)
		values 
		(2,aes_encrypt(person, 'laba5'),aes_encrypt(person, 'laba5'),now(),summ,rand(10));
		commit;
	else rollback;

end if;

end ;;

delimiter ;

call withdrawal2_2( '2535 2546 1254 2646', 100);

select*from accountt;



#1.5. Создайте представление для отображения истории счёта, конкретного пользователя за определённый период.

drop view time_account;

create view time_account as
select *  from appointment
where  (app_sender='9475 3943 2954 2344' or app_recipient='9475 3943 2954 2344')
and  (app_time between  '2019-12-19' and  '2020-12-31' );

select * from time_account;

#1.6. Добавьте в вашу БД отдельную функциональность с кредитами пользователя.

drop table if exists credits;
create table credits
(
credits_id int primary key auto_increment,
person_id int, 
credit_summa float, #кредитный 
credit_startdate datetime,
credit_period int, #месяцы
credit_stavka float,
constraint cn100 foreign key(person_id) references person(person_id)
);

insert into credits
(person_id, credit_summa, credit_startdate, credit_period, credit_stavka)
values
(1, 1000, '2016/08/22', 24, 0.15),
(1, 3500, '2019/01/01', 12, 0.12), 
(2, 5000, '2017/09/18', 30, 0.1);

select * from credits;

/* ДОДЕЛАТЬ!!! 1.7. Реализуйте хранимые процедуры для получения кредитной истории, получения и
пошагового погашения кредита с различным типом процентных ставок в транзактном
режиме. */

drop procedure credit_history ;

 delimiter ;;
 create procedure credit_history ( in per_id int)
 begin
 
 select person_id as code, credit_summa, credit_startdate, credit_period, credit_stavka,
row_number() over(partition by person_id) as row_num
from credits
where person_id = per_id;

  end ;;

 end // 
 delimiter ;
 
 call credit_history(1);
 
  select person_id as code, credit_summa, credit_startdate, credit_period,
row_number() over(partition by person_id) as row_num
from credits
where person_id = 1;
 
 

select*from credits;

alter table credits
add column outstanding float after credit_summa;

update credits
set outstanding = credit_summa*(1+credit_stavka);

select*from credits;

drop procedure if exists repayment2; 
delimiter ;;
create procedure repayment2(in creadit_id int, in money float)
begin 

start transaction;

if money < (select outstanding/credit_period from credits where credits_id = creadit_id)
  then
    signal sqlstate '45000'
	set message_text = 'You have to pay more!';
end if;

update credits
set credit_summa=credit_summa*(1+credit_stavka)-money
where credits_id=creadit_id;

end ;;
delimiter ;

call repayment2(2, 327);

select*from credits;
