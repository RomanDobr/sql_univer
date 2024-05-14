Sql дз Университет
(Нужны все скрипты создания БД, схем, таблиц)
Создаем схему Инженерно Экономического университета
Этап №1 Создание схемы. Определить самостоятельно типы данных для каждого поля(колонки). Самостоятельно определить что является primary key и foreign key.
1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения
2. Создать таблицу с курсами: id, номер курса, id факультета
3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса

Этап №2 Заполнение данными:
1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
2. Создать 1 курс на Инженерном факультете: 1 курс
3. Создать 2 курса на экономическом факультете: 1, 4 курс
4. Создать 5 учеников:
Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
Иванов Иван Иваныч, 1 курс инженерного факультета, частник
Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
Младич Настасья (без отчества), 1 курс экономического факультета, частник


Этап №3 Выборка данных. Необходимо написать sql запросы :
1. Вывести всех студентов, кто платит больше 30_000.
2. Перевести всех студентов Петровых на 1 курс экономического факультета.
3. Вывести всех студентов без отчества или фамилии.
4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван".
5. Удалить все записи из всех таблиц.




CREATE DATABASE univer
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE SCHEMA IF NOT EXISTS engineering_economic_university
AUTHORIZATION postgres;

-- Этап №1 Создание схемы. Определить самостоятельно типы данных для каждого поля(колонки). Самостоятельно определить что является primary key и foreign key.

-- 1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения
create table engineering_economic_university.faculty (id int primary key, name_faculty varchar(100), price numeric(7, 2));

-- 2. Создать таблицу с курсами: id, номер курса, id факультета
create table engineering_economic_university.course (id int primary key, number_course int,
													 id_faculty int REFERENCES engineering_economic_university.faculty(id));
													 
-- 3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса
create table engineering_economic_university.list (id int primary key, name varchar(100), 
													surname varchar(100), 
													patronymic varchar(100),
												   form_of_payment varchar(100),
												   id_cource int References engineering_economic_university.course(id));

-- Этап №2 Заполнение данными:

-- 1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
insert INTO engineering_economic_university.faculty values (1, 'инженерный', 30000);
insert INTO engineering_economic_university.faculty values (2, 'экономический', 49000);

-- 2. Создать 1 курс на Инженерном факультете: 1 курс
insert INTO engineering_economic_university.course values (1, 1, 1);

-- 3. Создать 2 курса на экономическом факультете: 1, 4 курс
insert INTO engineering_economic_university.course values (2, 1, 2);
insert INTO engineering_economic_university.course values (3, 4, 2);

-- 4. Создать 5 учеников:
-- Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
-- Иванов Иван Иваныч, 1 курс инженерного факультета, частник
-- Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
-- Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
-- Младич Настасья (без отчества), 1 курс экономического факультета, частник
											   
insert INTO engineering_economic_university.list values (1, 'Петров', 'Петр', 'Петрович', 'бюджетник', 1);
insert INTO engineering_economic_university.list values (2, 'Иванов', 'Иван', 'Иваныч', 'частник', 1);
insert INTO engineering_economic_university.list values (3, 'Михно', 'Сергей', 'Иваныч', 'бюджетник', 3);
insert INTO engineering_economic_university.list values (4, 'Стоцкая', 'Ирина', 'Юрьевна', 'частник', 3);
insert INTO engineering_economic_university.list values (5, 'Младич', 'Настасья', null, 'частник', 2);

-- Этап №3 Выборка данных. Необходимо написать sql запросы :

-- 1. Вывести всех студентов, кто платит больше 30_000.
select grp.name, grp.surname, grp.patronymic
from engineering_economic_university.list grp 
				Join engineering_economic_university.course crs on grp.id_cource = crs.id
				Join engineering_economic_university.faculty fty on fty.id = crs.id_faculty
where fty.price > 30000;				

-- 2. Перевести всех студентов Петровых на 1 курс экономического факультета.
Update engineering_economic_university.list Set id_cource = 2
where list.name = 'Петров';

-- 3. Вывести всех студентов без отчества или фамилии
Select list.name, list.surname, list.patronymic
From engineering_economic_university.list
Where (list.surname is null) OR (list.patronymic is null);

-- 4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван".
Select list.name, list.surname, list.patronymic
From engineering_economic_university.list
Where (list."name" like '%ван%') OR (list.surname like '%ван%') OR (list.patronymic like '%ван%');

-- 5. Удалить все записи из всех таблиц.
Delete From engineering_economic_university.list;
Delete From engineering_economic_university.course;
Delete From engineering_economic_university.faculty;

