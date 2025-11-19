--Part 1: Initial Setup
drop table if exists employees cascade;
drop table if exists departments cascade;
drop table if exists projects cascade;

create table departments (
    dept_id int primary key,
    dept_name varchar(50),
    location varchar(50)
);

create table employees (
    emp_id int primary key,
    emp_name varchar(50),
    salary decimal(10,2),
    dept_id int references departments(dept_id),
    email varchar(100),
    hire_date date
);

create table projects (
    project_id int primary key,
    project_name varchar(50),
    budget decimal(10,2),
    dept_id int references departments(dept_id)
);

insert into departments values
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C');

insert into employees values
(1, 'John Smith', 50000, 101, 'john@company.com', '2019-04-10'),
(2, 'Jane Doe', 60000, 102, 'jane@company.com', '2020-06-12'),
(3, 'Mike Johnson', 55000, 101, 'mike@company.com', '2021-01-20'),
(4, 'Sarah Williams', 65000, 103, 'sarah@company.com', '2018-03-15');

insert into projects values
(1, 'Website Redesign', 100000, 101),
(2, 'Training Program', 50000, 102),
(3, 'Budget Review', 75000, 103),
(4, 'Cloud Migration', 150000, 101);

--Part 2:
create index emp_salary_idx on employees(salary);
create index emp_dept_idx on employees(dept_id);
select indexname, indexdef from pg_indexes where tablename = 'employees';

--Part 3:
create index emp_dept_salary_idx on employees(dept_id, salary);
create index emp_salary_dept_idx on employees(salary, dept_id);

--Part 4:
create unique index emp_email_unique_idx on employees(email);
alter table employees add column phone varchar(20) unique;

--Part 5:
create index emp_salary_desc_idx on employees(salary desc);
create index proj_budget_nulls_first_idx on projects(budget nulls first);

--Part 6:
create index emp_name_lower_idx on employees(lower(emp_name));
create index emp_hire_year_idx on employees(extract(year from hire_date));

--Part 7:
alter index emp_salary_idx rename to employees_salary_index;
drop index emp_salary_dept_idx;
reindex index employees_salary_index;

--Part 8:
create index emp_high_salary_idx on employees(salary) where salary > 50000;
create index emp_join_idx on employees(dept_id);
create index emp_order_idx on employees(salary desc);

explain analyze
select e.emp_name, e.salary, d.dept_name
from employees e
join departments d on e.dept_id = d.dept_id
where e.salary > 50000
order by e.salary desc;

create index proj_high_budget_idx on projects(budget) where budget > 80000;

explain analyze
select * from employees
where extract(year from hire_date) = 2020;

--Part 9:
create index dept_name_hash_idx on departments using hash(dept_name);

--Part 10:
select relname as index_name,
       pg_size_pretty(pg_relation_size(indexrelid)) as index_size
from pg_stat_user_indexes
join pg_class on indexrelid = oid;

drop index if exists emp_dept_salary_idx;
drop index if exists emp_order_idx;
drop index if exists proj_high_budget_idx;

create view index_documentation as
select indexname, indexdef
from pg_indexes
where schemaname = 'public';