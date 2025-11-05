-- Part 1:

--Step 1.1:
create table employees (
    emp_id int primary key,
    emp_name varchar(50),
    dept_id int,
    salary decimal(10, 2)
);

create table departments (
    dept_id int primary key,
    dept_name varchar(50),
    location varchar (50)
);

create table projects (
    project_id int primary key,
    project_name varchar(50),
    dept_id int,
    budget decimal(10, 2)
);

--Step 1.2:
-- Insert data into employees
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);
-- Insert data into departments
INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');
-- Insert data into projects
INSERT INTO projects (project_id, project_name, dept_id,
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

--Part 2:

--Ex 2.1:
select e.emp_name, d.dept_name
from employees e, department d;

select e.emp_name, d.dept_name
from employees e 
inner join departments d on true;

--Ex 2.3:
select e.emp_name, p.project_name
from employees e cross join projects p;

--Part 3:

--Ex 3.1:
select e.emp_name, d.dept_name< d.location 
from employees e 
inner join departments d on e.dept_id = d.dept_id;

--Ex 3.2:
select emp_name, dept_name, location
from employees
inner join departments using (dept_id);

--Ex 3.3:
select emp_name, dept_name, location
from employees
natural inner join departments;

--Ex 3.4:
select e.emp_name, d.dept_name, p.project_name
from employees e
inner join departments d on e.dept_id = d.dept_id
inner join projects p on d.dept_id = p.dept_id;

--Part 4:

--Ex 4.1:
select e.emp_name, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e
left join departments d on e.dept_id = d.dept_id;

--Ex 4.2:
select emp_name, dept_id, dept_name
from employees
left join departments using (dept_id);

--Ex 4.3:
select e.emp_name, e.dept_id
from employees e
left join departments d on e.dept_id = d.dept_id
where d.dept_id is null;

--Ex 4.4:
select d.dept_name, count(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by employee_count desc;

--Part 5:

--Ex 5.1:
select e.emp_name, d.dept_name
from employees e
right join departments d on e.dept_id = d.dept_id;

--Ex 5.2:
select e.emp_name, d.dept_name
from departments d
left join employees e on d.dept_id = e.dept_id;

--Ex 5.3:
select d.dept_name, d.location
from employees e
right join departments d on e.dept_id = d.dept_id
where e.emp_id is null;

--Part 6:

--Ex 6.1:
select e.emp_name, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id;

--Ex 6.2:
select d.dept_name, p.project_name, p.budget
from departments d
full join projects p on d.dept_id = p.dept_id;

--Ex 6.3:
select 
    case 
        when e.emp_id is null then 'Department without employees'
        when d.dept_id is null then 'Employee without department'
        else 'Matched'
    end as record_status,
    e.emp_name,
    d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id
where e.emp_id is null or d.dept_id is null;

--Part 7:

--Ex 7.1:
select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id and d.location = 'Building A';

--Ex 7.2:
select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id
where d.location = 'Building A';

--Ex 7.3:
select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d on e.dept_id = d.dept_id and d.location = 'Building A';

select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d on e.dept_id = d.dept_id
where d.location = 'Building A';

--Part 8:

--Ex 8.1:
select d.dept_name, e.emp_name, e.salary, p.project_name, p.budget
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
order by d.dept_name, e.emp_name;

--Ex 8.2:
alter table employees add column manager_id int;

update employees set manager_id = 3 where emp_id = 1;
update employees set manager_id = 3 where emp_id = 2;
update employees set manager_id = null where emp_id = 3;
update employees set manager_id = 3 where emp_id = 4;
update employees set manager_id = 3 where emp_id = 5;

select e.emp_name as employee, m.emp_name as manager
from employees e
left join employees m on e.manager_id = m.emp_id;

--Ex 8.3:
select d.dept_name, avg(e.salary) as avg_salary
from departments d
inner join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 50000;

--Lab Questions:

--1. INNER JOIN shows only matching rows; LEFT JOIN shows all from the left table.
--2. Use CROSS JOIN to get all possible combinations (e.g., employees × projects).
--3. In OUTER JOIN, ON filters before join; WHERE filters after join (can remove NULLs).
--4. Result: 5 * 10 = 50 rows.
--5. NATURAL JOIN joins tables by all columns with the same name.
--6. Risk: unexpected joins if same column names exist.
--7. SELECT * FROM B RIGHT JOIN A ON A.id = B.id;
--8. Use FULL JOIN when you need all rows from both tables, matched or not.